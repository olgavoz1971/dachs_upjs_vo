<resource schema="ogle" resdir=".">
  <meta name="creationDate">2025-12-21T16:24:52Z</meta>

  <meta name="title">OGLE Time series</meta>
  <meta name="description" format="rst">
    I promis, I[ll fill this properly befire publisjing any data from this
    collection
    this should be a paragraph or two (take care to mention salient terms)
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">surveys</meta>

  <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Szymański, G.;  Poleski, R.; Pawlak, M.; Pietrukowicz, P.; Wrona, M.; Iwanek, P.; Mróz, M.</meta>
  <meta name="instrument">TBD</meta>
  <meta name="facility">OGLE TBD</meta>

  <meta name="source">2015AcA....65....1U</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">Optical</meta>


  <meta name="ssap.dataSource">survey</meta>
  <meta name="ssap.creationType">archival</meta>
  <meta name="productType">timeseries</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden"
      namePath="//ssap#instance">
    <!-- the table with your custom metadata; it is transformed
      to something palatable for SSA and Obscore using the view below -->

    <!-- for an explanation of what columns will be defined in the
    final view, see http://docs.g-vo.org/DaCHS/ref.html#the-ssap-view-mixin.

    Don't mention anything constant here; fill it in in the view
    definition.
    -->
    <!-- metadata actually varies among data sets JK: ssa_collection? add ssa_pubDID(?) -->
    <LOOP listItems=ssa_dstitle ssa_targname ssa_length ssa_timeExt
			ssa_bandpass ssa_specmid ssa_collection">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="//obscore#ObsCore.t_min"/>
		<column original="//obscore#ObsCore.t_max"/>

    <mixin>//products#table</mixin>
    <!-- remove this if your data doesn't have (usable) positions -->
    <mixin>//ssap#plainlocation</mixin>
    <!-- remove this if you don't have plainlocation or there is no
      aperture -->
    <mixin>//ssap#simpleCoverage</mixin>
    <!-- the following adds a q3c index so obscore queries over s_ra
      and s_dec are fast; again, remove this if you don't have useful
      positions -->
    <FEED source="//scs#splitPosIndex"
      columns="ssa_location"
      long="degrees(long(ssa_location))"
      lat="degrees(lat(ssa_location))"/>

    <!-- the datalink column is mainly useful if you have a form-based
      service.  You can dump this (and the mapping rule filling it below)
      if you're not planning on web or don't care about giving them datalink
      access. -->
    <column name="datalink" type="text"
      ucd="meta.ref.url"
      tablehead="Datalink"
      description="A link to a datalink document for this spectrum."
      verbLevel="15" displayHint="type=url">

      <property name="targetType">application/x-votable+xml;content=datalink</property>
      <property name="targetTitle">Datalink</property>
    </column>

    <!--add further custom columns if necessary here -->
    <!-- custom columns -->
      <column name="p_star_id" type="text" ucd="meta.id;meta.main" tablehead="internal id"
        description="Object id in the original table"
        verbLevel="1"
        required="True"/>
    <!-- Add there necessary data from ident.dat? -->		
    
  </table>

  <!-- if you have data that is continually added to, consider using
    updating="True" and an ignorePattern here; see also howDoI.html,
    incremental updating.  -->
  <data id="import">
    <recreateAfter>make_view</recreateAfter>
    <property key="previewDir">previews</property>
    <sources recurse="True"
      pattern="%resdir-relative pattern, like data/*.fits%"/>

    <!-- It's quite likely that you will need to be creative with a
      custom row filter or even an embedded grammar to annotate your
      time series.  Sorry about that; we need a standard format for
      these things badly.  The important thing is the rowfilter
      munging single input files to datalinks.  If you have multiple
      time series per file, it's likely that you want to manipulate
      self.sourceToken in a rowfilter in front of products#define. -->
    <fitsProdGrammar qnd="True">
      <rowfilter procDef="//products#define">
        <bind key="table">"\schema.raw_data"</bind>
        <bind key="path">\fullDLURL{sdl}</bind>
        <!-- the next item should be estimated (the stuff will
          be generated on the fly).  Make it something like
          10000+20*number of data points or so. -->
        <bind key="fsize">%typical size of an SDM VOTable in bytes%</bind>
        <bind key="datalink">"\rdId#sdl"</bind>
        <bind key="mime">"application/x-votable+xml"</bind>
        <bind key="preview">\standardPreviewPath</bind>
        <bind key="preview_mime">"image/png"</bind>
      </rowfilter>
    </fitsProdGrammar>

    <make table="raw_data">
      <rowmaker idmaps="*">
        <!-- put vars here to pre-process FITS keys that you need to
          re-format in non-trivial ways. -->

        <apply procDef="//ssap#fill-plainlocation">
          <bind key="ra">%where to get the RA from%</bind>
          <bind key="dec">%where to get the Dec from%</bind>
          <bind key="aperture">%the aperture (a constant estimate may just do it)%</bind>
        </apply>

        <!-- the following maps assume the column list in the LOOP
          above.  If you changed things there, you'll have to adapt
          things here, too -->
        <map key="ssa_dateObs">dateTimeToMJD(parseTimestamp(@%key for dateObs%,
          "%Y-%m-%d %H:%M:%S"))</map>
        <map key="ssa_dstitle">"{} {}".format(%make a string halfway human-readable and halfway unique for each data set%)</map>
        <map key="ssa_targname">%which header to get the target name from%</map>
        <map key="ssa_specstart">%the min wavelength [m] in your passband</map>
        <map key="ssa_specend">%the max wavelength [m] in your passband%</map>
        <map key="ssa_length">%the number of points in the time series%</map>
        <map key="ssa_timeExt">%t_max-t_min at this point%</map>
        <map key="t_min">%earliest time stamp, mjd%</map>
        <map key="t_max">%latest time stamp, mjd%</map>

        <map key="datalink">\dlMetaURI{sdl}</map>

        <!-- add mappings for your own custom columns here. -->
      </rowmaker>
    </make>
  </data>


  <table id="data" onDisk="True" adql="True">
    <!-- the SSA table (on which the service is based) -->

    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <!-- again, the full list of things you can pass to the mixin
      is at http://docs.g-vo.org/DaCHS/ref.html#the-ssap-view-mixin.

      Things you already defined in raw_data are ignored here; you
      can also (almost always) leave them out altogether here.
      Defaulted attributes (the doc has "defaults to" for them) you
      can remove.

      The values for the ssa_ attributes below are SQL expressions – that
      is, you need to put strings in single quotes.
    -->
    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      ssa_aperture="1/3600."
      ssa_fluxunit="'%Flux unit in the spectrum instance. Use'' for uncalibrated data.%'"
      ssa_spectralunit="'%Unit used in the spectrum itself ('Angstrom' or so)%'"
      ssa_bandpass="'%something like Optical or K; don't sweat it%'"
      ssa_collection="'%a very terse designation for your dataset%'"
      ssa_fluxcalib="'%ABSOLUTE|CALIBRATED|RELATIVE|NORMALIZED|UNCALIBRATED%'"
      ssa_fluxucd="%'phot.mag', perhaps; consider adding band info%"
      ssa_spectralucd="'%em.wl;obs.atmos or similar for optical spectra%'"
      ssa_targclass="'%e.g., star; use Simbad object types%'"
    >//ssap#view</mixin>

		<mixin
		  calibLevel="%likely one of 1 for uncalibrated or 2 for calibrated data%"
		  coverage="%ssa_region -- or remove this if you have no ssa_region%"
		  oUCD="ssa_fluxucd"
		  >//obscore#publishSSAPMIXC</mixin>
  </table>

  <data id="make_view" auto="False">
    <make table="data"/>
  </data>

  <coverage>
    <updater sourceTable="data"/>
  </coverage>

  <!-- This is the table definition *for a single time series* as used
    by datalink.  If you have per-bin errors or whatever else, just
    add columns as above. -->
  <table id="instance" onDisk="False">
    <!-- we use a template for description here; it will be filled
      out by the datalink service below -->
 		<meta name="description">The \metaString{source} light curve
			for {ssa_targname} in the {ssa_bandpass} filter.</meta>
		<mixin
			effectiveWavelength="@ssa_specmid"
			filterIdentifier="@ssa_bandpass"
			magnitudeSystem="%Vega or AB, perhaps%"
			phot_description="%make it something like 'Gaia-calibrated magnitude'%"
			phot_ucd="%phot.mag?%"
			phot_unit="%mag%"
			refposition="%pick from http://ivoa.net/rdf/refposition%"
			refframe="%pick from http://ivoa.net/rdf/refframe%"
			time0="%JD of your time's zero point, 2400000.5 for MJD%"
			timescale="%pick from http://ivoa.net/rdf/timescale%"
			>//timeseries#phot-0</mixin>
		<param original="data.ssa_bandpass"/>
		<param original="data.ssa_specstart"/>
		<param original="data.ssa_specmid"/>
		<param original="data.ssa_specend"/>
		<param original="data.ssa_location"/>
		<!-- %add columns for other dependent values (errors and the like) -->
	</table>

	<data id="build-ts" auto="False">
		<!-- The source token is the datalink descriptor from the sdl
			datalink service, which also has the metadata in ssa_row.
			This is what our pargetter returns.  If you have sane source
			material, you don't need that and you can in principle use
			proper grammars, too. -->
		<embeddedGrammar>
			<iterator>
				<code>
				  # Example: three-column lines (you could use an reGrammar
				  # here, but we need a custom pargetter)
					with open(self.sourceToken.src_name) as f:
						for ln in f:
							parts = ln.split()
							yield {
								'obs_time': float(parts[0]),
								'phot': float(parts[1]),
								'err_phot': float(parts[2]),}
				</code>
			</iterator>
			<pargetter>
				<code>
					return self.sourceToken.ssa_row
				</code>
			</pargetter>
		</embeddedGrammar>

		<make table="instance">
			<rowmaker idmaps="*" id="make-ts"/>
			<!-- you need explicit idmaps rather than * here because
			  #phot-0 has "hidden" params that you don't want to fill -->
			<parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specstart,
				ssa_specend, ssa_location, ssa_specmid">
			</parmaker>
		</make>
	</data>

  <!-- the datalink service spitting out quasi-standard time series -->
	<service id="sdl" allowed="dlget,dlmeta">
		<meta name="title">\schema Datalink Service</meta>
		<datalinkCore>
			<descriptorGenerator>
				<code>
					descriptor = ProductDescriptor.fromAccref(
						pubDID, pubDID.split("?")[-1])
					with base.getTableConn() as conn:
						descriptor.ssa_row = next(conn.queryToDicts(
							"SELECT * FROM \schema.data"
							" WHERE ssa_pubdid=%(pubDID)s",
							{"pubDID": pubDID}))
					return descriptor
				</code>
			</descriptorGenerator>
			<dataFunction>
				<setup imports="gavo.rsc"/>
				<code>
					descriptor.data = rsc.makeData(
						rd.getById("build-ts"),
						forceSource=descriptor)

          # sample code for how to change various pieces of metadata of
          # the generated table.  The tableDef you see is a copy,
          # so edit with impunity.
					tab = descriptor.data.getPrimaryTable()
					tab.setMeta("description",
						base.getMetaText(tab, "description").format(**descriptor.ssa_row))

					mag_ucd = "phot.mag;em.opt.V"
					if descriptor.ssa_row["ssa_bandpass"]=="Bessell R":
						mag_ucd = "phot.mag;em.opt.R"
					tab.tableDef.getColumnByName("phot").ucd = mag_ucd
					tab.tableDef.getColumnByName("err_phot").ucd = "stat.error;"+mag_ucd
				</code>
			</dataFunction>

			<dataFormatter>
				<setup imports="gavo.formats.votablewrite"/>
				<code>
					return ("application/x-votable+xml;version=1.5",
						votablewrite.getAsVOTable(descriptor.data, version=(1,5)))
				</code>
			</dataFormatter>
		</datalinkCore>
	</service>


  <!-- a form-based service – this is made totally separate from the
  SSA part because grinding down SSA to something human-consumable and
  still working as SSA is non-trivial -->
  <service id="web" defaultRenderer="form">
    <meta name="shortName">\schema Web</meta>

    <dbCore queriedTable="data">
      <condDesc buildFrom="ssa_location"/>
      <condDesc buildFrom="t_max"/>
      <!-- add further condDescs in this pattern; if you have useful target
      names, you'll probably want to index them and say:

      <condDesc>
        <inputKey original="data.ssa_targname" tablehead="Target Object">
          <values fromdb="ssa_targname from \schema.data
            order by ssa_targname"/>
        </inputKey>
      </condDesc> -->
    </dbCore>

    <outputTable>
      <autoCols>accref, ssa_targname, t_min, t_max, ssa_bandpass,
        datalink</autoCols>
      <FEED source="//ssap#atomicCoords"/>
    </outputTable>
  </service>

  <service id="ssa" allowed="form,ssap.xml">
    <meta name="shortName">\schema SSAP</meta>
    <meta name="ssap.complianceLevel">full</meta>

    <publish render="ssap.xml" sets="ivo_managed"/>
    <publish render="form" sets="ivo_managed,local" service="web"/>

    <ssapCore queriedTable="data">
      <property key="previews">auto%delete this line if you have no previews; else delete just this.%</property>
      <FEED source="//ssap#hcd_condDescs"/>
    </ssapCore>
  </service>

  <regSuite title="ogle regression">
    <!-- see http://docs.g-vo.org/DaCHS/ref.html#regression-testing
      for more info on these. -->

    <regTest title="ogle SSAP serves some data">
      <url REQUEST="queryData" PUBDID="%a value you have in ssa_pubDID%"
        >ssa/ssap.xml</url>
      <code>
        <!-- to figure out some good strings to use here, run
          dachs test -k SSAP -D tmp.xml q
          and look at tmp.xml -->
        self.assertHasStrings(
          "%some characteristic string returned by the query%",
          "%another characteristic string returned by the query%")
      </code>
    </regTest>

    <regTest title="ogle Datalink metadata looks about right.">
      <url ID="%a value you have in ssa_pubDID%"
        >sdl/dlmeta</url>
      <code>
        <!-- to figure out good items to test here, you probably want to
          dachs test -k datalink  q
          and pprint the by_sem dict -->
          by_sem = self.datalinkBySemantics()
          print(by_sem)
          self.fail("Fill this in")
      </code>
    </regTest>

    <regTest title="ogle delivers some data.">
      <url ID="%a value you have in ssa_pubDID%"
        >sdl/dlget</url>
      <code>
        <!-- to figure out some good strings to use here, run
          dachs test -k "delivers data" -D tmp.xml q
          and look at tmp.xml -->
        self.assertHasStrings(
          "%some characteristic string in the datalink meta%")
      </code>
    </regTest>

    <!-- add more tests: form-based service renders custom widgets, etc. -->
  </regSuite>
</resource>
