#!/usr/bin/env python3
"""Verify every product mapping and sample HTTP FITS download for both TCO RDs."""
import hashlib
import io
import json
from pathlib import Path
import sys
from urllib.parse import quote
import requests
from astropy.io import fits
from gavo import api
base=sys.argv[1].rstrip('/')
with api.getTableConn() as connection:
    for schema,expected in [('tco_echelle_spectra',837),('tco_hot_supergiants',512)]:
        resource=Path('/var/gavo/inputs')/schema
        manifest=json.loads((resource/'downloads/manifest.json').read_text())
        rows=list(connection.query('SELECT p.accref, p.accesspath, r.accsize FROM dc.products p JOIN '+schema+'.raw_data r USING (accref) WHERE p.sourcetable=%(table)s',{'table':schema+'.raw_data'}))
        assert len(rows)==expected==len(manifest),(schema,len(rows),len(manifest))
        for accref,path,size in rows:
            name=Path(accref).name
            assert path==schema+'/downloads/'+name,(accref,path)
            assert size==manifest[name]['bytes'],(size,manifest[name]['bytes'])
        for accref,path,size in (rows[0],rows[-1]):
            name=Path(accref).name
            response=requests.get(base+'/getproduct/'+quote(accref,safe='/'),timeout=60)
            response.raise_for_status()
            assert hashlib.sha256(response.content).hexdigest()==manifest[name]['download_sha256']
            source=Path(manifest[name]['source'])
            header=fits.Header.fromtextfile(str(source)+'.hdr')
            for key in ('CHECKSUM','DATASUM'):header.remove(key,remove_all=True,ignore_missing=True)
            with fits.open(io.BytesIO(response.content)) as hdus:
                assert hdus[0].header.tostring()==header.tostring()
        print(schema,expected,'product paths/sizes verified; HTTP FITS headers match HDR')
