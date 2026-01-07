<resource schema="ogle" resdir=".">
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
      description="VSX designation"
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

    <column name="vartype" type="text" ucd="meta.code.class"
      tablehead="Simbad type of Variable Star" verbLevel="15"
      description="Simbad type of variable star"
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
  </table>

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