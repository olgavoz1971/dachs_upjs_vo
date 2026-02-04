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
 	<meta name="productType">timeseries</meta>
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
		<meta name="description">A view over lightcurves and objects for SSA/ObsCore ingestion</meta>

		<!-- list of metadata varying across datasets -->
		<LOOP listItems="ssa_dstitle ssa_targname ssa_pubDID ssa_length ssa_timeExt ssa_bandpass
					ssa_specmid ssa_specstart ssa_specend ssa_specext ssa_csysName">
 			<events>
				<column original="\item"/>
			</events>
		</LOOP>

		<column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>
		<column original="//products#products.accref"/>
		<column original="//products#products.preview"/>

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
			ucd="pos.eq.ra;meta.main"
			tablehead="RA"
			verbLevel="1"
			unit="deg"
			description="Right ascension"
			required="False"/>

		<column name="p_dec"
			type="double precision"
			ucd="pos.eq.dec;meta.main"
			tablehead="Dec"
			verbLevel="1"
			unit="deg"
			description="Declination"
			required="False"/>

		<!-- note 1: accref = ...upjs_ts/q/object_id path for (future) product (lightcurve) this is carmenes-style
					'upjs_ts/q/' || o.id || '/' || p.band AS accref,
					 accref = '\getConfig{web}{serverURL}/bgds/l2/tsdl/dlget?ID='|| obs_id  - bgds-style
					'\getConfig{web}{serverURL}/upjs_ts/q/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,

			TODO!!!! Describe also the columns accref, and other. Should I? I see them in the database, but do not in TOPCAT
			JK: AAAAA!!! How does this macro work _inside_ the quoted string???? But it does!
				'\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || o.id || '/' || p.band AS accref,
 		-->
		<viewStatement>
			CREATE MATERIALIZED VIEW \curtable AS (
			SELECT
				'Kolonica lightcurve for Gaia DR3 ' || o.gaia_name AS ssa_dstitle,
				o.id AS p_object_id,
				'Gaia DR3 ' || o.gaia_name AS ssa_targname,
				o.coordequ AS ssa_location,
				spoly(  -- draw squares instead of hexagons
					'{(' || (long(o.coordequ) - aperture_rad) || ',' || (lat(o.coordequ) - aperture_rad) || '),'
					|| '(' || (long(o.coordequ) - aperture_rad) || ',' || (lat(o.coordequ) + aperture_rad) || '),'
					|| '(' || (long(o.coordequ) + aperture_rad) || ',' || (lat(o.coordequ) + aperture_rad) || '),'
					|| '(' || (long(o.coordequ) + aperture_rad) || ',' || (lat(o.coordequ) - aperture_rad) || ')' || '}'
					)::spoly AS ssa_region,
				-- NULL::spoly AS ssa_region,
				'\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || 'upjs/ts/' || o.id || '-' || p.band AS accref,
				'\pubDIDBase' || 'upjs/ts/' || o.id || '-' || p.band AS ssa_pubdid,
				'application/x-votable+xml' AS mime,
				'\getConfig{web}{serverURL}/\rdId/preview/qp/' || 'upjs/ts/' || o.id || '-' || p.band AS preview,
				50000 AS accsize,
				NULL AS embargo,
				NULL AS owner,
				NULL AS datalink,
				q.ssa_timeExt,
				p.band AS ssa_bandpass,
				p.specmid AS ssa_specmid,
				p.specstart AS ssa_specstart,
				p.specend AS ssa_specend,
				p.specend - p.specstart AS ssa_specext,
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
				CROSS JOIN LATERAL (SELECT RADIANS(0.5/3600.) AS aperture_rad) AS c 
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
			This table contains metadata about the photometric time
			series from Kolonica in IVOA SSA format. The actual data is
			available through a datalink service or in the lightcurves table.
		</meta>

		<!--
		JK: [!p]* ([^p]* does not work) excludes my private columns from the ssa view  - ??? this excludes t_min column too
		copied SSA columns cannot be overridden in mixin parameter (like ssa_bandpass)
			ssa_pubDID="\sql_standardPubDID"  -  we do it manullay in the raw_data
			copiedcolumns="[!p]*"
		-->
		<mixin
			sourcetable="raw_data"
			copiedcolumns="*"
			ssa_aperture="1/3600."
			ssa_collection="'Kolonica live timeseries'"
			ssa_dstype="'timeseries'"
			ssa_fluxcalib="'CALIBRATED'"
			ssa_fluxucd="'phot.mag'"
			ssa_spectralucd="NULL"
			ssa_spectralunit="NULL"
			ssa_targclass="'star'"
		>//ssap#view</mixin>

		<!-- caliblevel:
			0 - Raw instrumental data, in a proprietary or internal data-provider defined format
			1 - Instrumental data in a standard format (FITS, VOTable, etc )
			2 - Calibrated, science ready data with the instrument signature removed
			3 - Enhanced data products like mosaics, resampled or drizzled images, or heavily
				processed survey fields. Level 3 data products may represent the combination of data
				from multiple primary observations
		-->

		<mixin
			calibLevel="2"
			t_min="t_min"
			t_max="t_max"
			em_xel="1"
			t_xel="ssa_length"
			coverage="ssa_region"
			oUCD="'phot.mag'"
			createDIDIndex="True"
			preview="preview"
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


	<!-- JK: Build separate templates for different bands
		stolen from bgds/l
		This template is for the table definition *for a single time series* as used
		by datalink.

		TODO: fill this properly
		zeroPointFlux - Flux at the given zero point, in Jy
		effectiveWavelength - Central wavelength - take it from the photsys table

		TODO: ssa_targname is not seen there, do something to fix that issue
		TODO: add zeropints to the photosys table
		TODO: take bands parameters from to photosys table, do not doule them here
		TODO: check region, I don't have it yet
	-->
	<STREAM id="instance-template">
		<table id="instance_\band_short" onDisk="False">
			<!-- metadata modified by sdl's dataFunction -->
			<meta name="description">The \metaString{source} lightcurve in the
			\band_human filter </meta>

    	<!-- JK: define them _before_ mentioning them the mixin -->
			<param original="ts_ssa.ssa_bandpass"/>
			<param original="ts_ssa.ssa_specmid"/>
				<mixin
					effectiveWavelength="\effective_wavelength"
					filterIdentifier='"\band_human"'
					magnitudeSystem="Vega"
					zeroPointFlux="\zero_point_flux"
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
	</STREAM>

	<!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ -->
	<!-- zero point are from https://svo2.cab.inta-csic.es/theory/fps -->
	<LOOP source="instance-template">
		<csvItems>
			band_short, band_human, band_ucd, effective_wavelength, zero_point_flux
			U, 			Bessell/U, em.opt.U, 3.6e-7, 1699.71
			B, 			Bessell/B, em.opt.B, 4.4e-7, 3908.46
			V, 			Bessell/V, em.opt.V, 5.4e-7, 3630.22
			R, 			Bessell/R, em.opt.R, 6.2e-7, 3056.93
			I, 			Bessell/I, em.opt.I, 8.3e-7, 2415.65
			u_sdss,		   u/sdss, em.opt.U, 3.56e-7, 1456.61
			g_sdss,		   g/sdss, em.opt.B, 4.71e-7, 3996.23
			r_sdss,		   r/sdss, em.opt.R, 6.18e-7, 3148.77
			i_sdss,		   i/sdss, em.opt.I, 7.49e-7, 2508.91
			z_sdss,		   z/sdss, em.opt.I, 8.96e-7, 1909.06
		</csvItems>
	</LOOP>

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
							" JOIN \schema.photosys AS p ON p.id = l.photosys_id"
							"  WHERE object_id=%(object)s AND p.band=%(passband)s"
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
					return self.sourceToken.metadata
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
						sourceId = vars["ssa_targname"]		# works: in apply The current input fields are available in the vars dictionary
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
				<bind key="didPrefix">"\pubDIDBase/upjs/ts/"</bind>
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
						rd.getById("instance_"+bandid))
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
		<meta name="title">Kolonica Time Series Browser Service</meta>

		<dbCore queriedTable="ts_ssa">
			<condDesc buildFrom="ssa_location"/>
			<condDesc buildFrom="t_max"/>
<!--			<condDesc buildFrom="ssa_bandpass"/> -->

			<condDesc>	
				<inputKey original="ssa_bandpass" tablehead="Filter">
<!--					<values fromdb="ssa_bandpass from \schema.ts_ssa order by ssa_bandpass"/> -->
					<values fromdb="band from \schema.photosys order by band"/>
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
							"JOIN upjs_ts.photosys AS p ON p.id = l.photosys_id "						
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
				# dachs test -k datalink  q
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
