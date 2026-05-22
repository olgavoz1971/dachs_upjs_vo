<?xml version="1.0" encoding="utf-8"?>
<resource schema="upjs_gaia_eb" resdir=".">
  <meta name="schema-rank">60</meta>
  <meta name="creationDate">2026-05-21T16:13:29Z</meta>

  <meta name="title">Morphological classification of eclipsing binaries from the Gaia</meta>
  <meta name="description">
    This resource provides the results of a morphological classification of 2,184,283 eclipsing binary candidates 
    from the Gaia DR3 catalogue. The systems are classified into detached and overcontact configurations, 
    followed by the identification of starspot signatures within both morphological classes.

    The classification was performed using a hierarchical computer-vision pipeline based on a fine-tuned ResNet-18 
    convolutional neural network trained on synthetic light curves generated with the ELISa code. 
    The phase-folded Gaia G-band light curves are represented as 3-channel 128×128 pixel images encoding 
    the flux distribution, its polar transformation, and the flux gradient.

    A tailored augmentation scheme calibrated to the Gaia cadence distribution was applied to reduce 
    the synthetic-to-real domain gap (in prep).
     
    Because the morphological classification is based on single-passband Gaia G photometry alone, overcontact and ellipsoidal 
    systems cannot be reliably distinguished. Therefore, systems with orbital periods P &gt; 3 d initially classified as overcontact 
    are explicitly reassigned as "ellipsoidal", since such long-period overcontact configurations are physically unlikely 
    for main-sequence stars.
  </meta>  
  
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>
  <meta name="subject">eclipsing-binary-stars</meta>
  <meta name="subject">semi-detached-binary-stars</meta>
  <meta name="subject">starspots</meta>
  <meta name="subject">stellar-classification</meta>

  <meta name="creator">Parimucha, Š., Gabdeev, M., Vaňko, M., Markus, Y., Vozyakova, O., GAIA Collaboration</meta>
  <meta name="instrument">Gaia</meta>

  <meta name="source">Parimucha, S. and all, in prep.</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">Optical</meta>
  <coverage>  
        <spatial>0/0-11</spatial>
        <spectral>1.986e-19 4.966e-19</spectral>
  </coverage>

  <STREAM id="all_columns">
    <column name="gaia_id"
      ucd="meta.id;meta.main"
      type="bigint"
      tablehead="Gaia DR3 ID"
      description="Gaia DR3 identifier"
      required="True"/>

    <column name="period" type="double precision"
      ucd="src.var;time.period"
      unit="d"
      tablehead="Period"
      description="Period of the variable star calcukated from Gaia DR3 frequency"
      required="True"/>

    <column name="teff"
      ucd="phys.temperature.effective"
      unit="K"
      tablehead="teff_gspphot"
      description="Effective temperature from Gaia DR3 GSP-Phot Aeneas best library using BP/RP spectra"
      required="False"/>

    <column name="main_class" type="text"
      ucd="meta.code.class"
      tablehead="Main class"
      description="detached, overcontact or Eellispsoidal"
      required="True"
      note="main_class_note"/>

    <column name="prob_detached" type="real"
      ucd="meta.code.class;stat.probability"
      tablehead="detached probability"
      description="Probability of classification as detached"
      required="True"
      note="prob_over"/>

    <column name="prob_overcontact" type="real"
      ucd="meta.code.class;stat.probability"
      tablehead="overcontact probability"
      description="Probability of classification as overcontact"
      required="True"
      note="prob_over"/>
       
    <column name="spot_class" type="text"
      ucd="meta.code.class"
      tablehead="Spot class"
      description="Presence of spots"
      required="True"/>

    <column name="prob_spot" type="real"
      ucd="meta.code.class;stat.probability"
      tablehead="spot probability"
      description="Probability of classification as spotted"
      required="True"
      note="prob_over"/>

    <meta name="main_class_note">
      We explicitly assign the main class "ellipsoidal" to all systems with period > 3 d
      that are classified as overcontact, because such systems are physically unlikely.
      Using a single-passband light curve alone, we cannot reliably distinguish between
      overcontact and ellipsoidal systems.
    </meta>

    <meta name="note" tag="prob_over">
      For systems explicitly reclassified as "ellipsoidal" based on long period and
      overcontact-like lightcurve shape, the value of prob_overcontact should be interpreted
      as the probability of an ellipsoidal classification.
    </meta>

  </STREAM>


