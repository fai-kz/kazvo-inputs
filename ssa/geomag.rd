<resource schema="geomagnetic_field" resdir=".">
	<meta name="creationDate">2024-12-09T11:51:56Z</meta>

	<meta name="title">Alma-Ata Geomagnetic Observatory Data Service</meta>
	<meta name="description" format="rst">
		The Alma-Ata Geomagnetic Observatory provides continuous monitoring of
		Earth's geomagnetic field. Located at 1300 meters above sea level in the
		foothills of the Tien Shan Mountains, approximately 10 km from Almaty,
		Kazakhstan, the observatory operates state-of-the-art equipment certified by
		INTERMAGNET, including the fluxgate magnetometer LEMI-008 and the proton
		Overhauser magnetometer POS-1.

		The data service includes:

		* **Observables**: Three components of the geomagnetic field vector (X, Y, Z) and the total field amplitude (F), measured in nanoteslas (nT).

		* **Data Resolution**:

			- XYZ components measured at a 1-second frequency.

			- F component measured at a 5-second frequency.

			- Derived minute averages for XYZF components available in real time.

			- Absolute measurements performed two to three times per week.

		The service provides open access to minute- and hour-resolution data
		(XYZF components and the geomagnetic K-index) from 2003 onward via
		the Institute of Ionosphere’s website (https://ionos.kz/).
		Minute-resolution variation data since 2004 are also available through
		the INTERMAGNET network. Data prior to 2003 are available upon request.

		The dataset is maintained by the Institute of Ionosphere and is
		additionally accessible through the Kazakhstan Space Weather Portal
		(https://ssa.fai.kz/, registration required), which also offers
		interactive plots and visualizations.
	</meta>
	<meta name="subject">geomagnetic-fields</meta>
	<meta name="subject">space-weather</meta>

	<meta name="creator">Fesenkov Astrophysical Institute</meta>
	<meta name="instrument">LEMI-008</meta>
	<meta name="instrument">LEMI-203</meta>
	<meta name="instrument">POS-1</meta>
	<meta name="facility">Alma-Ata Geomagnetic Observatory</meta>

	<meta name="source">https://ionos.kz/en/geomagnetic-observatory-2/</meta>
	<meta name="contentLevel">Research</meta>
	<meta name="type">Archive</meta>

	<execute at="1:00" title="Ingest new files">
		<job>
			<code>
				#execDef.spawn("dachs imp \rdId")
				execDef.spawn(["dachs", "imp", "ssa/geomag"])
			</code>
		</job>
	</execute>

	<table id="main" onDisk="True" adql="True">
		<index columns="obs_time"/>
		<index columns="source_path"/>
		<index columns="b_total"/>

		<column name="obs_time" type="timestamp"
			ucd="time.epoch"
			tablehead="Timestamp"
			description="Time of observation in UTC (yyyy-mm-ddThh:mm:ssZ)."/>
		<column name="obs_mjd" type="double precision"
			unit="d" ucd="time.epoch"
			tablehead="Obs. MJD"
			description="Time of the observation at the detector as MJD."/>
		<column name="b_x" type="double precision"
			unit="nT" ucd="phys.magField;pos.cartesian.x"
			tablehead="B_x"
			description="Magnetic field component in the X direction."/>
		<column name="b_y" type="double precision"
			unit="nT" ucd="phys.magField;pos.cartesian.y"
			tablehead="B_y"
			description="Magnetic field component in the Y direction."/>
		<column name="b_z" type="double precision"
			unit="nT" ucd="phys.magField;pos.cartesian.z"
			tablehead="B_z"
			description="Magnetic field component in the Z direction."/>
		<column name="b_total" type="double precision"
			unit="nT" ucd="phys.magField"
			tablehead="B_total"
			description="Total magnetic field strength."/> 
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
		<sources pattern="./data/data/*.csv">
			<ignoreSources fromdb="select distinct source_path from \schema.main"/>
		</sources>

		<csvGrammar/>

		<make table="main">
			<rowmaker id="build_main">
				<map key="b_total">parseWithNull(@B_total, float, "999999.9")</map>
				<map key="b_x">parseWithNull(@Bx, float, "999999.9")</map>
				<map key="b_y">parseWithNull(@By, float, "999999.9")</map>
				<map key="b_z">parseWithNull(@Bz, float, "999999.9")</map>
				<map key="obs_time">@timestamp</map> 
				<map key="source_path">\fullPath</map>
				<map key="obs_mjd">dateTimeToMJD(parseISODT(@timestamp))</map>
			</rowmaker>
		</make>
	</data>

	<service id="q" allowed="form">
		<meta name="shortName">Geomag. fields</meta>

		<publish render="form" sets="ivo_managed, local"/>

		<dbCore queriedTable="main">
			<condDesc>
				<inputKey original="obs_time" type="date"/>
			</condDesc>
			<condDesc buildFrom="b_total"/>
		</dbCore>
		<outputTable autoCols="obs_time, obs_mjd, b_x, b_y, b_z, b_total"/>
	</service>

	<regSuite id="reg_tests" title="geomag_field regression">
		
		<regTest id="b_tot_test" title="geomag_field b_total test">
			<url parSet="TAP"
						QUERY="SELECT * FROM geomagnetic_field.main WHERE obs_mjd between 60111.6903 and 60111.691"
				>/tap/sync</url>
				<code>
					row = self.getFirstVOTableRow()
					self.assertAlmostEqual(row["b_total"], 55630.6)
					self.assertEqual(row["obs_time"].isoformat(), "2023-06-16T16:35:00")
			</code>
		</regTest>

		<regTest title="geomag_field mjd time range test">
			<url parSet="TAP"
					QUERY="SELECT * FROM geomagnetic_field.main
									WHERE obs_mjd BETWEEN 60248.00000 AND 60248.004"
				>/tap/sync</url>
			<code>
				rows = self.getVOTableRows()
				self.assertEqual(len(rows), 6)
				self.assertEqual({r["b_x"]&lt;-60 for r in rows}, {True})
			</code>
		</regTest>

		<regTest title="geomag web interface is there">
			<url parSet="form"
				obs_time__day="26" obs_time__month="3" obs_time__year="2023"
				_DBOPTIONS_ORDER="obs_time">q/form</url>
			<code><![CDATA[
				self.assertHasStrings(
					"2023-03-26T00:00:00", # requested timestamp
					"55614.7", # B total at that timestamp
					'title="Magnetic field component in the Y direction."')
			]]></code>
		</regTest>
<!-- ==SETUP== fix regtest-->
  </regSuite>
</resource>
