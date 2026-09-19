<?xml version="1.0" encoding="utf-8"?>

<resource schema="gcvs_gaia_tess" resdir=".">
    <meta name="title">ML-Enhanced GCVS: Variable Stars with Gaia DR3 and TESS</meta>
    <meta name="creationDate">2025-03-13T12:00:00Z</meta>
    <meta name="description" format="plain">
        This catalog combines photometric and astrometric data from three major sources:
        the General Catalogue of Variable Stars (GCVS, 2017ARep...61...80S), Gaia DR3, and TESS. It provides
        detailed information on variable stars, including their coordinates, magnitudes,
        variability periods, parallaxes, proper motions, spectral classifications, and
        other physical characteristics. Additionally, the catalog includes computed parameters
        such as galactocentric distances and model-predicted values for spectral types and
        variability types for stars with incomplete observational data.
        The catalog aims to facilitate studies of stellar variability, galactic structure, and
        stellar evolution.
    </meta>
    <meta name="subject">variable-stars</meta>
    <meta name="type">service</meta>
    <meta name="source">Kazakhstan Virtual Observatory (KazVO)</meta>

    <!-- Table Definition -->
    <table id="main" onDisk="True" adql="True" mixin="//scs#pgs-pos-index">
        <!-- GCVS Data -->
        <column name="name_gcvs" type="text"
            ucd="meta.id"
            verbLevel="1"
            description="Star name in the General Catalogue of Variable Stars (GCVS)"/>
        <column name="ra_gcvs" type="double precision"
            unit="deg" ucd="pos.eq.ra;meta.main"
            verbLevel="1"
            description="Right Ascension (J2000) from GCVS"/>
        <column name="dec_gcvs" type="double precision"
            unit="deg" ucd="pos.eq.dec;meta.main"
            verbLevel="1"
            description="Declination (J2000) from GCVS"/>
        <column name="min_mag_gcvs" type="double precision"
            unit="mag" ucd="phot.mag;stat.min"
            verbLevel="5"
            description="Minimum recorded magnitude (GCVS)"/>
        <column name="max_mag_gcvs" type="double precision"
            unit="mag" ucd="phot.mag;stat.max"
            verbLevel="5"
            description="Maximum recorded magnitude (GCVS)"/>
        <column name="period_gcvs" type="double precision"
            unit="d" ucd="time.period"
            verbLevel="5"
            description="Variability period (days) from GCVS"/>
        <column name="var_star_num_gcvs" type="integer"
            ucd="meta.id"
            verbLevel="10"
            description="Variable star number assigned in GCVS">
            <values nullLiteral="-1"/>
        </column>
        <column name="var_star_cpt_gcvs" type="text"
            ucd="meta.id"
            verbLevel="10"
            description="Component of a variable star system in GCVS"/>

        <!-- Gaia DR3 Data -->
        <column name="source_id_gaia" type="bigint"
            ucd="meta.id;meta.main"
            verbLevel="1"
            description="Unique Gaia DR3 source identifier">
            <values nullLiteral="-1"/>
        </column>
        <column name="parallax_gaia" type="double precision"
            unit="mas" ucd="pos.parallax"
            verbLevel="1"
            description="Stellar parallax in milliarcseconds (Gaia DR3)"/>
        <column name="pmra_gaia" type="double precision"
            unit="mas/yr" ucd="pos.pm;pos.eq.ra"
            verbLevel="5"
            description="Proper motion in Right Ascension (mas/yr, Gaia DR3)"/>
        <column name="pmdec_gaia" type="double precision"
            unit="mas/yr" ucd="pos.pm;pos.eq.dec"
            verbLevel="5"
            description="Proper motion in Declination (mas/yr, Gaia DR3)"/>
        <column name="phot_g_mag_gaia" type="double precision"
            unit="mag" ucd="phot.mag;em.opt"
            verbLevel="5"
            description="Mean magnitude in Gaia G-band"/>

        <!-- TESS Data -->
        <column name="tess_id" type="bigint"
            ucd="meta.id"
            verbLevel="1"
            description="TESS Input Catalog identifier">
            <values nullLiteral="-1"/>
        </column>
        <column name="teff_tess" type="double precision"
            unit="K" ucd="phys.temperature.effective"
            verbLevel="5"
            description="Effective temperature (Kelvin) from TESS"/>
        <column name="logg_tess" type="double precision"
            ucd="phys.gravity"
            verbLevel="5"
            description="Surface gravity (log g) from TESS"/>
        <column name="mass_tess" type="double precision"
            unit="solMass" ucd="phys.mass"
            verbLevel="5"
            description="Stellar mass in solar masses (TESS)"/>
        <column name="d_tess" type="double precision"
            unit="pc" ucd="pos.distance"
            verbLevel="5"
            description="Distance to the star in parsecs (TESS)"/>

        <!-- Computed and Predicted Data -->
        <column name="r_gal_calc" type="double precision"
            unit="kpc" ucd="pos.distance"
            verbLevel="10"
            description="Galactocentric distance of the star (calculated)"/>
        <column name="spt_source" type="text"
            ucd="meta.code"
            verbLevel="10"
            description="Source of spectral type (GCVS, Gaia, or machine learning prediction)"/>
        <column name="final_spect_type" type="text"
            ucd="src.spType"
            verbLevel="5"
            description="Final assigned spectral type (observed or predicted)"/>
        <column name="var_source" type="text"
            ucd="meta.code"
            verbLevel="10"
            description="Source of variability type (GCVS, Gaia, or machine learning prediction)"/>
        <column name="final_var_type" type="text"
            ucd="meta.code;src.var"
            verbLevel="5"
            description="Final assigned variability type (observed or predicted)"/>
    </table>

		<data id="import">
	    <sources pattern="data/enriched_catalog.fits"/>
    	<fitsTableGrammar/>

	    <make table="main">
        <rowmaker idmaps="*">
            <!-- Если нужно преобразовывать столбцы, можно добавить <map> -->
            <!-- Например, если в var_star_num_gcvs иногда -1, заменяем на NULL -->
            <!--<map dest="tess_id">None if @tess_id == -1 else @tess_id</map>-->
        </rowmaker>
  	  </make>
		</data>
    
		<coverage>
        <updater spaceTable="main" mocOrder="6"/>
    </coverage>

    <service id="scs" allowed="form,scs.xml">
        <meta name="shortName">KazVO Var Stars</meta>
        <meta>
            testQuery.ra: 346.3451843261719
            testQuery.dec: 47.67631149291992
            testQuery.sr: 0.001
        </meta>
        <scsCore queriedTable="main">
            <FEED source="//scs#coreDescs"/>
            <condDesc buildFrom="period_gcvs"/>
        </scsCore>
        <publish sets="local,ivo_managed" render="form"/>
        <publish sets="ivo_managed" render="scs.xml"/>
    </service>

    <regSuite title="var_star_cat service regression">
        <regTest title="SCS returns the catalogued variable star">
            <url RA="346.3451843261719" DEC="47.67631149291992"
                SR="0.001" MAXREC="5"
                RESPONSEFORMAT="application/x-votable+xml;serialization=tabledata">
                http://127.0.0.1/var_star_cat/q/scs/scs.xml
            </url>
            <code><![CDATA[
    self.assertHasStrings(
        "VOTABLE", 'name="QUERY_STATUS" value="OK"',
        'name="name_gcvs"', "AA And")
    self.assertLacksStrings(
        "Internal error", "Traceback", 'value="ERROR"')
    ]]></code>
        </regTest>

        <regTest title="Variable-star web form renders">
            <url>http://127.0.0.1/var_star_cat/q/scs/form</url>
            <code><![CDATA[
    self.assertHasStrings(
        "ML-Enhanced GCVS", "<form", "Search radius")
    self.assertLacksStrings("Internal error", "Traceback")
    ]]></code>
        </regTest>
    </regSuite>
</resource>
