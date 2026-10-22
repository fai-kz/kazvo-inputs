from gavo import api

class PreviewMaker(api.SpectralPreviewMaker):
  sdmId = "build_spectrum"

if __name__=="__main__":
  api.procmain(PreviewMaker, "tco_hot_supergiants/q", "import")
