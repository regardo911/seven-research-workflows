#!/usr/bin/env python3
"""snapshot.py — Chapter 5. The before-state, taken before anything touches the raw file.

The body is the book's, unchanged. Two arguments are this repo's, and they exist
because the printed version bakes in two things the book itself calls out one chapter
later: the key column is `sample_id` and the output is `before.json` in the current
directory. Both defaults below are the printed behaviour exactly, so

    python3 snapshot.py raw_metadata.csv

does what the book says it does. --id-column takes a differently named key.
--out puts the snapshot inside the run directory, which is where you want it as
soon as you have two configs: `before.json` in the CWD gets overwritten by the
second run, and then row 4 of the Chapter 8 rubric reconciles run B's output
against run A's input and closes perfectly.
"""
import sys, json, argparse

try:
    import pandas as pd
except ImportError:
    sys.exit(
        "MISSING DEPENDENCY: pandas.\n"
        "  conda install -c conda-forge pandas   (it is in environment.yml)\n"
        "  or: python3 -m pip install pandas"
    )

ap = argparse.ArgumentParser(description="Record the state of a table before cleaning.")
ap.add_argument("source", help="the raw file, before anything has touched it")
ap.add_argument("--id-column", default="sample_id", help="key column (default: sample_id)")
ap.add_argument("--out", default="before.json", help="where to write (default: before.json)")
args = ap.parse_args()

src = args.source
df = pd.read_csv(src, dtype=str)   # dtype=str on purpose: no coercion on read
key = args.id_column
if key not in df.columns:
    sys.exit(f"MISSING COLUMN: no '{key}' in {src}. Columns are: {', '.join(df.columns)}")

snap = {
    "source": src,
    "n_rows": len(df),
    "columns": list(df.columns),
    "dtypes": {c: str(t) for c, t in df.dtypes.items()},
    "n_missing": {c: int(df[c].isna().sum()) for c in df.columns},
    "n_unique_ids": int(df[key].nunique()),
    "id_sample": sorted(df[key].dropna().unique())[:10],
}
json.dump(snap, open(args.out, "w"), indent=2)
print(json.dumps(snap, indent=2))
