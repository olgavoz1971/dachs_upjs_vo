<?xml version="1.0" encoding="utf-8"?>
<resource schema="gaiadr3_veb" resdir=".">
  <macDef name="pubDIDBase">ivo://\getConfig{ivoa}{authority}/~?\rdId/</macDef>

  <execute on="loaded" title="define id parse functions"><job>
    <code><![CDATA[
        # we have artificial accrefs of the form /<id>-<band>;
        def unparseIdentifier(object, bandpass):
            """returns an accref from bandpass and object.
            """
            return f"{object}-{bandpass}"

        def parseIdentifier(id):
            """returns object and bandpass from an accref or a pubDID.
            """
            # assert "ogle" in id
            tail = id.split("/")[-1]
            object, bandpass = tail.rsplit("-", 1)  # object may contain "-"
            return object, bandpass

        rd.unparseIdentifier = unparseIdentifier
        rd.parseIdentifier = parseIdentifier
      ]]></code>
  </job></execute>

  <meta name="creationDate">2026-02-22T15:53:36Z</meta>

  <meta name="title">Selections from Gaia DR3 related to eclipsing binaries </meta>
  <meta name="description" format="rst">
        This schema contains data re-published from the official 
        Gaia DR3 TAP services (e.g. ivo://uni-heidelberg.de/gaia/tap). 
        It provides simplified access to eclipsing-binary parameters, 
        and epoch photometry via SSAP.
  </meta>
  <meta name="creator">
        <meta name="name">GAIA Collaboration</meta>
  </meta>

  <meta name="source">2023A&amp;A...674A...1G</meta>

  <meta name="content">
        <meta name="type">Catalog</meta>
  </meta>
  <meta name="coverage.waveband">Optical</meta>
  <meta name="schema-rank">20</meta>

  <meta name="subject">surveys</meta>
  <meta name="subject">astrometry</meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>

  <meta name="facility">Gaia</meta>

  <meta name="copyright" format="rst">
        If you use public Gaia DR3 data in a paper, please take note of
        `ESAC's guide`_ on how to acknowledge and cite it.

        .. _ESAC's guide: https://gea.esac.esa.int/archive/documentation/GDR3/Miscellaneous/sec_credit_and_citation_instructions/
  </meta>

  <coverage>  
        <temporal>2015-06-01 2015-06-01</temporal>
        <spatial>0/0-11</spatial>
        <spectral>1.986e-19 4.966e-19</spectral>
  </coverage>

<!-- ==============  photometric system ===================== -->

  <table id="photosys" onDisk="True" adql="Hidden">
    <meta name="description">The table with hotometric system parameters</meta>

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

<!-- ============================= sources ====================== -->

  <table id="gaia_source_lite_veb" onDisk="True" primary="source_id" adql="True">
    <index columns="pmra"/>
    <index columns="pmdec"/>
    <index columns="parallax"/>
    <index columns="phot_g_mean_mag"/>
    <index columns="phot_bp_mean_mag"/>
    <index columns="phot_rp_mean_mag"/>
    <mixin>//scs#pgs-pos-index</mixin>
    <publish sets="ivo_managed,local"/>

    <stc>
            Position ICRS BARYCENTER SPHER3 Epoch J2016.0 "ra" "dec" "parallax"
                    Error "ra_error" "dec_error" "parallax_error"
                Velocity "pmra" "pmdec" "radial_velocity"
                    Error "pmra_error" "pmdec_error" "radial_velocity_error"
    </stc>
    <column name="source_id" type="bigint"
        ucd="meta.id;meta.main"
        tablehead="Source Id"
        description="Gaia DR3 unique source identifier.  Note that this *cannot*
            be matched against the DR1 or DR2 source_ids."
	        verbLevel="1">
        <values nullLiteral="-1"/>
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="ra" type="double precision"
        ucd="pos.eq.ra;meta.main" unit="deg"
        tablehead="RA (ICRS)"
        description="Barycentric Right Ascension in ICRS at epoch J2016.0"
        verbLevel="1">
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="dec" type="double precision"
        ucd="pos.eq.dec;meta.main" unit="deg"
        tablehead="Dec (ICRS)"
        description="Barycentric Declination in ICRS at epoch J2016.0"
        verbLevel="1">
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="ra_error"
        ucd="stat.error;pos.eq.ra" unit="mas"
        tablehead="Err. RA"
        description="Standard error of ra (with cos δ applied)."/>

    <column name="dec_error"
        ucd="stat.error;pos.eq.dec" unit="mas"
        tablehead="Err. Dec"
        description="Standard error of dec" />

    <column name="pmra"
        type="double precision"
        ucd="pos.pm;pos.eq.ra" unit="mas/yr"
        tablehead="µ(RA)"
        description="Proper motion in right ascension of the source in ICRS
            at J2016.0. This is the tangent plane projection (i.e., multiplied by
            cos(δ)) of the proper
            motion vector in the direction of increasing right ascension."
        verbLevel="1"/>

    <column name="pmdec"
        type="double precision"
        ucd="pos.pm;pos.eq.dec" unit="mas/yr"
        tablehead="µ(Dec)"
        description="Proper motion in declination at J2016.0."
        verbLevel="1"/>

    <column name="pmra_error"
        ucd="stat.error;pos.pm;pos.eq.ra" unit="mas/yr"
        tablehead="Err. PM(RA)"
        description="Standard error of pmra"/>

    <column name="pmdec_error"
        ucd="stat.error;pos.pm;pos.eq.dec" unit="mas/yr"
        tablehead="Err. PM(Dec)"
        description="Standard error of pmdec"/>

    <column name="parallax"
        type="double precision"
        ucd="pos.parallax" unit="mas"
        tablehead="Parallax"
        description="Absolute barycentric stellar parallax of the source at the
        reference epoch J2016.0.  If looking for a distance, consider joining
        with gedr3dist.main and using the distances from there."
        verbLevel="1">
        <property name="statisticsTarget">10000</property>
    </column>

    <column name="parallax_error"
        ucd="stat.error;pos.parallax" unit="mas"
        tablehead="Parallax_error"
        description="Standard error of parallax" />

    <column name="phot_g_mean_mag"
        ucd="phot.mag;em.opt;stat.mean" unit="mag"
        tablehead="m_G"
        description="Mean magnitude in the G band. This is computed from the
            G-band mean flux applying the magnitude zero-point in the Vega
            scale.  To obtain error estimates, see phot_g_mean_flux_over_error."
        verbLevel="1" note="phot">
        <property name="statisticsTarget">5000</property>
    </column>

    <column name="phot_g_mean_flux_over_error"
        ucd="stat.snr;phot.flux;em.opt;stat.mean" unit=""
        tablehead="SNR G"
        description="Integrated mean G flux divided by its
            error. Errors are computed from the dispersion about the weighted
            mean of the input calibrated photometry."
        note="e"/>
    <LOOP>
        <csvItems>
            band, ucd
            rp,   R
            bp,   B
        </csvItems>
        <events>
            <column name="phot_\band\+_mean_flux_over_error"
                ucd="stat.snr;phot.flux;em.opt.\ucd"
                tablehead="SNR \upper{\band}"
                description="Integrated mean \upper{\band} flux divided by its
                    error. Errors are computed from the dispersion about the weighted
                    mean of the input calibrated photometry."
                note="e"/>
            <column name="phot_\band\+_mean_mag"
                unit="mag" ucd="phot.mag;em.opt.\ucd"
                tablehead="Mag \upper{\band}"
                description="Mean magnitude in the integrated \upper{\band} band.
                    This is computed from the \upper{\band}-band mean flux
                    applying the magnitude zero-point in the Vega scale.
                    To obtain error estimates, see
                    phot_\band\+_mean_flux_over_error."
                verbLevel="1" note="phot">
                <property name="statisticsTarget">5000</property>
            </column>
        </events>
    </LOOP>

    <column name="radial_velocity"
        unit="km/s" ucd="spect.dopplerVeloc.opt;em.opt.I"
        tablehead="RV"
        description="Spectroscopic radial velocity in the solar barycentric
            reference frame.  For stars brighter than about 12 mag, this is the
            median of all single-epoch measurements.  For fainter stars, RV
            estimation is from a co-added spectrum."
            verbLevel="1"/>

    <column name="radial_velocity_error"
        unit="km/s" ucd="stat.error;spect.dopplerVeloc"
        tablehead="Err. RV"
        description="Error in radial_velocity; this is the error of the median
            for bright stars.  For faint stars, it is derived from the
            cross-correlation function."/>

    <column name="ruwe"
        ucd="stat.weight"
        tablehead="RUWE"
        description="Renormalized Unit Weight Error; this is a revised
            measure for the overall consistency of the solution as defined
            by GAIA-C3-TN-LU-LL-124-01.  A suggested cut on this is
            RUWE &lt;1.40) See the note for details."
        verbLevel="5" note="ruwe"/>

    <!-- added myself -->

    <column name="pm"
        ucd="pos.pm;pos.eq" unit="mas/yr"
        tablehead="µ"
        description="Total proper motion"
        verbLevel="1"/>

    <column name="teff_gspphot"
        ucd="phys.temperature.effective"
        unit="K"
        tablehead="teff_gspphot"
        description="Effective temperature from GSP-Phot Aeneas best library 
              using BP/RP spectra"
        verbLevel="1"/>

    <column name="teff_gspphot_lower"
        ucd="phys.temperature.effective;stat.min"
        unit="K"
        tablehead="teff_gspphot_lower"
        description="Lower confidence level (16%) of effective temperature 
            from GSP-Phot Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="teff_gspphot_upper"
        ucd="phys.temperature.effective;stat.max"
        unit="K"
        tablehead="teff_gspphot_upper"
        description="Upper confidence level (84%) of effective temperature 
            from GSP-Phot Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="logg_gspphot"
        ucd="phys.gravity"
        unit="log(cm/s**2)"
        tablehead="logg_gspphot"
        description="Surface gravity from GSP-Phot Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="logg_gspphot_lower"
        ucd="phys.gravity;stat.min"
        unit="log(cm/s**2)"
        tablehead="logg_gspphot_lower"
        description="Lower confidence level (16%) of surface gravity from GSP-Phot 
            Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="logg_gspphot_upper"
        ucd="phys.gravity;stat.max"
        unit="log(cm/s**2)"
        tablehead="logg_gspphot_upper"
        description="Upper confidence level (84%) of surface gravity from GSP-Phot 
            Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="mh_gspphot"
        ucd="phys.abund.Z"
        unit="dex"
        tablehead="mh_gspphot"
        description="Iron abundance from GSP-Phot Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="mh_gspphot_lower"
        ucd="phys.abund.Z;stat.min"
        unit="dex"
        tablehead="mh_gspphot_lower"
        description="Lower confidence level (16%) of iron abundance from GSP-Phot 
            Aeneas best library using BP/RP spectra"
        verbLevel="1"/>

    <column name="mh_gspphot_upper"
        ucd="phys.abund.Z;stat.max"
        unit="dex"
        tablehead="mh_gspphot_upper"
        description="Upper confidence level (84%) of iron abundance from GSP-Phot 
            Aeneas best library using BP/RP spectra"
        verbLevel="1"/>
  </table>

  <data id="import_gaia_source">
    <sources item="data/gaia_source_lite_veb.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="gaia_source_lite_veb">
        <rowmaker idmaps="*">
     </rowmaker>
    </make>
  </data>
      

