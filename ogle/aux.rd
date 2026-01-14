<resource schema="ogle" resdir=".">
  <meta name="creationDate">2026-01-01T07:00:00Z</meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="title">Auxiliary things</meta>

  <table id="object" onDisk="False">
  <meta name="description">A stuff for motley OGLE tables to pull columns from</meta>

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
      description="VSX/GCVS/Macho or other designation"
      required="False">
    </column>

    <column name="ogle_vartype" type="text" ucd="meta.code.class"
      tablehead="Variability type" verbLevel="15"
      description="OGLE type of variable star"
      required="False">
    </column>

    <column name="subtype" type="text" ucd="meta.code.class"
      tablehead="Subtype of Variable Star" verbLevel="15"
      description="Subtype of Variable Star"
      required="False">
    </column>

    <column original="//ssap#instance.ssa_targclass"/>
    <column original="//ssap#instance.ssa_collection"/>
    <column original="//ssap#instance.ssa_reference"/>

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

    <column name="ampl_V" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Ampl V"
      description="V-band amplitude of the primary period"
      required="False"/>

    <column name="period" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period"
      description="Period of the variable star (primary/longest)"
      required="False"/>

    <column name="period_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period err"
      description="Uncertainty of period"
      required="False"/>

    <column name="epoch" type="double precision"
      ucd="src.var;time.epoch"
      unit="d"
      tablehead="Epoch"
      description="Time of maximum brightness; mjd (HJD)"
      required="False"/>
  </table>

  <macDef name="object_id_columns">
          object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx 
          ogle_vartype ssa_targclass ssa_collection ssa_reference  
  </macDef>

  <table id="acepheid_id" onDisk="False">							<!-- Anonalous Cepheid id -->
    <meta name="description">Columns relevant for the Anomalous Cepheid ident tables</meta>

    <LOOP listItems="\object_id_columns">
      <events>
        <column original="object.\item"/>
      </events>
    </LOOP>

    <column name="pulse_mode" type="text" ucd="meta.code.class"
      tablehead="Pulsation Mode" verbLevel="15"
      description="Cepheid Mode(s) of pulsation: F-fundamental, o1-first \
                   overtone, o2-second, etc"
      required="False">
    </column>
  </table>

  <table id="acepheid_p" onDisk="False" namePath="object">			<!-- Anomalous Cepheid param -->
    <meta name="description">Columns relevant for the Anomalous Cepheid parameters tables</meta>
    
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="cepheid_id" onDisk="False">								<!-- Cepheid id -->
    <meta name="description">Columns relevant for the Cepheid ident tables</meta>

    <LOOP listItems="\object_id_columns">
      <events>
        <column original="object.\item"/>
      </events>
    </LOOP>

    <column name="pulse_mode" type="text" ucd="meta.code.class"
      tablehead="Pulsation Mode" verbLevel="15"
      description="Cepheid Mode(s) of pulsation: F-fundamental, o1-first \
                   overtone, o2-second, etc"
      required="False">
    </column>
  </table>

  <table id="cepheid_p" onDisk="False" namePath="object">				<!-- Cepheid param -->
    <meta name="description">Columns relevant for the Cepheid parameters tables</meta>
    
    <LOOP listItems="object_id mean_I mean_V ampl_I period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="object.period" description="Period (longest)"/>

    <column name="period_short" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Shortest Period"
      description="The shortest period of the Cepheid"
      required="False"/>

    <column name="period_short_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period err"
      description="Uncertainty of the shortest period"
      required="False"/>

    <column name="period_med" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead=" Period"
      description="The medium period of the Cepheid"
      required="False"/>

    <column name="period_med_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period err"
      description="Uncertainty of the medium period"
      required="False"/>
  </table>

  <table id="dsct_id" onDisk="False" namePath="object">					<!-- d Sct id -->
    <meta name="description">Columns relevant for the Delta Sct ident  tables</meta>

    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <column original="subtype" description="singlemode, multimode"/>
  </table>

  <table id="dsct_p" onDisk="False" namePath="object">					<!-- d Sct param-->
    <meta name="description">Columns relevant for the Delta Sct object parameters tables</meta>
   
    <LOOP listItems="object_id mean_I mean_V ampl_I period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <column original="period" description="Primary period"/>
    <column name="period2" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Secondary Period"
      description="The secondary period"
      required="False"/>

    <column name="period2_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period2 err"
      description="Uncertainty of the secondary period"
      required="False"/>

    <column name="period3" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Tertiary Period"
      description="The tertiary period"
      required="False"/>

    <column name="period3_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period3 err"
      description="Uncertainty of the tertiary period"
      required="False"/>
  </table>

  <table id="ecl_id" onDisk="False" namePath="object">							<!-- Ecl ID-->
    <meta name="description">Columns relevant for the Eclipsing and Ellipsoidal Binary Systems ident tables</meta>
    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="subtype" tablehead="Subtype" description="C(contact), NC(non-contact), \
                                   CV(cataclysmic), ELL(ellipsoidal)"/>
  </table>

  <table id="ecl_p" onDisk="False" namePath="object">							<!-- Ecl param -->
    <meta name="description">Columns relevant for the Eclipsing and \
                                 Ellipsoidal Binary Systems parameters tables</meta>

    <column original="object_id"/>
    <column original="mean_I" tablehead="I at max" description="I-band magnitude at the maximum light"/>
    <column original="mean_V" tablehead="V at max" description="V-band magnitude at the maximum light"/>
    <column original="period" description="Orbital period"/>
    <column original="period_err"/>
    <column original="epoch" description="Epoch of of the primary eclipse, MJD"/>

    <column name="depth1" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Depth 1"
      description="Depth of the primary eclipse"
      required="False"/>

    <column name="depth2" type="double precision"
      ucd="phot.mag"
      unit="mag"
      tablehead="Depth 2"
      description="Depth of the secondary eclipse"
      required="False"/>
  </table>

  <table id="hb_id" onDisk="False" namePath="object">					<!-- HB ID -->
    <meta name="description">Columns relevant for the HB ident tables</meta>

    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="subtype" description="RG(system with red giant star) \
                     MS(system with a (post)main-sequence star)"/>

  </table>

  <table id="hb_p" onDisk="False" namePath="object">					<!-- HB param -->
    <meta name="description">Columns relevant for the HB object parameters tables</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="period" description="Orbital period"/>
    <column original="epoch" description="Epoch of the periastron passage"/>

    <column name="ecc" type="real"
      ucd="src.orbital.eccentricity"
      unit="deg"
      tablehead="Eccentricity"
      description="Orbital eccentricity"
      required="False"/>

    <column name="incl" type="real"
      ucd="src.orbital.inclination"
      unit="deg"
      tablehead="Inclination"
      description="Orbital inclination"
      required="False"/>

    <column name="omega" type="real"
      ucd="src.orbital.periastron"
      unit="deg"
      tablehead="Omega"
      description="Argument of periastron"
      required="False"/>

    <column name="add_var" type="text" 
      ucd="meta.code.class"
      tablehead="Additional variability" verbLevel="15"
      description="ECL(eclipses or spots), OSARG(Small Ampl RG oscillations),\
                   TEO(Tidally-excited oscillations), MISC(miscalloues)"
      required="False"/>
  </table>

  <table id="mira_id" onDisk="False" namePath="object">					<!-- LPV ID -->
    <meta name="description">Columns relevant for the Mira (LPV) ident tables</meta>

    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

  </table>

  <table id="mira_p" onDisk="False" namePath="object">					<!-- LPV param -->
    <meta name="description">Columns relevant for the Mira (LPV) object parameters tables</meta>
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="rot_id" onDisk="False" namePath="object">					<!-- ROT id -->
    <meta name="description">Columns relevant for the Rotating Variables ident  tables</meta>
    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="rot_p" onDisk="False" namePath="object">					<!-- ROT param-->
    <meta name="description">Columns relevant for the Rotating Variables parameters tables</meta>
   
    <LOOP listItems="object_id mean_I mean_V ampl_I ampl_V period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="rrlyr_id" onDisk="False" namePath="object">					<!-- RR Lyr id -->
    <meta name="description">Columns relevant for the RR Lyr ident  tables</meta>
    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="subtype"/>
  </table>

  <table id="rrlyr_p" onDisk="False" namePath="object">					<!-- RR Lyr param-->
    <meta name="description">Columns relevant for the RR Lyr parameters tables</meta>

    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="period" description="Fundamental mode period"/>
    <column name="period1" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="o1 period"
      description="First-overtone period"
      required="False"/>

    <column name="period1_err" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="o1 period_err"
      description="Uncertainty of the first-overtone period"
      required="False"/>

  </table>

  <table id="t2cep_id" onDisk="False" namePath="object">					<!-- t2cep id -->
    <meta name="description">Columns relevant for the Type II Cepheids ident  tables</meta>
    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="subtype"/>
  </table>

  <table id="t2cep_p" onDisk="False" namePath="object">					<!-- t2cep param-->
    <meta name="description">Columns relevant for the Type II Cepheids parameters tables</meta>
   
    <LOOP listItems="object_id mean_I mean_V ampl_I period period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="transit_id" onDisk="False" namePath="object">					<!-- transit id -->
    <meta name="description">Columns relevant for the candidates for transiting planets ident  tables</meta>
    <LOOP listItems="\object_id_columns">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="transit_p" onDisk="False" namePath="object">					<!-- transit param-->
    <meta name="description">Columns relevant for the candidates for transiting planets parameters tables</meta>
   
    <LOOP listItems="object_id mean_I mean_V ampl_I period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="period" description="Orbital period"/>
    <column original="epoch" description="Time of inferior conjunction (transit)"/>

    <column name="duration"
      type="real"
      ucd="time.duration"
      unit="d"
      tablehead="Duration"
      description="Duration of transit from 1st contact to 4th contact"
      required="False"/>

    <column name="depth"
      type="real"
      ucd="src.var.amplitude"
      tablehead="Depth"
      description="Transit depth"
      required="False"/>

    <column name="probability"
      type="real"
      ucd="stat.probability"
      tablehead="Probability"
      description="Probability(planet signal)"
      required="False"/>

    <column name="snr"
      type="real"
      ucd="stat.snr"
      tablehead="SNR"
      description="Signal-to-noise ratio"
      required="False"/>
  </table>

<!-- ============ lightcurve ================= -->
  <table id="lc" onDisk="False">
  <meta name="description">Reusable columns for the ligthcurve</meta>

    <column name="object_id" type="text" ucd="meta.id;meta.main"
      tablehead="Star ID" verbLevel="1" 
      description="Object identifier for this photometry point"
      required="True">
    </column>

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

    <column name="ogle_phase" type="integer"
      ucd="meta.id;meta.dataset"
      tablehead="Project Phase"
      description="OGLE project phase code (0–4): 2 = OGLE II, 3 = OGLE III, 
                   4 = OGLE IV; 0 = not specified"
      required="True"/>
  </table>

</resource>