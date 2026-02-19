<?xml version="1.0" encoding="utf-8"?>
<resource schema="shugarov_ts" resdir=".">
  <meta name="creationDate">2026-02-19T08:41:36Z</meta>
  <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>

  <meta name="title">Personal observations of S. Shugarov</meta>
  <meta name="description">
    This is a part of our project dedicated to publish variable stars
    observations, hidden on presonal and institutional arcives. All publications
    are made with permissions of owners
    TBD
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>

  <meta name="creator">Shugarov, S. Yu.</meta>
  <meta name="instrument">TBD</meta>
  <meta name="facility">TBD</meta>

  <meta name="source">2021Ap.....64..458S</meta>
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
        # we have artificial accrefs of the form /<id>-<band>;
        def unparseIdentifier(object, bandpass):
            """returns an accref from bandpass and object.
            """
            return f"{object}-{bandpass}"

        def parseIdentifier(id):
            """returns object and bandpass from an accref or a pubDID.
            """
            # assert "ogle" in id
            tail = id.split("/")[-1]
            object, bandpass = tail.rsplit("-", 1)  # object may contain "-"
            return object, bandpass

        rd.unparseIdentifier = unparseIdentifier
        rd.parseIdentifier = parseIdentifier
      ]]></code>
  </job></execute>



  <table id="raw_data" onDisk="True" adql="hidden"
      namePath="//ssap#instance">
    <meta name="table-rank">500</meta>
    <meta name="description">A united view over original ident tables for SSA/ObsCore ingestion</meta>

    <LOOP listItems="ssa_dstitle ssa_targname ssa_targclass
      ssa_pubDID ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext ssa_fluxucd
      ssa_timeExt ssa_length ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="//obscore#ObsCore.t_min"/>
    <column original="//obscore#ObsCore.t_max"/>

    <column original="//products#products.preview"/>

    <column original="//products#products.preview"/>


    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <index columns="ssa_targname"/>

    <FEED source="//scs#splitPosIndex"
      columns="ssa_location"
      long="degrees(long(ssa_location))"
      lat="degrees(lat(ssa_location))"/>

    <!-- the datalink column is mainly useful if you have a form-based
      service.  You can dump this (and the mapping rule filling it below)
      if you're not planning on web or don't care about giving them datalink
      access. -->
    <column name="datalink" type="text"
      ucd="meta.ref.url"
      tablehead="Datalink"
      description="A link to a datalink document for this timeseries"
      verbLevel="15" displayHint="type=url">

      <property name="targetType">application/x-votable+xml;content=datalink</property>
      <property name="targetTitle">Datalink</property>
    </column>

    <!-- custom columns -->

    <column name="mean_mag" type="real"
        ucd="phot.mag;stat.mean"
        unit="mag"
        tablehead="Mean magnitude"
        description="Stellar magnitude"
        verbLevel="1"
        required="False"/>

   <viewStatement>

      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT
          q.passband || ' lightcurve ' || 'for ' || q.object_id AS ssa_dstitle,
          q.object_id AS ssa_targname,
          ssa_targclass,
          spoint(o.raj_rad, o.dej_rad) as ssa_location,
          spoly(  -- I'm not crazy enough to draw hexagons there, put up with squares
               '{(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || '),'
             || '(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || ')' || '}'
          )::spoly AS ssa_region,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || q.object_id || '-' || q.passband AS accref,
          '\pubDIDBase' || q.object_id || '-' || q.passband AS ssa_pubdid,

          -- I prefer a folded lightcurve but we can put up with unfolded one sometimes
          -- CASE
          --  WHEN o.period IS NOT NULL THEN
          --    '\getConfig{web}{serverURL}/\rdId/preview-plot/qp/' || q.object_id || '-' || q.passband
          -- ELSE
          --    '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.object_id || '-' || q.passband
          -- END AS preview,

          '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.object_id || '-' || q.passband AS preview,

          'phot.mag;em.opt.' || q.passband AS ssa_fluxucd,
          q.passband AS ssa_bandpass,
          p.specmid AS ssa_specmid,
          p.specstart AS ssa_specstart,
          p.specend AS ssa_specend,
          p.specend-p.specstart AS ssa_specext,
          ssa_timeExt,
          t_min,
          t_max,
          q.ssa_length,
          q.mean_mag AS mean_mag,
          -- o.period AS period,
          -- o.epoch AS epoch,
          50000 AS accsize,
          NULL AS embargo,
          NULL AS owner,
          'application/x-votable+xml' AS mime,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlmeta?ID=' || '\pubDIDBase' || q.object_id || '-' || q.passband AS datalink,
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
        JOIN (
          SELECT *,
            radians(raj2000) AS raj_rad,
            radians(dej2000) AS dej_rad,
            radians(0.5/3600) AS aperture_rad
          FROM \schema.objects
        ) AS o USING (object_id)
        JOIN \schema.photosys AS p ON p.band_short = q.passband
      )

    </viewStatement>

  </table>

  <data id="create-raw-view">
    <recreateAfter>make-ssa-view</recreateAfter>
    <make table="raw_data"/>
  </data>

<!-- ================================== ts_ssa =========================== -->

  <table id="ts_ssa" onDisk="True" adql="True">
    <property name="forceStats">1</property>
    <meta name="table-rank">50</meta>
    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <meta name="description">
      This table contains metadata about the photometric time series from personal archive of S.Shugarov
      in IVOA SSA format. The actual data is available through a datalink service.
    </meta>

    <stc>
      TimeInterval UTC HELIOCENTER "t_min" "t_max"
    </stc>

<!--
      copiedcolumns="[!p]*"
-->

