#!/usr/bin/env python3

import sys

infile = sys.argv[1]
outfile = infile + ".jd_245"

with open(infile) as f:
    lines = f.readlines()

# check if correction is needed
for line in lines:
    jd = float(line.split()[0])
    if jd < 2400000:
        sys.exit(0)   # This is JD-2450000 Hurraaa

print(f"correcting {infile}")

with open(outfile, "w") as f_out:
    for line in lines:
        jd, mag, mag_err = line.split()
        jd_245 = float(jd) - 2450000
        f_out.write(f"{jd_245:.5f} {mag} {mag_err}\n")
