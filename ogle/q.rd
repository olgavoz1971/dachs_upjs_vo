<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>

  <meta name="creationDate">2025-12-21T16:24:52Z</meta>

  <meta name="title">OGLE Time series</meta>
  <meta name="description" format="rst">
    I promis, I'll fill this properly before publishing any data from this
    collection
    this should be a paragraph or two (take care to mention salient terms)
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  
    Poleski, R.; Pawlak, M.; Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.
  </meta>
  <meta name="instrument">TBD</meta>
  <meta name="facility">OGLE TBD</meta>

  <meta name="source">2015AcA....65....1U</meta>

  <meta name="copyright" format="rst">
    If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
      :bibcode: `2015AcA....65....1U`  (OGLE-IV photometry)
      :bibcode: `2008AcA....58...69U`  (OGLE-III photometry)
  </meta>

  <meta name="contentLevel">Research</meta>
  <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">Optical</meta>


  <meta name="ssap.dataSource">survey</meta>
  <meta name="ssap.creationType">archival</meta>
  <meta name="productType">timeseries</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <execute on="loaded" title="define id parse functions"><job>
    <code><![CDATA[
        # we have artificial accrefs of the form ogle/<id>-<band>;
        def unparseIdentifier(object, bandpass):
            """returns an accref from bandpass and object.
            """
            return f"{object}-{bandpass}"

        def parseIdentifier(id):
            """returns object and bandpass from an accref or a pubDID.
            """
            # assert "ogle" in id
            tail = id.split("/")[-1]
            object, bandpass = tail.rsplit("-", 1)	# object may contain "-"
            return object, bandpass

        rd.unparseIdentifier = unparseIdentifier
        rd.parseIdentifier = parseIdentifier
      ]]></code>
  </job></execute>

<!-- ======================= United Objects View ============================= -->

  <macDef name="objects_description">
    This table is a unified catalogue of objects from the OGLE Collection of Variable Star Light Curves.
    It was constructed by merging variable-type–specific ident.dat tables with selected columns 
    from tables containing parameters: cep.dat, cepF.dat, cep1O.dat, cepF1O.dat, cep1O2O.dat, cep1O2O3O.dat, 
    cep2O3O.dat, Miras.dat, and others.

    The corresponding light curves can be discovered via TAP through the ts_ssa or obscore tables, 
    or through the SSA service. Light curves can be extracted using the associated DataLink services.
  </macDef>

  <macDef name="object_common_cols">
    object_id, raj2000, dej2000, period, period_err, ampl_I, mean_I, mean_V, vartype, ogle_vartype, 
    ssa_reference, ssa_collection
  </macDef>

  <macDef name="param_common_cols">
    object_id, period, period_err, ampl_I, mean_I, mean_V
  </macDef>


<!-- Supposed to be serviced by scs -->
<!-- Check uniqueness of object_id in the Regression test 
     select object_id, count(*) AS n
       from ogle.objects_all
       group by object_id
       having count(*) > 1;
