<?xml version="1.0"?>

<!-- normal operation is update using the import data, to recreate import
*both* create and import.

If you want to start a complete re-harvest, import create_registries
and remove all subdirectories in data.

See README for how to start this from scratch.

-->

<resource schema="rr">
	<meta name="creationDate">2012-02-23T12:00:00</meta>
	<meta name="schema-rank">500</meta>
	<meta name="title">KazVO RegTAP Service</meta>
	<meta name="utype">ivo://ivoa.net/std/regtap#1.2</meta>
	<meta name="description" format="rst">
		Tables containing the information in the IVOA Registry.  To query
		these tables, use `our TAP service`_.

		For more information and example queries, see the
		`RegTAP specification`_.

		.. _our TAP service: /__system__/tap/run/info
		.. _RegTAP specification: http://www.ivoa.net/documents/RegTAP/
	</meta>
	<meta name="subject">virtual-observatories</meta>

	<!-- Harvesting is run by dachs-rr-harvest.timer.  Keeping scheduling out
		of the RD lets systemd serialize scheduled and manual updates through
		bin/updateRegistry.sh and retain complete logs in the journal. -->

	<table id="registries" onDisk="True" primary="ivoid" adql="True">
		<meta name="description">
			Administrative table: publishing registries we harvest, together
			with the dates of last full and incremental harvests.
		</meta>
		<column name="ivoid" type="text"
			description="IVOID of the registry."
		/>
		<column name="accessurl" type="text"
			description="URL of the registry's OAI-PMH endpoint."
		/>
		<column name="title" type="unicode"
			description="Name of the registry."
		/>
		<column name="last_full_harvest" type="timestamp"
			description="Date and time of the last full harvest of the registry."
		/>
		<column name="last_inc_harvest" type="timestamp"
			description="Date and time of the last incremental
				harvest of the registry."
		/>
	</table>

	<table id="imported" onDisk="True">
		<meta name="description">
			Administrative table: the files ingested together with the
			processing date.  Due to incremental harvesting, multiple files
			may/will exist for a single resource.
		</meta>
		<column name="path" type="text"
			description="Resdir-relative path of the input file."
		/>
		<column name="processedOn" type="timestamp"
			description="Date and time of ingestion."
		/>
	</table>

	<table id="authorities" onDisk="True" primary="managed_authority"
			dupePolicy="overwrite" adql="True">
		<meta name="description">
			A mapping between the registries and the authorities they
			claim to manage.
		</meta>
		<foreignKey source="ivoid" inTable="registries"/>

		<column original="registries.ivoid"/>
		<column name="managed_authority" type="text"
			description="An authority this registry claims to serve."
		/>
	</table>


	<STREAM id="columncolumns">
		<doc>common fields for tables and params.  The what stream parameter
		is either column or parameter, depending on where this thing goes.</doc>
		<column name="name" type="text"
			utype="xpath:name"
			description="The name of the \what.">
			<property name="std">1</property>
		</column>
		<column name="ucd" type="text"
			utype="xpath:ucd"
			description="A unified content descriptor that describes the
				scientific content of the \what.">
			<property name="std">1</property>
		</column>
		<column name="unit" type="text"
			utype="xpath:unit"
			description="The unit associated with all values in the \what.">
			<property name="std">1</property>
		</column>
		<column name="utype" type="text"
			utype="xpath:utype"
			description="An identifier for a role in a data model that the
				data in this \what represents.">
			<property name="std">1</property>
		</column>
		<column name="std" type="smallint"
			utype="xpath:@std"
			description="If 1, the meaning and use of this \what is
				reserved and defined by a standard model. If 0, it represents
				a database-specific \what that effectively extends beyond the
				standard.">
			<values default="0" nullLiteral="-1"/>
			<property name="std">1</property>
		</column>
		<column name="datatype" type="text"
			utype="xpath:dataType"
			description="The type of the data contained in the \what.">
			<property name="std">1</property>
		</column>
		<column name="extended_schema" type="text"
			utype="xpath:dataType/@extendedSchema"
			description="An identifier for the schema that the value given by
				the extended attribute is drawn from.">
			<property name="std">1</property>
		</column>
		<column name="extended_type" type="text"
			utype="xpath:dataType/@extendedType"
			description="A custom type for the values this \what contains.">
			<property name="std">1</property>
		</column>
		<column name="arraysize" type="text"
			utype="xpath:dataType/@arraysize"
			description="The shape of the array that constitutes the value, e.g.,
				4, *, 4*, 5x4, or 5x*, as specified by VOTable.">
			<property name="std">1</property>
		</column>
		<column name="delim" type="text"
			utype="xpath:dataType/@delim"
			description="The string that is used to delimit elements of an
				array value when arraysize is not '1'.">
			<property name="std">1</property>
		</column>
	</STREAM>


	<table id="resource" onDisk="True" primary="ivoid"
			dupePolicy="dropOld" adql="True">
		<meta name="description">
			The resources (like services, data collections, organizations)
			present in this registry.
		</meta>
		<meta name="table-rank">1</meta>
		<foreignKey source="harvested_from" dest="ivoid"
			inTable="registries"/>
		<property key="supportsModel">Registry 1.2</property>
		<property key="supportsModelURI"
				>ivo://ivoa.net/std/regtap#1.2</property>
		<meta name="utype">xpath:/</meta>

		<index columns="res_title" method="gin"
			>to_tsvector('english', res_title)</index>
		<index columns="res_description" method="gin"
			>to_tsvector('english', res_description)</index>
		<index columns="creator_seq" method="gin"
			>to_tsvector('english', creator_seq)</index>
		<index columns="short_name" method="gin"
			>LOWER(short_name) gin_trgm_ops</index>
		<index columns="ivoid" method="gin" name="ivoid_recs"
			>ivoid gin_trgm_ops</index>
		<!-- this is a service for old, broken TOPCATs; remove ~2018 -->
		<index columns="ivoid" method="gin" name="ivoid_re"
			>LOWER(ivoid) gin_trgm_ops</index>

		<column name="ivoid" type="text"
			utype="xpath:identifier"
			required="True"
			description="Unambiguous reference to the resource conforming to
				the IVOA standard for identifiers.">
			<property name="std">1</property>
		</column>
		<column name="res_type" type="text"
			utype="xpath:@xsi:type"
			description="Resource type (something like vg:authority,
				vs:catalogservice, etc).">
			<property name="std">1</property>
		</column>
		<column name="created" type="timestamp"
			utype="xpath:@created"
			description="The UTC date and time this resource metadata description
				was created.">
				<property name="std">1</property>
			</column>
		<column name="short_name" type="text"
			utype="xpath:shortName"
			description="A short name or abbreviation given to something, for
				presentation in space-constrained fields (up to 16 characters).">
				<property name="std">1</property>
			</column>
		<column name="res_title" type="unicode"
			utype="xpath:title"
			description="The full name given to the resource.">
			<property name="std">1</property>
		</column>
		<column name="updated" type="timestamp"
			utype="xpath:@updated"
			description="The UTC date this resource metadata description was
				last updated.">
			<property name="std">1</property>
		</column>
		<column name="content_level" type="text"
			utype="xpath:content/contentLevel"
			description="A hash-separated list of content levels specifying the
				intended audience." note="cl">
			<property name="std">1</property>
		</column>
		<column name="res_description" type="unicode"
			utype="xpath:content/description"
			description="An account of the nature of the resource.">
			<property name="std">1</property>
		</column>
		<column name="reference_url" type="text"
			utype="xpath:content/referenceURL"
			description="URL pointing to a human-readable document describing
				this resource.">
			<property name="std">1</property>
		</column>
		<column name="creator_seq" type="unicode"
			utype="xpath:curation/creator/name"
			description="The creator(s) of the resource in the order given
				by the resource record author, separated by semicolons.">
			<property name="std">1</property>
		</column>
		<column name="content_type" type="text"
			utype="xpath:content/type"
			description="A hash-separated list of natures or genres of the
				content of the resource." note="ct">
			<property name="std">1</property>
		</column>
		<column name="source_format" type="text"
			utype="xpath:content/source/@format"
			description="The format of source_value.  This, in particular, can
				 be ``bibcode''.">
			<property name="std">1</property>
		</column>
		<column name="source_value" type="unicode"
			utype="xpath:content/source"
			description="A bibliographic reference from which the present
				resource is derived or extracted.">
			<property name="std">1</property>
		</column>
		<column name="res_version" type="text"
			utype="xpath:curation/version"
			description="Label associated with creation or availablilty of a
				version of a resource.">
			<property name="std">1</property>
		</column>
		<column name="region_of_regard" type="real"
			unit="deg"
			utype="xpath:coverage/regionOfRegard">
			<description>
				A single numeric value representing the angle, given in decimal
				degrees, by which a positional query against this resource should be
				``blurred'' in order to get an appropriate match.
			</description>
			<property name="std">1</property>
		</column>
		<column name="waveband" type="text"
			utype="xpath:coverage/waveband"
			description="A hash-separated list of regions of the electro-magnetic
				spectrum that the resource's spectral coverage overlaps with."
			note="w">
			<property name="std">1</property>
		</column>
		<column name="rights" type="text"
			utype="xpath:/rights">
			<description>A statement of usage conditions (license, attribution,
				embargo, etc).</description>
			<property name="std">1</property>
		</column>
		<column name="rights_uri" type="text"
			utype="xpath:/rights/@rightsURI">
			<description>A URI identifying a license the data is made available
				under.</description>
			<property name="std">1</property>
		</column>

		<column name="harvested_from" type="text"
			description="IVOID of the registry this record came from."
		/>

		<meta name="note" tag="w">
			The allowed values for waveband include:
			Radio, Millimeter, Infrared, Optical, UV, EUV, X-ray, Gamma-ray.
		</meta>

		<meta name="note" tag="cl">
			The terms are taken from the vocabulary
			http://ivoa.net/rdf/voresource/content_level.
		</meta>

		<meta name="note" tag="ct">
			The terms are taken from the vocabulary
			http://ivoa.net/rdf/voresource/content_type.
		</meta>

		<meta name="note" tag="rt">
			The terms are taken from the vocabulary
			http://ivoa.net/rdf/voresource/relationship_type.
		</meta>

	</table>


	<STREAM id="refersToResource">
		<doc>Replay this in any table that represents a direct child
		of resource</doc>
		<foreignKey source="ivoid" inTable="resource"/>
		<index columns="ivoid"/>
		<column name="ivoid" type="text" utype="xpath:/identifier"
			description="The parent resource.">
			<property name="std">1</property>
		</column>
	</STREAM>

	
	<table id="res_role" onDisk="True" adql="True">
		<meta name="description">
			Entities (persons or organizations) operating on
			resources: creators, contacts, publishers, contributors.
		</meta>
		<FEED source="refersToResource"/>
		<index columns="role_name"/>
		<index columns="role_name" method="gin" name="role_re"
			>LOWER(role_name) gin_trgm_ops</index>
		<index columns="base_role"/>
		<index columns="alt_identifier"/>

		<column name="role_name" type="unicode"
			description="The real-world name or title of a person or organization.">
			<property name="std">1</property>
		</column>
		<column name="role_ivoid" type="text"
			description="An IVOA identifier of a person or organization.">
			<property name="std">1</property>
		</column>
		<column name="street_address" type="unicode"
			description="A mailing address for a person or organization.">
			<property name="std">1</property>
		</column>
		<column name="email" type="text"
			description="An email address the entity can be reached at.">
			<property name="std">1</property>
		</column>
		<column name="telephone" type="text"
			description="A telephone number the entity can be reached at.">
			<property name="std">1</property>
		</column>
		<column name="logo" type="text"
			description="URL pointing to a graphical logo, which may be used
				to help identify the entity.">
			<property name="std">1</property>
		</column>
		<column name="base_role" type="text"
			description="The role played by this entity;
				this is one of contact, publisher, contributor, or creator.">
			<property name="std">1</property>
		</column>
		<column name="alt_identifier" type="text"
			description="A non-IVOA identifier for the entity, for instance an
				ORCID or a ROR id.  See the RegTAP document for the notations for the
				various identifier types.">
			<property name="std">1</property>
		</column>
	</table>


	<table id="res_subject" onDisk="True" adql="True">
		<meta name="description">
			Topics, object types, or other descriptive keywords
			about the resource.
		</meta>
		<meta name="utype">xpath:/content/</meta>
		<FEED source="refersToResource"/>
		<index columns="res_subject" method="gin" name="subject_re"
			>LOWER(res_subject) gin_trgm_ops</index>
		<index columns="res_subject" method="gin"
			>to_tsvector('english', res_subject)</index>

		<column name="res_subject" type="text"
			utype="xpath:subject"
			description="Topics, object types, or other descriptive keywords
				about the resource.">
			<property name="std">1</property>
		</column>
	</table>

	<table id="subject_uat" onDisk="True" adql="True">
		<meta name="description">
			res_subject mapped to the UAT.  This is based on a manual
			mapping of keywords found in 2020, where subjects not mappable
			were dropped.  This is a non-standard, local extension.  Don't
			base your procedures on it, we will tear it down once there is
			sufficient takeup of the UAT in the VO.
		</meta>
		<FEED source="refersToResource"/>
		<index columns="uat_concept"/>

		<column name="uat_concept" type="text"
			description="Term from http://www.ivoa.net/rdf/uat; most
				of these resulted from mapping non-UAT designations.">
		</column>
	</table>

	<table id="capability" onDisk="True" adql="True"
			primary="ivoid,cap_index">
		<meta name="utype">xpath:/capability/</meta>
		<meta name="description">
			Pieces of behaviour of a resource.
		</meta>
		<meta name="table-rank">2</meta>
		<FEED source="refersToResource"/>

		<column name="cap_index" type="smallint" required="True"
			description="An arbitrary identifier of this capability within the
				resource.">
			<property name="std">1</property>
		</column>
		<column name="cap_type" type="text"
			utype="xpath:@xsi:type"
			description="The type of capability covered here.  If looking for
				endpoints implementing a certain standard, you should not use this
				column but rather match against standard_id.">
			<property name="std">1</property>
		</column>
		<column name="cap_description" type="unicode"
			utype="xpath:description"
			description="A human-readable description of what this capability
				provides as part of the over-all service.">
			<property name="std">1</property>
		</column>
		<column name="standard_id" type="text"
			utype="xpath:@standardID"
			description="A URI for a standard this capability conforms to.">
			<property name="std">1</property>
		</column>
	 </table>


	<table id="res_schema" onDisk="True" primary="ivoid,schema_index"
		adql="True">
		<meta name="utype">xpath:/tableset/schema/</meta>
		<meta name="description">
			Sets of tables related to resources.
		</meta>
		<FEED source="refersToResource"/>

		<column name="schema_index" type="smallint" required="True"
			description="An arbitrary identifier for the res_schema rows belonging to
				a resource.">
			<property name="std">1</property>
		</column>
		<column name="schema_description" type="unicode"
			utype="xpath:description"
			description="A free text description of the tableset explaining
				in general how all of the tables are related.">
			<property name="std">1</property>
		</column>
		<column name="schema_name" type="text"
			utype="xpath:name "
			description="A name for the set of tables.">
			<property name="std">1</property>
		</column>
		<column name="schema_title" type="unicode"
			utype="xpath:title"
			description="A descriptive, human-interpretable name for the table set.">
			<property name="std">1</property>
		</column>
		<column name="schema_utype" type="text"
			utype="xpath:utype"
			description="An identifier for a concept in a data model that the data in
				this schema as a whole represent.">
			<property name="std">1</property>
		</column>
	</table>


	<table id="res_table" onDisk="True" primary="ivoid,table_index"
			adql="True">
		<meta name="utype">xpath:/(tableset/schema/|)table/</meta>
		<meta name="description">
			(Relational) tables that are part of schemata or resources.
		</meta>
		<FEED source="refersToResource"/>

		<column original="res_schema.schema_index" required="False"
			description="Index of the schema this table belongs to, if it
			belongs to a schema (otherwise NULL).">
			<values nullLiteral="-1"/>
			<property name="std">1</property>
		</column>
		<column name="table_description" type="unicode"
			utype="xpath:description"
			description="A free-text description of the table's contents.">
			<property name="std">1</property>
		</column>
		<column name="table_name" type="text"
			utype="xpath:name"
			description="The fully qualified name of the table. As per
				VODataService, this includes all catalog or schema prefixes needed to
				distinguish it in a query, and it comes with SQL delimiters
				where necessary.">
			<property name="std">1</property>
		</column>
		<column name="table_index" type="smallint" required="True"
			description="An arbitrary identifier for the tables belonging to a
			resource.">
			<property name="std">1</property>
		</column>
		<column name="table_title" type="unicode"
			utype="xpath:title"
			description="A descriptive, human-interpretable name for the table.">
			<property name="std">1</property>
		</column>
		<column name="table_type" type="text"
			utype="xpath:@type">
			<description>
				A name for the role this table plays. Recognized values
				include "output", indicating this table is output from a query;
				"base_table", indicating a table whose records represent the
				main subjects of its schema; and "view", indicating that the
				table represents a useful combination or subset of other tables.
				Other values are allowed.
			</description>
			<property name="std">1</property>
		</column>
		<column name="table_utype" type="text"
			utype="xpath:utype"
			description="An identifier for a concept in a data model that the
				data in this table as a whole represent.">
			<property name="std">1</property>
		</column>
		<column name="nrows" type="bigint"
			utype="xpath:nrows"
			description="An estimate for the number of rows in the table.">
			<values nullLiteral="-1"/>
		</column>
	</table>

	<table id="table_column" onDisk="True" adql="True">
		<meta name="utype">xpath:/(tableset/schema/|)/table/column/</meta>
		<meta name="description">
			Metadata on columns of a resource's tables.
		</meta>
		<foreignKey source="ivoid,table_index" inTable="res_table"/>
		<index columns="ivoid"/>

		<index columns="column_description" method="gin"
			>to_tsvector('english', column_description)</index>
		<index columns="ucd" method="gin" name="ucd_re"
			>ucd gin_trgm_ops</index>
		<index columns="ucd"/>
		<index columns="name"/>
		<column original="res_table.ivoid"/>
		<column original="res_table.table_index"
			description="Index of the table this column belongs to."/>

		<FEED source="columncolumns" what="column"/>

		<column name="type_system" type="text"
			utype="xpath:dataType/@xsi:type"
			description="The type system used, as a QName with a canonical prefix;
				this will ususally be one of vs:simpledatatype, vs:votabletype,
				and vs:taptype.">
			<property name="std">1</property>
		</column>
		<column name="flag" type="text"
			utype="xpath:flag"
			description='Hash-separated keywords representing traits of the column.
				Recognized values include "indexed", "primary", and "nullable".'>
			<property name="std">1</property>
		</column>
		<column name="column_description" type="unicode"
			utype="xpath:description"
			description="A free-text description of the column's contents.">
			<property name="std">1</property>
		</column>
	</table>

	<table id="g_num_stat" onDisk="True" adql="True">
		<meta name="description">
			An experimental table containing advanced statistics for numeric
			table columns.  This is only available for very few tables at
			this point.

			Note that the values reported here may be estimates based on a
			subeset of the table rows.
		</meta>
		<!-- NOTE: it would be a lot nicer to reference ivoid, table_index, name
		in table_column.  But that doesn't fly at this point because data
		providers too often declare duplicate column names in tables. -->

		<foreignKey source="ivoid,table_index" inTable="res_table"/>
		<index columns="name"/>
		<index columns="percentile03"/>
		<index columns="median"/>
		<index columns="percentile97"/>

		<column original="res_table.ivoid"/>
		<column original="res_table.table_index"
			description="Index of the table this column belongs to."/>
	
		<column name="name" type="text"
			tablehead="Col"
			description="Name of the column (see rr.table_column for
				more metadata)."/>
		<column name="fill_factor"
			tablehead="Fill"
			description="An estimate for the ratio of non-NULL values in this column
				to the number of rows in the table."/>
		<column name="min_value"
			tablehead="Min"
			description="The largest value found in the column."/>
		<column name="percentile03"
			tablehead="P_3"
			description="An estimate for the value in the 3rd percentile
				of the column's distribution (for a Gaussian, roughly the lower
				limit of a 2σ interval)."/>
		<column name="median"
			tablehead="median"
			description="An estimate for the median value (or 50th percentile)
				of the column's distribution"/>
		<column name="percentile97"
			tablehead="P_3"
			description="An estimate for the value in the 97th percentile
				of the column's distribution (for a Gaussian, roughly the upper
				limit of a 2σ interval)."/>
		<column name="max_value"
			tablehead="Max"
			description="The largest value found in the column."/>
	</table>

	<table onDisk="True" id="res_detail" adql="True">
		<meta name="description">
			XPath-value pairs for members of
			resource or capability and their derivations that are less used and/or
			from VOResource extensions.  The pairs refer to a resource if
			cap_index is NULL, to the referenced capability otherwise.
		</meta>
		<FEED source="refersToResource"/>
		
		<column original="capability.cap_index" required="False"
			description="The index of the parent capability; if NULL the
				xpath-value pair describes a member of the entire resource.">
			<values nullLiteral="-1"/>
		</column>
		<column name="detail_xpath" type="text"
			description="The xpath of the data item.">
			<property name="std">1</property>
		</column>
		<column name="detail_value" type="unicode"
			description="(Atomic) value of the member.">
			<property name="std">1</property>
		</column>
	</table>


	<STREAM id="refersToCapability">
		<doc>Replay this in any table that represents a direct child
		of capability</doc>
		<index columns="ivoid,cap_index"/>
		<index columns="ivoid"/>

		<foreignKey source="ivoid,cap_index"
			inTable="capability"/>
		<column original="capability.ivoid"
		/>
		<column original="capability.cap_index"
			description="The index of the parent capability."
		/>
	</STREAM>


	<table id="interface" onDisk="True" adql="True"
			primary="ivoid,intf_index">
		<meta name="utype">xpath:/capability/interface/</meta>
		<meta name="description">
			Information on access modes of a capability.
		</meta>
		<FEED source="refersToCapability"/>

		<column name="intf_index" type="smallint" required="True"
			description="An arbitrary identifier for the interfaces of a resource.">
			<property name="std">1</property>
		</column>
		<column name="intf_type" type="text"
			utype="xpath:@xsi:type"
			description="The type of the interface (vr:webbrowser, vs:paramhttp,
				etc).">
				<property name="std">1</property>
		</column>
		<column name="intf_role" type="text"
			utype="xpath:@role"
			description='An identifier for the role the interface
				plays in the particular capability. If the value is equal to "std"
				or begins with "std:", then the interface refers to a standard
				interface defined by the standard referred to by the capability&#x27;s
				standardID attribute.'>
			<property name="std">1</property>
		</column>
		<column name="std_version" type="text"
			utype="xpath:@version"
			description="The version of a standard interface specification
				that this interface complies with. When the interface is provided
				in the context of a Capability element, then the standard being
				refered to is the one identified by the Capability's standardID
				element.">
			<property name="std">1</property>
		</column>
		<column name="query_type" type="text"
			utype="xpath:queryType"
			description="Hash-joined list of expected HTTP method (get or post)
				supported by the service.">
			<property name="std">1</property>
		</column>
		<column name="result_type" type="text"
			utype="xpath:resultType"
			description="The MIME type of a document returned in the HTTP
				response.">
			<property name="std">1</property>
		</column>
		<column name="wsdl_url" type="text"
			utype="xpath:wsdlURL"
				description="The location of the WSDL that describes this Web
				Service. If NULL, the location can be assumed to be the
				accessURL with '?wsdl' appended.">
			<property name="std">1</property>
		</column>
		<column name="url_use" type="text"
			utype="xpath:accessURL/@use"
			description="A flag indicating whether this should be interpreted
				as a base URL ('base'), a full URL ('full'), or a URL to a
				directory that will produce a listing of files ('dir').">
			<property name="std">1</property>
		</column>
		<column name="access_url" type="text"
			utype="xpath:accessURL"
			description="The URL at which the interface is found.">
			<property name="std">1</property>
		</column>
		<column name="mirror_url" type="text"
			utype="xpath:mirrorURL"
			description="Secondary access URLs of this interface, separated
				by hash characters.">
			<property name="std">1</property>
		</column>
		<column name="authenticated_only" type="smallint" required="True"
			description="A flag for whether an interface is available
				for anonymous use (=0) or only authenticated
				clients are served (=1).">
			<property name="std">1</property>
		</column>

		<column name="security_method_id" type="text"
			utype="not mapped"
			description="This column was mentioned in drafts of RegTAP 1.1
				but was abandoned before RegTAP 1.1 REC.  Do not use any more.
				This is just here to avoid a flag day for clients that experimentally
				used this column.  This is always NULL here.">
		</column>

	</table>


	<table id="relationship" onDisk="True" adql="True">
		<meta name="utype">xpath:/content/relationship/</meta>
		<meta name="description">
			Relationships between resources (like mirroring, derivation,
			serving a data collection).
		</meta>
		<FEED source="refersToResource"/>

		<column name="relationship_type" type="text"
			utype="xpath:relationshipType"
			description="The type of the relationship; these terms are drawn
				from a controlled vocabulary and are DataCite-compatible."
			note="rt">
				<property name="std">1</property>
			</column>
		<column name="related_id" type="text"
			utype="xpath:relatedResource/@ivo-id"
			description="The IVOA identifier for the resource referred
				to.">
				<property name="std">1</property>
			</column>
		<column name="related_name" type="text"
			utype="xpath:relatedResource"
			description="The name of resource that this resource is related to.">
			<property name="std">1</property>
		</column>
		<column name="related_alt_identifier" type="text"
			utype="xpath:relatedResource/@altIdentifier"
			description="A non-IVOA identifier for the related resource.  This will
				typically be a DOI in URI form ('doi:10...')">
			<property name="std">1</property>
		</column>

	</table>


	<table id="intf_param" onDisk="True" adql="True">
		<meta name="utype">xpath:/capability/interface/param/</meta>
		<meta name="description">
			Input parameters for services.
		</meta>
		<foreignKey source="ivoid,intf_index"
			inTable="interface"/>
		<index columns="column_description" method="gin"
			>to_tsvector('english', param_description)</index>
		<index columns="ivoid"/>

		<column original="interface.ivoid"
		/>
		<column original="interface.intf_index" description="The index
			of the interface this parameter belongs to."
		/>

		<FEED source="columncolumns" what="parameter"/>

		<column name="param_use" type="text"
			utype="xpath:@use"
			description="An indication of whether this parameter is required to be
				provided for the application or service to work properly (one of
				required, optional, ignored, or NULL).">
				<property name="std">1</property>
			</column>
		<column name="param_description" type="unicode"
			utype="xpath:description"
			description="A free-text description of the parameter's contents.">
			<property name="std">1</property>
		</column>

	</table>


	<table id="validation" onDisk="True" adql="True">
		<meta name="description">Validation levels for resources
			and capabilities.</meta>
		<meta name="utype">xpath:/(capability/|)validationLevel</meta>
		<foreignKey source="ivoid" inTable="resource"/>
		<FEED source="refersToResource"/>

		<column name="validated_by" type="text"
			utype="xpath:validationLevel/@validatedBy"
			description="The IVOA ID of the registry or organisation that
				assigned the validation level.">
			<property name="std">1</property>
		</column>
		<column name="val_level" type="smallint"
			utype="xpath:validationLevel"
			description="A numeric grade describing the quality of the
				resource description, when applicable, to be used to indicate
				the confidence an end-user can put in the resource as part of a
				VO application or research study."
			note="v">
			<values nullLiteral="0"/>
			<property name="std">1</property>
		</column>
		<column original="capability.cap_index"
			description="If non-NULL, the validation only refers to
				the capability referenced here."
			required="False">
			<values nullLiteral="-1"/>
			<property name="std">1</property>
		</column>
		<meta name="note" tag="v">
			The validation level is an integer encoding the following semantics:

			0
				The resource has a description that is stored in a registry. This level
				does not imply a compliant description.
			1
				In addition to meeting the level 0 definition, the resource
				description conforms syntactically to this standard and to
				the encoding scheme used.
			2
				In addition to meeting the level 1 definition, the resource description
				refers to an existing resource that has demonstrated to be functionally
				compliant.
				When the resource is a service, it is considered to exist and
				functionally compliant if use of the service accessURL responds without
				error when used as intended by the resource. If the service is a
				standard one, it must also demonstrate the response is syntactically
				compliant with the service standard in order to be considered
				functionally compliant. If the resource is not a service, then the
				ReferenceURL must be shown to return a document without error.
			3
				In addition to meeting the level 2 definition, the resource description
				has been inspected by a human and judged to comply semantically to this
				standard as well as meeting any additional minimum quality criteria
				(e.g., providing values for important but non-required metadata) set by
				the human inspector.
			4
				In addition to meeting the level 3 definition, the resource description
				meets additional quality criteria set by the human inspector and is
				therefore considered an excellent description of the resource.
				Consequently, the resource is expected to be operate well as part of a
				VO application or research study.
		</meta>
	</table>


	<table id="res_date" onDisk="True" adql="True">
		<meta name="description">
			A date associated with an event in the life cycle of the resource.  This
			could be creation or update.  The role column can be used to clarify.
    </meta>
		<meta name="utype">xpath:/curation/</meta>
		<FEED source="refersToResource"/>

		<column name="date_value" type="timestamp"
			utype="xpath:date"
			description="A date associated with an event in the life cycle
				of the resource.">
			<property name="std">1</property>
		</column>
		<column name="value_role" type="text"
			utype="xpath:date/@role"
			description="A string indicating what the date refers to, e.g.,
				created, availability, updated.  This value is generally drawn
				from a controlled vocabulary."
			note="r">
			<property name="std">1</property>
		</column>

		<meta name="note" tag="r">
			The terms for a date's role should be drawn from
			http://ivoa.net/rdf/voresource/date_role.

			Note that this date refers to the resource itself; dates
			describing the resource record are given by the created and updated
			columns in the resource table.
		</meta>
	</table>

	<table id="alt_identifier" onDisk="True" adql="True">
		<meta name="description">
			An alternate identifier associated with this record.
			This can be a resiource identifier like a DOI (in URI form,
			e.g., doi:10.1016/j.epsl.2011.11.037).
		</meta>
		<meta name="utype">xpath:/(curation/creator/|)altIdentifier</meta>
		<FEED source="refersToResource"/>
		<index columns="alt_identifier"/>
		<index columns="alt_identifier" method="gin" name="ai_re"
			>alt_identifier gin_trgm_ops</index>

		<column name="alt_identifier" type="text"
			description="An identifier for the resource or an entity related
				to the resource in URI form.">
			<property name="std">1</property>
		</column>
	</table>

	<table id="oairecs" onDisk="True">
		<meta name="description">
			Pre-rendered XML fragments for building OAI-PMH documents.
		</meta>
		<index columns="ivoid"/>
		<index columns="recTimestamp"/>
		<FEED source="refersToResource"/>
		
		<column name="recTimestamp" type="timestamp"
			description="The date this resources's record was last updated.">
			<property name="std">1</property>
		</column>
		<column name="oaixml" type="unicode"
			description="Pre-rendered XML for inclusion into OAI-PMH documents.">
			<property name="std">1</property>
		</column>
	</table>

	<table id="stc_spatial" onDisk="True" adql="True">
		<meta name="description">
			The spatial coverage of resources.  This table associates
			footprints (ADQL geometries) with ivoids.  The footprints are
			intended for resource discovery; a reasonable expectation for
			the resolution thus is something like a degree.
		</meta>
		<meta name="utype">xpath:/coverage/spatial</meta>
		<meta name="table-rank">5</meta>
		<FEED source="refersToResource"/>
		
		<column name="coverage" type="smoc"
			ucd="pos"
			utype="xpath:."
			description="A geometry representing the area a resource
				contains data for; this should be tight at least with a resolution
				of degrees.">
			<property name="std">1</property>
		</column>
		<column name="ref_system_name" type="text"
			ucd="pos.frame"
			utype="xpath:@frame"
			description="The reference frame coverage is written in.  This
				is currently reserved and fixed to NULL.  Clients should always
				add a constraint to NULL for this to avoid matching non-celestial
				resources later.">
			<property name="std">1</property>
		</column>
	</table>


	<table id="stc_temporal" onDisk="True" adql="True">
		<meta name="description">
			The temporal coverage of resources, given as one or more intervals.
			The total coverage is (a subset of) the union of all intervals
			given for a resource.  All times are understood as MJD for TDB
			at the solar system barycenter.
		</meta>
		<meta name="utype">xpath:/coverage/temporal</meta>
		<meta name="table-rank">5</meta>
		<FEED source="refersToResource"/>

		<column name="time_start" type="real" required="True"
			unit="d"
			utype="xpath:."
			description="Lower limit of a time interval covered by the resource in
				MJD.">
			<property name="std">1</property>
		</column>
		<column name="time_end" type="real" required="True"
			unit="d"
			utype="xpath:."
			description="Upper limit of a time interval covered by the resource in
				MJD.">
			<property name="std">1</property>
		</column>
	</table>


	<table id="stc_spectral" onDisk="True" adql="True">
		<meta name="description">
			The spectral coverage of resources, given as one or more intervals.
			The total coverage is (a subset of) the union of all intervals
			given for a resource.  The spectral values are given as
			messenger energy.
		</meta>
		<meta name="utype">xpath:/coverage/spectral</meta>
		<meta name="table-rank">5</meta>
		<FEED source="refersToResource"/>

		<column name="spectral_start" type="real" required="True"
			unit="J"
			utype="xpath:."
			description="Lower limit (in Joules) of messenger energy interval covered
				by the resource (for the solar system barycenter).">
			<property name="std">1</property>
		</column>
		<column name="spectral_end" type="real" required="True"
			unit="J"
			utype="xpath:."
			description="Upper limit (in Joules) of messenger energy interval covered
				by the resource (for the solar system barycenter).">
			<property name="std">1</property>
		</column>
	</table>

	<table id="tap_table" onDisk="True" adql="True">
		<meta name="description">
			TAP-queriable tables.
		</meta>
		<meta name="table-rank">3</meta>

		<index columns="svcid"/>
		<index columns="resid"/>
		<index columns="table_description" method="gin"
			>to_tsvector('english', table_description)</index>
		<index columns="table_title" method="gin"
			>to_tsvector('english', table_title)</index>
		<index columns="table_name" method="gin"
			>table_name gin_trgm_ops</index>

		<column name="resid" type="text"
			tablehead="Resource"
			description="IVOA identifier of the resource this table was
				taken from (where there is a dedicated resource containing this table
				in its tableset, that resource is preferred over a TAP service).">
			<property name="std">1</property>
		</column>
		<column name="svcid" type="text"
			tablehead="TAP service"
			description="IVOA identifier of the TAP service making this
				table queriable.">
			<property name="std">1</property>
		</column>
		<column original="res_table.table_name"/>
		<column original="res_table.table_title"/>
		<column original="res_table.table_description"/>
		<column original="res_table.table_utype"/>
		<viewStatement><!-- if you change this, consider updating RegTAP -->
			CREATE MATERIALIZED VIEW \qName AS (
				SELECT \colNames FROM (
WITH
  fromres AS (
    -- tables coming in through relationships; only those declaring
    -- an auxiliary capability *and* a relationship will be considered
    -- The GROUP BY and MIN hack is necessary since multiple of these
    -- may declare the same table (e.g., ivoa.obscore for data collections
    -- published through obscore).
    SELECT
    	MIN(tabcap.ivoid) as resid,
    	related_id as svcid,
    	table_name,
      MIN(table_title) as table_title,
      MIN(table_description) as table_description,
      MIN(table_utype) as table_utype
    FROM rr.res_table as tab
    NATURAL JOIN rr.capability as tabcap
    NATURAL JOIN rr.relationship
    JOIN rr.capability AS svccap
      ON (svccap.ivoid=related_id)
    WHERE
      (table_type!='output' OR table_type IS NULL)
      AND svccap.standard_id='ivo://ivoa.net/std/tap'
      AND tabcap.standard_id='ivo://ivoa.net/std/tap#aux'
      AND relationship_type='isservedby'
    GROUP BY related_id, table_name),

  fromtap AS (
    -- tables directly attached to the TAP service
    SELECT rt.ivoid as resid, ivoid as svcid,
      table_name, table_title,
      table_description, table_utype
    FROM rr.res_table AS rt
    NATURAL JOIN rr.capability
    WHERE
      (table_type!='output' OR table_type IS NULL)
      AND standard_id='ivo://ivoa.net/std/tap'
      AND NOT EXISTS (SELECT 1 FROM fromres as fr
        WHERE rt.ivoid=fr.svcid
        AND rt.table_name=fr.table_name))

-- using WITH here to allow for a lateral union
SELECT * FROM fromtap UNION ALL
SELECT * FROM fromres) q)
    </viewStatement>
	</table>

	<data id="make_tap_table" auto="False" updating="True">
		<sources item="1"/>
		<embeddedGrammar><iterator><code>
			if False: yield
		</code></iterator></embeddedGrammar>
		<make table="tap_table">
			<script type="sourceDone" lang="SQL" name="refresh matview">
				REFRESH MATERIALIZED VIEW \qName
			</script>
		</make>
	</data>

	<data id="create_registries" auto="false">
		<make table="registries"/>
		<make table="authorities"/>
	</data>

	<STREAM id="rr_makes">
		<make table="resource" role="resource">
			<rowmaker idmaps="*">
				<LOOP listItems="created updated">
					<events>
						<map src="\item" dest="\item" nullExcs="ValueError"/>
					</events>
				</LOOP>
			</rowmaker>
		</make>

		<LOOP listItems="capability res_schema res_table
				table_column res_detail interface intf_param
				relationship res_role
				validation res_date oairecs res_subject subject_uat
				alt_identifier
				stc_spatial stc_temporal stc_spectral
				g_num_stat">
			<events>
				<make table="\item" role="\item"/>
			</events>
		</LOOP>
		
		<make table="imported" rowSource="parameters">
			<rowmaker id="markProcessed" idmaps="*">
				<var name="path">\\inputRelativePath</var>
				<var name="processedOn">datetime.datetime.now()</var>
			</rowmaker>

			<!-- the following removes resources that had status="deleted" -->
			<script type="sourceDone" lang="SQL" name="removeDeleted"
					notify="False">
				DELETE FROM \\schema.resource WHERE res_title IS NULL
			</script>
		</make>
	</STREAM>

	<data id="create" auto="false">
		<recreateAfter>make_tap_table</recreateAfter>	
			
		<publish sets="ivo_managed,local" services="//tap#run">
			<meta name="mirrorURL">https://reg.g-vo.org/tap</meta>
			<meta name="mirrorURL">https://dc.g-vo.org/tap</meta>
			<meta name="mirrorURL">https://gavo.aip.de/tap</meta>
			<meta name="mirrorURL">https://voparis-rr.obspm.fr/tap</meta>
		</publish>
		<meta name="resType">registry</meta>
		<meta name="full">true</meta>
		<meta name="shortName">RegTAP mirror</meta>

		<FEED source="rr_makes"/>
	</data>

	<data id="create_stc" auto="false">
		<!-- a temporary data item while we're developing STC stuff.  -->
		<LOOP listItems="stc_spatial stc_temporal stc_spectral">
			<events>
				<make table="\item" role="\item"/>
			</events>
		</LOOP>
	</data>

	<data id="import" updating="true">
		<sources pattern="data/*/*.oaixml">
		<!-- <sources pattern="data/cadc.nrc.ca/*.oaixml"> -->
			<ignoreSources fromdb="SELECT path FROM rr.imported"/>
		</sources>

		<customGrammar id="vorgrammar"
			module="res/vorgrammar" isDispatching="True"/>

		<FEED source="rr_makes"/>
	</data>

	<service id="pmh" allowed="pubreg.xml">
		<meta name="title">KazVO searchable registry PMH interface</meta>
		<meta name="shortName">KazVO full PMH</meta>
		<meta name="description">
			The OAI-PMH endpoint of the KazVO searchable registry.  This service
			gives access to the full content of the VO registry using the Open
			Archive Initiative's protocol for metadata harvesting.  Advanced
			queries are possible using ADQL in the rr schema at
			https://dachs.fai.kz/tap.

			For the FAI publishing registry, see https://dachs.fai.kz/oai.xml.
		</meta>
		<meta name="resType">registry</meta>
		<meta name="maxRecords">1000</meta>
		<meta name="full">true</meta>
		<meta name="managedAuthority"/>

