# Methods, fixture draft

Illustrative results on synthetic sample data. Nothing in this file describes a real
dataset, and no biology was harmed in its production.

Raw counts were filtered to retain genes with at least 10 counts in a minimum of 3
samples. Of 96 submitted samples, 91 were retained (n = 91); 5 were removed at the
metadata join due to trailing whitespace in the sample identifier, and the removals
were balanced across conditions. Differential expression was performed with batch
included as a covariate, contrasting treat relative to ctrl, at an adjusted p-value
cutoff of 0.05 and a log2 fold-change cutoff of 1.0. The run was seeded at 42.
