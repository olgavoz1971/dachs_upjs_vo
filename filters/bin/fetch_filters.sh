#!/bin/bash

filters=(
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
)

base_url="https://svo2.cab.inta-csic.es/svo/theory/fps/fps.php?ID="

for f in "${filters[@]}"; do
  # replace '/' to make valid filename
  safe_name="${f//\//_}"
  curl -o "${safe_name}.xml" "${base_url}${f}"
done
