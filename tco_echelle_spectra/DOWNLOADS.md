# FITS downloads with companion headers

Both TCO services now serve a generated FITS copy for each existing product URL.
Its primary header comes from the adjacent `.fits.hdr`; the original FITS and HDR
are never edited. Bytes after the original primary header, including any extension
HDUs, are copied unchanged and verified by SHA-256. Structural/scaling mismatches
are errors. CHECKSUM and DATASUM cards are omitted from the new primary header
rather than carrying stale checksums. Other companion cards, including HISTORY,
are preserved. SODA-derived cutouts/reformatted SDM spectra retain their separate,
format-generated headers; this change applies to the full FITS product download.

## Workflow: development -> GitHub -> production

Edit and test on lark-obs, commit only reviewed source changes, push, then pull
on lark with `git pull --ff-only`. Do not copy service source files to production.
The same tracked helper builds local `downloads/` files on each machine from the
shared source FITS/HDR. Generated products and manifests are ignored by Git.

After changing source HDRs, regenerate exports BEFORE importing. From
`/var/gavo/inputs`, on each host:

```sh
python3 tco_echelle_spectra/bin/prepare_downloads.py tco_echelle_spectra/q
python3 tco_echelle_spectra/bin/prepare_downloads.py tco_hot_supergiants/q
dachs imp tco_echelle_spectra/q
dachs imp tco_hot_supergiants/q
```

Run generation using the account owning each resource directory and able to read
the observations. On development these are currently ildana (echelle) and
dachsroot (hot-supergiants); production uses ildana for both.
Do not run the old header-mutation helpers to produce these downloads.
`downloads/manifest.json` records source, sidecar, and generated-product hashes.
The original accrefs and publisher dataset IDs are retained. Product file sizes
are taken from the generated FITS, replacing the old hardcoded subset size.

Check development with:

```sh
python3 tco_echelle_spectra/bin/test_prepare_downloads.py
python3 tco_echelle_spectra/bin/verify_downloads.py http://127.0.0.1:8080
dachs test -v -u http://127.0.0.1:8080 tco_echelle_spectra/q
dachs test -v -u http://127.0.0.1:8080 tco_hot_supergiants/q
```

On production use `http://127.0.0.1` instead. Public HTTPS must also be checked
from an external client: lark cannot connect to its own public HTTPS endpoint.
The subset RD has existing pre-publication metadata validation issues; those are
separate from the FITS-product mapping and no registry metadata is changed here.

Historical statements in the original README about downloaded files matching the
original FITS SHA refer to the original deployment. After this change, source FITS
hashes still match, but download hashes match `downloads/manifest.json` instead.
