import pyvo
from astropy.table import Table

# TAP service URL
# TAP_URL = "https://gaia.ari.uni-heidelberg.de/tap/"
TAP_URL = "https://gaia.aip.de/tap"

# Output files
EB_FILE = "gaiadr3_vari_eclipsing_binary.csv"
GS_FILE = "gaiadr3_gaia_source_veb.csv"


def retrieve_veb_with_upload(upload_file, output_file='vari_eclipsing_binary.dat'):
    # todo:first 10 rows for debugging
    upload_table = Table.read(upload_file, format="csv")        # [:10]

    service = pyvo.dal.TAPService(TAP_URL)

    query = """
        SELECT source_id,
        reference_time, frequency, frequency_error, 
        geom_model_reference_level, geom_model_reference_level_error, 
        
        geom_model_gaussian1_phase, geom_model_gaussian1_phase_error, 
        geom_model_gaussian1_sigma, geom_model_gaussian1_sigma_error, 
        geom_model_gaussian1_depth, geom_model_gaussian1_depth_error,

        geom_model_gaussian2_phase, geom_model_gaussian2_phase_error, 
        geom_model_gaussian2_sigma, geom_model_gaussian2_sigma_error, 
        geom_model_gaussian2_depth, geom_model_gaussian2_depth_error,
        
        geom_model_cosine_half_period_amplitude, geom_model_cosine_half_period_amplitude_error, 
        geom_model_cosine_half_period_phase, geom_model_cosine_half_period_phase_error, 
        
        derived_primary_ecl_phase, derived_primary_ecl_phase_error, 
        derived_primary_ecl_duration, derived_primary_ecl_duration_error, 
        derived_primary_ecl_depth, derived_primary_ecl_depth_error, 
        
        derived_secondary_ecl_phase, derived_secondary_ecl_phase_error, 
        derived_secondary_ecl_duration, derived_secondary_ecl_duration_error, 
        derived_secondary_ecl_depth, derived_secondary_ecl_depth_error, 

        model_type

        FROM gaiadr3.vari_eclipsing_binary AS b
        JOIN TAP_UPLOAD.my_upload AS up
        USING (source_id)
    """

    print("Submitting async job with table upload...")

    job = service.run_sync(
        query,
        maxrec=2200000,
        uploads={"my_upload": upload_table}
    )

    result = job.to_table()

    print(f"Retrieved {len(result)} rows")

    result.write(output_file, format="csv", delimiter=",", overwrite=True)
    print(f"Saved to {output_file}")


def retrieve_veb(output_file='vari_eclipsing_binary.dat'):
    service = pyvo.dal.TAPService(TAP_URL)

    query = """
        SELECT 
        source_id,
        reference_time, frequency, frequency_error, 
        geom_model_reference_level, geom_model_reference_level_error, 
        
        geom_model_gaussian1_phase, geom_model_gaussian1_phase_error, 
        geom_model_gaussian1_sigma, geom_model_gaussian1_sigma_error, 
        geom_model_gaussian1_depth, geom_model_gaussian1_depth_error,

        geom_model_gaussian2_phase, geom_model_gaussian2_phase_error, 
        geom_model_gaussian2_sigma, geom_model_gaussian2_sigma_error, 
        geom_model_gaussian2_depth, geom_model_gaussian2_depth_error,
        
        geom_model_cosine_half_period_amplitude, geom_model_cosine_half_period_amplitude_error, 
        geom_model_cosine_half_period_phase, geom_model_cosine_half_period_phase_error, 
        
        derived_primary_ecl_phase, derived_primary_ecl_phase_error, 
        derived_primary_ecl_duration, derived_primary_ecl_duration_error, 
        derived_primary_ecl_depth, derived_primary_ecl_depth_error, 
        
        derived_secondary_ecl_phase, derived_secondary_ecl_phase_error, 
        derived_secondary_ecl_duration, derived_secondary_ecl_duration_error, 
        derived_secondary_ecl_depth, derived_secondary_ecl_depth_error, 

        model_type

        FROM gaiadr3.vari_eclipsing_binary
    """

    print("Submitting async job with table upload...")

    job = service.run_sync(
        query,
        maxrec=2200000        
    )

    result = job.to_table()

    print(f"Retrieved {len(result)} rows")

    result.write(output_file, format="csv", delimiter=",", overwrite=True)
    print(f"Saved to {output_file}")