<!-- ===================== vari_eclipsing_binary ============== -->

  <table id="vari_eclipsing_binary_lite" onDisk="True" primary="source_id" adql="True">
    <meta name="title">gaiadr3.vari_eclipsing_binary</meta>
    <meta name="description">
      This table describes the properties of the eclipsing binaries resulting from the variability analysis
    </meta>

    <column name="source_id" type="bigint"
        ucd="meta.id;meta.main"
        tablehead="Source Id"
        description="Gaia DR3 unique source identifier.  Note that this *cannot*
            be matched against the DR1 or DR2 source_ids."
        verbLevel="1" note="id">
        <values nullLiteral="-1"/>
        <property name="statisticsTarget">10000</property>
    </column>
 
    <column name="reference_time"
        type="double precision"
        ucd="time.epoch"
        unit="d"
        tablehead="reference_time"
        description="Reference time used for the geometric model fit"
        verbLevel="1"/>

    <column name="frequency"
        type="double precision"
        ucd="src.orbital"
        unit="d**-1"
        tablehead="frequency"
        description="Frequency of geometric model of the eclipsing binary light curve"
        verbLevel="1"/>

    <column name="frequency_error"
        ucd="stat.error"
        unit="d**-1"
        tablehead="frequency_error"
        description="Uncertainty of frequency"
        verbLevel="1"/>

    <column name="geom_model_reference_level"
        ucd="phot.mag;em.opt"
        unit="mag"
        tablehead="geom_model_reference_level"
        description="Magnitude reference level of geometric model"
        verbLevel="1"/>

    <column name="geom_model_reference_level_error"
        ucd="stat.error;phot.mag;em.opt"
        unit="mag"
        tablehead="geom_model_reference_level_error"
        description="Uncertainty of geomModel_Reference_Level"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_phase"
        ucd="time.phase"
        tablehead="geom_model_gaussian1_phase"
        description="Phase of the Gaussian 1 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_phase_error"
        ucd="stat.error;time.phase"
        tablehead="geom_model_gaussian1_phase_error"
        description="Uncertainty of geom_model_gaussian1_phase"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_sigma"
        ucd="stat.stdev"
        tablehead="geom_model_gaussian1_sigma"
        description="Standard deviation [phase] of Gaussian 1 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_sigma_error"
        ucd="stat.error"
        tablehead="geom_model_gaussian1_sigma_error"
        description="Uncertainty of geom_model_gaussian1_sigma"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_depth"
        ucd="src.var.amplitude"
        unit="mag"
        tablehead="geom_model_gaussian1_depth"
        description="Magnitude depth of Gaussian 1 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian1_depth_error"
        ucd="stat.error;src.var.amplitude"
        unit="mag"
        tablehead="geom_model_gaussian1_depth_error"
        description="Uncertainty of geom_model_gaussian1_depth"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_phase"
        ucd="time.phase"
        tablehead="geom_model_gaussian2_phase"
        description="Phase of the Gaussian 2 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_phase_error"
        ucd="stat.error;time.phase"
        tablehead="geom_model_gaussian2_phase_error"
        description="Uncertainty of geom_model_gaussian2_phase"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_sigma"
        ucd="stat.stdev"
        tablehead="geom_model_gaussian2_sigma"
        description="Standard deviation [phase] of Gaussian 2 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_sigma_error"
        ucd="stat.error"
        tablehead="geom_model_gaussian2_sigma_error"
        description="Uncertainty of geom_model_gaussian2_sigma"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_depth"
        ucd="src.var.amplitude"
        unit="mag"
        tablehead="geom_model_gaussian2_depth"
        description="Magnitude depth of Gaussian 2 component"
        verbLevel="1"/>

    <column name="geom_model_gaussian2_depth_error"
        ucd="stat.error;src.var.amplitude"
        unit="mag"
        tablehead="geom_model_gaussian2_depth_error"
        description="Uncertainty of geom_model_gaussian2_depth"
        verbLevel="1"/>

    <column name="geom_model_cosine_half_period_amplitude"
        ucd="src.var.amplitude"
        unit="mag"
        tablehead="geom_model_cosine_half_period_amplitude"
        description="Amplitude of the cosine component with half the period of the geometric model"
        verbLevel="1"/>

    <column name="geom_model_cosine_half_period_amplitude_error"
        ucd="stat.error;src.var.amplitude"
        unit="mag"
        tablehead="geom_model_cosine_half_period_amplitude_error"
        description="Uncertainty of geom_model_cosine_half_period_amplitude"
        verbLevel="1"/>

    <column name="geom_model_cosine_half_period_phase"
        ucd="time.phase"
        tablehead="geom_model_cosine_half_period_phase"
        description="Reference phase of the cosine component with half the period of the geometric model"
        verbLevel="1"/>

    <column name="geom_model_cosine_half_period_phase_error"
        ucd="stat.error;time.phase"
        tablehead="geom_model_cosine_half_period_phase_error"
        description="Uncertainty of geom_model_cosine_half_period_phase"
        verbLevel="1"/>

    <column name="derived_primary_ecl_phase"
        ucd="time.phase"
        tablehead="derived_primary_ecl_phase"
        description="Primary eclipse: phase at geometrically deepest point"
        verbLevel="1"/>

    <column name="derived_primary_ecl_phase_error"
        ucd="stat.error;time.phase"
        tablehead="derived_primary_ecl_phase_error"
        description="Primary eclipse: uncertainty of derivedPrimary_Ecl_Phase"
        verbLevel="1"/>

    <column name="derived_primary_ecl_duration"
        ucd="time.duration"
        tablehead="derived_primary_ecl_duration"
        description="Primary eclipse: duration [phase fraction]"
        verbLevel="1"/>

    <column name="derived_primary_ecl_duration_error"
        ucd="stat.error;time.duration"
        tablehead="derived_primary_ecl_duration_error"
        description="Primary eclipse: uncertainty of derivedPrimary_Ecl_Duration"
        verbLevel="1"/>

    <column name="derived_primary_ecl_depth"
        ucd="src.var.amplitude"
        unit="mag"
        tablehead="derived_primary_ecl_depth"
        description="Primary eclipse: depth"
       verbLevel="1"/>

    <column name="derived_primary_ecl_depth_error"
        ucd="stat.error;src.var.amplitude"
        unit="mag"
        tablehead="derived_primary_ecl_depth_error"
        description="Primary eclipse: uncertainty of derivedPrimary_Ecl_Depth"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_phase"
        ucd="time.phase"
        tablehead="derived_secondary_ecl_phase"
        description="Secondary eclipse: phase at geometrically second deepest point"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_phase_error"
        ucd="stat.error;time.phase"
        tablehead="derived_secondary_ecl_phase_error"
        description="Secondary eclipse: uncertainty of derivedSecondary_Ecl_Phase"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_duration"
        ucd="time.duration"
        tablehead="derived_secondary_ecl_duration"
        description="Secondary eclipse: duration [phase fraction]"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_duration_error"
        ucd="stat.error;time.duration"
        tablehead="derived_secondary_ecl_duration_error"
        description="Secondary eclipse: uncertainty of derivedSecondary_Ecl_Duration"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_depth"
        ucd="src.var.amplitude"
        unit="mag"
        tablehead="derived_secondary_ecl_depth"
        description="Secondary eclipse: depth"
        verbLevel="1"/>

    <column name="derived_secondary_ecl_depth_error"
        ucd="stat.error;src.var.amplitude"
        unit="mag"
        tablehead="derived_secondary_ecl_depth_error"
        description="Secondary eclipse: uncertainty of derivedSecondary_Ecl_Depth"
        verbLevel="1"/>

    <column name="model_type"
        type="text"
        ucd="meta.code.class"
        tablehead="model_type"
        description="Type of geometrical model of the light curve"
        verbLevel="1"/>
  </table>

  <data id="import_vari_eclipsing_binary">
    <sources item="data/vari_eclipsing_binary_lite.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="vari_eclipsing_binary_lite">
        <rowmaker idmaps="*">
     </rowmaker>
    </make>
  </data>


