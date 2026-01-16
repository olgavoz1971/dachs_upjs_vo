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

  <macDef name="object_common_cols">
    object_id, raj2000, dej2000, period, period_err, ampl_I, mean_I, mean_V, ssa_targclass,
    ogle_vartype, ssa_reference, ssa_collection
  </macDef>

<!-- ======================= All Anomalous Cepheids ============================= -->

  <macDef name="param_acepheid_common_cols">
    object_id, epoch, period, period_err, ampl_I, mean_I, mean_V
  </macDef>

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

    <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#acepheid_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#acepheid_id.\item"/>
       </events>
    </LOOP>
    <LOOP>			<!-- I duplicate there obs_id columns, but seems DaCHS handles this correctly -->
       <codeItems>
         for col in context.resolveId("ogle/aux#acepheid_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#acepheid_p.\item"/>
       </events>
    </LOOP>

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

    <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#cepheid_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#cepheid_id.\item"/>
       </events>
    </LOOP>
    <LOOP>			<!-- I duplicate there obs_id columns, but seems DaCHS handles this correctly -->
       <codeItems>
         for col in context.resolveId("ogle/aux#cepheid_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#cepheid_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

	<!-- JK: The order of UNIONs matters: we must first mention tables 
          where all columns are present (to define correct column types) -->
    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        WITH
        param_blg_cep_all AS ( 
            SELECT * FROM \schema.param_blg_cep_cepf
            UNION ALL
            SELECT * FROM \schema.param_blg_cep_cep1o
            UNION ALL
            SELECT * FROM \schema.param_blg_cep_cepf1o
            UNION ALL
            SELECT * FROM \schema.param_blg_cep_cep1o2o
            UNION ALL
            SELECT * FROM \schema.param_blg_cep_cep2o3o
            UNION ALL
            SELECT * FROM \schema.param_blg_cep_cep1o2o3o
        ),
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
        ),
        param_smc_cep_all AS (
            SELECT * FROM \schema.param_smc_cep_cepf
            UNION ALL
            SELECT * FROM \schema.param_smc_cep_cep1o
            UNION ALL
            SELECT * FROM \schema.param_smc_cep_cep2o
            UNION ALL
            SELECT * FROM \schema.param_smc_cep_cepf1o
            UNION ALL
            SELECT * FROM \schema.param_smc_cep_cep1o2o
            UNION ALL
            SELECT * FROM \schema.param_smc_cep_cep1o2o3o
        )
        SELECT \colNames FROM \schema.ident_blg_cep			-- blg cep
        LEFT JOIN param_blg_cep_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_cep			-- lmc cep
        LEFT JOIN param_lmc_cep_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_cep			-- smc cep
        LEFT JOIN param_smc_cep_all USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-cepheids-view">
    <make table="cepheids"/>
  </data>

<!-- ======================= All DSct ============================= -->

  <table id="dsct" adql="True" onDisk="True">

    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Delta Sct from the OGLE Variable Star Collection.\
      The table was constructed by merging all d Sct-related data from all OGLE fields, such as BLG, GD, LMC, and SMC.
    </meta>

    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_dsct LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_dsct LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_dsct LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#dsct_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#dsct_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#dsct_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#dsct_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_dsct						-- blg dsct
        LEFT JOIN \schema.param_blg_dsct USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_dsct						-- lmc dsct
        LEFT JOIN \schema.param_lmc_dsct USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_dsct						-- smc dsct
        LEFT JOIN \schema.param_smc_dsct USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-dsct-view">
    <make table="dsct"/>
  </data>

<!-- ======================= All Ecl/Ell binaries ============================= -->

  <table id="eclipsing" adql="True" onDisk="True">

    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Eclipsing and Ellipsoidal Binary Systems \
      from the OGLE Variable Star Collection. \
      The table was constructed by merging all EB-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_ecl LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_ecl LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_ecl LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>


    <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#ecl_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#ecl_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#ecl_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#ecl_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        WITH
        param_blg_all AS ( 
            SELECT * FROM \schema.param_blg_ecl
            UNION ALL
            SELECT * FROM \schema.param_blg_ell
        ),
        param_lmc_all AS (
            SELECT * FROM \schema.param_lmc_ecl
            UNION ALL
            SELECT * FROM \schema.param_lmc_ell
        ),
        param_smc_all AS (
            SELECT * FROM \schema.param_smc_ecl
            UNION ALL
            SELECT * FROM \schema.param_smc_ell
        )
        SELECT \colNames FROM \schema.ident_blg_ecl			-- blg ecl
        LEFT JOIN param_blg_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_ecl         -- lmc ecl
        LEFT JOIN param_lmc_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_ecl         -- smc ecl
        LEFT JOIN param_smc_all USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-ecl-view">
    <make table="eclipsing"/>
  </data>

<!-- ======================= HB (Heartbeat stars) ============================= -->

  <table id="heartbeat" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Heartbeat Variables \
      from the OGLE Variable Star Collection.\
      The table was constructed by merging all Hb-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_hb LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_hb LIMIT 1"))[0][0], 
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_hb LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

   <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#hb_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#hb_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#hb_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#hb_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_hb							-- blg hb
        LEFT JOIN \schema.param_blg_hb USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_hb                          -- lmc hb
        LEFT JOIN \schema.param_lmc_hb USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_hb                          -- smc hb
        LEFT JOIN \schema.param_smc_hb USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-hb-view">
    <make table="heartbeat"/>
  </data>

<!-- ======================= All LPV (Miras) ============================= -->

  <table id="miras" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Long Period Variables \
      (LPV, Miras) from the OGLE Variable Star Collection.\
      The table was constructed by merging all LPV-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_lpv LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <!-- Pull all columns from the prototype tables: -->
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#mira_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#mira_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#mira_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#mira_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_lpv							-- blg lpv
        LEFT JOIN \schema.param_blg_lpv USING (object_id)
																-- no lpv in lmc or smc
      )
    </viewStatement>
  </table>

  <data id="create-miras-view">
    <make table="miras"/>
  </data>

