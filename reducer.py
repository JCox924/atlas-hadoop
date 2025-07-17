#!/usr/bin/env python3
"""
reducer.py

Reads mapper output of the form:
    id<TAB>company,totalyearlycompensation
and prints out the top ten records sorted by compensation descending,
using only a fixed-size array of at most 10 elements.
"""

import sys

def main():
    top10 = []  # will hold up to 10 tuples: (salary, id, company)

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue

        parts = line.split('\t', 1)
        if len(parts) != 2:
            continue

        id_str, rest = parts

        # skip mapper header
        if id_str == 'id':
            continue

        # rest is "company,salary"
        try:
            company, salary_str = rest.rsplit(',', 1)
            salary = float(salary_str)
        except ValueError:
            continue

        record = (salary, id_str, company)

        if len(top10) < 10:
            top10.append(record)
            top10.sort(key=lambda x: x[0])  # keep ascending by salary
        else:
            # if this salary is larger than the smallest in top10, replace it
            if salary > top10[0][0]:
                top10[0] = record
                top10.sort(key=lambda x: x[0])

    # Now output in descending order
    top10_desc = sorted(top10, key=lambda x: x[0], reverse=True)

    # Print header
    print("id\tSalary\tcompany")
    for salary, id_str, company in top10_desc:
        # salary printed as float (e.g. "4980000.0")
        print(f"{id_str}\t{salary}\t{company}")


if __name__ == "__main__":
    main()
