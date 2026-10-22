import datetime

from gavo import api
from gavo.utils import fitstools

class PositionPeeker(api.HeaderProcessor):
  def _isProcessed(self, srcName):
    # Upstream files are missing quotes around the RA and DEC string
    with open(srcName, "rb") as f:
      hdr = fitstools.readPrimaryHeaderQuick(f)
    try:
      hdr["RA"]
      hdr["DEC"]
    except api.pyfits.VerifyError:
      return False
    
    return True

  def _mungeHeader(self, srcName, hdr):
    hdr.cards[hdr.index("RA")].verify("fix")
    hdr.cards[hdr.index("DEC")].verify("fix")
    hdr["HISTORY"] = "Header fixed by fai.kz {}".format(
            datetime.date.today().isoformat())
    return hdr


if __name__=="__main__":
  api.procmain(PositionPeeker, "tco_hot_supergiants/q", "import")
