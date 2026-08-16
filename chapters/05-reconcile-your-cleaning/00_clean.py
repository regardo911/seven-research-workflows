#!/usr/bin/env python3
"""00_clean.py — Chapter 5's cleaning step, and the reconciliation that accounts for it.

THIS FILE IS NOT BOOK TEXT. The book names scripts/00_clean.py three times and never
prints it, so this is the smallest honest implementation of the Chapter 5 spec: join
the metadata to the count matrix, log every removal with a reason, coerce the columns
you meant to coerce, and print the before-and-after record that says what the cleaning
did. Everything it reports is computed from the files you point it at.

It reproduces the worked report in the book because the fixture reproduces the worked
dataset, not because anything is hardcoded. Point it at your own CSV and it reports
your numbers.

Two of the defects it flags are deliberate, and they are the point: coercing an
identifier column to int loses leading zeros, and filling a missing value with zero
turns "unmeasured" into "measured zero". Both are things people do every week. The
reconciliation is what makes them visible.

Exit code is 1 when the verdict is FAIL, so this can sit inside a pipeline. Standard
library only.

    python3 00_clean.py --raw meta.csv --counts counts.tsv --snapshot before.json \\
                        --outdir runs/my_run
"""
import argparse
import csv
import json
import os
import sys
from datetime import date


def parse_kv(pairs, what):
    out = {}
    for p in pairs or []:
        if "=" not in p:
            sys.exit(f"BAD --{what}: expected COLUMN=VALUE, got {p!r}")
        k, v = p.split("=", 1)
        out[k] = v
    return out


def is_numeric(values):
    """True when every present value parses as a number.

    Decides which columns get a missingness line. A missing value only corrupts
    silently where something downstream will treat it as a number.
    """
    seen = False
    for v in values:
        if v == "":
            continue
        seen = True
        try:
            float(v)
        except ValueError:
            return False
    return seen


def coerce(value, kind):
    """Return (written value, round_trips).

    round_trips is False when the coerced value can no longer reproduce the string
    that was in the file. That is the whole dtype check, in one comparison.
    """
    if value == "":
        if kind in ("int64", "float64"):
            return "0", True        # a numeric column cannot hold a missing value
        return "", True
    if kind == "int64":
        w = str(int(value))
    elif kind == "float64":
        w = repr(float(value))
    elif kind == "datetime":
        w = date.fromisoformat(value).isoformat()
    elif kind == "str":
        w = value
    else:
        sys.exit(f"UNKNOWN TYPE: {kind}. Use int64, float64, datetime or str.")
    return w, w == value


