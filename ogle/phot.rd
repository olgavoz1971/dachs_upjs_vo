<resource schema="ogle" resdir=".">
  <macDef name="referenceM54">2016AcA....66..197H</macDef>
  <meta name="schema-rank">500</meta>
  <meta name="creationDate">2025-12-21T20:06:30Z</meta>

  <meta name="title">OGLE photometric system description</meta>
  <meta name="subject">light-curves</meta>

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

</resource>
