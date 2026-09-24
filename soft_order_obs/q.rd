<?xml version="1.0" encoding="utf-8"?>
<resource schema="orders" resdir=".">

	<meta name="title">Order Observations at FAI Telescopes</meta>
	<meta name="shortName">OrderObs</meta>
	<meta name="creationDate">2024-11-14</meta>

	<meta name="description">
		Via this service, it is possible to request astronomical observations with
		telescopes operated by the Fesenkov Astrophysical Institute.

		The Academician Omarov Assy-Turgen Observatory is located on the Assy-Turgen
		plateau at an altitude of 2750 m, approximately 85 km east of Almaty.
		Observations have been conducted since 1981. In 2017, the largest telescope
		in Kazakhstan (AZT-20) began regular operations. The site is characterized by
		high atmospheric transparency, minimal light pollution, and low turbulence.

		Available telescopes include: AZT-20, Zeiss-1000, RC-500, WFOS-40.

		To request observations, please log in to the VO web portal (https://vo.fai.kz/)
		and select "Order Observations" in your account, or use the page:
		https://vo.fai.kz/observatory_descrip.php
	</meta>
	
	
	<meta name="subject">astronomical-instrumentation</meta>
	<meta name="subject">automated-telescopes</meta>
	<meta name="subject">telescopes</meta>
	<meta name="subject">observatories</meta>
	<meta name="subject">optical-observation</meta>
	<meta name="subject">optical-observatories</meta>


	<!-- ===== Curation information ===== -->
	<meta name="creator.name">Fesenkov Astrophysical Institute</meta>
	<meta name="publisher">Fesenkov Astrophysical Institute</meta>

	<meta name="referenceURL">https://vo.fai.kz/observatory_descrip.php</meta>
	<meta name="source">https://vo.fai.kz/observatory_descrip.php</meta>

	<service id="orderobs" allowed="external,form">
		<meta name="shortName">OrderObs</meta>
		<nullCore/>
		<publish render="external" sets="local,ivo_managed">
			<meta name="referenceURL">https://vo.fai.kz/observatory_descrip.php</meta>
			<meta name="accessURL">https://vo.fai.kz/observatory_descrip.php</meta>
			<meta name="source">https://vo.fai.kz/observatory_descrip.php</meta>
			
						<meta name="description">
				Web page for requesting observations with FAI telescopes (external tool).
			</meta>
		</publish>
		<publish sets="local" render="form" auxiliary="True"/>
	</service>

</resource>
