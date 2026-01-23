<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <macDef name="referenceM54">2016AcA....66..197H</macDef>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">Original OGLE ident tables outside the main fields</meta>

  <FEED source="ogle/meta#field_table_desc" field="\field"/>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ==================== M54 stars  =========================================== -->

  <table id="m54" onDisk="True" adql="True" namePath="ogle/aux#object">
    <meta name="description">The (almost) original table M54variables.dat with identification and parameters of stars
                   from Sagittarius Dwarf Spheroidal Galaxy and its M54 Globular Cluster</meta>

    <!-- Pull whole set of columns directly from prototypes -->
    <FEED source="ogle/aux#object_ident_columns">
        <PRUNE name="subtype"/>
        <PRUNE name="ogle3_id"/>
        <PRUNE name="ogle2_id"/>
    </FEED>  
    <FEED source="ogle/aux#object_param_columns">
        <PRUNE id="object_id"/>"
    </FEED>
  </table>

  <!-- JK: there is an error in column format description in the README file; corrected -->
  <data id="import_m54">
    <sources>data/misc/m54/M54variables_cleaned.dat</sources>
    <columnGrammar topIgnoredLines="3">
      <colDefs>
        object_id:      1-4
        alphaHMS:      13-23
        deltaDMS:      26-36
        ogle4_id:      93-107
        period:       110-121
        period_err:   124-134
        ogle_vartype: 147-153
        mean_V:       155-160
        mean_I:       179-184
        ampl_I:       203-207
      </colDefs>
    </columnGrammar>
    <make table="m54">
      <rowmaker idmaps="*">
        <map dest="object_id">f'OGLE-M54-{@object_id}'</map>
        <map dest="ogle4_id">parseWithNull(@ogle4_id, str, "-")</map>
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>

        <LOOP listItems="mean_I mean_V ampl_I period period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>

        <!-- Try to bring ogle vartypes to the Simbad object types -->        
        <var name="ssa_targclass">@ogle_vartype</var>
        <apply name="m54_to_simbad_otype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"ssa_targclass"</bind>
          <bind key="mapping"> {
            "-" : "V*",
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
        <var name="ssa_collection">"OGLE-M54"</var>
        <var name="ssa_reference">"\referenceM54"</var>
      </rowmaker>
    </make>
  </data>
</resource>
