<resource schema="upjs" resdir=".">
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

  <table id="lightcurves" onDisk="True" adql="Hidden">
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

    <column name="mag_diff_error" type="double precision"
      ucd="stat.error;phot.mag"
      tablehead="Mag diff error"
      description="Estimation of differential magnitude error"
      required="False"/>

    <column name="quality" type="integer"
      ucd="meta.code.qual"
      tablehead="Quality"
      description="Quality flag"
      required="False"/>

    <column name="image_filename" type="text"
      ucd="meta.id;meta.fits"
      tablehead="Image filename"
      description="Path to the fits image"
      required="False"/>

  </table>

  <data id="import_lightcurves">
    <sources pattern="%resdir-relative pattern, like data/*.txt%"/>

    <!-- the grammar really depends on your input material.  See
      http://docs.g-vo.org/DaCHS/ref.html#grammars-available,
      in particular columnGrammar, csvGrammar, fitsTableGrammar,
      and reGrammar; if nothing else helps see embeddedGrammar
      or customGrammar -->
    <csvGrammar names="name1 some_other_name and_so_on"/>

    <make table="lightcurves">
      <rowmaker idmaps="*">
        <!-- the following is an example of a mapping rule that uses
        a python expression; @something takes the value of the something
        field returned by the grammar.  You obviously need to edit
        or remove this concrete rule. -->
        <!-- <map dest="%name of a column%">int(@some_other_name[2:])</map>
        -->
      </rowmaker>
    </make>
  </data>

<!--
  <service id="q" allowed="form">
    if you want a browser-based service in addition to TAP, use
    this.  Otherwise, delete this and just write <publish/> into
    the table element above to publish the table as such.  With a
    service, the table will be published as part of the service
    <meta name="shortName">%max. 16 characters%</meta>

    the browser interface goes to the VO and the front page
    <publish render="form" sets="ivo_managed, local"/>
    all publish elements only become active after you run
      dachs pub q

    <dbCore queriedTable="lightcurves">
      to add query constraints on table columns, add condDesc
      elements built from the column
      <condDesc buildFrom="%colname%"/>
    </dbCore>
  </service>
-->

  <table id="objects" onDisk="True" adql="Hidden">
    <column name="id" type="integer"
      ucd="meta.id;meta.main"
      tablehead="Object Id"
      description="Internal object identifier"
      required="True"/>

    <column name="coordequ" type="spoint"
      ucd="pos.eq;meta.main"
      tablehead="Coordequ" 
      description="Equatorial coordiantes, ICRS" 
      required="False"/>

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

    <column name="ucac4_name" type="text"
      ucd="meta.id" 
      tablehead="UCAC4 name" 
      description="UCAC4 name" 
      required="False"/>

    <column name="apass_name" type="text"
      ucd="meta.id" 
      tablehead="APASS name" 
      description="APASS name" 
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
    <sources pattern="%resdir-relative pattern, like data/*.txt%"/>

    <!-- the grammar really depends on your input material.  See
      http://docs.g-vo.org/DaCHS/ref.html#grammars-available,
      in particular columnGrammar, csvGrammar, fitsTableGrammar,
      and reGrammar; if nothing else helps see embeddedGrammar
      or customGrammar -->
    <csvGrammar names="name1 some_other_name and_so_on"/>

    <make table="objects">
      <rowmaker idmaps="*">
        <!-- the following is an example of a mapping rule that uses
        a python expression; @something takes the value of the something
        field returned by the grammar.  You obviously need to edit
        or remove this concrete rule. -->
        <!-- <map dest="%name of a column%">int(@some_other_name[2:])</map>
        -->
      </rowmaker>
    </make>
  </data>

  <table id="photosys" onDisk="True" adql="Hidden">
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

  </table>

  <data id="import_photosys">
    <sources pattern="%resdir-relative pattern, like data/*.txt%"/>

    <!-- the grammar really depends on your input material.  See
      http://docs.g-vo.org/DaCHS/ref.html#grammars-available,
      in particular columnGrammar, csvGrammar, fitsTableGrammar,
      and reGrammar; if nothing else helps see embeddedGrammar
      or customGrammar -->
    <csvGrammar names="name1 some_other_name and_so_on"/>

    <make table="objects">
      <rowmaker idmaps="*">
        <!-- the following is an example of a mapping rule that uses
        a python expression; @something takes the value of the something
        field returned by the grammar.  You obviously need to edit
        or remove this concrete rule. -->
        <!-- <map dest="%name of a column%">int(@some_other_name[2:])</map>
        -->
      </rowmaker>
    </make>
  </data>


  <regSuite title="upjs regression">
    <regTest title="upjs table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM upjs.main WHERE %select one column%"
        >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        print(row)
        self.assertAlmostEqual(row["ra"], 22.22222)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
