<?xml version="1.0" encoding="utf-8"?>
<resource schema="upjs_ts" resdir=".">
	<meta name="schema-rank">100</meta>
	<macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef> <!-- from bgds l2 -->

	<meta name="creationDate">2025-09-03T09:40:33Z</meta>

	<meta name="title"> Timeseries originating from small telescopes in Kolonica Observatory, Slovakia</meta>

	<meta name="description" format="rst">
		Time series in this collection were derived from CCD images obtained at the Kolonica Observatory, Slovakia.

		The observations were carried out to monitor selected fields centred on eclipsing binary
		stars with two small telescopes.

		The first instrument, ZIGA (PlaneWave CDK20, Corrected Dall–Kirkham), has a 508 mm aperture
		and is equipped with a Moravian Instruments G4-16000 CCD camera with UBVRI Bessell photometric filters.
		The second instrument, Alica (Explore Scientific MN-152, Maksutov–Newton), has a 152 mm aperture and
		is equipped with a Moravian Instruments G2-8300 CCD camera with Sloan g′ r′ i′ photometric filters.
		Both telescopes are currently in operation at the observatory.

		The time series were produced with a custom photometric pipeline (Parimicha, Š., in preparation).
		Differential photometry is performed using comparison star magnitudes from APASS DR9.

		Beyond the primary target (typically an eclipsing binary), the pipeline derives calibrated magnitudes
		for all stars in the field with sufficient signal-to-noise ratio.
		This approach, we believe, may help researchers follow the behaviour of other interesting objects over time.

		For each photometric point, we provide the list of comparison stars used in its calculation
		(which may vary for each star and each image).

		The corresponding calibrated images are published separately in the upjs_img image collection.
	</meta>