def main(argv):
    ap = argparse.ArgumentParser(description="Clean a metadata table and reconcile what changed.")
    ap.add_argument("--raw", required=True, help="the metadata CSV, as received")
    ap.add_argument("--counts", required=True, help="count matrix; row 1 is gene id then sample ids")
    ap.add_argument("--snapshot", default="before.json", help="snapshot.py output (default: before.json)")
    ap.add_argument("--outdir", required=True, help="run directory to write into")
    ap.add_argument("--id-column", default="sample_id")
    ap.add_argument("--group-column", default="condition", help="the biological variable (default: condition)")
    ap.add_argument("--coerce", action="append", metavar="COL=TYPE",
                    help="int64 | float64 | datetime | str. Repeatable. Default is the "
                         "book's worked example: patient_id=int64, collect_date=datetime, batch=str")
    ap.add_argument("--fillna", action="append", metavar="COL=VALUE",
                    help="fill missing values in COL. Repeatable, and flagged in the report, "
                         "because a fill is not a filter and nothing else logs it")
    ap.add_argument("--spot-check", default="", metavar="ID,ID,...",
                    help="IDs to carry through by eye (default: the first five in the snapshot)")
    ap.add_argument("--label", default="", help="report title (default: the raw file's name)")
    args = ap.parse_args(argv)

    type_spec = parse_kv(args.coerce, "coerce") or {
        "patient_id": "int64", "collect_date": "datetime", "batch": "str"}
    fills = parse_kv(args.fillna, "fillna")

    with open(args.raw, newline="") as fh:
        rows = list(csv.DictReader(fh))
    if not rows:
        sys.exit(f"EMPTY INPUT: {args.raw} has no data rows")
    columns = list(rows[0].keys())
    key, group = args.id_column, args.group_column
    for needed in (key, group):
        if needed not in columns:
            sys.exit(f"MISSING COLUMN: no '{needed}' in {args.raw}. Columns are: {', '.join(columns)}")

    with open(args.counts, newline="") as fh:
        header = next(csv.reader(fh, delimiter="\t"))
        totals = {s: 0 for s in header[1:]}
        for rec in csv.reader(fh, delimiter="\t"):
            for name, v in zip(header[1:], rec[1:]):
                totals[name] += int(v)

    if not os.path.exists(args.snapshot):
        sys.exit(f"MISSING SNAPSHOT: {args.snapshot}. Run snapshot.py against {args.raw} first; "
                 "the before-state is the one thing that cannot be recovered later.")
    snap = json.load(open(args.snapshot))

    kept = [r for r in rows if r[key] in totals]
    dropped = [r for r in rows if r[key] not in totals]

    # The only filter this script applies. Everything it removes gets a line, and a
    # step that removes nothing would still get one.
    groups = sorted({r[group] for r in rows})
    per_group = " / ".join(str(sum(1 for r in dropped if r[group] == g)) for g in groups)
    drop_line = {
        "filter_name": "id_not_in_countmatrix",
        "threshold": "exact match",
        "n_removed": str(len(dropped)),
        "n_removed_per_group": per_group,
        "example_ids": ", ".join(r[key].strip() for r in dropped[:5]),
    }
    cause = None
    if dropped and all(r[key].strip() != r[key] and r[key].strip() in totals for r in dropped):
        cause = f"trailing whitespace in {key}, source file {os.path.basename(args.raw)}"

    os.makedirs(args.outdir, exist_ok=True)
    with open(os.path.join(args.outdir, "drop_log.tsv"), "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=list(drop_line), delimiter="\t", lineterminator="\n")
        w.writeheader()
        w.writerow(drop_line)

    out_columns = [key, "n_counts"] + [c for c in columns if c != key]
    flags, losses = [], {}
    with open(os.path.join(args.outdir, "final_table.tsv"), "w", newline="") as fh:
        w = csv.writer(fh, delimiter="\t", lineterminator="\n")
        w.writerow(out_columns)
        for r in kept:
            written = {key: r[key], "n_counts": str(totals[r[key]])}
            for c in columns:
                if c == key:
                    continue
                v = fills[c] if (r[c] == "" and c in fills) else r[c]
                if c in type_spec:
                    v, ok = coerce(v, type_spec[c])
                    if not ok:
                        losses[c] = losses.get(c, 0) + 1
                written[c] = v
            w.writerow([written[c] for c in out_columns])

    after_missing = {}
    for c in columns:
        filled = c in fills or type_spec.get(c) in ("int64", "float64")
        after_missing[c] = 0 if filled else sum(1 for r in kept if r[c] == "")

    label = args.label or os.path.basename(args.raw)
    lines = [f"INTEGRITY RECONCILIATION — {label}", ""]

    rows_in, rows_out, logged = snap["n_rows"], len(kept), len(dropped)
    closes = rows_out + logged == rows_in
    arithmetic = (f"  ({rows_out} + {logged} = {rows_in})" if closes
                  else f"  ({rows_out} + {logged} = {rows_out + logged}, in was {rows_in})")
    lines.append("ROWS")
    for lab, val in (("in", rows_in), ("out", rows_out), ("logged removals", logged)):
        lines.append("  " + lab.ljust(19) + str(val).rjust(2))
    lines.append("  " + "reconciles?".ljust(19) + ("YES" if closes else "NO").rjust(2) + arithmetic)
    if not closes:
        flags.append("row arithmetic does not close")
    lines.append("")

    # Column widths hold at the defaults for the shapes in the book and grow for longer
    # filter names or group labels, so a wide value shifts the table instead of colliding.
    head = ("filter", "threshold", "n", f"per group ({'/'.join(groups)})", "example ids")
    body = (drop_line["filter_name"], drop_line["threshold"], drop_line["n_removed"],
            drop_line["n_removed_per_group"], drop_line["example_ids"])
    widths = [max(d, len(h) + 1, len(b) + 1)
              for d, h, b in zip((23, 15, 4, 25), head, body)]

    def drop_row(fields):
        return "  " + "".join(f.ljust(w) for f, w in zip(fields, widths)) + fields[4]

    lines += ["DROP LOG", drop_row(head), drop_row(body)]
    if cause:
        lines.append(" " * 25 + f"-> cause: {cause}")
    lines.append("")

    lines.append("DTYPES CHANGED")
    for c, kind in type_spec.items():
        if c not in columns:
            continue
        lost = losses.get(c, 0)
        if lost:
            zeros = sum(1 for r in kept if r[c].startswith("0") and r[c] != "0")
            why = (f"leading zeros lost, {lost} IDs affected" if zeros == lost
                   else f"{lost} values no longer reproduce the file")
            note = f"*** FLAGGED — {why}"
            flags.append(f"{c} str -> {kind}")
        elif kind == "str":
            note = "unchanged"
        else:
            note = "ok, intended"
        lines.append("  " + c.ljust(15) + f"str -> {kind}".ljust(17) + note)
    lines.append("")

    lines.append("MISSINGNESS")
    for c in columns:
        if c in type_spec or not is_numeric(r[c] for r in rows):
            continue
        b, a = snap["n_missing"][c], after_missing[c]
        if a == b:
            note = "unchanged"
        elif a < b:
            note = f"*** FLAGGED — {b - a} NAs became values, no filter logged this"
            flags.append(f"{c} missingness {b} -> {a}")
        else:
            note = f"*** FLAGGED — {a - b} values became NA"
            flags.append(f"{c} missingness {b} -> {a}")
        lines.append("  " + c.ljust(15) + f"{b} -> {a}".ljust(11) + note)
    lines.append("")

    wanted = [s.strip() for s in args.spot_check.split(",") if s.strip()] or snap["id_sample"][:5]
    shown = [c for c in columns if c != key][:3]
    gw = max(5, max((len(g) for g in groups), default=5))
    source_by_id = {r[key]: r for r in rows}
    out_by_id = {r[key]: r for r in kept}
    lines.append(f"SPOT CHECK ({len(wanted)} records carried by ID)")
    for sid in wanted:
        src, out = source_by_id.get(sid), out_by_id.get(sid)
        if out is None:
            lines.append(f"  {sid}  not in output   *** FLAGGED")
            flags.append(f"spot-check ID {sid} is not in the output")
            continue
        fields = [out[c] if c == group else f"{c.split('_')[0]} {out[c]}" for c in shown]
        same = all(src[c] == out[c] for c in shown)
        if not same:
            flags.append(f"spot-check {sid} differs from source")
        lines.append("  {}  {} {}   {}  {}".format(
            sid, fields[0].ljust(gw), "  ".join(fields[1:]),
            "matches source" if same else "DIFFERS", "OK" if same else "***"))
    lines.append("")

    lines.append("PER-GROUP BALANCE")
    rates = {}
    for g in groups:
        n = sum(1 for r in dropped if r[group] == g)
        tot = sum(1 for r in rows if r[group] == g)
        rates[g] = 100.0 * n / tot if tot else 0.0
        lines.append("  " + f"removals {g} {n} / {tot}".ljust(23) + f"({rates[g]:.1f}%)")
    hi, lo = max(rates, key=rates.get), min(rates, key=rates.get)
    if rates[hi] > 0 and (rates[lo] == 0 or rates[hi] >= 2 * rates[lo]):
        lines.append(f"  -> concentrated in {hi}; the filter is now part of your design")
        flags.append(f"removals concentrated in {hi}")
    else:
        lines.append("  -> not concentrated; proceed")
    lines.append("")

    if flags:
        lines.append(f"VERDICT: FAIL — {len(flags)} flagged item"
                     f"{'s' if len(flags) != 1 else ''} must be resolved before analysis")
    else:
        lines.append("VERDICT: PASS — every difference is accounted for")

    print("\n".join(lines))
    print(f"\nComputed from {args.raw} and {args.counts}; synthetic sample data, illustrative "
          f"only. Wrote {args.outdir}/final_table.tsv and {args.outdir}/drop_log.tsv.",
          file=sys.stderr)
    return 1 if flags else 0


if "snakemake" in globals():
    _s = globals()["snakemake"]             # injected by Snakemake's script: directive
    sys.exit(main(["--raw", _s.input.sheet, "--counts", _s.input.counts,
                   "--outdir", os.path.dirname(_s.output.table)]))
elif __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