<!--		<publish render="pubreg.xml" sets="ivo_managed">
			<meta name="description">
				The harvesting interface of GAVO's searchable registry.
			</meta>
		</publish> -->
		<customCore module="res/oaicore"/>
	</service>

	<service id="nmah" allowed="custom" customPage="res/irkpage">
		<meta name="title">A Resolver for IVOA Identifiers (IVOID)</meta>
		<meta name="shortName">KazVO IRK</meta>
		<publish sets="local,ivo_managed" render="custom"/>
		<meta name="description">
			A service for easy access to VOResource information by IVOID (“resolve
			IVOA identifiers”) – simply append the IVOID to the base URL of this
			service.  Append an IVOID to the service URL to render the matching
			VOResource record.
		</meta>
		<nullCore/>
	</service>

	<service id="lp" allowed="custom,static" customPage="res/vorlanding">
		<meta name="title">VOResource Landing Page Generator</meta>
		<meta name="shortName">VOR lander</meta>
		<meta name="description">
			A service that turns VOResource into HTML in a way that is
			supposed to work as a DataCite-style landing page, explaining
			non-VO experts what access options there may be.  Append an IVOID to
			https://dachs.fai.kz/rr/q/lp/custom/ and open the resulting URL in a
			browser.
		</meta>

		<property name="staticData">static</property>

		<nullCore/>
	</service>

	<service id="harvtrig" allowed="form,async">
		<meta name="title">Harvest Trigger Service</meta>
		<meta name="description" format="rst">Operators of publishing registries
			can use this service to request a re-harvest of their registry by pasting
			in their registry's IVOID below.  If you paste in the magic value
			``ivo://ivoa.net/rofr``, we will also fetch new registries from the
			RofR.

			You usually want to use this when you want to see the effect of some
			change in your registry on, say, TOPCAT.  Note that you cannot start
			a full re-harvest of a registry from this interface.  Contact the
			operators if you think you need that.
		</meta>
		<meta name="shortName">harvtrig</meta>
		<publish render="form" sets="local,ivo_managed"/>

		<pythonCore>
			<inputTable>
				<inputKey name="registry" type="text" required="True"
					tablehead="Registry's ivoid"
					description="The IVOA identifier of the registry that should
						be re-harvested.  If you do not know yours, see
						http://rofr.ivoa.net and look for yourself."/>
			</inputTable>
			<outputTable>
				<outputField name="result" type="text"
					tablehead="Result"/>
				<outputField name="remarks" type="text"
					tablehead="Remarks"/>
			</outputTable>

			<coreProc>
				<setup imports="gavo.api"/>
				<code>
					msgs = []
					regId = inputTable.args["registry"]
					if regId=="ivo://ivoa.net/rofr":
						harvest_rofr, _ = api.loadPythonModule(
							"bin/harvestRofR", relativeTo=rd.resdir / "dummy")
						regs = harvest_rofr.getRegistryRecords()
						harvest_rofr.updateRegistries(regs)
						msgs.append("Read {} registries from the RofR".format(
							len(regs)))
					
					harvest_reg, _ = api.loadPythonModule(
						"bin/harvestRegistries", relativeTo=rd.resdir / "dummy")
					regTD = rd.getById("registries")

					with api.getWritableAdminConn() as conn:
						regTable = api.TableForDef(regTD, connection=conn,
							parseOptions=api.parseValidating.change(doTableUpdates=True))
						context = harvest_reg.HarvestContext(regTable)
						# this defeats our anti-race hack to harvest one extra
						# interval in _harvestOneInc
						context.incInterval = datetime.timedelta(seconds=0)

						for rec in regTable.iterQuery(regTD, "ivoid=%(regId)s",
								{"regId": regId.lower()}):
							harvest_reg._harvestOneInc(rec, context)
							msgs.append("Harvested {} incrementally".format(regId))
							break

						else:
							return api.TableForDef(self.outputTable, rows=[
								{"result": "fail", "remarks": "No matching registry"
									"known here.  Have me harvest the RofR first?"}])
					
					res = api.makeData(rd.getById("import"), connection=conn)
					msgs.append("Ingested {} RegTAP rows from material harvested"
						.format(res.nAffected))

					return api.TableForDef(self.outputTable, rows=[
						{"result": "ok", "remarks": " | ".join(msgs)}])
				</code>
			</coreProc>
		</pythonCore>
	</service>

	<service id="ex" allowed="examples">
		<meta name="title">RegTAP examples</meta>
		<meta name="description">This service has the examples from the
			RegTAP spec in the form of a DALI examples document.
		</meta>
		<meta name="_example" title="Find all TAP services; return their
		  accessURLs.">