<!--
  I gave up on an idea of ingestong all as is
  <table id="detached" onDisk="True" adql="hidden">

    <FEED source="all_columns">
      <PRUNE name="spot_class"/>
      <PRUNE name="prob_spot"/>
    </FEED>

  </table>

  <data id="import_detached">
    <sources pattern="data/detached.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="detached">
        <rowmaker idmaps="*">
          <var name="gaia_id">@star_id</var>
          <var name="main_class">@class_name</var>
        </rowmaker>
    </make>
  </data>

  <table id="overcontact" onDisk="True" adql="hidden">

    <FEED source="all_columns">
      <PRUNE name="spot_class"/>
      <PRUNE name="prob_spot"/>
    </FEED>

  </table>

  <data id="import_overcontact">
    <sources pattern="data/overcontact.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="overcontact">
        <rowmaker idmaps="*">
          <var name="gaia_id">@star_id</var>
          <var name="main_class">@class_name</var>
        </rowmaker>
    </make>
  </data>

  <table id="spot_detached" onDisk="True" adql="hidden">
    <FEED source="all_columns">
      <PRUNE name="main_class"/>
      <PRUNE name="prob_detached"/>
      <PRUNE name="prob_overcontact"/>
    </FEED>
  </table>

  <data id="import_spot_detached">
    <sources pattern="data/spot_classifications_detached.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="spot_detached">
        <rowmaker idmaps="*">
          <var name="gaia_id">@star_id</var>
          <var name="spot_class">@classification</var>
        </rowmaker>
    </make>
  </data>

  <table id="spot_overcontact" onDisk="True" adql="hidden">
    <FEED source="all_columns">
      <PRUNE name="main_class"/>
      <PRUNE name="prob_detached"/>
      <PRUNE name="prob_overcontact"/>
    </FEED>
  </table>

  <data id="import_spot_overcontact">
    <sources pattern="data/spot_classifications_over.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="spot_overcontact">
        <rowmaker idmaps="*">
          <var name="gaia_id">@star_id</var>
          <var name="spot_class">@classification</var>
        </rowmaker>
    </make>
  </data>

  <table id="classification_raw" onDisk="True" adql="True">
    <property name="forceStats">1</property>
    <meta name="table-rank">50</meta>
    <meta name="description">
      TBD
    </meta>
    
    <FEED source="all_columns"/>

    <index columns="gaia_id"/>
    <index columns="period"/>
  
    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM (
          SELECT md.*, sd.spot_class, sd.prob_spot
            FROM \schema.spot_detached AS sd
            JOIN \schema.detached AS md USING (gaia_id)
          UNION ALL
          SELECT mo.*, so.spot_class, so.prob_spot
            FROM \schema.spot_overcontact AS so
            JOIN \schema.overcontact AS mo USING (gaia_id)
        ) AS ww
      )
    </viewStatement>
  </table>

  <data id="create-main-view">
    <make table="classification"/>
  </data>
-->

  <table id="classification_raw" onDisk="True" primary="gaia_id" adql="hidden">
    <FEED source="all_columns"/>
  </table>

  <data id="import_classification_raw">
    <sources pattern="data/classification_all.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="classification_raw">
        <rowmaker idmaps="*"/>
    </make>
  </data>


  <table id="classification" onDisk="True" adql="True">
    <property name="forceStats">1</property>
    <meta name="table-rank">50</meta>
    <meta name="description">
      The table contains the results of morphological classification of eclipsing binaries and selected parameters 
      from Gaia DR3 (2023A&amp;A...674A...1G), including orbital periods, GSP-Phot effective temperatures, and sky coordinates.

      Because the morphological classification is based on single-passband Gaia G photometry alone, overcontact and ellipsoidal 
      systems cannot be reliably distinguished. Therefore, systems with orbital periods P &gt; 3 d initially classified as overcontact 
      are explicitly reassigned as "ellipsoidal", since such long-period overcontact configurations are physically unlikely 
      for main-sequence stars.
    </meta>
    
    <index columns="gaia_id"/>
    <index columns="period"/>
    <mixin>//scs#pgs-pos-index</mixin>
    <publish sets="ivo_managed,local"/>
 
    <stc>
      Position ICRS BARYCENTER Epoch J2016.0 "ra" "dec" Error "ra_error" "dec_error"
    </stc>

    <FEED source="all_columns"/>
    
    <column name="ra" type="double precision"
        ucd="pos.eq.ra;meta.main" unit="deg"
        tablehead="RA (ICRS)"
        description="Barycentric Right Ascension in ICRS at epoch J2016.0 from Gaia DR3"
        verbLevel="1">
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="dec" type="double precision"
        ucd="pos.eq.dec;meta.main" unit="deg"
        tablehead="Dec (ICRS)"
        description="Barycentric Declination in ICRS at epoch J2016.0 from Gaia DR3"
        verbLevel="1">
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="ra_error"
        ucd="stat.error;pos.eq.ra" unit="mas"
        tablehead="Err. RA"
        description="Standard error of ra (with cos δ applied) from Gaia DR3"/>

    <column name="dec_error"
        ucd="stat.error;pos.eq.dec" unit="mas"
        tablehead="Err. Dec"
        description="Standard error of dec from Gaia DR3" />

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM (
          SELECT c.*, ra, dec, ra_error, dec_error 
            FROM \schema.classification_raw AS c
            JOIN gaiadr3_eb.gaia_source_lite_eb g 
            ON g.source_id=c.gaia_id
        ) AS ww
      )
    </viewStatement>
  </table>

  <data id="create-classification-view">
    <recreateAfter>import_classification_raw</recreateAfter>
    <make table="classification"/>
  </data>


  <service id="upjs_eb_cone" allowed="form,scs.xml">
    <meta name="shortName">GDR3light SCS</meta>
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>
    <meta name="title">Gaia DR3 EB Cone Search</meta>
    <meta>
            testQuery.ra:  39.78593
            testQuery.dec:  4.83580
            testQuery.sr:  0.0001
    </meta>
    <scsCore queriedTable="classification">
      <FEED source="//scs#coreDescs"/>
      <LOOP listItems="gaia_id main_class spot_class">
        <events>
          <condDesc buildFrom="\item"/>
        </events>
      </LOOP>
    </scsCore>
  </service>


  <regSuite title="upjs_gaia_eb regression">
    <regTest title="upjs_gaia_eb table serves some data">
      <url parSet="TAP"
        QUERY="SELECT count(*) AS n FROM upjs_gaia_eb.classification"
        >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        print(row)
        self.assertEqual(row["n"], 1000)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
