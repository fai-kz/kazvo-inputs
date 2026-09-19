<resource schema="spectra_agn_archive" resdir=".">
	<meta name="creationDate">2024-12-05T12:39:57Z</meta>

	<meta name="title">Archive of AGN spectral observations</meta>
	<meta name="description">
	The archive of AGN spectral observations is obtained on AZT-8 telescope at the Fesenkov Astrophysical Institute (FAI), Almaty, Kazakhstan.
	It represents the result of observations for abot 25 years - from 1970 to 1995. All observations were carried out at AZT-8 (D = 700 mm, F[main] = 2800 mm, F[Cassegrain] = 11000 mm) with a high-power spectrograph. In 1967-68, on the basis of the image intensifier (https://doi.org/10.1080/1055679031000084795a) developed and assembled the spectrograph of the original design in the workshops of the FAI.
	</meta>

	<meta name="subject">active-galactic-nuclei</meta>
	<meta name="subject">history-of-astronomy</meta>
	<meta name="creator">Fesenkov Astrophysical Institute</meta>
	<meta name="instrument">AZT-8</meta>
	<meta name="facility">Fesenkov Astrophysical Institute</meta>

	<meta name="source">2023ExA....56..557S</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Archive</meta>

	<meta name="coverage.waveband">Optical</meta>
	<meta name="ssap.dataSource">pointed</meta>
	<meta name="ssap.creationType">archival</meta>

	<!--<meta name="productType">spectrum</meta>-->
		<meta name="productType">image/fits</meta>
	<meta name="ssap.testQuery">MAXREC=1</meta>

	<table id="raw_data" onDisk="True" adql="hidden">

		<mixin>//products#table</mixin>
		<mixin>//ssap#plainlocation</mixin>
		<mixin>//ssap#simpleCoverage</mixin>
		<FEED source="//scs#splitPosIndex"
			long="degrees(long(ssa_location))"
			lat="degrees(lat(ssa_location))"
			columns="ssa_location"/>
		<column name="ssa_dateObs" type="double precision"
			unit="d"
			ucd="time.epoch"
			utype="ssa:Char.TimeAxis.Coverage.Location.Value"
			description="Observation time (MJD)"/>

		<column name="ssa_dstitle"
			type="text"
			ucd="meta.title"
			utype="ssa:DataID.Title"
			description="Dataset title"/>
		
		<column name="ssa_targname"
			type="text"
			ucd="meta.id;src"
			description="Target name"/>

		<column name="ssa_length"
			type="integer"
			required="True"
			ucd="meta.number"
			utype="ssa:Dataset.Length"
			description="Number of spectral points"/>

		<column name="ssa_timeExt"
			type="double precision"
			unit="s"
			ucd="time.duration;obs.exposure"
			description="Exposure time"/>
		
		<column name="ssa_specstart"
			type="double precision"
			unit="Angstrom"
			ucd="em.wl;stat.min"
			description="Start wavelength"/>
		
		<column name="ssa_specend"
			type="double precision"
			unit="Angstrom"
			ucd="em.wl;stat.max"
			description="End wavelength"/>
		
		<column name="ssa_specres"
			type="double precision"
			unit="Angstrom"
			ucd="em.wl"
			description="Wavelength step (sampling)"/>
		
		<column name="datalink"
			type="text"
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
			ucd="meta.id;src"
			tablehead="Name"
			description="Name of galaxy"
			verbLevel="1"/>
		
		<column name="ra"
			type="double precision"
			unit="deg"
			ucd="pos.eq.ra;meta.main"
			tablehead="RA"
			description="The AGN's ICRS right ascension from SIMBAD (J2000)"
			verbLevel="1"
			displayHint="type=hms,sf=2"/>
		
		<column name="dec"
			type="double precision"
			unit="deg"
			ucd="pos.eq.dec;meta.main"
			tablehead="Dec"
			description="The AGN's ICRS delination from SIMBAD (J2000)"
			verbLevel="1"
			displayHint="type=hms,sf=2"/>
		
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
			ucd="time.duration;obs.exposure"
			tablehead="Exp_time"
			description="Exposure time"
			verbLevel="1"/>
		
		<column name="spec_line"
			type="double precision"
			ucd="em.line"
			tablehead="Spec_line"
			description="The spectral line observed, such as H-alpha or H-beta."
			verbLevel="1"/>
		</table>

	<data id="import">
		<recreateAfter>make_view</recreateAfter>
		<property key="previewDir">previews</property>
		<!--<sources recurse="True"
		 pattern="/var/gavo/inputs/astroplates/spectra_agn_archive/reducted_spectra_agn/*.fits"/>-->
		<sources recurse="True"
			pattern="/var/gavo/inputs/spectra_agn_archive/data/*.fits"/>

		<fitsProdGrammar qnd="True">
		 <rowfilter procDef="//products#define">
			<bind key="table">"\schema.raw_data"</bind>
			<bind key="path">\inputRelativePath</bind>
			<bind key="datalink">"\rdId#sdl"</bind>
			<bind key="mime">"application/fits"</bind>
			<bind key="preview">\standardPreviewPath</bind>
			<bind key="preview_mime">"image/png"</bind>
		 </rowfilter>
		</fitsProdGrammar>

		<make table="raw_data">
		 <rowmaker idmaps="*">
			<var key="specAx">getWCSAxis(@header_, 1, forceSeparable=True)</var>
			<var key="raRaw">(@RA if @RA is not None else @OBJCTRA)</var>
			<var key="decRaw">(@DEC if @DEC is not None else @OBJCTDEC)</var>

			<map key="ra"><![CDATA[(
			(parseAngle(str(@raRaw).replace(";", ":"), "hms", sepChar=":")*15)
				if ((":" in str(@raRaw)) or (";" in str(@raRaw)))
				else (float(@raRaw)*15 if float(@raRaw) <= 24 else float(@raRaw))
			) if @raRaw else None]]></map>

			<map key="dec"><![CDATA[(
				parseAngle(str(@decRaw).replace(";", ":"), "dms", sepChar=":")
					if ((":" in str(@decRaw)) or (";" in str(@decRaw)))
					else float(@decRaw)
			) if @decRaw else None]]></map>

			<apply procDef="//ssap#fill-plainlocation">
				<bind key="aperture">0.0363</bind>
				<bind key="ra">@ra</bind>
				<bind key="dec">@dec</bind>
			</apply>
			<map key="exp_time">float(@EXPTIME)</map>
			<!--<map key="ssa_dateObs">float(@MJD) if @MJD is not None else float(@JD) if @JD is not None else None</map>-->
			<map key="ssa_dateObs">
				dateTimeToMJD(parseISODT(vars["DATE_OBS"]))
			</map>
			<map key="ssa_dstitle">"Spectrum of {} (ID: {}) taken on {}".format(@OBJECT or "unknown object", @IDN or "n/a", @DATE_OBS)</map>
			
			<map key="ssa_targname">@OBJECT</map>
			<map key="ssa_specstart">@specAx.pixToPhys(1)</map>
			<map key="ssa_specend">@specAx.pixToPhys(@specAx.axisLength)</map>
			<map key="ssa_length">@specAx.axisLength</map>
			<map key="ssa_timeExt">@EXPTIME</map>
			<map key="ssa_specres">@CDELT1</map>
			<map key="datalink">\dlMetaURI{sdl}</map>
		 </rowmaker>
		</make>
	</data>

	<table id="data" onDisk="True" adql="True">

		<meta name="_associatedDatalinkService">
			<meta name="serviceId">sdl</meta>
			<meta name="idColumn">ssa_pubDID</meta>
		</meta>

		<mixin
			sourcetable="raw_data"
			copiedcolumns="*"
			ssa_aperture="0.0363"
			ssa_fluxunit="'erg.cm**-2.s**-1.Angstrom**-1'"
			ssa_spectralunit="'Angstrom'"
			ssa_bandpass="'Optical'"
			ssa_collection="'agn_azt8'"
			ssa_fluxcalib="'RELATIVE'"
			ssa_fluxucd="'phot.flux.density;em.wl'"
			ssa_speccalib="'CALIBRATED'"
			ssa_spectralucd="'em.wl'"
			ssa_targclass="'AGN'"
		>//ssap#view</mixin>

		<mixin
			calibLevel="1"
			coverage="ssa_region"
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
		by datalink.	If you have per-bin errors or whatever else, just
		add columns as above. -->
	<table id="instance" onDisk="False">
		<mixin ssaTable="data"
			spectralDescription="'Wavelength in Angstrom'"
			fluxDescription="'Flux density in erg.cm**-2.s**-1.Angstrom**-1'"
			>//ssap#sdm-instance</mixin>
		<meta name="description" format="plain">
			This table represents a single spectrum with flux density as a function of wavelength.</meta>
	</table>


	<data id="build_spectrum">
		<embeddedGrammar>
			<iterator>
				<code>
				import os
				import urllib.parse
				from gavo import base
				from gavo.utils import pyfits

				pubDID = self.sourceToken.get("ssa_pubDID")
				if not pubDID:
					raise base.ValidationError(
						"No ssa_pubDID in datalink token", "ssa_pubDID")
				accref = urllib.parse.unquote(pubDID.split("?", 1)[-1])

				sourcePath = os.path.join(base.getConfig("inputsDir"), accref)

				with pyfits.open(sourcePath, memmap=False) as hdul:
					hdr = hdul[0].header
					arr = hdul[0].data

				crval1 = float(hdr.get("CRVAL1", 0.0))
				crpix1 = float(hdr.get("CRPIX1", 1.0))
				cdelt1 = float(hdr.get("CDELT1", 1.0))

				n = len(arr)
				for i in range(n):
					wl = crval1 + ((i+1) - crpix1) * cdelt1	# Angstrom
					yield {"spectral": wl, "flux": float(arr[i])}
				</code>
			</iterator>
		</embeddedGrammar>

		<make table="instance">
			<parmaker>
				<apply procDef="//ssap#feedSSAToSDM"/>
			</parmaker>
		</make>
	</data>

	<!-- the datalink service spitting out SDM spectra (and other formats on request) -->
	<service id="sdl" allowed="dlget,dlmeta">
		<meta name="title">\schema Datalink Service</meta>

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
		</datalinkCore>
	</service>

	<service id="web" defaultRenderer="form">
		<meta name="shortName">AGN Arch. SSA Web</meta>

		<dbCore queriedTable="data">
			<condDesc buildFrom="ssa_location"/>
			<condDesc buildFrom="ssa_dateObs"/>

			<condDesc>
				<inputKey original="data.ssa_targname" tablehead="Target Object">
					<values fromdb="ssa_targname FROM spectra_agn_archive.data
						ORDER BY ssa_targname"/>
				</inputKey>
			</condDesc>
		</dbCore>

		<outputTable>
			<autoCols>
				ssa_targname, accref, ssa_aperture, ssa_dateObs, datalink
			</autoCols>
			<FEED source="//ssap#atomicCoords"/>
			<outputField original="ssa_specstart" displayHint="spectralUnit=Angstrom"/>
			<outputField original="ssa_specend" displayHint="spectralUnit=Angstrom"/>
		</outputTable>
	</service>

	<service id="ssa" allowed="ssap.xml">
		<meta name="shortName">AGN Arch. SSAP</meta>
		<meta name="ssap.complianceLevel">minimal</meta>

		<publish render="ssap.xml" sets="ivo_managed"/>
		<publish render="form" sets="ivo_managed,local" service="web"/>

		<ssapCore queriedTable="data">
			<property key="previews">auto</property>
			<FEED source="//ssap#hcd_condDescs"/>
		</ssapCore>
	</service>


	<regSuite title="spectra_agn_archive service regression">

		<regTest title="SSAP returns a valid result table">
			<url REQUEST="queryData" MAXREC="1">
				http://127.0.0.1/spectra_agn_archive/q/ssa/ssap.xml
			</url>
			<code><![CDATA[
	self.assertHasStrings(
		"VOTABLE", 'name="QUERY_STATUS"',
		'name="ssa_pubDID"', 'name="ssa_targname"', "<TR>")
	self.assertLacksStrings(
		'value="ERROR"', "Traceback", "Internal Server Error")
	]]></code>
		</regTest>

		<regTest title="Datalink delivers a spectrum">
			<url
				ID="ivo://fai.kz/~?spectra_agn_archive/data/s_3C120_03-04.02.1986_20m_XXV-2-1.fits"
				FORMAT="application/x-votable+xml;serialization=tabledata">
				http://127.0.0.1/spectra_agn_archive/q/sdl/dlget
			</url>
			<code><![CDATA[
	self.assertHasStrings(
		"VOTABLE", 'name="spectral"', 'name="flux"', "<TR>", "<TD>")
	self.assertLacksStrings("Traceback", "UsageError", "Internal Server Error")
	]]></code>
		</regTest>

	</regSuite>

</resource>
