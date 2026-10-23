# FAI Assy-Turgen echelle archive

One archive record per original multispec FITS; currently 8 files, each with
33 orders and 1374 samples per order. No merging, rebinning, extraction, or
source-file modification is performed by this service.

The descriptor reads ../observations/assy/zeiss1000/echell/*.fits directly.
EXPTIME supplies exposure duration; EXPOSURE is retained as a separate provenance
column. DATE-OBS supplies the observation date rather than the filename date.
Linear IRAF WAT2 solutions provide overall wavelength bounds. These bounds
include possible gaps and overlapping orders. Physical resolving power is unknown.
RA/DEC quoting errors are corrected in memory only when ingesting metadata.
Downloads contain the original header, including its original card syntax.

The service offers a search form, TAP/ObsCore discovery and minimal SSA discovery
with native FITS products. It does not advertise single-array SDM conversions,
SODA cutouts, or per-order products. IRAF multispec-aware software is needed to
interpret the separate wavelength solutions in downloaded files.

On development, as the account that can read observations:

    cd /var/gavo/inputs/fai_echelle_spectra
    dachs val -p q
    dachs imp q
    dachs test -v -u http://127.0.0.1:8080 q

After source review, commit q.rd and README.md on development, push to GitHub,
and pull the same commit on production. Do not track the template backup or
science FITS. Ensure the original observations path is readable on production.
Then validate/import there and test with -u http://127.0.0.1 (production port 80).
Run dachs pub q for registry publication only as part of the production release.

Development form: http://127.0.0.1:8080/fai_echelle_spectra/q/web/form
Through the existing SSH tunnel: http://127.0.0.1:18080/fai_echelle_spectra/q/web/form

Checks performed on development: publication validation, 3 HTTP regressions,
all 8 product downloads byte-identical by SHA-256, and HTTP 200 search form.

HTML download links use a site-relative /getproduct/ URL so a development
SSH tunnel stays on development. SSA access URLs retain the configured public
server URL. The same descriptor works on production without editing host names.
