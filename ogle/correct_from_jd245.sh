#!/bin/bash

PY_SCRIPT="correct_from_jd245.py"

for file in *.dat; do
    [ -e "$file" ] || continue   # handle case with no .dat files
    echo "Processing $file"
    python3 "$PY_SCRIPT" "$file"
done
