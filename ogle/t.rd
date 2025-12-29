<resource schema="ogle" resdir=".">
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">Original OGLE ident tables</meta>
  <meta name="description">
    The OGLE project consists of several sub-surveys that differ by sky coverage and by the type of variability targeted.
    The content and structure of tables containing observed object parameters vary between these sub-surveys.

    In this resource descriptor, the individual tables are ingested separately, one by one.
    In another RD file, these tables are combined into a common raw_data table implemented as a unified view.

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
  <meta name="contentLevel">Research</meta>
  <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">Optical</meta>

  <meta name="copyright" format="rst">
    If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
      :bibcode: `2015AcA....65....1U`   (OGLE-IV photometry)
      :bibcode: `2008AcA....58...69U`   (OGLE-III photometry)
  </meta>

  <meta name="_longdoc" format="rst">
    TBD
  </meta>

  <table id="ident_blg_cep" onDisk="True" adql="True">
    <column name="star_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Star identifier"
      required="True">
    </column>

    <column name="pulse_mode" type="text" ucd="meta.id;meta.main"
      tablehead="Pulsation Mode" verbLevel="15"
      description="Cepheid Mode(s) of pulsation"
      required="False">
    </column>

    <column name="raj2000" type="double precision" ucd="pos.eq.ra;meta.main"
      tablehead="RA" verbLevel="1" unit="deg"
      description="Right ascension"
      required="True" displayHint="sf=10"/>

    <column name="dej2000" type="double precision" ucd="pos.eq.dec;meta.main"
      tablehead="Dec" verbLevel="1" unit="deg"
      description="Declination"
      required="True" displayHint="sf=10"/>

    <column name="ogle4_id" type="text" ucd="meta.id"
      tablehead="OGLE-IV ID" verbLevel="15"
      description="OGLE-IV Identifier"
      required="False">
    </column>

    <column name="ogle3_id" type="text" ucd="meta.id"
      tablehead="OGLE-III ID" verbLevel="15"
      description="OGLE-III Identifier"
      required="False">
    </column>

    <column name="ogle2_id" type="text" ucd="meta.id"
      tablehead="OGLE-II ID" verbLevel="15"
      description="OGLE-II Identifier"
      required="False">
    </column>

    <column name="vsx" type="text" ucd="meta.id"
      tablehead="VSX" verbLevel="1"
      description="VSX designation"
      required="False">
    </column>

  </table>

  <data id="import_blg_cep">
    <sources>data/ident_blg_cep.dat</sources>

    <columnGrammar>
      <colDefs>
        star_id:    1-16
        pulse_mode: 18-25
        alphaHMS:   28-38
        deltaDMS:   40-50
        ogle4_id:   53-68
        ogle3_id:   70-84
        ogle2_id:   86-100
        vsx:        102-110
      </colDefs>
    </columnGrammar>

    <make table="ident_blg_cep">
      <rowmaker idmaps="*">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="pulse_mode">parseWithNull(@pulse_mode, str, "")</map>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
        <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
        <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
        <map dest="vsx">parseWithNull(@vsx, str, "")</map>
      </rowmaker>
    </make>
  </data>

  <table id="ident_blg_lpv" onDisk="True" adql="True">
    <column name="star_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Star identifier"
      required="True">
    </column>

    <column name="type" type="text" ucd="meta.id;meta.main"
      tablehead="Type of Variable Star" verbLevel="15"
      description="Type of Variable Star (Mira)"
      required="False">
    </column>

    <column name="raj2000" type="double precision" ucd="pos.eq.ra;meta.main"
      tablehead="RA" verbLevel="1" unit="deg"
      description="Right ascension"
      required="True" displayHint="sf=10"/>

    <column name="dej2000" type="double precision" ucd="pos.eq.dec;meta.main"
      tablehead="Dec" verbLevel="1" unit="deg"
      description="Declination"
      required="True" displayHint="sf=10"/>

    <column name="ogle4_id" type="text" ucd="meta.id"
      tablehead="OGLE-IV ID" verbLevel="15"
      description="OGLE-IV Identifier"
      required="False">
    </column>

    <column name="ogle3_id" type="text" ucd="meta.id"
      tablehead="OGLE-III ID" verbLevel="15"
      description="OGLE-III Identifier"
      required="False">
    </column>

    <column name="ogle2_id" type="text" ucd="meta.id"
      tablehead="OGLE-II ID" verbLevel="15"
      description="OGLE-II Identifier"
      required="False">
    </column>

    <column name="vsx" type="text" ucd="meta.id"
      tablehead="VSX" verbLevel="1"
      description="VSX designation"
      required="False">
    </column>

  </table>

  <data id="import_blg_lpv">
    <sources>data/ident_blg_lpv.dat</sources>

    <columnGrammar>
      <colDefs>
        star_id:    1-19
        type: 22-25
        alphaHMS:   28-38
        deltaDMS:   40-50
        ogle4_id:   53-68
        ogle3_id:   70-84
        ogle2_id:   86-101
        vsx:        103-150
      </colDefs>
    </columnGrammar>

    <make table="ident_blg_lpv">
      <rowmaker idmaps="*">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="type">parseWithNull(@type, str, "")</map>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
        <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
        <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
        <map dest="vsx">parseWithNull(@vsx, str, "")</map>
      </rowmaker>
    </make>
  </data>

  <service id="web" allowed="form">
    <!-- if you want a browser-based service in addition to TAP, use
    this.  Otherwise, delete this and just write <publish/> into
    the table element above to publish the table as such.  With a
    service, the table will be published as part of the service -->
    <meta name="shortName">BLG CEP form</meta>

    <!-- the browser interface goes to the VO and the front page -->
    <publish render="form" sets="ivo_managed, local"/>
    <!-- all publish elements only become active after you run
      dachs pub q -->

    <dbCore queriedTable="ident_blg_cep">
      <!-- to add query constraints on table columns, add condDesc
      elements built from the column -->
      <condDesc buildFrom="pulse_mode"/>
    </dbCore>
  </service>

  <regSuite title="ogle regression">
    <regTest title="ogle table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM ogle.main WHERE %select one column%"
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
