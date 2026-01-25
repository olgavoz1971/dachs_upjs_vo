# OGLE light curve re-publication

This sub-repository contains resource descriptors for the re-publication of
OGLE-II, OGLE-III, and OGLE-IV light curves.

The original data are provided by the Optical Gravitational Lensing Experiment
(OGLE) and are available at https://ogle.astrouw.edu.pl/.

The re-publication is carried out with the permission of the OGLE team
(see correspondence).

## Structure

The OGLE Collection of Variable Star light curves is large. 
The input data are split into numerous tables by sky field, variability type, and other criteria. 
There are the time series themselves and separate tables containing star
coordinates, names and variable-star parameters. A couple of these tables are subsets of others, 
which, as I understand it, reflects the hierarchy of variability subtypes.

All this results in a rather complex system of RD files.
I try to follow the approach described below.

1. I ingest the original data _as is_ wherever possible, reflecting the original OGLE directory 
structure in the “field” RDs (such as blg, gd, lmc, smc, etc.),
These RD's corresponds to the top level of the OGLE directory tree.
I hope this approach may help with future data updates.

2. Client-visible tables are organised as views over the original data in the o.rd (“objects”). 
Here I try to aggregate objects of the same variability type (and therefore having a homogeneous set 
of parameters) into separate variable-star-type tables, such as Cepheids, RR Lyrae stars, 
eclipsing binaries, etc.
In this way, clients can construct ADQL queries for light curves by selecting variable stars 
with specified parameters.

3. The light curves themselves, together with previews of folded and unfolded curves, 
are accessible via DataLink services from the ts_ssa or ObsCore tables. ts_ssa
is intended to be the main access point for time series data.

4. I implement SSAP and Cone Search but, honestly, I am not sure how useful these services will be 
for the OGLE collection.

## References

There are many publications produced by the OGLE team. I include references 
in the ssa_reference column of the ts_ssa table (the main access point for time series
data).

The references are assigned separately for each part of the collection, following the publications 
listed in the original OGLE directory structure at https://www.astrouw.edu.pl/ogle/ogle4/OCVS

Unfortunately, it is not possible to include multiple publications in a single row of the table. 
Therefore, when several relevant papers exist, I selected the “paper1”.

## Issues
### gd/cep/phot/V/OGLE-GD-CEP-1198.dat;  gd/cep/phot/V/OGLE-GD-CEP-1160.dat
obstime is HJD-2450000.0, not HJD as for all other GD/cep/phot/[VI]/*.dat
Use script correct_jd245.sh to see, what is wrong.

### misc/BLAP/phot_ogle4/I; misc/BLAP/phot_ogle3/I
A lot of files have HJD instead of expected (and
declared) there HJD-2400000. Use script correct_from_jd245.sh to check and confirm.sh
to confirm corrections.

Perhaps, it makes sense to do so also:
mv misc/BLAP/phot_Swope/V/* misc/BLAP/phot_ogle4/V/
mv misc/BLAP/phot_Swope/I/* misc/BLAP/phot_ogle4/I/

The authors mention that observation time there is BJD TDB, which differs 
from the rest of the data (declared as HJD). I should think about how to 
put this gracefully into the photDM.

### M54/M54variables.dat
This file should be cleaned of empty lines with only the first column filled.
I could not write an appropriate grammar for ingesting this file and gave
up. Use clean_M54variables_file.py to fix thinhs.

### gal/acep/acepF.dat; acep1O.dat
Here some stars (at the moment, a single case: OGLE-GAL-ACEP-091) are present
in both files:
  - acepF.dat   : classified as a fundamental-mode anomalous Cepheid
  - acep1O.dat  : classified as a first-overtone anomalous Cepheid
As a result, the same object appears twice in the database with two
independent sets of parameters and duplicated light curves. This leads to
confusion in the database tables and to unpredictable behaviour of derived
parameters.

To resolve this issue, such stars are treated here as double-mode objects.
Their parameters from both classifications are extracted and combined into
a separate file (acepF1O_new.dat), while they are removed from the original
single-mode catalogues.

The exact format of acepF1O_new.dat is documented in the accompanying file
README_F1O.

Use correct_gal_acep_duplications.py to do this


## Importing order
1. Photometric system: phot.rd
2. Original data: blg, gd, lmc, smc, misc, lc
3. Object table views: o.rd
4. Top level: q.rd
