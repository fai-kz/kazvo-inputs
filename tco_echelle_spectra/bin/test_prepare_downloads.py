import importlib.util
from pathlib import Path
import tempfile
import unittest
import numpy as np
from astropy.io import fits
spec=importlib.util.spec_from_file_location('exporter', Path(__file__).with_name('prepare_downloads.py'))
mod=importlib.util.module_from_spec(spec);spec.loader.exec_module(mod)

class ExportTests(unittest.TestCase):
    def test_header_and_data_and_extensions(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);src=root/'source.fits';out=root/'export.fits'
            fits.HDUList([fits.PrimaryHDU(np.arange(100,dtype=np.int16)),
                          fits.ImageHDU(np.arange(12,dtype=np.float32))]).writeto(src,checksum=True)
            h=fits.getheader(src);h['OBJECT']='Corrected name';h['RA_ICRS']=123.45
            side=Path(str(src)+'.hdr');h.totextfile(side)
            before=(src.read_bytes(),side.read_bytes())
            mod.export(src,out)
            self.assertEqual(before,(src.read_bytes(),side.read_bytes()))
            with fits.open(src) as a,fits.open(out) as b:
                self.assertEqual(b[0].header['OBJECT'],'Corrected name')
                self.assertEqual(b[0].header['RA_ICRS'],123.45)
                for x,y in zip(a,b):np.testing.assert_array_equal(x.data,y.data)
            self.assertNotIn('CHECKSUM',fits.getheader(out))
    def test_reject_bad_dimensions_and_keep_existing_output(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory);src=root/'source.fits';out=root/'export.fits'
            fits.PrimaryHDU(np.arange(10)).writeto(src)
            h=fits.getheader(src);h['NAXIS1']=20;h.totextfile(str(src)+'.hdr')
            out.write_bytes(b'existing output')
            with self.assertRaisesRegex(ValueError,'NAXIS1'):mod.export(src,out)
            self.assertEqual(out.read_bytes(),b'existing output')
    def test_reject_source_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            src=Path(directory)/'source.fits'
            fits.PrimaryHDU(np.arange(10)).writeto(src)
            with self.assertRaises(ValueError):mod.export(src,src)

if __name__=='__main__':unittest.main()
