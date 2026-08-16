# Chapter 5 — Reconcile your cleaning

The cleaning is the easy part and the model is good at it. This folder is the check
that stops "faster" from quietly becoming "wrong".

## What you build

A before-and-after record where every difference is accounted for. Snapshot first,
clean second, reconcile third, and never two of those in one pass.

| File | What it is |
|---|---|
| `snapshot.py` | The book's script, plus `--id-column` and `--out`. Reads every column as a string so the snapshot records the file rather than a guess about it. |
| `00_clean.py` | **This repo's minimal implementation of the Chapter 5 spec, not book text.** The book names `scripts/00_clean.py` three times and never prints it. |
| `profile-prompt.md` | For data you did not generate. Asks for anomalies and questions, never for a cleaned file. |
| `droplog-prompt.md` | The reason log. `verify.sh` row 4 sums column 3 of what this produces. |
| `reconciliation.example.txt` | The book's worked report, to diff your run against. |
| `skills/data-cleaning-verify/` | The Skill that carries all of it into every session. |

## The one command

From the repo root:

```bash
cd chapters/05-reconcile-your-cleaning
python3 snapshot.py fixtures/cohort_2_v3.csv --out before.json > /dev/null
python3 00_clean.py --raw fixtures/cohort_2_v3.csv \
                    --counts fixtures/cohort2_counts.tsv \
                    --snapshot before.json --outdir runs/demo \
                    --fillna timepoint=0 \
                    --spot-check S002,S019,S044,S070,S088 \
                    --label "cohort_2 metadata + counts" \
  | diff - reconciliation.example.txt && echo "matches the book, line for line"
```

That diff is empty. The report the script computes from the shipped 96-row fixture is
byte-identical to the one printed in the chapter, including `VERDICT: FAIL`.

`snapshot.py` wants `pandas`, which is in `environment.yml` and which the book has you
install. Without it you get one line naming the missing package rather than a
traceback. `00_clean.py` is standard library only.

## What success looks like

Read the verdict line and then read everything above it. The counts reconcile, 91 plus
5 is 96. The spot check passes. The removals are balanced, 6.7 percent against 3.9
percent. And it still fails, on two things nobody would have noticed: twelve patient
IDs lost their leading zeros when the column was coerced to an integer, and two missing
timepoints became values with no filter claiming responsibility.

A run that reconciles on counts and fails on types is the normal outcome, not the
exception. That is what the artifact is for.

Both of those defects are in `00_clean.py` on purpose. Coercing an identifier to an
integer and filling a missing value with zero are things people do every week, and a
detector you haven't watched fire is a belief.

Then break it, which takes ten seconds:

```bash
sed -i '' '2d' runs/demo/drop_log.tsv   # delete the logged removal
```

Rerun and the arithmetic no longer closes. A check that still says PASS after that is
not a check.

## Your own CSV

```bash
python3 snapshot.py ~/data/my_metadata.csv --id-column "Sample ID" --out runs/r1/before.json
python3 00_clean.py --raw ~/data/my_metadata.csv --counts ~/data/my_counts.tsv \
                    --snapshot runs/r1/before.json --outdir runs/r1 \
                    --id-column "Sample ID" --group-column treatment \
                    --coerce subject_id=str --coerce visit_date=datetime
```

`--coerce COL=TYPE` is the important one. It is where you say what you meant the column
to be, and the report flags any coercion whose result can no longer reproduce the
string that was in the file. Leading zeros in identifiers are the classic case and the
fix is always the same: read the column as a string and keep it a string forever,
including in every file you write out.

`python3 00_clean.py --help` lists the rest.

## Where before.json goes, and why it is an argument

The printed script writes `before.json` into the current directory, and `verify.sh`
reads it from there. Everything else the book builds is run-scoped: outputs live under
one run directory and travel with the config that made them.

Run two configs in sequence and the second overwrites the first's before-state.
Rubric row 4 then reconciles run B's output against run A's input and closes perfectly.
Nothing printed in the book catches it.

So `--out` exists, it defaults to the printed behaviour, and `verify.sh` prefers
`$RUN/before.json` when it finds one and says which file it read. Put the snapshot in
the run directory the moment you have a second config.

The other thing the snapshot cannot survive is being taken late. It has to be the first
thing that touches the raw file. Snapshot the file you were given, not the file you are
working with, or the check compares a corrupted state to a corrupted state and reports
everything fine.
