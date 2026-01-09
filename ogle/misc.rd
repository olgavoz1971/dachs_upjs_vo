<resource schema="ogle" resdir=".">
  <macDef name="referenceM54">2016AcA....66..197H</macDef>
  <meta name="schema-rank">50</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">Original OGLE ident tables outside the main fields</meta>
  <meta name="description">
    The OGLE project consists of several sub-surveys that differ by sky coverage and by the type of variability targeted.
    The content and structure of tables containing observed object parameters vary between these sub-surveys.

    In this resource descriptor, the individual tables are ingested separately, one by one.
    In the q.rd file, these tables are combined into a common objects_all table implemented as a unified view.

  </meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  Poleski, R.; Pawlak, M.; 
                       Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.</meta>
  <meta name="instrument">1.0-1.3-meter telescopes. TBD</meta>
  <meta name="facility">OGLE TBD</meta>

  <meta name="source">2015AcA....65....1U</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->

  <meta name="coverage.waveband">Optical</meta>

  <meta name="copyright" format="rst">
    If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
      :bibcode: `2015AcA....65....1U`   (OGLE-IV photometry)
      :bibcode: `2008AcA....58...69U`   (OGLE-III photometry)
  </meta>

  <meta name="_longdoc" format="rst">
    TBD
  </meta>

<!-- ==============  photometric system ===================== -->

  <table id="photosys" onDisk="True" adql="Hidden">
    <meta name="description">The external table with photometric systems</meta>

    <column name="band_short" type="text"
      ucd="meta.id;instr.filter;meta.main"
      tablehead="Bandpass"
      description="Short bandpass name"
      required="True"/>

    <column name="band_human" type="text"
      ucd="meta.id;instr.filter"
      tablehead="Bandpass Human"
      description="Human readable bandpass name"
      required="True"/>

    <column name="band_ucd" type="text"
      ucd="meta.ucd"
      tablehead="Band ucd"
      description="UCD of the photometric band"
      required="True"/>

    <column name="specstart" type="real"
      ucd="em.wl"
      tablehead="specstart"
      description="Minimum wavelength of the band"
      required="True"/>

    <column name="specmid" type="real"
      ucd="em.wl.central"
      tablehead="specmid"
      description="Effective wavelength of the band"
      required="True"/>

    <column name="specend" type="real"
      ucd="em.wl"
      tablehead="specend"
      description="Maximum wavelength of the band"
      required="True"/>

    <column name="zero_point_flux" type="real"
      ucd="phot.flux"
      tablehead="Zero Point"
      description="Flux at the given zero point, in Jy;"
      required="False"/>

    <column name="description" type="text"
      ucd="meta.note"
      tablehead="Description"
      description="Photometric system description"
      required="False"/>
  </table>

 <data id="import_photosys">
    <make table="photosys">
      <script lang="python" type="postCreation" name="Load dump">
        table.connection.commit()
        src = table.tableDef.rd.getAbsPath("dumps/photosys.dump")
        with open(src) as f:
          cursor = table.connection.cursor()
          cursor.copy_expert(
            "COPY {} FROM STDIN".format(table.tableDef.getQName()),
            f)
      </script>
    </make>
  </data>

<!-- ==================== M54 stars  =========================================== -->

  <table id="m54" onDisk="True" adql="hidden" namePath="ogle/aux#object">
    <meta name="description">The (almost) original table M54variables.dat with identification and parameters of stars
                   from Sagittarius Dwarf Spheroidal Galaxy and its M54 Globular Cluster</meta>

    <LOOP listItems="object_id raj2000 dej2000 period period_err ogle_vartype vartype
                     mean_I mean_V ampl_I period period_err ssa_collection ssa_reference">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
  </table>

  <!-- JK: there is an error in column format description in the README file; corrected -->
  <data id="import_m54">
    <sources>data/misc/m54/M54variables_cleaned.dat</sources>
    <columnGrammar topIgnoredLines="3">
      <colDefs>
        object_id:   1-4
        alphaHMS:   13-23
        deltaDMS:   26-36
        period:     110-121
        period_err: 124-134
        ogle_vartype: 147-153
        mean_I:     179-184
        mean_V:     155-160
        ampl_I:     203-207
      </colDefs>
    </columnGrammar>
    <make table="m54">
      <rowmaker idmaps="*">
        <map dest="object_id">f'OGLE-M54-{@object_id}'</map>
        <var name="raj2000">hmsToDeg(@alphaHMS, ":")</var>
        <var name="dej2000">dmsToDeg(@deltaDMS, ":")</var>
        <map dest="mean_I">parseWithNull(@mean_I, float, "-")</map>
        <map dest="mean_V">parseWithNull(@mean_V, float, "-")</map>
        <map dest="ampl_I">parseWithNull(@ampl_I, float, "-")</map>
        <map dest="period">parseWithNull(@period, float, "-")</map>
        <map dest="period_err">parseWithNull(@period_err, float, "-")</map>

        <!-- Try to bring ogle vartypes to the Simbad codes -->        
        <var name="vartype">@ogle_vartype</var>
        <apply name="m54_to_simbad_vartype" procDef="//procs#dictMap">
          <bind key="default">base.NotGiven</bind>
          <bind key="key">"vartype"</bind>
          <bind key="mapping"> {
            "-" : None,
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
</resource>
