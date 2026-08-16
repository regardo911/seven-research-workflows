#!/usr/bin/env Rscript
# 03_enrichment.R — STUB. Named by the book, never printed by it.
#
# It prints the cutoffs it would apply and then names the assumption nobody thinks to
# put in a config: the organism. Most enrichment examples on the internet are human,
# so a generated script reaches for org.Hs.eg.db. Run that on mouse and roughly half
# your identifiers fail to map silently, the mapped subset proceeds happily, and you
# get a smaller gene list and a plausible result. No error anywhere.
#
# Two function names worth having, from Chapter 6. The enrichment dot plot is
# dotplot(edo, showCategory=30, label_format=NULL). There is also volplot(edo) in the
# same package, and it is a volcano plot OF OVER-REPRESENTATION RESULTS, not a
# differential-expression volcano. The names collide in the worst possible way.

if (exists("snakemake")) {
  cfg <- snakemake@config
} else {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) stop("usage: Rscript 03_enrichment.R <config.yaml>", call. = FALSE)
  cfg <- yaml::read_yaml(args[1])
}

message(sprintf("padj cutoff: %s", cfg$thresholds$padj_cutoff))
message(sprintf("lfc cutoff:  %s", cfg$thresholds$lfc_cutoff))
message(sprintf("seed:        %s", cfg$seed))

if (is.null(cfg$design$organism)) {
  message("organism: NOT IN THE CONFIG.")
  message("  Anything that is a property of your experiment and is not in your config")
  message("  is an assumption somebody else made for you. Add it before you map IDs.")
}

stop(paste("NOT IMPLEMENTED: 03_enrichment.R.",
           "Generate it from chapters/06-move-it-into-a-file/script-request-prompt.md.",
           "Say which volcano you want when you ask."), call. = FALSE)
