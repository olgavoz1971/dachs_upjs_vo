<resource schema="upjs_vo" resdir=".">
	<meta name="creationDate">2025-09-03T09:40:33Z</meta>

	<meta name="title">My amazing lightcurves</meta>
	<meta name="description">
	This is a loooooooong description of my amazing time series
	</meta>

<!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
 	<meta name="subject">light-curves</meta>
 	<meta name="subject">variable-stars</meta>

 	<meta name="creator">Last, F.I; Next, A.</meta>
	<meta name="source">2012IAUS..282...81P</meta>
 	<meta name="instrument">Some telescope in Kolonica</meta>
 	<meta name="facility">Kolonica</meta>

  <!-- <meta name="source">%ideally, a bibcode%</meta> -->
 	<meta name="contentLevel">Research</meta>
 	<meta name="type">Archive</meta>

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
 	<meta name="coverage.waveband">Optical</meta>


 	<meta name="ssap.dataSource">pointed</meta>   <!-- custom ? -->
 	<meta name="ssap.creationType">archival</meta>
 	<meta name="productType">timeseries</meta>
 	<meta name="ssap.testQuery">MAXREC=1</meta>

 	<!-- Define my existing database tables structure 
	I should also do this from outside of RD
		GRANT SELECT ON upjs_vo.lightcurves TO gavoadmin WITH GRANT OPTION;
		GRANT SELECT ON upjs_vo.objects TO gavoadmin WITH GRANT OPTION;
		GRANT SELECT ON upjs_vo.photosys TO gavoadmin WITH GRANT OPTION;
		GRANT SELECT ON upjs_vo.photosys TO gavo;
	-->
 
 	<table id="photosys" onDisk="True" adql="True">
		<meta name="description">External table containing photometric systems data</meta>
		<column name="id" type="integer"
			ucd="meta.id;meta.main" 
			tablehead="internal id" 
			description="Bandpass id in the original table" 
			verbLevel="1" 
			required="True"/>

        <column name="band" type="text"
            ucd="meta.id;instr.filter" 
            tablehead="internal id" 
            description="Bandpass name in the original table" 
            verbLevel="1" 
            required="True"/>

        <column name="description" type="text"
            ucd="meta.note" 
            tablehead="system" 
            description="Photometric system" 
            verbLevel="1" 
            required="True"/>

		<column name="specmid"
			ucd="em.wl"
			tablehead="specmid"
			description="Central wavelength of bandpass"
			verbLevel="1"
			required="True"/>
	</table>
    <data id="publish_photosys_orig" updating="True">
        <!-- <make table="photosys"/> -->
    </data>


 	<table id="objects" onDisk="True" adql="True">
		<meta name="description">External table containing objects</meta>
		<column name="id" type="integer"
			ucd="meta.id;meta.main" 
			tablehead="internal id" 
			description="Object id in the original table" 
			verbLevel="1" 
			required="True"/>

		<column name="gaia_name" type="text"
			ucd="meta.id" 
			tablehead="Gaia DR3 ID" 
			description="Gaia DR3 identifier" 
			verbLevel="1" 
			required="True"/>

		<column name="coordequ" type="spoint"
			ucd="pos.eq;meta.main"
			tablehead="coordequ" 
			description="Equatorial coordiantes ICRS in the original table (rad, rad)" 
			verbLevel="1" 
			required="False"/>

	</table>

	<data id="publish_objects_orig" updating="True">
		<!-- <make table="objects"/> -->
 	</data>


 	<table id="lightcurves" onDisk="True" adql="True">
		<meta name="description">External table containing lightcurves</meta>

		<column name="id" type="bigint" 
			ucd="meta.id;meta.main" 
			tablehead="internal id"
			description="lightcurve point id in the original table" 
			verbLevel="1" 
		required="True"/>

		<column name="object_id" type="integer" 
				ucd="meta.id" 
				tablehead="object id" 
				description="object id from the original objects table" 
				verbLevel="1" 
				required="True"/>

		<column name="dateobs" type="timestamp" 
				ucd="time.epoch" 
				tablehead="dateobs" 
				description="timestamp with timezone" 
				verbLevel="1" 
				required="True"/>

		<column name="magnitude" type="double precision" 
				ucd="phot.mag"
				unit="mag"
				tablehead="magnitude" 
				description="stellar magnitude" 
				verbLevel="1" 
				required="True"/>

		<column name="mag_err" type="double precision"
				ucd="stat.error;phot.mag"
				unit="mag"
				tablehead="magnitude" 
				description="stellar magnitude" 
				verbLevel="1" 
				required="False"/>