<!-- ======================= All Rot (rotating) ============================= -->

  <table id="rotating" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Rotating Variables \
      from the OGLE Variable Star Collection.\
      The table was constructed by merging all rotating variable-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_rot LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#rot_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#rot_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#rot_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#rot_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_rot			-- blg rot
        LEFT JOIN \schema.param_blg_rot USING (object_id)
															-- no rot in lmc or smc
      )
    </viewStatement>
  </table>

  <data id="create-rot-view">
    <make table="rotating"/>
  </data>

<!-- ======================= All RR Lyr ============================= -->

  <table id="rrlyr" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all RR Lyr Variables \
      from the OGLE Variable Star Collection.\
      The table was constructed by merging all RR Lyr-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <!-- Pull references -->
    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_rr LIMIT 1"))[0][0],
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_rr LIMIT 1"))[0][0],
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_rr LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#rrlyr_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#rrlyr_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#rrlyr_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#rrlyr_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        WITH
        param_blg_rr_all AS (
          SELECT * FROM \schema.param_blg_rr_ab
          UNION ALL
          SELECT * FROM \schema.param_blg_rr_c
          UNION ALL
          SELECT * FROM \schema.param_blg_rr_d
          UNION ALL
          SELECT * FROM \schema.param_blg_arr_d
        ),
        param_lmc_rr_all AS (
          SELECT * FROM \schema.param_lmc_rr_ab
          UNION ALL
          SELECT * FROM \schema.param_lmc_rr_c
          UNION ALL
          SELECT * FROM \schema.param_lmc_rr_d
          UNION ALL
          SELECT * FROM \schema.param_lmc_arr_d
        ),
        param_smc_rr_all AS (
          SELECT * FROM \schema.param_smc_rr_ab
          UNION ALL
          SELECT * FROM \schema.param_smc_rr_c
          UNION ALL
          SELECT * FROM \schema.param_smc_rr_d
          UNION ALL
          SELECT * FROM \schema.param_smc_arr_d
        )
        SELECT \colNames FROM \schema.ident_blg_rr					-- blg rrlyr
        LEFT JOIN param_blg_rr_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_rr					-- lmc rrlyr
        LEFT JOIN param_lmc_rr_all USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_rr					-- smc rrlyr
        LEFT JOIN param_smc_rr_all USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-rr-view">
    <make table="rrlyr"/>
  </data>

<!-- ======================= All t2cep ============================= -->

  <table id="t2cep" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of all Type II Cepheids \
      from the OGLE Variable Star Collection.\
      The table was constructed by merging all Type II Cepheids-related data from all OGLE fields, \
      such as BLG, GD, LMC, and SMC.
    </meta>

    <!-- Pull references -->
    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_t2cep LIMIT 1"))[0][0],
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_lmc_t2cep LIMIT 1"))[0][0],
                  list(conn.query("SELECT ssa_reference FROM ogle.ident_smc_t2cep LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#t2cep_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#t2cep_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#t2cep_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#t2cep_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_t2cep					-- blg t2cep
        LEFT JOIN \schema.param_blg_t2cep USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_lmc_t2cep                   -- lmc t2cep
        LEFT JOIN \schema.param_lmc_t2cep USING (object_id)
        UNION ALL
        SELECT \colNames FROM \schema.ident_smc_t2cep                   -- smc t2cep
        LEFT JOIN \schema.param_smc_t2cep USING (object_id)
      )
    </viewStatement>
  </table>

  <data id="create-t2cep-view">
    <make table="t2cep"/>
  </data>

<!-- ======================= All Transits ============================= -->

  <table id="transits" adql="True" onDisk="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
      Coordinates and variability parameters of candidates for transiting planets \
      from the OGLE Variable Star Collection.\
      The table was constructed by merging all transits-related data
    </meta>

    <!-- Pull references -->
    <LOOP>
      <codeItems>
        # Collect references from all involved tables
        with base.getTableConn() as conn:
          refs = [list(conn.query("SELECT ssa_reference FROM ogle.ident_blg_transit LIMIT 1"))[0][0]]
          # remove duplicates
          uniq_refs = list(dict.fromkeys(refs))
          yield {"db_source": "; ".join(uniq_refs)}
       </codeItems>
      <events>
        <meta name="source">\db_source</meta>
      </events>
    </LOOP>

    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#transit_id").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#transit_id.\item"/>
       </events>
    </LOOP>
    <LOOP>
       <codeItems>
         for col in context.resolveId("ogle/aux#transit_p").columns:
           yield {'item': col.name}
       </codeItems>
       <events>
         <column original="ogle/aux#transit_p.\item"/>
       </events>
    </LOOP>

    <index columns="object_id"/>
    <index columns="ssa_collection"/>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \colNames FROM \schema.ident_blg_transit					-- blg transit
        LEFT JOIN \schema.param_blg_transit USING (object_id)
					-- not transits in lmc or smc
      )
    </viewStatement>
  </table>

  <data id="create-transit-view">
    <make table="transits"/>
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