<!-- ============================= lightcurves ====================== -->
  <table id="lightcurves" onDisk="True" adql="True">
    <meta name="table-rank">150</meta>
    <meta name="description">This table contains all rows from Gaia DR3 epoch photometry for eclipsing binaties. Originally this data is accesible via DataLink</meta>
    <index columns="source_id"/>
<!--    <index columns="band"/>
    <index columns="time"/>  -->

    <column name="source_id" 
      type="bigint"
      ucd="meta.id;meta.main"
      tablehead="GaiaDR3 identifier"
      description="Unique source identifier within Gaia DR3"
      required="True"/>

    <column name="obs_time"
      type="double precision"
      ucd="time.epoch"
      unit="d"
      tablehead="Observation Time"
      description="observation time converted to mjd ???
          Different times are defined for each band. For G, it is 
          the field-of-view transit averaged observation time. For BP and RP, 
          it is the observation time of the BP CCD transit. 
          The units are Barycentric JD (in TCB) in days -2,455,197.5, computed as follows. 
          First the observation time is converted from On-board Mission Time (OBMT) 
          into Julian date in TCB (Temps Coordonnee Barycentrique). 
          Next a correction is applied for the light-travel time to the Solar system barycentre, 
          resulting in Barycentric Julian Date (BJD). Finally, an offset of 2,455,197.5 days 
          is applied (corresponding to a reference time $T_0$ at 2010-01-01T00:00:00) 
          to have a conveniently small numerical value. Although the centroiding time accuracy 
          of the individual CCD observations is (much) below 1~ms (e.g. in BP and RP), 
          the G band observation time is averaged over typically 9 CCD observations taken in 
          a time range of about 44sec."
      required="True"/>

    <column name="flux"
      type="double precision"
      ucd="phot.flux;em.opt;stat.mean"
      unit="s**-1"  
      tablehead="Flux"
      description="Band flux value for the transit. For G band, it is a combination of individual SM-AF CCD fluxes.
            For BP and RP bands, it is an integrated CCD flux."
      required="False"/>

    <column name="flux_error" 
      type="double precision"
      ucd="stat.error;phot.flux;em.opt"
      unit="s**-1"
      tablehead="Flux error"
      description="Flux error. If the flux has been rejected or is unavailable, this error will be set to null."
      required="False"/>

    <column name="band"
      type="text"
      ucd="instr.bandpass"
      utype="ssa:DataID.Bandpass"
      tablehead="Photometric Band"
      description="Photometric band. Values: G (per-transit combined SM-AF flux), 
          BP (blue photometer integrated flux) and RP (red photometer integrated flux)"
      required="True"/>

  </table>

  <data id="import_lightcurves">
    <make table="lightcurves">
      <script lang="python" type="postCreation" name="Load dump">
        table.connection.commit()
        src = table.tableDef.rd.getAbsPath("dumps/lightcurves.dump")
        with open(src) as f:
          cursor = table.connection.cursor()
          cursor.copy_expert(
            "COPY {} FROM STDIN".format(table.tableDef.getQName()),
            f)
      </script>
    </make>
  </data>


