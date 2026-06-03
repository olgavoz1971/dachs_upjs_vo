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

  <meta name="creator">Parimucha, Š., Gabdeev, M., Vaňko, M., Markus, Y., Vozyakova, O.</meta>
  <meta name="creator">GAIA Collaboration</meta>
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
        <spectral>325[nm] 1000[nm]</spectral>
  </coverage>

  <STREAM id="all_columns">
    <column name="source_id"
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
      required="True"/>

    <meta name="note" tag="main_class_note">
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
  I gave up on an idea of ingesting all as is
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
          <var name="source_id">@star_id</var>
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
          <var name="source_id">@star_id</var>
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
          <var name="source_id">@star_id</var>
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
          <var name="source_id">@star_id</var>
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

    <index columns="source_id"/>
    <index columns="period"/>
  
    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM (
          SELECT md.*, sd.spot_class, sd.prob_spot
            FROM \schema.spot_detached AS sd
            JOIN \schema.detached AS md USING (source_id)
          UNION ALL
          SELECT mo.*, so.spot_class, so.prob_spot
            FROM \schema.spot_overcontact AS so
            JOIN \schema.overcontact AS mo USING (source_id)
        ) AS ww
      )
    </viewStatement>
  </table>

  <data id="create-main-view">
    <make table="classification"/>
  </data>
-->

  <table id="classification_raw" onDisk="True" primary="source_id" adql="hidden">
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
    <meta name="description" format="rst">
      The table contains the results of morphological classification of eclipsing binaries and selected parameters 
      from Gaia DR3 (:bibcode: `2023A&amp;A...674A...1G`), including orbital periods, GSP-Phot effective temperatures, and sky coordinates.

      Because the morphological classification is based on single-passband Gaia G photometry alone, overcontact and ellipsoidal 
      systems cannot be reliably distinguished. Therefore, systems with orbital periods P &gt; 3 d initially classified as overcontact 
      are explicitly reassigned as "ellipsoidal", since such long-period overcontact configurations are physically unlikely 
      for main-sequence stars.
    </meta>
    
    <index columns="source_id"/>
    <index columns="period"/>
    <index columns="main_class"/>
    <index columns="spot_class"/>
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
            USING (source_id)
        ) AS ww
      )
    </viewStatement>
  </table>

  <data id="create-classification-view">
    <recreateAfter>import_classification_raw</recreateAfter>
    <make table="classification"/>
  </data>


  <service id="upjs_eb_cone" allowed="form,scs.xml">
    <meta name="shortName">GDR3class SCS</meta>
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>
    <meta name="title">Gaia EB classification Cone Search</meta>
    <meta>
            testQuery.ra:  39.78593
            testQuery.dec:  4.83580
            testQuery.sr:  0.0001
    </meta>
    <scsCore queriedTable="classification">
      <FEED source="//scs#coreDescs"/>
      <LOOP listItems="source_id main_class spot_class">
        <events>
          <condDesc buildFrom="\item"/>
        </events>
      </LOOP>
    </scsCore>
  </service>

  <service id="ex" allowed="examples">
    <meta name="title">Gaia EB Classification TAP Examples</meta>
    <meta name="description">
      This service provides examples of server-side matching between the Gaia EB Classification and OGLE tables.
    </meta>

    <meta name="_example" title="Compare OGLE and UPJŠ EB classifications. Simple match">
        Match the `ogle.objects_all` table with `upjs_gaia_eb.classification` by coordinates and compare the types assigned
        to the common eclipsing binaries by both sources. Here we perform a simple coordinate match, ignoring proper motion.

        Why do we choose 0.5 arcsec? 
        Try increasing the matching radius, retrieve a larger sample, and plot a histogram of `sep` in TOPCAT. 
        The histogram shows a peak at small separations produced by genuine matches. 
        Beyond the peak, the contribution of true matches decreases, while the contribution of false matches increases with radius. 
        We see a local minimum around 0.5 arcsec and choose it as a reasonable compromise between copleteness and contamination.
        
        Note that we use the new unit conversion operator `@{arcsec}` on the distance function. 
        This not only automatically transforms degrees to arcseconds but also explicitly embeds the correct unit metadata 
        into the resulting table.

        .. tapquery::
          SELECT TOP 1000 object_id, main_class, spot_class, ogle_vartype, subtype, ssa_targclass,
            DISTANCE(o.raj2000, o.dej2000, g.ra, g.dec)@{arcsec} AS sep
          FROM ogle.objects_all o
          JOIN upjs_gaia_eb.classification g
            ON DISTANCE(o.raj2000, o.dej2000, g.ra, g.dec) &lt; 0.5/3600
    </meta>

    <meta name="_example" title="Compare OGLE and UPJŠ EB classifications. Match with sky position propagation">
        Match the `ogle.objects_all` table with `upjs_gaia_eb.classification` by coordinates, taking into account 
        the 16-year epoch difference between the Gaia DR3 and OGLE equatorial coordinates.

        Many TAP services provide coordinate propagation through the `ivo_epoch_prop_pos` UDF. However, here, 
        we should perform the propagation explicitly in the query.

        Note that matching large tables using calculated coordinates instead of indexed values is generally inefficient. 
        Therefore, we first apply a rough spatial pre-filter using indexed coordinates and only then perform the match 
        on the preselected subset.

        If you need the complete result set, remove `TOP 1000` and increase the MAXREC (MAX ROWS in TOPCAT) value. 
        The input Gaia table contain slightly more than two million rows.

        .. tapquery::
          SELECT TOP 1000
            res.object_id, res.main_class, res.spot_class, res.ogle_vartype, 
            res.subtype, res.ssa_targclass, res.sep_j2000
          FROM (
            SELECT 
              o.object_id, o.raj2000, o.dej2000, o.ogle_vartype, o.subtype,
              o.ssa_targclass, gc.main_class, gc.spot_class,
              gs.ra AS gaia_ra_2016, gs.dec AS gaia_dec_2016, gs.pmra, gs.pmdec,
              DISTANCE(		--  propagate Gaia positions to 2000.0
                o.raj2000, o.dej2000, 
                -- Mention there gc to force planner filter tables first:
                gc.ra + ((COALESCE(gs.pmra@{deg/yr}, 0.0)) * -16.0) / COS(gc.dec@{rad}),
                -- Use these additional brackets around COALESCE in the expression
                gc.dec + ((COALESCE(gs.pmdec@{deg/yr}, 0.0)) * -16.0)
              )@{arcsec} AS sep_j2000
            FROM ogle.objects_all AS o
            JOIN upjs_gaia_eb.classification AS gc
              ON 
                -- Rough spatial pre-filter using indexed J2016 coordinates
                DISTANCE(o.raj2000, o.dej2000, gc.ra, gc.dec) &lt; 10.0 / 3600.0
            JOIN gaiadr3_eb.gaia_source_lite_eb AS gs
              ON gc.source_id = gs.source_id
         ) AS res
          WHERE res.sep_j2000 &lt; 0.5
    </meta>

    <nullCore/>
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
        # print(row)
        self.assertEqual(row["n"], 2184283)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
