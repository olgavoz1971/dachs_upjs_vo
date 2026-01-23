<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2026-01-21T20:06:30Z</meta>

  <macDef name="field">in the Milky Way</macDef>
  <macDef name="prefix">OGLE-GAL</macDef>

<!-- Assign each collection its own ssa_reference --> 
  <macDef name="referenceDefault">2015AcA....65....1U</macDef>
  <macDef name="referenceACep">2018AcA....68..315U</macDef>

  <meta name="title">Original OGLE Variable Stars tables form the \field Collection.</meta>

  <FEED source="ogle/meta#field_table_desc" field="\field"/>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ================================= Anomalous Cepheids ============================== -->

  <table id="ident_gal_acep" onDisk="True" adql="hidden">
    <meta name="description">The original table with identification of \
                       Anomalous Cepheids \field collection</meta>
    <mixin>ogle/aux#acepheid_id</mixin>
  </table>

  <data id="import_gal_acep">
    <sources>data/gal/acep/ident.dat</sources>

    <columnGrammar>
      <colDefs>
        object_id:   1-17
        pulse_mode: 19-21
        alphaHMS:   24-34
        deltaDMS:   36-46
        ogle4_id:   49-64
        ogle3_id:   66-80
        ogle2_id:   82-96
        vsx:        98-150
      </colDefs>
    </columnGrammar>

    <make table="ident_gal_acep">
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
      <table id="param_gal_acep_\class" onDisk="True" adql="hidden">
        <meta name="description">The table from the base of original \source with parameters of \subclass \
                from OGLE Anomalous Cepheids \\field collection</meta>

        <mixin>ogle/aux#acepheid_p</mixin>
      </table>

      <data id="import_param_gal_\class">
        <sources>data/gal/acep/\source</sources>
        <columnGrammar>
          <colDefs>
              object_id:   1-17
              mean_I:     20-25
              mean_V:     27-32
              period:     35-44
              period_err: 46-54
              epoch:      57-68
              ampl_I:     71-75
          </colDefs>
        </columnGrammar>
        <make table="param_gal_acep_\class">
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
    </events>
  </LOOP>

</resource>
