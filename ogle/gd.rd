<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <macDef name="field">in the Galactic disk fields</macDef>
  <macDef name="prefix">OGLE-GD</macDef>

<!-- Assign each collection its own ssa_reference --> 
  <macDef name="referenceDefault">2015AcA....65....1U</macDef>
  <macDef name="referenceCep">2018AcA....68..315U</macDef>
  <macDef name="referenceDSct">2021AcA....71..189S</macDef>
  <macDef name="referenceLPV">2022ApJS..260...46I</macDef>
  <macDef name="referenceRRLyr">2019AcA....69..321S</macDef>
  <macDef name="referenceT2Cep">2020AcA....70..101S</macDef>

  <meta name="title">Original OGLE Variable Stars tables form the \field Collection.</meta>

  <FEED source="ogle/meta#field_table_desc" field="\field"/>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ================================= Classical Cepheids ============================== -->

  <table id="ident_gd_cep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of \
                       Classical Cepheids \field collection</meta>
    <mixin>ogle/aux#cepheid_id</mixin>
  </table>

  <data id="import_gd_cep">
    <sources>data/gd/cep/ident.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-16
        pulse_mode: 18-25
        alphaHMS:   28-38
        deltaDMS:   40-50
        ogle4_id:   53-68
        ogle3_id:   70-84
        ogle2_id:   86-100
        vsx:        102-150
      </colDefs>
    </columnGrammar>

    <make table="ident_gd_cep">
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
    </csvItems>
    <events>
      <table id="param_gd_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>
        <mixin>ogle/aux#cepheid_p</mixin>   
      </table>

      <data id="import_param_gd_\class">
        <sources>data/gd/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     33-43
              period_err: 45-53
              epoch:      56-66
              ampl_I:     70-74
          </colDefs>
        </columnGrammar>
        <make table="param_gd_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")-JD_MJD</map>
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
      cep2o3o,     cep2O3O.dat, double-mode-(2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_gd_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>
        <mixin>ogle/aux#cepheid_p</mixin>   
      </table>

      <data id="import_param_gd_\class">
        <sources>data/gd/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     33-43
              period_err: 45-53
              epoch:      56-67
              ampl_I:     70-74
              period_short:     102-111
              period_short_err: 113-121
          </colDefs>
        </columnGrammar>
        <make table="param_gd_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")-JD_MJD</map>
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
      cepf1o2o,   cepF1O2O.dat, triple-mode-(F/1O/2O)-Cepheids
      cep1o2o3o, cep1O2O3O.dat, triple-mode-(1O/2O/30)-Cepheids
    </csvItems>
    <events>
      <table id="param_gd_cep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                with parameters of \subclass \
                from OGLE classical Cepheids \\field collection</meta>
        <mixin>ogle/aux#cepheid_p</mixin>   
      </table>

      <data id="import_param_gd_\class">
        <sources>data/gd/cep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-16
              mean_I:     19-24
              mean_V:     26-31
              period:     33-43
              period_err: 45-53
              epoch:      56-67
              ampl_I:     70-74
              period_med:     102-111
              period_med_err: 113-121
              period_short:     170-179
              period_short_err: 181-189
          </colDefs>
        </columnGrammar>
        <make table="param_gd_cep_\class">
          <rowmaker idmaps="*">
            <LOOP listItems="mean_I mean_V ampl_I period period_err 
                  period_med period_med_err period_short period_short_err">
              <events>
                <map dest="\item">parseWithNull(@\item, float, "-")</map>
              </events>
            </LOOP>
            <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")-JD_MJD</map>
          </rowmaker>
        </make>
      </data>
    </events>
  </LOOP>

<!-- ============================= DSct (Delta Sct) ============================================ -->

  <table id="ident_gd_dsct" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of delta Scuti-type stars \field collection</meta>
    <mixin>ogle/aux#dsct_id</mixin>
  </table>

  <data id="import_gd_dsct">
    <sources>data/gd/dsct/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-17
	    subtype:      20-29
        alphaHMS:     32-42
        deltaDMS:     44-54
        ogle4_id:     57-72
        ogle3_id:     74-88
        ogle2_id:     90-105
        vsx:         107-150
      </colDefs>
    </columnGrammar>
    <make table="ident_gd_dsct">
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

  <table id="param_gd_dsct" onDisk="True" adql="hidden">
    <meta name="description">The table from original dsct.dat from OGLE Delta Scuti Stars \field collection</meta>
    <mixin>ogle/aux#dsct_p</mixin>
  </table>

  <data id="import_param_gd_dsct">
    <sources>data/gd/dsct/dsct.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-17
        mean_I:       20-25
        mean_V:       27-32
        period:       35-44
        period_err:   46-55
        epoch:        58-67
        ampl_I:       70-74
        period2:     103-112
        period2_err: 114-123
        period3:     171-180
        period3_err: 182-191
      </colDefs>
    </columnGrammar>
    <make table="param_gd_dsct">
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