<!-- Add the column to map ssa_targname to for a natural join with objects* tables -->
    <column name="object_id" type="text" ucd="meta.id;meta.main"
        tablehead="Star ID" verbLevel="1" 
        description="Star identifier"
        required="True">
    </column>

    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      customcode=", ssa_targname AS object_id"
      ssa_aperture="1/3600."
      ssa_dstype="'timeseries'"
      ssa_fluxcalib="'CALIBRATED'"
      ssa_fluxunit="'mag'"
      ssa_spectralucd="NULL"
      ssa_spectralunit="NULL"
      ssa_creator="'Shugarov, S.'"
      ssa_csysName="'ICRS'"
      ssa_datasource="'pointed'"
      mime="'application/x-votable+xml'"
      ssa_targetpos="NULL"
      refposition="HELIOCENTER"
    >//ssap#view</mixin>
    
    <!--  coverage param is an alias of s_region param --> 
    <mixin
      calibLevel="2"
      t_min="t_min"
      t_max="t_max"
      em_xel="1"
      t_xel="ssa_length"
      s_region="ssa_region"
      oUCD="'phot.mag'"
      createDIDIndex="True"
      preview="preview"
    >//obscore#publishSSAPMIXC</mixin>
    <column original="ssa_publisher" type="unicode"/>    <!-- unicode allows diacrtric symbols -->
  </table>

  <data id="make-ssa-view" auto="False">
    <make table="ts_ssa"/>
  </data>

  <coverage>
    <updater sourceTable="ts_ssa"/>
  </coverage>

  <STREAM id="instance-template">
    <table id="instance_\band_short" onDisk="False">
      <!-- metadata modified by sdl's dataFunction -->
      <meta name="description">The lightcurve in the \band_human filter </meta>
      <!-- <meta name="source">2025AcA....65....1U</meta> -->
      <!-- JK: define them _before_ mentioning them the mixin -->
      <param original="ts_ssa.ssa_bandpass"/>
      <param original="ts_ssa.ssa_specmid"/>
        <mixin
          effectiveWavelength="\effective_wavelength"
          filterIdentifier='"\band_human"'
          magnitudeSystem="Vega"
          zeroPointFlux="\zero_point_flux"
          phot_description="Landolt magnitude in \band_human"
          phot_ucd='phot.mag;\band_ucd'
          phot_unit="mag"
          refposition="HELIOCENTER"
          refframe="ICRS"
          time0="2400000.5"
          timescale="UTC"
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
        <column original="shugarov_ts/t#lightcurves.facility"/>
        <column original="shugarov_ts/t#lightcurves.note"/>
    </table>
  </STREAM>

  <!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ -->
  <!-- zero point are from https://svo2.cab.inta-csic.es/theory/fps -->
  <!-- It would be interesting to have here a mixin like  //siap#getBandFromFilter but for ssap -->

  <LOOP source="instance-template">
    <csvItems>
            band_short, band_human, band_ucd, effective_wavelength, zero_point_flux
            U,          Bessell/U, em.opt.U, 3.6e-7, 1699.71
            B,          Bessell/B, em.opt.B, 4.4e-7, 3908.46
            V,          Bessell/V, em.opt.V, 5.4e-7, 3630.22
            R,          Bessell/R, em.opt.R, 6.2e-7, 3056.93
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
                   "SELECT l.obs_time, l.magnitude AS phot, l.mag_err, l.facility, l.note"
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
             # JK: does not work :-( How to specifify it for each ts instance from ssa_reference?
             # targetTable.setMeta("source", "2035AcA....65....1U")
             # targetTable.setMeta("publication_id", "2034AcA....65....1U")
             targetTable.setMeta("name", str(sourceId))
           </code>
         </apply>
      </parmaker>
    </make>
  </data>

  <service id="sdl" allowed="dlget,dlmeta,static">
    <meta name="title">S. Shugarov light curves Datalink Service</meta>
    <meta name="shortName">TS Datalink</meta>
    <meta name="description">
      This service produces time series datasets for lightcurves
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
              description=f"S.Shugarov archive time series for {targname} in {passband}",
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
            # Preview of folded lightcurve with period and epoch (if available)
            pubdid = descriptor.metadata['ssa_pubdid']
            target = descriptor.metadata['ssa_targname']
            band = descriptor.metadata['ssa_bandpass']

            # Try to pull period and epoch from the objects table:
            with base.getTableConn() as conn:
              res = next(conn.query(
                "SELECT period, epoch from shugarov_ts.objects where object_id=%(object)s",
                {"object": descriptor.metadata['ssa_targname']})
              )

            print(f"!!!!!!!!!!!!!!!!! {res=}")
            period, epoch = res
            # Check if the period is present:
            # period = descriptor.metadata['period']	# I eliminated period from ts_ssa as unnecessary duplication
            if period is None:
              # yield None
              yield DatalinkFault.NotFoundFault(target, "No period for this star known here")
            else:
              path_ending = "/".join(pubdid.split("/")[-2:])
              url = makeAbsoluteURL(f"\rdId/preview-plot/qp/{path_ending}")
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
                rd.getById("instance_" + bandid))
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
    <meta name="title">Folded lightcurve previews</meta>
    <meta name="shortName">TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails for folded time series. It takes the obs_id for which to generate a preview. 
        To calculate phases, period and epoch from objects view are used.
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

                    period_epoch = list(conn.query(
                      "SELECT period, epoch "
                        "FROM \schema.objects "
                        "WHERE object_id=%(obj_id)s LIMIT 1",
                        {"obj_id": objId}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              period, epoch = period_epoch[0] if len(period_epoch) > 0 else (None, None)
              if period is None:
                raise UnknownURI(f'We have no period for {objId}')
              # use epoch if present, otherwise take just the first observation
              jd0 = epoch if epoch is not None else res[0][0]
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
    <meta name="title">Timeseries previews</meta>
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


</resource>
