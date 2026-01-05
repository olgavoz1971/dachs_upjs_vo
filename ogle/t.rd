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

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  Poleski, R.; Pawlak, M.; 
                       Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.</meta>
  <meta name="instrument">1.0-1.3-meter telescopes. TBD</meta>
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

<!-- ====================== ident tables (base for objects view) ==========  -->

  <STREAM id="basicColumnsIdent">
    <meta name="description">The original table with identification of stars from \name collection</meta>

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

    <column name="ogle4_id" type="text" ucd="meta.id"
      tablehead="OGLE-IV ID" verbLevel="25"
      description="OGLE-IV Identifier"
      required="False">
    </column>

    <column name="ogle3_id" type="text" ucd="meta.id"
      tablehead="OGLE-III ID" verbLevel="25"
      description="OGLE-III Identifier"
      required="False">
    </column>

    <column name="ogle2_id" type="text" ucd="meta.id"
      tablehead="OGLE-II ID" verbLevel="25"
      description="OGLE-II Identifier"
      required="False">
    </column>

    <column name="vsx" type="text" ucd="meta.id"
      tablehead="VSX" verbLevel="1"
      description="VSX designation"
      required="False">
    </column>
  </STREAM>

  <STREAM id="makeCommonRowsIdent">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
        <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
        <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
        <map dest="vsx">parseWithNull(@vsx, str, "")</map>    
  </STREAM>

  <table id="ident_blg_cep" onDisk="True" adql="hidden">
    <FEED source="basicColumnsIdent" name="Classical Cepheids toward the Galactic bulge"/>
    <column name="pulse_mode" type="text" ucd="meta.code.class"
      tablehead="Pulsation Mode" verbLevel="15"
      description="Cepheid Mode(s) of pulsation"
      required="False">
    </column>
  </table>

  <data id="import_blg_cep">
    <sources>data/ident_blg_cep.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-16
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
        <FEED source="makeCommonRowsIdent"/>
        <map dest="pulse_mode">parseWithNull(@pulse_mode, str, "")</map>
      </rowmaker>
    </make>
  </data>

  <table id="ident_blg_lpv" onDisk="True" adql="hidden">
    <FEED source="basicColumnsIdent" name="Mira stars toward the Galactic Bulge"/>
    <column name="type" type="text" ucd="meta.code.class"
      tablehead="Type of Variable Star" verbLevel="15"
      description="Type of Variable Star (Mira)"
      required="False">
    </column>
  </table>

  <data id="import_blg_lpv">
    <sources>data/ident_blg_lpv.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-19
        type:       22-25
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
        <FEED source="makeCommonRowsIdent"/>
        <map dest="type">parseWithNull(@type, str, "")</map>
      </rowmaker>
    </make>
  </data>