<!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
 	<meta name="subject">light-curves</meta>
 	<meta name="subject">variable-stars</meta>
	<meta name="subject">time-domain-astronomy</meta>
	<meta name="productType">timeseries</meta>

	<meta name="creator">UPJŠ</meta>
	<meta name="source">Parimucha, S., in prep.</meta>
	<meta name="instrument">ZIGA and Alica telescopes</meta>
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
	<meta name="ssap.testQuery">MAXREC=1</meta>

	<execute on="loaded" title="define id parse functions"><job>
		<code><![CDATA[
			# we have artificial accrefs of the form upjs/ts/<id>-<band>;
			# what we define here needs to be reflected in the viewStatement
			# of the raw_data table
			def unparseIdentifier(object, bandpass):
				"""returns an accref from bandpass and object.
				"""
				return f"upjs/ts/{object}-{bandpass}"

			def parseIdentifier(id):
				"""returns object and bandpass from an accref or a pubDID.
				"""
				assert "upjs/ts" in id
				tail = id.split("/")[-1]
				object, bandpass = tail.rsplit("-", 1)	# object may contain "-"
				return object, bandpass

			rd.unparseIdentifier = unparseIdentifier
			rd.parseIdentifier = parseIdentifier
		]]></code>
	</job></execute>

	<table id="raw_data" adql="True" onDisk="True" namePath="//ssap#instance">
        <meta name="table-rank">500</meta>
		<meta name="description">A view over lightcurves and objects for SSA/ObsCore ingestion</meta>

		<!-- list of metadata varying across datasets -->
		<LOOP listItems="ssa_dstitle ssa_targname
			ssa_pubDID ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext
			ssa_timeExt ssa_length ssa_reference">
 			<events>
				<column original="\item"/>
			</events>
		</LOOP>

		<column original="//ssap#instance.ssa_fluxucd" required="False"/>
		<column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>
		<!-- <column original="//products#products.accref"/> -->
		<column original="//products#products.preview"/>

		<mixin>//products#table</mixin>
		<mixin>//ssap#plainlocation</mixin>		<!-- injects ssa_location -->
		<mixin>//ssap#simpleCoverage</mixin>	<!-- ssa_region -->

		<index columns="ssa_targname"/>
		<index columns="ssa_bandpass"/>

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

		<column name="object_id" type="integer"
			ucd="meta.id;meta.main"
			tablehead="internal id"
			description="Object id in the original table"
			verbLevel="1"
			required="True"/>	<!-- think more about this, I really need this to produce lightcurve -->
		
		<column name="mean_mag" type="real"
			ucd="phot.mag;stat.mean"
			unit="mag"
			tablehead="mean magnitude"
			description="stellar magnitude"
			verbLevel="1"
			required="True"/>	<!-- And this column is worth showing to users -->

 		<column name="ra" type="double precision"
			ucd="pos.eq.ra;meta.main"
			tablehead="RA"
			verbLevel="1"
			unit="deg"
			description="Right ascension"
			required="False"/>

		<column name="dec"
			type="double precision"
			ucd="pos.eq.dec;meta.main"
			tablehead="Dec"
			verbLevel="1"
			unit="deg"
			description="Declination"
			required="False"/>

		<column original="filters/q#main.filter_id" name="fps_filter_id"/>

		<!-- note 1: accref = ...upjs_ts/q/object_id path for (future) product (lightcurve) this is carmenes-style
					'upjs_ts/q/' || o.id || '/' || p.band AS accref,
					 accref = '\getConfig{web}{serverURL}/bgds/l2/tsdl/dlget?ID='|| obs_id  - bgds-style
					'\getConfig{web}{serverURL}/upjs_ts/q/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,

			TODO!!!! Describe also the columns accref, and other. Should I? I see them in the database, but do not in TOPCAT
			JK: Macro works _inside_ the quoted string???? But it does!
				'\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,
 		-->
		
		
		<viewStatement>
			CREATE MATERIALIZED VIEW \curtable AS (
				SELECT \colNames FROM (				 -- magic ! otherwise i must follow there predefined column order
				SELECT
					'Kolonica lightcurve for Gaia DR3 ' || o.gaia_name AS ssa_dstitle,
					'Gaia DR3 ' || o.gaia_name AS ssa_targname,				 
					o.object_id,
					o.coordequ as ssa_location,
					spoly(
						'{(' || (long(o.coordequ) - aperture_ra_rad) || ',' || (lat(o.coordequ) - aperture_rad) || '),'
							|| '(' || (long(o.coordequ) - aperture_ra_rad) || ',' || (lat(o.coordequ) + aperture_rad) || '),'
							|| '(' || (long(o.coordequ) + aperture_ra_rad) || ',' || (lat(o.coordequ) + aperture_rad) || '),'
							|| '(' || (long(o.coordequ) + aperture_ra_rad) || ',' || (lat(o.coordequ) - aperture_rad) || ')}'
					)::spoly AS ssa_region,

					'\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' ||
					'\pubDIDBase' || 'upjs/ts/' || o.object_id || '-' || q.passband AS accref,

					'\pubDIDBase' || 'upjs/ts/' || o.object_id || '-' || q.passband AS ssa_pubdid,
					
					'\getConfig{web}{serverURL}/\rdId/preview/qp/' ||
					'upjs/ts/' || o.object_id || '-' || q.passband AS preview,

					'phot.mag;' || f.band_ucd AS ssa_fluxucd,

					q.passband AS ssa_bandpass,
					f.wavelength_ref * 1e-10 AS ssa_specmid,
					f.wavelength_min * 1e-10	AS ssa_specstart,
					f.wavelength_max * 1e-10	AS ssa_specend,
					f.width_eff * 1e-10 AS ssa_specext,
					q.fps_filter_id AS fps_filter_id,
					q.ssa_timeExt,
					q.t_min,
					q.t_max,
					q.ssa_length,
					q.mean_mag,
					50000 AS accsize,
					NULL::DATE AS embargo,
					NULL AS owner,
					'application/x-votable+xml' AS mime,
					'\getConfig{web}{serverURL}/\rdId/sdl/dlmeta?ID=' ||
					'\pubDIDBase' || 'upjs/ts/' || o.object_id || '-' || q.passband AS datalink,
					NULL AS ssa_reference,
					degrees(long(o.coordequ)) AS ra,
					degrees(lat(o.coordequ)) AS dec
				FROM (
					-- in general, there are no one-to-one passband-filter_id relations
					-- they are data-specific
					WITH passband_map(passband, fps_filter_id) AS (
						VALUES
							('U', 'Generic/Bessell.U'),
							('B', 'Generic/Bessell.B'),
							('V', 'Generic/Bessell.V'),
							('R', 'Generic/Bessell.R'),
							('I', 'Generic/Bessell.I'),
							('u_sdss', 'SLOAN/SDSS.u'),
							('g_sdss', 'SLOAN/SDSS.g'),
							('r_sdss', 'SLOAN/SDSS.r'),
							('i_sdss', 'SLOAN/SDSS.i'),
							('z_sdss', 'SLOAN/SDSS.z')
					)
					SELECT
						l.object_id, l.passband,
						count(*) AS ssa_length,
						(MAX(EXTRACT(julian FROM l.dateobs AT TIME ZONE 'UTC+12')) -
						MIN(EXTRACT(julian FROM l.dateobs AT TIME ZONE 'UTC+12'))) AS ssa_timeExt,
						MIN(EXTRACT(julian FROM l.dateobs AT TIME ZONE 'UTC+12')) - 2400000.5 AS t_min,
						MAX(EXTRACT(julian FROM l.dateobs AT TIME ZONE 'UTC+12')) - 2400000.5 AS t_max,						
						AVG(magnitude) AS mean_mag,
						COALESCE(m.fps_filter_id, l.passband) AS fps_filter_id

					FROM \schema.lightcurves AS l
					JOIN passband_map m
						ON l.passband = m.passband
					GROUP BY l.object_id, l.passband, fps_filter_id
				) AS q
				JOIN \schema.objects o USING(object_id)
				JOIN filters.main AS f ON f.filter_id = q.fps_filter_id
				CROSS JOIN LATERAL (
					SELECT
					RADIANS(1.5/3600.) AS aperture_rad,
					RADIANS(1.5/3600.) / COS(lat(o.coordequ)) AS aperture_ra_rad
				) AS ap
			) as ww			 -- end of colnames-magic 
			)

		</viewStatement>
		
	</table>

	<data id="create-raw-view">
		<recreateAfter>make-ssa-view</recreateAfter>
		<!-- <property key="previewDir">previews</property> We make previews on the fly, so we don't need this directory -->
		<make table="raw_data"/>		
	</data>

	<table id="ts_ssa" onDisk="True" adql="True">
		<meta name="table-rank">50</meta>
		<meta name="_associatedDatalinkService">		<!-- declared a table as having datalink support -->
			<meta name="serviceId">sdl</meta>			<!-- JK: this will go to the table metadata, TOPCAT use this sdl to build *sdl/dlmeta* stuff -->
			<meta name="idColumn">ssa_pubDID</meta>
		</meta>

		<meta name="description">
			This table contains metadata about the photometric timeseries 
			from Kolonica in IVOA SSA format. The actual data is
			available through a datalink service or in the lightcurves table.
		</meta>

		<!--
		JK: [!p]* ([^p]* does not work) excludes my private columns from the ssa view	- ??? this excludes t_min column too
		copied SSA columns cannot be overridden in mixin parameter (like ssa_bandpass)
			ssa_pubDID="\sql_standardPubDID"	-	we do it manullay in the raw_data
			copiedcolumns="[!p]*"
		-->
		<mixin
			sourcetable="raw_data"
			copiedcolumns="*"
			ssa_aperture="1/3600."
			ssa_collection="'Kolonica live timeseries'"
			ssa_dstype="'timeseries'"
			ssa_fluxcalib="'CALIBRATED'"
			ssa_fluxunit="'mag'"
			ssa_spectralucd="NULL"
			ssa_spectralunit="NULL"
			ssa_targclass="'star'"
			ssa_csysName="'ICRS'"
			ssa_datasource="'pointed'"
			mime="'application/x-votable+xml'"
			ssa_targetpos="NULL"
			refposition="BARYCENTER"
		>//ssap#view</mixin>

		<!-- caliblevel:
			0 - Raw instrumental data, in a proprietary or internal data-provider defined format
			1 - Instrumental data in a standard format (FITS, VOTable, etc )
			2 - Calibrated, science ready data with the instrument signature removed
			3 - Enhanced data products like mosaics, resampled or drizzled images, or heavily
				processed survey fields. Level 3 data products may represent the combination of data
				from multiple primary observations
		-->

		<!--  coverage param is an alias of s_region param --> 
		<mixin
			calibLevel="2"
			t_min="t_min"
			t_max="t_max"
			em_xel="1"
			t_xel="ssa_length"
			s_region="ssa_region"
			oUCD="ssa_fluxucd"
			createDIDIndex="True"
			preview="preview"
			dataproduct_subtype="'lightcurve'"
		>//obscore#publishSSAPMIXC</mixin>	<!-- JK: Note: We need to pass t_min/t_max parameters explicitly
			in the case of timeseries: defaults are appropriate for spectra only -->

		<!-- JK: Change the column type from text to unicode to allow our Slovak diacritic symbols -->
		<column original="ssa_publisher" type="unicode"/>
	</table>

	<data id="make-ssa-view" auto="False">		<!-- also stolen from carmenes t.rd auto=False "don't build this on an unadorned dachs imp" -->
		<make table="ts_ssa"/>
	</data>
	
	<coverage>
		<updater sourceTable="ts_ssa"/>
	</coverage>

	<table id="lc_instance" onDisk="False">
		<!-- metadata modified by sdl's dataFunction -->
		<meta name="description">The \metaString{source} lightcurve</meta>
		<param name="ra" type="double precision"
			ucd="pos.eq.ra"
			unit="deg"
			description="RA of source object"/>
		<param name="dec" type="double precision"
			ucd="pos.eq.dec"
		 	unit="deg"
		 	description="Dec of source object"/>
		<param name="filter" type="text"
			ucd="meta.id;instr.filter"
			description="Filter used."
			required="False">		<!-- otherwise we get "not given for param filter" error -->
		</param>

