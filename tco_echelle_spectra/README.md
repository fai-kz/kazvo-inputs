# TCO Echelle Spectral Archive

Public service host: **lark**, DaCHS 2.13.
Preparation host: **lark-obs**, DaCHS 2.11 (its HTTP daemon was inactive).

- Web: https://dachs.fai.kz/tco_echelle_spectra/q/web/form
- SSA: https://dachs.fai.kz/tco_echelle_spectra/q/ssa/ssap.xml
- DataLink: https://dachs.fai.kz/tco_echelle_spectra/q/sdl/dlmeta
- TAP table: `tco_echelle_spectra.data`
- Production descriptor: `/var/gavo/inputs/tco_echelle_spectra/q.rd` on **lark**.
- Preparation package: `/home/ildana/obs_data_codes/tco_echelle_service_20261022` on **lark-obs**.

The root-owned example descriptor at `/var/gavo/inputs/tco_echelle_spectra/q.rd`
on lark-obs was not overwritten; use the preparation package for that host.
No import/publication was performed on lark-obs. The public deployment was
performed on lark, which has access to the same shared source spectra.

## Authoritative inputs

905 spectra are linked from
`/var/gavo/inputs/observations/others/tco/spectra_echelle/targets`.
The resource's `data` entry is a symlink; no source FITS copies were created for
publication. Existing hot-supergiant resource and its 512 rows were preserved.

The user's `/home/ildana/obs_data_codes/make_hdr_tco.py` on lark-obs was updated
with in-memory RA/DEC quote repair, an explicit input path, a dry-run option,
macOS metadata filtering and atomic sidecar writes. It generated 324 new HDR
files and updated 513 existing HDR files. All 837 original FITS SHA256 hashes
remained unchanged. The prior HDR files and script are backed up under
`/home/ildana/obs_data_codes/backups/tco-hdr-20261022T120748Z`.

Numeric source RA values are hours, as established by repeated targets with
matching sexagesimal/numeric values. Declinations are degrees. 308 original
files require coordinate-card quote repair in memory. Syntax repair does not
change the original coordinate values.

90 spectra belonging to seven targets had inconsistent or invalid positions:
HD45314, HD7902, HD14542, HD14322, HD9311, BS2839 and HD58131. These now use
SIMBAD ICRS positions from CDS Sesame queried on 2026-10-22. Original RA/DEC
cards remain; RA_ICRS, DEC_ICRS, COORDSRC and SIMBADID were added to HDR sidecars.
BS2839 was resolved as HR2839. Full resolver XML is preserved in coordinates.json.
Before-correction sidecars are backed up in
`/home/ildana/obs_data_codes/backups/tco-coordinates-20261022T121835Z.tar.gz`.
Two blank target names use filename prefixes, explicitly recorded in the table.

## Metadata and service behavior

The source FITS and its adjacent `.fits.hdr` file are the only authoritative
inputs. During `dachs imp`, `bin/tco_live.py` reads the linear IRAF WCS,
exposure, reduction flags, object name and reviewed coordinates directly from
the sidecar. There is no `metadata.json` snapshot to refresh.

For a download request, DaCHS combines the immutable source data bytes with the
current HDR header in a temporary FITS file. It verifies that the data payload
is byte-identical and deletes the temporary file after the HTTP response.
There is no persistent `downloads/` tree.

Previews plot original wavelength/flux samples without resampling or smoothing.
DaCHS creates only missing PNGs automatically after a successful import. The
PNG cache remains on disk because DaCHS' generic `AUTO` preview does not render
one-dimensional spectra on demand.
Relative flux is not presented as absolute calibrated flux or normalized flux.
The inherited telescope-aperture diameter is not used as an angular sky footprint.

The new schema is `tco_echelle_spectra`; no tables from other collections were
modified. The original example's whitelist and insertion into an SSA view were
removed. Standard publisher dataset IDs and actual FITS sizes are supplied.
SSA and the web service were published through `dachs pub`.

## Historical verification (2026-10-22)

- Header repair tests: 3 passed locally; FITS originals unchanged.
- Descriptor pre-publication validation passed on DaCHS 2.11 and 2.13.
- All 837 metadata rows mapped, with unique dataset IDs and valid wavelengths.
- 837 FITS hashes, 837 HDR hashes and 837 PNG signatures verified on production.
- Database counts: raw_data=837, SSA view=837, dc.products=837, ObsCore=837.
- Existing hot-supergiant view still contains 512 rows.
- Both embedded SSA regression tests passed.
- Public HTTPS and localhost checks passed for full SSA query, original FITS
  SHA256, PNG delivery, DataLink, SDM VOTable, wavelength cutout and web form.
- Public TAP query returned 837; corrected HD45314 positional query returned 73.
- Public SODA FITS reformatting returned a readable two-HDU FITS product.
- Older server Astropy emits E02 warnings on the standard interval BAND
  descriptor's scalar MIN/MAX bounds. Public responses parse without warnings
  in Astropy 8; spectral extraction/cutout tests pass in both environments.

## Updating the collection

On lark-obs, run the HDR generator with an explicit source directory. Use
`--dry-run` first for a new batch and `--only-missing` when existing reviewed
sidecars must not be rewritten. The generator preserves existing
RA_ICRS/DEC_ICRS correction cards.

Then, on lark, run:

```sh
cd /var/gavo/inputs
dachs val -p tco_echelle_spectra/q
dachs imp tco_echelle_spectra/q
dachs pub tco_echelle_spectra/q
dachs test -v tco_echelle_spectra/q
```

Import reads FITS/HDR pairs live and generates missing previews. Update the
embedded regression count only when the intentionally published inventory
changes.

## Preview recovery

Normal imports create missing previews automatically. PNG files are generated
locally and ignored by Git. If the cache is lost, rerunning `dachs imp` rebuilds
the missing PNGs without changing the FITS/HDR sources.