-->
  <table id="objects_all" adql="True" onDisk="True"
         mixin="//scs#pgs-pos-index" namePath="ogle/aux#object">

    <meta name="table-rank">100</meta>
    <meta name="description">
      \objects_description
     </meta>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <stc>
      Position ICRS "raj2000" "dej2000"
    </stc>

    <LOOP listItems="object_id raj2000 dej2000 period period_err ampl_I
               mean_I mean_V vsx vartype ogle_vartype subtype ssa_reference ssa_collection">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM (
          WITH 
            param_blg_cep_all AS (													-- blg cep
              SELECT \param_common_cols FROM \schema.param_blg_cep_cepf
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_cep_cepf1o
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_cep_cep1o
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_cep_cep1o2o
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_cep_cep1o2o3o
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_cep_cep2o3o
            ),
            param_blg_rr_all AS (													-- blg rrlyr
              SELECT \param_common_cols FROM \schema.param_blg_rr_ab
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_rr_c
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_rr_d
              UNION ALL
              SELECT \param_common_cols FROM \schema.param_blg_arr_d
            )
          SELECT \object_common_cols, vsx, pulse_mode AS subtype					-- blg cep
          FROM \schema.ident_blg_cep
          LEFT JOIN param_blg_cep_all USING (object_id)
        UNION ALL
          SELECT \object_common_cols, vsx, subtype									-- blg rrlyr
          FROM \schema.ident_blg_rr
          LEFT JOIN param_blg_rr_all USING (object_id)
        UNION ALL
          SELECT \object_common_cols, vsx, NULL AS subtype							-- blg lpv
          FROM \schema.ident_blg_lpv
          LEFT JOIN \schema.param_blg_lpv USING (object_id)
        UNION ALL
          SELECT \object_common_cols, vsx, subtype									-- blg dsct
          FROM \schema.ident_blg_dsct
          LEFT JOIN \schema.param_blg_dsct USING (object_id)
        UNION ALL
          SELECT \object_common_cols, vsx, subtype									-- blg hb
          FROM \schema.ident_blg_hb
          LEFT JOIN \schema.param_blg_hb USING (object_id)
        UNION ALL
          SELECT \object_common_cols, NULL AS vsx, NULL AS subtype					-- misc m54
          FROM \schema.m54
        ) AS all_objects)           

    </viewStatement>
  </table>

  <data id="create-objects_all-view">
    <make table="objects_all"/>
  </data>

<!--
  <coverage>   
    <updater spaceTable="objects_all"/>
    <spatial/>
  </coverage>
-->

<!--   Cone Search  -->
  <service id="ogle-objects" allowed="form,scs.xml">
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>

    <meta name="shortName">All OGLE Objects</meta>
    <meta name="title">OGLE objects Cone Search</meta>
    <meta name="description">
      \objects_description
    </meta>
    <meta name="_related" title="OGLE Varable Stars Time series"
            >\internallink{\rdId/ts-web/info}
    </meta>

    <meta>
      testQuery.ra: 263.562625
      testQuery.dec: -27.398250
      testQuery.sr:   0.0001
    </meta>

    <scsCore queriedTable="objects_all">
      <FEED source="//scs#coreDescs"/>
        <condDesc buildFrom="mean_I"/>
        <condDesc buildFrom="mean_V"/>
        <condDesc buildFrom="period"/>
        <condDesc buildFrom="vsx"/>
        <condDesc>
          <inputKey original="vsx">
            <values fromdb="vsx from \schema.objects_all"/>
          </inputKey>
        </condDesc>
    </scsCore>
  </service>

