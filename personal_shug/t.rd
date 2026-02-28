<?xml version="1.0" encoding="utf-8"?>
<resource schema="personal_shug" resdir=".">
  <meta name="schema-rank">100</meta>
  <meta name="creationDate">2026-02-19T12:38:44Z</meta>

  <meta name="title">Personal archive of S.Yu.Shugarov</meta>

  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>

  <meta name="creator">Shugarov, S.,Yu.; Vozyakova O.</meta>
  <meta name="instrument">Various</meta>
  <meta name="facility">Various</meta>

  <meta name="source">2021Ap.....64..458S</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>  <!-- or Archive, Survey, Simulation -->

  <meta name="coverage.waveband">Optical</meta>

<!-- ======================= lightcurves ===================== -->

  <table id="lightcurves" onDisk="True" adql="True">
    <meta name="table-rank">150</meta>
    <meta name="description">The basic table with photometry points of all objects</meta>

    <index columns="object_id, passband"/>
    <index columns="obs_time"/>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Object identifier for this photometry point"
      required="True">
    </column>

    <column name="passband" type="text"
      utype="ssa:DataID.Bandpass" ucd="instr.bandpass"
      tablehead="Filter" verbLevel="15"
      description="Bandpass (i.e., rough spectral location) of this dataset"/>

    <column name="obs_time" type="double precision"
      unit="d" ucd="time.epoch"
      tablehead="Obs Time"
      description="mjd of the photometry point"/>

    <column name="magnitude" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Magnitude"
      description="Stellar magnitude"
      required="False"/>

    <column name="mag_err" type="double precision"
      ucd="stat.error;phot.mag"
      unit="mag"
      tablehead="Magnitude error"
      description="Estimation of magnitude error"
      required="False"/>

    <column name="facility" type="integer"
      ucd="meta.id;meta.dataset"
      tablehead="Facility"
      description="Facility and telescope code: 1 = AISAS, Z-600, 2 = Nauchny, Z-600, 3 = Nauchny, Maksutov-50, 0 = not specified"
      required="True"/>

    <column name="note" type="text"
      ucd="meta.note"
      tablehead="Note"
      description="Comment"
      required="False"/>

  </table>

  <data id="import_lightcurves">
    <!-- <sources pattern="data/??_???/*.dat"/> -->
    <sources pattern="data/*/*.dat"/>
    <csvGrammar delimiter=" " strip="True" preFilter="grep -v '^#'" names="dateobs_jd, magnitude, facility, note"/>
    <make table="lightcurves">
      <rowmaker idmaps="*">
        <map key="object_id">\rootlessPath.split("/")[-2]</map>
        <var name="obs_time">float(@dateobs_jd)-0.5</var>
        <map key="passband">\srcstem</map>
      </rowmaker>
    </make>
  </data>

<!-- ================== objects ======================== -->

  <table id="objects" onDisk="True" adql="True">
    <meta name="table-rank">100</meta>
    <meta name="description">Basic parameters of variable star targets included in the time-series archive</meta>

    <index columns="object_id"/>

    <stc>
      Position ICRS "raj2000" "dej2000"
    </stc>

    <mixin>//scs#pgs-pos-index</mixin>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
        tablehead="Star ID" verbLevel="1" 
        description="Star identifier"
        required="True">
    </column>

    <column name="raj2000" type="double precision" ucd="pos.eq.ra;meta.main"
        tablehead="RA" verbLevel="1" unit="deg"
        description="Right ascension"
        required="True" displayHint="sf=10"/>

    <column name="dej2000" type="double precision" ucd="pos.eq.dec;meta.main"
        tablehead="Dec" verbLevel="1" unit="deg"
        description="Declination"
        required="True" displayHint="sf=10"/>

    <column name="period" type="double precision"
        ucd="src.var;time.period"
        unit="d"
        tablehead="Period"
        description="Period of the variable star"
        required="False"/>

    <column name="epoch" type="double precision"
        ucd="src.var;time.epoch"
        unit="d"
        tablehead="Epoch"
        description="Time of maximum brightness; mjd (HJD)"
        required="False"/>

    <column name="identifiers" type="text" ucd="meta.id"
        tablehead="Identifiers" verbLevel="1"
        description="Other designation"
        required="False">
    </column>
    
    <column name="gaia_id" type="bigint" ucd="meta.id"
        tablehead="Gaia DR3 ID" verbLevel="1"
        description="Gaia DR3 identifier"
        required="False">
        <values nullLiteral="-1"/>
    </column>
    
    <column name="varclass" type="text"
      ucd="src.class"
      tablehead="Target class"
      description="Target class (variable star class"
      required="False"/>

    <column original="//ssap#instance.ssa_targclass"/>
    <column original="//ssap#instance.ssa_collection"/>
    <column original="//ssap#instance.ssa_reference"/>

    <column name="description" type="text"
      ucd="meta.note"
      tablehead="Description"
      description="Target description"
      required="False"/>
  </table>

  <data id="import_objects">
    <make table="objects">
      <script lang="python" type="postCreation" name="Load dump">
        table.connection.commit()
        src = table.tableDef.rd.getAbsPath("dumps/objects.dump")
        with open(src) as f:
          cursor = table.connection.cursor()
          cursor.copy_expert(
            "COPY {} FROM STDIN".format(table.tableDef.getQName()),
            f)
      </script>
    </make>
  </data>

