#!/usr/bin/python

import sys

def process_file(input_file, output_file):
    with open(input_file, 'r') as f:
        lines = f.readlines()

    if not lines:
        raise ValueError("Empty file")

    # --- Read telescope codes ---
    first_line = lines[0].strip()
    if not first_line.startswith("Scopes:"):
        raise ValueError("First line must start with 'Scopes:'")

    codes = [c.strip() for c in first_line.split(":")[1].split(",")]
    if not codes:
        raise ValueError("No telescope codes found")

    current_code_index = -1
    pieces_count = -1   # first block starts after header

    with open(output_file, 'w') as out:
        for line in lines[1:]:
            if line.startswith('#'):	# comment, ignore
                out.write(line)
                continue
            stripped = line.strip()
            if not stripped:
                continue

            parts = stripped.split()

            try:
                if len(parts) != 2:
                    raise ValueError
                float(parts[0])
                float(parts[1])

                # valid measurement
                out.write(f'{parts[0]}  {parts[1]}  {codes[current_code_index]}\n')

            except ValueError:
                # switch telescope
                current_code_index += 1
                pieces_count += 1
                out.write(f'# {line}')
                print(f'{line=} {current_code_index=} {pieces_count=}')

                if current_code_index >= len(codes):
                    raise ValueError(
                        f"Too many data blocks ({pieces_count}) "
                        f"for provided telescope codes ({len(codes)})."
                    )

    # --- Final consistency check ---
    print(f'{pieces_count=} {len(codes)=}')
    if pieces_count+1 != len(codes):
        print(
            f"Number of data blocks ({pieces_count}) "
            f"does not match number of telescope codes ({len(codes)})."
        )

    print("Done")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: ./correct_lc input.dat output.dat")
        sys.exit(1)

    process_file(sys.argv[1], sys.argv[2])