<!--   =========================== raw_data ======================== -->

  <table id="raw_data" onDisk="True" adql="True"
      namePath="//ssap#instance">
    <meta name="description">A united view over original ident tables for SSA/ObsCore ingestion</meta>

    <!-- the table with your custom metadata; it is transformed
      to something palatable for SSA and Obscore using the view below -->
    <!-- JK: We create a Materialised View across different ident.dat tables. 
      They are non-homogeneous, variable-type specific. But we try to do our best -->

    <!-- for an explanation of what columns will be defined in the
      final view, see http://docs.g-vo.org/DaCHS/ref.html#the-ssap-view-mixin.
      Don't mention anything constant here; fill it in in the view
      definition.
    -->

    <!-- metadata actually varies among data sets -->
    <!-- JK: ssa_region comes from ssap#simpleCoverage mixin, and does not reside in ssap#instance.
         accref, mime, owner, embargo come from products#table mixin
         ssa_location resides in both, ssap#instance and ssap#plainlocation
    -->
    <LOOP listItems="ssa_dstitle ssa_targname ssa_targclass
      ssa_pubDID ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext 
      ssa_timeExt ssa_length ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="//obscore#ObsCore.t_min"/>
    <column original="//obscore#ObsCore.t_max"/>

    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <FEED source="//scs#splitPosIndex"
      columns="ssa_location"
      long="degrees(long(ssa_location))"
      lat="degrees(lat(ssa_location))"/>

    <!-- JK: We create two different spatial indexes on the same column ssa_location - gist and q3c. 
      Are they for different kinds of queries? -->  

    <!-- the datalink column is mainly useful if you have a form-based
      service.  You can dump this (and the mapping rule filling it below)
      if you're not planning on web or don't care about giving them datalink
      access. -->
    <column name="datalink" type="text"
      ucd="meta.ref.url"
      tablehead="Datalink"
      description="A link to a datalink document for this spectrum."
      verbLevel="15" displayHint="type=url">

      <property name="targetType">application/x-votable+xml;content=datalink</property>
      <property name="targetTitle">Datalink</property>
    </column>

    <!-- custom columns -->

    <column name="p_mean_mag" type="real"
        ucd="phot.mag;stat.mean"
        unit="mag"
        tablehead="Mean magnitude"
        description="Stellar magnitude"
        verbLevel="1"
        required="False"/>   <!-- And this column is worth showing to users -->

    <column original="objects_all.period" name="p_period"/>

    <!-- ssap#fill-plainlocation mixin converts rd,dec into ssa_location
      (spoint) and ssa_region, but do not forget add aperture 
      Unfortunately no, we can not apply this fill-plainlocation because we do not have 
      rowmaker here, while working with a view-->

    <viewStatement>

      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT
          'OGLE ' || q.passband || ' lightcurve ' || 'for ' || q.object_id AS ssa_dstitle,
          q.object_id AS ssa_targname,
          vartype AS ssa_targclass,
          spoint(radians(o.raj2000), radians(o.dej2000)) as ssa_location,
          NULL::spoly AS ssa_region,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || q.object_id || '-' || q.passband AS accref,
          '\pubDIDBase' || q.object_id || '-' || q.passband AS ssa_pubdid,
          q.passband AS ssa_bandpass,
          p.specmid AS ssa_specmid,
          p.specstart AS ssa_specstart,
          p.specend AS ssa_specend,
          p.specend-p.specstart AS ssa_specext,
          ssa_timeExt,
          t_min,
          t_max,
          q.ssa_length,
          mean_mag AS p_mean_mag,
          o.period AS p_period,
          'ICRS' AS ssa_csysName,
          'application/x-votable+xml' AS mime,
          50000 AS accsize,
          NULL AS embargo,
          NULL AS owner,
          NULL AS datalink,
          o.ssa_collection,
          o.ssa_reference
        FROM (
          SELECT
            l.object_id, l.passband,
            count(*) AS ssa_length,
            MAX(l.obs_time) - MIN(l.obs_time) AS ssa_timeExt,
            MIN(l.obs_time) AS t_min,
            MAX(l.obs_time) AS t_max,
            AVG(magnitude) AS mean_mag
          FROM \schema.lightcurves AS l
            GROUP BY l.object_id, l.passband
        ) AS q
        JOIN \schema.objects_all AS o USING (object_id)
        JOIN \schema.photosys AS p ON p.band_short = q.passband
      )

    </viewStatement>
  </table>

  <data id="create-raw-view">
    <recreateAfter>make-ssa-view</recreateAfter>
    <!-- <property key="previewDir">previews</property> -->
    <make table="raw_data"/>
  </data>

<!-- ================================== ts_ssa =========================== -->

  <table id="ts_ssa" onDisk="True" adql="True">
    <meta name="table-rank">50</meta>
    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <meta name="description">
      This table contains metadata about the OGLE the photometric time series
      in IVOA SSA format. The actual data is available through a datalink
      service.
    </meta>

    <stc>
      TimeInterval UTC HELIOCENTER "t_min" "t_max"
    </stc>

<!--
      copiedcolumns="[!p]*"
