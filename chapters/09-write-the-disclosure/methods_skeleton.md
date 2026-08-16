<!-- Chapter 9. The shape, not the text. Every clause below names the file it came
     from. Write yours with the run directory open; if you type a number you have not
     looked up, stop and look it up. -->
# Methods skeleton

The ordering is the trick: **the methods section is downstream of the checks, not
parallel to them.** Every number comes out of a file, every threshold is quoted from
the config rather than recalled, and every citation has already passed the metadata
comparison.

| Clause | The file it comes from |
|---|---|
| Filtering thresholds | `config.used.yaml`, `thresholds.*` |
| Samples submitted, samples retained, what removed the rest | the reconciliation: `before.json`, `drop_log.tsv`, `final_table.tsv` |
| Removals per group | `drop_log.tsv`, the per-group column |
| Covariates and contrast direction | `config.used.yaml`, `design.*`, and the sentence your script printed into its own log |
| Workflow and environment | the Snakefile, `conda-lock.yml` |
| Seed | `config.used.yaml`, `seed` |
| Independent reproduction and its tolerance | the equivalence check, and the tolerance you wrote down first |

Here is the author's, assembled from exactly those artifacts:

> Raw counts were filtered to retain genes with at least 10 counts in a minimum of 3 samples (`config.used.yaml`, `thresholds.min_count_per_gene`, `thresholds.min_samples_expressed`). Of 96 submitted samples, 91 were retained; 5 were removed at the metadata join due to trailing whitespace in the sample identifier, and the removals were balanced across conditions (3 control, 2 treated). Differential expression was performed with batch included as a covariate, contrasting treated relative to control, so that positive log2 fold changes indicate higher expression in treated samples. The analysis was executed as a fixed-DAG workflow against a multi-platform locked environment (`conda-lock.yml`, per-package checksums), seeded at a value recorded in the run configuration. The pipeline was independently re-executed from the lockfile on a separate machine; the top 100 differentially expressed genes were identical and the maximum absolute difference in log2 fold change between runs was below the tolerance recorded in the repository.

Read it next to what most methods sections say, which is some arrangement of
"differential expression analysis was performed using standard parameters". A reviewer
cannot check that sentence. They can check every sentence above, and the fact that they
can is itself the argument.

One caution when drafting prose with a model here: it will happily write a fluent
methods section containing plausible numbers. Use the inline source marker from Chapter
4, and let the rubric row that greps every prose number against the run directory be
the backstop.
