<resource schema="fai_echelle_spectra" resdir=".">
  <meta name="creationDate">2026-10-22T20:44:12Z</meta>
  <meta name="title">FAI Assy-Turgen Unmerged Echelle Spectra</meta>
  <meta name="description">
    Extracted, wavelength-calibrated, unmerged stellar echelle spectra from
    the eShel spectrograph on the Zeiss-1000 telescope at Assy-Turgen Observatory.
    Each archive record delivers one original IRAF multispec FITS containing
    all extracted orders. Wavelength solutions are recorded separately for
    each order in the WAT2 header cards, in Angstroms. Orders are neither
    flattened nor merged. Downloaded files retain their original bytes.
    Wavelength bounds enclose all orders; they do not imply continuous coverage.
    Exposure duration is taken from EXPTIME. Flux calibration and resolving
    power are not established by these headers and are not assumed.
    Generic single-array spectrum viewers may not support IRAF multispec.
  </meta>
  <meta name="subject">spectroscopy</meta>
  <meta name="subject">stars</meta>
  <meta name="creator">Fesenkov Astrophysical Institute</meta>
  <meta name="instrument">eShel spectrograph; Zeiss-1000</meta>
  <meta name="facility">Assy-Turgen Observatory</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>
  <meta name="coverage.waveband">Optical</meta>
  <meta name="ssap.dataSource">pointed</meta>
  <meta name="ssap.creationType">spectralExtraction</meta>
  <meta name="productType">spectrum</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden" namePath="//ssap#instance">
    <LOOP listItems="ssa_dateObs ssa_dstitle ssa_targname ssa_length ssa_specstart ssa_specend ssa_timeExt ssa_pubDID">
      <events><column original="\item"/></events>
    </LOOP>
    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <FEED source="//scs#splitPosIndex" columns="ssa_location"
      long="degrees(long(ssa_location))" lat="degrees(lat(ssa_location))"/>
    <column name="n_orders" type="integer" required="True" ucd="meta.number" tablehead="Orders"
      description="Number of separately extracted orders in this FITS."/>
    <column name="pixels_per_order" type="integer" required="True" ucd="meta.number;instr.pixel"
      tablehead="Pixels/order" description="Samples per extracted order."/>
    <column name="ncombine" type="integer" ucd="meta.number" tablehead="Combined"
      description="NCOMBINE from the original header."><values nullLiteral="-1"/></column>
    <column name="exposure_header" type="double precision" unit="s" ucd="time.duration;obs.exposure"
      tablehead="EXPOSURE (original)" description="Original EXPOSURE keyword; not used as the product exposure duration."/>
    <column name="origfile" type="text" ucd="meta.id;meta.file" tablehead="File"
      description="Original file name."/>
    <column name="observer" type="text" ucd="meta.id;obs.observer" tablehead="Observer"
      description="Observer from the original FITS header."/>
  </table>

  <data id="import">
    <recreateAfter>make_view</recreateAfter>
    <sources pattern="../observations/assy/zeiss1000/echell/*.fits"/>
    <embeddedGrammar>
      <iterator>
        <setup imports="os,re,numpy">
          <code>
            from astropy.io import fits
            from astropy.coordinates import Angle
            from astropy import units as u
            from astropy.time import Time
          </code>
        </setup>
        <code><![CDATA[
          with fits.open(self.sourceToken, mode="readonly") as hdus:
              h = hdus[0].header
              shape = hdus[0].shape
              if len(hdus) != 1 or len(shape) != 2:
                  raise ValueError("Expected one two-dimensional multispec primary HDU")
              if h.get("WAT0_001", "").strip() != "system=multispec":
                  raise ValueError("Missing multispec coordinate system")
              wat = "".join(str(h[k]).ljust(68) for k in sorted(h)
                            if re.fullmatch(r"WAT2_\d{3}", k))
              specs = re.findall(r'spec(\d+)\s*=\s*"([^"]+)"', wat)
              if [int(k) for k, v in specs] != list(range(1, shape[0]+1)):
                  raise ValueError("Order descriptions do not match array rows")
              limits = []
              for k, value in specs:
                  fields = list(map(float, value.split()))
                  if len(fields) != 9 or not numpy.isfinite(fields).all():
                      raise ValueError("Unsupported or invalid multispec description")
                  ap, beam, dtype, w1, dw, nw, z, low, high = fields
                  if dtype != 0 or nw != shape[1] or dw <= 0 or z <= -1:
                      raise ValueError("Expected valid linear wavelength solution")
                  limits.extend([w1/(1+z), (w1+(nw-1)*dw)/(1+z)])
              if "units=angstroms" not in "".join(str(h[k]).ljust(68) for k in sorted(h) if k.startswith("WAT1_")):
                  raise ValueError("Wavelength units must be Angstroms")
              # Repair malformed quoted cards only in memory. Never write the FITS.
              for key in ("RA", "DEC"):
                  h.cards[key].verify("fix")
              ra = Angle(str(h["RA"]), unit=u.hourangle).degree
              dec = Angle(str(h["DEC"]), unit=u.deg).degree
              if not (0 <= ra < 360 and -90 <= dec <= 90):
                  raise ValueError("Invalid header sky position")
              exposure = float(h["EXPTIME"])
              if not numpy.isfinite(exposure) or exposure <= 0:
                  raise ValueError("Invalid EXPTIME")
              yield dict(ra=ra, dec=dec,
                  ssa_dateObs=float(Time(h["DATE-OBS"], format="isot", scale="utc").mjd),
                  ssa_dstitle=str(h["OBJNAME"]).strip()+" unmerged echelle "+h["DATE-OBS"],
                  ssa_targname=str(h["OBJNAME"]).strip(),
                  ssa_length=int(shape[0]*shape[1]),
                  ssa_specstart=min(limits)*1e-10, ssa_specend=max(limits)*1e-10,
                  ssa_timeExt=exposure, n_orders=shape[0], pixels_per_order=shape[1],
                  ncombine=h.get("NCOMBINE"), exposure_header=h.get("EXPOSURE"),
                  origfile=os.path.basename(self.sourceToken), observer=h.get("OBSERVER"))
        ]]></code>
      </iterator>
      <rowfilter procDef="//products#define">
        <bind key="table">"\schema.raw_data"</bind>
        <bind key="accref">\inputRelativePath{True}</bind>
        <bind key="path">\inputRelativePath{True}</bind>
        <bind key="fsize">os.path.getsize(rowIter.sourceToken)</bind>
        <bind key="mime">"application/fits"</bind>
      </rowfilter>
    </embeddedGrammar>
    <make table="raw_data">
      <rowmaker idmaps="*">
        <apply procDef="//ssap#fill-plainlocation">
          <bind key="ra">@ra</bind><bind key="dec">@dec</bind>
        </apply>
        <map key="ssa_pubDID">getStandardPubDID(@prodtblAccref)</map>
      </rowmaker>
    </make>
  </data>
  <table id="data" onDisk="True" adql="True">
    <mixin sourcetable="raw_data" copiedcolumns="*" timescale="UTC"
      ssa_aperture="NULL" ssa_fluxunit="''" ssa_spectralunit="'Angstrom'"
      ssa_bandpass="'Optical'" ssa_collection="'FAI Assy Echelle'"
      ssa_fluxcalib="'UNCALIBRATED'" ssa_fluxucd="'phot.count'"
      ssa_speccalib="'CALIBRATED'" ssa_spectralucd="'em.wl'"
      ssa_targclass="'star'">//ssap#view</mixin>
    <mixin calibLevel="2" sResolution="ssa_spaceres" oUCD="ssa_fluxucd"
      emUCD="ssa_spectralucd">//obscore#publishSSAPMIXC</mixin>
  </table>
  <data id="make_view" auto="False"><make table="data"/></data>
  <coverage><updater sourceTable="data"/></coverage>
  <service id="web" defaultRenderer="form">
    <meta name="shortName">FAI Echelle Web</meta>
    <dbCore queriedTable="data">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="ssa_dateObs"/>
      <condDesc buildFrom="ssa_targname"/>
    </dbCore>
    <outputTable>
      <outputField original="accref" tablehead="FITS download">
        <formatter>
          from gavo.protocols import products
          return T.a(href=products.makeProductLink(data, withHost=False))[data.rsplit("/", 1)[-1]]
        </formatter>
      </outputField>
      <autoCols>ssa_targname,ssa_dateObs,ssa_timeExt,n_orders,pixels_per_order,ncombine</autoCols>
      <FEED source="//ssap#atomicCoords"/>
      <outputField original="ssa_specstart" displayHint="displayUnit=Angstrom"/>
      <outputField original="ssa_specend" displayHint="displayUnit=Angstrom"/>
    </outputTable>
  </service>
  <service id="ssa" allowed="form,ssap.xml">
    <meta name="shortName">FAI Echelle SSA</meta>
    <meta name="ssap.complianceLevel">minimal</meta>
    <publish render="ssap.xml" sets="ivo_managed"/>
    <publish render="form" sets="ivo_managed,local" service="web"/>
    <ssapCore queriedTable="data"><FEED source="//ssap#hcd_condDescs"/></ssapCore>
  </service>
  <regSuite title="FAI multispec archive">
    <regTest title="Web download links stay on the current server">
      <url __nevow_form__="genForm" _FORMAT="HTML">web/form</url>
      <code>
        self.assertHasStrings('href="/getproduct/observations/assy/zeiss1000/echell/BetAql_20260930.fits"')
      </code>
    </regTest>
    <regTest title="Eight complete multispec products">
      <url REQUEST="queryData" MAXREC="1000">ssa/ssap.xml</url>
      <code>
        rows = self.getVOTableRows()
        self.assertEqual(len(rows), 8)
        for row in rows:
            self.assertEqual(row["mime"], "application/fits")
            self.assertEqual(row["n_orders"], 33)
            self.assertEqual(row["pixels_per_order"], 1374)
      </code>
    </regTest>
    <regTest title="Exposure comes from EXPTIME">
      <url REQUEST="queryData" TARGETNAME="UpsCyg">ssa/ssap.xml</url>
      <code>
        row = self.getFirstVOTableRow(rejectExtras=False)
        self.assertEqual(row["ssa_timeExt"], 1200.)
        self.assertEqual(row["exposure_header"], 60.)
      </code>
    </regTest>
  </regSuite>
</resource>
