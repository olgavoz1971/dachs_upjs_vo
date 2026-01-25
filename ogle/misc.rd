<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <macDef name="referenceM54">2016AcA....66..197H</macDef>
  <macDef name="referenceCV">2015AcA....65..313M</macDef>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">Original OGLE ident tables outside the main fields</meta>

  <FEED source="ogle/meta#field_table_desc"/>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ==================== M54 stars  =========================================== -->

  <table id="m54" onDisk="True" adql="True">
    <meta name="description">The (almost) original table M54variables.dat with identification and parameters of stars
                   from Sagittarius Dwarf Spheroidal Galaxy and its M54 Globular Cluster</meta>

    <meta name="source">\referenceM54</meta>

    <!-- Pull whole set of columns directly from prototypes -->
    <FEED source="ogle/aux#object_ident_columns">
        <PRUNE name="subtype"/>
        <PRUNE name="ogle3_id"/>
        <PRUNE name="ogle2_id"/>
    </FEED>
    <FEED source="ogle/aux#object_param_columns">
        <PRUNE name="object_id"/>"
    </FEED>
  </table>

  <!-- JK: there is an error in column format description in the README file; corrected -->
  <data id="import_m54">
    <sources>data/misc/m54/M54variables_cleaned.dat</sources>
    <columnGrammar>
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

<!-- ==================== CV stars (Dwarf Nova candidates DN)  =========================================== -->

  <table id="cv_basic" onDisk="True" adql="hidden">
    <meta name="description">The original table CV/tab1.dat with basic parameters of dwarf nova candidates
            detected in the OGLE fields toward the Galactic bulge and the Magellanic System</meta>

    <!-- Pull whole set of columns directly from prototypes -->
    <FEED source="ogle/aux#object_ident_columns">
        <PRUNE name="subtype"/>
        <PRUNE name="ogle4_id"/>
        <PRUNE name="ogle3_id"/>
        <PRUNE name="ogle2_id"/>
        <PRUNE name="vsx"/>
    </FEED>  
    <FEED source="ogle/aux#object_param_columns">
        <PRUNE name="object_id"/>"
        <PRUNE name="mean_V"/>"
        <PRUNE name="mean_I"/>"
        <PRUNE name="period"/>"
        <PRUNE name="period_err"/>"
        <PRUNE name="epoch"/>"
    </FEED>

    <column name="peak_I" type="double precision"
        ucd="phot.mag"
        unit="mag"
        tablehead="Peack I"
        description="I-band peak magnitude"
        required="False"/>

    <column name="duration" type="real"
        ucd="src.var;time.duration"
        unit="d"
        tablehead="Outburst Duration"
        description="Mean outburst duration"
        required="False"/>

    <column name="frequency" type="double precision"
        ucd="src.var;time.period"
        unit="yr**-1"
        tablehead="Outburst frequency"
        description="Number of outbursts per year"
        required="False"/>    

  </table>

  <data id="import_cv">
    <sources>data/misc/CV/tab1.dat</sources>
    <!-- There is an error in the original README format decription -->
    <columnGrammar>
      <colDefs>
        object_id:      1-16
        alphaHMS:      18-28
        deltaDMS:      30-40
        peak_I:        91-96
        ampl_I:        98-102
        frequency:    104-109
        duration:     111-115
      </colDefs>
    </columnGrammar>
    <make table="cv_basic">
      <rowmaker idmaps="*">
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>

        <LOOP listItems="peak_I ampl_I frequency duration">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
        <var name="ogle_vartype">"CV"</var>  
        <var name="ssa_targclass">"CV*"</var>
        <var name="ssa_collection">"OGLE-CV"</var>
        <var name="ssa_reference">"\referenceCV"</var>
      </rowmaker>
    </make>
  </data>

  <table id="cv_periods" onDisk="True" adql="hidden">
    <meta name="description">The original table CV/orb_periods.dat with orbital periods 
            of dwarf nova candidates detected in the OGLE fields toward the Galactic 
            bulge and the Magellanic System</meta>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
        tablehead="Star ID" verbLevel="1" 
        description="Star identifier"
        required="True">
    </column>

    <column name="period" type="double precision">
        ucd="src.var;time.period"
        unit="d"
        tablehead="Orbital Period"
        description="Orbital period"
        required="False"
    </column>

    <column name="period_err" type="double precision">
        ucd="src.var;time.period"
        unit="d"
        tablehead="Period err"
        description="Uncertainty of period"
        required="False"
    </column>
  </table>

  <data id="import_cv_periods">
    <sources>data/misc/CV/orb_periods.dat</sources>
    <!-- There is an error in the original README format decription -->
    <!-- Remove empty lines on prefilter -->
    <columnGrammar commentIntroducer="#" preFilter="sed '/^$/d'">
      <colDefs>
        object_id:   1-16
        period:     18-27
        period_err: 29-38
      </colDefs>
    </columnGrammar>
    <make table="cv_periods">
      <rowmaker idmaps="*">
        <LOOP listItems="period period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
      </rowmaker>
    </make>
  </data>

  <table id="cv_sh_periods" onDisk="True" adql="hidden">
    <meta name="description">The original table CV/sh_periods.dat with superhump periods 
            of dwarf nova candidates detected in the OGLE fields toward the Galactic 
            bulge and the Magellanic System</meta>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
        tablehead="Star ID" verbLevel="1" 
        description="Star identifier"
        required="True">
    </column>

    <column name="sh_period" type="double precision">
        ucd="src.var;time.period"
        unit="d"
        tablehead="Superhump Period"
        description="Superhump period"
        required="False"
    </column>

    <column name="sh_period_err" type="double precision">
        ucd="src.var;time.period"
        unit="d"
        tablehead="SH Period err"
        description="Uncertainty of period"
        required="False"
    </column>
  </table>

  <data id="import_cv_sh_periods">
    <sources>data/misc/CV/sh_periods.dat</sources>
    <!-- There is an error in the original README format decription -->
    <columnGrammar commentIntroducer="#" preFilter="sed '/^$/d'">
      <colDefs>
        object_id:      1-16
        sh_period:     18-25
        sh_period_err: 27-34
      </colDefs>
    </columnGrammar>
    <make table="cv_sh_periods">
      <rowmaker idmaps="*">
        <LOOP listItems="sh_period sh_period_err">
          <events>
            <map dest="\item">parseWithNull(@\item, float, "-")</map>
          </events>
        </LOOP>
      </rowmaker>
    </make>
  </data>

<!-- ==================================== -->

</resource>
