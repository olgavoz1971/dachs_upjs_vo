<?xml version="1.0" encoding="utf-8"?>
<resource schema="gaiadr3_eb" resdir=".">
  <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>

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

  <meta name="creationDate">2026-02-22T15:53:36Z</meta>

  <meta name="title">Gaia DR3 eclipsing binaries</meta>
  <meta name="description" format="rst">
        This schema contains data re-published from the official
        Gaia DR3 TAP services (e.g., ivo://uni-heidelberg.de/gaia/tap).
        It provides simplified access to data related to eclipsing binary stars,
        including epoch photometry and basic parameters from the gaiadr3.gaia_source
        and gaiadr3.vari_eclipsing_binary tables. Timeseries are available via SSAP and DataLink.
  </meta>
  <meta name="creator">
        <meta name="name">GAIA Collaboration</meta>
  </meta>

  <meta name="source">2023A&amp;A...674A...1G</meta>

  <meta name="content">
        <meta name="type">Catalog</meta>
  </meta>
  <meta name="coverage.waveband">Optical</meta>
  <meta name="schema-rank">70</meta>

  <meta name="subject">surveys</meta>
  <meta name="subject">astrometry</meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>

  <meta name="facility">Gaia</meta>
  <meta name="instrument">Gaia</meta>

  <meta name="copyright" format="rst">
        If you use public Gaia DR3 data in a paper, please take note of
        `ESAC's guide`_ on how to acknowledge and cite it.

        .. _ESAC's guide: https://gea.esac.esa.int/archive/documentation/GDR3/Miscellaneous/sec_credit_and_citation_instructions/
  </meta>

  <coverage>  
        <temporal>2015-06-01 2015-06-01</temporal>
        <spatial>0/0-11</spatial>
        <spectral>1.986e-19 4.966e-19</spectral>
  </coverage>

<!-- ================= SSA stuff ======================== -->

  <meta name="ssap.dataSource">survey</meta> 
  <meta name="ssap.creationType">archival</meta>
  <meta name="productType">timeseries</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden"
      namePath="//ssap#instance">
    <meta name="table-rank">500</meta>
    <meta name="description">Gaia DR3 timeseries of eclipsing binaries for SSA/ObsCore ingestion</meta>

    <LOOP listItems="ssa_dstitle
      ssa_pubDID ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext ssa_fluxucd
      ssa_timeExt ssa_length">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="//obscore#ObsCore.t_min"/>
    <column original="//obscore#ObsCore.t_max"/>
    <column original="//products#products.preview"/>


    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <!-- <index columns="ssa_targname"/> -->
    <index columns="source_id"/>
    <index columns="ssa_bandpass"/>

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

    <column name="source_id" 
      type="bigint"
      ucd="meta.id;meta.main"
      tablehead="GaiaDR3 identifier"
      description="Unique source identifier within Gaia DR3"
      required="True"/>

   <viewStatement>

      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT
          'Gaia DR3 ' || q.band || ' lightcurve for ' || q.source_id AS ssa_dstitle,
           q.source_id,
          -- 'Gaia DR3 ' || q.source_id AS ssa_targname,
          spoint(o.raj_rad, o.dej_rad) as ssa_location,
          spoly(  -- I'm not crazy enough to draw hexagons there, put up with squares
               '{(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || '),'
             || '(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || ')' || '}'
          )::spoly AS ssa_region,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || q.source_id || '-' || q.band AS accref,
          '\pubDIDBase' || q.source_id || '-' || q.band AS ssa_pubdid,

          -- I prefer a folded lightcurve but we can put up with unfolded one sometimes
          CASE
            WHEN b.frequency IS NOT NULL THEN
              '\getConfig{web}{serverURL}/\rdId/preview-plot/qp/' || q.source_id || '-' || q.band
            ELSE
              '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.source_id || '-' || q.band
          END AS preview,

          -- '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.source_id || '-' || q.band AS preview,

          'Gaia ' || q.band AS ssa_bandpass,
          'phot.flux;em.opt' AS ssa_fluxucd,
          p.specmid AS ssa_specmid,
          p.specstart AS ssa_specstart,
          p.specend AS ssa_specend,
          p.specend-p.specstart AS ssa_specext,
          ssa_timeExt,
          t_min,
          t_max,
          q.ssa_length,
          50000 AS accsize,
          NULL AS embargo,
          NULL AS owner,
          'application/x-votable+xml' AS mime,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlmeta?ID=' || '\pubDIDBase' || q.source_id || '-' || q.band AS datalink
        FROM (
          SELECT
            l.source_id, l.band,
            count(*) AS ssa_length,
            MAX(l.obs_time) - MIN(l.obs_time) AS ssa_timeExt,
            MIN(l.obs_time)+55197.0 AS t_min,	-- + 2455197.5 - 2400000.5 converting gaia_jd to mjd
            MAX(l.obs_time)+55197.0 AS t_max
          FROM \schema.lightcurves AS l
            GROUP BY l.source_id, l.band
        ) AS q
        JOIN (
          SELECT *,
            radians(ra) AS raj_rad,
            radians(dec) AS dej_rad,
            radians(0.5/3600) AS aperture_rad
          FROM \schema.gaia_source_lite_eb
        ) AS o USING (source_id)
        JOIN \schema.vari_eclipsing_binary_lite b USING (source_id)
        JOIN \schema.photosys AS p ON p.band_short = q.band
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
    <index columns="ssa_targname"/>

    <meta name="description">
		This table contains metadata of photometric timeseries for eclipsing binaries from 
		Gaia DR3 epoch photometry in IVOA SSA format. The actual data is available through a datalink service.
    </meta>

    <stc>
      TimeInterval TCB BARYCENTER "t_min" "t_max"
    </stc>

