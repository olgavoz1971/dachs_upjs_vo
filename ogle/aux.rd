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

    <column original="//ssap#instance.ssa_targclass"/>
    <column original="//ssap#instance.ssa_collection"/>
    <column original="//ssap#instance.ssa_reference"/>

  </table>

  <table id="cepheid" onDisk="False" namePath="object">					<!-- Cepheid -->
    <meta name="description">Columns relevant for the Cepheid object tables</meta>
    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass ssa_collection ssa_reference
                     mean_I mean_V ampl_I period period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <column name="pulse_mode" type="text" ucd="meta.code.class"
      tablehead="Pulsation Mode" verbLevel="15"
      description="Cepheid Mode(s) of pulsation: F-fundamental, o1-first \
                   overtone, o2-second, etc"
      required="False">
    </column>
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
  </table>

  <table id="dsct" onDisk="False" namePath="object">					<!-- d Sct -->
    <meta name="description">Columns relevant for the Delta Sct object tables</meta>
    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass ssa_collection ssa_reference
                     mean_I mean_V ampl_I period period_err epoch">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <column original="subtype" description="singlemode, multimode"/>
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

  <table id="mira" onDisk="False" namePath="object">					<!-- LPV -->
    <meta name="description">Columns relevant for the Mira (LPV) object tables</meta>
    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass ssa_collection ssa_reference
                     mean_I mean_V ampl_I period period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <table id="ecl" onDisk="False" namePath="object">					<!-- Ecl -->
    <meta name="description">Columns relevant for the Eclipsing and Ellipsoidal Binary Systems tables</meta>
    <LOOP listItems="object_id raj2000 dej2000 ogle4_id ogle3_id ogle2_id vsx
                     ogle_vartype ssa_targclass subtype ssa_collection ssa_reference
                     period_err">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
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