#!/usr/bin/env python3
"""Build service-only metadata and previews; never edit source FITS or HDR files."""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
from pathlib import Path
import warnings
import numpy as np
from astropy.io import fits
from astropy.coordinates import Angle, SkyCoord
from astropy import units as u
from astropy.time import Time


def header_read(path):
    header = fits.getheader(path)
    repaired = []
    for card in header.cards:
        try:
            card.value
        except fits.VerifyError:
            with warnings.catch_warnings():
                warnings.simplefilter('ignore')
                card.verify('fix')
            repaired.append(card.keyword)
    return header, repaired


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def metadata(path, root):
    h, fixed = header_read(path)
    side = Path(str(path) + '.hdr')
    extra = fits.Header.fromtextfile(side) if side.exists() else fits.Header()
    name = str(h.get('OBJECT') or h.get('OBJNAME') or '').strip()
    name_source = 'FITS header'
    if not name:
        name = path.name.split('_')[0]
        name_source = 'filename prefix (blank OBJECT/OBJNAME)'
    n = int(h['NAXIS1'])
    if h['NAXIS'] != 1 or h.get('DC-FLAG', 0) != 0 or h['CTYPE1'].strip() != 'LINEAR':
        raise ValueError(f'Unsupported spectral axis: {path}')
    # All audited inputs have IRAF WAT1_001 units=Angstroms.
    if 'units=Angstroms' not in h.get('WAT1_001', ''):
        raise ValueError(f'Unconfirmed wavelength unit: {path}')
    crval, crpix, delta = float(h['CRVAL1']), float(h['CRPIX1']), float(h['CDELT1'])
    if not np.isfinite([crval, crpix, delta]).all() or delta <= 0:
        raise ValueError(f'Invalid spectral WCS: {path}')
    w0 = (crval + (1-crpix)*delta)*1e-10
    w1 = (crval + (n-crpix)*delta)*1e-10
    ra, dec, status = None, None, 'header position; RA interpreted as hours'
    try:
        # The same stars have both sexagesimal and numeric-hour RA headers.
        ra = float(Angle(h['RA'], unit=u.hourangle).degree)
        dec = float(Angle(h['DEC'], unit=u.deg).degree)
        if not (0 <= ra < 360 and -90 <= dec <= 90):
            raise ValueError('coordinate out of range')
    except (ValueError, TypeError):
        ra = dec = None
        status = 'invalid header position; location omitted'
    exposure = h.get('EXPTIME', h.get('EXPOSURE'))
    exposure = float(exposure) if exposure is not None else None
    if exposure is not None and (not np.isfinite(exposure) or exposure < 0):
        raise ValueError(f'Invalid exposure: {path}')
    row = dict(relative=str(path.relative_to(root)), sha256=sha(path),
        header_sha256=sha(side) if side.exists() else None,
        target=name, target_source=name_source, ra=ra, dec=dec,
        raw_ra=str(h['RA']), raw_dec=str(h['DEC']), coordinate_status=status,
        repaired_cards=','.join(fixed), mjd=float(Time(h['DATE-OBS'],format='isot',scale='utc').mjd),
        date_obs=h['DATE-OBS'], n=n, wave_min=w0, wave_max=w1,
        exposure=exposure, crval=crval, crpix=crpix, delta=delta,
        origfile=path.name, puborg='KazVO', dataorig='external',
        observer=h.get('OBSERVER'), telescope=h.get('TELESCOP'), instrument=h.get('INSTRUME'),
        camera=h.get('CAMERA'), detnam=h.get('DETNAM'), bunit=extra.get('BUNIT','relative'),
        fluxcal=extra.get('FLUXCAL','RELATIVE'), cosmicr=extra.get('COSMICR'),
        specrp=float(extra.get('SPECRP',12000)), calib_level=2)
    for col,key in [('norm','NORM'),('biascor','BIASCOR'),('darkcor','DARKCOR'),
                    ('bpixcor','BPIXCOR'),('flatcor','FLATCOR'),('tellcor','TELLCOR'),('helcor','HELCOR')]:
        value=extra.get(key)
        row[col] = value if isinstance(value,bool) else None
    row['wavecal'] = True
    return row


def prepare(root, output, previews=False):
    paths=sorted(root.glob('*/*/reduced/*.fits'))
    if not paths:
        raise ValueError('No spectra found')
    rows=[metadata(p,root) for p in paths]
    groups=defaultdict(list)
    for r in rows:
        groups[r['target'].upper().replace('_','').replace(' ','')].append(r)
    # Do not invent corrections for inconsistent pointing metadata. Retain the
    # raw values, flag the group and omit its sky-search location pending review.
    for group in groups.values():
        valid=[r for r in group if r['ra'] is not None]
        if len(valid)<2: continue
        c=SkyCoord([r['ra'] for r in valid]*u.deg,[r['dec'] for r in valid]*u.deg)
        if np.max(c[:,None].separation(c[None,:]).arcsec)>60:
            for r in group:
                r['ra']=r['dec']=None
                r['coordinate_status']='inconsistent positions for this target (>60 arcsec); location omitted'
    for r in rows:
        side = fits.Header.fromtextfile(str(root/r['relative'])+'.hdr')
        if 'RA_ICRS' in side and 'DEC_ICRS' in side:
            r['ra'], r['dec'] = float(side['RA_ICRS']), float(side['DEC_ICRS'])
            r['coordinate_status'] = str(side.get('COORDSRC', 'sidecar ICRS coordinates'))
        if r['ra'] is None:
            raise ValueError(f"Unresolved coordinate for {r['relative']}")
    output.mkdir(parents=True,exist_ok=True)
    if previews:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
        dest=output/'previews'; dest.mkdir(exist_ok=True)
        for path,r in zip(paths,rows):
            flux=fits.getdata(path)
            wave=(r['crval']+(np.arange(r['n'])+1-r['crpix'])*r['delta'])
            fig,ax=plt.subplots(figsize=(8,3))
            ax.plot(wave,flux,lw=.45)
            ax.set(xlabel='Wavelength (Angstrom)',ylabel='Relative flux',title=f"{r['target']} — {r['date_obs'][:10]}")
            fig.tight_layout()
            fig.savefig(dest/(r['origfile']+'.png'),dpi=100)
            plt.close(fig)
    if len({r['origfile'] for r in rows}) != len(rows):
        raise ValueError('Duplicate basenames: preview naming requires unique names')
    (output/'metadata.json').write_text(json.dumps({r['relative']:r for r in rows},indent=2))
    print(json.dumps(dict(files=len(rows),missing_positions=sum(r['ra'] is None for r in rows),
        repaired_headers=sum(bool(r['repaired_cards']) for r in rows),
        filename_targets=sum(r['target_source'].startswith('filename') for r in rows),
        coordinate_status=dict(Counter(r['coordinate_status'] for r in rows))),indent=2))
    return rows

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('source',type=Path); p.add_argument('output',type=Path)
    p.add_argument('--previews',action='store_true')
    a=p.parse_args(); prepare(a.source,a.output,a.previews)
