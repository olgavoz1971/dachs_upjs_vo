<?xml version="1.0" encoding="utf-8"?>
<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <macDef name="field">in the Large Magellanic Cloud</macDef>
  <macDef name="prefix">OGLE-LMC</macDef>

<!-- Assign each collection its own ssa_reference --> 
  <macDef name="referenceDefault">2015AcA....65....1U</macDef>
  <macDef name="referenceACep">2015AcA....65..233S</macDef>
  <macDef name="referenceCep">2015AcA....65..297S</macDef>
  <macDef name="referenceRRLyr">2016AcA....66..131S</macDef>
  <macDef name="referenceDSct">2023AcA....73..105S</macDef>
  <macDef name="referenceEcl">2016AcA....66..421P</macDef>
  <macDef name="referenceHB">2022ApJS..259...16W</macDef>
  <macDef name="referenceT2Cep">2018AcA....68...89S</macDef>

  <meta name="title">Original OGLE Variable Stars tables form the \field Collection.</meta>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ================================= Anomalous Cepheids ============================== -->

  <table id="ident_lmc_acep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of \
                       Anomalous Cepheids \field collection</meta>
    <mixin>ogle/aux#acepheid_id</mixin>
  </table>

  <data id="import_lmc_acep">
    <sources>data/lmc/acep/ident.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-17
        pulse_mode: 20-21
        alphaHMS:   24-34
        deltaDMS:   36-46
        ogle4_id:   49-64
        ogle3_id:   66-80
        ogle2_id:   82-96
        vsx:        98-150
      </colDefs>
    </columnGrammar>

    <make table="ident_lmc_acep">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
        <map dest="pulse_mode">parseWithNull(@pulse_mode, str, "")</map>
        <var name="ogle_vartype">"ACep"</var>
        <var name="ssa_targclass">"Ce*"</var>
        <var name="ssa_collection">"\prefix-ACEP"</var>
        <var name="ssa_reference">"\referenceACep"</var>
      </rowmaker>
    </make>
  </data>

  <!-- =============== Anomlous Cepheids parameters ======================== -->

  <!-- ================ Single mode =============== -->
  <LOOP>
    <csvItems>
      class,             source, subclass
      acepf,           acepF.dat, fundamental-mode-(F)-A.Cepheids
      acep1o,         acep1O.dat, first-overtone-(1O)-A.Cepheids
    </csvItems>
    <events>
      <table id="param_lmc_acep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source with parameters of \subclass \
                from OGLE Anomalous Cepheids \\field collection</meta>

        <mixin>ogle/aux#acepheid_p</mixin>
      </table>

      <data id="import_param_lmc_\class">
        <sources>data/lmc/acep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-17
              mean_I:     20-25
              mean_V:     27-32
              period:     34-43
              period_err: 45-53
              epoch:      56-65
              ampl_I:     68-72
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_acep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

<!-- ================================= Classical Cepheids ============================== -->

  <table id="ident_lmc_cep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of \
                       Classical Cepheids \field collection</meta>
    <!-- Pull all columns from the prototype id table: -->
    <mixin>ogle/aux#cepheid_id</mixin>
<!--
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#cepheid_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="\item"/>
       </events>
    </LOOP>