<!--
		<column name="band" type="text"
				ucd="meta.id;instr.filter"
				tablehead="filter"
				description="photometric filter"
				verbLevel="1"
				required="True"/>
-->

	</table>

	<data id="publish_lightcurves_orig" updating="True">
		<!-- <make table="lightcurves"/> -->
	</data>


	<table id="raw_data" adql="True" onDisk="True" namePath="//ssap#instance">
		<meta name="description">A view over lightcurves and objects for SSA/ObsCore ingestion</meta>

		<!-- list of metadata varying across datasets -->
		<LOOP listItems="ssa_dstitle ssa_targname ssa_length ssa_timeExt ssa_bandpass 
					ssa_specmid ssa_csysName">
 			<events>
				<column original="\item"/>
			</events>
		</LOOP>

		<column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>

		<mixin>//products#table</mixin>
		<mixin>//ssap#plainlocation</mixin>	<!-- injects ssa_location -->
		<mixin>//ssap#simpleCoverage</mixin>	<!-- ssa_region -->

		<!-- add a q3c index so obscore queries over s_ra
		and s_dec are fast -->
		<FEED source="//scs#splitPosIndex"
			columns="ssa_location"
			long="degrees(long(ssa_location))"
			lat="degrees(lat(ssa_location))"/>

		<!-- the datalink column is mainly useful if you have a form-based
			service.  You can dump this (and the mapping rule filling it below)
			if you're not planning on web or don't care about giving them datalink access. -->
		<column name="datalink" type="text"
			ucd="meta.ref.url"
		 	tablehead="Datalink"
		 	description="A link to a datalink document for this lightcurve."
		 	verbLevel="15" displayHint="type=url">

		 	<property name="targetType">application/x-votable+xml;content=datalink</property>
		 	<property name="targetTitle">Datalink</property>
		</column>

	<!-- custom columns -->
		<column name="p_object_id" type="integer"
			ucd="meta.id;meta.main"
			tablehead="internal id"
			description="Object id in the original table"
			verbLevel="1"
			required="True"/>	<!-- think more about this, I really need this to produce lightcurve -->
		
		<column name="p_mean_mag" type="double precision" 
			ucd="phot.mag;stat.mean"
			unit="mag"
			tablehead="mean magnitude"
			description="stellar magnitude"
			verbLevel="1"
			required="True"/>	<!-- And this column is worth showing to users -->

		<column name="p_ra" type="double precision"
			unit="deg"
			ucd="pos.eq.ra;meta.main"
			tablehead="RA"
			description="Right Ascension (double precision floating-point number)"
			verbLevel="1"/>

		<column name="p_dec" type="double precision"
			unit="deg"
			ucd="pos.eq.dec;meta.main"
			tablehead="Dec"
			description="Declination (double precision floating-point number)"
			verbLevel="1"/>

		<!-- note 1: accref = upjs_vo/q/object_id path for (future) product (lightcurve) -->
		<viewStatement>
			CREATE OR REPLACE VIEW \curtable AS (
			SELECT
				'Kolonica Gaia DR3 ' || o.gaia_name AS ssa_dstitle,
				o.id AS p_object_id,
				'Gaia DR3 ' || o.gaia_name AS ssa_targname,
				o.coordequ AS ssa_location,
				NULL::spoly AS ssa_region,
				'upjs_vo/q/' || o.id || '/' || p.band AS accref,
				'application/x-votable+xml' AS mime,
				50000 AS accsize,
				NULL AS embargo,
				NULL AS owner,
				NULL AS datalink,
				ssa_timeExt,
				p.band AS ssa_bandpass,
				p.specmid AS ssa_specmid,
				t_min,
				t_max,
				ssa_length,
				degrees(long(o.coordequ)) AS p_ra,
				degrees(lat(o.coordequ)) AS p_dec,
				mean_mag AS p_mean_mag,
				'ICRS' AS ssa_csysName
			FROM (
			SELECT
				l.object_id, l.photosys_id,
				COUNT(*) AS ssa_length,
				(MAX(extract(julian from dateobs at time zone 'UTC+12')) -
				MIN(extract(julian from dateobs at time zone 'UTC+12'))) AS ssa_timeExt,
				MIN(extract(julian from dateobs at time zone 'UTC+12')) - 2400000.5 AS t_min,
				MAX(extract(julian from dateobs at time zone 'UTC+12')) - 2400000.5 AS t_max,
			    AVG(magnitude) AS mean_mag
			FROM \schema.lightcurves AS l
				GROUP BY l.object_id, l.photosys_id
			) AS q
				JOIN \schema.objects AS o ON o.id = q.object_id
				JOIN \schema.photosys AS p ON p.id = q.photosys_id
			);
		</viewStatement>
	</table>


	<!-- if you have data that is continually added to, consider using
		updating="True" and an ignorePattern here; see also howDoI.html,
		incremental updating.
		<data id="import">  
	-->

	<data id="create-raw-view">			<!-- stolen from carmenes t.rd -->
		<recreateAfter>make-ssa-view</recreateAfter>	<!-- make_ssa_view should be called after this -->
		<property key="previewDir">previews</property>
		<make table="raw_data">		<!-- do this manually because we din't have place for rowfilter //products#define -->
			<script type="preImport" lang="SQL">
				DELETE FROM dc.products WHERE sourcetable='upjs_vo.raw_data';
			</script>

			<script type="postCreation" lang="SQL" name="add to product table">
				INSERT INTO dc.products (SELECT
					accref,
					owner,
					NULL AS embargo,
					mime,
					\sqlquote{\internallink{/upjs_vo/q/sdl/dlget?ID=}} ||
						gavo_urlescape(accref) AS accesspath,
					'upjs_vo.raw_data' AS sourcetable,
					'upjs_vo/previews/' || accref || '.png' AS preview, <!-- todo build the "preview" service for on the fly generation -->
					NULL AS datalink,
					'image/png' AS preview_mime
				FROM upjs_vo.raw_data);
			</script>
		</make>
	</data>

	<table id="ts_ssa" onDisk="True" adql="True">		<!-- also stolen from carmenes t.rd  -->
		<meta name="_associatedDatalinkService">		<!-- declared a table as having datalink support -->
			<meta name="serviceId">sdl</meta>
			<meta name="idColumn">ssa_pubDID</meta>
		</meta>

	<!-- todo:  do something with passbands  like for Gaia or BGDS ???
		ssa_fluxcalib - something for  differential photometry 
		[!p]* ([^p]* does not work) excludes my private columns from the ssa view  - ??? this excludes t_min column too
		copied SSA columns cannot be overridden in mixin parameter (like ssa_bandpass)
		-->
		<mixin
			sourcetable="raw_data"
			copiedcolumns="[!p]*"
			ssa_aperture="1/3600."
			ssa_collection="'Kolonica live timeseries'"
			ssa_dstype="'timeseries'"
			ssa_fluxcalib="'CALIBRATED'"
			ssa_fluxucd="'phot.mag'"
			ssa_pubDID="\sql_standardPubDID"
			ssa_spectralucd="NULL"
			ssa_spectralunit="NULL"
			ssa_targclass="'star'"
			ssa_specext="NULL"
		>//ssap#view</mixin>

		<!-- todo: caliblevel:
			0 - Raw instrumental data, in a proprietary or internal data-provider defined format
			1 - Instrumental data in a standard format (FITS, VOTable, etc )
			2 - Calibrated, science ready data with the instrument signature removed
			3 - Enhanced data products like mosaics, resampled or drizzled images, or heavily
				processed survey fields. Level 3 data products may represent the combination of data
				from multiple primary observations
		-->

		<mixin
			calibLevel="2"
			coverage="ssa_region"
			oUCD="'phot.mag'"
		>//obscore#publishSSAPMIXC</mixin>	<!-- publish this through ObsCore to -->
	</table>

	<data id="make-ssa-view" auto="False">		<!-- also stolen from carmenes t.rd auto=False "don't build this on an unadorned dachs imp" -->
		<make table="ts_ssa"/>
	</data>
	
	 <coverage>
		<updater sourceTable="ts_ssa"/>
	</coverage>


	<!-- JK: Try to build separate templates for different bands 
		stolen from bgds/l 
		This template is for the table definition *for a single time series* as used
		by datalink.

		TODO: fill this properly
		zeroPointFlux - Flux at the given zero point, in Jy 
		effectiveWavelength - Central wavelength - take it from the photsys table

		TODO: ssa_targname is not seen there, do something to fix that issue
		TODO: add zeropints to the photosys table
		TODO: take bands parameters from to photosys table, do not doule them here
		TODO: check region, I den't have it yet
	-->
	<STREAM id="time-series-template">
		<table id="instance_\band_short" onDisk="False">
			<meta name="description">The \metaString{source} lightcurve in the \band_human filter </meta>

       <!-- JK: define them _before_ mentioning them the mixin -->
		    <param original="ts_ssa.ssa_bandpass"/>
		    <param original="ts_ssa.ssa_specmid"/>
			<mixin
				effectiveWavelength="\effective_wavelength"
				filterIdentifier='"\band_human"'
				magnitudeSystem="Vega"
				zeroPointFlux="3636"
				phot_description="Kolonica magnitude in \band_human"
				phot_ucd='phot.mag;\band_ucd'
				phot_unit="mag"
				refposition="BARYCENTER"
				refframe="ICRS"
				time0="2400000.5"
				timescale="TCB"
			>//timeseries#phot-0</mixin>

		    <param original="ts_ssa.t_min"/>
		    <param original="ts_ssa.t_max"/>
		    <param original="ts_ssa.ssa_location"/>

	        <!-- Add my columns -->
    	    <column original="lightcurves.mag_err"/>

	        <!-- JK: Add also something kind of:
	        <column original="lightcurves.image"/>  fits image ref?
	        <column original="lightcurves.process_info"/>   my jsonb from lc_metadata
	        -->

		  </table>
	</STREAM>

	<!-- instantiate for a few bands -->
	<LOOP source="time-series-template">
		<csvItems>
			band_short, band_human, band_ucd, effective_wavelength
			U, 			Bessell/U, em.opt.U, 3.6e-7
			B, 			Bessell/B, em.opt.B, 4.4e-7
			V, 			Bessell/V, em.opt.V, 5.4e-7
			R, 			Bessell/R, em.opt.R, 6.2e-7
			I, 			Bessell/I, em.opt.I, 8.3e-7
			u_sdss,		   u/sdss, em.opt.U, 3.56e-7
			g_sdss,		   g/sdss, em.opt.B, 4.71e-7
			r_sdss,		   r/sdss, em.opt.R, 6.18e-7
			i_sdss,		   i/sdss, em.opt.I, 7.49e-7
			z_sdss,		   z/sdss, em.opt.I, 8.96e-7
		</csvItems>
	</LOOP>


	<!-- This is the table definition *for a single time series* as used
	by datalink.  If you have per-bin errors or whatever else, just
	add columns as above.

	TODO: fill this properly
	zeroPointFlux - Flux at the given zero point, in Jy 
	effectiveWavelength - Central wavelength	(or similar measure) 
	for the passband used for the photometry, in meters


	<table id="instance" onDisk="False">
		we use a template for description here; it will be filled out by the datalink service below
		
		JK: Note1: Unfortunately i can't use @ssa_bandpass and @ssa_specmid in the mixin parameters (i.g., filterIdentifier="@ssa_bandpass").
		I suppose they have not 'filled' at the time of mixin uses them - as a result, 
		I don't have them in the lightcurves table metadata in the PhotDM
		Note2: I also have not succeeded in 'filterIdentifier="Bessel/V"' or 'filterIdentifier="'Bessel/V'"', seems phot-0 does not like "/" sign 
		ssa_targname and ssa_bandpass on the meta name="description" are from the clicked row of ssa_table (?)


 		<meta name="description">The \metaString{source} lightcurve for {ssa_targname} in the {ssa_bandpass} filter </meta>

		define them _before_ mentioning them the mixin 
		<param original="ts_ssa.ssa_bandpass"/>
		<param original="ts_ssa.ssa_specmid"/>

		<mixin
			effectiveWavelength="12345"
			filterIdentifier="Bessel_V"
			magnitudeSystem="Vega"
            zeroPointFlux="3636"
			phot_description="somehow-calibrated magnitude"
			phot_ucd="phot.mag;em.opt.V"
			phot_unit="mag"
			refposition="BARYCENTER"
			refframe="ICRS"
			time0="2400000.5"
			timescale="TCB"
		>//timeseries#phot-0</mixin>

		from carmenes:
		<param original="ts_ssa.t_min"/>
		<param original="ts_ssa.t_max"/>
		<param original="ts_ssa.ssa_location"/>

		Add my columns
		<column original="lightcurves.mag_err"/>

		JK: Add also something kind of:
		<column original="lightcurves.image"/>	fits image ref?
		<column original="lightcurves.process_info"/>	my jsonb from lc_metadata

	</table>
	-->

	<data id="build-ts" auto="False"> 
		<!-- stolen from carmenes 
		note 1: parmaker copies values from the SSA input row to the params in the instance table.
        note 2: pargetter gets parameters from the related row of the parent table (ssa-table) to fill instance table metadata
		-->
		<embeddedGrammar>
			<iterator>
				<code>
					object = self.sourceToken.accref.split("/")[-2]		# self.sourceToken points to the clicked ssa_table row
					passband = self.sourceToken.accref.split("/")[-1]	# TODO use this as a band
					# band = "B"
					with base.getTableConn() as conn:
						for row in conn.queryToDicts(
							"SELECT dateobs, magnitude AS phot, mag_err"
							"  FROM \schema.lightcurves AS l"
							" JOIN \schema.photosys AS p ON p.id = l.photosys_id"
							"  WHERE object_id=%(object)s AND p.band=%(passband)s"
							" ORDER BY dateobs",
							{"object": object, "passband": passband}		# locals()
						):
							dt = row["dateobs"]
							dt_utc = dt.astimezone(datetime.timezone.utc) # I should have thrown out this trash
							row['obs_time'] = dateTimeToMJD(dt_utc)	# This doesn't take timezone into account (like "extract(julian from dateobs at time zone 'UTC+12'")
							yield row
				</code>
			</iterator>
			<pargetter>
				<code>
					return self.sourceToken.ssa_row
				</code>
			</pargetter>
		</embeddedGrammar>

		<make table="instance_U">	<!-- just a placeholder, we don't have the bare "instance" table 
			tut: this is really overridden in the datalink service's data function to select the actual table definition -->
			<rowmaker idmaps="*" id="make-ts"/>
			
			<!--parmaker can get parameters, provided by pargetter and write them as a metadata in the instance table -->
			<parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specmid, t_min, t_max, ssa_location">
				<!--(from the tutorial) touch manually the instance table metadata -->
				<apply name="update_metadata">
					<code>
						# sourceId = vars["parser_"].sourceToken["ssa_targname"]	does not work
						sourceId = vars["ssa_targname"]		# works
						targetTable.setMeta("description", base.getMetaText(targetTable, "description") +
							" for {}".format(sourceId))
						targetTable.setMeta("name", str(sourceId))
					</code>
				</apply>
			</parmaker>
		</make>
	</data>


	<!--
			static for prepared periodogramms
			descriptorGenerator: dataset description
			metaMaker: makes #* stuff (semantics)
			dataFunction: builds ts
			dataFormatter: -> VOTable(?)
			pubDID is the only input parameter there
	-->

	<service id="sdl" allowed="dlget,dlmeta,static">
		<property name="staticData">data/periodograms</property>
		<meta name="title">\schema Datalink Service</meta>
		<meta name="description">
            This service produces time series datasets for Kolonica lightcurves.
        </meta>


		<datalinkCore>
			<descriptorGenerator>
				<code>
					# extract info from the ssa-table row and fill
					# descriptor.ssa_row and something
					if "?" in pubDID:
						accref = urllib.parse.unquote_plus(pubDID.split("?")[-1])
					else:
						# it already is an accref rather than a full pubDID
						accref = pubDID

					descriptor = ProductDescriptor.fromAccref(pubDID, accref)
					# descriptor.band = accref.split.split("/")[-1]
					# descriptor.band = "V"
					with base.getTableConn() as conn:
						descriptor.ssa_row = next(conn.queryToDicts(
							"SELECT * FROM \schema.ts_ssa"
							" WHERE accref=%(accref)s",
							{"accref": accref}))
					descriptor.band = descriptor.ssa_row.get("ssa_bandpass")
					return descriptor
				</code>
			</descriptorGenerator>

			<!-- I don't have fits_accref yet, TODO --> 

			<metaMaker name="add_periodogram" semantics="#derivation">
				<code>
					objname = descriptor.accref.split("/")[-1]
					yield descriptor.makeLinkFromFile(
						rd.getAbsPath(f"data/periodograms/bilet.pdf"),
						description="Periodograms derivied from this time series")
				</code>
			</metaMaker>

			<!-- 
			"#this" and #preview content comes automatically from the dc.products table 
			dataFunction is for dlget service(?)
			The lightcurve sits in the PrimaryTable (?)
			dataFunction is stolen from bgds/l2
			-->
			<dataFunction>
				<setup imports="gavo.rsc"/>
				<code>
					# fills descriptor.data
					# actually calls data's "build-ts" block
					# descriptor is from metaMaker as input parameters for
					# build-ts sourceToken

					# descriptor.data = rsc.makeData(
					#	rd.getById("build-ts"),
					#	forceSource=descriptor)

					dd = rd.getById("build-ts")	# take build-ts block
					# tableId = "instance_B"
					tableId = "instance_" + descriptor.band		# rd.getById(tableId) picks up an appropriate instance table
					descriptor.data = rsc.Data.createWithTable(dd, rd.getById(tableId)) # here is the magic for dispathing between instance tables 
					descriptor.data = rsc.makeData(dd, data=descriptor.data, forceSource=descriptor)	# runs all this stuff?

					# tab = descriptor.data.getPrimaryTable()
					# tab.setMeta("description",
					# 	base.getMetaText(tab, "description").format(**descriptor.ssa_row))
				</code>
			</dataFunction>

			<dataFormatter>
				<!-- to VOTable -->
				<setup imports="gavo.formats.votablewrite"/>
				<code>
					return ("application/x-votable+xml;version=1.5",
						votablewrite.getAsVOTable(descriptor.data, version=(1,5)))
				</code>
			</dataFormatter>
		</datalinkCore>
	</service>


	<!-- again from carmenes -->
	<!-- a form-based service – this is made totally separate from the
		SSA part because grinding down SSA to something human-consumable and
		still working as SSA is non-trivial -->
	<service id="web" defaultRenderer="form">
		<meta name="shortName">\schema Web</meta>
		<meta name="title">Our Amazing Time Series Browser Service</meta>

		<dbCore queriedTable="ts_ssa">
			<condDesc buildFrom="ssa_location"/>
			<condDesc buildFrom="t_max"/>
