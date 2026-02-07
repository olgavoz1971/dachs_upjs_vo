<?xml version="1.0" encoding="utf-8"?>
<resource schema="ogle" resdir=".">
  <meta name="creationDate">2026-01-23T12:00:00Z</meta>

  <meta name="title">Shared metadata</meta>

  <STREAM id="ogle_meta">

    <meta name="description" format="rst">
      The **Optical Gravitational Lensing Experiment (OGLE)** is a long-term photometric 
      survey operated by the University of Warsaw at Las Campanas Observatory.
      Most of the observations are carried out in the Cousins *I* filter, with
      auxiliary measurements in the *V* filter.

      High-cadence, long-term observations of crowded fields have led to the
      systematic discovery and classification of variable stars.
      The OGLE Collection of Variable Stars (OCVS) contains over one million objects.
      OCVS light curves span three survey phases: OGLE-II (1996-2000), OGLE-III
      (2001-2009), and OGLE-IV (2010-present).

      The VO-compliant re-publication of the OCVS light curve collection allows
      bulk download for objects with a specific variability class and parameters,
      which can be very handy for ML-based light curve analysis and related applications.

      The original data of the republished collection can be found at: 
      https://www.astrouw.edu.pl/ogle/ogle4/OCVS/

      While republishing, we almost preserve the original data structure. That is, there are tables
      with variable star parameters split by variability type (Cepheids, Eclipsing and Ellipsoidal
      Binaries, RR Lyrae stars, etc.) and by sky field: Galactic Bulge (BLG), Magellanic Clouds
      (LMC, SMC), Galactic Disc (GD). A few tables are related only to a variability class 
      (e.g., Cataclysmic Variables - CV, BLAPs, Anomalous Cepheids in the Milky Way - ACEP/GAL)
      or a specific field (M54 variables, which comprise diverse classes).

      All observed objects with their main parameters are aggregated in the object_all table,
      which facilitates generic queries across all classes. This table is served by Cone Search.

      The ts_ssa table is the main table for light-curve queries. It is served by TAP and SSA services.
      The time series themselves, as well as previews of folded and unfolded light curves, can be accessed
      via DataLink from the ts_ssa and ObsCore tables. Direct links to previews of folded curves are placed
      in the *preview* column of both the *ts_ssa* and *ObsCore* tables.
    </meta>

    <meta name="subject">light-curves</meta>
    <meta name="subject">variable-stars</meta>
    <meta name="subject">surveys</meta>

    <meta name="instrument">Warsaw 1.3m Telescope</meta>
    <meta name="facility">Las Campanas</meta>
    <meta name="source">2015AcA....65....1U</meta>

    <meta name="creator">Soszyński, I.; Udalski, A.; Szymański, M.K.; Pietrukowicz, P.; Borowicz, J.; 
                         Glowacki, M.; Hamanowicz, A.; Iwanek, P.; Kołaczek-Szymański, P.A.; Mróz, M.; 
                         Pawlak, M.; Ratajczak, M.; Skowron J.; Wrona, M.
    </meta>
    <meta name="copyright" format="rst">
      If you use or refer to the data obtained from this catalog in your scientific work, please cite the appropriate papers:
        :bibcode: `2015AcA....65....1U`  (OGLE-IV photometry)
        :bibcode: `2008AcA....58...69U`  (OGLE-III photometry)
    </meta>

    <meta name="contentLevel">Research</meta>
    <meta name="type">Survey</meta>  <!-- or Archive, Survey, Simulation -->
    <meta name="coverage.waveband">Optical</meta>
  </STREAM>

  <STREAM id="schema_desc">
    <meta name="description" format="rst">
      The Optical Gravitational Lensing Experiment (OGLE) is a long-term photometric 
      survey operated by the University of Warsaw at Las Campanas Observatory.
      Most of the observations are carried out in the Cousins I filter, with
      auxiliary measurements in the V filter.

      High-cadence, long-term observations of crowded fields have led to the
      systematic discovery and classification of variable stars.
      The OGLE Collection of Variable Stars (OCVS) contains over one million objects.
      OCVS light curves span three survey phases: OGLE-II (1996-2000), OGLE-III
      (2001-2009),
      and OGLE-IV (2010-present).

      The VO-compliant re-publication of the OCVS light curve collection allows 
      bulk download for objects with a specific variability class and parameters, 
      which can be very handy for ML-based light curve analysis and related applications.

      The original data of the republished collection can be found at:
      https://www.astrouw.edu.pl/ogle/ogle4/OCVS/.

      While republishing, we almost preserve the original data structure. That is, there are tables
      with variable star parameters split by variability type (Cepheids, Eclipsing and Ellipsoidal
      Binaries, RR Lyrae stars, etc.) and by sky field: Galactic Bulge (BLG), Magellanic Clouds
      (LMC, SMC), Galactic Disc (GD). A few tables are related only to a variability class (e.g., 
      Cataclysmic Variables - CV, BLAPs, Anomalous Cepheids in the Milky Way
      - ACEP/GAL) or a specific 
      field (M54 variables, which comprise diverse classes).

      All observed objects with their main parameters are aggregated in the object_all table, 
      which facilitates generic queries across all classes. This table is served by Cone Search.

      The ts_ssa table is the main table for light-curve queries. It is served by TAP and SSA services. 
      The time series themselves, as well as previews of folded and unfolded light curves, can be accessed 
      via DataLink from the ts_ssa and ObsCore tables. Direct links to previews of folded curves are placed 
      in the preview column of both the ts_ssa and ObsCore tables.
    </meta>
  </STREAM>

  <STREAM id="object_table_desc">
    <meta name="description" format="rst">
      The set of tables with variable star parameters from the OGLE Collection of Variable Stars
      (OCVS). The data are organised into separate tables by variable star class, 
      with corresponding names such as Classical Cepheids, Eclipsing Binaries, etc.
      The OGLE team provides different sets of parameters depending on the variability class, 
      which allows variability-class–specific queries.

      The objects_all table holds the basic parameters of all objects. 
      It serves as a base for the ts_ssa table (and the OGLE-related part of 
      the ObsCore table), which provide the main access points for light curves.
    </meta>
  </STREAM>

  <STREAM id="field_table_desc">
    <DEFAULTS field=""/>

    <meta name="description" format="rst">
      The OCVS project consists of several sub-surveys that differ by sky coverage and by the type 
      of variability targeted. The content and structure of tables containing observed object 
      parameters vary between these sub-surveys.

      In this resource descriptor, the individual tables related to the Variable Stars \field
      are ingested separately, one by one.
      In the o.rd all these tables are combined into a common objects_all table implemented as a unified view.
      Original tables are not supposed to be seen from outside via ADQL or web-forms 
    </meta>
  </STREAM>

  <STREAM id="longdoc_ogle">
    <meta name="_longdoc" format="rst">
