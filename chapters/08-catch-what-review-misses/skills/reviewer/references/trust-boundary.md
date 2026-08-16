<!-- The Skill's copy. Step 5 of SKILL.md reads this file and names any task in the
     always-verified column as needing your sign-off. Replace it with your own; the
     author's bulk RNA-seq boundary is a shape to copy, not an answer. -->
# trust-boundary.md — bulk RNA-seq DE

## Unsupervised (with detection method)

| Task | Why | Detection method (resolves outside the model) |
|---|---|---|
| Reformat sample metadata into a samplesheet | Mechanical transform, no biology | Row count in == row count out; every FASTQ path exists on disk |
| Write the config/YAML for a known pipeline | Config is the model's strongest surface | Pipeline's own test profile runs clean before real data |
| Rename/relabel columns, fix delimiters, fix encodings | Deterministic string work | Column set diff before/after is exactly the rename map |
| Draft a plotting script from a spec I wrote | Plotting is checkable by eye + by data | Regenerate plot from raw counts; spot-check 3 genes by hand |
| Summarise a paper's methods section I already have open | I have the source in front of me | Every claim traceable to a line I can point at |

## Always verified by me (never unsupervised)

| Task | Why | What I check |
|---|---|---|
| Which samples are replicates vs conditions | Wrong grouping = wrong biology, perfect code | Design matrix read aloud against the bench notebook |
| Normalisation choice and filtering thresholds | Silently changes every downstream number | Thresholds stated explicitly; sample-level counts before/after |
| Any citation in any draft | Fabrication + Frankenstein citations | Every DOI/PMID resolved; year + authors + journal compared |
| Presence of positive and negative controls | Silent deletion is invisible in the output | Controls named in the config and present in the final table |
| Biological interpretation of an enrichment result | This is the actual science | My own reading of the pathway, against my own hypothesis |
| Train/test splits in any predictive model | Leakage inflates everything | Group IDs compared across splits; zero patient overlap |
