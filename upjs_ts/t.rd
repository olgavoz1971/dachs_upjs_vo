<resource schema="upjs_ts" resdir=".">
  <meta name="creationDate">2025-11-25T12:38:44Z</meta>

  <meta name="title">External Tables with Lightcurves From Kolonica Observatory</meta>
  <meta name="description">
    Lightcurves of variable stars were produced at Kolonica Observatory, Slovakia, with two telescopes TBD.
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">%keywords; repeat the element as needed%</meta>

  <meta name="creator">%authors in the format Last, F.I; Next, A.%</meta>
  <meta name="instrument">ZIGA and Alica telescopes</meta>
  <meta name="facility">Kolonica</meta>

  <meta name="source">Parimucha, S., in prep.</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>  <!-- or Archive, Survey, Simulation -->

  <meta name="coverage.waveband">Optical</meta>

  <table id="lightcurves" onDisk="True" adql="True">
    <meta name="description">The external table with photometric points of all objects</meta>
    <index columns="object_id"/>
    <index columns="photosys_id"/>
    <index columns="dateobs"/>

    <column name="id" type="bigint"
      ucd="meta.id;meta.main"
      tablehead="PP Id"
      description="Identifier for this photometry point"
      required="True"/>

    <column name="object_id" type="integer"
      ucd="meta.id"
      tablehead="Object id"
      description="Object identifier for this photometry point"
      required="True"/>

    <column name="dateobs" type="timestamp"
      ucd="time.epoch"
      tablehead="Dateobs"
      description="Timestamp with timezone"
      required="True"/>

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

    <column name="photosys_id" type="integer"
      ucd="meta.id"
      tablehead="PhotoSys id"
      description="Photometric system identifier"
      required="True"/>

    <column name="mag_diff" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Mag diff"
      description="Differential magnitude"
      required="False"/>

    <column name="mag_diff_err" type="double precision"
      ucd="stat.error;phot.mag"
      tablehead="Mag diff error"
      description="Estimation of differential magnitude error"
      required="False"/>

    <column name="quality" type="integer"
      ucd="meta.code.qual"
      tablehead="Quality"
      description="Quality flag">
      <values nullLiteral="-1"/>
    </column>

    <column name="image_filename" type="text"
      ucd="meta.id;meta.fits"
      tablehead="Image filename"
      description="Path to the fits image"
      required="False"/>

    <column name="comp_stars" type="text[]"
      ucd="meta.id"
      tablehead="Comparison stars"
      description="Comparison stars for the photomery point"
      required="False"/>

  </table>

  <data id="import_lightcurves">
    <make table="lightcurves">
      <script lang="python" type="postCreation" name="Load dump">
        table.connection.commit()
        src = table.tableDef.rd.getAbsPath("dumps/lightcurves.dump")
        with open(src) as f:
          cursor = table.connection.cursor()
          cursor.copy_expert(
            "COPY {} FROM STDIN".format(table.tableDef.getQName()),
            f)
      </script>
    </make>
  </data>

  <table id="objects" onDisk="True" adql="True">
    <index columns="id"/>
    <mixin>//scs#pgs-pos-index</mixin>
    <meta name="description">The external table with objects</meta>

    <column name="id" type="integer"
      ucd="meta.id;meta.main"
      tablehead="Object Id"
      description="Internal object identifier"
      required="True"/>

    <column name="ra" type="double precision"
      ucd="pos.eq.ra;meta.main"
      tablehead="RA"
      verbLevel="1"
      unit="deg"
      description="Right ascension from"
      required="True"/>

    <column name="dec"
      type="double precision"
      ucd="pos.eq.dec;meta.main"
      tablehead="Dec"
      verbLevel="1"
      unit="deg"
      description="Declination"
      required="True"/>

<!--
    <column name="coordequ" type="spoint"
      ucd="pos.eq;meta.main"
      tablehead="Coordequ"
      description="Equatorial coordiantes, ICRS"
      required="False"/>
-->

    <column name="gaia_name" type="text"
      ucd="meta.id"
      tablehead="Gaia DR3 ID"
      description="Gaia DR3 identifier"
      required="False"/>

    <column name="simbad_name" type="text"
      ucd="meta.id"
      tablehead="Simbad name"
      description="Simbad resolvable name"
      required="False"/>

    <column name="vsx_name" type="text"
      ucd="meta.id"
      tablehead="VSX name"
      description="VSX name"
      required="False"/>

    <column name="class" type="text"
      ucd="src.class"
      tablehead="Target class"
      description="Target class"
      required="False"/>

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
        src = table.tableDef.rd.getAbsPath("dumps/objects_2.dump")
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

  <table id="photosys" onDisk="True" adql="Hidden">
    <meta name="description">The external table with photometric systems</meta>
    <column name="id" type="integer"
      ucd="meta.id;meta.main"
      tablehead="Photosys Id"
      description="Photometric system identifier"
      required="True"/>

    <column name="band" type="text"
      ucd="meta.id;instr.filter"
      tablehead="Bandpass"
      description="Bandpass name"
      required="True"/>

    <column name="description" type="text"
      ucd="meta.note"
      tablehead="Description"
      description="Photometric system description"
      required="False"/>

    <column name="specmid" type="real"
      ucd="em.wl.central"
      tablehead="specmid"
      description="Central wavelength of the band"
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

  <regSuite title="upjs_ts regression">
    <regTest title="upjs_ts objects table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM upjs_ts.objects WHERE gaia_name='1656754192432536832'"
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

    <regTest title="upjs_ts lightcurves table serves some data">
      <url parSet="TAP"
        QUERY="select l.dateobs, l.image_filename FROM upjs_ts.lightcurves l join upjs_ts.objects o on l.object_id = o.id  WHERE o.gaia_name='1656754192432536832' and l.dateobs='2021-10-22 22:37:08.832'"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        print(row)
        self.assertEqual(row["image_filename"], 'upjs_img/data/Alica/2021-10-22/2021-10-22T20:36:42_r.fit.fz')
      </code>
    </regTest>

    <regTest title="upjs_ts photosys table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM upjs_ts.photosys WHERE band='I'"
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
