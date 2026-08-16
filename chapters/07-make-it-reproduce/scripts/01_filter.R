#!/usr/bin/env Rscript
# 01_filter.R — STUB. The book names this file and never prints it, and this repo is
# not going to invent an analysis the book does not describe.
#
# What it does do is the part of the read-through that belongs in the code rather than
# in your head: print n per group before anything else happens, and print every
# threshold it read out of the config, so a bare number sitting in the script would
# show up as a number that does not appear in this list.
#
# Generate the real one with chapters/06-move-it-into-a-file/script-request-prompt.md,
# then read it with chapters/06-move-it-into-a-file/read-through.md.

if (exists("snakemake")) {
  cfg   <- snakemake@config
  sheet <- snakemake@input[["sheet"]]
} else {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) stop("usage: Rscript 01_filter.R <config.yaml>", call. = FALSE)
  cfg   <- yaml::read_yaml(args[1])
  sheet <- file.path(cfg$paths$outdir, "final_table.tsv")
}

tab <- read.delim(sheet, colClasses = "character", check.names = FALSE)
grp <- cfg$design$condition_column

message("n per group, before anything is filtered:")
print(table(tab[[grp]]))

message("thresholds read from the config:")
for (k in names(cfg$thresholds)) message(sprintf("  %-24s %s", k, cfg$thresholds[[k]]))

stop(paste("NOT IMPLEMENTED: 01_filter.R.",
           "The gene-level filter belongs to you. Every threshold it needs is printed",
           "above and none of them is in this file."), call. = FALSE)