-->
  </table>

  <data id="import_lmc_cep">
    <sources>data/lmc/cep/ident.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-17
        pulse_mode: 19-26
        alphaHMS:   29-39
        deltaDMS:   41-51
        ogle4_id:   54-69
        ogle3_id:   71-85
        ogle2_id:   87-101
        vsx:        103-150
      </colDefs>
    </columnGrammar>

    <make table="ident_lmc_cep">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
        <map dest="pulse_mode">parseWithNull(@pulse_mode, str, "")</map>
        <var name="ogle_vartype">"Cep"</var>
        <var name="ssa_targclass">"cC*"</var>
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
      cep2o,         cep2O.dat, second-overtone-(2O)-Cepheids
    </csvItems>
    <events>
      <table id="param_lmc_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>

        <mixin>ogle/aux#cepheid_p</mixin>   
      </table>

      <data id="import_param_lmc_\class">
        <sources>data/lmc/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-17
              mean_I:     20-25
              mean_V:     27-32
              period:     34-44
              period_err: 46-54
              epoch:      57-66
              ampl_I:     68-73
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
            <!-- <map dest="epoch">float(@epoch)-JD_MJD</map> -->
            <!-- 
            JK: seems, here is no need to do this explcitly, DaCHS assigns None
            authomatucally to all empty columns, right?
            <LOOP listItems="period_short period_short_err period_med period_med_err">
              <events>
                <var key="\item">None</var>
              </events>
            </LOOP>
            -->
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
      cep1o3o,     cep1O3O.dat, double-mode-(1O/3O)-Cepheids
      cep2o3o,     cep2O3O.dat, double-mode-(2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_lmc_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>
        <mixin>ogle/aux#cepheid_p</mixin>
      </table>

      <data id="import_param_lmc_\class">
        <sources>data/lmc/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-17
              mean_I:     20-25
              mean_V:     27-32
              period:     34-44
              period_err: 46-54
              epoch:      57-66
              ampl_I:     69-73
              period_short:     101-110
              period_short_err: 112-120
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
            <!--
            <LOOP listItems="period_med period_med_err">
              <events>
                <var key="\item">None</var>
              </events>
            </LOOP>
            -->
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

  <!-- ================ Triple mode ============== -->

  <LOOP>
    <csvItems>
      class,             source, subclass
      cepF1o2o, cepF1O2O.dat, triple-mode-(F/2O/30)-Cepheids
      cep1o2o3o, cep1O2O3O.dat, triple-mode-(1O/2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_lmc_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>
        <mixin>ogle/aux#cepheid_p</mixin>
      </table>

      <data id="import_param_lmc_\class">
        <sources>data/lmc/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-17
              mean_I:     20-25
              mean_V:     27-32
              period:     34-44
              period_err: 46-54
              epoch:      57-66
              ampl_I:     69-73
              period_med:     101-110
              period_med_err: 112-120
              period_short:     167-176
              period_short_err: 178-186
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err 
                  period_med period_med_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

<!-- ============================= DSct (Delta Sct) ============================================ -->

  <table id="ident_lmc_dsct" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of delta Scuti-type stars \field collection</meta>
    <mixin>ogle/aux#dsct_id</mixin>
  </table>

  <data id="import_lmc_dsct">
    <sources>data/lmc/dsct/ident.dat</sources>
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
    <make table="ident_lmc_dsct">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"dSct"</var>
        <var name="ssa_targclass">"dS*"</var>
        <var name="ssa_collection">"\prefix-DSCT"</var>
        <var name="ssa_reference">"\referenceDSct"</var>
      </rowmaker>
    </make>
  </data>

<!-- ================================= Param DSCT (Delta Sct) ============= -->

  <table id="param_lmc_dsct" onDisk="True" adql="hidden">
    <meta name="description">The table from original dsct.dat from OGLE Delta Scuti Stars \field collection</meta>
    <mixin>ogle/aux#dsct_p</mixin>
  </table>

  <data id="import_param_lmc_dsct">
    <sources>data/lmc/dsct/dsct.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
        mean_I:       22-27
        mean_V:       29-34
        period:       37-46
        period_err:   48-57
        epoch:        60-69
        ampl_I:       72-76
        period2:     105-114
        period2_err: 116-125
        period3:     173-182
        period3_err: 184-193
      </colDefs>
    </columnGrammar>
    <make table="param_lmc_dsct">
      <rowmaker idmaps="*">
        <LOOP listItems="mean_I mean_V ampl_I period period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <LOOP listItems="period2 period2_err period3 period3_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "")</map>
          </events>
        </LOOP>
        <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
      </rowmaker>
    </make>
  </data>

<!-- ========================= Ecl (Eclipsing and Ellipsoidal) ================================== -->

  <table id="ident_lmc_ecl" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of Eclipsing and Ellipsoidal \
                 binary systems \field colection</meta>
    <mixin>ogle/aux#ecl_id</mixin>
  </table>

  <data id="import_lmc_ecl">
    <sources>data/lmc/ecl/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-18
        subtype:      21-23
        alphaHMS:     25-35
        deltaDMS:     37-47
        ogle4_id:     50-65
        ogle3_id:     67-81
        ogle2_id:     83-97
        vsx:          99-150
      </colDefs>
    </columnGrammar>
    <make table="ident_lmc_ecl">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
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

  <!-- ============== Ecl/Ell parameters ====================== -->

  <LOOP>
    <csvItems>
      class,   source, subclass
      ecl,    ecl.dat, eclipsing-binaries
      ell,    ell.dat, ellipsoidal-binaries
    </csvItems>
    <events>
      <table id="param_lmc_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source file with parameters \
              of \subclass stars from OGLE Eclipsing and Ellipsoidal Binary Systems  \\field collection</meta> 
       <mixin>ogle/aux#ecl_p</mixin>
      </table>

      <data id="import_param_lmc_\class">
        <sources>data/lmc/ecl/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:   1-18
            mean_I:     21-26
            mean_V:     28-33
            period:     35-46
            epoch:      49-60
            depth1:     62-67
            depth2:     69-73            
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V period depth1 depth2">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <var key="period_err">None</var>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")-JD_MJD</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

