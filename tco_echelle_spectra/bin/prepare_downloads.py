#!/usr/bin/env python3
"""Create downloadable FITS with companion primary headers; sources are read-only.

Run on each host before importing either RD. Generated files are not Git inputs.
The original bytes after the primary header (including extensions) are preserved.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import tempfile
from astropy.io import fits


def digest(path):
    with open(path, 'rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def tail_digest(path, offset):
    with open(path, 'rb') as stream:
        stream.seek(offset)
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def export(source, destination):
    source, destination = Path(source).resolve(strict=True), Path(destination)
    sidecar = Path(str(source) + '.hdr')
    if destination.resolve() in (source.resolve(), sidecar.resolve()):
        raise ValueError('Output must not replace either source')
    source_sha, sidecar_sha = digest(source), digest(sidecar)
    header = fits.Header.fromtextfile(sidecar)
    with fits.open(source, memmap=False, do_not_scale_image_data=True) as hdus:
        original = hdus[0].header
        offset = hdus[0].fileinfo()['datLoc']
        keys = ['SIMPLE', 'BITPIX', 'NAXIS', 'GROUPS', 'PCOUNT', 'GCOUNT',
                'BSCALE', 'BZERO', 'BLANK']
        keys += ['NAXIS'+str(i) for i in range(1, int(original['NAXIS'])+1)]
        for key in keys:
            if original.get(key) != header.get(key):
                raise ValueError(f'{source}: structural/scaling mismatch for {key}')
    # CHECKSUM includes the old header and cannot be reused. DATASUM is retained
    # only indirectly via the byte-for-byte data verification below.
    for key in ('CHECKSUM', 'DATASUM'):
        header.remove(key, remove_all=True, ignore_missing=True)
    serialized = header.tostring(sep='', endcard=True, padding=True).encode('ascii')
    destination.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix='.fits-export-', dir=destination.parent)
    try:
        with os.fdopen(fd, 'wb') as output, source.open('rb') as incoming:
            output.write(serialized)
            incoming.seek(offset)
            shutil.copyfileobj(incoming, output)
            output.flush()
            os.fsync(output.fileno())
        with fits.open(temporary, memmap=False, do_not_scale_image_data=True) as hdus:
            hdus.verify('exception')
            new_offset = hdus[0].fileinfo()['datLoc']
            if hdus[0].header.tostring() != header.tostring():
                raise ValueError(f'{source}: output header differs from companion')
        if tail_digest(source, offset) != tail_digest(temporary, new_offset):
            raise ValueError(f'{source}: data bytes changed')
        if digest(source) != source_sha or digest(sidecar) != sidecar_sha:
            raise ValueError(f'{source}: source changed during export')
        os.chmod(temporary, 0o644)
        os.replace(temporary, destination)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)
    return dict(source=str(source), source_sha256=source_sha,
                header_sha256=sidecar_sha, download_sha256=digest(destination),
                bytes=destination.stat().st_size)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('rd', choices=['tco_hot_supergiants/q', 'tco_echelle_spectra/q'])
    args = parser.parse_args()
    from gavo import api
    rd = api.getRD(args.rd)
    paths = [Path(p) for p in rd.getById('import').sources.iterSources()]
    if args.rd == 'tco_hot_supergiants/q':
        from gavo.utils import iterSimpleText
        with open(rd.getAbsPath('res/files-to-publish.txt')) as stream:
            names = {line.strip() for _, line in iterSimpleText(stream)}
        paths = [p for p in paths if p.name in names]
    if not paths or len({p.name for p in paths}) != len(paths):
        raise ValueError('No sources or duplicate basenames; refusing export')
    output = Path(rd.getAbsPath('downloads'))
    manifest = {}
    for path in sorted(paths):
        manifest[path.name] = export(path, output/path.name)
    temporary = output/'manifest.json.new'
    temporary.write_text(json.dumps(manifest, indent=2)+'\n')
    os.replace(temporary, output/'manifest.json')
    print(f'{args.rd}: verified {len(manifest)} FITS downloads; source FITS/HDR unchanged')


if __name__ == '__main__':
    main()
