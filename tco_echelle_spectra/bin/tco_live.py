#!/usr/bin/env python3
"""Live FITS/HDR support for the TCO echelle DaCHS resource.

The source FITS and its neighbouring ``.fits.hdr`` sidecar are authoritative.
No metadata snapshot and no persistent download copy are required.
"""

from __future__ import annotations

import hashlib
import os
from pathlib import Path
import shutil
import tempfile
import warnings

import numpy as np
from astropy import units as u
from astropy.coordinates import Angle
from astropy.io import fits
from astropy.time import Time


STRUCTURAL_KEYS = (
    "SIMPLE", "BITPIX", "NAXIS", "GROUPS", "PCOUNT", "GCOUNT",
    "BSCALE", "BZERO", "BLANK",
)


def _digest_tail(path: Path, offset: int) -> str:
    with path.open("rb") as stream:
        stream.seek(offset)
        return hashlib.file_digest(stream, "sha256").hexdigest()


def _headers_for(source: Path):
    """Return original and authoritative sidecar headers after validation."""
    source = source.resolve(strict=True)
    sidecar = Path(str(source) + ".hdr")
    if not sidecar.is_file():
        raise FileNotFoundError(f"Missing HDR sidecar: {sidecar}")

    repaired = []
    with fits.open(source, memmap=False, do_not_scale_image_data=True) as hdus:
        original = hdus[0].header.copy()
        data_offset = hdus[0].fileinfo()["datLoc"]

    for card in original.cards:
        try:
            card.value
        except fits.VerifyError:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                card.verify("fix")
            repaired.append(card.keyword)

    header = fits.Header.fromtextfile(sidecar)
    keys = list(STRUCTURAL_KEYS)
    keys.extend(f"NAXIS{index}" for index in range(1, int(original["NAXIS"]) + 1))
    for key in keys:
        if original.get(key) != header.get(key):
            raise ValueError(f"{source}: HDR structural/scaling mismatch for {key}")

    return source, sidecar, original, header, data_offset, repaired


def read_metadata(source: Path, root: Path) -> dict:
    """Build one DaCHS input row directly from a FITS/HDR pair."""
    source, sidecar, original, header, data_offset, repaired = _headers_for(source)

    if header.get("NAXIS") != 1:
        raise ValueError(f"Expected one-dimensional spectrum: {source}")
    if header.get("DC-FLAG", 0) != 0 or str(header.get("CTYPE1", "")).strip() != "LINEAR":
        raise ValueError(f"Unsupported spectral axis: {source}")
    if "units=angstrom" not in str(header.get("WAT1_001", "")).lower():
        raise ValueError(f"Unconfirmed wavelength unit: {source}")

    n = int(header["NAXIS1"])
    crval = float(header["CRVAL1"])
    crpix = float(header["CRPIX1"])
    delta = float(header["CDELT1"])
    if not np.isfinite([crval, crpix, delta]).all() or delta <= 0:
        raise ValueError(f"Invalid spectral WCS: {source}")
    wave_min = (crval + (1 - crpix) * delta) * 1e-10
    wave_max = (crval + (n - crpix) * delta) * 1e-10

    target = str(header.get("OBJECT") or header.get("OBJNAME") or "").strip()
    target_source = "HDR sidecar"
    if not target:
        target = source.name.split("_")[0]
        target_source = "filename prefix (blank OBJECT/OBJNAME)"

    raw_ra = str(header.get("RA", ""))
    raw_dec = str(header.get("DEC", ""))
    if "RA_ICRS" in header and "DEC_ICRS" in header:
        ra = float(header["RA_ICRS"])
        dec = float(header["DEC_ICRS"])
        coordinate_status = str(header.get("COORDSRC", "HDR sidecar ICRS coordinates"))
    else:
        try:
            ra = float(Angle(header["RA"], unit=u.hourangle).degree)
            dec = float(Angle(header["DEC"], unit=u.deg).degree)
        except (KeyError, TypeError, ValueError) as exc:
            raise ValueError(f"Unresolved coordinate in {sidecar}: {exc}") from exc
        coordinate_status = "HDR position; RA interpreted as hours"

    if not np.isfinite([ra, dec]).all() or not (0 <= ra < 360 and -90 <= dec <= 90):
        raise ValueError(f"Coordinate out of range in {sidecar}")

    exposure = header.get("EXPTIME", header.get("EXPOSURE"))
    exposure = float(exposure) if exposure is not None else None
    if exposure is not None and (not np.isfinite(exposure) or exposure < 0):
        raise ValueError(f"Invalid exposure in {sidecar}")

    serialized = _download_header(header)
    merged_size = len(serialized) + source.stat().st_size - data_offset

    row = dict(
        target=target,
        target_source=target_source,
        ra=ra,
        dec=dec,
        raw_ra=raw_ra,
        raw_dec=raw_dec,
        coordinate_status=coordinate_status,
        repaired_cards=",".join(repaired),
        mjd=float(Time(header["DATE-OBS"], format="isot", scale="utc").mjd),
        date_obs=header["DATE-OBS"],
        n=n,
        wave_min=wave_min,
        wave_max=wave_max,
        exposure=exposure,
        origfile=source.name,
        puborg=str(header.get("PUBORG", "KazVO")),
        dataorig=str(header.get("DATAORIG", "external")),
        observer=header.get("OBSERVER"),
        telescope=header.get("TELESCOP"),
        instrument=header.get("INSTRUME"),
        camera=header.get("CAMERA"),
        detnam=header.get("DETNAM"),
        bunit=str(header.get("BUNIT", "relative")),
        fluxcal=str(header.get("FLUXCAL", "RELATIVE")),
        cosmicr=header.get("COSMICR"),
        specrp=float(header.get("SPECRP", 12000)),
        calib_level=2,
        wavecal=True,
        merged_size=merged_size,
    )
    for column, key in (
        ("norm", "NORM"), ("biascor", "BIASCOR"),
        ("darkcor", "DARKCOR"), ("bpixcor", "BPIXCOR"),
        ("flatcor", "FLATCOR"), ("tellcor", "TELLCOR"),
        ("helcor", "HELCOR"),
    ):
        value = header.get(key)
        if not isinstance(value, bool):
            raise ValueError(f"Missing boolean {key} in {sidecar}")
        row[column] = value
    return row


