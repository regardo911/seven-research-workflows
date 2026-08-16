#!/usr/bin/env Rscript
# 02_de.R — STUB. Named by the book, never printed by it.
#
# The one thing it does is the defence against the bug that costs the most: it makes
# the script state its own interpretation of the contrast in English, so you can
# compare it against the config in English instead of mentally evaluating an argument
# order. A reversed contrast produces a beautiful, publishable, exactly-backwards
# figure, and reading c("condition", "control", "treated") silently will not catch it,
# because your brain supplies the order you intended.
#
# It also prints the covariate structure, because a covariate that is in your
# samplesheet and not in your model is a question nobody will ask you.

if (exists("snakemake")) {
  cfg   <- snakemake@config
  sheet <- snakemake@input[["sheet"]]
} else {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) stop("usage: Rscript 02_de.R <config.yaml>", call. = FALSE)
  cfg   <- yaml::read_yaml(args[1])
  sheet <- file.path(cfg$paths$outdir, "final_table.tsv")
}

ref <- cfg$design$reference_level
num <- trimws(strsplit(cfg$design$contrast, " vs ")[[1]][1])
message(sprintf("Contrast: %s relative to %s. Positive LFC = higher in %s.", num, ref, num))
message(sprintf("Read that against the config, which says: %s", cfg$design$contrast))

covs <- cfg$design$covariates
message(sprintf("Covariates in the model: %s",
                if (length(covs)) paste(covs, collapse = ", ") else "none"))

tab <- read.delim(sheet, colClasses = "character", check.names = FALSE)
unused <- setdiff(names(tab), c(cfg$design$condition_column, unlist(covs)))
message(sprintf("Columns in the samplesheet that are not in the model: %s",
                paste(unused, collapse = ", ")))
message("Any technical variable in that list is a covariate you have decided not to model.")

stop(paste("NOT IMPLEMENTED: 02_de.R.",
           "Generate it from chapters/06-move-it-into-a-file/script-request-prompt.md",
           "and check the contrast direction against the line printed above."), call. = FALSE)