<!--
		<param name="mean_mag" type="real"
			ucd="phot.mag;stat.mean"
			unit="mag"
			description="stellar magnitude"/>
-->

		<param original="//ssap#instance.ssa_reference" name="bibcode"/>
		<param original="ts_ssa.ssa_targclass"/>
		<param original="ts_ssa.ssa_collection"/>
		<param original="ts_ssa.ssa_fluxucd"/>
		<param original="ts_ssa.mean_mag" required="False"/>	<!-- "False" otherwise we get "not given for param filter" error  -->
		<param original="ts_ssa.ssa_bandpass"/>
		<param original="ts_ssa.ssa_specmid" ucd="em.wl.effective"/>
		<param original="ts_ssa.fps_filter_id" required="False"/>
		<param original="filters/q#main.zeropoint"/>

		<mixin
			effectiveWavelength="@ssa_specmid"
			filterIdentifier="@fps_filter_id"
			magnitudeSystem="Vega"
			zeroPointFlux="@zeropoint"
			phot_ucd="phot.mag;em.opt"
			phot_unit="mag"
			refposition="BARYCENTER"
			refframe="ICRS"
			longitude="@ra"
			latitude="@dec"
			time0="2400000.5"
			timescale="TCB"
		>//timeseries#phot-0</mixin>
	
		<!-- Add my column -->
		<column name="mag_err" type="double precision"
			ucd="stat.error;phot.mag"
			unit="mag"
			tablehead="magnitude"
			description="stellar magnitude error"
			verbLevel="1"
			required="False"/>
		<column name="origin_image" type="text"
			ucd="meta.ref.url"
			tablehead="access_url"
			description="Path to access fits image"
			verbLevel="1"
			required="False"
			displayHint="type=product"/>

		<column name="airmass"
			ucd="obs.airMass"
			type="real"
			description="Airmass of the target"
			verbLevel="18"/>

		<column name="comp_stars" 
			type="text"
			tablehead="Comparison stars"
			ucd="meta.ref.url"
			verbLevel="10"
			description="Link to comparison stars for this photometry point"/>

	</table>

	<data id="build-ts" auto="False">
		<!--
		note 1: parmaker copies values from the SSA input row to the params in the
			instance table.
		-->
		<embeddedGrammar>
			<iterator>
				<code>
					object, passband = rd.parseIdentifier(
						self.sourceToken.metadata["ssa_pubdid"])	# in embeddedGrammar input is available as self.sourceToken

					with base.getTableConn() as conn:
						for row in conn.queryToDicts(
							"SELECT l.id as pp_id, l.dateobs as dateobs, l.magnitude AS phot, l.mag_err, "
							" 99.99 AS airmass, l.image_filename AS origin_image"
							" FROM \schema.lightcurves AS l"
							" WHERE object_id=%(object)s AND l.passband=%(passband)s"
							" ORDER BY l.dateobs",
							{"object": object, "passband": passband}
						):
							dt = row["dateobs"]
							dt_utc = dt.astimezone(datetime.timezone.utc) # I should have thrown out this trash
							row['obs_time'] = dateTimeToMJD(dt_utc)	# This doesn't take timezone into account (like "extract(julian from dateobs at time zone 'UTC+12'")
							row["comp_stars"] = makeAbsoluteURL("\rdId/comp_stars/qp/{}".format(row["pp_id"]))
							yield row
				</code>
			</iterator>
			<pargetter>
				<code>
					# print(f"\n\n pargetter code {self.sourceToken.metadata.keys()=}\n")
					# print(f"{self.sourceToken.metadata['mean_mag']=}")
					return self.sourceToken.metadata
				</code>
			</pargetter>
		</embeddedGrammar>

		<make table="lc_instance">	<!-- Now this is a real "instance" table -->
			<rowmaker idmaps="*" id="make-ts"/>			
			<!--parmaker can get parameters, provided by pargetter and write them as a metadata in the instance table -->
			<!--<parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specmid, t_min, t_max, ssa_location"> -->
			<!-- add mean_mag -->
			<parmaker id="make-ts-par" idmaps="ssa_targclass, ssa_collection, ssa_bandpass, ssa_fluxucd, ssa_specmid, mean_mag, fps_filter_id">
				<!-- Add additioanal stuff to the litghtcure VOTable metadata --> 
				<map dest="filter">@ssa_bandpass</map>
				<map dest="bibcode">@ssa_reference</map>
				<map dest="ra">@ssa_location.asDALI()[0]</map>
				<map dest="dec">@ssa_location.asDALI()[1]</map>

				<!--(from the tutorial) touch manually the instance table metadata -->
				<!-- Can I get into TABLE->FIELD phot to correct ucd (add band_ucd to phot.mag;)? -->
				<apply name="update_metadata">
					<code>
						# sourceId = vars["parser_"].sourceToken["ssa_targname"]	does not work
						sourceId = vars["ssa_targname"]		# works: in apply The current input fields are available in the vars dictionary
						ssa_bandpass = vars["ssa_bandpass"]
						targetTable.setMeta("description", base.getMetaText(targetTable, "description") +
							f" for {sourceId} in the {ssa_bandpass} filter")
						targetTable.setMeta("name", str(sourceId))
												
						# Retrieve information for the PhotCal from our database (zeropoint so far): 
						with base.getTableConn() as conn:
							di_filters = next(conn.queryToDicts(
							"SELECT band, zeropoint, band_ucd FROM filters.main"
							" WHERE filter_id=%(fps_filter_id)s",
							{"fps_filter_id":vars.get("fps_filter_id", None)}))
						# put it into the VOTable:
						zeropoint = di_filters.get("zeropoint", None)
						targetTable.setParam("zeropoint", zeropoint)

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

	<service id="comp_stars" allowed="qp">
		<property key="queryField">pp_id</property>
		<pythonCore>
			<inputTable>
				<inputKey name="pp_id" type="bigint" required="True"
					description="Identifier of a photometry point"/>
			</inputTable>

			<outputTable namePath="upjs_ts/t#objects" autoCols="gaia_name,ra,dec"/>

			<coreProc>
				<setup imports="gavo.api"/>
				<code>
					pp_id = inputTable.getParam("pp_id")
					with base.getTableConn() as conn:
						row = list(conn.query(
							"select comp_stars from upjs_ts.lightcurves"
							" where id=%(pp_id)s", {"pp_id": pp_id}))
						try:
							gdr3_ids = tuple(row[0][0])
						except Exception as e:
							print(f"something is wrong with comp_stars list: {e}")
							t = api.TableForDef(self.outputTable, rows=[])
							return("application/x-votable+xml", api.getAsVOTable(t))
						if not gdr3_ids:
							print("Empty list of comp_stars")
							t = api.TableForDef(self.outputTable, rows=[])
							return("application/x-votable+xml", api.getAsVOTable(t))

						t = api.TableForDef(
							self.outputTable,
							rows = conn.queryToDicts(
									"select gaia_name, ra, dec from upjs_ts.objects where gaia_name in %(gdr3_ids)s",
									{"gdr3_ids": gdr3_ids}
							)
						)
						return("application/x-votable+xml", api.getAsVOTable(t))
				</code>
			</coreProc>
		</pythonCore>
	</service>

	<service id="sdl" allowed="dlget,dlmeta,static">
		<!-- <property name="staticData">data/periodograms</property> -->
		<meta name="title">Kolonica light curves Datalink Service</meta>
		<meta name="shortName">TS Datalink</meta>
		<meta name="description">
			This service produces time series datasets for Kolonica lightcurves.
		</meta>

		<!-- The datalink#fromtable descriptor generator simply pulling a row from a database table.
			This row is made available as the .metadata attribute -->
		<datalinkCore>
			<descriptorGenerator procDef="//datalink#fromtable">
				<bind key="tableName">"\schema.ts_ssa"</bind>
				<bind key="idColumn">"ssa_pubdid"</bind>
				<!-- <bind key="didPrefix">"\pubDIDBase/upjs/ts/"</bind>  -->
				<setup>
					<code>
						def addExtras(desc):	# since DaCHS 2.13 ;(
							parts = desc.metadata["ssa_pubdid"].split("/")
							desc.object, desc.passband = rd.parseIdentifier(desc.metadata["ssa_pubdid"])
					</code>
				</setup>
			</descriptorGenerator>

			<!-- We should do #this explicitly without products table (using //datalink#fromtable) -->
			<metaMaker semantics="#this">
				<code>
					targname = descriptor.metadata["ssa_targname"]
					passband = descriptor.metadata["ssa_bandpass"]
					# targname = descriptor.object		since 2.13
					# passband = descriptor.passband
					yield descriptor.makeLink(
						descriptor.metadata["accref"],
						description=f"Kolonica time series for {targname} in {passband}",
						contentType="application/x-votable+xml",
						contentLength="15000",
						contentQualifier="#timeseries")
				</code>
			</metaMaker>

			<!-- todo
			<metaMaker semantics="#progenitor">
				<code>
					ra, dec = descriptor.metadata["ssa_location"].addCooPair()
					yield descriptor.makeLink(
						makeAbsoluteURL("upjs/t/calibrators/scs.xml?"
							"RA={}&amp;DEC={}&amp;SR=0.5".format(ra, dec),
						description="Calibrator stars for this time series' photometry"
							"points.", contentType="application/x-votable+xml"))
				</code>
			</metaMaker>
			-->

			<!-- My useless on-the-fly preview -->
			<metaMaker semantics="#preview">
				<code>
					pubdid = descriptor.metadata['ssa_pubdid']
					target = descriptor.metadata['ssa_targname']
					band = descriptor.metadata['ssa_bandpass']
					path_ending = "/".join(pubdid.split("/")[-3:])
					# url = makeAbsoluteURL(f"\rdId/preview/qp/{descriptor.objId}/{descriptor.band}")
					url = makeAbsoluteURL(f"\rdId/preview/qp/{path_ending}")
					yield descriptor.makeLink(
						url,
						description=f"Preview for {target} in {band}",
						contentType="image/png",
						contentLength="2000"
					)
				</code>
			</metaMaker>

			<!-- this is a placeholder 
			<metaMaker name="add_periodogram" semantics="#derivation">
				<code>
					yield descriptor.makeLinkFromFile(
						rd.getAbsPath(f"data/periodograms/picture.png"),
						description="Periodograms derivied from this time series")
				</code>
			</metaMaker>
			-->

			<!--
			dataFunction is executed by dlget
			The lightcurve sits in the PrimaryTable (?)
			dataFunction is stolen from bgds/l2
			-->
			<dataFunction>
				<setup imports="gavo.rsc"/>
				<code>
					_, bandid = rd.parseIdentifier(descriptor.metadata["ssa_pubdid"])
					# bandid = descriptor.passband	# since 2.13
					dd = rd.getById("build-ts")
					descriptor.data = rsc.Data.createWithTable(dd,
						rd.getById("lc_instance"))
					descriptor.data = rsc.makeData(
						dd,
						data=descriptor.data,
						forceSource=descriptor)
				</code>
			</dataFunction>

			<dataFormatter>
				<!-- to VOTable -->
				<setup imports="gavo.formats.votablewrite"/>
				<code>
					return ("application/x-votable+xml;version=1.6",
						votablewrite.getAsVOTable(descriptor.data, version=(1,6)))
						# votablewrite.getAsVOTable(descriptor.data, version=(1,5), tablecoding="binary"))
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
		<meta name="title">Kolonica Time Series Browser Service</meta>

		<dbCore queriedTable="ts_ssa">
			<condDesc buildFrom="ssa_location"/>
			<condDesc buildFrom="t_min"/>
			<condDesc buildFrom="t_max"/>