def retrieve_gaia_source_with_upload(upload_file, output_file=GS_FILE):
    upload_table = Table.read(upload_file, format="csv")        # [:10]
    service = pyvo.dal.TAPService(TAP_URL)
    query = """
        SELECT
        source_id, ra, dec, ra_error, dec_error,
        pmra, pmdec, pmra_error, pmdec_error,
        parallax, parallax_error,
        phot_g_mean_mag, phot_g_mean_flux, phot_g_mean_flux_error, phot_g_mean_flux_over_error,
        phot_rp_mean_mag, phot_rp_mean_flux, phot_rp_mean_flux_error, phot_rp_mean_flux_over_error,
        phot_bp_mean_mag, phot_bp_mean_flux, phot_bp_mean_flux_error, phot_bp_mean_flux_over_error,
        radial_velocity, radial_velocity_error,
        ruwe, pm,
        teff_gspphot, teff_gspphot_lower, teff_gspphot_upper,
        logg_gspphot, logg_gspphot_lower, logg_gspphot_upper,
        mh_gspphot, mh_gspphot_lower, mh_gspphot_upper
        FROM gaiadr3.gaia_source
        JOIN TAP_UPLOAD.my_upload AS up
        USING (source_id)
    """

    print("Submitting async job with table upload...")
    job = service.run_sync(
        query,
        maxrec=2200000,
        uploads={"my_upload": upload_table}
    )
    result = job.to_table()
    print(f"Downloaded {len(result)} rows")
    result.write(output_file, format="csv", delimiter=",", overwrite=True)
    print(f"Saved to {output_file}")


def retrieve_gaia_source(output_file=GS_FILE):
    service = pyvo.dal.TAPService(TAP_URL)

    query_gs = """
        SELECT
        s.source_id, ra, dec, ra_error, dec_error,
        pmra, pmdec, pmra_error, pmdec_error,
        parallax, parallax_error,
        phot_g_mean_mag, phot_g_mean_flux, phot_g_mean_flux_error, phot_g_mean_flux_over_error,
        phot_rp_mean_mag, phot_rp_mean_flux, phot_rp_mean_flux_error, phot_rp_mean_flux_over_error,
        phot_bp_mean_mag, phot_bp_mean_flux, phot_bp_mean_flux_error, phot_bp_mean_flux_over_error,
        radial_velocity, radial_velocity_error,
        ruwe, pm,
        teff_gspphot, teff_gspphot_lower, teff_gspphot_upper,
        logg_gspphot, logg_gspphot_lower, logg_gspphot_upper,
        mh_gspphot, mh_gspphot_lower, mh_gspphot_upper
        FROM gaiadr3.gaia_source AS s JOIN gaiadr3.vari_eclipsing_binary AS b ON s.source_id = b.source_id
    """
    print("Submitting async job with table gaia_source...")
    job_gs = service.run_async(query_gs, maxrec=2200000)
    result_gs = job_gs.to_table()
    print(f"Downloaded {len(result_gs)} rows")
    result_gs.write(output_file, format="csv", delimiter=",", overwrite=True)
    print(f"Saved to {output_file}")


def retrieve_gaia_source_for_veb(output_file=GS_FILE):
    print('Inside retrieve_gaia_source_for_veb')
    service = pyvo.dal.TAPService(TAP_URL)
    print('Got service')
    query = """
        SELECT
        source_id, ra, dec, ra_error, dec_error,
        pmra, pmdec, pmra_error, pmdec_error,
        parallax, parallax_error,
        phot_g_mean_mag, phot_g_mean_flux, phot_g_mean_flux_error, phot_g_mean_flux_over_error,
        phot_rp_mean_mag, phot_rp_mean_flux, phot_rp_mean_flux_error, phot_rp_mean_flux_over_error,
        phot_bp_mean_mag, phot_bp_mean_flux, phot_bp_mean_flux_error, phot_bp_mean_flux_over_error,
        radial_velocity, radial_velocity_error,
        ruwe, pm,
        teff_gspphot, teff_gspphot_lower, teff_gspphot_upper,
        logg_gspphot, logg_gspphot_lower, logg_gspphot_upper,
        mh_gspphot, mh_gspphot_lower, mh_gspphot_upper
        FROM gaiadr3.gaia_source
        JOIN gaiadr3.vari_eclipsing_binary USING (source_id)
        
    """
    print("Submitting async job retrieve_gaia_source_for_veb ...")
    job = service.run_async(
        query,
        maxrec=2200000,
    )
    result = job.to_table()
    print(f"Downloaded {len(result)} rows")
    result.write(output_file, format="csv", delimiter=",", overwrite=True)
    print(f"Saved to {output_file}")


def main():
    # retrieve_veb(output_file='vari_eclipsing_binary.csv')
    # retrieve_gaia_source_with_upload(upload_file="vari_eclipsing_binary.csv",
    #                                 output_file="gaia_source_lite_veb.csv")
    # retrieve_gaia_source(output_file="gaia_source_lite_veb.csv")
    print('start')
    retrieve_gaia_source_for_veb(output_file="gaia_source_lite_eb.csv")
    print('finish')
    return


if __name__ == "__main__":
    main()