<!-- ======================= HB (Heartbeat stars) ================================== -->

  <table id="ident_lmc_hb" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of Heartbeat binary systems \
                in the Galactic bulge and Magellanic Clouds</meta>
    <mixin>ogle/aux#hb_id</mixin>
  </table>

  <data id="import_lmc_hb">
    <sources>data/lmc/hb/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-16
	    subtype:      18-19
        alphaHMS:     21-31
        deltaDMS:     33-43
        ogle4_id:     45-60
        ogle3_id:     62-76
        ogle2_id:     78-92
        vsx:         94-123
      </colDefs>
    </columnGrammar>
    <make table="ident_lmc_hb">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent" sep=" "/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"Hb"</var>
        <var name="ssa_targclass">"Pu*,El*"</var>
        <var name="ssa_collection">"\prefix-HB"</var>
        <var name="ssa_reference">"\referenceHB"</var>
      </rowmaker>
    </make>
  </data>

<!-- ====================== Param HB (heartbeat binary systems) ============ -->

  <table id="param_lmc_hb" onDisk="True" adql="hidden">
    <meta name="description">The table from original hb.dat from OGLE \
                         Heartbeat binary systems \field collection</meta>
    <mixin>ogle/aux#hb_p</mixin>
  </table>

  <data id="import_param_lmc_hb">
    <sources>data/lmc/hb/hb.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-16
        mean_I:     18-23
        mean_V:     25-30
        period:     32-44
        epoch:      46-55
        ampl_I:     57-61
        ecc:        63-68
        incl:       70-74
        omega:      76-81
        add_var:    83-91
      </colDefs>
    </columnGrammar>
    <make table="param_lmc_hb">
      <rowmaker idmaps="*">
        <LOOP listItems="mean_I mean_V ampl_I period ">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <var name="period_err">None</var>
        <map dest="add_var">parseWithNull(@add_var, str, "")</map>
        <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
      </rowmaker>
    </make>
  </data>