<!-- Supposed to be serviced by TAP and SCS -->
<!-- Check uniqueness of object_id in the Regression test 
     select object_id, count(*) AS n
       from ogle.objects_all
       group by object_id
       having count(*) > 1;
-->
  <macDef name="common_cols">
    object_id, raj2000, dej2000,
    vsx, ssa_targclass, ogle_vartype, ssa_reference, ssa_collection,
    mean_I, mean_V, period, period_err
  </macDef>

  <table id="objects_all" adql="True" onDisk="True"
         mixin="//scs#pgs-pos-index" namePath="ogle/aux#object">

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

    <LOOP listItems="object_id raj2000 dej2000
               mean_I mean_V ampl_I period period_err
               vsx ssa_targclass ogle_vartype subtype ssa_reference ssa_collection">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>

    <viewStatement>
      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT \common_cols, ampl_I, pulse_mode AS subtype					--acep
          FROM \schema.acepheids
        UNION ALL
        SELECT \common_cols, ampl_I, pulse_mode AS subtype					-- cep
          FROM \schema.cepheids
        UNION ALL
          SELECT \common_cols, ampl_I, subtype								-- dsct
          FROM \schema.dsct
        UNION ALL
          SELECT \common_cols, depth1 AS ampl_I, subtype					-- ecl
          FROM \schema.eclipsing
        UNION ALL
          SELECT \common_cols, ampl_I, subtype								-- hb
          FROM \schema.heartbeat
        UNION ALL
          SELECT \common_cols, ampl_I, NULL AS subtype						-- lpv
          FROM \schema.miras
        UNION ALL
          SELECT \common_cols, ampl_I, NULL AS subtype						-- rot 
          FROM \schema.rotating
        UNION ALL
          SELECT \common_cols, ampl_I, subtype								-- rrlyr
          FROM \schema.rrlyr
        UNION ALL
          SELECT \common_cols, ampl_I, subtype								-- t2cep
          FROM \schema.t2cep
        UNION ALL
          SELECT \common_cols, ampl_I, NULL AS subtype						-- blg transits
          FROM \schema.transits
        )
    </viewStatement>
  </table>

  <coverage>
    <updater sourceTable="objects_all"/>
  </coverage>

  <data id="create-objects_all-view">
    <make table="objects_all"/>
  </data>


<!--   Cone Search  -->
  <service id="ogle-objects" allowed="form,scs.xml">
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>

    <meta name="shortName">All OGLE Objects</meta>
    <meta name="title">OGLE objects Cone Search</meta>
    <meta name="description">
      \objects_description format="rst
    </meta>
    <meta name="_related" title="OGLE Varable Stars Time series"
            >\internallink{\rdId/ts-web/info}
    </meta>

    <meta>
      testQuery.ra: 263.562625
      testQuery.dec: -27.398250
      testQuery.sr:   0.0001
    </meta>

    <scsCore queriedTable="objects_all">
      <FEED source="//scs#coreDescs"/>
        <condDesc buildFrom="mean_I"/>
        <condDesc buildFrom="mean_V"/>
        <condDesc buildFrom="period"/>
        <condDesc buildFrom="vsx"/>
        <condDesc>
          <inputKey original="vsx">
            <values fromdb="vsx from \schema.objects_all"/>
          </inputKey>
        </condDesc>
    </scsCore>
  </service>

  <regSuite title="ogle objects regression">
    <regTest title="ogle SCS serves some data">
      <url RA="%ra that returns exactly one row%"
          DEC="%dec that returns exactly one row%" SR="0.001"
        >cone/scs.xml</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        print(row)
        self.assertAlmostEqual(row["ra"], 22.22222)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>

</resource>
