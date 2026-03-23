#!/usr/bin/env python3

import os
import argparse
from astropy.time import Time
from astropy.coordinates import EarthLocation, SkyCoord
import astropy.units as u


def make_output_name(input_file):
    base, ext = os.path.splitext(input_file)
    return f"{base}_helio{ext}"


def main():
    parser = argparse.ArgumentParser(
        description="Convert topocentric JD to heliocentric JD (HJD)"
    )

    parser.add_argument("--input_file", type=str, required=False,
                        default='data/Shugarov/B.DAT',
                        help="Input file with two float columns (JD_topo whatever_you_want")
    parser.add_argument(
        "--lat", type=float, default=49.1667,
        help="Observatory latitude in degrees (default: Tatranska Lomnica)"
    )
    parser.add_argument(
        "--lon", type=float, default=20.2833,
        help="Observatory longitude in degrees (default: Tatranska Lomnica)"
    )
    parser.add_argument(
        "--height", type=float, default=863,
        help="Observatory height in meters (default: 863 m)"
    )
    parser.add_argument(
        "--object", "-o",
        # default='AA And',
        # default='SDSS J231110.88+013002.7',
        help="Object name to resolve if RA/Dec not given"
    )
    parser.add_argument(
        "--ra", type=float, required=False,
        help="Target Right Ascension in degrees"
    )
    parser.add_argument(
        "--dec", type=float, required=False,
        help="Target Declination in degrees"
    )
    parser.add_argument(
        "--output", required=False,
        help="Output file name"
    )

    args = parser.parse_args()
    output_file = args.output if args.output else make_output_name(args.input_file)

    location = EarthLocation(
        lat=args.lat * u.deg,
        lon=args.lon * u.deg,
        height=args.height * u.m
    )

    if args.ra is not None and args.dec is not None:
        target_coord = SkyCoord(ra=args.ra * u.deg, dec=args.dec * u.deg, frame="icrs")
    elif args.object:
        target_coord = SkyCoord.from_name(args.object)
    else:
        parser.error("Must provide either --object name or both --ra and --dec")

    with open(args.input_file, "r") as fin, open(output_file, "w") as fout:
        for line in fin:
            stripped = line.strip()

            if not stripped:
                fout.write(line)
                continue

            parts = stripped.split()

            if len(parts) != 2:
                fout.write(line)
                continue

            try:
                jd_topo = float(parts[0]) + 2400000
                value = float(parts[1])
            except ValueError:
                fout.write(line)
                continue

            t = Time(jd_topo, format="jd", scale="utc", location=location)

            # Light travel time correction to heliocentric
            ltt_helio = t.light_travel_time(target_coord, kind="heliocentric")
            t_helio = t + ltt_helio

            fout.write(f"{t_helio.jd-2400000:.10f} {value}\n")
        print(f'{output_file} with heliocentric JD for {args.object} '
              f'with ra: {target_coord.ra} dec: {target_coord.dec} is ready')


if __name__ == "__main__":
    main()
