<?xml version="1.0" encoding="utf-8"?>
<!-- A template for a simple, TAP-accessible table with no further frills.
If you have "typed" data (object catalgues, images, spectra...), use
a more refined template.

To fill it out, search and replace %.*%

Note that this doesn't expose all features of DaCHS.  For advanced
projects, you'll still have to read documentation... -->


<resource schema="filters" resdir=".">
  <meta name="schema-rank">61</meta>

  <meta name="creationDate">2026-04-06T11:37:56Z</meta>

  <meta name="title">Filter Profiles</meta>
  <meta name="description" format="rst">
This table provides photometric filter characteristics derived from the SVO Filter Profile Service https://svo2.cab.inta-csic.es/svo/theory/fps/.
Each row corresponds to a single photometric filter and contains basic bandpass information.

Exposing these data through TAP enables ADQL queries joining filter data with photometric datasets. 

The table contains a selected subset of filters used in the published light-curve collections. 
The full transmission curves can be retrieved from the original SVO Filter Profile Service using the fps_url column.

These data are republished with permission from the SVO Filter Profile Service.
If this table contributes to your research, please acknowledge the original service and cite the following references:

* Rodrigo, C., Cruz, P., Aguilar, J.F., et al. 2024, :bibcode:`2024A&amp;A...689A..93R`; 
* The SVO Filter Profile Service. Rodrigo, C., Solano, E., Bayo, A., 2012, :bibcode:`2012ivoa.rept.1015R`;
* The SVO Filter Profile Service. Rodrigo, C., Solano, E., 2020, :bibcode:`2020sea..confE.182R`.

