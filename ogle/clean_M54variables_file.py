#!/usr/bin/env python3

# Purpose of this cleaning step:
# 1) Remove malformed or truncated lines that do not reach the declared
#    fixed-width catalogue format (i.e. do not contain all mandatory columns).
# 2) Exclude objects already identified as RR Lyrae stars in the
#    OGLE-BLG-RRLYR collection, to avoid duplication lightcurves
#
# Note:
# I normally try not to touch the original data at all.
# Unfortunately, in this case I have decided to violate this rule

from pathlib import Path

def clean_rrlyr(input_file):
    input_file = Path(input_file)
    output_file = input_file.with_name(input_file.stem + "_cleaned" + input_file.suffix)

    # Bytes 71–90 (1-based) → indices 70:90 (0-based)
    RRLYR_COL = slice(70, 90)

    with input_file.open("r", encoding="utf-8") as fin, \
         output_file.open("w", encoding="utf-8") as fout:

        for line in fin:
            # Skip empty or truncated lines (e.g. "V282  -")
            if len(line.rstrip("\n")) < 90:
                continue

            rrlyr_id = line[RRLYR_COL].strip()

            # Keep only rows with missing OGLE-BLG-RRLYR-ID
            if rrlyr_id == "-":
                fout.write(line)

    print(f"Written: {output_file}")


if __name__ == "__main__":
    clean_rrlyr("M54variables.dat")