<!--			<condDesc buildFrom="ssa_bandpass"/> -->

			<condDesc>	
				<inputKey original="ssa_bandpass" tablehead="Filter">
					<values fromdb="ssa_bandpass from \schema.ts_ssa"/>
				</inputKey>
			</condDesc>
<!--					
			add further condDescs in this pattern; if you have useful target
					names, you'll probably want to index them and say: -->
			<condDesc>
				<inputKey original="ssa_targname" tablehead="Target Object">
					<values fromdb="ssa_targname from \schema.ts_ssa order by ssa_targname limit 10"/>
				</inputKey>
			</condDesc>

		</dbCore>
		<outputTable>
			<autoCols>accref, ssa_targname, t_min, t_max, ssa_bandpass,
					datalink</autoCols>
				<FEED source="//ssap#atomicCoords"/>
		</outputTable>
	</service>

	<service id="ssa" allowed="form,ssap.xml">
		<meta name="shortName">\schema TS SSAP</meta>
		<meta name="ssap.complianceLevel">full</meta>

		<publish render="ssap.xml" sets="ivo_managed"/>
		<publish render="form" sets="ivo_managed,local" service="web"/>

		<meta name="title">Kolonica light curves</meta>
		<meta name="description">This service exposes photometric light curves obtained
			with small telescopes at the Kolonica Observatory.
			The first published dataset covers observations from 2019–2021.
			The light curves are published per-band and are also discoverable
			through ObsCore.
		</meta>

		<ssapCore queriedTable="ts_ssa">
		<!--
			<property key="previews">auto</property>
			JK: auto produces wrong URLs in my case. Would it work properly if I populate products table?
			And does this really make sense?
		-->
			<FEED source="//ssap#hcd_condDescs"/>
		</ssapCore>
	</service>

	<!-- stolen from bgds/l,l2 -->
	<service id="preview" allowed="qp">
		<property name="queryField">obs_id</property>
		<meta name="title">Kolonica timeseries previews</meta>
		<meta name="shortName">TS previews</meta>
					<meta name="description">
			A service returning PNG thumbnails for time series. It takes the obs id for which to generate a preview.
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
					objId, passband = rd.parseIdentifier(
						inputTable.getParam("obs_id"))
					with base.getUntrustedConn() as conn:
						res = list(conn.query(
							"SELECT extract(julian from l.dateobs at time zone 'UTC+12') AS obs_time, l.magnitude "
							"FROM \schema.lightcurves AS l "
							"WHERE object_id=%(obj_id)s AND l.passband=%(passband)s",
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

	<service id="ex" allowed="examples">
		<meta name="title">Kolonica TAP examples</meta>
		<meta name="description">This service has examples of Kolonica timeseries queries</meta>

		<meta name="_example" title="Find objects that have VSX names">
			Find lightcurves of objects having VSX names in the :taptable:`upjs_ts.objects` table;
			these are known variable stars:

			.. tapquery::
				SELECT TOP 100 o.vsx_name, s.* FROM upjs_ts.ts_ssa s 
				NATURAL JOIN upjs_ts.objects o WHERE vsx_name IS NOT NULL
		</meta>

				<meta name="_example" title="Cone search using ssa_location">
						Find timeseries for object by simbad resolvable name
						using ssa_location (:taptable:`upjs_ts.ts_ssa`):

						.. tapquery::
								SELECT TOP 10 * FROM upjs_ts.ts_ssa
										WHERE 1=CONTAINS(ivo_simbadpoint('VY UMi'), CIRCLE(ssa_location, ssa_aperture))
				</meta>

				<meta name="_example" title="Cone search using ssa_region">
						Find timeseries for object by simbad resolvable name using
						ssa_region (:taptable:`upjs_ts.ts_ssa`):

						.. tapquery::
								SELECT TOP 10 * FROM upjs_ts.ts_ssa
										WHERE 1=CONTAINS(ivo_simbadpoint('BT Tau'), ssa_region)
				</meta>

		<nullCore/>
 	</service>

	<!-- ivo://astro.upjs/~?upjs_ts/q/upjs/ts/2309-R -->
	<regSuite title="upjs_ts regression">
		<regTest title="upjs_ts SSAP serves some data">
			<url REQUEST="queryData" PUBDID="ivo://astro.upjs/~?upjs_ts/q/upjs/ts/122-i_sdss"
				>ssa/ssap.xml</url>
					<code>
					# print(f'{self.data=}')
					self.assertHasStrings("Kolonica lightcurve for Gaia DR3 1704796837612266368", "258.65889999999996 76.77089999999973")
				</code>
		</regTest>

		<regTest title="upjs_ts Datalink metadata looks about right.">
			<url ID="ivo://astro.upjs/~?upjs_ts/q/upjs/ts/2309-R"
				>sdl/dlmeta</url>
			<code>
				# to figure out good items to test here, you probably want to
				# dachs test -k datalink	q
				# and pprint the by_sem dict
				# by_sem = self.datalinkBySemantics()
				# print(by_sem)
				# self.fail("Fill this in")
				self.assertHasStrings("Gaia DR3 1704793573437107328 in R")
			</code>
		</regTest>

		<regTest title="upjs_ts delivers some data.">
			<url ID="ivo://astro.upjs/~?upjs_ts/q/upjs/ts/2217-V">
				sdl/dlget</url>
			<code>
				# to figure out some good strings to use here, run
				# dachs test -k "delivers data" -D tmp.xml q
				# and look at tmp.xml
				self.assertHasStrings('Gaia DR3 1704791992889145344', 'utype="ssa:DataID.Bandpass" value="V"')
			</code>
		</regTest>
	</regSuite>
</resource>
