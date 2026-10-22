<resource schema="pn_spec_res_table" resdir=".">
  <meta name="creationDate">2025-06-19T09:16:56Z</meta>

  <meta name="title">Planetary Nebulae: results of abs spectroscopy</meta>
  <meta name="description" format="rst">
    This resource provides a compiled dataset of Galactic planetary nebulae
    derived from absolute optical spectroscopy and supplemented by selected
    values from the literature. Based on these data, fundamental physical
    parameters were calculated, including sizes, densities, electron
    temperatures, and central star characteristics.

    The table includes:
    
    * Object identifiers, excitation classes, and interstellar extinction at Hβ.

    * Morphological and distance properties: angular diameters (Diam_arcsec), linear sizes (Diam_pc), and heliocentric distances (D_kpc).

    * Electron densities from [SII] 6717/6731 ratios.

    * Effective temperatures of central stars estimated both by the Zanstra method (T_HI) and empirical [OIII]-based calibrations (T0_[OIII], T1_[OIII]), given in units of 10**4 K.

    * Timescales: duration of available observations (delta_t_obs_year) and model reproduction intervals (delta_t_model_year), linked to evolutionary models by Bertolami (2016, A&amp;A 588, A25).

    * Absolute emission-line fluxes for Hβ, HeII 4685, [OIII] 5007, Hα, [NII] 6583, HeI 6678, [SII] 6717/6731, HeI 7065, [ArIII] 7136, and [OI] 7324, with measurement uncertainties and (where relevant) a power-of-ten exponent.

    Each measurement is provided in a machine-readable format, separating values,
    uncertainties, and exponents into dedicated columns. This ensures precise
    numerical handling and interoperability with Virtual Observatory services
    and pipelines.
  </meta>
  <meta name="subject">emission-nebulae</meta>
  <meta name="subject">planetary-nebulae</meta>
  <meta name="subject">spectroscopy</meta>
  <meta name="subject">optical-observation</meta>

  <meta name="creator">L.N. Kondratyeva, E.K. Denissyuk, S.A. Shomshekova, I.V. Reva, A.K. Aimanova, M.A. Krugov </meta>
  <meta name="instrument">AZT-8</meta>
  <meta name="facility">Fesenkov Astrophysical Institute</meta>

  <meta name="source">2025Ap.....68...51K</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>

  <meta name="coverage.waveband">Optical</meta>

  <table id="main" onDisk="True" adql="True">
    <column name="object"
        type="text"
        ucd="meta.id;src"
        tablehead="Object"
        description="Primary identifier of the planetary nebula."
        verbLevel="1"/>
    <column name="alt_name"
        type="text"
        ucd="meta.id;src" 
        tablehead="AltName"
        description="Alternative name of the object."
        verbLevel="15"/>

    <column name="excitation_class"
        type="text"
        ucd="phys.atmol.ionStage"
        tablehead="ExcClass"
        description="Excitation class of the nebula, typically 'low' or 'high'."
        verbLevel="15"/>

    <column name="extinction_C_Hbeta" 
        type="double precision"
        ucd="phys.absorption.gal"
        unit=""
        tablehead="C(H_beta)" 
        description="Logarithmic extinction at Hβ."
        verbLevel="5"/>

    <column name="Diam_arcsec"
        type="double precision"
        unit="arcsec"
        ucd="phys.angSize;stat.min" 
        tablehead="Diam″" 
        description="Angular diameter (2*radius) of the nebula in arcseconds. Zero means stellar like object."
        verbLevel="15"/>
    <column name="Diam_sign"
        type="text"
        ucd="meta.code.qual"
        tablehead="DiamQual"
        description="Qualifier for the physical radius: limit ('&gt;', '&lt;') or blank."
        verbLevel="15"/>
    <column name="Diam_pc"
        type="double precision"
        unit="pc"
        ucd="phys.size.radius" 
        tablehead="Diam_pc"
        description="Physical radius (2*radius) of the nebula in parsecs."
        verbLevel="15"/>
    <column name="Dist_kpc"
        type="double precision"
        unit="kpc"
        ucd="pos.distance;src"
        tablehead="Dist"
        description="Distance to the planetary nebula in kiloparsecs."
        verbLevel="15"/>

      <column name="Ne_SII"
        type="double precision"
        unit="cm**-3"
        ucd="phys.density;phys.electron"
        tablehead="Ne_[SII]"
        description="Electron density derived from the [SII] 6717/6731 line ratio."
        verbLevel="15"/>
    <column name="Ne_SII_err"
        type="double precision"
        unit="cm**-3"
        ucd="stat.error;phys.density;phys.electron"
        tablehead="Ne_[SII]_err"
        description="Uncertainty in electron density from [SII] lines."
        verbLevel="15"/>
    <column name="Ne_SII_power"
        type="integer"
        ucd="arith.factor" 
        tablehead="Ne_[SII]_power"
        description="Power of 10 to apply to Ne_[SII] value (i.e., Ne × 10^power)."
        verbLevel="15">
        <values nullLiteral="-9999"/></column>

    <column name="T_HI"
        type="double precision"
        unit="K"
        ucd="phys.temperature.effective"
        tablehead="T_HI"
        verbLevel="15"
        description="Effective temperature of the central star derived using the Zanstra method (based on H I Balmer discontinuity)."/>
    <column name="T_HI_err"
        type="double precision"
        unit="K"
        ucd="stat.error;phys.temperature.effective"
        tablehead="T_HI_err"
        verbLevel="15"
        description="Uncertainty in effective temperature T_HI."/>
    <column name="T_HI_power"
        type="integer"
        ucd="arith.factor" 
        tablehead="T_HI_pow"
        verbLevel="15"
        description="Power of 10 to apply to T_HI value.">
        <values nullLiteral="-9999"/></column>

    <column name="T0_OIII"
        type="double precision"
        unit="K" 
        ucd="phys.temperature.effective"
        tablehead="T0_[OIII]"
        verbLevel="15"
        description="Effective temperature of the central star at the beginning of observations, derived using the empirical method based on [O III] lines."/>
    <column name="T0_OIII_err"
        type="double precision"
        unit="K" 
        ucd="stat.error;phys.temperature.effective"
        tablehead="T0_[OIII]_err"
        verbLevel="15"
        description="Uncertainty in the effective temperature T0_[OIII]."/>
    <column name="T0_OIII_power"
        type="integer"
        ucd="arith.factor"
        tablehead="T0_pow"
        verbLevel="15"
        description="Power of 10 to apply to T0_[OIII] value.">
        <values nullLiteral="-9999"/></column>

    <column name="T1_OIII"
        type="double precision"
        unit="K"
        ucd="phys.temperature.effective"
        tablehead="T1_[OIII]"
        verbLevel="15"
        description="Effective temperature of the central star at the end of observations, derived using the empirical method based on [O III] lines."/>
    <column name="T1_OIII_err"
        type="double precision"
        unit="K"
        ucd="stat.error;phys.temperature.effective"
        tablehead="T1_[OIII]_err"
        description="Uncertainty in the effective temperature T1_[OIII]."/>
    <column name="T1_OIII_power"
        type="integer"
        ucd="arith.factor"
        tablehead="T1_[OIII_]pow"
        description="Power of 10 to apply to T1_[OIII] value.">
        <values nullLiteral="-9999"/></column>

    <column name="delta_t_obs_year"
        type="double precision"
        unit="yr"
        ucd="time.duration;obs"
        tablehead="dt_obs"
        verbLevel="15"
        description="Time span in years between the first and last spectroscopic observations used in the analysis."/>
    <column name="delta_t_model_year"
        type="double precision"
        unit="yr"
        ucd="time.duration"
        tablehead="dt_model"
        verbLevel="15"
        description="Time interval in the photoionization model over which the observed variations are reproduced."/>

    <column name="model_number"
        type="integer"
        ucd="meta.id"
        tablehead="Model"
        description="Number of model from doi:10.1051/0004-6361/201526577.">
        <values nullLiteral="-1"/>
    </column>
    <column name="mass_prog_star"
        type="double precision"
        unit="solMass"
        ucd="phys.mass"
        tablehead="M_prog"
        description="Initial mass of the progenitor star in solar masses according to the selected model."/>

    <column name="age_year"
        type="double precision"
        unit="yr"
        ucd="time.age"
        tablehead="Age"
        description="Estimated age of the planetary nebula."
        verbLevel="15"/>

    <column name="obs_year" required="True"
        type="integer"
        unit="yr"
        ucd="time.epoch"
        tablehead="Obs_year1"
        description="Year of observation. If there is the second year, then the column means 'from' the year"
        verbLevel="1"/>
    <column name="obs_year_2"
        type="integer"
        unit="yr"
        ucd="time.epoch"
        tablehead="Obs_year2"
        description="Ending year of observation (if applicable). It means 'to' the year."
        verbLevel="1">
        <values nullLiteral="-1"/>
    </column>
    <column name="obs_month"
        type="text"
        ucd="time.epoch" 
        tablehead="Obs_month1"
        description="Month of first observation (if known). If there is the second month, then the column means 'from' the month"
        verbLevel="1"/>
    <column name="obs_month_2"
        type="text"
        ucd="time.epoch" 
        tablehead="Obs_month2"
        description="Ending month of observation (if applicable). It means 'to' the month"
        verbLevel="1"/>
    <column name="obs_day"
        type="text"
        ucd="time.epoch" 
        tablehead="Obs_day"
        description="Day of observation (if known)."
        verbLevel="1"/>

    <column name="F_H_beta"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line.Hbeta"
        tablehead="F(H_beta)"
        verbLevel="1"
        description="Observed H_beta flux in erg cm⁻² s⁻¹."/>
    <column name="F_H_beta_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line.Hbeta"
        tablehead="F(H_beta)_err"
        verbLevel="5"
        description="Uncertainty in the observed H_beta flux."/>
    <column name="F_H_beta_power"
        type="integer"
        ucd="arith.factor" 
        tablehead="F(H_beta)_pow"
        verbLevel="1"
        description="Power of 10 to apply to the Hβ flux (F × 10^power).">
        <values nullLiteral="-9999"/></column>

    <column name="HeII_4685"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="HeII_4685"
        verbLevel="1"
        description="Observed flux of the He II 4685 Angstrom line."/>
    <column name="HeII_4685_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="HeII_4685_err"
        verbLevel="5"
        description="Uncertainty in the He II 4685 Angstrom flux."/>

    <column name="OIII_5007"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line.OIII"
        tablehead="[OIII]_5007"
        verbLevel="1"
        description="Observed flux of the [O III] 5007 Angstrom line."/>
    <column name="OIII_5007_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line.OIII"
        tablehead="[OIII]_5007_err"
        verbLevel="5"
        description="Uncertainty in the [O III] 5007 Angstrom flux."/>

    <column name="H_alpha_6563"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line.Halpha"
        tablehead="H_alpha"
        verbLevel="1"
        description="Observed flux of the Hα 6563 Angstrom line."/>
    <column name="H_alpha_6563_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line.Halpha"
        tablehead="H_alpha_err"
        verbLevel="5"
        description="Uncertainty in the H_alpha 6563 Angstrom flux."/>

    <column name="NII_6583"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="[NII]_6583"
        verbLevel="1"
        description="Observed flux of the [N II] 6583 Angstrom line."/>
    <column name="NII_6583_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="[NII]_6583_err"
        verbLevel="5"
        description="Uncertainty in the [N II] 6583 Angstrom flux."/>

    <column name="HeI_6678"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="HeI_6678"
        verbLevel="1"
        description="Observed flux of the He I 6678 Angstrom line."/>
     <column name="HeI_6678_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="HeI_6678_err"
        verbLevel="5"
        description="Uncertainty in the He I 6678 Angstrom flux."/>

    <column name="SII_6717"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="[SII]_6717"
        verbLevel="1"
        description="Observed flux of the [S II] 6717 Angstrom line."/>
    <column name="SII_6717_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="[SII]_6717_err"
        description="Uncertainty in the [S II] 6717 Angstrom flux."/>

    <column name="SII_6731"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="[SII]_6731"
        verbLevel="1"
        description="Observed flux of the [S II] 6731 Angstrom line."/>
    <column name="SII_6731_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="[SII]_6731_err"
        verbLevel="5"
        description="Uncertainty in the [S II] 6731 Angstrom flux."/>

    <column name="HeI_7065"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="HeI_7065"
        verbLevel="1"
        description="Observed flux of the He I 7065 Angstrom line."/>
    <column name="HeI_7065_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="HeI_7065_err"
        verbLevel="5"
        description="Uncertainty in the He I 7065 Angstrom flux."/>

    <column name="ArIII_7136"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="[ArIII]_7136"
        verbLevel="1"
        description="Observed flux of the [Ar III] 7136 Angstrom line."/>
    <column name="ArIII_7136_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="[ArIII]_7136_err"
        verbLevel="5"
        description="Uncertainty in the [Ar III] 7136 Angstrom flux."/>

    <column name="OI_7324"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="phot.flux;em.line"
        tablehead="[OI]_7324"
        verbLevel="1"
        description="Observed flux of the [O I] 7324 Angstrom line."/>
    <column name="OI_7324_err"
        type="double precision"
        unit="erg.cm**-2.s**-1"
        ucd="stat.error;phot.flux;em.line"
        tablehead="[OI]_7324_err"
        verbLevel="1"
        description="Uncertainty in the [O I] 7324 Angstrom flux."/>

    <column name="spec_ref"
        type="text"
        ucd="meta.bib.bibcode"
        tablehead="Ref"
        verbLevel="15"
        description="Reference code for spectroscopic data source. Only provided for Hβ and related absolute line fluxes."/>
  </table>

  <data id="import">
    <sources pattern="data/pn_abs_spec.csv"/>

    <csvGrammar/>
    <make table="main">
      <rowmaker idmaps="*">
        <map key="Diam_arcsec" source="2R_arcsec"/>
        <map key="Diam_sign" source="2R_sign"/>
        <map key="Diam_pc" source="2R_pc"/>
        <map key="Dist_kpc" source="D_kpc"/>
        
        <map key="Ne_SII" source="Ne_[SII]"/>
        <map key="Ne_SII_err" source="Ne_[SII]_err"/>
        <map key="Ne_SII_power" source="Ne_[SII]_power"/>
        
        <map key="T0_OIII" source="T0_[OIII]"/>
        <map key="T0_OIII_err" source="T0_[OIII]_err"/>
        <!-- The deployed legacy CSV has this column headed "4" rather than
             "T0_[OIII]_power".  Prefer the descriptive header when present,
             but keep importing the existing archive without rewriting it. -->
        <map key="T0_OIII_power">parseInt(vars.get("T0_[OIII]_power", vars.get("4")))</map>
        <map key="T1_OIII" source="T1_[OIII]"/>
        <map key="T1_OIII_err" source="T1_[OIII]_err"/>
        <map key="T1_OIII_power" source="T1_[OIII]_power"/>

        <map key="OIII_5007" source="[OIII]_5007"/>
        <map key="OIII_5007_err" source="[OIII]_5007_err"/>

        <map key="NII_6583" source="[NII]_6583"/>
        <map key="NII_6583_err" source="[NII]_6583_err"/>

        <map key="SII_6717" source="[SII]_6717"/>
        <map key="SII_6717_err" source="[SII]_6717_err"/>
        <map key="SII_6731" source="[SII]_6731"/>
        <map key="SII_6731_err" source="[SII]_6731_err"/>

        <map key="HeI_6678" source="HeI_6678"/>
        <map key="HeI_6678_err" source="HeI_6678_err"/>
        <map key="F_H_beta" source="F(H_beta)"/>
        <map key="F_H_beta_err" source="F(H_beta)_err"/>
        <map key="F_H_beta_power" source="F(H_beta)_power"/>

        <map key="ArIII_7136" source="[ArIII]_7136"/>
        <map key="ArIII_7136_err" source="[ArIII]_7136_err"/>
        <map key="OI_7324" source="[OI]_7324"/>
        <map key="OI_7324_err" source="[OI]_7324_err"/>
      </rowmaker>
    </make>
  </data>

  <service id="q" allowed="form">
    <meta name="shortName">PN Abs Spec</meta>
    <publish render="form" sets="ivo_managed, local"/>
    <dbCore queriedTable="main">
      <condDesc>
        <inputKey name="name" type="text"
          ucd="meta.id;src"
          description="Search by object name or alternative name."/>
        <phraseMaker>
          <code>
            val = inPars.get("name")
            if not val:
                return
            key1 = base.getSQLKey("object", "%" + val.replace(" ", "") + "%", outPars)
            key2 = base.getSQLKey("alt_name", "%" + val.replace(" ", "") + "%", outPars)
            yield "(UPPER(REPLACE(object, ' ', '')) LIKE UPPER(%%(%s)s) OR UPPER(REPLACE(alt_name, ' ', '')) LIKE UPPER(%%(%s)s))" % (key1, key2)
          </code>
        </phraseMaker>
      </condDesc>
      <condDesc buildFrom="Diam_arcsec"/>
      <condDesc buildFrom="Diam_pc"/>
      <condDesc buildFrom="Dist_kpc"/>
      <condDesc buildFrom="age_year"/>
    </dbCore>
  </service>

  <regSuite title="pn_spec_res_table regression">

  <regTest title="Test TAP access by date-obs">
    <url parSet="TAP"
          QUERY = "SELECT * from pn_spec_res_table.main
          WHERE object='PK232-4.7' AND obs_year=1971"
          >/tap/sync</url>
   <code>
    row = self.getFirstVOTableRow()
    self.assertAlmostEqual(row['F_H_beta'],1.3)
    self.assertAlmostEqual(row['mass_prog_star'],1.25)
    self.assertEqual(row['model_number'],3)
   </code>
  </regTest>

  </regSuite>
</resource>