-->

    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      ssa_aperture="1/3600."
      ssa_dstype="'timeseries'"
      ssa_fluxcalib="'CALIBRATED'"
      ssa_fluxucd="'phot.mag'"
      ssa_spectralucd="NULL"
      ssa_spectralunit="NULL"
      ssa_creator="'OGLE Team'"
      ssa_csysName="'ICRS'"
      ssa_datasource="'survey'"
    >//ssap#view</mixin>
    
    <mixin
      calibLevel="2"
      t_min="t_min"
      t_max="t_max"
      em_xel="1"
      t_xel="ssa_length"
      coverage="ssa_region"
      oUCD="'phot.mag'"
      createDIDIndex="True"
    >//obscore#publishSSAPMIXC</mixin>

    <column original="ssa_publisher" type="unicode"/>    <!-- unicode allows diacrtric symbols -->
  </table>

  <data id="make-ssa-view" auto="False">
    <make table="ts_ssa"/>
  </data>

  <coverage>
    <updater sourceTable="ts_ssa"/>
  </coverage>

<!--
  <coverage>
    <updater timeTable="ts_ssa"/>
    <temporal/>
    <updater spaceTable="objects_all"/>
    <spatial/>
  </coverage>
-->

  <STREAM id="instance-template">
    <table id="instance_\band_short" onDisk="False">
      <!-- metadata modified by sdl's dataFunction -->
      <meta name="description">The \metaString{source} lightcurve in the \band_human filter </meta>

      <!-- JK: define them _before_ mentioning them the mixin -->
      <param original="ts_ssa.ssa_bandpass"/>
      <param original="ts_ssa.ssa_specmid"/>
        <mixin
          effectiveWavelength="\effective_wavelength"
          filterIdentifier='"\band_human"'
          magnitudeSystem="Vega"
          zeroPointFlux="\zero_point_flux"
          phot_description="OGLE magnitude in \band_human"
          phot_ucd='phot.mag;\band_ucd'
          phot_unit="mag"
          refposition="HELIOCENTER"
          refframe="ICRS"
          time0="2400000.5"
          timescale="TCB"
        >//timeseries#phot-0</mixin>

        <param original="ts_ssa.t_min"/>
        <param original="ts_ssa.t_max"/>
        <param original="ts_ssa.ssa_location"/>

        <!-- Add my column -->
        <column name="mag_err" type="double precision"
          ucd="stat.error;phot.mag"
          unit="mag"
          tablehead="magnitude"
          description="stellar magnitude error"
          verbLevel="1"
          required="False"/>
        <column original="ogle/aux#lc.ogle_phase"/>
    </table>
  </STREAM>

  <!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ -->
  <!-- zero point are from https://svo2.cab.inta-csic.es/theory/fps -->
  <!-- TODO How to read it from the database????  -->
  <LOOP source="instance-template">
    <csvItems>
            band_short, band_human, band_ucd, effective_wavelength, zero_point_flux
            V,          Bessell/V, em.opt.V, 5.4e-7, 3630.22
            I,          Bessell/I, em.opt.I, 8.3e-7, 2415.65
    </csvItems>
  </LOOP>

  <data id="build-ts" auto="False">
    <embeddedGrammar>
      <iterator>
        <code>
          object, passband = rd.parseIdentifier(self.sourceToken.metadata["ssa_pubdid"])    # in embeddedGrammar input is available as self.sourceToken

          with base.getTableConn() as conn:
            yield from conn.queryToDicts(
                   "SELECT l.obs_time, l.magnitude AS phot, l.mag_err, l.ogle_phase"
                   " FROM \schema.lightcurves AS l"
                   " WHERE object_id=%(object)s AND l.passband=%(passband)s"
                   " ORDER BY l.obs_time",
                   {"object": object, "passband": passband})
        </code>
      </iterator>
      <pargetter>
        <code>
          return self.sourceToken.metadata
        </code>
      </pargetter>
    </embeddedGrammar>

    <make table="instance_V">   <!-- just a placeholder, we don't have the bare "instance" table. But we need a name from the LOOP -->
      <rowmaker idmaps="*" id="make-ts"/>

      <!-- parmaker can get parameters, provided by pargetter and write them as a metadata in the instance table -->
      <parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specmid, t_min, t_max, ssa_location">
         <!--tut: touch manually the instance table metadata -->
         <apply name="update_metadata">
           <code>
             sourceId = vars["ssa_targname"]     # in apply the current input fields are available in the vars dictionary
             targetTable.setMeta("description", base.getMetaText(targetTable, "description") +
                 " for {}".format(sourceId))
             targetTable.setMeta("name", str(sourceId))
           </code>
         </apply>
      </parmaker>
    </make>
  </data>

  <service id="sdl" allowed="dlget,dlmeta,static">
    <meta name="title">OGLE light curves Datalink Service</meta>
    <meta name="shortName">TS Datalink</meta>
    <meta name="description">
      This service produces time series datasets for OGLE lightcurves.
    </meta>

    <!-- The datalink#fromtable descriptor generator simply pulling a row from a database table.
            This row is made available as the .metadata attribute -->
    <datalinkCore>
      <descriptorGenerator procDef="//datalink#fromtable">
        <bind key="tableName">"\schema.ts_ssa"</bind>
        <bind key="idColumn">"ssa_pubdid"</bind>
        <!-- <bind key="didPrefix">"\pubDIDBase/upjs/ts/"</bind>  -->
      </descriptorGenerator>

      <!-- We should make #this and #preview explicitly without products table (using //datalink#fromtable) -->
      <metaMaker semantics="#this">
        <code>
          targname = descriptor.metadata["ssa_targname"]
          passband = descriptor.metadata["ssa_bandpass"]
          yield descriptor.makeLink(
              descriptor.metadata["accref"],
              description=f"OGLE time series for {targname} in {passband}",
              contentType="application/x-votable+xml",
              contentLength="15000",
              contentQualifier="#timeseries")
        </code>
      </metaMaker>

      <metaMaker semantics="#preview">
        <code>
            pubdid = descriptor.metadata['ssa_pubdid']
            target = descriptor.metadata['ssa_targname']
            band = descriptor.metadata['ssa_bandpass']
            path_ending = "/".join(pubdid.split("/")[-2:])
            url = makeAbsoluteURL(f"\rdId/preview/qp/{path_ending}")
            yield descriptor.makeLink(
                url,
                description=f"Preview for {target} in {band}",
                contentType="image/png",
                contentLength="2000"
            )
        </code>
      </metaMaker>

      <metaMaker semantics="#preview-plot">
        <code>
            # TODO raise something reasonable in case of absent information about the period
            pubdid = descriptor.metadata['ssa_pubdid']
            target = descriptor.metadata['ssa_targname']
            band = descriptor.metadata['ssa_bandpass']
            period = descriptor.metadata['p_period']
            print(f'metaMaker semantics="#preview-plot" {period=}')
            if period is None:
              # yield None
              yield DatalinkFault.NotFoundFault(target, "No period for this star known here")
            else:
              path_ending = "/".join(pubdid.split("/")[-2:])
              url = makeAbsoluteURL(f"\rdId/preview-plot/qp/{path_ending}")
              if period:
                  print('Period!')
              yield descriptor.makeLink(
                url,
                description=f"Preview of folded lightcurve for {target} in {band}",
                contentType="image/png",
                contentLength="2000"
              )
        </code>
      </metaMaker>

      <dataFunction>
        <setup imports="gavo.rsc"/>
        <code>
            _, bandid = rd.parseIdentifier(descriptor.metadata["ssa_pubdid"])
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

  <service id="preview-plot" allowed="qp">
    <property name="queryField">obs_id</property>
    <meta name="title">OGLE folded lightcurve previews</meta>
    <meta name="shortName">TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails for folded time series. It takes the obs_id for which to generate a preview. 
        To calculate phases, period from objects_all view is used.
    </meta>
    <pythonCore>
        <inputTable>
          <inputKey name="obs_id" type="text"
              tablehead="Obs. Id"
              description="Observation id (a combination of an object id and a passband) to create the preview for."/>
        </inputTable>
        <coreProc>
            <setup>
                <code>
                    from gavo.svcs import UnknownURI
                    from gavo.helpers.processing import SpectralPreviewMaker
                </code>
            </setup>
            <code>
              objId, passband = rd.parseIdentifier(inputTable.getParam("obs_id"))
              with base.getUntrustedConn() as conn:
                    res = list(conn.query(
                        "SELECT l.obs_time, l.magnitude "
                        "FROM \schema.lightcurves AS l "
                        "WHERE object_id=%(obj_id)s AND l.passband=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

                    period = list(conn.query(
                      "SELECT period "
                        "FROM \schema.objects_all "
                        "WHERE object_id=%(obj_id)s LIMIT 1",
                        {"obj_id": objId}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              print(f'--- qp renderer for previews {period=}')
              period = period[0][0] if len(period) > 0 else None
              print(f'--- qp renderer for previews {period=}')
              if period is None:
                raise UnknownURI(f'We have no period for {objId}')
              jd0 = res[0][0]
              folded = [
                     ((jd - jd0) / period % 1.0, mag)
                     for jd, mag in res
              ]

              # Invert y-axis:
              jds, mags = zip(*folded)
              lc = list(zip(jds, [-m for m in mags]))
              return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>

  <service id="preview" allowed="qp">
    <property name="queryField">obs_id</property>
    <meta name="title">OGLE timeseries previews</meta>
    <meta name="shortName">TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails for time series. It takes the obs id for which to generate a preview.
    </meta>
    <pythonCore>
        <inputTable>
          <inputKey name="obs_id" type="text"
              tablehead="Obs. Id"
              description="Observation id (a combination of an object id and a passband) to create the preview for."/>
        </inputTable>
        <coreProc>
            <setup>
                <code>
                    from gavo.svcs import UnknownURI
                    from gavo.helpers.processing import SpectralPreviewMaker
                </code>
            </setup>
            <code>
              objId, passband = rd.parseIdentifier(inputTable.getParam("obs_id"))
              with base.getUntrustedConn() as conn:
                    res = list(conn.query(
                        "SELECT l.obs_time, l.magnitude "
                        "FROM \schema.lightcurves AS l "
                        "WHERE object_id=%(obj_id)s AND l.passband=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              # Invert y-axis:
              jds, mags = zip(*res)
              lc = list(zip(jds, [-m for m in mags]))
              return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>

  <!-- a form-based service – this is made totally separate from the
  SSA part because grinding down SSA to something human-consumable and
  still working as SSA is non-trivial -->

  <service id="ts-web" defaultRenderer="form">
    <meta name="shortName">\schema Web</meta>
    <meta name="title">OGLE Time Series Browser Service</meta>

    <dbCore queriedTable="ts_ssa">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="t_min"/>
      <condDesc buildFrom="t_max"/>
      <condDesc buildFrom="ssa_bandpass"/>
      <!-- <condDesc>
        <inputKey original="ssa_bandpass" tablehead="Filter">
          <values fromdb="DISTINCT ssa_bandpass from \schema.ts_ssa order by ssa_bandpass"/>
        </inputKey>
      </condDesc> -->
 
      <condDesc>
        <inputKey original="ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname from \schema.ts_ssa order by ssa_targname limit 10"/>
        </inputKey>
      </condDesc>


<!--      <condDesc>
        <inputKey original="ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname from \schema.ts_ssa order by ssa_targname limit 10"/>
        </inputKey>
      </condDesc> -->

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
    <publish render="form" sets="ivo_managed,local" service="ts-web"/>

    <meta name="title">OGLE light curves Form</meta>
    <meta name="description">This service exposes OGLE photometric light curves
          The light curves are published per-band and are also discoverable
          through ObsCore.
    </meta>

    <ssapCore queriedTable="ts_ssa">
      <property key="previews">auto</property>
      <FEED source="//ssap#hcd_condDescs"/>
    </ssapCore>
  </service>

</resource>
