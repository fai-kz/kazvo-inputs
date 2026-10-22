#!/usr/bin/env python3
"""Repair only broken local FITS symlinks after the move into reduced folders."""
from pathlib import Path
from collections import defaultdict
import datetime
import json
import os

root=Path('/var/gavo/inputs/tco_hot_supergiants/data')
if root.is_symlink():
    print('Subset data directory is already a shared-data link; no repair needed')
else:
    sources=Path('/var/gavo/inputs/observations/others/tco/spectra_echelle/targets')
    index=defaultdict(list)
    for path in sources.glob('*/*/reduced/*.fits'):
        index[path.name].append(path)
    changes=[]
    for path in sorted(root.glob('*.fits')):
        if path.is_symlink() and not path.exists():
            old=path.readlink()
            matches=index[old.name]
            if len(matches)!=1:
                raise ValueError(f'{path}: expected one source, found {len(matches)}')
            changes.append((path,old,matches[0]))
    if changes:
        backup=Path.home()/'tco-git-backups'/('subset-links-'+datetime.datetime.now().strftime('%Y%m%dT%H%M%S%f'))
        backup.mkdir(parents=True)
        (backup/'links.json').write_text(json.dumps([
            {'link':str(path),'old_target':str(old),'new_target':str(new)}
            for path,old,new in changes],indent=2)+'\n')
        for path,old,new in changes:
            temporary=path.with_name('.repair-'+path.name)
            if os.path.lexists(temporary):raise FileExistsError(temporary)
            temporary.symlink_to(new)
            os.replace(temporary,path)
        print(f'Repaired {len(changes)} local symlinks; old targets saved at {backup}')
    else:
        print('No broken FITS links')