The original OCVS data are provided as a set of tables with stellar parameters, split by variable-star 
class and sky field. Indeed, different variability classes have different sets of parameters. 
We preserve the division by variability class, but aggregate stars of a given class from all fields 
into unified tables with corresponding names, such as cepheids for Classical Cepheids
or eclipsing for Eclipsing Binaries and so on. 
This allows more precise, variability-class–specific queries.

All observed objects, together with their basic parameters, are aggregated in the object_all 
table, which facilitates generic queries across all classes. This table is served via Cone Search.

The ts_ssa table is the main table for light-curve queries. It is served by TAP and SSA services. 
The time series themselves, as well as previews of folded and unfolded light curves, can be accessed 
via DataLink from the ts_ssa and ObsCore tables. Direct links to previews of folded curves are placed 
in the preview column of both the ts_ssa and ObsCore tables.

ADQL Query Examples
-------------------

Download all RR Lyrae light curves with period in [0.5–0.7 days] range in the I band::


  SELECT ssa_targname, accref, o.period FROM ogle.ts_ssa AS t JOIN ogle.rrlyr AS o
  ON t.ssa_targname = o.object_id
  WHERE o.period BETWEEN 0.5 AND 0.7 AND t.ssa_bandpass = 'I'


Download all previews of the light curves with epochs (time of maximum brightness) in the future::


  SELECT * from ogle.objects_all WHERE epoch > ivo_to_mjd('2027-01-01')


Find all stars with periods longer than the duration of observations in I filter::


  SELECT o.* FROM ogle.objects_all o JOIN ogle.ts_ssa t ON o.object_id = t.ssa_targname
  AND t.ssa_bandpass='I' WHERE o.period > ssa_timeext


Select ten eclipsing binary systems, classified as "Contact" with the longest periods::


  SELECT TOP 10 accref, preview, o.* FROM ogle.eclipsing o JOIN ogle.ts_ssa t ON o.object_id = t.ssa_targname 
  WHERE subtype='C' and ssa_length>100 ORDER BY o.period DESC


    </meta>

  </STREAM>

</resource>