<!-- ================= SSAP stuff ======================== -->

  <meta name="ssap.dataSource">survey</meta> 
  <meta name="ssap.creationType">archival</meta>
  <meta name="productType">timeseries</meta>
  <meta name="ssap.testQuery">MAXREC=1</meta>

  <table id="raw_data" onDisk="True" adql="hidden"
      namePath="//ssap#instance">
    <meta name="table-rank">500</meta>
    <meta name="description">Gaia DR3 timeseries of eclipsing binaries for SSA/ObsCore ingestion</meta>

    <LOOP listItems="ssa_dstitle ssa_targname
      ssa_pubDID ssa_bandpass ssa_specmid ssa_specstart ssa_specend ssa_specext ssa_fluxucd
      ssa_timeExt ssa_length">
      <events>
        <column original="\item"/>
      </events>
    </LOOP>
    <column original="//obscore#ObsCore.t_min"/>
    <column original="//obscore#ObsCore.t_max"/>
    <column original="//products#products.preview"/>


    <mixin>//products#table</mixin>
    <mixin>//ssap#plainlocation</mixin>
    <mixin>//ssap#simpleCoverage</mixin>

    <index columns="ssa_targname"/>

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
      description="A link to a datalink document for this timeseries"
      verbLevel="15" displayHint="type=url">

      <property name="targetType">application/x-votable+xml;content=datalink</property>
      <property name="targetTitle">Datalink</property>
    </column>

   <viewStatement>

      CREATE MATERIALIZED VIEW \curtable AS (
        SELECT
          'Gaia DR3 ' || q.band || ' lightcurve for ' || q.source_id AS ssa_dstitle,
           q.source_id AS ssa_targname,
          -- 'Gaia DR3 ' || q.source_id AS ssa_targname,
          spoint(o.raj_rad, o.dej_rad) as ssa_location,
          spoly(  -- I'm not crazy enough to draw hexagons there, put up with squares
               '{(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || '),'
             || '(' || (o.raj_rad - o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad + o.aperture_rad) || '),'
             || '(' || (o.raj_rad + o.aperture_rad) || ',' || (o.dej_rad - o.aperture_rad) || ')' || '}'
          )::spoly AS ssa_region,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlget?ID=' || '\pubDIDBase' || q.source_id || '-' || q.band AS accref,
          '\pubDIDBase' || q.source_id || '-' || q.band AS ssa_pubdid,

          -- I prefer a folded lightcurve but we can put up with unfolded one sometimes
          CASE
            WHEN b.frequency IS NOT NULL THEN
              '\getConfig{web}{serverURL}/\rdId/preview-plot/qp/' || q.source_id || '-' || q.band
            ELSE
              '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.source_id || '-' || q.band
          END AS preview,

          -- '\getConfig{web}{serverURL}/\rdId/preview/qp/' || q.source_id || '-' || q.band AS preview,

          'Gaia ' || q.band AS ssa_bandpass,
          'phot.mag;em.opt' AS ssa_fluxucd,
          p.specmid AS ssa_specmid,
          p.specstart AS ssa_specstart,
          p.specend AS ssa_specend,
          p.specend-p.specstart AS ssa_specext,
          ssa_timeExt,
          t_min,
          t_max,
          q.ssa_length,
          50000 AS accsize,
          NULL AS embargo,
          NULL AS owner,
          'application/x-votable+xml' AS mime,
          '\getConfig{web}{serverURL}/\rdId/sdl/dlmeta?ID=' || '\pubDIDBase' || q.source_id || '-' || q.band AS datalink
        FROM (
          SELECT
            l.source_id, l.band,
            count(*) AS ssa_length,
            MAX(l.obs_time) - MIN(l.obs_time) AS ssa_timeExt,
            MIN(l.obs_time)+55197.0 AS t_min,	-- + 2455197.5 - 2400000.5 converting gaia_jd to mjd
            MAX(l.obs_time)+55197.0 AS t_max
          FROM \schema.lightcurves AS l
            GROUP BY l.source_id, l.band
        ) AS q
        JOIN (
          SELECT *,
            radians(ra) AS raj_rad,
            radians(dec) AS dej_rad,
            radians(0.5/3600) AS aperture_rad
          FROM \schema.gaia_source_lite_veb
        ) AS o USING (source_id)
        JOIN \schema.vari_eclipsing_binary_lite b USING (source_id)
        JOIN \schema.photosys AS p ON p.band_short = q.band
      )

    </viewStatement>
  </table>

  <data id="create-raw-view">
    <recreateAfter>make-ssa-view</recreateAfter>
    <make table="raw_data"/>
  </data>

