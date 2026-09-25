<resource schema="neutrons" resdir=".">
	<meta name="creationDate">2024-12-11T15:27:49Z</meta>

	<meta name="title">Alma-Ata Station Neutron Monitor Data Service </meta>
	<meta name="description" format="rst">
		The Alma-Ata Cosmic Ray Station operates the 18NM-64 neutron
		supermonitor at an altitude of 3340 meters above sea level,
		with a geomagnetic cutoff rigidity of 6.7 GeV. The station
		provides real-time, minute-level measurements of cosmic ray
		intensity, contributing to the
		international NMDB network. These data support the study of 
		cosmic ray variations and space weather phenomena.

		The provided dataset consists of daily tables,
		where each table corresponds to a single observation day.
		The data includes two columns:
		
		- **Obs_time**: The time of observation at the detector (UTC).
		- **Count [ct/s]**: The recorded cosmic ray intensity in 
				counts per second.

		The data are collected and provided by the Institute of Ionosphere, 
		(https://ionos.kz/) and are also available through the Kazakhstan
		Space Weather Portal (https://ssa.fai.kz/, registration required), 
		which additionally offers interactive visualizations and graphs.
	
	</meta>
	<meta name="subject">space-weather</meta>
	<meta name="subject">neutron-monitors</meta>
	<meta name="subject">cosmic-ray-detectors</meta>

	<meta name="creator">Fesenkov Astrophysical Institute</meta>
	<meta name="instrument">18NM-64 Neutron Monitor</meta>
	<meta name="facility">Alma-Ata Cosmic Ray Station (AATB)</meta>

	<meta name="source">https://ionos.kz/</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Archive</meta> 

	<execute every="3600" title="Ingest new files">
		<job>
			<code>
				#execDef.spawn("dachs imp \rdId")
				execDef.spawn(["dachs", "imp", "ssa/neutrons"])
			</code>
		</job>
	</execute>

	<table id="main" onDisk="True" adql="True">
		<index columns="obs_time"/>
		<index columns="obs_mjd"/>
		<index columns="source_path"/>
		<index columns="counts"/>
		<column name="obs_time" type="timestamp"
			ucd="time.epoch"
			tablehead="Timestamp"
			description="Time of observation in UTC (yyyy-mm-ddThh:mm:ssZ)."/>
		<column name="obs_mjd" type="double precision"
			unit="d" ucd="time.epoch"
			tablehead="Obs. MJD"
			description="Time of observation in MJD."/>
		<column name="counts" type="double precision"
			unit="ct/s" ucd="arith.rate;phys.particle.neutron"
			tablehead="Count"
			description="Average neutron counts per second, derived from one-minute measurements."/>
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
		<sources pattern="./data/ndata/*.csv">
			<ignoreSources fromdb="select distinct source_path from \schema.main"/>
		</sources>

		<csvGrammar>
			<rowfilter>
				<code>
					# upstream writes their files live; skip files that
					# still seem to be written to.
					if os.path.getmtime(rowIter.sourceToken)>time.time()-3600:
						raise SkipThis(f"Skipping file still being written to: {rowIter.sourceToken}")
					yield row
				</code>
			</rowfilter>
		</csvGrammar>

		<make table="main">
			<rowmaker idmaps="*">
				<map key="obs_time">@timestamp</map>
				<map key="source_path">\inputRelativePath</map>
				<map key="obs_mjd">dateTimeToMJD(parseISODT(@timestamp))</map>
				<map key="counts">float(vars["counts/sec"])</map>
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
			<condDesc buildFrom="counts"/>
		</dbCore>
		<outputTable autoCols="obs_time, obs_mjd, counts"/>
	</service>

	<regSuite title="neutrons regression">
		<regTest title="neutrons table serves some data">
			<url parSet="TAP"
				QUERY="SELECT * FROM neutrons.main WHERE obs_mjd between 60111.691 and 60111.692"
				>/tap/sync</url>
			<code>
				row = self.getFirstVOTableRow()
				self.assertAlmostEqual(row["counts"], 1315.5)
				self.assertEqual(row["obs_time"].isoformat(), "2023-06-16T16:36:00")
			</code>
		</regTest>

	</regSuite>
<!-- ==SETUP== fix regtest-->

</resource>
