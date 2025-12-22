<resource schema="ogle" resdir=".">
  <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>

  <meta name="creationDate">2025-12-21T16:24:52Z</meta>

  <meta name="title">OGLE Time series</meta>
  <meta name="description" format="rst">
    I promis, I[ll fill this properly befire publisjing any data from this
    collection
    this should be a paragraph or two (take care to mention salient terms)
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  Poleski, R.; Pawlak, M.; Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.</meta>
  <meta name="instrument">TBD</meta>
  <meta name="facility">OGLE TBD</meta>

  <meta name="source">2015AcA....65....1U</meta>

  <meta name="copyright" format="rst">
    If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
      :bibcode: `2015AcA....65....1U `  (OGLE-IV photometry)
      :bibcode: `2008AcA....58...69U`   (OGLE-III photometry)
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
        # we have artificial accrefs of the form ogle/<id>_<band>;
        # what we define here needs to be reflected in the viewStatement
        # of the raw_data table
        def unparseIdentifier(object, bandpass):
            """returns an accref from bandpass and object.
            """
            return f"ogle/{object}-{bandpass}"

        def parseIdentifier(id):
            """returns object and bandpass from an accref or a pubDID.
            """
            assert "ogle" in id
            return id.split("/")[-1].split("-")

            rd.unparseIdentifier = unparseIdentifier
            rd.parseIdentifier = parseIdentifier
      ]]></code>
  </job></execute>


  <table id="raw_data" onDisk="True" adql="hidden"
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

    <!-- metadata actually varies among data sets JK: add ssa_pubDID(?) -->
    <LOOP listItems="ssa_dstitle ssa_location ssa_targname ssa_length ssa_timeExt ssa_targclass
        ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext ssa_collection">
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
      <column name="p_star_id" type="text" ucd="meta.id;meta.main" tablehead="OGLE star id"
        description="Object id in the original table"
        verbLevel="1"
        required="True"/>

      <column name="p_vartype" type="text" ucd="meta.code.class" tablehead="var type"
        description="Varibale star type, marks part of survey"
        verbLevel="1"
        required="False"/>    

    <!-- ssap#fill-plainlocation mixin converts rd,dec into ssa_location
      (spoint) and ssa_region, but do not forget add aperture 
      Unfortunately no, we can not apply this fill-plainlocation because we do not have 
      rowmaker here, while working with a view-->
    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT
          star_id AS p_star_id,
          'OGLE ' || 'V' || ' lightcurve ' || 'for ' || star_id AS ssa_dstitle, 
          'BLG CEP' AS p_vartype,
          star_id AS ssa_targname,
          'Ce*' AS ssa_targclass,
          spoint(radians(raj2000), radians(dej2000)) as ssa_location,
          NULL::spoly AS ssa_region,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || 'ogle' || star_id || '-' || 'V' AS accref,
          '\pubDIDBase' || 'ogle' || star_id || '-' || 'V' AS ssa_pubdid,
          'V' AS ssa_bandpass,
          5.5E-7 AS ssa_specmid,
          4.8E-7 AS ssa_specstart,
          7.3E-7 AS ssa_specend,
          2.5E-7 AS ssa_specext,
          99 AS ssa_timeExt,
          99 AS ssa_length,
          49999.999999 AS t_min,
          59999.999999 AS t_max,
          'application/x-votable+xml' AS mime,
          50000 AS accsize,
          NULL AS embargo,
          NULL AS owner,
          NULL AS datalink,
          'OGLE-BLG-CEP' AS ssa_collection
        FROM \schema.ident_blg_cep
      )
    </viewStatement>
  </table>

  <data id="create-raw-view">
    <recreateAfter>make-ssa-view</recreateAfter>
    <property key="previewDir">previews</property>
    <make table="raw_data"/>
  </data>

<!-- JK: todo      <meta name="serviceId">sdl</meta>	-->
  <table id="ts_ssa" onDisk="True" adql="True">
    <meta name="_associatedDatalinkService">
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <meta name="description">
      This table contains metadata about OGLE the photometric time
      in IVOA SSA format. The actual data is available through a datalink
      service.
    </meta>

    <mixin
      sourcetable="raw_data"
      copiedcolumns="[!p]*"
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
    >//obscore#publishSSAPMIXC</mixin>

    <column original="ssa_publisher" type="unicode"/>    <!-- unicode allows diacrtric symbols -->
  </table>

  <data id="make-ssa-view" auto="False">
    <make table="ts_ssa"/>
  </data>

  <coverage>
    <updater sourceTable="ts_ssa"/>
  </coverage>

  <!-- a form-based service – this is made totally separate from the
  SSA part because grinding down SSA to something human-consumable and
  still working as SSA is non-trivial -->

  <service id="web" defaultRenderer="form">
    <meta name="shortName">\schema Web</meta>

    <dbCore queriedTable="ts_ssa">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="t_min"/>
      <condDesc buildFrom="t_max"/>
      <condDesc buildFrom="ssa_bandpass"/>
      <condDesc>
        <inputKey original="ts_ssa.ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname from \schema.raw_data
            order by ssa_targname"/>
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
