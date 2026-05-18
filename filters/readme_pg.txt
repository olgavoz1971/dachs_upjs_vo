================================================================================
PHOTOMETRIC PASSBAND MAPPING MATRIX FOR HISTORICAL PHOTOGRAPHIC PLATES
================================================================================

When documenting new photographic plate data or mapping archival observations
to Virtual Observatory (VO) services, use the following standardized short 
designations for user-friendly column names, metadata labels, or aliases.

+------------+--------------------+--------------------------------------------+
| Short Code | Legacy Filter Name | Emulsion / Filter Context                  |
+------------+--------------------+--------------------------------------------+
| pg         | Photographic Blue  | Unfiltered blue-sensitive emulsions.       |
|            |                    | Default for undocumented/standard plates.  |
|            |                    | Examples: Kodak 103a-O, ORWO ZU-2, ZU-21,  |
|            |                    | Agfa Astro, Ilford Zenith.                 |
+------------+--------------------+--------------------------------------------+
| pv         | Photovisual Yellow | Orthochromatic or panchromatic emulsions   |
|            |                    | exposed through a yellow/amber sharp-cut   |
|            |                    | filter to mimic the human eye (V-band).    |
|            |                    | Examples: Kodak 103a-D, Agfa Astro Spezial |
|            |                    | paired with GG11, GG14, or Schott K2 filters|
+------------+--------------------+--------------------------------------------+
| g_phot     | Photographic Green | Panchromatic emulsions exposed through a   |
|            |                    | true green filter. Used in early 3-color   |
|            |                    | photographic photometry setups.            |
|            |                    | Examples: Kodak 103a-G, ORWO RP-1          |
|            |                    | paired with VG1 or GG9 filters.            |
+------------+--------------------+--------------------------------------------+
| r_phot     | Photographic Red   | Red-sensitized emulsions, often paired with|
|            |                    | a red filter to isolate H-alpha/red bands. |
|            |                    | Examples: Kodak 103a-F, 098-02, Agfa ISS,  |
|            |                    | ORWO WP-1 paired with RG1, RG2, or RG645.  |
+------------+--------------------+--------------------------------------------+
| i_phot     | Photographic IR    | Infrared-sensitized emulsions. Require     |
|            |                    | deep red or infrared-passing filters.      |
|            |                    | Examples: Kodak I-N, IV-N                  |
|            |                    | paired with RG5, RG8, or RG715 filters.    |
+------------+--------------------+--------------------------------------------+

--------------------------------------------------------------------------------
DECISION RULES FOR UNCERTAIN ARCHIVAL LOGS:
--------------------------------------------------------------------------------
1. IF NO EMULSION/FILTER IS NOTED: 
   Default to 'pg'. Historically, standard blue plates were the baseline asset;
   any special sensitization (panchromatic, infrared) or filter use was almost
   always explicitly written down due to complex chemistry or exposure times.

2. "GREEN" VS "YELLOW" CONFUSION:
   - If log says "green plate" or "visual plate" but references a yellow filter
     (e.g., GG11, GG14), map to 'pv'.
   - If log references an explicit green-isolating filter (e.g., VG1), map to 
     'g_phot'.
================================================================================
