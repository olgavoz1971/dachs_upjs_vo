#!/usr/bin/env python3

import sys

infile = sys.argv[1]
outfile = infile + ".hjd"

with open(infile) as f:
    lines = f.readlines()

# check if correction is needed
for line in lines:
    jd245 = float(line.split()[0])
    if jd245 > 2400000:
        sys.exit(0)   # This is HJD Hurraaa

print(f"correcting {infile}")

with open(outfile, "w") as f_out:
    for line in lines:
        jd245, mag, mag_err = line.split()
        hjd = float(jd245) + 2450000
        f_out.write(f"{hjd:.5f} {mag} {mag_err}\n")
