<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <macDef name="field">toward the Galactic bulge</macDef>
  <macDef name="prefix">OGLE-BLG</macDef>

<!-- Assign each collection its own ssa_reference --> 
  <macDef name="referenceDefault">2015AcA....65....1U</macDef>
  <macDef name="referenceCep">2017AcA....67..297S</macDef>
  <macDef name="referenceLPV">2022ApJS..260...46I</macDef>
  <macDef name="referenceRRLyr">2014AcA....64..177S</macDef>
  <macDef name="referenceDPV">\referenceDefault</macDef>
  <macDef name="referenceDSct">2020AcA....70..241P</macDef>
  <macDef name="referenceEcl">2016AcA....66..405S</macDef>
  <macDef name="referenceHB">2022ApJS..259...16W</macDef>
  <macDef name="referenceRot">\referenceDefault</macDef>
  <macDef name="referenceShortEcl">2015AcA....65...39S</macDef>
  <macDef name="referenceT2Cep">2017AcA....67..297S</macDef>
  <macDef name="referenceTransits">2023AcA....73..127M</macDef>

  <meta name="title">Original OGLE Variable Stars Collection tables.</meta>
  <meta name="description">
    The OGLE project consists of several sub-surveys that differ by sky coverage and by the type of variability targeted.
    The content and structure of tables containing observed object parameters vary between these sub-surveys.

    In this resource descriptor, the individual tables related to the Variable Stars \field
    Collections are ingested separately, one by one.
    In q.rd all these tables are combined into a common objects_all table implemented as a unified view.
    Original tables are not supposed to be seen from outside via ADQL or web-forms 
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

<!-- ##########################  Ident tables  #############  -->

  <STREAM id="makeCommonRowsIdent">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
        <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
        <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
        <map dest="vsx">parseWithNull(@vsx, str, "")</map>    
  </STREAM>

<!-- ================ Classical Cepheids ================== -->

  <table id="ident_blg_cep" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of 
                       Classical Cepheids \field collection</meta>

    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype vartype ssa_collection ssa_reference">
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
    <sources>data/blg/cep/ident.dat</sources>

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
        <var name="ogle_vartype">"Cep"</var>
        <var name="vartype">"Ce*"</var>
        <var name="ssa_collection">"\prefix-CEP"</var>
        <var name="ssa_reference">"\referenceCep"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= LPV (Miras) ================================== -->

  <table id="ident_blg_lpv" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of Mira stars \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx ogle_vartype vartype ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_lpv">
    <sources>data/blg/lpv/ident.dat</sources>
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
        <var name="ssa_collection">"\prefix-LPV"</var>
        <var name="ssa_reference">"\referenceLPV"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= RR Lyr ================================== -->

  <table id="ident_blg_rr" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of RR Lyr stars \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     ogle_vartype vartype subtype ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="vsx" description="GCVS or VSX designation"/>
  </table>

  <data id="import_blg_rr">
    <sources>data/blg/rrlyr/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-20
        subtype:      23-26
        alphaHMS:     29-39
        deltaDMS:     41-51
        ogle4_id:     54-69
        ogle3_id:     71-85
        ogle2_id:     87-101
        vsx:         103-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_rr">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <!-- Map ogle RRlyr suptypes to the Simbad codes -->
        <var name="vartype">@subtype</var>
        <apply name="to_simbad_vartype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"vartype"</bind>
          <bind key="mapping"> {
            "-" : None,
            "RRab": "RR*",
            "RRc": "RR*",
            "RRd": "RR*",
          } </bind>
        </apply>
        <var name="ogle_vartype">"RR Lyr"</var>
        <var name="ssa_collection">"\prefix-RRLYR"</var>
        <var name="ssa_reference">"\referenceRRLyr"</var>
      </rowmaker>
    </make>
  </data>

<!-- ########################## Parameters tables ################## -->

<!-- ================================= Param Miras (LPV) ============= -->

  <table id="param_blg_lpv_miras" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original Miras.dat from OGLE Mira stars \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_param_blg_lpv_miras">
    <sources>data/blg/lpv/Miras.dat</sources>
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

  <!-- =============== RR Lyr parameters ======================== -->

  <LOOP>
    <csvItems>
      class,   source, subclass
      rr_ab, RRab.dat, RRab
      rr_c,   RRc.dat, first-overtone
      rr_d,   RRd.dat, double-mode
      arr_d, aRRd.dat, anomalous-RRd
    </csvItems>
    <events>
      <table id="param_blg_\class" onDisk="True" adql="hidden" namePath="ogle/aux#object">
        <meta name="description">The table from the base of original \source 
                  with parameters of \subclass stars
                  from OGLE RR Lyr \\field collection</meta>
        <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
      </table>
      <data id="import_blg_\class">
        <sources>data/blg/rrlyr/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:   1-20
            mean_I:     23-28
            mean_V:     30-35
            period:     38-47
            period_err: 49-58
            ampl_I:     73-77
          </colDefs>
        </columnGrammar>
        <make table="param_blg_\class">
          <rowmaker idmaps="*">
            <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
            <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
            <map dest="period">parseWithNull(@period, float, "-")</map>
            <map dest="period_err">parseWithNull(@period_err, float, "-")</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

  <!-- =============== Cepheids parameters ======================== -->

  <LOOP>
    <csvItems>
      class,             source, subclass
      cepf,           cepF.dat, fundamental-mode-(F)-Cepheids
      cep1o,         cep1O.dat, first-overtone-(1O)-Cepheids
      cepf1o,       cepF1O.dat, double-mode-(F/1O)-Cepheids
      cep1o2o,     cep1O2O.dat, double-mode-(1O/2O)-Cepheids
      cep1o2o3o, cep1O2O3O.dat, triple-mode-(1O/2O/30)-Cepheids
      cep2o3o,     cep2O3O.dat, double-mode-(2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_blg_cep_\class" onDisk="True" adql="hidden" namePath="ogle/aux#object">
        <meta name="description">The table from the base of original \source
                with parameters of \subclass
                from OGLE classical Cepheids \\field collection</meta>

        <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
      </table>
      <data id="import_blg_\class">
        <sources>data/blg/cep/\source</sources>
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
        <make table="param_blg_cep_\class">
          <rowmaker idmaps="*">
            <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
            <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
            <map dest="period">parseWithNull(@period, float, "-")</map>
            <map dest="period_err">parseWithNull(@period_err, float, "-")</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

</resource>
