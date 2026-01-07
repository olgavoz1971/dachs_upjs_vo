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

<!-- ====================== blg ident tables (base for objects view) ==========  -->

  <STREAM id="makeCommonRowsIdent">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
        <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
        <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
        <map dest="vsx">parseWithNull(@vsx, str, "")</map>    
  </STREAM>

  <table id="ident_blg_cep" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of stars from 
                       Classical Cepheids toward the Galactic bulge collection</meta>

    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype vartype">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

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
        <var name="ogle_vartype">None</var>
        <var name="vartype">"Ce*"</var>
      </rowmaker>
    </make>
  </data>

  <table id="ident_blg_lpv" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of stars from 
                       the Mira stars toward the Galactic Bulge collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx ogle_vartype vartype">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_lpv">
    <sources>data/ident_blg_lpv.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:    1-19
        type: 22-25
        alphaHMS:     28-38
        deltaDMS:     40-50
        ogle4_id:     53-68
        ogle3_id:     70-84
        ogle2_id:     86-101
        vsx:         103-150
      </colDefs>
    </columnGrammar>

    <make table="ident_blg_lpv">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <map dest="ogle_vartype">parseWithNull(@type, str, "")</map>
        <var name="vartype">"LP*"</var>
      </rowmaker>
    </make>
  </data>

<!-- ================== param tables ============================= -->

  <table id="param_blg_lpv_miras" onDisk="True" adql="hidden">
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

<!-- =================== Miras param table ======================== -->

  <data id="import_param_blg_lpv_miras">
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

    <make table="param_blg_lpv_miras">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
      </rowmaker>
    </make>
  </data>

  <!-- =============== BLG Cepheid params ======================== -->

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
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, float, "-")</map>
      </rowmaker>
    </make>
  </STREAM>

  <table id="param_blg_cep_cepf" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cepF.dat 
                with parameters of fundamental-mode (F) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>

    <LOOP listItems="object_id mean_I mean_V ampl_I period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="period" description="Period"/>
  </table>

  <data id="import_blg_cep_cepf">
    <sources>data/blg_cep/cepF.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cepf"/>
  </data>

  <table id="param_blg_cep_cep1o" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cep1O.dat 
                with parameters of first-overtone (1O) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>
  <data id="import_blg_cep_cep1o">
    <sources>data/blg_cep/cep1O.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cep1o"/>
  </data>

  <table id="param_blg_cep_cepf1o" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cepF1O.dat 
                with parameters of double-mode (F/1O) Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>
  <data id="import_blg_cep_cepf1o">
    <sources>data/blg_cep/cepF1O.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cepf1o"/>
  </data>

  <table id="param_blg_cep_cep1o2o" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cep1O2O.dat
                with parameters of double-mode 1O/2O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>
  <data id="import_blg_cep_cep1o2o">
    <sources>data/blg_cep/cep1O2O.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cep1o2o"/>
  </data>

  <table id="param_blg_cep_cep1o2o3o" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cep1O2O3O.dat
                with parameters of triple-mode 1O/2O/3O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>
  <data id="import_blg_cep_cep1o2o3o">
    <sources>data/blg_cep/cep1O2O3O.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cep1o2o3o"/>
  </data>

  <table id="param_blg_cep_cep2o3o" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from the base of original cep2O3O.dat
                with parameters of 2O/3O Cepheids
                from OGLE classical Cepheids toward the Galactic bulge collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>
  <data id="import_blg_cep_cep2o3o">
    <sources>data/blg_cep/cep2O3O.dat</sources>
    <FEED source="blg_cep_dd" table_name="param_blg_cep_cep2o3o"/>
  </data>

