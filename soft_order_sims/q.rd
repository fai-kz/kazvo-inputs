<?xml version="1.0" encoding="utf-8"?>
<resource schema="orders" resdir=".">

	<meta name="title">Order Computational and Storage Resources at FAI</meta>
	<meta name="shortName">OrderCompRes</meta>
	<meta name="creationDate">2024-11-14T12:02:00Z</meta>
	<meta name="description">
		 Via this service, it is possible to order computations with FAI computer cluster.

		 Fesenkov Astrophysical Institute operates a computer cluster that consists of several·
		 high-performance computing nodes equipped with high-end multi-core CPUs and GPU cards.
		 The theoretical single precision performance of the cluster currently peaks at 68 TFLOPS
		 for CPU operations (784 cores / 1 568 threads) and 1235 TFLOPS for GPU (286 208 CUDA cores).
		 In addition, it has redundant data storage of 300 terabytes in volume. Cluster has 10 gigabit
		 interlink and operates under Linux based OS. Task scheduling is organized using SLURM workload
		 manager. For external users, computation and data storage operations on the FAI cluster can be
		 arranged via online task submission that once approved results in an SSH account to the master
		 node with agreed permissions.
		 
		 To order simulations, please, Log In on VO web-page (https://vo.fai.kz/) and press the button
		 "Order Simulations" into your account or go to https://vo.fai.kz/comput_sub.php.
	</meta>
	<meta name="subject">astronomical-instrumentation</meta>
	<meta name="subject">computational-astronomy</meta>
	<meta name="subject">gpu-computing</meta>
	<meta name="subject">automated-telescopes</meta>

	<!-- ===== Curation information ===== -->
	<meta name="creator.name">Fesenkov Astrophysical Institute</meta>

	<meta name="publisher">Fesenkov Astrophysical Institute</meta>
	<meta name="referenceURL">https://vo.fai.kz/comput_sub.php</meta>
	<meta name="accessURL">https://vo.fai.kz/comput_sub.php</meta>
	<meta name="source">https://vo.fai.kz/comput_sub.php</meta>

	<service id="compres" allowed="external,form">
		<meta name="shortName">OrderCompRes</meta>
		<nullCore/>
		<publish render="external" sets="local,ivo_managed">
			<meta name="referenceURL">https://vo.fai.kz/comput_sub.php</meta>
			<meta name="accessURL">https://vo.fai.kz/comput_sub.php</meta>
			<meta name="source">https://vo.fai.kz/comput_sub.php</meta>

			<meta name="description">
				Via this service, it is possible to order computations with FAI computer cluster.

				Fesenkov Astrophysical Institute operates a computer cluster that consists of several·
				high-performance computing nodes equipped with high-end multi-core CPUs and GPU cards.
				The theoretical single precision performance of the cluster currently peaks at 68 TFLOPS
				for CPU operations (784 cores / 1 568 threads) and 1235 TFLOPS for GPU (286 208 CUDA cores).
				In addition, it has redundant data storage of 300 terabytes in volume. Cluster has 10 gigabit
				interlink and operates under Linux based OS. Task scheduling is organized using SLURM workload
				manager. For external users, computation and data storage operations on the FAI cluster can be
				arranged via online task submission that once approved results in an SSH account to the master
				node with agreed permissions.

				To order simulations, please, Log In on VO web-page (https://vo.fai.kz/) and press the button
				"Order Simulations" into your account or go to https://vo.fai.kz/comput_sub.php.
			</meta>
		</publish>
		<publish sets="local" render="form" auxiliary="True"/>
	</service>



</resource>