The SVO Filter Profile Service is funded by MCIN/AEI/10.13039/501100011033/ through grant PID2023-146210NB-I00.
  </meta>

  <meta name="copyright" format="rst">
        If this table contributes to your research, please acknowledge the original service and cite the following references:

        | Rodrigo, C., Cruz, P., Aguilar, J.F., et al. 2024, :bibcode:`2024A&amp;A...689A..93R`; 
        | The SVO Filter Profile Service. Rodrigo, C., Solano, E., Bayo, A., 2012, :bibcode:`2012ivoa.rept.1015R`;
        | The SVO Filter Profile Service. Rodrigo, C., Solano, E., 2020, :bibcode:`2020sea..confE.182R`.
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">optical-filters</meta>
  <meta name="subject">photometric-systems</meta>

  <meta name="creator">Rodrigo, C.; Solano, E.</meta>
  <meta name="instrument"></meta>
  <meta name="facility"></meta>

  <!-- <meta name="source">2024A&amp;A...689A..93R</meta> -->
  <meta name="source">2020sea..confE.182R</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated;
      remove if there are no messengers involved.  -->
  <meta name="coverage.waveband">Infrared, Optical, UV</meta>

  <table id="main" onDisk="True" adql="True">


    <!-- B -->
    <column name="band" type="text"
      ucd="instr.bandpass"
      tablehead="band"
      description="Human-readable name of the photometric band"
      utype="photdm:PhotometryFilter.bandName"
      required="False"
      verbLevel="1"
    />

    <column name="filter_id" type="text"
      ucd="meta.ref.ivoid"
      tablehead="filter_id"
      description="Filter Unique identifier within SVO Filter Profiles Service"
      utype="photdm:PhotometryFilter.identifier"
      required="True"
      verbLevel="1"
    />

    <column name="description" type="text"
      ucd="meta.note"
      tablehead="description"
      description="Description of the filter"
      utype="photdm:PhotometryFilter.description"
      verbLevel="15"
    />

    <column name="wavelength_ref" type="double precision"
      unit="Angstrom" ucd="em.wl;meta.main"
      tablehead="lambda_ref"
      description="Reference wavelength. Defined as the same than the pivot
      wavelength."
      utype="photdm:PhotometryFilter.spectralLocation.value"
      required="True"
      verbLevel="1"
    />

    <column name="wavelength_mean" type="double precision"
      unit="Angstrom" ucd="em.wl"
      tablehead="lambda_mean"
      description="Mean wavelength. Defined as integ[x*filter(x) dx]/integ[filter(x) dx]"
      verbLevel="15"
    />

    <column name="wavelength_eff" type="double precision"
      unit="Angstrom" ucd="em.wl.effective"
      tablehead="lambda_eff"
      description="Effective wavelength. Defined as integ[x*filter(x)*vega(x) dx]/integ[filter(x)*vega(x) dx]"
      verbLevel="15"
    />

    <column name="wavelength_min" type="double precision"
      unit="Angstrom" ucd="em.wl;stat.min"
      tablehead="lambda_min"
      description="Minimum wavelength. Calculated by the SVO FP service as the first
      lambda value with a transmission at least 1% of maximum transmission."
      utype="photdm:PhotometryFilter.bandwidth.start.value"
      required="True"
      verbLevel="1"
    />

    <column name="wavelength_max" type="double precision"
      unit="Angstrom" ucd="em.wl;stat.max"
      tablehead="lambda_max"
      description="Maximum wavelength. Calculated by SVO FP service as the last 
      lambda value with a transmission at least 1% of maximum transmission."
      utype="photdm:PhotometryFilter.bandwidth.stop.value"
      required="True"
      verbLevel="1"
    />

    <column name="width_eff" type="double precision"
      unit="Angstrom" ucd="instr.bandwidth"
      tablehead="width_eff"
      description="Effective width. Defined as integ[x*filter(x) dx]. 
      Equivalent to the horizontal size of a rectangle with height equal to maximum 
      transmission and with the same area that the one covered by the filter transmission curve."
      utype="photdm:PhotometryFilter.bandwidth.extent.value"
      verbLevel="15"
    />

    <column name="wavelength_cen" type="double precision"
      unit="Angstrom" ucd="em.wl"
      tablehead="lambda_cen"
      description="Central wavelength. Defined as the central wavelength between the two points defining FWMH."
      verbLevel="15"
    />

    <column name="wavelength_pivot" type="double precision"
      unit="Angstrom" ucd="em.wl"
      tablehead="lambda_pivot"
      description="Pivot wavelength. Defined as sqrt{integ[x*filter(x) dx]/integ[filter(x) dx/x]}."
      verbLevel="15"
    />

    <column name="wavelength_peak" type="double precision"
      unit="Angstrom" ucd="em.wl"
      tablehead="lambda_peak"
      description="Peak wavelength. Defined as the lambda value with larger transmission."
      verbLevel="15"
    />

    <column name="wavelength_phot" type="double precision"
      unit="Angstrom" ucd="em.wl"
      tablehead="lambda_phot"
      description="Photon distribution based effective wavelength. Defined as 
      integ[x^2*filter(x)*vega(x) dx]/integ[x*filter(x)*vega(x) dx]."
      verbLevel="15"
    />

    <column name="fwhm" type="double precision"
      unit="Angstrom" ucd="instr.bandwidth"
      tablehead="fwhm"
      description="Full width at half maximum. Defined as the difference between
      the two wavelengths for which filter transmission is half maximum."
      verbLevel="15"
    />

    <column name="fsun" type="double precision"
      unit="erg/(cm**2.s.Angstrom)" ucd="phot.flux.density"
      tablehead="fsun"
      description="Solar flux integrated over the filter band."
      verbLevel="15"
    />

    <!-- 3908.4589846433 for B -->
    <column name="zeropoint" type="double precision"
      unit="Jy" ucd="phot.flux.density"
      tablehead="zp"
      description="Photometric zero point in flux units."
      utype="photdm:PhotCal.zeroPoint.flux.value"
      verbLevel="1"
    />

    <column name="zeropoint_unit" type="text"
      ucd="meta.unit"
      tablehead="zp_u"
      description="Photometric zero point unit"
      utype="photdm:PhotCal.ZeroPoint.flux.unitexpression"
      verbLevel="15"
    />

    <column name="zeropoint_type" type="text"
      ucd="meta.code"
      tablehead="zp_type"
      description="Type of zero point definition (e.g., Pogson)."
      utype="photdm:PhotCal.ZeroPoint.type"
      verbLevel="15"
    />

    <column name="magsys" type="text"
      ucd="meta.code"
      tablehead="magsys"
      description="Magnitude system (e.g., Vega, AB, ST)."
      utype="photdm:PhotCal.MagnitudeSystem.type"
      verbLevel="1"
    />

    <column name="photcal_id" type="text"
      ucd="meta.id"
      tablehead="photcal_id"
      description="Identifier of the photometric calibration."
      utype="photdm:PhotCal.identifier"
      verbLevel="15"
    />

    <column name="phot_system" type="text"
      tablehead="phot_system"
      description="Photometric system to which the filter belongs (e.g., Bessell)."
      utype="photdm:PhotometricSystem.description"
      verbLevel="1"
    />

    <column name="detector_type" type="integer"
      ucd="meta.code"
      tablehead="det_type"
      description="Detector type: 0 = energy counter, 1 = photon counter."
      utype="photdm:PhotometricSystem.detectorType"
      verbLevel="15">
      <values nullLiteral="-1"/>
    </column>

    <column name="fps_identifier" type="text"
      ucd="meta.ref.ivorn"
      tablehead="fps_id"
      description="Identifier of the Filter Profile Service providing the data."
      utype="photdm:PhotometryFilter.fpsIdentifier"
    />

    <column name="fps_url" type="text"
      ucd="meta.ref.url"
      tablehead="FPS_URL"
      displayHint="type=url"
      description="URL to the SVO Filter Profile Service query returning the filter profile and metadata for this filter."
      verbLevel="1"
    />

    <!-- Non-FPS column -->
    <column name="band_ucd" type="text"
      ucd="meta.ucd"
      tablehead="Band ucd"
      description="UCD of the photometric band"
      required="True"/>

    <publish/>
  </table>

  <data id="import">
    <sources pattern="data/*.csv">
      <ignoreSources pattern="*transmission*"/>
    </sources>
    <csvGrammar delimiter="," strip="True"/>
    <make table="main">
      <rowmaker id="filter_meta_rowmaker" idmaps="*">
        <!-- the following is an example of a mapping rule that uses
        a python expression; @something takes the value of the something
        field returned by the grammar.  You obviously need to edit
        or remove this concrete rule.
        <map dest="%name of a column%">int(@some_other_name[2:])</map>
        -->
      </rowmaker>
    </make>
  </data>

  <service id="q" allowed="form">
    <meta name="shortName">FPS form</meta>

    <publish render="form" sets="ivo_managed, local"/>

    <dbCore queriedTable="main">
      <condDesc>
        <inputKey original="filter_id">
          <values fromdb="filter_id from \schema.main"/>
        </inputKey>
      </condDesc>
    </dbCore>
  </service>

  <regSuite title="filters regression">
    <regTest title="filters table serves some data">
      <url parSet="TAP"
        QUERY="select * from filters.main WHERE filter_id='Generic/Bessell.U'"
        >/tap/sync</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        # print(row)
        # print(f'\n\n\n row={row}')
        self.assertAlmostEqual(row["wavelength_ref"], 3584.7769658367)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