<!-- Add the column to map ssa_targname to for a natural join with other Gaia tables -->
<!--      customcode=", ssa_targname AS source_id" -->
    <column name="source_id" 
      type="bigint"
      ucd="meta.id;meta.main"
      tablehead="GaiaDR3 identifier"
      description="Unique source identifier within Gaia DR3"
      required="True"/>

    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      ssa_targname="'Gaia DR3 ' || source_id"
      ssa_aperture="1/3600."
      ssa_dstype="'timeseries'"
      ssa_fluxcalib="'CALIBRATED'"
      ssa_fluxunit="'s**-1'"
      timescale='"TCB"'
      ssa_spectralucd="NULL"
      ssa_spectralunit="NULL"
      ssa_targclass="'EB*'"
      ssa_creator="'GAIA Collaboration'"
      ssa_csysName="'ICRS'"
      ssa_datasource="'survey'"
      ssa_collection="'Gaia DR3'"
      ssa_reference="'2023A&amp;A...674A...1G'"
      mime="'application/x-votable+xml'"
      ssa_targetpos="NULL"
      refposition="BARYCENTER"
    >//ssap#view</mixin>
    
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
      instrument_name="'Gaia'"
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
      <!--	TODO: correct zeroPointFlux -->

      <meta name="description">Lightcurve in the \band_human filter </meta>
      <!--
      <param original="ts_ssa.ssa_bandpass"/>
      <param original="ts_ssa.ssa_specmid"/>
      Instead add additional parameters, which we will fill up later (while making instance) for each lightcurve separately
      -->
      <param name="ra" type="double precision"
           ucd="pos.eq.ra"
           description="RA of source object"/>
      <param name="dec" type="double precision"
           ucd="pos.eq.dec"
           description="Dec of source object"/>
      <param name="filter" type="text"
           ucd="meta.id;instr.filter"
           description="Filter used."/>

      <param name="period" type="double precision"
           ucd="src.var;time.period"
           unit="d"
           description="Period of the variable star; 1/frequency from the vari_eclipsing_binary table"/>

      <param name="epoch" type="double precision"
           ucd="time.epoch"
           unit="d"
           description="Reference time from the vari_eclipsing_binary table; JD-2455197.5"/>

      <param original="//ssap#instance.ssa_reference" name="bibcode"/>
      <param original="ts_ssa.ssa_targclass"/>
      <param original="ts_ssa.ssa_collection"/>
      
      <mixin
          effectiveWavelength="\effective_wavelength"
          filterIdentifier='"\band_human"'
          magnitudeSystem='"Vega"'
          zeroPointFlux="\zero_point_flux"
          phot_description="Gaia DR3 magnitude in \band_human"
          phot_ucd='phot.flux;\band_ucd'
          phot_unit="s**-1"
          refposition="BARYCENTER"
          refframe="ICRS"
          time0="2455197.5"
          timescale='"TCB"'
          pos_epoch='2016.0'
      >//timeseries#phot-0</mixin>

      <!-- Add my column -->
      <column name="flux_error" 
          type="double precision"
          ucd="stat.error;phot.flux;em.opt"
          unit="s**-1"
          tablehead="Flux error"
          description="Flux error. If the flux has been rejected or is unavailable, this error will be set to null."
          required="False"/>

    </table>
  </STREAM>

  <!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ -->
  <!-- zero point are from https://svo2.cab.inta-csic.es/theory/fps -->
  <!-- It would be interesting to have here a mixin like  //siap#getBandFromFilter but for ssap -->

  <LOOP source="instance-template">
    <csvItems>
            band_short, band_human, band_ucd, effective_wavelength, zero_point_flux
            G,          Gaia G,  em.opt, 5.82e-7, 3228.75
            BP,         Gaia Bp, em.opt.B, 5.04e-7, 3552.01
            RP,         Gaia Rp, em.opt.R, 7.62e-7, 2554.95
    </csvItems>
  </LOOP>

  <data id="build-ts" auto="False">
    <embeddedGrammar>
      <iterator>
        <code>
          object, passband = rd.parseIdentifier(self.sourceToken.metadata["ssa_pubdid"])    # in embeddedGrammar input is available as self.sourceToken

          with base.getTableConn() as conn:
            yield from conn.queryToDicts(
                   "SELECT l.obs_time, l.flux AS phot, l.flux_error"
                   " FROM \schema.lightcurves AS l"
                   " WHERE source_id=%(object)s AND l.band=%(passband)s"
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

    <make table="instance_BP">   <!-- just a placeholder, we don't have the bare "instance" table. But we need a name from the LOOP -->
      <rowmaker idmaps="*" id="make-ts"/>

      <!-- parmaker can get parameters, provided by pargetter and write them as a metadata in the instance table -->
      <!-- Think, what do we really want to keep in the final VOTable metadata
      <parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specmid, t_min, t_max, ssa_location">  -->
      <parmaker id="make-ts-par" idmaps="ssa_targclass, ssa_collection">
         <!-- Add additioanal stuff to the litghtcure4 VOTable metadata. TODO: It would be nice to have the period and epoch there --> 
         <map dest="filter">@ssa_bandpass</map>
         <map dest="bibcode">@ssa_reference</map>
         <map dest="ra">@ssa_location.asDALI()[0]</map>
         <map dest="dec">@ssa_location.asDALI()[1]</map>

         <!--tut: touch manually the instance table metadata -->
         <apply name="update_metadata">
           <code>
             sourceId = vars["source_id"]     # in apply the current input fields are available in the vars dictionary
             targname = vars["ssa_targname"]
             targetTable.setMeta("description", base.getMetaText(targetTable, "description") +
                 " for {}".format(targname))
             targetTable.setMeta("name", str(targname))
             print(f'\n\n\n {sourceId=} {type(sourceId)=}\n\n\n')

             # Try to pull period and epoch from the objects table:
             with base.getTableConn() as conn:
               res = next(conn.query(
                  "SELECT frequency, reference_time from \schema.vari_eclipsing_binary_lite where source_id=%(source_id)s",
                  {"source_id": sourceId})
               )
               
             print(f'{res=}')

             freq, epoch = res
             # Check if the frequency is present and not zero:
             period = 1.0/freq if freq else None
             targetTable.setParam("period", period)
             targetTable.setParam("epoch", epoch)
             print('The finish!')
           </code>
         </apply>
      </parmaker>
    </make>
  </data>

  <service id="sdl" allowed="dlget,dlmeta,static">
    <meta name="title">Gaia DR3 EB light curves Datalink</meta>
    <meta name="shortName">GDR3 EB TS Datalink</meta>
    <meta name="description">This service provides photometric time series
         for eclipsing binaries from Gaia DR3 epoch photometry.
         It generates per-band photometric time series along with previews
         of folded and unfolded light curves.
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
              description=f"Gaia DR3 time series for {targname} in {passband}",
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

      <!-- TODO check 0 in frequency column of vari_eclipsing_binary_lite -->
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
                "SELECT frequency, reference_time from \schema.vari_eclipsing_binary_lite where source_id=%(source_id)s",
                {"source_id": descriptor.metadata['source_id']})
              )

            freq, epoch = res
            # Check if the frequency is present and not zero:
            if freq is None or freq == 0:
              # yield None
              yield DatalinkFault.NotFoundFault(target, "No period for this star known here")
            else:
              # period = 1.0/freq
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
    <meta name="shortName">Folded TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails of folded light curves for eclipsing binaries from Gaia DR3 epoch photometry.
        Phases were calculated using the period and epoch values from the gaiadr3.vari_eclipsing_binary table
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
                        "SELECT l.obs_time, l.flux "
                        "FROM \schema.lightcurves AS l "
                        "WHERE source_id=%(obj_id)s AND l.band=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

                    period_epoch = list(conn.query(
                      "SELECT frequency, reference_time "
                        "FROM \schema.vari_eclipsing_binary_lite "
                        "WHERE source_id=%(obj_id)s LIMIT 1",
                        {"obj_id": objId}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              freq, epoch = period_epoch[0] if len(period_epoch) > 0 else (None, None)
              if freq is None or freq == 0:
                raise UnknownURI(f'We have no period for {objId}')
              # use epoch if present, otherwise take just the first observation
              jd0 = epoch if epoch is not None else res[0][0]
              period =  1.0 / freq
              folded = [
                     ((jd - jd0) / period % 1.0, mag)
                     for jd, mag in res
              ]

              # No need to invert y-axis, we deal with fluxes:
              # jds, mags = zip(*folded)
              # lc = list(zip(jds, [-m for m in mags]))
              # return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
              return "image/png", SpectralPreviewMaker.get2DPlot(folded, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>

  <service id="preview" allowed="qp">
    <property name="queryField">obs_id</property>
    <meta name="title">Timeseries previews</meta>
    <meta name="shortName">TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails of time series for eclipsing binaries from Gaia DR3 epoch photometry.
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
                        "SELECT l.obs_time, l.flux "
                        "FROM \schema.lightcurves AS l "
                        "WHERE source_id=%(obj_id)s AND l.band=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              # No need to invert y-axis for fluxes:
              # jds, mags = zip(*res)
              # lc = list(zip(jds, [-m for m in mags]))
              # return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
              return "image/png", SpectralPreviewMaker.get2DPlot(res, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>

  <service id="ts-web" defaultRenderer="form">
    <meta name="shortName">\schema Web</meta>
    <meta name="title">Gaia DR3 EB Time Series Browser Service</meta>

    <dbCore queriedTable="ts_ssa">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="t_min"/>
      <condDesc buildFrom="t_max"/>
      <!-- <condDesc buildFrom="ssa_bandpass"/> -->

      <condDesc>
        <inputKey original="ssa_bandpass" tablehead="Filter" multiplicity="single">
          <values>
            <option title="Gaia G">Gaia G</option>
            <option title="Gaia Bp">Gaia Bp</option>
            <option title="Gaia Rp">Gaia Rp</option>
          </values>
        </inputKey>
      </condDesc>

      <condDesc>
        <inputKey original="ssa_targname" tablehead="Target Object" showItems="10">
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
    <meta name="shortName">GDR3 EB TS SSAP</meta>
    <meta name="ssap.dataSource">survey</meta>
    <meta name="ssap.creationType">archival</meta>
    <meta name="ssap.testQuery">MAXREC=1</meta>
    <meta name="ssap.complianceLevel">query</meta>
    <meta name="productTypesServed">timeseries</meta>	<!-- TODO: add this to other ssa-service descriptions -->

    <publish render="ssap.xml" sets="ivo_managed"/>
    <publish render="form" sets="ivo_managed,local" service="ts-web"/>

    <meta name="title">Gaia DR3 eclipsing binaries light curves SSA</meta>
    <meta name="description">This service exposes photometric light curves
          of eclipsing binaries from Gaia DR3 epoch photometry via the VO SSA protocol.
          The light curves are published per-band and are also discoverable through ObsCore.
    </meta>

    <ssapCore queriedTable="ts_ssa">
      <!-- <property key="previews">auto</property> 
      auto produces wrong URLs in my case. Would it work properly if I populate products table? 
      And does this really make sense?
      -->
      <FEED source="//ssap#hcd_condDescs"/>
    </ssapCore>
  </service>

  <regSuite title="gaiadr3_eb ts regression">
    <regTest title="gaiadr3_eb SSAP serves some data">
      <url REQUEST="queryData" PUBDID="ivo://upjs.jk/~?personal_shug/q/MO_Psc-R"
      >ssa/ssap.xml</url>
      <code>
        # print(self.data)
        # self.assertHasStrings("OGLE I lightcurve for OGLE-SMC-CEP-1759", "12.972499999999977 -72.95352777777752")
        # self.assertHasStrings("OGLE I lightcurve for OGLE-SMC-CEP-1759")
        self.assertHasStrings("R lightcurve for MO_Psc")
      </code>
    </regTest>

    <regTest title="gaiadr3_eb Datalink metadata looks about right.">
      <url ID="ivo://upjs.jk/~?personal_shug/q/AY_Lac-B">
           sdl/dlmeta</url>
      <code>
        # dachs test -k datalink  q
        by_sem = self.datalinkBySemantics()
        # print(by_sem)
        # self.fail("Fill this in")
        # self.assertHasStrings("Preview for OGLE-SMC-CEP-1733 in I", "OGLE time series for OGLE-SMC-CEP-1733 in I")
        self.assertHasStrings("S.Shugarov archive time series for AY_Lac in B", "Preview for AY_Lac in B")
      </code>
    </regTest>

    <regTest title="gaiadr3_eb ts_ssa TAP serves some data">
      <url parSet="TAP" QUERY="SELECT count(*) n from personal_shug.ts_ssa where ssa_collection='PERSONAL shug'"
      >/tap/sync</url>
      <code>
        row = self.getFirstVOTableRow()
        # print(f'n = {row["n"]}')
        self.assertEqual(row["n"], 10)
      </code>
    </regTest>
  </regSuite>

</resource>
