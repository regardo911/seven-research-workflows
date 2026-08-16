# Chapter 6 — Move it into a file

Anything that changes between runs goes in a config file, and anything that does not
goes in the script. That is the whole design principle and almost nobody does it,
because when you are moving fast it is quicker to type the path into the script.

The cost arrives later, when a reviewer asks what threshold you used and the honest
answer is that it is on line 340 of a bash script, hardcoded, and there were four
versions of that script.

## The two files

`config.yaml` holds five categories, and each one is there because leaving it out has
bitten somebody: paths, thresholds, contrasts, the seed, and run identity. Both files
here are the chapter's, transcribed.

`run_analysis.sh` reads it. Three properties matter more than elegance: it fails loudly
on a missing input before doing any work, it writes everything under one run directory,
and it copies the config it ran with into that directory so the outputs and the
parameters can never be separated.

Two lines do most of the work. `set -euo pipefail` turns bash from a language that
continues cheerfully after a failure into one that stops. And `cp "$CONFIG"
"$OUTDIR/config.used.yaml"` is the one that saves you in month six, because configs get
edited and outputs get kept.

## Running it

`run_analysis.sh` needs `yq`, `Rscript`, and the three step scripts. The step scripts
are in `../07-make-it-reproduce/scripts/` and they are stubs: they read your config,
print the read-through items that belong in code, and stop with a named error rather
than inventing an analysis the book never printed.

So this one doesn't run end to end here, and pretending otherwise would be the
failure this repo is against. What runs is the failure path, which is the half of the
checkpoint people skip:

```bash
cd chapters/06-move-it-into-a-file
sed 's|data/cohort2_counts.tsv|data/nope.tsv|' config.yaml > /tmp/broken.yaml
bash run_analysis.sh /tmp/broken.yaml; echo "exit=$?"
```

```
MISSING INPUT: counts -> data/nope.tsv
exit=1
```

No output directory was created. If yours creates the directory and then fails halfway,
the failure handling is in the wrong order and you will eventually get a half-populated
run directory that looks complete.

## Read it before you run it

`read-through.md` is six questions and three real bugs. All three run clean, none of
them errors, and none of them is a coding mistake: what is wrong in each case is a
decision made silently by something that does not know which organism you work on,
which direction you care about, or that the slice was temporary.

Do the read-through before you run on real data. Reading a script that has not produced
a result yet is a neutral activity. Reading one that has already produced a result you
like is not, because you will be reading to confirm.

## One thing the printed config sidesteps

The chapter tells you to name your positive and negative controls in `design.controls`,
by identifier. The rubric in Chapter 8 asserts that every named control appears in the
final table with `count > 0`.

A negative control legitimately reads at or near zero. List one there and you get a
FAIL that is not a failure. The printed config lists positives only, and so do the
fixture configs in this repo. If you want negative controls asserted, they need a
different assertion, and inventing a two-list schema the book never printed would be
worse than saying this out loud.

## Your own task

Pick the thing you did three times last month. Not the most interesting one, the most
repeated one.

Write the config first, by hand, before you ask for any code. Ten minutes on your own,
listing every path, every threshold, every contrast, the seed and a run name. Doing
that first changes what you get back, because you are now specifying rather than
describing. Then hand over `script-request-prompt.md`, which asks for properties rather
than for code.

Then the two-run test, which is the actual point of the chapter: change one threshold,
change the run name, run it again. Two run directories, two configs, two sets of
outputs, zero edits to the script. If you had to touch the script between the two runs,
something that should be a parameter is still hardcoded.
