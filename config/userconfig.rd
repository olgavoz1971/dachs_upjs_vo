<resource schema="__system">


<!-- ================================ Obscore ===================== -->

	<STREAM id="obscore-extraevents">
		<doc><![CDATA[
			Write extra events to mix into obscore-published tables.  This
			will almost always be just additions to the obscore clause of
			looking roughly like::
				
				<property name="obscoreClause" cumulate="True">
					,
					CAST(\\\\plutoLong AS real) AS pluto_long,
					CAST(\\\\plutoLat AS real) AS pluto_lat
				</property>

			See also `Extending Obscore`_ in the reference manual.
		]]></doc>
	</STREAM>

	<STREAM id="obscore-extrapars">
		<doc><![CDATA[
			For each macro you reference in obscore-extraevents, add a
			mixinPar here, like:

				<mixinPar key="plutoLong">NULL</mixinPar>
			
			Note that all mixinPars here must have default (i.e., there must
			be some content in the element suitable as an SQL expression
			of the appropriate type).  If you fail to give one, the creation
			of the empty prototype obscore table will fail with fairly obscure
			error messages.
		]]></doc>
	</STREAM>

	<STREAM id="obscore-extracolumns">
		<doc>
			Add column definitions for obscore here.  See `Extending Obscore`_ for
			details.
		</doc>
	</STREAM>

	<rowmaker id="_test-rmk">
		<!-- test instrumentation -->
		<map key="foo">@bar</map>
	</rowmaker>

	<STREAM id="obscore-registration">
		<doc>
			Registry-relevant material for the ivoa.obscore table.

			You might consider adding a set="local,ivo_vor" here to
			have obscore on your front page (but it's probably
			preferable to have a form service; cf. the tutorial).

			You can override obscore metadata (title, description...)
			here, too.  Remember you will usually have to prefix meta
			names with a bang to clear previous content.
		</doc>
		<register/>
	</STREAM>

	<STREAM id="obs-radio-registration">
		<doc>
			Registry-relevant material for the ivoa.obs_radio table.
		</doc>
		<register/>
	</STREAM>

<!-- ================================ Registry Interface ============ -->

	<STREAM id="registry-interfacerecords">
		<doc>
			These are services and registry records for the registry interface
			of this service.

			Even if together with defaultmeta, this will just work, keep
			these elements in your etc/userconfig.rd.

			The metaString macros in here generally point into defaultmeta.
			Replace them with whatever actual text applies to your site;  we
			will work to do away with defaultmeta.txt.
		</doc>

		<resRec id="authority">
			<meta>
				resType: authority
				creationDate: \metaString{authority.creationDate}
				title: UPJŠ Authority
				shortName: \\metaString{authority.shortName}
				subject: Authority
				managingOrg: \\metaString{publisher}
				referenceURL: https://astronomy.science.upjs.sk
				identifier: ivo://\getConfig{ivoa}{authority}
				sets: ivo_managed
			</meta>
			<meta name="description">
				These records belong to UPJŠ dachs server
			</meta>
		</resRec>

		<service id="registry" allowed="pubreg.xml">
			<registryCore/>
			<publish render="pubreg.xml" sets="ivo_managed">
				<meta name="accessURL"
					>\getConfig{web}{serverURL}\getConfig{web}{nevowRoot}oai.xml</meta>
			</publish>
			<meta name="resType">registry</meta>
			<meta name="title">\getConfig{web}{sitename} Registry</meta>
			<meta name="creationDate">\metaString{authority.creationDate}</meta>
			<meta name="description">
				The publishing registry for the \getConfig{web}{sitename}.
			</meta>
			<meta name="subject">virtual-observatories</meta>
			<meta name="shortName">\\metaString{authority.shortName} RG</meta>
			<meta name="content.type">Archive</meta>
			<meta name="rights">public</meta>
			<meta name="harvest.description">The harvesting interface for
				the publishing registry of the \getConfig{web}{sitename}</meta>
			<meta name="maxRecords">10000</meta>
			<meta name="managedAuthority">\getConfig{ivoa}{authority}</meta>
			<meta name="publisher">The staff at the \getConfig{web}{sitename}</meta>
		</service>
	</STREAM>

<!-- ============================= TAP ========================== -->

	<STREAM id="tapexamples">
		<doc>Examples for TAP querying</doc>
		
		<meta name="_example" title="tap_schema example">
			To locate columns "by physics", as it were, use UCD in
			:taptable:`tap_schema.columns`.  For instance,
			to find everything talking about the mid-infrared about 10µm, you
			could write:

			.. tapquery::
				
				SELECT * FROM tap_schema.columns
				  WHERE description LIKE '%em.IR.8-15um%'
		</meta>

		<meta name="_example" title="HEALPix map">
			To draw HEALPix map of the OCVS :taptable:`ogle.objects_all`, use TOPCAT's 
			Sky Plot --> Add new healpix layer control with results of the query:

			.. tapquery::

				SELECT count(*) as n, ivo_healpix_index(8, raj2000, dej2000) as hpx
					FROM ogle.objects_all
		</meta>

		<meta name="_example" title="ObsCore coverage">
			To see actual coverage of Kolonica observations (both images and
			timeseries), you can plot the result of this query against :taptable:`ivoa.obscore`
			table with TOPCAT (Sky Plot --> Add a new area plot control):

			.. tapquery::

				SELECT obs_id, s_region from ivoa.obscore 
					WHERE obs_collection ILIKE '%kolonica%'
		</meta>

		<meta>
			moreExamples: ogle/q#ex
			moreExamples.title: OGLE OCVS queries
		</meta>

		<meta>
			moreExamples: upjs_ts/q#ex
			moreExamples.title: Kolonica lightcurves queries
		</meta>

		<meta>
			moreExamples: https://dc.g-vo.org/static/obscore-examples.shtml
			moreExamples.title: ObsCore queries
		</meta>

		<meta>
			moreExamples: https://dc.g-vo.org/misc/udfexamples/examples
			moreExamples.title: Local UDFs
		</meta>

	</STREAM>
	
	<NXSTREAM id="tapdescription">
		<meta name="description">The \\getConfig{web}{sitename}'s TAP end point.
			The Table Access Protocol (TAP) lets you execute queries against our
			database tables, inspect various metadata, and upload your own
			data.  It is thus the VO's premier way to access public data
			holdings.

			Tables exposed through this endpoint include: \\tablesForTAP.
		</meta>
	</NXSTREAM>

	<NXSTREAM id="sitewidesiap2-extras">
		<!-- put any items you want to appear in the //siap2#sitewide
		service definition (in particular, metadata) here; it'd be nice if
		you changed the creationDate, at least, as that might aid
		in debugging.
		
		You should also add
		testQuery.pos.ra, testQuery.pos.dec,
		testQuery.size.ra, testQuery.size.dec meta item to  describe a field
		that is guaranteed to return at least one result.
		-->
		<meta name="description">
			The \\getConfig{web}{sitename}'s sitewide SIAP version 2 service
			publishes all the images published through the site.  For more
			advanced queries including uploads, all this data is also available
			through ObsTAP.
		</meta>
		<meta name="creationDate">2016-08-05T12:40:00</meta>
		<meta name="subject">virtual-observatories</meta>
		<meta name="shortName">\\metaString{authority.shortName} SIA2</meta>
		<meta name="title">\getConfig{web}{sitename} SIAP Version 2 Service</meta>
		<meta name="sia.type">Pointed</meta>
	</NXSTREAM>
</resource>