<!-- ======================= RR Lyr ================================== -->

  <table id="ident_lmc_rr" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of RR Lyr stars \field collection</meta>
    <mixin>ogle/aux#rrlyr_id</mixin>
  </table>

  <data id="import_lmc_rr">
    <sources>data/lmc/rrlyr/ident.dat</sources>
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
    <make table="ident_lmc_rr">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>

        <var name="ssa_targclass">@subtype</var>
        <apply name="rr_to_simbad_otype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"ssa_targclass"</bind>
          <bind key="mapping"> {
            "-" : None,
            "RRab": "RR*",
            "RRc": "RR*",
            "RRd": "RR*",
            "aRRd": "RR*",
          } </bind>
        </apply>
        <var name="ogle_vartype">"RR Lyr"</var>
        <var name="ssa_collection">"\prefix-RRLYR"</var>
        <var name="ssa_reference">"\referenceRRLyr"</var>
      </rowmaker>
    </make>
  </data>

  <!-- =============== RR Lyr parameters ======================== -->

  <LOOP>										<!-- single mode -->
    <csvItems>
      class,   source, subclass
      rr_ab, RRab.dat, RRab
      rr_c,   RRc.dat, first-overtone
    </csvItems>
    <events>
      <table id="param_lmc_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                  with parameters of \subclass stars \
                  from OGLE RR Lyr \\field collection</meta>
        <mixin>ogle/aux#rrlyr_p</mixin>
      </table>

      <data id="import_lmc_\class">
        <sources>data/lmc/rrlyr/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:   1-20
            mean_I:     23-28
            mean_V:     30-35
            period:     38-46
            period_err: 48-56
            epoch:      59-68
            ampl_I:     71-75
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period  period_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

  <LOOP>									<!-- double mode -->
    <csvItems>
      class,   source, subclass
      rr_d,   RRd.dat, double-mode
      arr_d, aRRd.dat, anomalous-RRd
    </csvItems>
    <events>
      <table id="param_lmc_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                  with parameters of \subclass stars \
                  from OGLE RR Lyr \\field collection</meta>

        <mixin>ogle/aux#rrlyr_p</mixin>
      </table>

      <data id="import_lmc_\class">
        <sources>data/lmc/rrlyr/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:    1-20
            mean_I:      23-28
            mean_V:      30-35
            period1:     38-46
            period1_err: 48-56
            period:     104-112
            period_err: 114-122
            epoch:      125-134
            ampl_I:     137-141
          </colDefs>
        </columnGrammar>
        <make table="param_lmc_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err period1 period1_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

<!-- ======================= t2cep (Type II Cepheids) ================================== -->

  <macDef name="class_desc">Type II Cepheids</macDef>

  <table id="ident_lmc_t2cep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of \class_desc \field</meta>
    <mixin>ogle/aux#t2cep_id</mixin>
  </table>

  <data id="import_lmc_t2cep">
    <sources>data/lmc/t2cep/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-18
	    subtype:      21-25
        alphaHMS:     28-38
        deltaDMS:     40-50
        ogle4_id:     53-68
        ogle3_id:     70-84
        ogle2_id:     86-100
        vsx:         102-150
      </colDefs>
    </columnGrammar>
    <make table="ident_lmc_t2cep">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
        <map dest="subtype">parseWithNull(@subtype, str, "")</map>
        <var name="ogle_vartype">"T2Cep"</var>
        <var name="ssa_targclass">"WV*"</var>
        <var name="ssa_collection">"\prefix-T2CEP"</var>
        <var name="ssa_reference">"\referenceT2Cep"</var>
      </rowmaker>
    </make>
  </data>

<!-- ================================= Param t2cep (Type II Cepheids) ============= -->

  <table id="param_lmc_t2cep" onDisk="True" adql="hidden">
    <meta name="description">The table from original t2cep.dat from OGLE Type II Cepheids \field collection</meta>
    <mixin>ogle/aux#t2cep_p</mixin>
  </table>

  <data id="import_param_lmc_t2cep">
    <sources>data/lmc/t2cep/t2cep.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-18
        mean_I:     21-26
        mean_V:     28-33
        period:     36-45
        period_err: 47-55
        epoch:      58-67
        ampl_I:     70-74
      </colDefs>
    </columnGrammar>
    <make table="param_lmc_t2cep">
      <rowmaker idmaps="*">
        <LOOP listItems="mean_I mean_V ampl_I period period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")+49999.5</map>
      </rowmaker>
    </make>
  </data>

</resource>
