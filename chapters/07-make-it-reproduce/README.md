# Chapter 7 — Make it reproduce

Your Chapter 6 script ran today. That is genuinely all you established. It ran on your
machine, against whatever versions of whatever packages happened to be installed, and
none of those three facts is written down anywhere.

## The DAG

`Snakefile` is the chapter's, transcribed: five rules, and not one of them says what
order to run in. `filter_counts` needs `final_table.tsv`, only `clean` makes it,
therefore `clean` runs first. The order is a consequence rather than an instruction,
and that is the whole idea.

`environment.yml` is what you asked for, written by hand. Never paste the output of
`conda env export`; it dumps hundreds of transitive dependencies pinned to your
machine's architecture and produces a file nobody can read or reuse.

![The DAG and the frame around it. Four rules in a left-to-right chain, clean then filter_counts then differential_expression then enrichment, with the file each arrow carries written above it: final_table.tsv, filtered_counts.tsv, de_results.tsv. Underneath the chain, the sentence that explains the order: filter_counts needs final_table.tsv, only clean makes it, therefore clean runs first. A bar above the chain reads config.yaml, every threshold in one file. A bar below reads conda-lock.yml, every package with a checksum. A border encloses the whole arrangement, labelled seed: 42.](../../images/ch07-dag.png)

## The dry run

```bash
snakemake -n -s chapters/07-make-it-reproduce/Snakefile \
             -d chapters/07-make-it-reproduce/fixtures \
             --configfile chapters/07-make-it-reproduce/fixtures/config.yaml
```

```
Job stats:
job                        count
-----------------------  -------
clean                          1
filter_counts                  1
differential_expression        1
enrichment                     1
all                            1
total                          5
```

Exit 0, five rules, no conda and no R involved. This is the first of the two gates the
vendor's own Nextflow Skill enforces and this book adopts: the environment check must
pass, then the test profile must pass, and both of them sit before your real data is
touched. If the dry run can't build the graph, no amount of compute will help.

Do not drop the `-d`. Paths in a config are relative to the working directory, not to
the Snakefile, so without it you get `MissingInputException` on files that are sitting
right there.

## The equivalence check

Two run directories and a tolerance:

```bash
bash chapters/07-make-it-reproduce/equivalence-check.sh \
     chapters/07-make-it-reproduce/fixtures/runA \
     chapters/07-make-it-reproduce/fixtures/runB \
     0.000010
```

```
TOP-100 GENE LIST: identical
max |log2FC| difference: 0.000003
tolerance recorded in advance: 0.000010
WITHIN TOLERANCE
```

Exit 0. Pass a tighter tolerance and it exits 1 without touching the data, which is the
demonstration: the verdict lives in the number you committed to, not in the run.

Write that number into the repo before you look at the results. A tolerance chosen
after seeing the difference is not a tolerance, it is a rationalisation.

The bar is not byte-identical output. Nobody has established when a bioinformatics
pipeline is byte-reproducible and plenty of legitimate steps are not.

## Where the files sit, and why

Snakemake resolves `conda:` and `script:` relative to the Snakefile. The chapter's
Snakefile says `conda: "environment.yml"` and `script: "scripts/01_filter.R"`, and
Chapter 10's tree puts the Snakefile at `workflow/Snakefile` with `environment.yml` and
`scripts/` at the project root. Those two cannot both be right.

This repo puts `environment.yml` and `scripts/` beside the Snakefile, which is what
makes the dry run above actually resolve. If you use Chapter 10's layout, move them
with it or the `conda:` lines point at nothing.

`scripts/00_clean.py` is a symlink to the Chapter 5 file. One copy, and the DAG finds
it where the Snakefile expects it.

## What is missing on purpose

**`conda-lock.yml`.** Generating one requires a conda solve on your platforms. Writing
one by hand would mean inventing per-package checksums in the companion to the chapter
that exists to explain why checksums matter, so there is no lockfile here and there
never will be. Yours:

```bash
conda-lock -f chapters/07-make-it-reproduce/environment.yml -p osx-64 -p linux-64 -p osx-arm64
conda-lock install -n cohort2-verify conda-lock.yml
```

Open it and find one package. Confirm it has a version, a URL and a hash. That takes
fifteen seconds and it is the moment the abstract idea becomes a file. One naming
detail that will cost you an hour: the unified lockfile has to keep the
`.conda-lock.yml` extension. `env.lock` looks tidier and stops working.

**The three R steps.** `01_filter.R`, `02_de.R` and `03_enrichment.R` are named by the
book and never printed by it, and this repo is not going to invent a DESeq2 pipeline
the book does not describe. The stubs read your config and print the parts of the
Chapter 6 read-through that belong in code, then stop with a named error. Generate the
real ones from `../06-move-it-into-a-file/script-request-prompt.md`, which is what the
book has you do.

## Your own pipeline

Convert each step of your Chapter 6 script into a rule declaring its inputs and
outputs. Do not move any logic into the workflow file; the R and Python stay where they
are. You are describing dependencies, not rewriting analysis.

Then the part that proves something: install from your lockfile into a clean
environment on a machine that never saw your original one, rerun, and compare with the
equivalence check.

Then the test that actually counts. Send it to a colleague on a different operating
system with one instruction, install from the lockfile and run it, and do not answer
questions for the first hour. If they get your top-100 gene list, you have something
real. If they hit a wall, that wall is a gap you would otherwise have found during peer
review, at much higher cost and in front of a much less friendly audience.

## Five things a lockfile does not pin

Reference data and annotation versions. Thread count. Hardware and the numerical
libraries under it. Anything stochastic you did not seed. Timestamps and path ordering.

There is a sixth that defeats more reproducibility efforts than the other five
combined, and it is not technical: the manual step. The one where you open the results
in a spreadsheet, fix a label and save. A pipeline with one manual step in the middle
is not a pipeline, it is two pipelines with a rumour between them.

None of that is a reason to skip the lockfile. It is why the lockfile is necessary and
not sufficient, and why the strong answer to "is this reproducible" names its own
limits: the software is locked and checksummed, the reference data is versioned and
hashed, the seed and thread count are in the config, and here is the tolerance at which
two independent runs agreed. That answer is much harder to attack than "yes".
