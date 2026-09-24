<resource schema="solar_flux" resdir=".">
	<meta name="creationDate">2024-12-12T18:34:01Z</meta>

	<meta name="title">Solar Radio Emission Observations at “Orbita” Radio Polygon</meta>
	<meta name="description" format="rst">
    The “Orbita” Radio Polygon at an altitude of 2750 meters 
    conducts solar radio emission observations using 
    state-of-the-art equipment. This includes instruments for 
    monitoring solar radio flux at frequencies of 1 GHz and 2.8 GHz,
    as well as the Callisto solar radio spectrograph, which is part 
    of the international e-Callisto network. These tools enable the 
    detection of solar radio bursts of types II, III, IV, and V, and 
    provide valuable insights for forecasting the geo-effectiveness 
    of solar flare activity.

    The provided dataset consists of daily tables, where each table 
    corresponds to a single observation day. The data includes two columns:

    - **Obs_time**: The time of observation at the detector (UTC).
    - **Flux [SFU]**: The solar flux unit measurement, representing the intensity of solar radio emission in SFU (Solar Flux Units).

    The data are collected and provided by the Institute of Ionosphere,
    (https://ionos.kz/) and are also available through the Kazakhstan
    Space Weather Portal (https://ssa.fai.kz/, registration required),
    which additionally offers interactive visualizations and graphs.	
  </meta>
  <meta name="subject">space-weather</meta>
	<meta name="subject">solar-physics</meta>
	<meta name="subject">radio-astronomy</meta>
	<meta name="subject">solar-radio-emission</meta>
	<meta name="subject">solar-activity</meta>

	<meta name="creator">Fesenkov Astrophysical Institute</meta>
	<meta name="instrument">Callisto Spectrometer</meta>
	<meta name="instrument">Solar Radio Emission Detectors</meta>
	<meta name="facility">Orbita Radiopolygon</meta>

	<!--<meta name="source"></meta>-->
	<meta name="contentLevel">Research</meta>
	<meta name="type">Archive</meta>

  <execute at="01:00" title="Ingest new files">
    <job>
      <code>
        #execDef.spawn("dachs imp \rdId")
        execDef.spawn(["dachs", "imp", "ssa/solar_flux"])
      </code>
    </job>
  </execute>

	<meta name="coverage.waveband">Radio</meta>

	<table id="main" onDisk="True" adql="True">
		<index columns="obs_time"/>
		<index columns="obs_mjd"/>
		<index columns="source_path"/>
		<index columns="flux"/>
		<column name="obs_time" type="timestamp"
  		ucd="time.epoch"
  		tablehead="Timestamp"
  		description="Time of observation in UTC (yyyy-mm-ddThh:mm:ssZ)."
			displayHint="type=humanDate"/>
		<column name="obs_mjd" type="double precision"
			unit="d" ucd="time.epoch"
			tablehead="Obs. MJD"
			description="Time of observation in MJD."/>	
    <column name="flux" type="double precision"
			unit="SFU" ucd="phot.flux.density;em.radio"
			tablehead="Flux"
			description="Solar radio flux density measured in Solar Flux Units (SFU)."/>
		<column name="source_path" type="text"
			ucd="meta.id;meta.file"
			tablehead="Src."
			description="File this row was parsed from."
			verbLevel="30"/>
	</table>

  <coverage>
    <temporal>59555 70000</temporal>
  </coverage>

	<data id="import" updating="True">
		<sources pattern="./data/orbita/*.csv">
      <ignoreSources fromdb="select distinct source_path from \schema.main"/>
    </sources>
		
    <csvGrammar/>

		<make table="main">
			<rowmaker idmaps="*">
				<map key="obs_time">@timestamp</map>
				<map key="source_path">\fullPath</map>
				<map key="obs_mjd">dateTimeToMJD(parseISODT(@timestamp))</map>
				<map key="flux">float(@SFU)</map>
			</rowmaker>
		</make>
	</data>

	<service id="q" allowed="form">
		<meta name="shortName">\schema data</meta>

		<publish render="form" sets="ivo_managed, local"/>

		<dbCore queriedTable="main">
			<condDesc>
				<inputKey original="obs_time" type="date"/>				
			</condDesc>
			<condDesc buildFrom="flux"/>
		</dbCore>
		<outputTable autoCols="obs_time, obs_mjd, flux"/>
	</service>

	<regSuite title="solar_flux regression">
    <regTest title="solar flux test">
      <url parSet="TAP"
        QUERY="SELECT * FROM solar_flux.main
               WHERE obs_time BETWEEN '2023-06-16T02:27:59' AND '2023-06-16T02:28:01'"
        >/tap/sync</url>
      <code>
          row = self.getFirstVOTableRow()
          self.assertAlmostEqual(row["flux"], 156.4)
          self.assertEqual(str(row["obs_time"]), "2023-06-16 02:28:00")
      </code>
    </regTest>
	</regSuite>

<!-- ==SETUP== fix regtest-->
</resource>
