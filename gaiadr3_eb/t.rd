<?xml version="1.0" encoding="utf-8"?>
<resource schema="gaiadr3_eb" resdir=".">
  <meta name="creationDate">2026-02-22T15:53:36Z</meta>

  <meta name="title">Gaia DR3 eclipsing binaries</meta>
  <meta name="description" format="rst">
        This schema contains data re-published from the official
        Gaia DR3 TAP services (e.g., ivo://uni-heidelberg.de/gaia/tap).
        It provides simplified access to data related to eclipsing binary stars,
        including epoch photometry and basic parameters from the gaiadr3.gaia_source
        and gaiadr3.vari_eclipsing_binary tables. Timeseries are available via SSAP and DataLink.
  </meta>
  <meta name="creator">
        <meta name="name">GAIA Collaboration</meta>
  </meta>

  <meta name="source">2023A&amp;A...674A...1G</meta>

  <meta name="content">
        <meta name="type">Catalog</meta>
  </meta>
  <meta name="coverage.waveband">Optical</meta>
  <meta name="schema-rank">70</meta>

  <meta name="subject">surveys</meta>
  <meta name="subject">astrometry</meta>
  <meta name="subject">light-curves</meta>
  <meta name="subject">variable-stars</meta>
  <meta name="subject">time-domain-astronomy</meta>

  <meta name="facility">Gaia</meta>
  <meta name="instrument">Gaia</meta>

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
    <meta name="description">The table with photometric system parameters</meta>

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

<!-- ============================= gaia_sources_lite ====================== -->

  <table id="gaia_source_lite_eb" onDisk="True" primary="source_id" adql="True">
    <meta name="table-rank">150</meta>
    <meta name="description" format="rst">
            This is a light version of the full gaiadr3.gaia_source table,
            containing astrometric and photometric columns and most columns
            with astrophysical parameters for eclipsing binaries.
            The full DR3 is available via the TAP services ivo://uni-heidelberg.de/gaia/tap
            and ivo://esavo/gaia/tap
    </meta>

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

<!--
    <column name="phot_g_mean_mag"
        ucd="phot.mag;em.opt;stat.mean" unit="mag"
        tablehead="m_G"
        description="Mean magnitude in the G band. This is computed from the
            G-band mean flux applying the magnitude zero-point in the Vega
            scale.  To obtain error estimates, see phot_g_mean_flux_over_error."
        verbLevel="1" note="phot">
        <property name="statisticsTarget">5000</property>
    </column>

    <column name="phot_g_mean_flux"
        ucd="phot.flux;em.opt;stat.mean"
        unit="s**-1"
        tablehead="flux_G"
        description="Integrated mean G flux">
    </column>

    <column name="phot_g_mean_flux_over_error"
        ucd="phot.flux" unit=""
        tablehead="SNR G"
        description="Integrated mean G flux divided by its
            error. Errors are computed from the dispersion about the weighted
            mean of the input calibrated photometry.">
    </column>
-->
    <LOOP>
        <csvItems>
            band, ucd
             g,   em.opt
            rp,   em.opt.R
            bp,   em.opt.B
        </csvItems>
        <events>
            <column name="phot_\band\+_mean_mag"
                unit="mag" ucd="phot.mag;\ucd"
                tablehead="Mag \upper{\band}"
                description="Mean magnitude in the integrated \upper{\band} band.
                    This is computed from the \upper{\band}-band mean flux
                    applying the magnitude zero-point in the Vega scale.
                    To obtain error estimates, see
                    phot_\band\+_mean_flux_over_error."
                verbLevel="1">
                <property name="statisticsTarget">5000</property>
            </column>
            <column name="phot_\band\+_mean_flux"
              ucd="phot.flux;\ucd;stat.mean"
              unit="s**-1"
              tablehead="flux \upper{\band}"
              description="Integrated mean \upper{\band} flux">
            </column>
            <column name="phot_\band\+_mean_flux_error"
                unit="s**-1"
                ucd="stat.error;phot.flux;\ucd"
                tablehead="SNR \upper{\band}"
                description="Integrated mean \upper{\band} flux divided by its
                    error. Errors are computed from the dispersion about the weighted
                    mean of the input calibrated photometry.">
            </column>
            <column name="phot_\band\+_mean_flux_over_error"
                ucd="stat.snr;phot.flux;\ucd"
                tablehead="Error \upper{\band}"
                description="Error on the integrated mean \upper{\band} flux">
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
    <sources item="data/gaia_source_lite_eb.csv"/>
    <csvGrammar delimiter="," strip="True"/>
      <make table="gaia_source_lite_eb">
        <rowmaker idmaps="*">
     </rowmaker>
    </make>
  </data>
      

<!-- ============================ vari_eclipsing_binary ========================== -->

  <table id="vari_eclipsing_binary_lite" onDisk="True" primary="source_id" adql="True">
    <meta name="table-rank">150</meta>
    <meta name="title">gaiadr3.vari_eclipsing_binary</meta>
    <meta name="description">
      This table describes the properties of eclipsing binaries resulting from the variability analysis in Gaia DR3.
      It includes most columns from the gaiadr3.vari_eclipsing_binary table.
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
        description="Reference time used for the geometric model fit; JD-2455197.5"
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
    <meta name="table-rank">200</meta>
    <meta name="description">This table contains all rows of Gaia DR3 epoch photometry
       for eclipsing binaries. The data were retrieved via the original Gaia DR3 DataLink service.
    </meta>
    <!-- <index columns="source_id"/> -->
    <index columns="source_id, band"/>
    <index columns="obs_time"/>

<!--    <index columns="band"/>
    <index columns="time"/>  -->

    <column name="source_id" 
      type="bigint"
      ucd="meta.id;meta.main"
      tablehead="GaiaDR3 identifier"
      description="Unique source identifier within Gaia DR3"
      required="True">
      <property name="statistics">no</property>
    </column>

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
      required="True">
      <property name="statistics">no</property>
    </column>

    <column name="flux"
      type="double precision"
      ucd="phot.flux;em.opt;stat.mean"
      unit="s**-1"  
      tablehead="Flux"
      description="Band flux value for the transit. For G band, it is a combination of individual SM-AF CCD fluxes.
            For BP and RP bands, it is an integrated CCD flux."
      required="False">
      <property name="statistics">no</property>
    </column>

    <column name="flux_error" 
      type="double precision"
      ucd="stat.error;phot.flux;em.opt"
      unit="s**-1"
      tablehead="Flux error"
      description="Flux error. If the flux has been rejected or is unavailable, this error will be set to null."
      required="False">
      <property name="statistics">no</property>
    </column>

    <column name="band"
      type="text"
      ucd="instr.bandpass"
      utype="ssa:DataID.Bandpass"
      tablehead="Photometric Band"
      description="Photometric band. Values: G (per-transit combined SM-AF flux), 
          BP (blue photometer integrated flux) and RP (red photometer integrated flux)"
      required="True">
      <property name="statistics">no</property>
    </column>

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


  <service id="dr3cone" allowed="form,scs.xml">
    <meta name="shortName">GDR3light SCS</meta>
    <publish render="scs.xml" sets="ivo_managed"/>
    <publish render="form" sets="local,ivo_managed"/>
    <meta name="title">Gaia DR3 EB Cone Search</meta>
    <meta>
            testQuery.ra:  39.78593
            testQuery.dec:  4.83580
            testQuery.sr:  0.0001
    </meta>
    <scsCore queriedTable="gaia_source_lite_eb">
      <FEED source="//scs#coreDescs"/>
      <LOOP listItems="source_id phot_g_mean_mag phot_bp_mean_mag phot_rp_mean_mag">
        <events>
          <condDesc buildFrom="\item"/>
        </events>
      </LOOP>
    </scsCore>
  </service>

  <!-- TODO Add RegTest -->
</resource>
