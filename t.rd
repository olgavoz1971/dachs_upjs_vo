<resource schema="upjs" resdir=".">
  <meta name="creationDate">2025-11-25T12:38:44Z</meta>

  <meta name="title">%title -- not more than a line%</meta>
  <meta name="description">
    %this should be a paragraph or two (take care to mention salient terms)%
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">%keywords; repeat the element as needed%</meta>

  <meta name="creator">%authors in the format Last, F.I; Next, A.%</meta>
  <meta name="instrument">%telescope or detector or code used%</meta>
  <meta name="facility">%observatory/probe at which the data was taken%</meta>

  <meta name="source">%ideally, a bibcode%</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">%word from controlled vocabulary%</meta>

  <table id="lightcurves" onDisk="True" adql="True">
    <column name="id" type="bigint"
      ucd="meta.id;meta.main"
      tablehead="PP Id"
      description="Identifier for this photometry point"/>
  </table>

  <data id="import">
    <sources pattern="%resdir-relative pattern, like data/*.txt%"/>

    <!-- the grammar really depends on your input material.  See
      http://docs.g-vo.org/DaCHS/ref.html#grammars-available,
      in particular columnGrammar, csvGrammar, fitsTableGrammar,
      and reGrammar; if nothing else helps see embeddedGrammar
      or customGrammar -->
    <csvGrammar names="name1 some_other_name and_so_on"/>

    <make table="main">
      <rowmaker idmaps="*">
        <!-- the following is an example of a mapping rule that uses
        a python expression; @something takes the value of the something
        field returned by the grammar.  You obviously need to edit
        or remove this concrete rule. -->
        <map dest="%name of a column%">int(@some_other_name[2:])</map>
      </rowmaker>
    </make>
  </data>

  <service id="q" allowed="form">
    <!-- if you want a browser-based service in addition to TAP, use
    this.  Otherwise, delete this and just write <publish/> into
    the table element above to publish the table as such.  With a
    service, the table will be published as part of the service -->
    <meta name="shortName">%max. 16 characters%</meta>

    <!-- the browser interface goes to the VO and the front page -->
    <publish render="form" sets="ivo_managed, local"/>
    <!-- all publish elements only become active after you run
      dachs pub q -->

    <dbCore queriedTable="main">
      <!-- to add query constraints on table columns, add condDesc
      elements built from the column -->
      <condDesc buildFrom="%colname%"/>
    </dbCore>
  </service>

  <regSuite title="upjs regression">
    <regTest title="upjs table serves some data">
      <url parSet="TAP"
        QUERY="SELECT * FROM upjs.main WHERE %select one column%"
        >/tap/sync</url>
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
