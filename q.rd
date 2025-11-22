<resource schema="upjs_vo" resdir=".">
    <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>	<!-- bgds l2 -->

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
		GRANT SELECT ON upjs_vo.observations TO gavoadmin WITH GRANT OPTION;
		GRANT SELECT ON upjs_vo.photosys TO gavoadmin WITH GRANT OPTION;
		GRANT SELECT ON upjs_vo.photosys TO gavo;
	-->
 
 	<table id="photosys" onDisk="True" adql="Hidden">
		<meta name="description">External table containing photometric systems data</meta>
		<column name="id" type="integer"
			ucd="meta.id;meta.main" 
			tablehead="internal id" 
			description="Observation id in the original table" 
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


 	<table id="objects" onDisk="True" adql="Hidden">
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

	<table id="observations" onDisk="True" adql="Hidden">
		<meta name="description">External table containing information on fits-images</meta>
		<column name="id" type="integer"
			ucd="meta.id;meta.main"
			tablehead="internal id"
			description="Image id in the original table"
			verbLevel="1"
			required="True"/>

		<column name="dateobs" type="timestamp"
			ucd="time.epoch" 
			tablehead="dateobs" 
			description="Timestamp with timezone" 
			verbLevel="1" 
			required="True"/>

		<column name="accumtime" type="real" 
			ucd="time.duration;obs.exposure"
			unit="s"
			tablehead="accumtime" 
			description="Image accumulation time" 
			verbLevel="1" 
			required="True"/>

		<column name="fov" type="spoint"
			ucd="pos.angdistance;instr.fov"
			tablehead="FOV" 
			description="Field of view of the image along axes (1,2)" 
			verbLevel="1" 
			required="True"/>

		<column name="band" type="text"
			ucd="meta.id;instr.filter"
			tablehead="filter"
			description="photometric filter from the fits-header"
			verbLevel="1"
			required="True"/>

		<column name="coordequ" type="spoint"
			ucd="pos.eq;meta.main"
			tablehead="coordequ" 
			description="Equatorial coordiantes ICRS in the original table (rad, rad)" 
			verbLevel="1" 
			required="False"/>

		<column name="filename" type="text"
			ucd="meta.id;meta.file"
			tablehead="filename"
			description="File name of the fits"
			verbLevel="14"
			required="False"/>

		<column name="path_to_fits" type="text"
			ucd="meta.ref;meta.file"
			tablehead="file path"
			description="Fits file path"
			verbLevel="14"
			required="False"/>
	</table>

	<data id="publish_obsevations_orig" updating="True">
		<!-- <make table="observations"/> -->
	</data>