<!--
  <service id="calibrators" allowed="scs.xml">
    <meta name="shortName">upjs calibrators</meta>
    <meta name="testQuery">
      <meta name="ra">9.4076</meta>
      <meta name="dec">9.6414</meta>
      <meta name="sr">1.0</meta>
    </meta>
    <scsCore queriedTable="objects">
      <FEED source="//scs#coreDescs"/>
    </scsCore>
  </service>
-->

<!--   Cone Search  -->
  <service id="shug-objects" allowed="form,scs.xml">
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>

    <meta name="shortName">All shug Objects</meta>
    <meta name="title">personal_shug objects Cone Search</meta>
    <meta name="description">
      The table with basic parameters of the observed objects
    </meta>
    <meta name="_related" title="shug Varable Stars Time series"
            >\internallink{\rdId/ts-web/info}
    </meta>

    <meta>
      testQuery.ra: 263.562625
      testQuery.dec: -27.398250
      testQuery.sr:   0.0001
    </meta>

    <scsCore queriedTable="objects">
      <FEED source="//scs#coreDescs"/>
        <condDesc buildFrom="varclass"/>
        <condDesc buildFrom="object_id"/>
    </scsCore>
  </service>

<!-- ==============  photometric system ===================== -->

  <table id="photosys" onDisk="True" adql="Hidden">
    <meta name="description">The external table with photometric systems</meta>

    <column name="band_short" type="text"
      ucd="meta.id;instr.filter;meta.main"
      tablehead="Bandpass"
      description="Short bandpass name"
      required="True"/>

    <column name="band_human" type="text"
      ucd="meta.id;instr.filter"
      tablehead="Bandpass Human"
      description="Human readable bandpass name"
      required="True"/>

    <column name="band_ucd" type="text"
      ucd="meta.ucd"
      tablehead="Band ucd"
      description="UCD of the photometric band"
      required="True"/>

    <column name="specstart" type="real"
      ucd="em.wl"
      tablehead="specstart"
      description="Minimum wavelength of the band"
      required="True"/>

    <column name="specmid" type="real"
      ucd="em.wl.central"
      tablehead="specmid"
      description="Effective wavelength of the band"
      required="True"/>

    <column name="specend" type="real"
      ucd="em.wl"
      tablehead="specend"
      description="Maximum wavelength of the band"
      required="True"/>

    <column name="zero_point_flux" type="real"
      ucd="phot.flux"
      tablehead="Zero Point"
      description="Flux at the given zero point, in Jy;"
      required="False"/>

    <column name="description" type="text"
      ucd="meta.note"
      tablehead="Description"
      description="Photometric system description"
      required="False"/>
  </table>

 <data id="import_photosys">
    <make table="photosys">
      <script lang="python" type="postCreation" name="Load dump">
        table.connection.commit()
        src = table.tableDef.rd.getAbsPath("dumps/photosys.dump")
        with open(src) as f:
          cursor = table.connection.cursor()
          cursor.copy_expert(
            "COPY {} FROM STDIN".format(table.tableDef.getQName()),
            f)
      </script>
    </make>
  </data>

  <regSuite title="personal_shug regression">
    <regTest title="personal_shug objects table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM personal_shug.objects WHERE gaia_id='1656754192432536832'"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        # print(row)
        self.assertAlmostEqual(row["ra"], 259.244800000003)
        self.assertAlmostEqual(row["dec"], 76.53109999999987)
      </code>
    </regTest>

    <regTest title="personal_shug objects table seems to contain the correct number of rows">
      <url parSet="TAP"
        QUERY="SELECT COUNT(*) AS nrows FROM personal_shug.objects"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        # print(row)
        self.assertTrue(row["nrows"] == 14331)
      </code>
    </regTest>

    <regTest title="personal_shug lightcurves table serves some data">
      <url parSet="TAP"
        QUERY="select l.dateobs, l.image_filename FROM personal_shug.lightcurves l join personal_shug.objects o on l.object_id = o.id  WHERE o.gaia_id='1656754192432536832' and l.dateobs='2021-10-22 22:37:08.832'"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        # print(row)
        self.assertEqual(row["image_filename"], 'upjs_img/data/Alica/2021-10-22/2021-10-22T20:36:42_r.fit.fz')
      </code>
    </regTest>

    <regTest title="personal_shug photosys table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM personal_shug.photosys WHERE band='I'"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        # print(row)
        self.assertEqual(row["description"], "BESSELL")
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