<!-- ================================== ts_ssa =========================== -->

  <table id="ts_ssa" onDisk="True" adql="True">
    <property name="forceStats">1</property>
    <meta name="table-rank">50</meta>
    <meta name="_associatedDatalinkService">
      <meta name="serviceId">sdl</meta>
      <meta name="idColumn">ssa_pubDID</meta>
    </meta>

    <meta name="description">
		This table contains photometric timeseries for eclipsing binaries from 
		Gaia DR3 epoch photometry in IVOA SSA format. 
		The actual data is available through a datalink service.
    </meta>

    <stc>
      TimeInterval UTC HELIOCENTER "t_min" "t_max"
    </stc>

<!-- Add the column to map ssa_targname to for a natural join with other Gaia tables -->
    <column name="source_id" 
      type="bigint"
      ucd="meta.id;meta.main"
      tablehead="GaiaDR3 identifier"
      description="Unique source identifier within Gaia DR3"
      required="True"/>

    <mixin
      sourcetable="raw_data"
      copiedcolumns="*"
      customcode=", ssa_targname AS source_id"
      ssa_aperture="1/3600."
      ssa_dstype="'timeseries'"
      ssa_fluxcalib="'CALIBRATED'"
      ssa_fluxunit="'s**-1'"
      timescale='"TCB"'
      ssa_spectralucd="NULL"
      ssa_spectralunit="NULL"
      ssa_targclass="'EB*'"
      ssa_creator="'GAIA Collaboration'"
      ssa_csysName="'ICRS'"
      ssa_datasource="'survey'"
      ssa_collection="'Gaia DR3'"
      ssa_reference="'2023A&amp;A...674A...1G'"
      mime="'application/x-votable+xml'"
      ssa_targetpos="NULL"
      refposition="BARYCENTER"
    >//ssap#view</mixin>
    
    <!--  coverage param is an alias of s_region param --> 
    <mixin
      calibLevel="2"
      t_min="t_min"
      t_max="t_max"
      em_xel="1"
      t_xel="ssa_length"
      s_region="ssa_region"
      oUCD="'phot.mag'"
      createDIDIndex="True"
      preview="preview"
    >//obscore#publishSSAPMIXC</mixin>

    <column original="ssa_publisher" type="unicode"/>    <!-- unicode allows diacrtric symbols -->

  </table>

  <data id="make-ssa-view" auto="False">
    <make table="ts_ssa"/>
  </data>

  <coverage>
    <updater sourceTable="ts_ssa"/>
  </coverage>

  <STREAM id="instance-template">
    <table id="instance_\band_short" onDisk="False">
      <!-- metadata modified by sdl's dataFunction -->
      <!--	TODO: correct zeroPointFlux -->

      <meta name="description">Gaia DR3 lightcurve in the \band_human filter </meta>
      <param original="ts_ssa.ssa_bandpass"/>
      <param original="ts_ssa.ssa_specmid"/>
        <mixin
          effectiveWavelength="\effective_wavelength"
          filterIdentifier='"\band_human"'
          magnitudeSystem='"Vega"'
          zeroPointFlux="\zero_point_flux"
          phot_description="Gaia DR3 magnitude in \band_human"
          phot_ucd='phot.mag;\band_ucd'
          phot_unit="s**-1"
          refposition="BARYCENTER"
          refframe="ICRS"
          time0="2455197.5"
          timescale='"TCB"'
          pos_epoch='2016.0'
        >//timeseries#phot-0</mixin>

        <param original="ts_ssa.t_min"/>
        <param original="ts_ssa.t_max"/>
        <param original="ts_ssa.ssa_location"/>

        <!-- Add my column -->
        <column name="flux_error" 
          type="double precision"
          ucd="stat.error;phot.flux;em.opt"
          unit="s**-1"
          tablehead="Flux error"
          description="Flux error. If the flux has been rejected or is unavailable, this error will be set to null."
          required="False"/>

    </table>
  </STREAM>

  <!-- instantiate for a few bands - take names from https://svo2.cab.inta-csic.es/theory/fps/ -->
  <!-- zero point are from https://svo2.cab.inta-csic.es/theory/fps -->
  <!-- It would be interesting to have here a mixin like  //siap#getBandFromFilter but for ssap -->

  <LOOP source="instance-template">
    <csvItems>
            band_short, band_human, band_ucd, effective_wavelength, zero_point_flux
            G,          Gaia DR3 G,  em.opt, 5.82e-7, 3228.75
            BP,         Gaia DR3 Bp, em.opt, 5.04e-7, 3552.01
            RP,         Gaia DR3 Rp, em.opt, 7.62e-7, 2554.95
    </csvItems>
  </LOOP>

  <data id="build-ts" auto="False">
    <embeddedGrammar>
      <iterator>
        <code>
          object, passband = rd.parseIdentifier(self.sourceToken.metadata["ssa_pubdid"])    # in embeddedGrammar input is available as self.sourceToken

          with base.getTableConn() as conn:
            yield from conn.queryToDicts(
                   "SELECT l.obs_time, l.flux AS phot, l.flux_error"
                   " FROM \schema.lightcurves AS l"
                   " WHERE source_id=%(object)s AND l.band=%(passband)s"
                   " ORDER BY l.obs_time",
                   {"object": object, "passband": passband})
        </code>
      </iterator>
      <pargetter>
        <code>
          return self.sourceToken.metadata
        </code>
      </pargetter>
    </embeddedGrammar>

    <make table="instance_BP">   <!-- just a placeholder, we don't have the bare "instance" table. But we need a name from the LOOP -->
      <rowmaker idmaps="*" id="make-ts"/>

      <!-- parmaker can get parameters, provided by pargetter and write them as a metadata in the instance table -->
      <parmaker id="make-ts-par" idmaps="ssa_bandpass, ssa_specmid, t_min, t_max, ssa_location">
         <!--tut: touch manually the instance table metadata -->
         <apply name="update_metadata">
           <code>
             sourceId = vars["ssa_targname"]     # in apply the current input fields are available in the vars dictionary
             targetTable.setMeta("description", base.getMetaText(targetTable, "description") +
                 " for {}".format(sourceId))
             # JK: does not work :-( How to specifify it for each ts instance from ssa_reference?
             # targetTable.setMeta("source", "2035AcA....65....1U")
             # targetTable.setMeta("publication_id", "2034AcA....65....1U")
             targetTable.setMeta("name", str(sourceId))
           </code>
         </apply>
      </parmaker>
    </make>
  </data>

  <service id="sdl" allowed="dlget,dlmeta,static">
    <meta name="title">Gaia DR3 light curves Datalink Service</meta>
    <meta name="shortName">GDR3 TS Datalink</meta>
    <meta name="description">
      This service produces time series datasets for Gaia DR3 epoch photometry (lightcurves) of eclipsing binaries
    </meta>

    <!-- The datalink#fromtable descriptor generator simply pulling a row from a database table.
            This row is made available as the .metadata attribute -->
    <datalinkCore>
      <descriptorGenerator procDef="//datalink#fromtable">
        <bind key="tableName">"\schema.ts_ssa"</bind>
        <bind key="idColumn">"ssa_pubdid"</bind>
        <!-- <bind key="didPrefix">"\pubDIDBase/upjs/ts/"</bind>  -->
      </descriptorGenerator>

      <!-- We should make #this and #preview explicitly without products table (using //datalink#fromtable) -->
      <metaMaker semantics="#this">
        <code>
          targname = descriptor.metadata["ssa_targname"]
          passband = descriptor.metadata["ssa_bandpass"]
          yield descriptor.makeLink(
              descriptor.metadata["accref"],
              description=f"Gaia DR3 time series for {targname} in {passband}",
              contentType="application/x-votable+xml",
              contentLength="15000",
              contentQualifier="#timeseries")
        </code>
      </metaMaker>

      <metaMaker semantics="#preview">
        <code>
            pubdid = descriptor.metadata['ssa_pubdid']
            target = descriptor.metadata['ssa_targname']
            band = descriptor.metadata['ssa_bandpass']
            path_ending = "/".join(pubdid.split("/")[-2:])
            url = makeAbsoluteURL(f"\rdId/preview/qp/{path_ending}")
            yield descriptor.makeLink(
                url,
                description=f"Preview for {target} in {band}",
                contentType="image/png",
                contentLength="2000"
            )
        </code>
      </metaMaker>

      <!-- TODO check 0 in frequency column of vari_eclipsing_binary_lite -->
      <metaMaker semantics="#preview-plot">
        <code>
            # TODO raise something reasonable in case of absent information about the period
            # Preview of folded lightcurve with period and epoch (if available)
            pubdid = descriptor.metadata['ssa_pubdid']
            target = descriptor.metadata['ssa_targname']
            band = descriptor.metadata['ssa_bandpass']

            # Try to pull period and epoch from the objects table:
            with base.getTableConn() as conn:
              res = next(conn.query(
                "SELECT frequency, reference_time from \schema.vari_eclipsing_binary_lite where source_id=%(object)s",
                {"object": descriptor.metadata['ssa_targname']})
              )

            freq, epoch = res
            # Check if the frequency is present and not zero:
            if freq is None or freq == 0:
              # yield None
              yield DatalinkFault.NotFoundFault(target, "No period for this star known here")
            else:
              # period = 1.0/freq
              path_ending = "/".join(pubdid.split("/")[-2:])
              url = makeAbsoluteURL(f"\rdId/preview-plot/qp/{path_ending}")
              yield descriptor.makeLink(
                url,
                description=f"Preview of folded lightcurve for {target} in {band}",
                contentType="image/png",
                contentLength="2000"
              )
        </code>
      </metaMaker>

      <dataFunction>
        <setup imports="gavo.rsc"/>
        <code>
            _, bandid = rd.parseIdentifier(descriptor.metadata["ssa_pubdid"])
            dd = rd.getById("build-ts")
            descriptor.data = rsc.Data.createWithTable(dd,
                rd.getById("instance_" + bandid))
            descriptor.data = rsc.makeData(
                dd,
                data=descriptor.data,
                forceSource=descriptor)
        </code>
      </dataFunction>

      <dataFormatter>
        <!-- to VOTable -->
        <setup imports="gavo.formats.votablewrite"/>
        <code>
            return ("application/x-votable+xml;version=1.5",
                votablewrite.getAsVOTable(descriptor.data, version=(1,5)))
        </code>
      </dataFormatter>
    </datalinkCore>
  </service>

  <service id="preview-plot" allowed="qp">
    <property name="queryField">obs_id</property>
    <meta name="title">Folded lightcurve previews</meta>
    <meta name="shortName">Folded TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails for folded time series. It takes the obs_id for which to generate a preview. 
        To calculate phases, period and epoch from objects view are used.
    </meta>
    <pythonCore>
        <inputTable>
          <inputKey name="obs_id" type="text"
              tablehead="Obs. Id"
              description="Observation id (a combination of an object id and a passband) to create the preview for."/>
        </inputTable>
        <coreProc>
            <setup>
                <code>
                    from gavo.svcs import UnknownURI
                    from gavo.helpers.processing import SpectralPreviewMaker
                </code>
            </setup>
            <code>
              objId, passband = rd.parseIdentifier(inputTable.getParam("obs_id"))
              with base.getUntrustedConn() as conn:
                    res = list(conn.query(
                        "SELECT l.obs_time, l.flux "
                        "FROM \schema.lightcurves AS l "
                        "WHERE source_id=%(obj_id)s AND l.band=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

                    period_epoch = list(conn.query(
                      "SELECT frequency, reference_time "
                        "FROM \schema.vari_eclipsing_binary_lite "
                        "WHERE source_id=%(obj_id)s LIMIT 1",
                        {"obj_id": objId}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              freq, epoch = period_epoch[0] if len(period_epoch) > 0 else (None, None)
              if freq is None or freq == 0:
                raise UnknownURI(f'We have no period for {objId}')
              # use epoch if present, otherwise take just the first observation
              jd0 = epoch if epoch is not None else res[0][0]
              period =  1.0 / freq
              folded = [
                     ((jd - jd0) / period % 1.0, mag)
                     for jd, mag in res
              ]

              # No need to invert y-axis, we deal with fluxes:
              # jds, mags = zip(*folded)
              # lc = list(zip(jds, [-m for m in mags]))
              # return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
              return "image/png", SpectralPreviewMaker.get2DPlot(folded, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>

  <service id="preview" allowed="qp">
    <property name="queryField">obs_id</property>
    <meta name="title">Timeseries previews</meta>
    <meta name="shortName">TS previews</meta>
    <meta name="description">
        A service returning PNG thumbnails for time series. It takes the obs id for which to generate a preview.
    </meta>
    <pythonCore>
        <inputTable>
          <inputKey name="obs_id" type="text"
              tablehead="Obs. Id"
              description="Observation id (a combination of an object id and a passband) to create the preview for."/>
        </inputTable>
        <coreProc>
            <setup>
                <code>
                    from gavo.svcs import UnknownURI
                    from gavo.helpers.processing import SpectralPreviewMaker
                </code>
            </setup>
            <code>
              objId, passband = rd.parseIdentifier(inputTable.getParam("obs_id"))
              with base.getUntrustedConn() as conn:
                    res = list(conn.query(
                        "SELECT l.obs_time, l.flux "
                        "FROM \schema.lightcurves AS l "
                        "WHERE source_id=%(obj_id)s AND l.band=%(passband)s "
                        "ORDER BY l.obs_time",
                        {"obj_id": objId, "passband": passband}
                    ))

              if not res:
                raise UnknownURI(f'No time series for {objId} {passband}')

              # No need to invert y-axis for fluxes:
              # jds, mags = zip(*res)
              # lc = list(zip(jds, [-m for m in mags]))
              # return "image/png", SpectralPreviewMaker.get2DPlot(lc, linear=True, connectPoints=False)
              return "image/png", SpectralPreviewMaker.get2DPlot(res, linear=True, connectPoints=False)
            </code>
        </coreProc>
    </pythonCore>
  </service>


</resource>