<!-- I want to implement siap2, so I need a View, correct? The reason why I
don't actually want to make this table from scratch is obsevation_id -
which is used to join lightcurves points with fits images. They are in the
existing database -->

	<table id="observations_siap2" onDisk="True" adql="True">
		<meta name="description">SIAP2 view on the observations table</meta>
		<mixin>//siap2#pgs</mixin>			<!-- JK: All this into one heap????? siap2 + products table???  -->
		<mixin>//products#table</mixin>		<!-- form carmenes -->
		<mixin preview="access_url || '?preview=True'"
			>//obscore#publishObscoreLike</mixin>

		<column name="observation_id" type="integer"
			description="Observation id in the original observations table"
			ucd="meta.id;meta.main" 
			tablehead="internal id" 
			verbLevel="1" 
			required="True"/>

		<column name="airmass"
			ucd="obs.airMass"
			description="Airmass of the target"
			verbLevel="18"/>

		<column name="band" type="text"
			ucd="meta.id;instr.filter"
			tablehead="filter"
			description="photometric filter from the fits-header"
			verbLevel="1"
			required="True"/>

		<!-- This is extra HJust to pass import, where I stuck
		<column name="accref" type="text"
			ucd="meta.id"
			tablehead="accref"
			description="some extra accref"
			verbLevel="1"
			required="True"/>
		-->

		<column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>

		<!-- fill fields from header-realted table 
				'\getConfig{web}{serverURL}/\rdId' || path_to_fits || '/' || filename AS access_url,
				pgsphere.SPoint.fromDALI(coordequ, degrees(fov[0])/60) AS s_region,

				em_min, em_max - use //siap#getBandFromFilter to fill them
				NULL::spoly AS s_region,	
				scircle(coordequ, radians(s_fov/2)) AS s_region,

		-->
		<viewStatement>
            CREATE MATERIALIZED VIEW \curtable AS
            SELECT 
				band, 
				observation_id, 
				t_exptime,
				t AS t_min,
				t AS t_max,
				s_fov,
				spoly(
					'{(' || (ra_rad - radians(s_fov/2)) || ',' || (dec_rad - radians(s_fov/2)) || '),'
					|| '(' || (ra_rad - radians(s_fov/2)) || ',' || (dec_rad + radians(s_fov/2)) || '),'
					|| '(' || (ra_rad + radians(s_fov/2)) || ',' || (dec_rad + radians(s_fov/2)) || '),'
					|| '(' || (ra_rad + radians(s_fov/2)) || ',' || (dec_rad - radians(s_fov/2)) || ')'
					|| '}'
					)::spoly AS s_region,
				NULL AS s_resolution,
				NULL AS t_resolution,
				3.5E-7 AS em_min,
				8.0E-7 AS em_max,
				NULL AS em_res_power,
				'phot.flux.density' AS o_ucd,
				NULL AS pol_states,
				instrument_name,
				facility_name,
				airmass,
				s_xel1,
				s_xel2,
				1 AS t_xel,
				1 AS em_xel,
				1 AS pol_xel,
				s_pixel_scale,
				NULL AS em_ucd,
				'\schema.observations_siap2' AS source_table,
				'image' AS dataproduct_type,
				NULL AS dataproduct_subtype,
				1 AS calib_level,
				'Kolonica' AS obs_collection,
				'Kolonica CCD placeholder' AS obs_title,
				target_name,
				'star' AS target_class,
				NULL AS obs_creator_did,
				access_url,
				'application/fits' AS access_format,
				access_estsize,
				obs_publisher_did,
				obs_id,
				accref,
				NULL as owner,
				NULL as embargo,
				50000 AS accsize,
				'image/fits' AS mime,
				degrees(ra_rad) AS s_ra,
				degrees(dec_rad) AS s_dec
			FROM (
				SELECT
					band,
					o.id AS observation_id,
					accumtime AS t_exptime,
					extract(julian from dateobs at time zone 'UTC+12') - 2400000.5 AS t,
					coordequ,
					long(coordequ) AS ra_rad,
					lat(coordequ) AS dec_rad,
					LEAST(degrees(fov[0]), degrees(fov[1])) AS s_fov,
					(m.data->>'INSTRUME') AS instrument_name,
					(m.data->>'TELESCOP') AS facility_name,
					(m.data->>'AIRMASS')::float AS airmass,
					(m.data->>'NAXIS1')::int AS s_xel1,
					(m.data->>'NAXIS2')::int AS s_xel2,
					((m.data->>'XPIXSZ')::float / ((m.data->>'FOCALLEN')::float * 1000)) * 206265 AS s_pixel_scale,
					(m.data->>'OBJECT') AS target_name,
					replace(path_to_fits, '/home/skvo/data/upjs', 'upjs_vo/data') || '/' || filename AS access_url,
					FLOOR(((m.data->>'BITPIX')::int / 8.0 * (m.data->>'NAXIS1')::int * (m.data->>'NAXIS2')::int) / 1024)::int AS access_estsize,
					'\pubDIDBase' || filename AS obs_publisher_did,
					'\pubDIDBase' || filename AS obs_id,
					replace(path_to_fits, '/home/skvo/data/upjs', 'upjs_vo/data') || '/' || filename AS accref
				FROM \schema.observations AS o
				JOIN \schema.metadata_obs_json AS m ON o.id = m.observation_id
			) AS foo;
		</viewStatement>
	</table>

	<data id="create-observations-view">	
		<make table="observations_siap2">	<!-- from carmenes - Seems, I need to do this mannually  -->
			<script type="preImport" lang="SQL">
				DELETE FROM dc.products WHERE sourcetable='upjs_vo.observations_siap2'
			</script>
			<script type="postCreation" lang="SQL" name="add to product table">
				INSERT INTO dc.products (SELECT
					accref,
					owner,
					NULL as embargo,
					mime,
					accref as accesspath,
					source_table as sourcetable,
					NULL as preview,
					NULL as datalink,
					'image/png' as preview_mime
				FROM upjs_vo.observations_siap2);					
			</script>
		</make>
	</data>

	<service id="s" allowed="form,siap2.xml">
		<meta name="shortName">My shiny SIAP2 service</meta>
		<meta name="sia.type">Pointed</meta>
		<meta name="testQuery.pos.ra">258.5</meta>
		<meta name="testQuery.pos.dec">76.8</meta>
		<meta name="testQuery.size.ra">0.1</meta>
		<meta name="testQuery.size.dec">0.1</meta>

		<publish render="siap2.xml" sets="ivo_managed"/>

		<dbCore queriedTable="observations_siap2">
		<FEED source="//siap2#parameters"/>
		<condDesc buildFrom="airmass"/>
	</dbCore>
