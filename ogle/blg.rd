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

  <meta name="title">Original OGLE Variable Stars tables form the \field Collection.</meta>
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
    <DEFAULTS sep=":"/>

    <!-- Input HMS/DMS fields are quite diverse: separators may be spaces or
         colons; leading  zeros may be replaced by extra spaces -->
    <var name="raj2000">hmsToDeg(@alphaHMS.replace(" \sep", "\sep"), "\sep")</var>
    <var name="dej2000">dmsToDeg(@deltaDMS.replace(" \sep", "\sep"), "\sep")</var>

    <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "")</map>
    <map dest="ogle3_id">parseWithNull(@ogle3_id, str, "")</map>
    <map dest="ogle2_id">parseWithNull(@ogle2_id, str, "")</map>
    <map dest="vsx">parseWithNull(@vsx, str, "")</map>
  </STREAM>

<!-- ================ Classical Cepheids ================== -->

  <table id="ident_blg_cep" onDisk="True" adql="hidden" namePath="ogle/aux#cepheid">
    <meta name="description">The original table with identification of 
                       Classical Cepheids \field collection</meta>

    <LOOP listItems="object_id raj2000 dej2000 pulse_mode ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass ssa_collection ssa_reference">
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
        <var name="ssa_targclass">"Ce*"</var>
        <var name="ssa_collection">"\prefix-CEP"</var>
        <var name="ssa_reference">"\referenceCep"</var>
      </rowmaker>
    </make>
  </data>

  <!-- =============== Classical Cepheids parameters ======================== -->

  <!-- ================ Single mode =============== -->
  <LOOP>
    <csvItems>
      class,             source, subclass
      cepf,           cepF.dat, fundamental-mode-(F)-Cepheids
      cep1o,         cep1O.dat, first-overtone-(1O)-Cepheids
    </csvItems>
    <events>
      <table id="param_blg_cep_\class" onDisk="True" adql="hidden" namePath="ogle/aux#cepheid">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>

        <LOOP listItems="object_id mean_I mean_V ampl_I period period_err epoch">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
      </table>
      <data id="import_param_blg_\class">
        <sources>data/blg/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     34-43
              period_err: 45-53
              epoch:      56-66
              ampl_I:     70-74
          </colDefs>
        </columnGrammar>
        <make table="param_blg_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V period period_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch">float(@epoch)-JD_MJD</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

  <!-- ================ Double mode ============== -->

  <LOOP>
    <csvItems>
      class,             source, subclass
      cepf1o,       cepF1O.dat, double-mode-(F/1O)-Cepheids
      cep1o2o,     cep1O2O.dat, double-mode-(1O/2O)-Cepheids
      cep2o3o,     cep2O3O.dat, double-mode-(2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_blg_cep_\class" onDisk="True" adql="hidden" namePath="ogle/aux#cepheid">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>

        <LOOP listItems="object_id mean_I mean_V ampl_I period period_err 
                         period_short period_short_err epoch">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
      </table>
      <data id="import_param_blg_\class">
        <sources>data/blg/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     34-43
              period_err: 45-53
              epoch:      56-67
              ampl_I:     70-74
              period_short:     102-111
              period_short_err: 113-121
          </colDefs>
        </columnGrammar>
        <make table="param_blg_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V period period_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch">float(@epoch)-JD_MJD</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

  <!-- ================ Triple mode ============== -->

  <LOOP>
    <csvItems>
      class,             source, subclass
      cep1o2o3o, cep1O2O3O.dat, triple-mode-(1O/2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_blg_cep_\class" onDisk="True" adql="hidden" namePath="ogle/aux#cepheid">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>

        <LOOP listItems="object_id mean_I mean_V ampl_I period period_err 
                         period_med period_med_err period_short period_short_err epoch">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
      </table>
      <data id="import_param_blg_\class">
        <sources>data/blg/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     34-43
              period_err: 45-53
              epoch:      56-67
              ampl_I:     70-74
              period_med:     102-111
              period_med_err: 113-121
              period_short:     170-179
              period_short_err: 181-189
          </colDefs>
        </columnGrammar>
        <make table="param_blg_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V period period_err 
                  period_med period_med_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch">float(@epoch)-JD_MJD</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>
<!-- ======================= LPV (Miras) ================================== -->

  <table id="ident_blg_lpv" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of Mira stars \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_lpv">
    <sources>data/blg/lpv/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
        type:         22-25
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
        <var name="ssa_targclass">"LP*"</var>
        <var name="ssa_collection">"\prefix-LPV"</var>
        <var name="ssa_reference">"\referenceLPV"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= DPV (Double Periodic Variables) ================================== -->
<!-- Is this is a subset of ecl? What about lightcurves, are they included in the ecl collection?-->

<!-- ======================= short_period_ecl  ================================== -->
<!-- Is this is a subset of ecl? What about lightcurves, are they included in the ecl collection?-->


<!-- ======================= DSct (Delta Sct) ================================== -->

  <table id="ident_blg_dsct" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identifications of delta Scuti-type stars
                 \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx subtype ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_dsct">
    <sources>data/blg/dsct/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
	    subtype:      22-31
        alphaHMS:     34-44
        deltaDMS:     46-56
        ogle4_id:     59-74
        ogle3_id:     76-90
        ogle2_id:     92-107
        vsx:         109-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_dsct">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"dSct"</var>
        <var name="ssa_targclass">"dS*"</var>
        <var name="ssa_collection">"\prefix-DSCT"</var>
        <var name="ssa_reference">"\referenceDSct"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= t2cep (Type II Cepheids) ================================== -->

  <macDef name="class_desc">Type II Cepheids</macDef>

  <table id="ident_blg_t2cep" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identifications of \class_desc \field</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx subtype ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_t2cep">
    <sources>data/blg/t2cep/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
	    subtype:      22-26
        alphaHMS:     29-39
        deltaDMS:     41-51
        ogle4_id:     54-69
        ogle3_id:     71-85
        ogle2_id:     87-101
        vsx:         103-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_t2cep">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"T2Cep"</var>
        <var name="ssa_targclass">"WV*"</var>
        <var name="ssa_collection">"\prefix-T2CEP"</var>
        <var name="ssa_reference">"\referenceT2Cep"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= HB (Heartbeat stars) ================================== -->

  <table id="ident_blg_hb" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identifications of Heartbeat binary systems
                in the Galactic bulge and Magellanic Clouds</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx subtype ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_hb">
    <sources>data/blg/hb/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-16
	    subtype:      18-19
        alphaHMS:     21-31
        deltaDMS:     33-43
        ogle4_id:     56-60
        ogle3_id:     62-76
        ogle2_id:     78-92
        vsx:         94-123
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_hb">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent" sep=" "/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"Hb"</var>
        <var name="ssa_targclass">"Pu*,El*"</var>
        <var name="ssa_collection">"\prefix-HB"</var>
        <var name="ssa_reference">"\referenceHB"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= ROT (Rotating Variables) ================================== -->

  <table id="ident_blg_rot" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identifications of Rotating Variables
                 \field colection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     vsx ogle_vartype ssa_targclass subtype ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <!-- The format described in the original README is completely incorrect -->
  <data id="import_blg_rot">
    <sources>data/blg/rot/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
        alphaHMS:     21-31
        deltaDMS:     33-43
        ogle4_id:     45-60
        ogle3_id:     62-76
        ogle2_id:     78-92
        vsx:          95-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_rot">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <var name="ogle_vartype">"Rot"</var>
        <var name="ssa_targclass">"Ro*"</var>
        <var name="subtype">None</var>
        <var name="ssa_collection">"\prefix-ROT"</var>
        <var name="ssa_reference">"\referenceRot"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= Ecl (Eclipsing and Ellipsoidal) ================================== -->

  <table id="ident_blg_ecl" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identifications of Eclipsing and Ellipsoidal
                 binary systems \field colection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     subtype vsx ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_blg_ecl">
    <sources>data/blg/ecl/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
        subtype:      22-24
        alphaHMS:     26-36
        deltaDMS:     38-48
        ogle4_id:     51-66
        ogle3_id:     68-82
        ogle2_id:     84-98
        vsx:          99-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_ecl">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <map key="subtype">parseWithNull(@subtype, str, "")</map>
        <map key="ogle_vartype">@object_id.split("-")[2].capitalize()</map>

        <var name="ssa_targclass">@subtype</var>
        <apply name="ecl_to_simbad_otype" procDef="//procs#dictMap">
          <bind key="default">"EB*"</bind>
          <bind key="key">"ssa_targclass"</bind>
          <bind key="mapping"> {
            "C": "EB*",
            "NC": "EB*",
            "CV": "CV*",
            "ELL": "El*",
          } </bind>
        </apply>

        <map key="ssa_collection">f'\prefix-{@object_id.split("-")[2]}'</map>
        <var key="ssa_reference">"\referenceEcl"</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= RR Lyr ================================== -->

  <table id="ident_blg_rr" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of RR Lyr stars \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     ogle_vartype ssa_targclass subtype ssa_collection ssa_reference">
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

        <var name="ssa_targclass">@subtype</var>
        <apply name="rr_to_simbad_otype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"ssa_targclass"</bind>
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

<!-- ======================= Transits ================================== -->

  <table id="ident_blg_transits" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The original table with identification of candidates for transiting
                   planets \field collection</meta>

    <LOOP listItems="object_id  raj2000 dej2000 ogle4_id ogle3_id ogle2_id
                     ogle_vartype ssa_targclass subtype ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="vsx" description="GCVS or VSX designation"/>
  </table>

  <data id="import_blg_transits">
    <sources>data/blg/transits/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-12
        alphaHMS:     14-24
        deltaDMS:     26-36
        ogle4_id:     38-53
        ogle3_id:     55-69
        ogle2_id:     71-85
        vsx:          87-150
      </colDefs>
    </columnGrammar>
    <make table="ident_blg_transits">
      <rowmaker idmaps="*">
        <FEED source="makeCommonRowsIdent"/>
        <var name="subtype">None</var>
        <var name="ssa_targclass">"V*,Pl"</var>
        <var name="ogle_vartype">"Transit"</var>
        <var name="ssa_collection">"\prefix-TR"</var>
        <var name="ssa_reference">"\referenceTransits"</var>
      </rowmaker>
    </make>
  </data>

<!-- ########################## Parameters tables ################## -->

<!-- ================================= Param Miras (LPV) ============= -->

  <table id="param_blg_lpv" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original Miras.dat from OGLE Mira stars \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_param_blg_lpv">
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
    <make table="param_blg_lpv">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <var name="period_err">None</var>
      </rowmaker>
    </make>
  </data>

<!-- ================================= Param DSCT (Delta Sct) ============= -->

  <table id="param_blg_dsct" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original dsct.dat from OGLE Delta Scuti Stars \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_param_blg_dsct">
    <sources>data/blg/dsct/dsct.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-19
        mean_I:     22-27
        mean_V:     29-34
        period:     37-46
        period_err: 48-57
        ampl_I:     72-76
      </colDefs>
    </columnGrammar>
    <make table="param_blg_dsct">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, float, "-")</map>
      </rowmaker>
    </make>
  </data>

<!-- ================================= Param t2cep (Type II Cepheids) ============= -->

  <table id="param_blg_t2cep" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original t2cep.dat from OGLE Type II Cepheids \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_param_blg_t2cep">
    <sources>data/blg/t2cep/t2cep.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-19
        mean_I:     22-27
        mean_V:     29-34
        period:     37-46
        period_err: 48-56
        ampl_I:     73-77
      </colDefs>
    </columnGrammar>
    <make table="param_blg_t2cep">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, float, "-")</map>
      </rowmaker>
    </make>
  </data>