As the capability type is in :taptable:`rr.capability`, whereas the access URL
can be found from :taptable:`rr.interface`, this requires a (natural) join.

Clients communicating with a RegTAP 1.1 or later service should request the new
``authenticated_only`` column.  If this is 1, the service requires some sort of
authentication and should only presented to users if a client has the necessary
infrastructure for the authentication system.

Hence, clients only interested in services not requiring authentication should
use

.. tapquery::
  SELECT ivoid, access_url
  FROM rr.capability
  NATURAL JOIN rr.interface
  WHERE standard_id like 'ivo://ivoa.net/std/tap%'
   	AND intf_role='std'
   	AND authenticated_only=0

Analogous considerations apply to the other example queries

Other ``standard_id``-s relevant here include:

* ``ivo://ivoa.net/std/registry`` for OAI-PMH services,
* ``ivo://ivoa.net/std/sia`` for SIA services,
* ``ivo://ivoa.net/std/conesearch`` for SCS services, and
* ``ivo://ivoa.net/std/ssa`` for SSA services.
		</meta>


		<meta name="_example" title="Find all SIA services that might have spiral
		  galaxies">
This is somewhat tricky since it is probably hard to image a part of the sky
guaranteed not to have some, possibly distant, spiral galaxy in it.  However,
translating the intention into “find all SIA services that mention spiral in
either the subject (from :taptable:`rr.res_subject`), the description, or the
title (which are in :taptable:`rr.resource`)“, the query would become:

.. tapquery::
  SELECT ivoid, access_url
  FROM rr.capability
    NATURAL JOIN rr.resource
    NATURAL JOIN rr.interface
    NATURAL JOIN rr.res_subject
  WHERE standard_id like 'ivo://ivoa.net/std/sia%'
    AND intf_role='std'
    AND (
      1=ivo_nocasematch(res_subject, '%spiral%')
      OR 1=ivo_hasword(res_description, 'spiral')
      OR 1=ivo_hasword(res_title, 'spiral'))
		</meta>

		<meta name="_example" title="Find all SIA services that provide infrared
		  images">

The waveband information in :taptable:`rr.resource` comes in hash-separated
atoms (which can be terms from https://www.ivoa.net/rdf/messenger).  For
matching those, use the ``ivo_hashlist_has`` function as below.  The access URL
and the service standard come from :taptable:`rr.interface` and
:taptable:`rr.capability`, respectively.

.. tapquery::
  SELECT ivoid, access_url
  FROM rr.capability
    NATURAL JOIN rr.resource
    NATURAL JOIN rr.interface
  WHERE standard_id LIKE 'ivo://ivoa.net/std/sia%'
    AND intf_role='std'
    AND 1=ivo_hashlist_has(waveband, 'infrared')
		</meta>

		<meta name="_example" title="Find all searchable catalogues that have
		  redshifts">

Metadata on columns exposed by a service are contained in
:taptable:`rr.table_column`.  Again, this table can be
naturally joined with
:taptable:`rr.capability` and
:taptable:`rr.interface`.

.. tapquery::
  SELECT ivoid, access_url
  FROM rr.capability
    NATURAL JOIN rr.table_column
    NATURAL JOIN rr.interface
  WHERE standard_id LIKE 'ivo://ivoa.net/std/conesearch%'
    AND intf_role='std'
    AND ucd='src.redshift'

Sometimes you want to match a whole set of ucds.  Frequently the
simple regular expressions of SQL will help, as in
``AND ucd LIKE 'pos.parallax\%'``.  When that is not enough,
use boolean OR expressions.
		</meta>

		<meta name="_example" title="Find all the resources published by a certain
		  authority">

An “authority” within the VO is something that hands out identifiers.
You can tell what authority a record came from by looking at the “host
part” of the IVO identifier, most naturally obtained from
:taptable:`rr.resource`.  Since ADQL cannot actually parse
URIs, we make do with simple string matching:

.. tapquery::
  SELECT ivoid
  FROM rr.resource
  WHERE ivoid LIKE 'ivo://org.gavo.dc%'
		</meta>

		<meta name="_example" title="What registry records are there from a given
publisher?">

This uses the :taptable:`rr.res_role` table both to match names (in this case,
a publisher that has “gavo” in its name) and to ascertain the named entity
actually publishes the resource (rather than, e.g., just being the contact in
case of trouble).  The result is a list of ivoids in this case.  You could join
this with any other table in the relational registry to find out more about
these services.

.. tapquery::
  SELECT ivoid
  FROM rr.res_role
  WHERE 1=ivo_nocasematch(role_name, '%gavo%')
    AND base_role='publisher'

or, if the publisher actually gives its ivo-id in the registry
records::

  SELECT ivoid
  FROM rr.res_role
  WHERE role_ivoid='ivo://ned.ipac/ned'
    AND base_role='publisher'
		</meta>

		<meta name="_example" title="What registry records are there originating
		  from registry X?">
This is mainly a query interesting for registry maintainers.  Still, it is a
nice example for joining with the :taptable:`rr.res_detail` table, in this case
to first get a list of all authorities managed by the CDS registry.

.. tapquery::
  SELECT ivoid FROM rr.resource
  RIGHT OUTER JOIN (
    SELECT 'ivo://' || detail_value || '%' AS pat
    FROM rr.res_detail
    WHERE detail_xpath='/managedAuthority'
      AND ivoid='ivo://cds.vizier/registry')
    AS authpatterns
  ON 1=ivo_nocasematch(resource.ivoid, authpatterns.pat)
		</meta>

		<meta name="_example" title="Find all TAP endpoints offering the relational
		  registry">

This is the discovery query for RegTAP services themselves;  note how this
combines :taptable:`rr.res_detail` pairs with :taptable:`rr.capability` and
:taptable:`rr.interface` to locate the desired protocol endpoints.  As clients
should not usally be concerned with minor versions of protocols unless  they
rely on additions made in later versions, this query will return endpoints
supporting “version 1” rather than exactly version 1.2.

.. tapquery::
  SELECT access_url
  FROM rr.interface
  NATURAL JOIN rr.capability
  NATURAL JOIN rr.res_detail
  WHERE standard_id LIKE 'ivo://ivoa.net/std/tap%'
    AND intf_role='std'
    AND detail_xpath='/capability/dataModel/@ivo-id'
    AND 1=ivo_nocasematch(detail_value,
      'ivo://ivoa.net/std/regtap#1.%')
    AND authenticated_only=0
		</meta>

		<meta name="_example" title="Find all TAP services exposing a table with
		  certain features">

“Certain features” could be “have some word in their description and having a
column with a certain UCD”.  Either way, this kind of query fairly invariably
combines the usual :taptable:`rr.capability` and :taptable:`rr.interface` for
service location with :taptable:`rr.table_column` for the column metadata and
:taptable:`rr.res_table` for properties of tables.

.. tapquery::
  SELECT ivoid,
    name, ucd, column_description,
    access_url
  FROM rr.capability
    NATURAL JOIN rr.interface
    NATURAL JOIN rr.table_column
    NATURAL JOIN rr.res_table
  WHERE standard_id LIKE 'ivo://ivoa.net/std/tap%'
    AND intf_role='std'
    AND 1=ivo_hasword(table_description, 'quasar')
    AND ucd='phot.mag;em.opt.v'
		</meta>

		<meta name="_example" title="Find all SSAP services that provide
		  theoretical spectra.">
The metadata required to solve this problem is found in the SSAP
registry extension and is thus kept in
:taptable:`rr.res_detail`:

.. tapquery::
  SELECT access_url
  FROM rr.res_detail
    NATURAL JOIN rr.capability
    NATURAL JOIN rr.interface
  WHERE detail_xpath='/capability/dataSource'
    AND intf_role='std'
    AND standard_id LIKE 'ivo://ivoa.net/std/ssa%'
    AND detail_value='theory'
		</meta>

		<meta name="_example" title="Find a contact person by access URL">
This uses the :taptable:`rr.res_role` table and returns all information on
it based on the IVOID of a service that in turn was obtained from
:taptable:`rr.interface`.  You could restrict to the actual technical
contact person by requiring ``base_role='contact'``.

.. tapquery::
  SELECT DISTINCT base_role, role_name, email
  FROM rr.res_role
    NATURAL JOIN rr.interface
  WHERE access_url='http://dc.g-vo.org/tap'
		</meta>

		<meta name="_example" title="Get the capabilities of all services serving a
		  specific resource">
In the VO, data providers can register data collections either as such
or with “auxiliary capabilities” that are fully described elsewhere; a practice
for doing that is discussed in an Endorsed Note on `discovering data
collections within services`_.

.. _discovering data collections within services: http://ivoa.net/documents/discovercollections/

When following this pattern, data collections records should provide an
*isServedBy* relationship to the resources providing the access
services for the data collection (like a TAP or a SIAP service).

While the access URLs can typically be established from the auxiliary
capabilities themselves, several use cases require finding out more about the
publishing service.  To locate its metadata, inspect
:taptable:`rr.relationship` and use it to select records from
:taptable:`rr.capability`; this requires an explicit join condition, as in this
case the capabilities are for the *related* record, not for the originally
matched one.

.. tapquery::
  SELECT *
  FROM rr.relationship AS a
    JOIN rr.capability AS b
      ON (a.related_id=b.ivoid)
  WHERE
    relationship_type='isservedby'
    AND a.ivoid='ivo://cds.vizier/j/a+a/649/a25'
		</meta>

		<meta name="_example" title="Constraints on Space, Time, and Spectrum">
Consider the example: ”Give me resources that cover M 101 (α=210.80,
δ=54.35, Diameter about 0.3°) in the mid-infrared around
5μm in August 2010.

Without further database support, clients need to manually convert the
spectral coordinate to energy (hc/λ ≈ 3.97 × 10\ :sup:`-20` J and time (August
1st, 2010 starts MJD 55409.0) to the quantities RegTAP expects.

This would yield a query like (the explicit MOC conversion is a common
device to speed the query up; without it, the database would convert the
circle once for each coverage, to the respective order):

.. tapquery::
  SELECT ivoid
  FROM rr.stc_spatial
    NATURAL JOIN rr.stc_spectral
    NATURAL JOIN rr.stc_temporal
  WHERE
    1=CONTAINS(MOC(8, CIRCLE(210.80, 54.35, 0.3)), coverage)
    AND 1=ivo_interval_overlaps(time_start, time_end, 55409, 55440)
    AND 3.97e-20 between spectral_start and spectral_end

In particular when more complex geometries are desired, clients will
want to pass in MOCs directly.  Conversely, RegTAP services may provide
the additional user-defined functions that allow specifying temporal and
spectral constraints in different, perhaps human-friendlier ways.  For
instance, once support for the relevant UDFs is established using the TAP
capabilities, the above query could also be written as (the MOC given is the
circle above at order 8)::

  SELECT ivoid
  FROM rr.stc_spatial
    NATURAL JOIN rr.stc_spectral
    NATURAL JOIN rr.stc_temporal
  WHERE
    1=CONTAINS(MOC('8/182947 182950 182952-182953 182955-182956 8/'), coverage)
    AND 1=ivo_interval_overlaps(
      time_start, time_end,
      gavo_to_mjd('2010-08-01'), gavo_to_mjd('2010-08-31'))
    AND gavo_specconv(5e-6, 'm', 'J') between spectral_start and spectral_end
		</meta>

		<meta name="_example" title="Query expansion in subjects">
Using the gavo_vocmatch user-defined-functions, you can do what is called
query expansion in information retrieval, that is: not only query for a
keyword, but also for related terms.

In the relational registry, this concerns subjects, which should come from the
`IVOA rendering of the Unified Astronomy Thesaurus`_.  To find resources
for brown dwarfs, you would query::

	SELECT ivoid, res_subject FROM rr.res_subject
	WHERE res_subject='brown-dwarfs'

However, this will miss resources talking about t-dwarfs, l-dwarfs and several
other concepts.  To include those (“narrower”) concepts, write::

	SELECT ivoid, res_subject FROM rr.res_subject
	WHERE 1=gavo_vocmatch('uat', 'brown-dwarfs', res_subject)

instead.  In reality, far too few data providers actually use the UAT
(correctly).  We hence have a local extension table,
:taptable:`rr.subject_uat`, that is res_subject with legacy terms mapped to UAT
concept identifiers (translated to plain English: use this table instead
of :taptable:`rr.res_subject` for the time being).  In there, you would
do something like:

.. tapquery::
	SELECT ivoid, uat_concept FROM rr.subject_uat
	WHERE 1=gavo_vocmatch('uat', 'brown-dwarfs', uat_concept)

.. _IVOA rendering of the Unified Astronomy Thesaurus: http://www.ivoa.net/rdf/uat
		</meta>
		<meta name="_example" title="Find resources for a set of points"><![CDATA[
Several (but unfortunately by no means all) service operators define the
spatial coverage of their services.  This information is havested into the
proposed new relational registry table :taptable:`rr.stc_spatial`.  One way
to use this information is to match the resources against the points in an
upload and perhaps see if they are in the infrared band, like this:

.. tapquery::

	SELECT ivoid FROM
	rr.resource
	NATURAL JOIN
	(SELECT DISTINCT
   	 ivoid
   	 FROM rr.stc_spatial AS db
   	 JOIN TAP_UPLOAD.t1 AS tc
   	 ON 1=CONTAINS(POINT('ICRS', tc.ra, tc.dec), coverage)) AS spate
	WHERE 1=ivo_hashlist_has(waveband, 'Infrared')

As usual, you will have to adapt the index after TAP_UPLOAD.  To find out
access URLs of these services, NATURAL JOIN with rr.interface.  For more
information, see also the `RegTAP specification`_

.. _RegTAP specification: http://ivoa.net/documents/RegTAP
]]></meta>

		<nullCore/>
	</service>

	<regSuite title="RR regressions">
		<regTest title="RR registry record looks right">
			<url metadataPrefix="ivo_vor" verb="GetRecord"
				identifier="ivo://fai.kz/rr/q/create"
				>/oai.xml</url>
			<code><![CDATA[
				self.assertValidatesXSD()
				self.assertHasStrings(
					'xsi:type="vg:Registry"',
					"<identifier>ivo://fai.kz/rr/q/create</identifier>",
					"use `our TAP service`_.",
					'<relatedResource ivo-id="ivo://fai.kz/tap">',
					"<full>true</full>",
					'standardID="ivo://ivoa.net/std/TAP#aux"',
					"/tap</accessURL>",)
					# add this when we have a tableset:	"<name>rr.resource</name>")
			]]></code>
		</regTest>

		<regTest title="RR findable in RegTAP">
			<url parSet="TAP"
				QUERY="SELECT access_url, res_title, mirror_url
					FROM rr.resource
					NATURAL JOIN rr.interface
					WHERE ivoid='ivo://fai.kz/rr/q/create'">/tap/sync</url>
			<code>
				rows = self.getVOTableRows()
				self.assertEqual(len(rows), 1)
				self.assertEqual(rows[0]["access_url"],
					"https://dachs.fai.kz/tap")
				self.assertEqual(rows[0]["res_title"], "KazVO RegTAP Service")
				self.assertTrue({
					"https://reg.g-vo.org/tap",
					"https://dc.g-vo.org/tap",
					"https://gavo.aip.de/tap",
					"https://voparis-rr.obspm.fr/tap",
				}.issubset(set((rows[0]["mirror_url"] or "").split("#"))))
			</code>
		</regTest>

		<regTest title="Aladin 10 basic metadata query returns something">
			<url parSet="TAP"
				QUERY="SELECT TOP 2 * FROM rr.resource NATURAL JOIN rr.interface NATURAL JOIN
rr.capability WHERE (rr.resource.ivoid NOT LIKE 'ivo://cds%' OR
rr.resource.ivoid='ivo://cds.vizier/tap' OR
rr.resource.ivoid='ivo://cds.vizier/siap' OR
rr.resource.ivoid='ivo://cds.vizier/ssap' OR
rr.resource.ivoid='ivo://cds.aladin/sia') AND (standard_id LIKE '%conesearch%'
or standard_id LIKE '%sia%' or standard_id LIKE '%tap%' or standard_id LIKE
'%ssa%') AND intf_type LIKE '%paramhttp%'">/tap/sync</url>
			<code>
				self.assertEqual(len(self.getVOTableRows()), 2)
			</code>
		</regTest>

		<regTest title="Aladin 10 footprint query returns something">
			<url parSet="TAP"
				QUERY="SELECT TOP 2 ivoid, detail_value AS url FROM rr.res_detail WHERE
detail_xpath='/coverage/footprint' AND rr.res_detail.ivoid NOT LIKE
'ivo://cds%'">/tap/sync</url>
			<code>
				self.assertEqual(len(self.getVOTableRows()), 2)
			</code>
		</regTest>

		<regTest title="Aladin 10 tap tables query returns something">
			<url parSet="TAP"
				QUERY="select top 2 ivoid, table_name from rr.res_table natural join rr.table_column
natural join rr.capability where table_name IS NOT NULL AND ivoid NOT LIKE
'ivo://cds%' AND  standard_id LIKE '%tap%aux' group by ivoid, table_name order
by ivoid">/tap/sync</url>
			<code>
				self.assertEqual(len(self.getVOTableRows()), 2)
			</code>
		</regTest>

		<regTest title="RR returns something looking like oai_dc">
			<url metadataPrefix="oai_dc" verb="GetRecord"
				identifier="ivo://org.gavo.dc/ohmaser/q/scs"
				>pmh/pubreg.xml</url>
			<code>
				self.XPATH_NAMESPACE_MAP["dc"] = "http://purl.org/dc/elements/1.1/"
				self.XPATH_NAMESPACE_MAP["oai_dc"] = \
					"http://www.openarchives.org/OAI/2.0/oai_dc/"
				self.assertValidatesXSD()
				self.assertXpath(
					"o:GetRecord/o:record/o:header/o:identifier",
						{None: "ivo://org.gavo.dc/ohmaser/q/scs"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/oai_dc:dc/dc:identifier",
						{None: "ivo://org.gavo.dc/ohmaser/q/scs"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/oai_dc:dc/dc:title",
						{None: "A Database of Circumstellar OH Masers"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/oai_dc:dc/dc:description",
						{None: EqualingRE("A all-sky compilation.*")})
				self.assertFalse(b"ivo_managed" in self.data)
			</code>
		</regTest>

		<regTest title="RR returns something looking like oai_datacite">
			<url metadataPrefix="oai_datacite" verb="GetRecord"
				identifier="ivo://org.gavo.dc/lswscans/res/positions/siap"
				>pmh/pubreg.xml</url>
			<code>
				# don't XSD-validate them: we don't have the datacite schema on
				# board.
				self.XPATH_NAMESPACE_MAP["d"] = "http://datacite.org/schema/kernel-4"
				self.assertXpath(
					"o:GetRecord/o:record/o:header/o:identifier", {
						None: "ivo://org.gavo.dc/lswscans/res/positions/siap"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:identifier", {
						None: "10.21938/haTEMZmoaCTEK6XZvGU.fQ",
						"identifierType": "DOI"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:creators/d:creator[1]/d:creatorName", {
						None: "Mandel, H."})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:resourceType", {
					"resourceTypeGeneral": "Dataset",
					None: "AstroImage"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:alternateIdentifiers/d:alternateIdentifier[1]", {
						"alternateIdentifierType": "ivoid",
						None: "ivo://org.gavo.dc/lswscans/res/positions/siap"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:alternateIdentifiers/d:alternateIdentifier[2]", {
						"alternateIdentifierType": "reference URL",
						None: "http://dc.g-vo.org/"
							"lswscans/res/positions/siap/info"})
				self.assertXpath(
					"o:GetRecord/o:record/o:metadata/d:resource/d:alternateIdentifiers/d:alternateIdentifier[3]", {
						"alternateIdentifierType": "browser URL",
						None: "http://dc.g-vo.org/hdap"})
				self.assertFalse(b"ivo_managed" in self.data)

				# if the following doesn't work, there's probably something wrong
				# with our UAT top-level mapping
				subjectsFound = set(e.text for e in
					getattr(self, "cached parsed tree").xpath("//d:subject",
						namespaces={"d": self.XPATH_NAMESPACE_MAP["d"]}))
				self.assertEqual(subjectsFound, {
					'history-of-astronomy', 'astrophotography'})
			</code>
		</regTest>

		<regTest title="RR returns something looking like oai_b2find">
			<url metadataPrefix="oai_b2find" verb="GetRecord"
				identifier="ivo://org.gavo.dc/lswscans/res/positions/siap"
				>pmh/pubreg.xml</url>
			<code>
				self.assertValidatesXSD()

				R = "o:GetRecord/o:record/o:metadata/eudc:resource/"
				self.XPATH_NAMESPACE_MAP["eudc"
					] = "http://schema.eudat.eu/schema/kernel-1"
				self.assertXpath(
					R+"eudc:creators/eudc:creator[1]/eudc:creatorName", {
						None: "Mandel, H."})
				self.assertXpath(
					R+"/eudc:rightsList/eudc:rights[3]", {
						None: "https://spdx.org/licenses/CC0-1.0.html"})
				self.assertXpath(
					R+"/eudc:instruments/eudc:instrument[1]", {
						None:"Bruce Double Astrograph",
						"instrumentIdentifierType": "Handle",
						"instrumentIdentifier": "21.11157/e3c244b9-0463-4bb8-b344-371a3a125bbd"})
				self.assertXpath(
					R+"/eudc:instruments/eudc:instrument[2]", {
						None:"Calar Alto Schmidt Telescope"})
				self.assertXpath(
					R+"/eudc:publicationYear", {None: "2007"})

				# The following is our UAT concept extension.
				subjectsFound = set(e.text for e in
					getattr(self, "cached parsed tree").xpath("//eudc:keyword",
						namespaces={"eudc": self.XPATH_NAMESPACE_MAP["eudc"]}))
				self.assertEqual(subjectsFound, {
					'history-of-astronomy', 'astrophotography'})
				
				# now see if both a WebBrowser interface and the referenceURL are
				# turned into relatedIdentifiers, the sequence being determined
				# by the XSLT
				self.assertXpath(
					"//eudc:relatedIdentifier[@relatedIdentifierType='URL'][1]",
					{ None:
						"http://dc.g-vo.org/lswscans/res/positions/siap/info"
					})
				self.assertXpath(
					"//eudc:relatedIdentifier[@relatedIdentifierType='URL'][2]",
					{ None: "http://dc.g-vo.org/hdap"})

				self.assertXpath(
					R+"/eudc:temporalCoverages/eudc:temporalCoverage[1]/eudc:startDate",
					{None: "1837-07-08T23:02:24Z"})
			</code>
		</regTest>

		<regTest title="RR has some more oai_b2find features">
			<url metadataPrefix="oai_b2find" verb="GetRecord"
				identifier="ivo://org.gavo.dc/hsoy/q/q"
				>pmh/pubreg.xml</url>
			<code>
				self.assertValidatesXSD()

				R = "o:GetRecord/o:record/o:metadata/eudc:resource/"
				self.XPATH_NAMESPACE_MAP["eudc"
					] = "http://schema.eudat.eu/schema/kernel-1"
				self.assertXpath(R+"eudc:relatedIdentifiers/"
					"eudc:relatedIdentifier[@relatedIdentifierType"
					"='bibcode']",
					{None: '2017A&amp;A...600L...4A'})
			</code>
		</regTest>

		<regTest title="irk returns something plausible">
			<url>nmah/custom/ivo%3a//org.gavo.dc</url>
			<code><![CDATA[
				self.assertHasStrings(
					"<title>The GAVO data centre</title>",
					'<date role="Updated">',
					'xsi:type="vg:Authority"',
					'xmlns:vg=',
					'created=')
			]]></code>
		</regTest>

		<regTest title="b2find landing page returns reasonable HTML">
			<url>lp/custom/org.gavo.dc/hsoy/q/q</url>
			<code><![CDATA[
				self.assertHasStrings("<title>The HSOY Catalog</title>",
					'<h1 id="doctitle">',
					'<ol class="inline">',
					'href="https://adsabs.harvard.edu/abs/2017A&amp;A...600L...4A">',
					'<a href="https://dachs.fai.kz/rr/q/nmah/custom/ivo://org.gavo.dc/hsoy/q/q">ivo://org.gavo.dc/hsoy/q/q</a>',
					'<dt>IVOA Cone Search <span class="protocol">SCS</span></dt>',
					'onclick="return false"')
			]]></code>
		</regTest>

		<regTest title="RegTAP synonyms enabled">
			<url parSet="TAP" QUERY="select top 1
				ivo_hasword('catalog', 'catalogue') as has_synonyms
				from tap_schema.tables">/tap/sync</url>
			<code>
				# See rr/README if you don't understand what's going on here
				row = self.getFirstVOTableRow()
				self.assertEqual(row["has_synonyms"], 1)
			</code>
		</regTest>
	</regSuite>
</resource>
