<?xml version="1.0" encoding="utf-8"?>

<resource schema="upjs_img" resdir=".">
  <meta name="schema-rank">150</meta>
  <meta name="creationDate">2025-11-24T08:21:08Z</meta>

  <meta name="title">Images From Kolonica Observatory</meta>
  <meta name="description" format="rst">
    The images in this collection were acquired to monitor selected sky fields around 
    eclipsing binary stars at the Kolonica Observatory, Slovakia. 

    The Kolonica Observatory is located on the Kolonica Saddle and is operated by the Vihorlat
    Observatory in Humenné. It lies in the northeastern part of Slovakia, within the Poloniny Dark-Sky Park, 
    a location with the darkest night skies in Slovakia and among the darkest in Europe.

    Two small telescopes were used to obtain the images in this collection.
    The first telescope, named ZIGA (PlaneWave CDK20 — Corrected Dall–Kirkham), has a 508 mm aperture
    and is equipped with a Moravian Instruments G4-16000 CCD camera and UBVRI Bessell photometric filters.
    The second telescope, named Alica (Explore Scientific MN-152 — Maksutov–Newton), has a 152 mm aperture
    and is equipped with a Moravian Instruments G2-8300 CCD camera and g′ r′ i′ Sloan photometric filters.
    Both telescopes are currently in operation, and the archive is expected to be updated with new data.

    We publish the photometric time series derived from these images in the upjs_ts collection.
  </meta>

  <meta name="subject">observational-astronomy</meta>

  <meta name="creator">UPJŠ</meta>
  <meta name="instrument">Ziga and Alica telescopes</meta>
  <meta name="facility">Kolonica</meta>

  <meta name="source">Parimucha, S., in prep.</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Archive</meta>

  <meta name="coverage.waveband">Optical</meta>

  <table id="main" onDisk="True" adql="True">
    <meta name="_associatedDatalinkService">
      <meta name="serviceId">dl</meta>
      <meta name="idColumn">obs_publisher_did</meta>
    </meta>

    <mixin have_bandpass_id="True">//siap2#pgs</mixin>
    <mixin preview="NULL">//obscore#publishObscoreLike</mixin>
  </table>

  <coverage>
    <updater sourceTable="main"/>
  </coverage>

  <data id="import" updating="True">

    <sources recurse="True">
       <pattern>data/*/*.fit</pattern>
       <pattern>data/*/*.fit.fz</pattern>
       <ignoreSources fromdb="select access_url from \schema.main"/>
    </sources>

    <fitsProdGrammar qnd='False'>
      <rowfilter procDef="//products#define">
        <bind key="table">"\schema.main"</bind>
      </rowfilter>

      <rowfilter>
        <code>
          if "CRVAL1" in row:
            yield row
        </code>
      </rowfilter>
    </fitsProdGrammar>

    <make table="main">
      <rowmaker>
        <apply procDef="//siap2#computePGS"/>

        <apply procDef="//procs#dictMap">
          <bind key="key">"FILTER"</bind>
          <bind key="mapping">{
          "U": "Bessell U",
          "B": "Bessell B",
          "V": "Bessell V",
          "R": "Bessell R",
          "I": "Bessell I",
          "u_sdss": "SDSS u'",
          "g": "SDSS g'",
          "r": "SDSS r'",
          "i": "SDSS i'",
          "z": "SDSS z'",}</bind>
        </apply>

        <apply procDef="//siap2#setMeta">
          <bind name="bandpassId">@FILTER</bind>
          <bind key="dateObs">@DATE_OBS</bind>
          <bind key="dataproduct_type">"image"</bind>
          <bind key="dataproduct_subtype">None</bind>
          <bind key="calib_level">2</bind>
          <bind key="obs_collection">"Kolonica Variable Stars"</bind>
          <bind key="obs_id">None</bind>

          <!-- titles are what users usually see in a selection, so
            try to combine band, dateObs, object..., like
             -->
          <bind key="obs_title">"{} Varstar {} {}".format(
            @TELESCOP, @DATE_OBS, @FILTER)</bind>
          <bind key="obs_publisher_did">\standardPubDID</bind>
          <bind key="obs_creator_did">None</bind>
          <bind key="target_name">@OBJECT</bind>
          <bind key="target_class">"Star"</bind>

          <bind key="t_exptime">@EXPTIME</bind>
          <bind key="t_resolution">None</bind>

          <bind key="em_res_power">None</bind>
          <bind key="em_ucd">None</bind>
          <bind key="o_ucd">"phot.count"</bind>
          <bind key="pol_states">None</bind>
          <bind key="facility_name"
            >base.getMetaText(targetTable, "facility", default=None)</bind>
          <bind key="instrument_name"
            >base.getMetaText(targetTable, "instrument", default=None)</bind>

          <bind key="t_xel">1</bind>
          <bind key="em_xel">1</bind>
          <bind key="pol_xel">None</bind>
        </apply>

        <apply procDef="//siap2#getBandFromFilter"/>

      </rowmaker>
    </make>
  </data>

  <service id="dl" allowed="dlget,dlmeta">
    <meta name="title">Kolonica Images Datalink</meta>
    <meta name="description">In addition to common image cut-out operations, 
          #coderived returns decompressed FITS image</meta>
    <datalinkCore>
      <descriptorGenerator procDef="//soda#fits_genDesc"  name="genFITSDesc">
        <bind key="qnd">0</bind>	<!-- deals with fit.fz -->
        <bind key="accrefPrefix">'upjs_img/data'</bind>
      </descriptorGenerator>
      <FEED source="//soda#fits_standardDLFuncs"/>
      <metaMaker semantics="#coderived">
        <code>
          # print(f'\n\n metaMaker descriptor {descriptor} {descriptor.accref=} {descriptor.accessPath=} {descriptor.hdr}\n\n')
          descriptor.contentQualifier="#image"
          # give a hint that we will deal with an unpacked fits 
          # How to do this whthout the headaches of restoring filenames?
          accref_unpacked = descriptor.accref.replace('.fit.fz', '.fits')
          yield descriptor.makeLink(
            makeAbsoluteURL("\rdId/unpack/qp/{}".format(accref_unpacked)),
            contentType="image/fits",
            description="funpacked FITS",
            contentLength=descriptor.estimateSize()*2.0,
            contentQualifier="#image"
          )
        </code>
      </metaMaker>
    </datalinkCore>
  </service>

  <service id="unpack" allowed="qp">
    <meta name="title">Experimenting with fz unpacking on the fly</meta>
    <property key="queryField">accref</property>
    <pythonCore>
      <inputTable>
        <inputKey name="accref" type="text" required="True"
          description="filename and path to the unpacked fits file file"/>
      </inputTable>
      <coreProc>
        <setup imports="gavo.utils.pyfits, io"/>
        <code>
          # JK: How to find original file? Let's pretend we do not know if unpacked one exists

          accref_unpacked = inputTable.getParam("accref")
          fullpath = os.path.join(base.getConfig("inputsDir"), accref_unpacked)

          if not os.path.isfile(fullpath):
            fullpath = fullpath.replace('.fits', '.fit')
            if not os.path.isfile(fullpath):
              fullpath = fullpath.replace('.fit', '.fit.fz')

          # This code is just for fun - it will not work with two-page headers
          with pyfits.open(fullpath) as hdulist:
            hdu = None

            for h in hdulist:
              if isinstance(h, pyfits.CompImageHDU):
                hdu = h
                break
            is_compressed = hdu is not None
            if is_compressed:
              # take uncompressed data
              data = hdu.data
              header = hdu.header
            else:
              # just copy non-compressed data
              data = hdulist[0].data
              header = hdulist[0].header

            out_buffer = io.BytesIO()
            pyfits.writeto(out_buffer, data, header)
            return ("application/fits", out_buffer.getvalue())

        </code>
      </coreProc>
    </pythonCore>
  </service>

  <!-- if you want to build an attractive form-based service from
    SIAP, you probably want to tinker here quite a bit; if you
    don't want to serve a browser service, just remove the following
    element. -->
  <service id="browse" allowed="form">
    <meta name="shortName">Kolonica web form</meta>
    <meta name="title">Browser interface for searching Kolonica fits images</meta>

    <dbCore queriedTable="main">
      <condDesc original="//siap2#humanInput"/>
      <condDesc>
        <inputKey original="target_name" showItems="10" multiplicity="multiple">
          <values fromdb="target_name from \schema.main order by target_name"/>
        </inputKey>
      </condDesc>
      <outputTable autoCols="target_name, access_estsize">
        <column original="access_url"/>
        <column original="s_ra" displayHint="type=hms"/>
        <column original="s_dec" displayHint="type=dms"/>
      </outputTable>
    </dbCore>
  </service>

  <service id="i" allowed="form,siap2.xml">
    <meta name="shortName">Kolonica siap2</meta>
    <meta name="title">Kolonica images</meta>

    <meta name="description">
      The images in this collection were acquired to monitor selected sky fields around 
      eclipsing binary stars at the Kolonica Observatory, Slovakia. 
    </meta>

    <!-- other sia.types: Cutout, Mosaic, Atlas -->
    <meta name="sia.type">Pointed</meta>

    <meta name="testQuery.pos.ra">258.6</meta>
    <meta name="testQuery.pos.dec">76.7</meta>
    <meta name="testQuery.size.ra">0.1</meta>
    <meta name="testQuery.size.dec">0.1</meta>

    <!-- this is the VO publication -->
    <publish render="siap2.xml" sets="ivo_managed"/>
    <!-- this puts the service on the root page -->
    <publish render="form" sets="local,ivo_managed" service="browse"/>
    <!-- all publish elements only become active after you run
      dachs pub q -->

    <dbCore queriedTable="main">
      <FEED source="//siap2#parameters"/>
      <!-- enable custom parameters like this:
        <condDesc buildFrom="dateObs"/> -->
    </dbCore>
  </service>

  <regSuite title="upjs_img regression">
    <!-- see http://docs.g-vo.org/DaCHS/ref.html#regression-testing
      for more info on these. -->

    <regTest title="upjs SIAP2 service works">
      <url POS="CIRCLE 258.6 76.7 0.1">
        i/siap2.xml
      </url>
      <code>
          # dachs test -D tmp.xml i
          # and look at tmp.xml -->
          # self.data self.headers self.status self.requestTime self.url.httpURL
          # Incidentally, that last name (_http_) is right; the regression framework only supports http, 
          # and it's not terribly likely that we'll change that.
          # print(f"upjs SIAP2 regression test")
          res = self.getVOTableRows()
          # print(f"{res[0]=}")
          # print(f"{len(res)=}")
          # print(f'{res[0]["access_url"]=}')
          # self.assertEqual(res[0]["access_url"], EqualingRE(r"http://.*/getproduct/.*/ZIGA/2021-10-29/2021-10-29T19%3A26%3A18_V\.fit"))
          self.assertHasStrings("VOTABLE", "publisher", "siap2")
          self.assertHTTPStatus(200)
          self.assertTrue(len(res) >= 702)
        </code>
    </regTest>
    <regTest title="TAP: VY UMi images are in obscore">
      <url parSet="TAP"><QUERY>
          SELECT count(*) AS nrows FROM ivoa.obscore WHERE dataproduct_type = 'image' AND target_name = 'VY UMi'
        </QUERY>/tap/sync</url>
      <code>
        row = self.getFirstVOTableRow()
        # print(f'{row["nrows"]=}')
        self.assertTrue(row["nrows"] >= 461)
      </code>
    </regTest>
    <!-- add more tests: image actually delivered, form-based service
      renders custom widgets, etc. -->


  </regSuite>
</resource>
