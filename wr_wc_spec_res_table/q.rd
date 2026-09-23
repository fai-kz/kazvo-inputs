<resource schema="wr_wc_wo_sequence" resdir=".">
	<meta name="creationDate">2025-10-17T15:58:00</meta>
	<meta name="title">Photometric and Spectral Data of Galactic Wolf-Rayet Stars (WC and WO sequence)</meta>
	<meta name="description" format="rst">
			This catalogue contains results of **photometric and spectral observations** 
			of seven Galactic **Wolf–Rayet stars** of the **WC and WO sequences**, 
			obtained in 2021–2022 at the *Fesenkov Astrophysical Institute (FAI), Kazakhstan*.

			The observing programme included moderately bright stars (mostly fainter than *V = 10m*) 
			observed in **B**, **V**, and **Rc** photometric filters, 
			as well as **medium-resolution spectra** for measuring absolute fluxes 
			in prominent emission lines.

			For each object, the table provides:
				* identifiers (WR catalogue number, alternative name),
				* spectral subtype,
				* equatorial coordinates (J2000),
				* literature photometry (B_cat, V_cat) and reference codes,
				* date of observation and Julian Date (JD−2400000),
				* measured **B**, **V**, **Rc** magnitudes with their errors,
				* and absolute fluxes and equivalent widths for a set of emission lines, including  
					**C III λ4650**, **He II λ4686**, **C IV λ5017**, **He II λ5411**,  
					**He II + C IV λ6560**, **C III λ6744**, **C IV λ7065**, and **C II λ7234**.

			These data were **first published** in the paper  
			*“Photometric and Spectral Studies of a Group of Galactic Wolf–Rayet Stars. II. WC and WO Sequences”*,  
			*Astrophysics*, **Vol. 67, No. 1 (February 2024)**,  
			by *L.N. Kondratyeva, I.V. Reva, E.K. Denisyuk, S.A. Shomshekova, A.K. Aimanova*.  
			DOI: `10.54503/0002-3051-2024.77.1-13`
	</meta>	
	<meta name="subject">massive-stars</meta>
	<meta name="subject">wolf-rayet-stars</meta>
	<meta name="subject">spectroscopy</meta>
	<meta name="subject">bv-photometry</meta>
	<meta name="subject">ccd-photometry</meta>
	<meta name="subject">johnson-photometry</meta>
	<meta name="subject">photometry</meta>
	<meta name="subject">stellar-photometry</meta>
	<meta name="subject">variable-stars</meta>
	
	<meta name="source">10.54503/0002-3051-2024.77.1-13</meta>
	<meta name="creator">L.N. Kondratyeva, I.V. Reva, E.K. Denissyuk, S.A. Shomshekova, A.K. Aimanova</meta>
	<meta name="facility">Fesenkov Astrophysical Institute</meta>
	<meta name="instrument">AZT-8</meta>
	
	<meta name="coverage.waveband">Optical</meta>
	<meta name="coverage.spectral">4.34e-7 7.26e-7</meta>
	<meta name="coverage.temporal">59216 59914</meta>
	<meta name="coverage.region">Milky Way</meta>
	<meta name="contentLevel">Research</meta>
	
	<table id="main" onDisk="True" adql="True">
		<column name="object"
			type="text"
			ucd="meta.id;src"
			tablehead="Object"
			description="WR catalogue number of the star."
			verbLevel="1"/>

		<column name="alt_name"
			type="text"
			ucd="meta.id;src"
			tablehead="Alt. name"
			description="Alternative identifier of the star (e.g., HD, BD number)."
			verbLevel="1"/>

		<column name="sp"
			type="text"
			ucd="src.spType"
			tablehead="Sp. type"
			description="Spectral type of the star."
			verbLevel="1"/>

		<column name="ra"
			type="double precision"
			ucd="pos.eq.ra;meta.main"
			unit="deg"
			tablehead="RA(J2000)"
			description="Right Ascension (J2000) of the star in decimal degrees."
			verbLevel="1"/>

		<column name="dec"
			type="double precision"
			ucd="pos.eq.dec;meta.main"
			unit="deg"
			tablehead="Dec(J2000)"
			description="Declination (J2000) of the star in decimal degrees."
			verbLevel="1"/>

		<column name="B_cat"
			type="real"
			ucd="phot.mag;em.opt.B"
			unit="mag"
			tablehead="B_cat"
			description="Catalogue B magnitude from literature."
			verbLevel="1"/>

		<column name="V_cat"
			type="real"
			ucd="phot.mag;em.opt.V"
			unit="mag"
			tablehead="V_cat"
			description="Catalogue V magnitude from literature."
			verbLevel="1"/>

		<column name="mag_ref"
			type="text"
			ucd="meta.bib"
			tablehead="Mag ref"
			description="Reference code for the catalogue magnitudes."
			verbLevel="1"/>

		<column name="date_obs"
			type="date"
			ucd="time.epoch"
			tablehead="Obs. date"
			description="UTC date of the observation."
			verbLevel="1"/>

		<column name="B_mag"
			type="real"
			ucd="phot.mag;em.opt.B"
			unit="mag"
			tablehead="B"
			description="Measured B magnitude from observations."
			verbLevel="1"/>

		<column name="B_mag_err"
			type="real"
			ucd="stat.error;phot.mag;em.opt.B"
			unit="mag"
			tablehead="e_B"
			description="Uncertainty in the measured B magnitude."
			verbLevel="1"/>

		<column name="V_mag"
			type="real"
			ucd="phot.mag;em.opt.V"
			unit="mag"
			tablehead="V"
			description="Measured V magnitude from observations."
			verbLevel="1"/>

		<column name="V_mag_err"
			type="real"
			ucd="stat.error;phot.mag;em.opt.V"
			unit="mag"
			tablehead="e_V"
			description="Uncertainty in the measured V magnitude."
			verbLevel="1"/>

		<column name="Rc_mag"
			type="real"
			ucd="phot.mag;em.opt.R"
			unit="mag"
			tablehead="Rc"
			description="Measured Cousins R magnitude from observations."
			verbLevel="1"/>

		<column name="Rc_mag_err"
			type="real"
			ucd="stat.error;phot.mag;em.opt.R"
			unit="mag"
			tablehead="e_Rc"
			description="Uncertainty in the measured Cousins R magnitude."
			verbLevel="1"/>

		<column name="HeII_CIV_4340_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII CIV 4340)"
			description="Absolute flux of HeII and CIV λ4340 blend."
			verbLevel="1"/>

		<column name="HeII_CIV_4340_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII CIV 4340)"
			description="Equivalent width of HeII and CIV λ4340 blend."
			verbLevel="1"/>

		<column name="CIII_CIV_4444_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII CIV 4444)"
			description="Absolute flux of CIII and CIV λ4444 blend."
			verbLevel="1"/>

		<column name="CIII_CIV_4444_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII CIV 4444)"
			description="Equivalent width of CIII and CIV λ4444 blend."
			verbLevel="1"/>

	<column name="CIII_HeII_4515_4540_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII HeII 4515 4540)"
			description="Absolute flux of CIII and HeII λ4515 and 4540 blend."
			verbLevel="1"/>

	<column name="CIII_HeII_4515_4540_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII HeII 4515 4540)"
			description="Equivalent width of CIII and HeII λ4515 and 4540 blend."
			verbLevel="1"/>

	<column name="HeII_4540_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 4540)"
			description="Absolute flux of HeII III λ4540 emission line."
			verbLevel="1"/>

	<column name="HeII_4540_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 4540)"
			description="Equivalent width of HeII λ4540 emission line."
			verbLevel="1"/>

	<column name="CIII_4619_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII 4619)"
			description="Absolute flux of CIII λ4619 emission line."
			verbLevel="1"/>

	<column name="CIII_4619_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII 4619)"
			description="Equivalent width of CIII λ4619 emission line."
			verbLevel="1"/>

	<column name="CIV_HeII_4650_4686_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4650 4686)"
			description="Absolute flux of CIV and HeII λ4650 and 4686 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4650_4686_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeII 4650 4686)"
			description="Equivalent width of CIV and HeII λ4650–4686 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4650_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4650)"
			description="Absolute flux of CIV and HeII λ4650 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4650_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeII 4650)"
			description="Equivalent width of CIV and HeII λ4650 blend."
			verbLevel="1"/>

	<column name="CIV_4656_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 4656)"
			description="Absolute flux of CIV λ4656 emission line."
			verbLevel="1"/>

	<column name="CIV_4656_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 4656)"
			description="Equivalent width of CIV λ4656 emission line."
			verbLevel="1"/>

	<column name="CIII_CIV_4656_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII CIV 4656)"
			description="Absolute flux of CII and CIV λ4656 blend."
			verbLevel="1"/>

	<column name="CIII_CIV_4656_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII CIV 4656)"
			description="Equivalent width of CIII and CIV λ4656 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4660_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4660)"
			description="Absolute flux of CIV and HeII λ4660 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4660_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV_HeII_4660)"
			description="Equivalent width of CIV and HeII λ4660 blend."
			verbLevel="1"/>

	<column name="CIV_4660_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 4660)"
			description="Absolute flux of CIV λ4660 emission line."
			verbLevel="1"/>

	<column name="CIV_4660_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 4660)"
			description="Equivalent width of CIV λ4660 emission line."
			verbLevel="1"/>

	<column name="CIV_HeII_4686_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4686)"
			description="Absolute flux of CIV λ4686 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4686_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeII 4686)"
			description="Equivalent width of CIV and HeII λ4686 blend."
			verbLevel="1"/>

	<column name="HeII_4686_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 4686)"
			description="Absolute flux of HeII λ4686 emission line."
			verbLevel="1"/>

	<column name="HeII_4686_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 4686)"
			description="Equivalent width of HeII λ4686 emission line."
			verbLevel="1"/>

	<column name="OIV_CIV_4780_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(OIV CIV 4780)"
			description="Absolute flux of OIV and CIV λ4945 blend."
			verbLevel="1"/>

	<column name="OIV_CIV_4780_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(OIV CIV 4780)"
			description="Equivalent width of OIV and CIV λ4945 blend."
			verbLevel="1"/>
	
	<column name="CII_4780_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII 4780)"
			description="Absolute flux of СII λ4780 emission line."
			verbLevel="1"/>

	<column name="CII_4780_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII 4780)"
			description="Equivalent width of СII λ4780 emission line."
			verbLevel="1"/>

	<column name="HeII_4860_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII_4860)"
			description="Absolute flux of HeII λ4860 emission line."
			verbLevel="1"/>

	<column name="HeII_4860_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 4860)"
			description="Equivalent width of HeII λ4860 emission line."
			verbLevel="1"/>

	<column name="CIV_HeII_4860_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4860)"
			description="Absolute flux of CIV and HeII λ4860 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4860_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeII 4860)"
			description="Equivalent width of CIV  and HeII λ4860 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4861_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeII 4861)"
			description="Absolute flux of CIV and HeII λ4861 blend."
			verbLevel="1"/>

	<column name="CIV_HeII_4861_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeII 4861)"
			description="Equivalent width of CIV  and HeII λ4861 blend."
			verbLevel="1"/>

	<column name="HeI_4921_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeI 4921)"
			description="Absolute flux of HeI λ4921 emission line."
			verbLevel="1"/>

	<column name="HeI_4921_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeI 4921)"
			description="Equivalent width of HeI λ4921 emission line."
			verbLevel="1"/>

	<column name="HeII_4921_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 4921)"
			description="Absolute flux of HeII λ4921 emission line."
			verbLevel="1"/>

	<column name="HeII_4921_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 4921)"
			description="Equivalent width of HeII λ4921 emission line."
			verbLevel="1"/>

	<column name="OV_4930_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(OV 4930)"
			description="Absolute flux of OV λ4930 emission line."
			verbLevel="1"/>

	<column name="OV_4930_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(OV 4930)"
			description="Equivalent width of OV λ4930 emission line."
			verbLevel="1"/>

	<column name="OV_4940_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(OV 4940)"
			description="Absolute flux of OV λ4940 emission line."
			verbLevel="1"/>

	<column name="OV_4940_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(OV 4940)"
			description="Equivalent width of OV λ4940 emission line."
			verbLevel="1"/>

	<column name="HeII_4940_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 4940)"
			description="Absolute flux of HeII λ4940 emission line."
			verbLevel="1"/>

	<column name="HeII_4940_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 4940)"
			description="Equivalent width of HeII λ4940 emission line."
			verbLevel="1"/>

	<column name="CIV_5016_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 5016)"
			description="Absolute flux of CIV λ5016 emission line."
			verbLevel="1"/>

	<column name="CIV_5016_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 5016)"
			description="Equivalent width of CIV λ5016 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_5016_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeI 5016)"
			description="Absolute flux of CIV and HeI λ5016 blend."
			verbLevel="1"/>

	<column name="CIV_HeI_5016_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeI 5016)"
			description="Equivalent width of CIV and HeI λ5016 blend."
			verbLevel="1"/>

	<column name="CIV_5017_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 5017)"
			description="Absolute flux of CIV λ5017 emission line."
			verbLevel="1"/>

	<column name="CIV_5017_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 5017)"
			description="Equivalent width of CIV λ5017 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_5017_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV HeI 5017)"
			description="Absolute flux of CIV and HeI λ5017 blend."
			verbLevel="1"/>

	<column name="CIV_HeI_5017_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV HeI 5017)"
			description="Equivalent width of CIV and HeI λ5017 blend."
			verbLevel="1"/>

	<column name="CII_CIII_5141_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII CIII 5141)"
			description="Absolute flux of CII and CIII λ5141 blend."
			verbLevel="1"/>

	<column name="CII_CIII_5141_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII CIII 5141)"
			description="Equivalent width of CII and CIII  λ5141 blend."
			verbLevel="1"/>

	<column name="CIII_5250_5270_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII_5250_5270)"
			description="Absolute flux of CIII λ5250 and 5270 emission line."
			verbLevel="1"/>

	<column name="CIII_5250_5270_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII_5250_5270)"
			description="Equivalent width of CIII λ5250 and 5270 emission line."
			verbLevel="1"/>

	<column name="CIII_5250_5305_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII 5250+5305)"
			description="Absolute flux of CIII λ5250+5305 emission blend."
			verbLevel="1"/>

	<column name="CIII_5250_5305_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII 5250+5305)"
			description="Equivalent width of CIII λ5250+5305 emission blend."
			verbLevel="1"/>

	<column name="CIII_OIV_5260_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII+OIV 5260)"
			description="Absolute flux of CIII + OIV λ5260 emission line."
			verbLevel="1"/>

	<column name="CIII_OIV_5260_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII+OIV 5260)"
			description="Equivalent width of CIII + OIV λ5260 emission line."
			verbLevel="1"/>

	<column name="OVI_5280_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(OVI 5280)"
			description="Absolute flux of OVI λ5280 emission line."
			verbLevel="1"/>

	<column name="OVI_5280_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(OVI 5280)"
			description="Equivalent width of OVI λ5280 emission line."
			verbLevel="1"/>

	<column name="CIII_5305_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII 5305)"
			description="Absolute flux of CIII λ5305 emission line."
			verbLevel="1"/>

	<column name="CIII_5305_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII 5305)"
			description="Equivalent width of CIII λ5305 emission line."
			verbLevel="1"/>

	<column name="HeII_5411_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 5411)"
			description="Absolute flux of HeII λ5411 emission line."
			verbLevel="1"/>

	<column name="HeII_5411_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 5411)"
			description="Equivalent width of HeII λ5411 emission line."
			verbLevel="1"/>

	<column name="HeII_CIV_5411_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII+CIV 5411)"
			description="Absolute flux of HeII + CIV λ5411 emission blend."
			verbLevel="1"/>

	<column name="HeII_CIV_5411_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII+CIV 5411)"
			description="Equivalent width of HeII + CIV λ5411 emission blend."
			verbLevel="1"/>

	<column name="HeII_CIII_5411_5470_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII+CIII 5411–5470)"
			description="Absolute flux of HeII + CIII λ5411–5470 emission feature."
			verbLevel="1"/>

	<column name="HeII_CIII_5411_5470_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII+CIII 5411–5470)"
			description="Equivalent width of HeII + CIII λ5411–5470 emission feature."
			verbLevel="1"/>

	<column name="CVI_5440_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CVI 5440)"
			description="Absolute flux of CVI λ5440 emission line."
			verbLevel="1"/>

	<column name="CVI_5440_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CVI 5440)"
			description="Equivalent width of CVI λ5440 emission line."
			verbLevel="1"/>

	<column name="CIV_5460_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 5460)"
			description="Absolute flux of CIV λ5460 emission line."
			verbLevel="1"/>

	<column name="CIV_5460_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 5460)"
			description="Equivalent width of CIV λ5460 emission line."
			verbLevel="1"/>

	<column name="CIV_5469_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 5469)"
			description="Absolute flux of CIV λ5469 emission line."
			verbLevel="1"/>

	<column name="CIV_5469_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 5469)"
			description="Equivalent width of CIV λ5469 emission line."
			verbLevel="1"/>

	<column name="CIV_5471_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 5471)"
			description="Absolute flux of CIV λ5471 emission line."
			verbLevel="1"/>

	<column name="CIV_5471_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 5471)"
			description="Equivalent width of CIV λ5471 emission line."
			verbLevel="1"/>

	<column name="HeII_CIV_5595_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII+CIV 5595)"
			description="Absolute flux of HeII + CIV λ5595 emission blend."
			verbLevel="1"/>

	<column name="HeII_CIV_5595_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII+CIV 5595)"
			description="Equivalent width of HeII + CIV λ5595 emission blend."
			verbLevel="1"/>

	<column name="HeII_CIV_6560_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII+CIV 6560)"
			description="Absolute flux of HeII + CIV λ6560 emission blend."
			verbLevel="1"/>

	<column name="HeII_CIV_6560_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII+CIV 6560)"
			description="Equivalent width of HeII + CIV λ6560 emission blend."
			verbLevel="1"/>

	<column name="HeII_6560_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeII 6560)"
			description="Absolute flux of HeII λ6560 emission line."
			verbLevel="1"/>

	<column name="HeII_6560_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeII 6560)"
			description="Equivalent width of HeII λ6560 emission line."
			verbLevel="1"/>

	<column name="CII_HeII_6580_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII+HeII 6580)"
			description="Absolute flux of blended CII + HeII λ6580 emission line."
			verbLevel="1"/>

	<column name="CII_HeII_6580_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII+HeII 6580)"
			description="Equivalent width of blended CII + HeII λ6580 emission line."
			verbLevel="1"/>

	<column name="HeI_6678_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeI 6678)"
			description="Absolute flux of HeI λ6678 emission line."
			verbLevel="1"/>

	<column name="HeI_6678_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeI 6678)"
			description="Equivalent width of HeI λ6678 emission line."
			verbLevel="1"/>

	<column name="CII_CIII_6732_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII+CIII 6732)"
			description="Absolute flux of CII + CIII λ6732 emission line."
			verbLevel="1"/>

	<column name="CII_CIII_6732_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII+CIII 6732)"
			description="Equivalent width of CII + CIII λ6732 emission line."
			verbLevel="1"/>

	<column name="CIII_6740_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII 6740)"
			description="Absolute flux of CIII λ6740 emission line."
			verbLevel="1"/>

	<column name="CIII_6740_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII 6740)"
			description="Equivalent width of CIII λ6740 emission line."
			verbLevel="1"/>

	<column name="CIII_CII_6744_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII+CII 6744)"
			description="Absolute flux of CIII + CII λ6744 emission blend."
			verbLevel="1"/>

	<column name="CIII_CII_6744_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII+CII 6744)"
			description="Equivalent width of CIII + CII λ6744 emission blend."
			verbLevel="1"/>

	<column name="CIII_CIV_6748_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII+CIV 6748)"
			description="Absolute flux of CIII + CIV λ6748 emission line."
			verbLevel="1"/>

	<column name="CIII_CIV_6748_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII+CIV 6748)"
			description="Equivalent width of CIII + CIV λ6748 emission line."
			verbLevel="1"/>

	<column name="CI_CIII_6748_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CI+CIII 6748)"
			description="Absolute flux of CI + CIII λ6748 emission line."
			verbLevel="1"/>

	<column name="CI_CIII_6748_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CI+CIII 6748)"
			description="Equivalent width of CI + CIII λ6748 emission line."
			verbLevel="1"/>

	<column name="CII_CIII_6780_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII+CIII 6780)"
			description="Absolute flux of CII + CIII λ6780 emission line."
			verbLevel="1"/>

	<column name="CII_CIII_6780_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII+CIII 6780)"
			description="Equivalent width of CII + CIII λ6780 emission line."
			verbLevel="1"/>

	<column name="CIII_7037_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIII 7037)"
			description="Absolute flux of CIII λ7037 emission line."
			verbLevel="1"/>

	<column name="CIII_7037_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIII 7037)"
			description="Equivalent width of CIII λ7037 emission line."
			verbLevel="1"/>

	<column name="CIV_7060_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV 7060)"
			description="Absolute flux of CIV λ7060 emission line."
			verbLevel="1"/>

	<column name="CIV_7060_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV 7060)"
			description="Equivalent width of CIV λ7060 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_7060_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV+HeI 7060)"
			description="Absolute flux of blended CIV + HeI λ7060 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_7060_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV+HeI 7060)"
			description="Equivalent width of blended CIV + HeI λ7060 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_7065_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV+HeI 7065)"
			description="Absolute flux of blended CIV + HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="CIV_HeI_7065_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV+HeI 7065)"
			description="Equivalent width of blended CIV + HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="CII_HeI_7065_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII+HeI 7065)"
			description="Absolute flux of blended CII + HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="CII_HeI_7065_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII+HeI 7065)"
			description="Equivalent width of blended CII + HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="CIV_CII_7065_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CIV+CII 7065)"
			description="Absolute flux of blended CIV + CII λ7065 emission line."
			verbLevel="1"/>

	<column name="CIV_CII_7065_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CIV+CII 7065)"
			description="Equivalent width of blended CIV + CII λ7065 emission line."
			verbLevel="1"/>

	<column name="HeI_7065_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(HeI 7065)"
			description="Absolute flux of HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="HeI_7065_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(HeI 7065)"
			description="Equivalent width of HeI λ7065 emission line."
			verbLevel="1"/>

	<column name="CII_7122_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII 7122)"
			description="Absolute flux of CII λ7122 emission line."
			verbLevel="1"/>

	<column name="CII_7122_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII 7122)"
			description="Equivalent width of CII λ7122 emission line."
			verbLevel="1"/>

	<column name="CII_7207_7258_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII 7207–7258)"
			description="Absolute flux of CII λ7207–7258 emission feature."
			verbLevel="1"/>

	<column name="CII_7207_7258_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII 7207–7258)"
			description="Equivalent width of CII λ7207–7258 emission feature."
			verbLevel="1"/>

	<column name="CII_7234_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII 7234)"
			description="Absolute flux of CII λ7234 emission line."
			verbLevel="1"/>

	<column name="CII_7234_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII 7234)"
			description="Equivalent width of CII λ7234 emission line."
			verbLevel="1"/>

	<column name="Unknown_7254_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(7254)"
			description="Absolute flux of λ7254 emission line."
			verbLevel="1"/>

	<column name="Unknown_7254_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(7254)"
			description="Equivalent width of λ7254 emission line."
			verbLevel="1"/>

	<column name="CII_7260_Fabs"
			type="real"
			ucd="phot.flux;em.line"
			unit="W.m**-2"
			tablehead="F(CII 7260)"
			description="Absolute flux of CII λ7260 emission line."
			verbLevel="1"/>

	<column name="CII_7260_EW"
			type="real"
			ucd="spect.line.eqWidth"
			unit="Angstrom"
			tablehead="EW(CII 7260)"
			description="Equivalent width of CII λ7260 emission line."
			verbLevel="1"/>

	</table>

	<data id="import">
		<sources pattern="data/WR_spec_result_WC_WO.csv"/>
		<make table="main">
			<rowmaker id="rm">
				<!-- имена: подрежем пробелы на входе -->
				<map key="object">@object</map>
				<map key="alt_name">@alt_name</map>
				<map key="sp">@sp</map>

				<!-- координаты из H:M:S / D:M:S в градусы -->
				<map key="ra">hmsToDeg(@ra, " ")</map>
				<map key="dec">dmsToDeg(@dec, " ")</map>

				<!-- фотометрия каталожная (если есть в CSV) -->
				<map key="B_cat">parseFloat(@B_cat)</map>
				<map key="V_cat">parseFloat(@V_cat)</map>
				<map key="mag_ref">@mag_ref</map>

				<!-- дата наблюдения: в ISO8601; если в CSV уже ISO, parseISODT просто вернёт datetime -->
				<map key="date_obs">parseDate(@date_obs)</map>
				<!-- при желании — MJD из той же даты (если есть колонка obs_mjd в таблице) -->
				<!-- <map key="obs_mjd">dateTimeToMJD(parseISODT(@date_obs))</map>-->

				<!-- фотометрия из наблюдений -->
				<map key="B_mag">parseFloat(killBlanks(@B_mag))</map>
				<map key="B_mag_err">parseFloat(killBlanks(@B_mag_err))</map>
				<map key="V_mag">parseFloat(killBlanks(@V_mag))</map>
				<map key="V_mag_err">parseFloat(killBlanks(@V_mag_err))</map>
				<map key="Rc_mag">parseFloat(@Rc_mag)</map>
				<map key="Rc_mag_err">parseFloat(@Rc_mag_err)</map>



				<map key="HeII_CIV_4340_Fabs">parseFloat(@HeII_CIV_4340_Fabs)</map>
				<map key="HeII_CIV_4340_EW">parseFloat(@HeII_CIV_4340_EW)</map>
				<map key="CIII_CIV_4444_Fabs">parseFloat(@CIII_CIV_4444_Fabs)</map>
				<map key="CIII_CIV_4444_EW">parseFloat(@CIII_CIV_4444_EW)</map>
				<map key="CIII_HeII_4515_4540_Fabs">parseFloat(@CIII_HeII_4515_4540_Fabs)</map>
				<map key="CIII_HeII_4515_4540_EW">parseFloat(@CIII_HeII_4515_4540_EW)</map>
				<map key="HeII_4540_Fabs">parseFloat(@HeII_4540_Fabs)</map>
				<map key="HeII_4540_EW">parseFloat(@HeII_4540_EW)</map>
				<map key="CIII_4619_Fabs">parseFloat(@CIII_4619_Fabs)</map>
				<map key="CIII_4619_EW">parseFloat(@CIII_4619_EW)</map>
				<map key="CIV_HeII_4650_4686_Fabs">parseFloat(@CIV_HeII_4650_4686_Fabs)</map>
				<map key="CIV_HeII_4650_4686_EW">parseFloat(@CIV_HeII_4650_4686_EW)</map>
				<map key="CIV_HeII_4650_Fabs">parseFloat(@CIV_HeII_4650_Fabs)</map>
				<map key="CIV_HeII_4650_EW">parseFloat(@CIV_HeII_4650_EW)</map>
				<map key="CIV_4656_Fabs">parseFloat(@CIV_4656_Fabs)</map>
				<map key="CIV_4656_EW">parseFloat(@CIV_4656_EW)</map>
				<map key="CIII_CIV_4656_Fabs">parseFloat(@CIII_CIV_4656_Fabs)</map>
				<map key="CIII_CIV_4656_EW">parseFloat(@CIII_CIV_4656_EW)</map>
				<map key="CIV_HeII_4660_Fabs">parseFloat(@CIV_HeII_4660_Fabs)</map>
				<map key="CIV_HeII_4660_EW">parseFloat(@CIV_HeII_4660_EW)</map>
				<map key="CIV_4660_Fabs">parseFloat(@CIV_4660_Fabs)</map>
				<map key="CIV_4660_EW">parseFloat(@CIV_4660_EW)</map>
				<map key="CIV_HeII_4686_Fabs">parseFloat(@CIV_HeII_4686_Fabs)</map>
				<map key="CIV_HeII_4686_EW">parseFloat(@CIV_HeII_4686_EW)</map>
				<map key="HeII_4686_Fabs">parseFloat(@HeII_4686_Fabs)</map>
				<map key="HeII_4686_EW">parseFloat(@HeII_4686_EW)</map>
				<map key="OIV_CIV_4780_Fabs">parseFloat(@OIV_CIV_4780_Fabs)</map>
				<map key="OIV_CIV_4780_EW">parseFloat(@OIV_CIV_4780_EW)</map>
				<map key="CII_4780_Fabs">parseFloat(@CII_4780_Fabs)</map>
				<map key="CII_4780_EW">parseFloat(@CII_4780_EW)</map>
				<map key="HeII_4860_Fabs">parseFloat(@HeII_4860_Fabs)</map>
				<map key="HeII_4860_EW">parseFloat(@HeII_4860_EW)</map>
				<map key="CIV_HeII_4860_Fabs">parseFloat(@CIV_HeII_4860_Fabs)</map>
				<map key="CIV_HeII_4860_EW">parseFloat(@CIV_HeII_4860_EW)</map>
				<map key="CIV_HeII_4861_Fabs">parseFloat(@CIV_HeII_4861_Fabs)</map>
				<map key="CIV_HeII_4861_EW">parseFloat(@CIV_HeII_4861_EW)</map>
				<map key="HeI_4921_Fabs">parseFloat(@HeI_4921_Fabs)</map>
				<map key="HeI_4921_EW">parseFloat(@HeI_4921_EW)</map>
				<map key="HeII_4921_Fabs">parseFloat(@HeII_4921_Fabs)</map>
				<map key="HeII_4921_EW">parseFloat(@HeII_4921_EW)</map>
				<map key="OV_4930_Fabs">parseFloat(@OV_4930_Fabs)</map>
				<map key="OV_4930_EW">parseFloat(@OV_4930_EW)</map>
				<map key="OV_4940_Fabs">parseFloat(@OV_4940_Fabs)</map>
				<map key="OV_4940_EW">parseFloat(@OV_4940_EW)</map>
				<map key="HeII_4940_Fabs">parseFloat(@HeII_4940_Fabs)</map>
				<map key="HeII_4940_EW">parseFloat(@HeII_4940_EW)</map>
				<map key="CIV_5016_Fabs">parseFloat(@CIV_5016_Fabs)</map>
				<map key="CIV_5016_EW">parseFloat(@CIV_5016_EW)</map>
				<map key="CIV_HeI_5016_Fabs">parseFloat(@CIV_HeI_5016_Fabs)</map>
				<map key="CIV_HeI_5016_EW">parseFloat(@CIV_HeI_5016_EW)</map>
				<map key="CIV_5017_Fabs">parseFloat(@CIV_5017_Fabs)</map>
				<map key="CIV_5017_EW">parseFloat(@CIV_5017_EW)</map>
				<map key="CIV_HeI_5017_Fabs">parseFloat(@CIV_HeI_5017_Fabs)</map>
				<map key="CIV_HeI_5017_EW">parseFloat(@CIV_HeI_5017_EW)</map>
				<map key="CII_CIII_5141_Fabs">parseFloat(@CII_CIII_5141_Fabs)</map>
				<map key="CII_CIII_5141_EW">parseFloat(@CII_CIII_5141_EW)</map>
				<map key="CIII_5250_5270_Fabs">parseFloat(@CIII_5250_5270_Fabs)</map>
				<map key="CIII_5250_5270_EW">parseFloat(@CIII_5250_5270_EW)</map>
				<map key="CIII_5250_5305_Fabs">parseFloat(@CIII_5250_5305_Fabs)</map>
				<map key="CIII_5250_5305_EW">parseFloat(@CIII_5250_5305_EW)</map>
				<map key="CIII_OIV_5260_Fabs">parseFloat(@CIII_OIV_5260_Fabs)</map>
				<map key="CIII_OIV_5260_EW">parseFloat(@CIII_OIV_5260_EW)</map>
				<map key="OVI_5280_Fabs">parseFloat(@OVI_5280_Fabs)</map>
				<map key="OVI_5280_EW">parseFloat(@OVI_5280_EW)</map>
				<map key="CIII_5305_Fabs">parseFloat(@CIII_5305_Fabs)</map>
				<map key="CIII_5305_EW">parseFloat(@CIII_5305_EW)</map>
				<map key="HeII_5411_Fabs">parseFloat(@HeII_5411_Fabs)</map>
				<map key="HeII_5411_EW">parseFloat(@HeII_5411_EW)</map>
				<map key="HeII_CIV_5411_Fabs">parseFloat(@HeII_CIV_5411_Fabs)</map>
				<map key="HeII_CIV_5411_EW">parseFloat(@HeII_CIV_5411_EW)</map>
				<map key="HeII_CIII_5411_5470_Fabs">parseFloat(@HeII_CIII_5411_5470_Fabs)</map>
				<map key="HeII_CIII_5411_5470_EW">parseFloat(@HeII_CIII_5411_5470_EW)</map>
				<map key="CVI_5440_Fabs">parseFloat(@CVI_5440_Fabs)</map>
				<map key="CVI_5440_EW">parseFloat(@CVI_5440_EW)</map>
				<map key="CIV_5460_Fabs">parseFloat(@CIV_5460_Fabs)</map>
				<map key="CIV_5460_EW">parseFloat(@CIV_5460_EW)</map>
				<map key="CIV_5469_Fabs">parseFloat(@CIV_5469_Fabs)</map>
				<map key="CIV_5469_EW">parseFloat(@CIV_5469_EW)</map>
				<map key="CIV_5471_Fabs">parseFloat(@CIV_5471_Fabs)</map>
				<map key="CIV_5471_EW">parseFloat(@CIV_5471_EW)</map>
				<map key="HeII_CIV_5595_Fabs">parseFloat(@HeII_CIV_5595_Fabs)</map>
				<map key="HeII_CIV_5595_EW">parseFloat(@HeII_CIV_5595_EW)</map>
				<map key="HeII_CIV_6560_Fabs">parseFloat(@HeII_CIV_6560_Fabs)</map>
				<map key="HeII_CIV_6560_EW">parseFloat(@HeII_CIV_6560_EW)</map>
				<map key="HeII_6560_Fabs">parseFloat(@HeII_6560_Fabs)</map>
				<map key="HeII_6560_EW">parseFloat(@HeII_6560_EW)</map>
				<map key="CII_HeII_6580_Fabs">parseFloat(@CII_HeII_6580_Fabs)</map>
				<map key="CII_HeII_6580_EW">parseFloat(@CII_HeII_6580_EW)</map>
				<map key="HeI_6678_Fabs">parseFloat(@HeI_6678_Fabs)</map>
				<map key="HeI_6678_EW">parseFloat(@HeI_6678_EW)</map>
				<map key="CII_CIII_6732_Fabs">parseFloat(@CII_CIII_6732_Fabs)</map>
				<map key="CII_CIII_6732_EW">parseFloat(@CII_CIII_6732_EW)</map>
				<map key="CIII_6740_Fabs">parseFloat(@CIII_6740_Fabs)</map>
				<map key="CIII_6740_EW">parseFloat(@CIII_6740_EW)</map>
				<map key="CIII_CII_6744_Fabs">parseFloat(@CIII_CII_6744_Fabs)</map>
				<map key="CIII_CII_6744_EW">parseFloat(@CIII_CII_6744_EW)</map>
				<map key="CIII_CIV_6748_Fabs">parseFloat(@CIII_CIV_6748_Fabs)</map>
				<map key="CIII_CIV_6748_EW">parseFloat(@CIII_CIV_6748_EW)</map>
				<map key="CI_CIII_6748_Fabs">parseFloat(@CI_CIII_6748_Fabs)</map>
				<map key="CI_CIII_6748_EW">parseFloat(@CI_CIII_6748_EW)</map>
				<map key="CII_CIII_6780_Fabs">parseFloat(@CII_CIII_6780_Fabs)</map>
				<map key="CII_CIII_6780_EW">parseFloat(@CII_CIII_6780_EW)</map>
				<map key="CIII_7037_Fabs">parseFloat(@CIII_7037_Fabs)</map>
				<map key="CIII_7037_EW">parseFloat(@CIII_7037_EW)</map>
				<map key="CIV_7060_Fabs">parseFloat(@CIV_7060_Fabs)</map>
				<map key="CIV_7060_EW">parseFloat(@CIV_7060_EW)</map>
				<map key="CIV_HeI_7060_Fabs">parseFloat(@CIV_HeI_7060_Fabs)</map>
				<map key="CIV_HeI_7060_EW">parseFloat(@CIV_HeI_7060_EW)</map>
				<map key="CIV_HeI_7065_Fabs">parseFloat(@CIV_HeI_7065_Fabs)</map>
				<map key="CIV_HeI_7065_EW">parseFloat(@CIV_HeI_7065_EW)</map>
				<map key="CII_HeI_7065_Fabs">parseFloat(@CII_HeI_7065_Fabs)</map>
				<map key="CII_HeI_7065_EW">parseFloat(@CII_HeI_7065_EW)</map>
				<map key="CIV_CII_7065_Fabs">parseFloat(@CIV_CII_7065_Fabs)</map>
				<map key="CIV_CII_7065_EW">parseFloat(@CIV_CII_7065_EW)</map>
				<map key="HeI_7065_Fabs">parseFloat(@HeI_7065_Fabs)</map>
				<map key="HeI_7065_EW">parseFloat(@HeI_7065_EW)</map>
				<map key="CIV_HeI_7065_Fabs">parseFloat(@CIV_HeI_7065_Fabs)</map>
				<map key="CIV_HeI_7065_EW">parseFloat(@CIV_HeI_7065_EW)</map>
				<map key="CII_7122_Fabs">parseFloat(@CII_7122_Fabs)</map>
				<map key="CII_7122_EW">parseFloat(@CII_7122_EW)</map>
				<map key="CII_7207_7258_Fabs">parseFloat(@CII_7207_7258_Fabs)</map>
				<map key="CII_7207_7258_EW">parseFloat(@CII_7207_7258_EW)</map>
				<map key="CII_7234_Fabs">parseFloat(@CII_7234_Fabs)</map>
				<map key="CII_7234_EW">parseFloat(@CII_7234_EW)</map>
				<map key="Unknown_7254_Fabs">parseFloat(@Unknown_7254_Fabs)</map>
				<map key="Unknown_7254_EW">parseFloat(@Unknown_7254_EW)</map>
				<map key="CII_7260_Fabs">parseFloat(@CII_7260_Fabs)</map>
				<map key="CII_7260_EW">parseFloat(@CII_7260_EW)</map></rowmaker>
		</make>
		<csvGrammar/>
	</data>

	<service id="q" allowed="form">
		<meta name="shortName">WR WN Spec</meta>
		<publish render="form" sets="ivo_managed,local"/>
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

			<condDesc>
				<inputKey name="sp" type="text"
									ucd="src.spType"
									description="Filter by spectral subtype (e.g., WN4, WN7)."/>
				<phraseMaker>
					<code>
            val = inPars.get("sp")
            if not val:
              return
            key = base.getSQLKey("sp", "%" + val.strip().upper() + "%", outPars)
            yield "UPPER(sp) LIKE %%(%s)s" % key
					</code>
				</phraseMaker>
			</condDesc>

			<condDesc buildFrom="date_obs"/>
			<condDesc buildFrom="B_mag"/>
			<condDesc buildFrom="V_mag"/>
			<condDesc buildFrom="Rc_mag"/>

		</dbCore>
	</service>

	<regSuite title="wr_spec_result (WC and WO) regression">

    <regTest title="Test TAP">
     <url parSet="TAP"
          QUERY="SELECT * FROM wr_wc_wo_sequence.main
          WHERE object='WR 4' AND date_obs='2021-01-27'"
          >/tap/sync</url>
     <code>
        row = self.getFirstVOTableRow()
        self.assertAlmostEqual(row['B_mag'],9.979999542236328)
        self.assertAlmostEqual(row['Rc_mag'],9.279999732971191)
     </code>
    </regTest>
	</regSuite>

</resource>
