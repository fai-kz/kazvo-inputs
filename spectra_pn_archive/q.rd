<resource schema="spectra_pn_archive" resdir=".">
  <meta name="creationDate">2023-10-09T15:11:27Z</meta>

  <meta name="title">Archival of Planetary Nebulae Spectral Observation</meta>
  <meta name="description" format="rst">
    Spectra of planetary nebulae obtained at the AZT-8 telescope 
    (0.7-m, Fesenkov Astrophysical Institute, Kamenskoe Plato, Almaty, Kazakhstan)
    during 1970–1998. Observations were carried out with a diffraction spectrograph 
    equipped with the UM-92 image tube, in the 4000–8000 Å range, 
    recorded on A-600 and A-600U photographic plates.
  </meta>
  <meta name="subject">planetary-nebulae</meta>

  <meta name="creator">L.N. Kondratyeva; S.A. Shomshekova; A.Zh. Umirbayeva; L. Aktay</meta>
  <meta name="instrument">AZT-8</meta>
  <meta name="facility">Fesenkov Astrophysical Institute</meta>

  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>  <!-- or Archive, Survey, Simulation -->

  <meta name="coverage.waveband">Optical</meta>

  <meta name="ssap.dataSource">pointed</meta>
  <meta name="ssap.creationType">archival</meta>
  <meta name="productType">spectrum</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden"
      namePath="//ssap#instance">
    <LOOP listItems="ssa_targname ssa_dateObs ssa_timeExt
      ssa_specstart ssa_specend ssa_specres ssa_length ssa_dstitle">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <column name="datalink" type="text"
      ucd="meta.ref.url"
      tablehead="Datalink"
      description="A link to a datalink document for this spectrum."
      verbLevel="15" displayHint="type=url">
      <property name="targetType"
       >application/fits;content=datalink</property>
      <property name="targetTitle">Datalink</property>
    </column>
    <column name="objects"
      type="text"
      ucd="meta.id"
      tablehead="Name"
      description="Planetary nebula identifier"
      verbLevel="1"/>

    <column name="ra"
      type="double precision"
      unit="deg"
      ucd="pos.eq.ra;meta.main"
      tablehead="RA"
      description="ICRS right ascension (J2000)"
      verbLevel="1"
      displayHint="type=hms,sf=2"/>

    <column name="dec"
      type="double precision"
      unit="deg"
      ucd="pos.eq.dec;meta.main"
      tablehead="Dec"
      description="ICRS declination (J2000)"
      verbLevel="1" displayHint="type=dms,sf=2"/>

    <column original="ssa_dateObs"
      type="double precision"
      unit="d"
      ucd="time.epoch"
      tablehead="Obs.date"
      description="The date of observation from observational log in JD"
      verbLevel="1"/>

    <column name="exp_time"
      type="double precision"
      unit="s"
      ucd="obs.exposure"
      tablehead="Exp_time"
      description="Total exposure time (seconds)"
      verbLevel="5"/>
  </table>

  <data id="import">
    <recreateAfter>make_view</recreateAfter>
    <property key="previewDir">previews</property>
    <!--<sources recurse="True"
      pattern="/var/gavo/inputs/astroplates/spectra_pn_archive/reducted_spectra_pn/*.fits"/>-->
    <sources recurse="True"
      pattern="/var/gavo/inputs/spectra_pn_archive/data/*.fits"/>
    
    <fitsProdGrammar qnd="True">
      <rowfilter procDef="//products#define">
        <bind key="table">"\schema.raw_data"</bind>
        <bind key="path">\inputRelativePath</bind>
        <bind key="datalink">"\rdId#datalink"</bind>
        <bind key="mime">"application/fits"</bind>
        <bind key="preview">\standardPreviewPath</bind>
        <bind key="preview_mime">"image/png"</bind>
      </rowfilter>
    </fitsProdGrammar>

    <make table="raw_data">
      <rowmaker idmaps="*">
        <!-- put vars here to pre-process FITS keys that you need to
          re-format in non-trivial ways. -->

        <var key="specAx">getWCSAxis(@header_, 1,forceSeparable=True)</var>

        <apply procDef="//ssap#fill-plainlocation">
          <bind key="ra">@RA</bind>
          <bind key="dec">@DEC</bind>
          <bind key="aperture">10/3600.</bind>
        </apply>
        <map key="ssa_dateObs">dateTimeToMJD(parseTimestamp(@DATE_OBS,
          "%Y-%m-%dT%H:%M:%S"))</map>

        <map key="ssa_dstitle">"Spectrum of {} (ID: {}) taken on {}".format(@OBJECT, @IDN, @DATE_OBS)</map>
        <map key="ssa_targname">@OBJECT</map>

        <map key="ssa_specstart">@specAx.pixToPhys(1)*1e-10</map>
        <map key="ssa_specend">@specAx.pixToPhys(@specAx.axisLength)*1e-10</map>
        <map key="ssa_length">@specAx.axisLength</map>
        <map key="ssa_timeExt">float(@EXPTIME)</map>
        <map key="ssa_specres">abs(float(@CDELT1))*1e-10</map>
        <map key="datalink">\dlMetaURI{sdl}</map>
      </rowmaker>
    </make>
  </data>


  <table id="data" onDisk="True" adql="True">
    <!-- the SSA table (on which the service is based -->

    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      ssa_aperture="10/3600."
      ssa_fluxunit="'erg.cm**-2.s**-1.Angstrom**-1'"
      ssa_spectralunit="'Angstrom'"
      ssa_bandpass="'Optical'"
      ssa_collection="'FAI PN Archive'"
      ssa_fluxcalib="'CALIBRATED'"
      ssa_fluxucd="'phot.flux.density;em.wl'"
      ssa_speccalib="'RELATIVE'"
      ssa_spectralucd="'em.wl'"
      ssa_targclass="'PN'"
    >//ssap#view</mixin>

    <mixin
      calibLevel="2"
      sResolution="ssa_spaceres"
      oUCD="ssa_fluxucd"
      emUCD="ssa_spectralucd"
      >//obscore#publishSSAPMIXC</mixin>
  </table>

  <data id="make_view" auto="False">
    <make table="data"/>
  </data>

  <coverage>
    <updater sourceTable="data"/>
  </coverage>

  <!-- This is the table definition *for a single spectrum* as used
    by datalink.  If you have per-bin errors or whatever else, just
    add columns as above. -->
  <table id="instance" onDisk="False">
    <mixin ssaTable="data"
      spectralDescription="Wavelength (Angstrom)"
      fluxDescription="Flux density (erg.cm**-2.s**-1.Angstrom**-1)"
      >//ssap#sdm-instance</mixin>
    <meta name="description">Single-spectrum instance</meta>
  </table>


  <!-- this data item build spectrum *instances* (for datalink) -->
  <data id="build_spectrum">
    <embeddedGrammar>
      <iterator>
        <setup imports="gavo.utils.pyfits"/>
        <code>
          sourcePath = os.path.join(
            base.getConfig("inputsDir"),
            self.sourceToken["accref"])
          with pyfits.open(sourcePath) as hdul:
            header = hdul[0].header
            data = hdul[0].data

          crval1 = header.get("CRVAL1", 0.0)  # Начальное значение
          crpix1 = header.get("CRPIX1", 1.0)  # Индекс опорной точки
          cdelt1 = header.get("CDELT1", 1.0)  # Шаг между длинами волн

          wavelengths = [
              crval1 + (i + 1 - crpix1) * cdelt1
              for i in range(len(data))
          ]

          for wl, flux in zip(wavelengths, data):
              yield {"spectral": wl, "flux": flux}
        </code>
      </iterator>
    </embeddedGrammar>
    <make table="instance">
      <parmaker>
        <apply procDef="//ssap#feedSSAToSDM"/>
      </parmaker>
    </make>
  </data>

  <!-- the datalink service spitting out SDM spectra (and other formats
    on request) -->
  <service id="sdl" allowed="dlget,dlmeta">
    <meta name="title">PN Datalink Service</meta>
    <meta name="description">Datalink for the Planetary Nebula spectra from
      AZT-8; you can do cutouts and simple calibration here.</meta>
    <datalinkCore>
      <descriptorGenerator procDef="//soda#sdm_genDesc">
        <bind key="ssaTD">"\rdId#data"</bind>
      </descriptorGenerator>
      <dataFunction procDef="//soda#sdm_genData">
        <bind key="builder">"\rdId#build_spectrum"</bind>
      </dataFunction>
      <FEED source="//soda#sdm_plainfluxcalib"/>
      <FEED source="//soda#sdm_cutout"/>
      <FEED source="//soda#sdm_format"/>

      <metaMaker semantics="#derivation">
        <code>
          yield descriptor.makeLink(
            makeAbsoluteURL("\rdId/sdl/dlget?ID="+urllib.parse.quote(descriptor.pubDID)),
              description="This spectrum as a VOTable in the Spectral Data Model")
        </code>
      </metaMaker>
    </datalinkCore>
  </service>

  <!-- a form-based service – this is made totally separate from the
  SSA part because grinding down SSA to something human-consumable and
  still working as SSA is non-trivial -->
  <service id="web" defaultRenderer="form">
    <meta name="shortName">PN Web</meta>

    <dbCore queriedTable="data">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="ssa_dateObs"/>

      <condDesc>
        <inputKey original="data.ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname FROM spectra_pn_archive.data 
            ORDER BY ssa_targname"/>
        </inputKey>
      </condDesc>
    </dbCore>

    <outputTable>
      <autoCols>ssa_targname,accref, mime,
        ssa_aperture, ssa_dateObs</autoCols>
      <FEED source="//ssap#atomicCoords"/>
      <outputField original="ssa_specstart" displayHint="spectralUnit=Angstrom"/>
      <outputField original="ssa_specend" displayHint="spectralUnit=Angstrom"/>
      <outputField name="dlurl" select="accref"
        tablehead="Datalink Access"
        description="URL of a datalink document for the dataset
          (cutouts, different formats, etc)">
        <formatter>
          yield T.a(href=getDatalinkMetaLink(
            rd.getById("sdl"), data)
            )["Datalink"]
        </formatter>
        <property name="targetType"
          >application/x-votable+xml;content=datalink</property>
        <property name="targetTitle">Datalink</property>
      </outputField>
    </outputTable>
  </service>

  <service id="ssa" allowed="form,ssap.xml">
    <meta name="shortName">PN SSAP</meta>
    <meta name="ssap.complianceLevel">full</meta>

    <publish render="ssap.xml" sets="ivo_managed"/>
    <publish render="form" sets="ivo_managed,local" service="web"/>

    <ssapCore queriedTable="data">
      <property key="previews">auto</property>
      <FEED source="//ssap#hcd_condDescs"/>
    </ssapCore>
  </service>

  <regSuite title="spectra_pn_archive regression">

    <!-- 1 SSAP отвечает и отдаёт хотя бы одну запись -->
    <regTest title="SSAP returns a well-known record">
      <url REQUEST="queryData" TARGETNAME="PN M1-77"
        TIME="1981-09-29T17:45:00/1981-09-29T18:15:00">ssa/ssap.xml</url>
      <code><![CDATA[
        row = self.getFirstVOTableRow()
        self.assertAlmostEqual(row['ssa_specend'], 5.995006e-07)
        self.assertEqual(row["ssa_pubDID"],
          'ivo://fai.kz/~?spectra_pn_archive/data/s_M1-77_29-30.09.1981_5m_2548.fits')
  ]]></code>
    </regTest>

    <!-- 2 Datalink-метаданные выглядят правдоподобно -->
    <regTest title="Datalink metadata looks sane">
      <url ID="ivo://fai.kz/~?spectra_pn_archive/data/s_M1-77_29-30.09.1981_5m_2548.fits">sdl/dlmeta</url>
      <code>
        links = self.datalinkBySemantics()
        self.assertEqual(
          set(links), {'#preview', '#this', '#proc', '#derivation'})
        self.assertTrue("cutouts and simple calibration" 
          in links["#proc"][0]["description"],
          "#proc description broken")
        self.assertTrue("Spectral Data Model"
          in links["#derivation"][0]["description"],
          "#derivation description broken")
      </code>
    </regTest>

    <!-- 3 Datalink выдаёт сами данные (SDM-экземпляр спектра) -->
    <regTest title="Datalink delivers spectrum data">
      <url ID="ivo://fai.kz/~?spectra_pn_archive/data/s_M1-77_29-30.09.1981_5m_2548.fits">sdl/dlget</url>
      <code>
        rows = self.getVOTableRows()
        self.assertAlmostEqual(rows[0]["spectral"], 4439.69)
        self.assertEqual(rows[1]["flux"], -451.50506591796875)

        self.assertHasStrings(
          'utype="spec:Spectrum.Char.FluxAxis.Calibration"',
          'value="CALIBRATED"')
      </code>
    </regTest>
<!-- ==SETUP== fix regtest-->
  </regSuite>

</resource>
