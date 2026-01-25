#!/bin/bash

for f in *.dat.jd_245; do
    mv "$f" "${f%.jd_245}"
done
