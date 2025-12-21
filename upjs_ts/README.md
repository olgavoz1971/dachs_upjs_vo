# Kolonica light curves collection sub-repository
This repository contains resource descriptors for the publication loight curves  (time series) collection.
Time series were derived from CCD images obtained at the Kolonica Observatory, Slovakia.
Calibrated images are published separately in the upjs_img collection.

The observations were carried out to monitor selected fields centred on eclipsing binary
stars with two small telescopes.

The time series were produced with a custom photometric pipeline (Parimicha, Š., in preparation).
Differential photometry is performed using comparison star magnitudes from APASS DR9.

Beyond the primary target (typically an eclipsing binary), the pipeline derives calibrated magnitudes
for all stars in the field with sufficient signal-to-noise ratio.
This approach, we believe, may help researchers follow the behaviour of other interesting objects over time.

For each photometric point, we provide the list of comparison stars used in its calculation
(which may vary for each star and each image) via a DataLink service with #auxiliary semantics.