<!--			<condDesc buildFrom="ssa_bandpass"/> -->

			<condDesc>	
				<inputKey original="ssa_bandpass" tablehead="Filter">
<!--				<values fromdb="ssa_bandpass from \schema.ts_ssa order by ssa_bandpass"/> -->
					<values fromdb="band from \schema.photosys order by band"/>
				</inputKey>
			</condDesc>
<!--					
			add further condDescs in this pattern; if you have useful target
					names, you'll probably want to index them and say: -->
			<condDesc>
				<inputKey original="ssa_targname" tablehead="Target Object">
					<values fromdb="ssa_targname from \schema.ts_ssa
						order by ssa_targname limit 10"/>
				</inputKey>
			</condDesc> 

		</dbCore>
		<outputTable>
			<autoCols>accref, ssa_targname, t_min, t_max, ssa_bandpass,
					datalink</autoCols>
				<FEED source="//ssap#atomicCoords"/>
		</outputTable>
	</service>

	<!-- TODO Check multicolor query, look at bgds/l.rd -->
	<service id="ssa" allowed="form,ssap.xml">
		<meta name="shortName">\schema TS SSAP</meta>
		<meta name="ssap.complianceLevel">full</meta>

		<publish render="ssap.xml" sets="ivo_managed"/>
		<publish render="form" sets="ivo_managed,local" service="web"/>

		<ssapCore queriedTable="ts_ssa">
			<property key="previews">auto</property>
			<FEED source="//ssap#hcd_condDescs"/>
		</ssapCore>
	</service>

	<!-- stolen from bgds/l,l2 -->
	<service id="preview" allowed="qp">
		<property name="queryField">obs_id</property>
		<meta name="title">Kolonica timeseries previews</meta>
        <meta name="description">
			A service returning PNG thumbnails for time series. It takes the obs id for which to generate a preview.
			JK: Here, I try to figure out how to play with these kinds of things.
			Actually, I haven't found these ts-previews very informative, especially for noisy data,
			but perhaps I'll manage to invent something
        </meta>
		<pythonCore>
			<inputTable>
				<inputKey name="obs_id" type="text"
					tablehead="Obs. Id"
					description="Observation id of the object to create the preview for."/>
			</inputTable>
			<coreProc>
				<setup>
					<code>
						from gavo.svcs import UnknownURI
						from gavo.helpers.processing import SpectralPreviewMaker
					</code>
				</setup>
				<code>
					obsId = inputTable.getParam("obs_id")
					# always go through a mapping here or you'll create a SQL injection (!!!)
					# try:
					#	srcTable = {
					#		"r": "bgds2.lc_r",
					#		"i": "bgds2.lc_i",
					#		# where are U? V? z? ...
					#		}[obsId.split("-")[3]]
					# except KeyError:
					#	raise UnknownURI("No time series in the %s band here"%
					# obsId.split("-")[3])
					# with base.getUntrustedConn() as conn:
					#		res = list(conn.query(
					#		"SELECT mjds, mags FROM %s WHERE obs_id=%%(obs_id)s"%
					#			srcTable, {"obs_id": obsId}))
					# passband = "B"
					# objId = "1"
					# print(f'{obsId=}')
					objId, passband = obsId.split("/")
					print("===================== AHA =====================================")
					with base.getUntrustedConn() as conn:
						res = list(conn.query(
							"SELECT extract(julian from l.dateobs at time zone 'UTC+12') AS obs_time, l.magnitude "
							"FROM \schema.lightcurves AS l "
							"JOIN upjs_vo.photosys AS p ON p.id = l.photosys_id "						
							"WHERE object_id=%(obj_id)s AND p.band=%(passband)s",
							{"obj_id": objId, "passband": passband}
						))
						print(f'{res=}')
					if not res:
						raise UnknownURI(f'No time series for {objId} {passband}')
					return "image/png", SpectralPreviewMaker.get2DPlot(res)

				</code>

			</coreProc>
		</pythonCore>
	</service>
</resource>