<!-- ================== auxiliary tables ============================= -->

  <table id="aux_blg_lpv_miras" onDisk="True" adql="hidden">
    <meta name="description">The table from original Miras.dat from OGLE Mira stars toward the
                Galactic bulge collection</meta>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Star identifier"
      required="True">
    </column>

    <column name="mean_I" type="real"
      ucd="phot.mag"
      unit="mag"
      tablehead="Mean I"
      description="Intensity mean I-band magnitude"
      required="False"/>

    <column name="mean_V" type="real"
      ucd="phot.mag"
      unit="mag"
      tablehead="Mean V"
      description="Intensity mean V-band magnitude"
      required="False"/>

    <column name="period" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period"
      description="Primary period"
      required="False"/>

    <column name="ampl_I" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Ampl I"
      description="I-band amplitude of the primary period"
      required="False"/>

  </table>

  <data id="import_aux_blg_lpv_miras">
    <sources>data/blg_lpv/Miras.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-19
        mean_I:     22-27
        mean_V:     29-34
        period:     36-44
        ampl_I:     46-50
      </colDefs>
    </columnGrammar>

    <make table="aux_blg_lpv_miras">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, str, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, str, "-")</map>
        <map dest="period">parseWithNull(@period, str, "-")</map>
      </rowmaker>
    </make>
  </data>

  <!-- =============== BLG Cephewids ======================== -->

  <STREAM id="basicColumnsCep">
    <column name="object_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Star identifier"
      required="True">
    </column>

    <column name="mean_I" type="real"
      ucd="phot.mag"
      unit="mag"
      tablehead="Mean I"
      description="Intensity mean I-band magnitude"
      required="False"/>

    <column name="mean_V" type="real"
      ucd="phot.mag"
      unit="mag"
      tablehead="Mean V"
      description="Intensity mean V-band magnitude"
      required="False"/>

    <column name="ampl_I" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Ampl I"
      description="I-band amplitude of the primary period"
      required="False"/>

    <column name="period" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period"
      description="Primary/longest period"
      required="False"/>

    <column name="period_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period err"
      description="Uncertainty of period"
      required="False"/>
  </STREAM>

  <STREAM id="blg_cep_dd">
    <columnGrammar>
      <colDefs>
        object_id:   1-16
        mean_I:     19-24
        mean_V:     26-31
        period:     34-43
        period_err: 45-53
        ampl_I:     70-74
      </colDefs>
    </columnGrammar>
    <make table="\table_name">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, str, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, str, "-")</map>
        <map dest="period">parseWithNull(@period, str, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, str, "-")</map>
      </rowmaker>
    </make>
  </STREAM>

  <table id="aux_blg_cep_cepf" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cepF.dat 
                with parameters of fundamental-mode (F) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cepf">
    <sources>data/blg_cep/cepF.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cepf"/>
  </data>

  <table id="aux_blg_cep_cep1o" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cep1O.dat 
                with parameters of first-overtone (1O) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cep1o">
    <sources>data/blg_cep/cep1O.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cep1o"/>
  </data>

  <table id="aux_blg_cep_cepf1o" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cepF1O.dat 
                with parameters of double-mode (F/1O) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cepf1o">
    <sources>data/blg_cep/cepF1O.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cepf1o"/>
  </data>

  <table id="aux_blg_cep_cep1o2o" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cep1O2O.dat
                with parameters of double-mode 1O/2O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cep1o2o">
    <sources>data/blg_cep/cep1O2O.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cep1o2o"/>
  </data>

  <table id="aux_blg_cep_cep1o2o3o" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cep1O2O3O.dat
                with parameters of triple-mode 1O/2O/3O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cep1o2o3o">
    <sources>data/blg_cep/cep1O2O3O.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cep1o2o3o"/>
  </data>

  <table id="aux_blg_cep_cep2o3o" onDisk="True" adql="hidden">
    <meta name="description">The table from the base of original cep2O3O.dat
                with parameters of 2O/3O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <FEED source="basicColumnsCep"/>
  </table>
  <data id="import_blg_cep_cep2o3o">
    <sources>data/blg_cep/cep2O3O.dat</sources>
    <FEED source="blg_cep_dd" table_name="aux_blg_cep_cep2o3o"/>
  </data>

<!-- ########################## lightcurves ############################################## -->


  <table id="lightcurves" onDisk="True" adql="True">
    <meta name="description">The united table with photometry points of all OGLE Lightcurves</meta>
    <index columns="object_id"/>
    <index columns="passband"/>
    <index columns="obs_time"/>

    <column name="object_id" type="text"
      ucd="meta.id"
      tablehead="Object id"
      description="Object identifier for this photometry point"
      required="True"/>

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
  </table>

  <data id="import_lightcurves" updating="True">

    <sources pattern="data/blg_???/phot*/[VI]/*.dat"/>

    <csvGrammar delimiter=" " strip="True" names="dateobs_jd, magnitude, mag_err"/>

    <make table="lightcurves">
      <rowmaker idmaps="*">
        <!-- OGLE jds come with different "time zero-points" unfortunately -->
        <var name="to_mjd">
          2400000.5 if "blg_cep" in \rootlessPath else -49999.5
        </var>
        <var name="obs_time">float(@dateobs_jd)-@to_mjd</var>
        <map key="object_id">\srcstem</map>
        <map key="passband">\rootlessPath.split("/")[-2]</map>
      </rowmaker>
    </make>
  </data>

<!-- ################################################################# -->

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
