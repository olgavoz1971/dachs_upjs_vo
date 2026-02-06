<?xml version="1.0" encoding="utf-8"?>
<resource schema="ogle" resdir=".">
  <meta name="creationDate">2026-01-01T07:00:00Z</meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="title">Auxiliary things</meta>

  <STREAM id="object_ident_columns">
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
  </STREAM>

  <STREAM id="object_param_columns">
      <column name="object_id" type="text" ucd="meta.id;meta.main"
        tablehead="Star ID" verbLevel="1" 
        description="Star identifier"
        required="True">
      </column>

      <column name="mean_I" type="double precision"
        ucd="phot.mag"
        unit="mag"
        tablehead="Mean I"
        description="Intensity mean I-band magnitude"
        required="False"/>

      <column name="mean_V" type="double precision"
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
  </STREAM>

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

  <mixinDef id="acepheid_id">
    <doc>
        Columns relevant for the Anomalous Cepheid ident tables
    </doc>
    <events>
      <FEED source="object_ident_columns">
        <PRUNE name="subtype"/>
      </FEED>      
      <column name="pulse_mode" type="text" ucd="meta.code.class"
        tablehead="Pulsation Mode" verbLevel="15"
        description="Cepheid Mode(s) of pulsation: F-fundamental, 1O-first \
                     overtone"
        required="False">
      </column>
    </events>
  </mixinDef>

  <mixinDef id="acepheid_p">					<!-- Anomalous Cepheid param -->
    <doc>
      Columns relevant for the Anomalous Cepheid parameters tables
    </doc>
    <events>
      <FEED source="object_param_columns"/>
      <column name="period_short" type="double precision"
        ucd="src.var;time.period"
        unit="d"
        tablehead="Shortest Period"
        description="The shortest period of the A.Cepheid"
        required="False"/>

      <column name="period_short_err" type="double precision"
        ucd="src.var;time.period"
        unit="d"
        tablehead="Period err"
        description="Uncertainty of the shortest period"
        required="False"/>
    </events>
  </mixinDef>

  <mixinDef id="cepheid_id">
    <doc>
        Columns relevant for the Classical Cepheid ident tables
    </doc>
    <events>
      <FEED source="object_ident_columns">
        <PRUNE name="subtype"/>
      </FEED>

      <column name="pulse_mode" type="text" ucd="meta.code.class"
        tablehead="Pulsation Mode" verbLevel="15"
        description="Cepheid Mode(s) of pulsation: F-fundamental, o1-first \
                     overtone, o2-second, etc"
        required="False">
      </column>
    </events>
  </mixinDef>

  <mixinDef id="cepheid_p">							<!-- Cepheid param -->
    <doc>
        Columns relevant for the Classical Cepheid parameter tables
    </doc>
    <events>
      <FEED source="object_param_columns"/>

      <column original="period" description="Period (longest)"/>

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
    </events>
  </mixinDef>

  <mixinDef id="dsct_id">												<!-- d Sct id -->    
    <doc>"description">Columns relevant for the Delta Sct ident  tables</doc>
    <events>
      <FEED source="object_ident_columns"/>
      <column original="subtype" description="singlemode, multimode"/>
    </events>
  </mixinDef>

  <mixinDef id="dsct_p">												<!-- d Sct param-->
    <doc>"description">Columns relevant for the Delta Sct object parameters tables</doc>

    <events>   
      <FEED source="object_param_columns"/>
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
    </events>
  </mixinDef>

  <mixinDef id="ecl_id">													<!-- Ecl ID-->
    <doc>"description">Columns relevant for the Eclipsing and Ellipsoidal Binary Systems ident tables</doc>
    <events>
      <FEED source="object_ident_columns"/>
      <column original="subtype" tablehead="Subtype" description="C(contact), NC(non-contact), \
                                   CV(cataclysmic), ELL(ellipsoidal)"/>
    </events>  
  </mixinDef>

  <mixinDef id="ecl_p">													<!-- Ecl param -->
    <doc>"description">Columns relevant for the Eclipsing and \
                                 Ellipsoidal Binary Systems parameters tables</doc>
    <events>
      <FEED source="object_param_columns">
        <PRUNE name="ampl_I"/>
      </FEED>
      <column original="mean_I" tablehead="I at max" description="I-band magnitude at the maximum light"/>
      <column original="mean_V" tablehead="V at max" description="V-band magnitude at the maximum light"/>
      <column original="period" description="Orbital period"/>
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
    </events>
  </mixinDef>

  <mixinDef id="hb_id">												<!-- HB ID -->
    <doc>"description">Columns relevant for the HB ident tables</doc>
    <events>
      <FEED source="object_ident_columns"/>
      <column original="subtype" description="RG(system with red giant star) \
                     MS(system with a (post)main-sequence star)"/>

    </events>
  </mixinDef>

  <mixinDef id="hb_p">												<!-- HB param -->
    <doc>"description">Columns relevant for the HB object parameters tables</doc>
    <events>
      <FEED source="object_param_columns"/>
      <column original="period" description="Orbital period"/>
      <column original="epoch" description="Epoch of the periastron passage"/>

      <column name="ecc" type="double precision"
        ucd="src.orbital.eccentricity"
        unit="deg"
        tablehead="Eccentricity"
        description="Orbital eccentricity"
        required="False"/>

      <column name="incl" type="double precision"
        ucd="src.orbital.inclination"
        unit="deg"
        tablehead="Inclination"
        description="Orbital inclination"
        required="False"/>

      <column name="omega" type="double precision"
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
    </events>
  </mixinDef>

  <mixinDef id="mira_id">													<!-- LPV ID -->
    <doc>"description">Columns relevant for the Mira (LPV) ident tables</doc>
    <events>  
      <FEED source="object_ident_columns">
        <PRUNE name="subtype"/>
      </FEED>      

    </events>
  </mixinDef>

  <mixinDef id="mira_p">													<!-- LPV param -->
    <doc>"description">Columns relevant for the Mira (LPV) object parameters tables</doc>
    <events>
      <FEED source="object_param_columns">
        <PRUNE name="epoch"/>
      </FEED>
    </events>
  </mixinDef>

  <mixinDef id="rot_id">													<!-- ROT id -->
    <doc>"description">Columns relevant for the Rotating Variables ident  tables</doc>
    <events>
      <FEED source="object_ident_columns">
        <PRUNE name="subtype"/>
      </FEED>      
    </events>
  </mixinDef>

  <mixinDef id="rot_p">														<!-- ROT param-->
    <doc>"description">Columns relevant for the Rotating Variables parameters tables</doc>
    <events>
      <FEED source="object_param_columns">
        <PRUNE name="epoch"/>
      </FEED>
      <column name="ampl_V" type="double precision"
        ucd="phot.mag"
        unit="mag"
        tablehead="Ampl V"
        description="V-band amplitude of the primary period"
        required="False"/>
    </events>   
  </mixinDef>

  <mixinDef id="rrlyr_id">													<!-- RR Lyr id -->
    <doc>"description">Columns relevant for the RR Lyr ident  tables</doc>
    <events>
      <FEED source="object_ident_columns"/>
    </events>
  </mixinDef>

  <mixinDef id="rrlyr_p">													<!-- RR Lyr param-->
    <doc>"description">Columns relevant for the RR Lyr parameters tables</doc>
    <events>
      <FEED source="object_param_columns"/>
      <column original="ampl_I" description="I-band amplitude of the fundamental-mode period"/>
      <column original="period" description="Fundamental mode period"/>
      <column original="epoch" description="Time of maximum brightness (fundamental mode)"/>
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
    </events>
  </mixinDef>

  <mixinDef id="t2cep_id">												<!-- t2cep id -->
    <doc>"description">Columns relevant for the Type II Cepheids ident  tables</doc>
    <events>
      <FEED source="object_ident_columns"/>
    </events>
  </mixinDef>

  <mixinDef id="t2cep_p">												<!-- t2cep param -->
    <doc>"description">Columns relevant for the Type II Cepheids parameters tables</doc>
    <events>
      <FEED source="object_param_columns"/>   
    </events>
  </mixinDef>

  <mixinDef id="transit_id">											<!-- transit id -->
    <doc>"description">Columns relevant for the candidates for transiting planets ident  tables</doc>
    <events>
      <FEED source="object_ident_columns">
        <PRUNE name="subtype"/>
      </FEED>      
    </events>
  </mixinDef>

  <mixinDef id="transit_p">												<!-- transit param -->
    <doc>"description">Columns relevant for the candidates for transiting planets parameters tables</doc>
    <events>
      <FEED source="object_param_columns">
        <PRUNE name="ampl_I"/>
      </FEED>
      <column original="period" description="Orbital period"/>
      <column original="epoch" description="Time of inferior conjunction (transit)"/>

      <column name="duration"
        type="double precision"
        ucd="time.duration"
        unit="d"
        tablehead="Duration"
        description="Duration of transit from 1st contact to 4th contact"
        required="False"/>

      <column name="depth"
        type="double precision"
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
    </events>
  </mixinDef>

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