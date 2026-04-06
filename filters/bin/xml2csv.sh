#!/bin/bash

for f in *.xml; do
  [ -e "$f" ] || continue
  python xml2csv.py "$f"
done
