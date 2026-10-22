<resource schema="tco_echelle_spectra" resdir=".">
  <meta name="creationDate">2026-10-22T11:49:00Z</meta>

  <meta name="title">TCO Optical Echelle Spectral Archive</meta>

  <meta name="description" format="rst">
One-dimensional reduced optical stellar spectra obtained at the Three College
Observatory (TCO) with the eShel spectrograph on the 0.81-m telescope.
This collection includes the full supplied archive, including the stars in the
separately published hot-supergiant subset and additional stellar targets.

Wavelengths are computed from the original linear IRAF WCS in Angstroms and
served in meters. Fluxes are relative; continuum normalization is recorded only
where supplied in the metadata. Resolving power R=12000 is adopted from the
existing collection documentation, not measured separately for each spectrum.

  </meta>

  <meta name="subject">spectroscopy</meta>
  <meta name="subject">stars</meta>

  <meta name="creator">Danford, S.; Miroshnichenko, A.</meta>
  <meta name="instrument">eShel spectrograph</meta>
  <meta name="facility">Three College Observatory</meta>

  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>  

  <meta name="coverage.waveband">Optical</meta>

  <meta name="ssap.dataSource">pointed</meta>
  <meta name="ssap.creationType">spectralExtraction</meta>
  <meta name="productType">spectrum</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden" namePath="//ssap#instance">

    <LOOP listItems="
      ssa_dateObs
      ssa_dstitle
      ssa_targname
      ssa_length
      ssa_specstart
      ssa_specend
      ssa_specres
      ssa_timeExt
      ssa_pubDID
    ">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <FEED source="//scs#splitPosIndex"
      columns="ssa_location"
      long="degrees(long(ssa_location))"
      lat="degrees(lat(ssa_location))"/>

    <column name="datalink" type="text"
      ucd="meta.ref.url"
      tablehead="DataLink"
      description="A DataLink document for this spectrum, providing SODA access and the original file."
      verbLevel="15"
      displayHint="type=url">
      <property name="targetType">application/x-votable+xml;content=datalink</property>
      <property name="targetTitle">DataLink</property>
    </column>

    <column name="wave_min"
      type="double precision"
      unit="m"
      ucd="em.wl;stat.min"
      tablehead="λ min"
      description="Minimum wavelength covered by the spectrum."
      verbLevel="15"/>

    <column name="wave_max"
      type="double precision"
      unit="m"
      ucd="em.wl;stat.max"
      tablehead="λ max"
      description="Maximum wavelength covered by the spectrum."
      verbLevel="15"/>

    <column name="specrp"
      type="real"
      ucd="spect.resolution"
      tablehead="R"
      description="Spectral resolving power lambda/dlambda."
      verbLevel="15"/>

    <column name="calib_level"
      type="smallint"
      tablehead="Calib Level"
      ucd="meta.code.qual"
      required="True"
      description="ObsCore-style calibration level. Merged relative flux spectra are level 2."
      verbLevel="15"/>

    <column name="origfile"
      type="text"
      ucd="meta.id"
      tablehead="Original file"
      description="Original FITS file name in the supplied archive."
      verbLevel="25"/>

    <column name="puborg"
      type="text"
      ucd="meta.curation"
      tablehead="Publisher"
      description="Publishing archive or organisation."
      verbLevel="25"/>

    <column name="dataorig"
      type="text"
      ucd="meta.note"
      tablehead="Data origin"
      description="Origin of the data with respect to KazVO/FAI."
      verbLevel="25"/>

    <column name="observer"
      type="text"
      ucd="meta.id;obs.observer"
      tablehead="Observer"
      description="Observer(s) listed in the FITS header."
      verbLevel="15"/>

    <column name="telescope"
      type="text"
      ucd="instr.tel"
      tablehead="Telescope"
      description="Telescope used for the observation."
      verbLevel="15"/>

    <column name="instrument"
      type="text"
      ucd="instr"
      tablehead="Instrument"
      description="Instrument or spectrograph used for the observation."
      verbLevel="15"/>

    <column name="camera"
      type="text"
      ucd="meta.id;instr.det"
      tablehead="Camera"
      description="Camera listed in the FITS header."
      verbLevel="25"/>

    <column name="detnam"
      type="text"
      ucd="meta.id;instr.det"
      tablehead="Detector"
      description="Detector name listed in the FITS header."
      verbLevel="25"/>

    <column name="bunit"
      type="text"
      ucd="meta.unit"
      tablehead="Flux unit"
      description="Flux unit from supplied companion metadata, or relative for this collection."
      verbLevel="15"/>

    <column name="norm"
      type="boolean"
      ucd="meta.code"
      tablehead="Normalized"
      required="True"
      description="True if the merged spectrum is continuum-normalized."
      verbLevel="15"/>

    <column name="wavecal"
      type="boolean"
      ucd="meta.code"
      tablehead="Wavecal"
      required="True"
      description="True if the spectrum is wavelength calibrated."
      verbLevel="25"/>

    <column name="fluxcal"
      type="text"
      ucd="meta.code"
      tablehead="Flux calibration"
      description="Flux calibration status from supplied companion metadata, or relative for this collection."
      verbLevel="15"/>

    <column name="biascor"
      type="boolean"
      ucd="meta.code"
      tablehead="Bias corrected"
      required="True"
      description="True if bias correction was applied."
      verbLevel="25"/>

    <column name="darkcor"
      type="boolean"
      ucd="meta.code"
      tablehead="Dark corrected"
      required="True"      
      description="True if dark correction was applied."
      verbLevel="25"/>

    <column name="bpixcor"
      type="boolean"
      ucd="meta.code"
      tablehead="Bad pixels"
      required="True"
      description="True if bad-pixel map correction was applied."
      verbLevel="25"/>

    <column name="flatcor"
      type="boolean"
      ucd="meta.code"
      tablehead="Flat corrected"
      required="True"
      description="True if flat-field correction was applied."
      verbLevel="25"/>

    <column name="cosmicr"
      type="text"
      ucd="meta.code"
      tablehead="Cosmic rays"
      description="Cosmic ray removal method."
      verbLevel="25"/>

    <column name="tellcor"
      type="boolean"
      ucd="meta.code"
      tablehead="Telluric corrected"
      required="True"
      description="True if telluric correction was applied."
      verbLevel="25"/>

    <column name="helcor"
      type="boolean"
      ucd="meta.code"
      tablehead="Heliocentric corrected"
      required="True"
      description="True if heliocentric correction was applied."
      verbLevel="25"/>
    <column name="target_source" type="text" ucd="meta.note" tablehead="Target provenance" description="Source of the target name."/>
    <column name="raw_ra" type="text" ucd="meta.note" tablehead="Original RA" description="Original header RA, in numeric hours or sexagesimal hours."/>
    <column name="raw_dec" type="text" ucd="meta.note" tablehead="Original Dec" description="Original header declination, in degrees or sexagesimal degrees."/>
    <column name="coordinate_status" type="text" ucd="meta.code.qual" tablehead="Position status" description="Coordinate interpretation or reason sky position is omitted."/>
    <column name="repaired_cards" type="text" ucd="meta.note" tablehead="Card syntax" description="Cards whose syntax was repaired in memory; source FITS is unchanged."/>
  </table>

  <data id="import">
    <property name="previewDir">previews</property>
    <sources pattern="data/*/*/reduced/*.fits"/>
    <embeddedGrammar>
      <iterator>
        <setup imports="json,os">
          <code>
            with open(rd.getAbsPath("metadata.json")) as stream:
                metadata = {os.path.basename(k): v for k, v in json.load(stream).items()}
          </code>
        </setup>
        <code>
          yield dict(metadata[os.path.basename(self.sourceToken)])
        </code>
      </iterator>
      <rowfilter procDef="//products#define">
        <bind key="table">"\schema.raw_data"</bind>
        <bind key="accref">\inputRelativePath{True}</bind>
        <bind key="mime">"application/fits"</bind>
        <bind key="preview">"tco_echelle_spectra/previews/"+row["origfile"]+".png"</bind>
        <bind key="preview_mime">"image/png"</bind>
      </rowfilter>
    </embeddedGrammar>
    <make table="raw_data">
      <rowmaker idmaps="*">
        <apply procDef="//ssap#fill-plainlocation">
          <bind key="ra">@ra</bind>
          <bind key="dec">@dec</bind>
        </apply>
        <map key="ssa_dateObs">@mjd</map>
        <map key="ssa_dstitle">@target+" echelle spectrum "+@date_obs</map>
        <map key="ssa_targname">@target</map>
        <map key="ssa_specstart">@wave_min</map>
        <map key="ssa_specend">@wave_max</map>
        <map key="ssa_length">@n</map>
        <map key="ssa_timeExt">@exposure</map>
        <map key="ssa_specres">(@wave_min+@wave_max)/2/@specrp</map>
        <map key="ssa_pubDID">getStandardPubDID(@prodtblAccref)</map>
        <map key="datalink">\dlMetaURI{sdl}</map>
      </rowmaker>
    </make>
  </data>

  <table id="data" onDisk="True" adql="True">
    <mixin 
      sourcetable="raw_data" timescale="UTC" 
      copiedcolumns="*"
      ssa_aperture="NULL"
      ssa_fluxunit="''"
      ssa_spectralunit="'m'"
      ssa_bandpass="'Optical'"
      ssa_collection="'TCO Echelle Spectra'"
      ssa_fluxcalib="'RELATIVE'"
      ssa_fluxucd="'phot.flux.density;em.wl'"
      ssa_speccalib="'CALIBRATED'"
      ssa_spectralucd="'em.wl;obs.atmos'"
      ssa_targclass="'star'"
    >//ssap#view</mixin>

    <mixin 
      calibLevel="2" 
      sResolution="ssa_spaceres" 
      oUCD="ssa_fluxucd" 
      emUCD="ssa_spectralucd"
    >//obscore#publishSSAPMIXC</mixin> 

    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

  </table>

  <data id="make_view">
    <make table="data"/>
  </data>


  <coverage> 
    <updater sourceTable="data"/> 
  </coverage>


  <table id="instance" onDisk="False">
    <mixin ssaTable="data"
      spectralDescription="'Wavelength in meters'"
      fluxDescription="'Relative flux'"
    >//ssap#sdm-instance</mixin>
    <meta name="description">1D merged relative flux eShel spectrum</meta>
  </table>

  <data id="build_spectrum" auto="False">
    <embeddedGrammar>
      <iterator>
        <setup imports="gavo.protocols.products,gavo.utils.pyfits,gavo.utils"/>
        <code>
          fitsPath = base.getConfig("inputsDir") / self.sourceToken["accref"]

          with pyfits.open(fitsPath) as hdus:
              ax = utils.getWCSAxis(hdus[0].header, 1)
              data = hdus[0].data

              for spec, flux in enumerate(data):
                  wl_meters = ax.pix0ToPhys(spec) * 1e-10
                  yield {"spectral": wl_meters, "flux": float(flux)}
        </code>
      </iterator>
    </embeddedGrammar>
    <make table="instance">
      <parmaker>
        <apply procDef="//ssap#feedSSAToSDM"/>
      </parmaker>
    </make>
  </data>

  <service id="sdl" allowed="dlget,dlmeta">
    <meta name="shortName">TCO Echelle DL</meta>
    <meta name="title">\schema Datalink Service</meta>
    <meta name="description">
      The TCO datalink provides an IVOA spectral data model rendering of the
      merged echelle spectra and cutout and reformatting operations.
    </meta>
    
    <datalinkCore>
      <descriptorGenerator procDef="//soda#sdm_genDesc">
        <bind key="ssaTD">"\rdId#data"</bind>
      </descriptorGenerator>
      
      <dataFunction procDef="//soda#sdm_genData">
        <bind key="builder">"\rdId#build_spectrum"</bind>
      </dataFunction>
      
      <FEED source="//soda#sdm_cutout"/>
      <FEED source="//soda#sdm_format"/>
      
      <metaMaker semantics="#derivation">
        <code>
          if descriptor.pubDID is None:
              return
          yield descriptor.makeLink(
              makeAbsoluteURL("\rdId/sdl/dlget?ID="+urllib.parse.quote(descriptor.pubDID)),
              contentType="application/x-votable+xml",
              description="Spectrum as SDM VOTable",
              contentLength=100000
          )
        </code>
      </metaMaker>
    </datalinkCore>
  </service>


  <service id="web" defaultRenderer="form">
    <meta name="shortName">TCO Echelle Web</meta>

    <dbCore queriedTable="data">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="ssa_dateObs"/>
      <condDesc>
        <inputKey original="data.ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname from \schema.data order by ssa_targname"/>
        </inputKey>
      </condDesc>
    </dbCore>

    <outputTable>
      <autoCols>accref, ssa_targname, ssa_dateObs, datalink</autoCols>
      <FEED source="//ssap#atomicCoords"/>
      
      <outputField original="ssa_specstart" displayHint="displayUnit=Angstrom"/>
      <outputField original="ssa_specend" displayHint="displayUnit=Angstrom"/>
    </outputTable>
  </service>


  <service id="ssa" allowed="form,ssap.xml">
    <meta name="shortName">TCO Echelle SSAP</meta>
    <meta name="ssap.complianceLevel">full</meta>

    <publish render="ssap.xml" sets="ivo_managed"/>
    <publish render="form" sets="ivo_managed,local" service="web"/>

    <ssapCore queriedTable="data">
      <FEED source="//ssap#hcd_condDescs"/>
    </ssapCore>
  </service>

  <regSuite title="TCO full collection regression">
    <regTest title="Full archive contains all 837 spectra">
      <url REQUEST="queryData" MAXREC="1000">ssa/ssap.xml</url>
      <code>
        self.assertEqual(len(self.getVOTableRows()), 837)
      </code>
    </regTest>
    <regTest title="New ZIP target available">
      <url TARGETNAME="2Cet" REQUEST="queryData">ssa/ssap.xml</url>
      <code>
        row = self.getFirstVOTableRow(rejectExtras=False)
        self.assertEqual(row['ssa_targname'], '2Cet')
        self.assertTrue(row['ssa_pubDID'])
      </code>
    </regTest>
  </regSuite>
</resource>
