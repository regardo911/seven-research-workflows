<!-- Chapter 5, transcribed verbatim. Append it to any cleaning pass. You will not get
     this by default, and without it the reconciliation in Chapter 8 has nothing to
     read: verify.sh row 4 sums column 3 of drop_log.tsv. -->
# The drop-log instruction

```markdown
For every record removed, append one line to drop_log.tsv with these columns:
filter_name, threshold, n_removed, n_removed_per_group, example_ids (up to 5).
Never remove records without writing a line. If a step removes zero records, still
write the line with n_removed=0.
```

The arithmetic that has to close:

```
rows_in  =  rows_out  +  sum(drop_log.n_removed)
```

If those two sides do not match, something removed records without logging them, and
you have found a real bug in your own pipeline before it reached a figure. Do not
adjust the expected count. Find the step. The usual culprit is a join that dropped
non-matching rows, and the usual cause is whitespace or capitalisation in a key.
