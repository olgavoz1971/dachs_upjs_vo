#!/bin/bash

base_filters=(
  "GAIA/GAIA3.G"
  "GAIA/GAIA3.Gbp"
  "GAIA/GAIA3.Grp"
  "GAIA/GAIA3.Grvs"
  "Generic/Bessell.U"
  "Generic/Bessell.B"
  "Generic/Bessell.V"
  "Generic/Bessell.R"
  "Generic/Bessell.I"
  "SLOAN/SDSS.u"
  "SLOAN/SDSS.g"
  "SLOAN/SDSS.r"
  "SLOAN/SDSS.i"
  "SLOAN/SDSS.z"
  "TESS/TESS.Red"
  "Palomar/Arp1961.103aO_atm"
  "Palomar/Arp1961.103aO_Sch"
  "Palomar/Arp1961.103aO_WG2"
  "Palomar/Arp1961.103aO_B"
)

more_filters=(
)

base_url="https://svo2.cab.inta-csic.es/svo/theory/fps/fps.php?ID="

DATA_DIR="../data"

if [ ! -d "$DATA_DIR" ]; then
  mkdir -p "$DATA_DIR"
fi

for f in "${base_filters[@]}"; do
  # replace '/' to make valid filename
  safe_name="${DATA_DIR}/${f//\//_}"
  curl -o "${safe_name}.xml" "${base_url}${f}"
done
