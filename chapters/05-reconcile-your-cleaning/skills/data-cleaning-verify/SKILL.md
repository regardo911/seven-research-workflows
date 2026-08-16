---
name: data-cleaning-verify
description: Snapshots a dataset before cleaning, requires a logged reason for every
  removed record, and reconciles counts, dtypes and missingness afterwards. Use before
  and after any cleaning, filtering, merging, deduplication or QC step, on any table,
  matrix or metadata file.
---

# Data cleaning verification

Never clean and reconcile in one pass. Snapshot first, clean second, reconcile third.

## Steps

1. Before anything touches the raw file, record: row count, column list, dtype per
   column, missing count per column, unique key count, and ten example key values.
   Read every column as a string, so the snapshot records the file rather than a guess
   about what the file means.

2. Perform the cleaning only after the snapshot exists on disk.

3. For every removed record, append a line naming the filter, the threshold, the count
   removed, and the count removed per biological group. If a step removes zero records,
   still write the line with zero.

4. Reconcile: rows in must equal rows out plus the sum of logged removals. Print both
   sides of the arithmetic even when they match.

5. Diff dtypes and missing counts against the snapshot. Flag every change and state
   whether it was intended. An unexplained dtype change is a failure, not a note.

6. Carry five records through by key and print their values from both the source and
   the output, for the human to compare by eye.

7. Report removals per group. Flag any filter whose removals are concentrated in one
   condition.

## Output

The row arithmetic, the drop log, the dtype and missingness diff, the five carried
records, and the per-group balance. End with PASS or FAIL. FAIL if the arithmetic does
not close, if any dtype changed without being marked intended, or if any removal is
unattributable to a logged filter. Never report PASS with an unexplained delta.