<!-- ==================== M54 stars  =========================================== -->

  <table id="m54" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The (almost) original table M54variables.dat with identification and parameters of stars
                   from Sagittarius Dwarf Spheroidal Galaxy and its M54 Globular Cluster</meta>

    <LOOP listItems="object_id raj2000 dej2000 period period_err ogle_vartype vartype
                     mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <!-- JK: there is an error in column format description in the README file; corrected -->
  <data id="import_m54">
    <sources>data/m54/M54variables_cleaned.dat</sources>
    <columnGrammar topIgnoredLines="3">
      <colDefs>
        object_id:   1-4
        alphaHMS:   13-23
        deltaDMS:   26-36
        period:     110-121
        period_err: 124-134
        ogle_vartype: 147-153
        mean_I:     179-184
        mean_V:     155-160
        ampl_I:     203-207
      </colDefs>
    </columnGrammar>
    <make table="m54">
      <rowmaker idmaps="*">
        <map name="object_id">"OGLE-M54-"+@object_id</map>
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, float, "-")</map>

        <!-- Try to bring ogle vartypes to the Simbad codes -->        
        <var name="vartype">@ogle_vartype</var>
        <apply name="to_simbad_vartype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"vartype"</bind>
          <bind key="mapping"> {
            "-" : None,
            "v" : "V*",
            "RRab": "RR*",
            "RRc": "RR*",
            "RRd": "RR*",
            "EA": "EB*",
            "EB": "EB*",
            "EW": "EB*",
            "SXPhe": "SX*",
            "Irr": "Ir*",
            "SR": "V*",
            "BLHer": "WV*",
            "WVir": "WV*",
            "Ell": "El*",
            "spotted": "Ro*"
          } </bind>
        </apply>
        <map dest="ogle_vartype">parseWithNull(@ogle_vartype, str, "-")</map>
      </rowmaker>
    </make>
  </data>

<!-- ########################## lightcurves ############################################## -->


  <table id="lightcurves" onDisk="True" adql="True"  namePath="ogle/aux#lc">
    <meta name="description">The united table with photometry points of all OGLE Lightcurves</meta>
    <index columns="object_id"/>
    <index columns="passband"/>
    <index columns="obs_time"/>

    <LOOP listItems="object_id passband obs_time magnitude mag_err ogle_phase">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_lightcurves" updating="False">

    <!-- <sources pattern="data/blgx_lpv/phot_ogle3/[VI]/*.dat"/>  -->
    <sources pattern="data/m54/phot/I/*.dat"/>

    <csvGrammar delimiter=" " strip="True" names="dateobs_jd, magnitude, mag_err"/>

    <make table="lightcurves">
      <rowmaker idmaps="*">
        <!-- OGLE jds come with different "time zero-points" unfortunately -->
        <var name="to_mjd">
          2400000.5 if "blg_cep" in \rootlessPath else -49999.5
        </var>
        <var name="obs_time">float(@dateobs_jd)-@to_mjd</var>

        <apply name="restore_object_names">
          <code>
            abs_path = vars["parser_"].sourceToken
            name = \srcstem
            name = name[:-2] if name.endswith(("_V", "_I")) else name
            collection = abs_path.split("/")[-4].upper()
            if not name.startswith("OGLE"):
              name = "OGLE-" + collection + "-" + name
            @object_id = name
          </code>
        </apply>
<!--        <map key="object_id">
          \srcstem[:-2] if \srcstem.endswith(("_V", "_I")) else \srcstem
        </map>
-->

        <!-- <map key="object_id">\srcstem</map> -->
        <map key="passband">\rootlessPath.split("/")[-2]</map>

        <!-- OGLE phase: phot -> 0, phot_ogle2 -> 2, etc. -->
        <map key="ogle_phase">
          0 if \rootlessPath.split("/")[-3] == "phot" \
          else int(\rootlessPath.split("/")[-3].replace("phot_ogle", ""))
        </map>
      </rowmaker>
    </make>
  </data>

<!-- ############################## web services ################################### -->

  <service id="cep-web" allowed="form">
    <meta name="title">OGLE BLG CEP united table</meta>
    <meta name="description">
      This form allows to select OGLE Galactic bulge Cepheids TBD
    </meta>
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
      <!-- <condDesc buildFrom="pulse_mode"/>  -->
      <condDesc>
        <inputKey original="pulse_mode">
          <values fromdb="pulse_mode from \schema.ident_blg_cep"/>
        </inputKey>
      </condDesc>

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
