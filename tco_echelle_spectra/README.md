# TCO Echelle Spectral Archive — published 2026-10-22

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

## Source integrity and HDR preparation

837 spectra are linked from
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

`bin/prepare_metadata.py` reads the original linear IRAF WCS, including CRPIX1,
and exposure from FITS; it reads reduction flags and catalog positions from
HDR sidecars. The collection-wide reduction flags in the user's HDR generator
are preserved as supplied metadata, not inferred independently from pixels.
The service reads the reviewed metadata.json snapshot and serves original FITS.
Previews plot original wavelength/flux samples without resampling or smoothing.
Relative flux is not presented as absolute calibrated flux or normalized flux.
The inherited telescope-aperture diameter is not used as an angular sky footprint.

The new schema is `tco_echelle_spectra`; no tables from other collections were
modified. The original example's whitelist and insertion into an SSA view were
removed. Standard publisher dataset IDs and actual FITS sizes are supplied.
SSA and the web service were published through `dachs pub`.

## Verification completed

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

## Subsequent updates

On lark-obs, run the HDR generator with an explicit source directory, first
with `--dry-run`. It preserves existing RA_ICRS/DEC_ICRS correction cards.
Review and resolve any new coordinate conflicts before metadata preparation.
On lark, run `bin/prepare_metadata.py SOURCE RESOURCE --previews`, then
`dachs val -p tco_echelle_spectra/q`, `dachs imp tco_echelle_spectra/q`,
`dachs pub tco_echelle_spectra/q` and live verification. The embedded regression
count (837) must be updated when the intentionally published inventory changes.
Do not use the old copied helpers on lark-obs: they target tco_hot_supergiants.
