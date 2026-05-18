#!/usr/bin/python

import xml.etree.ElementTree as ET
import csv
import sys
import os

# -------- Input file from command line --------
if len(sys.argv) < 2:
    print("Usage: script.py input.xml")
    sys.exit(1)

xml_file = sys.argv[1]

# Build output filenames
base_name = xml_file[:-4] if xml_file.lower().endswith(('.xml', '.vot')) else xml_file
metadata_csv = base_name + ".csv"
transmission_csv = base_name + "_transmission.csv"


# Mapping XML PARAM names -> your database column names
param_map = {
    "FilterProfileService": "fps_identifier",
    "filterID": "filter_id",
    "PhotSystem": "phot_system",
    "DetectorType": "detector_type",
    "Band": "band",
    "Description": "description",
    "WavelengthRef": "wavelength_ref",
    "WavelengthMean": "wavelength_mean",
    "WavelengthEff": "wavelength_eff",
    "WavelengthMin": "wavelength_min",
    "WavelengthMax": "wavelength_max",
    "WidthEff": "width_eff",
    "WavelengthCen": "wavelength_cen",
    "WavelengthPivot": "wavelength_pivot",
    "WavelengthPeak": "wavelength_peak",
    "WavelengthPhot": "wavelength_phot",
    "FWHM": "fwhm",
    "Fsun": "fsun",
    "PhotCalID": "photcal_id",
    "MagSys": "magsys",
    "ZeroPoint": "zeropoint",
    "ZeroPointUnit": "zeropoint_unit",
    "ZeroPointType": "zeropoint_type",
}

# Mapping filte-d (FPS code) to human-readable band
band_map = {
    "GAIA/GAIA3.G": "Gaia G",
    "GAIA/GAIA3.Grp": "Gaia RP",
    "GAIA/GAIA3.Gbp": "Gaia BP",
    "GAIA/GAIA3.Grvs": "Gaia RVS",
    "SLOAN/SDSS.u": "sdss_u",
    "SLOAN/SDSS.g": "sdss_g",
    "SLOAN/SDSS.r": "sdss_r",
    "SLOAN/SDSS.i": "sdss_i",
    "SLOAN/SDSS.z": "sdss_z",
    "TESS/TESS.Red": "TESS",
    "Palomar_Arp1961.103aO_atm": "pg",
    "Palomar_Arp1961.103aO_B": "pg",
    "Palomar_Arp1961.103aO_Sch": "pg",
    "Palomar_Arp1961.103aO_WG2": "pg",
}


band_ucd = [
        ((300, 380), "opt.u"),
        ((380, 500), "opt.b"),	# we should  catch Palomar/Arp1961.103aO_atm in this interval (λref = 3839.80)
        ((500, 600), "opt.v"), 
        ((600, 750), "opt.r"),
        ((750, 1000), "opt.i"),
    ]

def get_band_ucd(lambda_eff_angstrom):
    """
    Return UCD for photometric band based on effective wavelength (Angstrom).
    """

    # convert Å --> nm
    wl_nm = lambda_eff_angstrom * 1e-1

    for (lo, hi), ucd in band_ucd:
        if lo <= wl_nm < hi:
            return ucd

    return None  # or "em.wl" if you prefer default

tree = ET.parse(xml_file)
root = tree.getroot()

# -------- Extract PARAM metadata --------
params = {}
for param in root.iter("PARAM"):
    name = param.attrib.get("name")
    value = param.attrib.get("value")
    if name in param_map:
        params[param_map[name]] = value

if "filter_id" in params:
    params["fps_url"] = (
        "https://svo2.cab.inta-csic.es/svo/theory/fps/fps.php?ID="
        + params["filter_id"]
    )

band = params.get("band", None)

if "filter_id" in params:
    params["band"] = band_map.get(params["filter_id"], band)

params["band_ucd"] = get_band_ucd(float(params.get("wavelength_ref",  None)))

# -------- Write metadata CSV --------
columns = list(params.keys())

with open(metadata_csv, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=columns)
    writer.writeheader()
    writer.writerow(params)

print(metadata_csv + " written")


# -------- Extract transmission curve --------
rows = []
for tr in root.iter("TR"):
    td = tr.findall("TD")
    wavelength = td[0].text
    transmission = td[1].text
    rows.append([wavelength, transmission])

with open(transmission_csv, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["wavelength", "transmission"])
    writer.writerows(rows)

print(transmission_csv + " written")
