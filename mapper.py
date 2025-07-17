#!/usr/bin/env python3
"""
mapper.py

Reads CSV from stdin and, for each line (including header),
prints: id<TAB>company,totalyearlycompensation
"""

import sys
import csv

def main():
    reader = csv.reader(sys.stdin)
    try:
        header = next(reader)
    except StopIteration:
        return

    # Determine the indexes for id, company, and totalyearlycompensation
    # (assumes the CSV columns are in this order)
    id_idx = 0
    comp_idx = 1
    total_idx = 2

    # Print header line
    print(f"{header[id_idx]}\t{header[comp_idx]},{header[total_idx]}")

    # Process each subsequent row
    for row in reader:
        # skip empty lines
        if not row:
            continue
        print(f"{row[id_idx]}\t{row[comp_idx]},{row[total_idx]}")

if __name__ == "__main__":
    main()
