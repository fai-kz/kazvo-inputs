<?xml version="1.0" encoding="utf-8"?>

<!--
	Registry description for the ArXSP software package.
	This RD creates a VOResource record for the ArXSP application,
	providing metadata and a reference URL where installers can be downloaded.
-->

<resource schema="soft_arxsp" resdir=".">

	<!-- ===== Basic metadata ===== -->
	<meta name="title">ArXSP: Archive Spectrum Processing Tool</meta>
	<meta name="shortName">ArXSP</meta>

	<meta name="description">
		ArXSP is a Python-based desktop application for the reduction and analysis
		of digitized archival spectra obtained at the Fesenkov Astrophysical Institute.
		The software provides geometric correction tools (cropping and alignment of
		spectral images), extraction of characteristic curves, s-distortion correction,
		and conversion from optical density to relative intensity.
		Installers for Linux, Windows, and macOS are available on the FAI VO portal (https://vo.fai.kz/software.php).
	</meta>

	<!-- ===== Keywords / Classification ===== -->
	<meta name="subject">spectroscopy</meta>
	<meta name="subject">astronomy-software</meta>
	<meta name="subject">astronomy-data-reduction</meta>

	<!-- UAT keywords -->
	<meta name="uat">Astronomy software</meta>
	<meta name="uat">Spectroscopy</meta>
	<meta name="uat">Data reduction</meta>

	<!-- ===== Curation information ===== -->
	<meta name="creator.name">Fesenkov Astrophysical Institute</meta>
	<meta name="publisher">Fesenkov Astrophysical Institute</meta>

	<!-- ===== Dates ===== -->
	<meta name="creationDate">2025-06-19</meta>
	<meta name="updateDate">2025-11-30</meta>

	<!-- ===== External references ===== -->
	<meta name="referenceURL">https://vo.fai.kz/software.php</meta>
	<meta name="source">https://github.com/ill-i/ArXSP</meta>
	<meta name="accessURL">https://vo.fai.kz/software.php</meta>

	<meta name="bibliography">
		Izmailova et al. (2025),
		"ArXSP: A Python-based Modular Application for the Reduction of Digitized Archival Spectra",
		submitted to Astronomy &amp; Computing.
	</meta>

	<service id="arxsp-soft" allowed="external,form">
		<meta name="shortName">ArXSP-download</meta>
		<nullCore/>
		<publish sets="local,ivo_managed" render="external">

			<meta name="accessURL">https://vo.fai.kz/software.php</meta>
			<meta name="referenceURL">https://vo.fai.kz/software.php</meta>
			<meta name="description">
				ArXSP is a Python-based desktop application for the reduction and analysis
				of digitized archival spectra obtained at the Fesenkov Astrophysical Institute.
				The software provides geometric correction tools (cropping and alignment of
				spectral images), extraction of characteristic curves, s-distortion correction,
				and conversion from optical density to relative intensity.
				Installers for Linux, Windows, and macOS are available on the FAI VO portali (https://vo.fai.kz/software.php).
			</meta>
		</publish>
		<publish render="form" sets="local" auxiliary="True"/>

	</service>

</resource>