</service>



 	<table id="lightcurves" onDisk="True" adql="Hidden">
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
				description="Barycentric time; timestamp with timezone" 
				verbLevel="1" 
				required="True"/>

		<column name="magnitude" type="real" 
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

	</table>

	<data id="publish_lightcurves_orig" updating="True">
		<!-- <make table="lightcurves"/> -->
	</data>


	<table id="raw_data" adql="True" onDisk="True" namePath="//ssap#instance">
		<meta name="description">A view over lightcurves and objects for SSA/ObsCore ingestion</meta>

		<!-- list of metadata varying across datasets -->
		<LOOP listItems="ssa_dstitle ssa_targname ssa_pubDID ssa_length ssa_timeExt ssa_bandpass 
					ssa_specmid ssa_csysName">
 			<events>
				<column original="\item"/>
			</events>
		</LOOP>

		<column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>

		<!-- <mixin>//products#table</mixin>	JK: I wonder if I really need products if I deal with on-the-fly data only -->
		<mixin>//ssap#plainlocation</mixin>		<!-- injects ssa_location -->
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

<!--
		<column name="p_filename" type="text"
			ucd="meta.id;meta.file"
			tablehead="file name"
			description="Fits file name"
			verbLevel="14"/>
-->
		<!-- note 1: accref = ...upjs_vo/q/object_id path for (future) product (lightcurve) this is carmenes-style
					'upjs_vo/q/' || o.id || '/' || p.band AS accref,
					 accref = '\getConfig{web}{serverURL}/bgds/l2/tsdl/dlget?ID='|| obs_id  - bgds-style
					'\getConfig{web}{serverURL}/upjs_vo/q/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,

			TODO!!!! Describe also the columns accref, and other. Should I? I see them in the database, but do not in TOPCAT 
			JK: AAAAA!!! How does this macro work _inside_ the quoted string???? But it does!
 		-->
		<viewStatement>
			CREATE OR REPLACE VIEW \curtable AS (
			SELECT
				'Kolonica Gaia DR3 ' || o.gaia_name AS ssa_dstitle,
				o.id AS p_object_id,
				'Gaia DR3 ' || o.gaia_name AS ssa_targname,
				o.coordequ AS ssa_location,
				NULL::spoly AS ssa_region,
				'\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,
				'\pubDIDBase' || o.id || '/' || p.band AS ssa_pubdid,
				'application/x-votable+xml' AS mime,
				50000 AS accsize,
				NULL AS embargo,
				NULL AS owner,
				NULL AS datalink,
				q.ssa_timeExt,
				p.band AS ssa_bandpass,
				p.specmid AS ssa_specmid,
				q.t_min,
				q.t_max,
				q.ssa_length,
				degrees(long(o.coordequ)) AS p_ra,
				degrees(lat(o.coordequ)) AS p_dec,
				mean_mag AS p_mean_mag,
				'ICRS' AS ssa_csysName
			FROM (
				SELECT
					l.object_id, l.photosys_id,
					COUNT(*) AS ssa_length,
					(MAX(extract(julian from l.dateobs at time zone 'UTC+12')) -
					MIN(extract(julian from l.dateobs at time zone 'UTC+12'))) AS ssa_timeExt,
					MIN(extract(julian from l.dateobs at time zone 'UTC+12')) - 2400000.5 AS t_min,
					MAX(extract(julian from l.dateobs at time zone 'UTC+12')) - 2400000.5 AS t_max,
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

		<make table="raw_data">		
		<!-- 
			do this manually because we din't have place for rowfilter //products#define 
			<script type="preImport" lang="SQL">
				DELETE FROM dc.products WHERE sourcetable='upjs_vo.raw_data';
			</script>

			Do I really  need this stuff? Let;s try to do without it
			<script type="postCreation" lang="SQL" name="add to product table">
				INSERT INTO dc.products (SELECT
					accref,
					owner,
					NULL AS embargo,
					mime,
					\sqlquote{\internallink{/upjs_vo/q/sdl/dlget?ID=}} ||
						gavo_urlescape(accref) AS accesspath,
					'upjs_vo.raw_data' AS sourcetable,
					'upjs_vo/previews/' || accref || '.png' AS preview,
					NULL AS datalink,
					'image/png' AS preview_mime
				FROM upjs_vo.raw_data);
			</script>
		-->
		</make>
	</data>

	<table id="ts_ssa" onDisk="True" adql="True">		<!-- also stolen from carmenes t.rd  -->
		<meta name="_associatedDatalinkService">		<!-- declared a table as having datalink support -->
			<meta name="serviceId">sdl</meta>			<!-- JK: this will go to the table metadata, TOPCAT use this sdl to build *sdl/dlmeta* stuff -->
			<meta name="idColumn">ssa_pubDID</meta>
		</meta>

		<!--
		JK: [!p]* ([^p]* does not work) excludes my private columns from the ssa view  - ??? this excludes t_min column too
		copied SSA columns cannot be overridden in mixin parameter (like ssa_bandpass)
			ssa_pubDID="\sql_standardPubDID"  -  we do it manullay in the raw_data
		-->
		<mixin
			sourcetable="raw_data"
			copiedcolumns="[!p]*"
			ssa_aperture="1/3600."
			ssa_collection="'Kolonica live timeseries'"
			ssa_dstype="'timeseries'"
			ssa_fluxcalib="'CALIBRATED'"
			ssa_fluxucd="'phot.mag'"
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
			<column original="observations.filename"/>

			<column name="access_url" type="text"
				ucd="meta.ref.url"
				tablehead="access_url"
				description="Path to access fits image"
				verbLevel="1"
				required="False"/>

			<column name="airmass"
				ucd="obs.airMass"
				description="Airmass of the target"
				verbLevel="18"/>

	        <!-- JK: Add also something kind of:
	        <column original="lightcurves.process_info"/>   my jsonb from lc_metadata
	        -->

		  </table>
	</STREAM>

	<!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ ??? -->
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
		
	<data id="build-ts" auto="False"> 
		<!-- stolen from carmenes 
		note 1: parmaker copies values from the SSA input row to the params in the instance table.
        note 2: pargetter gets parameters from the related row of the parent table (ssa-table) to fill instance table metadata
		-->
		<embeddedGrammar>
			<iterator>
				<code>
					obsId = self.sourceToken.accref.split('ID=')[-1]	# self.sourceToken points to the clicked ssa_table row
					object = obsId.split("/")[-2]
					passband = obsId.split("/")[-1]	# TODO use this as a band
					print(f"\n===================== build-ts == {obsId=} {object=} {passband=}\n")
					with base.getTableConn() as conn:
						for row in conn.queryToDicts(
							"SELECT l.dateobs as dateobs, magnitude AS phot, mag_err, airmass, "
							" \sqlquote{\internallink{/getproduct/}} || gavo_urlescape(i.access_url) as access_url"
							"  FROM \schema.lightcurves AS l"
							" JOIN \schema.photosys AS p ON p.id = l.photosys_id"
							" JOIN \schema.observations_siap2 AS i ON i.observation_id = l.observation_id"
							"  WHERE object_id=%(object)s AND p.band=%(passband)s"
							" ORDER BY l.dateobs",
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
		static for prepared things (like periodogramms)
		descriptorGenerator: dataset description
		JK: As we abandoned dc.products there (following bgds) and
		can't use ProductDescriptor.fromAccref() anymore, we need to steal bgds TSDescriptor class
		metaMaker: makes #* stuff (semantics)
		dataFunction: builds ts
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
				<setup>
					<code>
						from gavo import svcs

						class TSDescriptor(ProductDescriptor):	# bgds l2
							def __init__(self, pubDID):
								# We accept "local" pubDIDs (without ivo://...?), too
								print(f'\n=== {pubDID=} ====\n')
								if pubDID.startswith("ivo://"):
									self.pubDID = pubDID
									# accref = urllib.parse.unquote_plus(pubDID.split("?")[-1])
									# self.accreff = accref
								else:
									self.pubDID = '\pubDIDBase'+pubDID
								self.objId = pubDID.split("/")[-2]
								self.band = pubDID.split("/")[-1]
								print(f'\n=== {self.pubDID=} {self.objId=} {self.band=} ====\n')

								self.suppressAutoLinks = True	# I don't know what this means, just copy
								# print(f'============= {accref=} ======\n')
								with base.getTableConn() as conn:
									res = list(conn.queryToDicts(
										"SELECT * FROM \schema.ts_ssa WHERE ssa_pubDID=%(pubdid)s",
										{"pubdid": self.pubDID}))
								if not res:
									raise svcs.UnknownURI("No timeseries for %s" % self.pubDID)
								self.ssa_row = res[0]
								self.accref = self.ssa_row['accref']
								print(f'============= {self.ssa_row=} ==============')
					</code>
				</setup>
				<code>
					return TSDescriptor(pubDID)		# this turns into descriptor I will use below
				</code>
			</descriptorGenerator>

			<!-- We should do #this explicitly without products table -->
			<metaMaker semantics="#this">
				<code>
					acrf = descriptor.ssa_row["accref"]
					print(f'==================== metaMaker semantics=#this {acrf=}')
					yield descriptor.makeLink(
					descriptor.ssa_row["accref"],	# JK: seems, I already have it
					description=f"Kolonica time series for {descriptor.objId} in {descriptor.band}",
					contentType="application/x-votable+xml",
					contentLength="15000",
					contentQualifier="#timeseries")
				</code>
			</metaMaker>

			<!-- My useless on-the-fly preview -->
			<metaMaker semantics="#preview">
				<code>
					print(f'============ metaMaker semantics=#preview {descriptor.objId=} {descriptor.band=}')
					url = makeAbsoluteURL(f"\rdId/preview/qp/{descriptor.objId}/{descriptor.band}")
					print(f'{url=}')
					yield descriptor.makeLink(
						url,
						description=f"Preview for {descriptor.objId} in {descriptor.band}",
						contentType="image/png",
						contentLength="2000"
					)
				</code>
			</metaMaker>

			<!-- I don't have fits_accref yet, TODO --> 

			<metaMaker name="add_periodogram" semantics="#derivation">
				<!-- todo -->
				<code>
					yield descriptor.makeLinkFromFile(
						rd.getAbsPath(f"data/periodograms/placeholder.pdf"),
						description="Periodograms derivied from this time series")
				</code>
			</metaMaker>

			<!-- 
			"#this" and #preview content comes automatically from the dc.products table 
			dataFunction is executed by dlget (?)
			The lightcurve sits in the PrimaryTable (?)
			dataFunction is stolen from bgds/l2
			-->
			<dataFunction>
				<setup imports="gavo.rsc"/>
				<code>
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
						from astropy.stats import sigma_clip
						from numpy import nan
					</code>
				</setup>
				<code>
					obsId = inputTable.getParam("obs_id")
					objId, passband = obsId.split("/")
					print(f"===================== AHA PRVIEW == {obsId=} {objId=}")
					with base.getUntrustedConn() as conn:
						res = list(conn.query(
							"SELECT extract(julian from l.dateobs at time zone 'UTC+12') AS obs_time, l.magnitude "
							"FROM \schema.lightcurves AS l "
							"JOIN upjs_vo.photosys AS p ON p.id = l.photosys_id "						
							"WHERE object_id=%(obj_id)s AND p.band=%(passband)s",
							{"obj_id": objId, "passband": passband}
						))
					if not res:
						raise UnknownURI(f'No time series for {objId} {passband}')
					# Try to clean data, kind of:
					jds, mags = zip(*res)
					clipped_mags = sigma_clip(mags, sigma=3)
					cleaned_data = list(zip(jds, -1*clipped_mags.filled(nan)))	# How to invert y-axis?
					return "image/png", SpectralPreviewMaker.get2DPlot(cleaned_data, linear=True, connectPoints=False)
					# return "image/png", SpectralPreviewMaker.get2DPlot(res, linear=True, connectPoints=False)
				</code>
			</coreProc>
		</pythonCore>
	</service>
</resource>