<!-- ======================= LPV (Long Period Variable, Miras) ================================== -->

  <table id="ident_gd_lpv" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of Mira stars \field collection</meta>
    <mixin>ogle/aux#mira_id</mixin>
  </table>

  <data id="import_gd_lpv">
    <sources>data/gd/lpv/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-18
        type:         21-24
        alphaHMS:     27-37
        deltaDMS:     39-49
        ogle4_id:     52-67
        ogle3_id:     69-83
        ogle2_id:     85-100
        vsx:         102-150
      </colDefs>
    </columnGrammar>
    <make table="ident_gd_lpv">
      <rowmaker idmaps="*">
        <FEED source="ogle/aux#makeCommonRowsIdent"/>
        <map dest="ogle_vartype">parseWithNull(@type, str, "")</map>
        <var name="ssa_targclass">"LP*"</var>
        <var name="ssa_collection">"\prefix-LPV"</var>
        <var name="ssa_reference">"\referenceLPV"</var>
      </rowmaker>
    </make>
  </data>

<!-- ====================== Parameters of Miras (LPV) ============= -->

  <table id="param_gd_lpv" onDisk="True" adql="hidden">
    <meta name="description">The table from original Miras.dat from OGLE Mira stars \field collection</meta>
    <mixin>ogle/aux#mira_p</mixin>
  </table>

  <data id="import_param_gd_lpv">
    <sources>data/gd/lpv/Miras.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-18
        mean_I:     21-26
        mean_V:     28-33
        period:     35-43
        ampl_I:     45-49
      </colDefs>
    </columnGrammar>
    <make table="param_gd_lpv">
      <rowmaker idmaps="*">
        <LOOP listItems="mean_I mean_V ampl_I period">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <var name="period_err">None</var>
      </rowmaker>
    </make>
  </data>

<!-- ======================= RR Lyr ================================== -->

  <table id="ident_gd_rr" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of RR Lyr stars \field collection</meta>
    <mixin>ogle/aux#rrlyr_id</mixin>
  </table>

  <data id="import_gd_rr">
    <sources>data/gd/rrlyr/ident.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:     1-19
        subtype:      22-25
        alphaHMS:     28-38
        deltaDMS:     40-50
        ogle4_id:     53-68
        ogle3_id:     70-84
        ogle2_id:     86-100
        vsx:         102-150
      </colDefs>
    </columnGrammar>
    <make table="ident_gd_rr">
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
      <table id="param_gd_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                  with parameters of \subclass stars \
                  from OGLE RR Lyr \\field collection</meta>
        <mixin>ogle/aux#rrlyr_p</mixin>
      </table>

      <data id="import_gd_\class">
        <sources>data/gd/rrlyr/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:   1-19
            mean_I:     22-27
            mean_V:     29-34
            period:     37-46
            period_err: 48-57
            epoch:      60-69
            ampl_I:     72-76
          </colDefs>
        </columnGrammar>
        <make table="param_gd_\class">
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
      <table id="param_gd_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source \
                  with parameters of \subclass stars \
                  from OGLE RR Lyr \\field collection</meta>
        <mixin>ogle/aux#rrlyr_p</mixin>
      </table>

      <data id="import_gd_\class">
        <sources>data/gd/rrlyr/\source</sources>
        <columnGrammar>
          <colDefs>
            object_id:    1-19
            mean_I:      22-27
            mean_V:      29-34
            period1:     37-46
            period1_err: 48-57
            period:     105-114
            period_err: 116-125
            epoch:      128-137
            ampl_I:     140-144
          </colDefs>
        </columnGrammar>
        <make table="param_gd_\class">
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

  <table id="ident_gd_t2cep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identifications of \class_desc \field</meta>
    <mixin>ogle/aux#t2cep_id</mixin>
  </table>

  <data id="import_gd_t2cep">
    <sources>data/gd/t2cep/ident.dat</sources>
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
    <make table="ident_gd_t2cep">
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

  <table id="param_gd_t2cep" onDisk="True" adql="hidden">
    <meta name="description">The table from original t2cep.dat from OGLE Type II Cepheids \field collection</meta>
    <mixin>ogle/aux#t2cep_p</mixin>
  </table>

  <data id="import_param_gd_t2cep">
    <sources>data/gd/t2cep/t2cep.dat</sources>
    <columnGrammar>
      <colDefs>
        object_id:   1-18
        mean_I:     21-26
        mean_V:     28-33
        period:     36-45
        period_err: 47-55
        epoch:      58-69
        ampl_I:     72-76
      </colDefs>
    </columnGrammar>
    <make table="param_gd_t2cep">
      <rowmaker idmaps="*">
        <LOOP listItems="mean_I mean_V ampl_I period period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <map dest="epoch" nullExcs="TypeError">parseWithNull(@epoch, float, "-")-JD_MJD</map>
      </rowmaker>
    </make>
  </data>

</resource>