<!-- =============================== Param HB (heartbeat binary systems) ============ -->

  <table id="param_blg_hb" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original hb.dat from OGLE 
                         Heartbeat binary systems \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_param_blg_hb">
    <sources>data/blg/hb/hb.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-16
        mean_I:     18-23
        mean_V:     25-30
        period:     32-44
        ampl_I:     57-61
      </colDefs>
    </columnGrammar>
    <make table="param_blg_hb">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <var name="period_err">None</var>
      </rowmaker>
    </make>
  </data>

<!-- =============================== Param Rot (rotating) ============ -->

  <table id="param_blg_rot" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original rot.dat from OGLE 
                         Rotating Variables \field collection</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I ampl_V period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <!-- The format described in the original README is completely incorrect 
  I've corrected format, but I'm not sure if columns V and I are reversed -->
  <data id="import_param_blg_rot">
    <sources>data/blg/rot/rot.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-19
        mean_V:     21-26
        ampl_V:     27-32
        mean_I:     34-39
        ampl_I:     40-45
        period:     48-58
      </colDefs>
    </columnGrammar>
    <make table="param_blg_rot">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="ampl_V">parseWithNull(@ampl_V, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <var name="period_err">None</var>
      </rowmaker>
    </make>
  </data>

  <!-- =============== Transits parameters ======================== -->

  <table id="param_blg_transits" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The table from original transits.dat from OGLE
                catalog of candidates for transiting planets \field</meta>
    <LOOP listItems="object_id mean_I mean_V period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="ampl_I" description="Transit depth"/>
  </table>

  <!-- There is an incorrect format description in the README file -->
  <data id="import_param_blg_transits">
    <sources>data/blg/transits/transits.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-12
        mean_I:     14-19
        mean_V:     21-26
        period:     28-38
        ampl_I:     51-56
      </colDefs>
    </columnGrammar>
    <make table="param_blg_transits">
      <rowmaker idmaps="*">
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <var name="period_err">None</var>
      </rowmaker>
    </make>
  </data>

  <!-- =============== Ecl/Ell parameters ======================== -->

  <LOOP>
    <csvItems>
      class,   source, subclass
      ecl,    ecl.dat, eclipsing-binaries
      ell,    ell.dat, ellipsoidal-binaries
    </csvItems>
    <events>
      <table id="param_blg_\class" onDisk="True" adql="hidden" namePath="ogle/aux#object">
        <meta name="description">The table from the base of original \source file
                  with parameters of \subclass stars
                  from OGLE Eclipsing and Ellipsoidal Binary Systems  \\field collection</meta>
        <LOOP listItems="object_id ampl_I period period_err">
          <events>
            <column original="\item"/>
          </events>
        </LOOP>
        <column original="mean_I" description="I-band magnitude at the maximum light"/>
        <column original="mean_V" description="V-band magnitude at the maximum light"/>
        <column original="ampl_I" description="Depth of the primary eclipse" tablehead="Primary Ampl"/>
        <column original="ampl_V" description="Depth of the secondary eclipse" tablehead="Secondary Ampl"/>
      </table>
      <data id="import_blg_\class">
        <sources>data/blg/ecl/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:   1-19
            mean_I:     22-27
            mean_V:     29-34
            period:     36-47
            depth1:     61-65
            depth2:     67-71            
          </colDefs>
        </columnGrammar>
        <make table="param_blg_\class">
          <rowmaker idmaps="*">
            <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
            <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
            <map dest="period">parseWithNull(@period, float, "-")</map>
            <var key="period_err">None</var>
            <map dest="ampl_I">parseWithNull(@depth1, float, "-")</map>
            <map dest="ampl_V">parseWithNull(@depth2, float, "-")</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

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


</resource>
