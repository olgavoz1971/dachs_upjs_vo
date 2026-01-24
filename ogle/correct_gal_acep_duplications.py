#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Purpose of this script
----------------------

Ingesting the Galactic anomalous Cepheid (ACEP), we found
that some stars (at the moment, a single case: OGLE-GAL-ACEP-091) are present
in two separate input files:

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
"""

from pathlib import Path

# ------------------------------------------------------------
# Input column slices (original files)
# ------------------------------------------------------------
IN = {
    "id":        slice(0, 17),
    "I_mag":     slice(19, 25),
    "V_mag":     slice(26, 32),
    "period":    slice(34, 44),
    "per_err":   slice(45, 54),
    "t0":        slice(56, 68),
    "I_amp":     slice(70, 75),
}

# ------------------------------------------------------------
# Output formatting (EXACT widths)
# ------------------------------------------------------------
FMT = {
    "id":     "{:<17}",
    "I_mag":  "{:>6}",
    "V_mag":  "{:>6}",
    "period": "{:>10}",
    "per_err":"{:>9}",
    "t0":     "{:>12}",
    "I_amp":  "{:>5}",
}

def read(fname):
    return [l.rstrip("\n") for l in Path(fname).read_text().splitlines()
            if l.strip()]

def f(line, sl):
    return line[sl].strip()

# ------------------------------------------------------------
# Read input files
# ------------------------------------------------------------
acepF  = read("acepF.dat")
acep1O = read("acep1O.dat")

ids_F  = [f(l, IN["id"]) for l in acepF]
ids_1O = [f(l, IN["id"]) for l in acep1O]

common = set(ids_F) & set(ids_1O)

# ------------------------------------------------------------
# a) Remove intersecting rows
# ------------------------------------------------------------
Path("acepF_corr.dat").write_text(
    "\n".join(l for l in acepF if f(l, IN["id"]) not in common) + "\n"
)

Path("acep1O_corr.dat").write_text(
    "\n".join(l for l in acep1O if f(l, IN["id"]) not in common) + "\n"
)

# ------------------------------------------------------------
# Index acep1O by Star ID
# ------------------------------------------------------------
map_1O = {f(l, IN["id"]): l for l in acep1O}

# ------------------------------------------------------------
# b) Create acepF1O_new.dat
# ------------------------------------------------------------
out = []

for lF in acepF:
    sid = f(lF, IN["id"])
    if sid not in common:
        continue

    l1 = map_1O[sid]

    row = (
        FMT["id"].format(sid) + " " +
        FMT["I_mag"].format(f(lF, IN["I_mag"])) + " " +
        FMT["V_mag"].format(f(lF, IN["V_mag"])) + " " +
        FMT["period"].format(f(lF, IN["period"])) + " " +
        FMT["per_err"].format(f(lF, IN["per_err"])) + " " +
        FMT["t0"].format(f(lF, IN["t0"])) + " " +
        FMT["I_amp"].format(f(lF, IN["I_amp"])) + " " +
        FMT["period"].format(f(l1, IN["period"])) + " " +
        FMT["per_err"].format(f(l1, IN["per_err"])) + " " +
        FMT["t0"].format(f(l1, IN["t0"])) + " " +
        FMT["I_amp"].format(f(l1, IN["I_amp"]))
    )

    out.append(row)

Path("acepF1O_new.dat").write_text("\n".join(out) + "\n")

# ------------------------------------------------------------
# c) README_F1O (IDENTICAL FORMAT)
# ------------------------------------------------------------
Path("README_F1O").write_text("""\
Format of acepF1O_new.dat
--------------------------------------------------------------------------
  1-17  A17      ---     Star's ID

 19-24  F6.3     mag     Mean I-band magnitude (acepF)
 26-31  F6.3     mag     Mean V-band magnitude (acepF)

 33-42  F10.7    days    Period (acepF)
 44-52  F9.7     days    Period uncertainty (acepF)
 54-65  F12.4    days    Time of maximum brightness (acepF)
 67-71  F5.3     mag     I-band amplitude (acepF)

 73-82  F10.7    days    Period (acep1O)
 84-92  F9.7     days    Period uncertainty (acep1O)
 94-105 F12.4    days    Time of maximum brightness (acep1O)
107-111 F5.3     mag     I-band amplitude (acep1O)
--------------------------------------------------------------------------
""")
