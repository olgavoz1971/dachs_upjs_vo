<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2026-01-11T16:12:00Z</meta>

  <meta name="title">OGLE Variable Star Parameters</meta>
  <meta name="description" format="rst">
    The set of tables with variable star parameters from the OGLE Variable Stars
    Collection. The data are organised into separate tables by variable star class, 
    with corresponding names such as Classical Cepheids, Eclipsing Binaries, etc.
    The OGLE team provides different sets of parameters depending on the variability class, 
    which allows variability-class–specific queries.

    The objects_all table holds the basic parameters of all objects. 
    It serves as a base for the ts_ssa table (and the OGLE-related part of 
    the ObsCore table), which provide the main access points for light curves.
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  
    Poleski, R.; Pawlak, M.; Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.
  </meta>
  <meta name="instrument">TBD</meta>
  <meta name="facility">OGLE TBD</meta>

  <meta name="source">2015AcA....65....1U</meta>

  <meta name="copyright" format="rst">
    If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
      :bibcode: `2015AcA....65....1U`  (OGLE-IV photometry)
      :bibcode: `2008AcA....58...69U`  (OGLE-III photometry)
  </meta>

  <meta name="contentLevel">Research</meta>
  <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->
  <meta name="coverage.waveband">Optical</meta>

<!-- ======================= All Anomalous Cepheids ============================= -->

  <table id="acepheids" adql="True" onDisk="True">

    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Anomalous Cepheids from the OGLE Variable Star Collection.
      The table was constructed by merging all A.Cepheid-related data from all OGLE fields, such as GD, LMC, and SMC.
    </meta>

    <!-- Unfortunately, I've failed to wrap this into something reusable, so I put up with vulgar copypasting ;-( -->
    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs=[list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_acep LIMIT 1"))[0][0], 
                list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_acep LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <!-- Pull all columns related to acepheid: -->
    <mixin>ogle/aux#acepheid_id</mixin>
    <mixin>ogle/aux#acepheid_p</mixin>	<!-- I duplicate there obs_id columns, but seems DaCHS handles this correctly -->
    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        WITH
        param_acep_lmc_all AS ( 
            SELECT * FROM \schema.param_lmc_acep_acepf
            UNION ALL
            SELECT * FROM \schema.param_lmc_acep_acep1o
        ),
        param_acep_smc_all AS (
            SELECT * FROM \schema.param_smc_acep_acepf
            UNION ALL
            SELECT * FROM \schema.param_smc_acep_acep1o
        )

        SELECT \colNames FROM \schema.ident_lmc_acep      -- lmc acep
        LEFT JOIN param_acep_lmc_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_acep      -- smc acep
        LEFT JOIN param_acep_smc_all USING (object_id)
        												-- no acep in blg
      )
    </viewStatement>
  </table>

  <data id="create-acepheids-view">
    <make table="acepheids"/>
  </data>

<!-- ======================= All Classical Cepheids ============================= -->

  <macDef name="param_cepheid_common_cols">
    object_id, epoch, period, period_err, ampl_I, mean_I, mean_V
  </macDef>

  <table id="cepheids" adql="True" onDisk="True">

    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Classical Cepheids from the OGLE Variable Star Collection.
      The table was constructed by merging all Cepheid-related data from all OGLE fields, such as BLG, GD, LMC, and SMC.
    </meta>

    <!--
    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_cep LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_cep LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_cep LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>
    -->

    <!-- Pull all columns from the prototype tables: -->
    <mixin>ogle/aux#cepheid_id</mixin>
    <mixin>ogle/aux#cepheid_p</mixin>	<!-- I duplicate there obs_id columns, but seems DaCHS handles this correctly -->

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

	<!-- JK: The order of UNIONs matters: we must first mention tables 
          where all columns are present (to define correct column types) -->
    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        WITH
        param_lmc_cep_all AS (
            SELECT * FROM \schema.param_lmc_cep_cepf
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep1o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep2o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cepf1o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep1o2o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep1o3o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep2o3o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cepF1o2o
            UNION ALL
            SELECT * FROM \schema.param_lmc_cep_cep1o2o3o
        )
        SELECT \colNames FROM \schema.ident_lmc_cep			-- lmc cep
        LEFT JOIN param_lmc_cep_all USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-cepheids-view">
    <make table="cepheids"/>
  </data>

<!-- ======================= United Objects View ============================= -->

  <macDef name="objects_description">
    This table is a unified catalogue of objects from the OGLE Collection of Variable Star Light Curves.
    It was constructed by merging variable-type–specific ident.dat tables with selected columns 
    from tables containing parameters: cep.dat, cepF.dat, cep1O.dat, cepF1O.dat, cep1O2O.dat, cep1O2O3O.dat, 
    cep2O3O.dat, Miras.dat, and others.

    The corresponding light curves can be discovered via TAP through the ts_ssa or obscore tables, 
    or through the SSA service. Light curves can be extracted using the associated DataLink services.
  </macDef>

  <macDef name="common_cols">
    object_id, raj2000, dej2000,
    vsx, ssa_targclass, ogle_vartype, ssa_reference, ssa_collection,
    mean_I, mean_V, period, period_err, epoch
  </macDef>

  <table id="objects_all" adql="True" onDisk="True"
         mixin="//scs#pgs-pos-index">

    <meta name="table-rank">100</meta>

    <meta name="description">
      \objects_description format="rst
     </meta>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <!-- <primary>object_id</primary> -->
    <stc>
      Position ICRS "raj2000" "dej2000"
    </stc>

    <FEED source="ogle/aux#object_ident_columns">
      <PRUNE name="ogle4_id"/>
      <PRUNE name="ogle3_id"/>
      <PRUNE name="ogle2_id"/>
    </FEED>
    <FEED source="ogle/aux#object_param_columns">
      <PRUNE name="ampl_V"/>
    </FEED>
      
    <!--
    <mixin>ogle/aux#object_ident</mixin>
    <mixin>ogle/aux#object_param</mixin>
    -->

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \common_cols, ampl_I, pulse_mode AS subtype					--acep
          FROM \schema.acepheids
        UNION ALL
        SELECT \common_cols, ampl_I, pulse_mode AS subtype					-- cep
          FROM \schema.cepheids
        )
    </viewStatement>
  </table>

  <coverage>
    <updater sourceTable="objects_all"/>
  </coverage>

  <data id="create-objects_all-view">
    <make table="objects_all"/>
  </data>


</resource>
