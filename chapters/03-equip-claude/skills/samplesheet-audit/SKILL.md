---
name: samplesheet-audit
description: Audits an experimental sample sheet for confounded designs and missing
  controls before any analysis runs. Use whenever a sample sheet, metadata table, or
  design matrix is provided, or before running differential expression, classification,
  or any grouped comparison.
---

# Sample sheet audit

Run this before any analysis that compares groups. Report findings; do not fix
anything silently.

## Steps

1. List every column and classify it as biological (the variable of interest),
   technical (batch, plate, run, prep date, operator, instrument), or identifier.
   If a column's role is ambiguous, ask rather than assume.

2. Cross-tabulate every technical column against the biological column of interest.
   Print each crosstab in full.

3. Flag any crosstab cell containing zero. A zero means that technical level appears
   in only one biological group, and the two are confounded. State plainly which
   variables are confounded and that no downstream analysis can separate them.

4. Report the count of samples per biological group. Flag any group with fewer than
   three.

5. List the samples that appear to be positive or negative controls, by name. If none
   are identifiable, say so explicitly as a finding rather than continuing.

6. Compare the number of rows in the sample sheet against the number of data files
   or columns in the matrix. Report both numbers even when they match.

## Output

A short report with: the classification table, every crosstab, the confound findings,
the per-group counts, the named controls, and the row-count reconciliation. End with
either PROCEED or a numbered list of blocking issues. Never say PROCEED when a
crosstab contains a zero.