def _download_header(header: fits.Header) -> bytes:
    header = header.copy()
    for key in ("CHECKSUM", "DATASUM"):
        header.remove(key, remove_all=True, ignore_missing=True)
    return header.tostring(sep="", endcard=True, padding=True).encode("ascii")


def make_temporary_fits(source: Path) -> Path:
    """Build a merged FITS in /tmp; DaCHS TemporaryFile deletes it."""
    source, sidecar, original, header, data_offset, repaired = _headers_for(source)
    serialized = _download_header(header)
    fd, temporary_name = tempfile.mkstemp(prefix="tco-echelle-", suffix=".fits")
    temporary = Path(temporary_name)
    try:
        with os.fdopen(fd, "wb") as output, source.open("rb") as incoming:
            output.write(serialized)
            incoming.seek(data_offset)
            shutil.copyfileobj(incoming, output)
            output.flush()
            os.fsync(output.fileno())

        with fits.open(temporary, memmap=False, do_not_scale_image_data=True) as hdus:
            hdus.verify("exception")
            new_offset = hdus[0].fileinfo()["datLoc"]
            expected = fits.Header.fromtextfile(sidecar)
            for key in ("CHECKSUM", "DATASUM"):
                expected.remove(key, remove_all=True, ignore_missing=True)
            if hdus[0].header.tostring() != expected.tostring():
                raise ValueError(f"{source}: temporary FITS header differs from HDR")
        if _digest_tail(source, data_offset) != _digest_tail(temporary, new_offset):
            raise ValueError(f"{source}: temporary FITS data bytes changed")
        os.chmod(temporary, 0o644)
        return temporary
    except Exception:
        temporary.unlink(missing_ok=True)
        raise


def ensure_previews(root: Path, preview_dir: Path) -> int:
    """Create only missing spectral PNG previews using DaCHS' plot helper."""
    try:
        from gavo.helpers.processing import OneDPreviewMaker as PreviewPlotter
    except ImportError:  # DaCHS 2.11
        from gavo.helpers.processing import SpectralPreviewMaker as PreviewPlotter

    preview_dir.mkdir(parents=True, exist_ok=True)
    created = 0
    for source in sorted(root.glob("*/*/reduced/*.fits")):
        destination = preview_dir / f"{source.name}.png"
        if destination.is_file():
            continue
        with fits.open(source, memmap=False) as hdus:
            flux = np.asarray(hdus[0].data, dtype=float)
            header = hdus[0].header
        if flux.ndim != 1:
            raise ValueError(f"Expected one-dimensional spectrum: {source}")
        crval = float(header["CRVAL1"])
        crpix = float(header["CRPIX1"])
        delta = float(header["CDELT1"])
        points = [
            ((crval + (index + 1 - crpix) * delta) * 1e-10, float(value))
            for index, value in enumerate(flux)
        ]
        payload = PreviewPlotter.get2DPlot(
            points, linear=False, connectPoints=True)
        fd, temporary_name = tempfile.mkstemp(prefix=".preview-", dir=preview_dir)
        temporary = Path(temporary_name)
        try:
            with os.fdopen(fd, "wb") as output:
                output.write(payload)
                output.flush()
                os.fsync(output.fileno())
            os.chmod(temporary, 0o664)
            os.replace(temporary, destination)
        finally:
            temporary.unlink(missing_ok=True)
        created += 1
    return created
