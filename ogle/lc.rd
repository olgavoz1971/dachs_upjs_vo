<resource schema="ogle" resdir=".">
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">Combined lightcurve tables with all PP for all objects from OGLE
                     Variable Star Collection</meta>
  <meta name="description">
    The OGLE project consists of several sub-surveys that differ in sky coverage and in the types of variability targeted.
    Here, we build the big table contained all photometry points for all objects from the OGLE Collection of Variable 
    Star Light Curves.
    The data can be accessed via ADQL, but the main purpose of this table is to serve as a basis for the
    ssa_ts table and to provide input to the timeseries and preview instances in the DataLink service.
  </meta>

  <FEED source="ogle/meta#longdoc_ogle"/>
  <FEED source="ogle/meta#ogle_meta"/>

<!-- ########################## lightcurves ############################################## -->

<!-- Note: We _updating_ the lightcurve table, because it is quite large. 
     I have not found the way to check whether the importing collection was ingested already, so
     be careful not to double/triple data. Just play with the templates
-->

  <table id="lightcurves" onDisk="True" adql="True"  nrows="1700000000" 
      namePath="ogle/aux#lc">
    <meta name="description">The united table with photometry points of all OGLE Lightcurves</meta>
    <index columns="object_id, passband"/>
<!-- <index columns="object_id, passband" cluster=True>
    <index columns="object_id"/>
    <index columns="passband"/>
-->
    <index columns="obs_time"/>

    <LOOP listItems="object_id passband obs_time magnitude mag_err ogle_phase">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <data id="import_lightcurves" updating="True">

    <sources pattern="data/misc/BLAP/phot*/[VI]/*.dat"/>
    <!-- <sources pattern="data/misc/CV/phot*/[VI]/*.dat"/> -->

    <!-- <sources pattern="data/gal/*/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/misc/m54/phot*/[VI]/*.dat"/> -->

    <!-- <sources pattern="data/gd/*/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/smc/acep/phot*/[VI]/*.dat"/>
    <sources pattern="data/smc/cep/phot*/[VI]/*.dat"/>
    <sources pattern="data/smc/dsct/phot*/[VI]/*.dat"/>
    <sources pattern="data/smc/ecl/phot*/[VI]/*.dat"/>
    <sources pattern="data/smc/hb/phot_o*/[VI]/*.dat"/>
    <sources pattern="data/smc/rrlyr/phot*/[VI]/*.dat"/>
    <sources pattern="data/smc/t2cep/phot*/[VI]/*.dat"/> -->

    <!-- <sources pattern="data/lmc/acep/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/lmc/cep/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/lmc/dsct/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/lmc/ecl/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/lmc/hb/phot_o*/[VI]/*.dat"/>  -->
    <!-- <sources pattern="data/lmc/rrlyr/phot*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/lmc/t2cep/phot*/[VI]/*.dat"/> -->

    <!-- <sources pattern="data/blg/lpv/phot_ogle2/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/blg/rrlyr/phot/I/*.dat"/> -->
    <!-- sources pattern="data/blg/dsct/phot*/I/*.dat"/> -->
    <!-- <sources pattern="data/blg/hb/phot_o*/[VI]/*.dat"/> -->
    <!-- <sources pattern="data/blg/rot/phot*/I/*.dat"/> -->
    <!-- <sources pattern="data/blg/cep/phot*/V/*.dat"/> -->
    <!-- <sources pattern="data/blg/ecl/phot*/I/*.dat"/> -->
    <!-- <sources pattern="data/blg/transits/phot*/[VI]/*.dat"/> -->

    <csvGrammar delimiter=" " strip="True" names="dateobs_jd, magnitude, mag_err"/>

    <make table="lightcurves">
      <rowmaker idmaps="*">
        <!-- OGLE jds come with different "time zero-points" unfortunately -->
        <var name="to_mjd">
          2400000.5 if ("blg/cep" in \rootlessPath or "blg/rot" in \rootlessPath or \
                        "blg/t2cep" in \rootlessPath or "lmc/ecl" in \rootlessPath or \
                        "smc/ecl" in \rootlessPath or "gd/cep" in \rootlessPath
                        or "gd/t2cep" in \rootlessPath or "gal/acep" in \rootlessPath) else -49999.5
        </var>
        <var name="obs_time">float(@dateobs_jd)-@to_mjd</var>

        <apply name="restore_object_names">
          <code>
            abs_path = vars["parser_"].sourceToken
            name = \srcstem
            name = name[:-2] if name.endswith(("_V", "_I")) else name
            # collection = abs_path.split("/")[-4].upper()
            part1 = '' if abs_path.split("/")[-5].upper() == 'MISC' else abs_path.split("/")[-5].upper() + '-'
            part2 = abs_path.split("/")[-4].upper()
            collection = part1 + part2
            if not name.startswith("OGLE"):
              name = "OGLE-" + collection + "-" + name
            @object_id = name
          </code>
        </apply>
<!--        <map key="object_id">
          \srcstem[:-2] if \srcstem.endswith(("_V", "_I")) else \srcstem
        </map>
-->

        <!-- <map key="object_id">\srcstem</map> -->
        <map key="passband">\rootlessPath.split("/")[-2]</map>

        <!-- OGLE phase: phot -> 0, phot_ogle2 -> 2, etc. -->
        <map key="ogle_phase">
          0 if \rootlessPath.split("/")[-3] == "phot" \
          else int(\rootlessPath.split("/")[-3].replace("phot_ogle", ""))
        </map>
      </rowmaker>
    </make>
  </data>

<!-- ############################## web service ################################### -->

  <service id="lc-web" allowed="form">
    <meta name="title">OGLE lightcurves table</meta>
    <meta name="description">
      This form allows the selection of Lightcurve points for the entire OGLE Varibale Star Collection. Enjoy
    </meta>
    <meta name="shortName">Lightcurves form</meta>

    <publish render="form" sets="ivo_managed, local"/>

    <dbCore queriedTable="lightcurves">
      <condDesc buildFrom="object_id"/>
      <condDesc buildFrom="passband"/>
      <condDesc>
        <inputKey original="ogle_phase" required="False">
          <!-- 
           JK: I am an ass! Here, DaCHS performs SELECT DISTINCT ogle_phase from
           ... a huge table with ~2 billions rows without any index on this
           column!!!! This is performed during validation and at the beginning of the importing. 
           I really do not need to retrieve this list of phases [0,2,3,4] from db
          <values fromdb="ogle_phase from \schema.lightcurves"/> 
          -->
          <values>
            <option title="ogle">0</option>
            <option title="ogle2">2</option>
            <option title="ogle3">3</option>
            <option title="ogle4">4</option>
          </values>
        </inputKey>
      </condDesc>
    </dbCore>
  </service>

<!-- Check uniqueness of object_id in the Regression test 
     select object_id, count(*) AS n
       from ogle.objects_all
       group by object_id
       having count(*) > 1;
-->
  <regSuite title="ogle regression">
    <regTest title="ogle table serves some data">
      <url parSet="TAP"
        QUERY="SELECT object_id, count(*) AS n FROM ogle.objects_all group by object_id having count(*) > 1"
      >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        print('???????????????????????????')
        print()
        row = self.getFirstVOTableRow()
        print(row)
        # self.assertAlmostEqual(row["n"], 0)
        
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
