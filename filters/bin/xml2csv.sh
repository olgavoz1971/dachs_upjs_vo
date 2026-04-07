#!/bin/bash

for f in ../data/*.xml; do
  [ -e "$f" ] || continue
  python xml2csv.py "$f"
done
