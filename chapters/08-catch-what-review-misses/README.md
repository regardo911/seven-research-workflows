# Chapter 8 — Catch what review misses

The load-bearing chapter, and the longest folder in this repo for that reason.

There are two published results that rule out the obvious design. Language models do
not reliably self-correct without external feedback and sometimes get worse after
trying, and a model grading output that came from a model scores it too generously.
Together those describe "open a fresh session and ask it to review" as the failure
case.

So the fix is not a second opinion. It is external ground truth. Your reviewer is not
a smarter reader, it is a checklist runner, and every row terminates in a fact that
exists outside the conversation.

The test for whether a row belongs: if the verdict could change because the model felt
differently today, it is not a rubric row.

## The rubric

`skills/reviewer/references/verification-rubric.md` is the ten rows, transcribed. Six
fields each, and the fields are not negotiable.

There is one copy of it, and it sits inside the Skill on purpose. The chapter has you
write the rubric and then copy it into `references/`, which leaves you with two files
that have to agree; the one that runs is the one in `references/`, so that is the one
that is here and the one you edit.

`bad-rows.md` is the four rows the author wrote first, why each one is worthless, and
the rewrite. Read that before you write your own, because you will produce all four.

Verdicts are PASS, FAIL and INCONCLUSIVE. Never RELEASE with an INCONCLUSIVE row, and
never soften a FAIL into a warning. A row whose file could not be read is INCONCLUSIVE,
never PASS.

## The split, and which half needs no model

Rows 1, 2, 3, 4, 6 and 8 are arithmetic over files on disk. They go in `verify.sh`,
where no model is consulted and the check cannot have an off day. Rows 5, 7, 9 and 10
need reading comprehension and stay with the Skill.

That division is the chapter's load-bearing design decision. A reader who does not see
it builds a rubric of opinions.

![The rubric split: six rows that are file arithmetic, four that need reading, and the third verdict. Left column, headed "verify.sh, no model consulted", lists rows 1 patient leakage, 2 site leakage, 3 controls present, 4 row reconciliation, 6 n matches, 8 numbers trace, each with the file it reads. Right column, headed "reviewer Skill, reading comprehension", lists rows 5 correction applied, 7 statistic recomputes, 9 citations resolve, 10 conclusions grounded. Underneath both, a third state labelled INCONCLUSIVE: the file could not be read, which is never a pass.](../../images/ch08-rubric-split.png)

## verify.sh

Rows 3 and 4 are the book's, transcribed. Rows 1, 2, 6 and 8 are the ones the chapter
tells you to add "in the same file on the same pattern", written out so you can read
them instead of reinventing them.

Two details in that file are deliberate and worth copying. Every check prints its
comparison and sets `fail=1` rather than exiting, so one run tells you everything that
is broken instead of the first thing; that is why the shebang line is `set -uo
pipefail` with no `-e`. And every field comparison is `awk`, not `grep -P`, because the
stock `grep` on macOS rejects `-P` outright and a check that errors out looks exactly
like a check that failed.

## Two fixtures, and one of them is broken

```bash
bash chapters/08-catch-what-review-misses/verify.sh \
     chapters/08-catch-what-review-misses/fixtures/run-clean.yaml
```

```
row1  train x test patient overlap: 0
PASS row1  no patient overlap between train and test
row2  train x test site overlap: 0
PASS row2  no site overlap between train and test
PASS row3  control present, count > 0: POS_CTRL_1
PASS row3  control present, count > 0: POS_CTRL_2
row4  before-state read from .../fixtures/run-clean/before.json
row4  96 in = 91 out + 5 dropped
PASS row4  arithmetic closes
row6  draft says n = 91, post-QC rows = 91
PASS row6  reported n equals post-QC n
row8  9 distinct numbers in draft.md, searched .../fixtures/run-clean
PASS row8  every prose number appears in a run file
```

Exit 0. Now the other one:

```bash
bash chapters/08-catch-what-review-misses/verify.sh \
     chapters/08-catch-what-review-misses/fixtures/run-sabotaged.yaml
```

Exit 1, and it names the row that failed and prints the values it compared. It is not
labelled in the fixture and there is no comment marking it, because the exercise is to
run it and read the output rather than to find the plant by eye. Then `diff -r` the two
run directories and see how small the difference was.

Then do the second half of the checkpoint, which is the half people skip: look at the
sabotaged run's outputs the way you would look at a colleague's, without the rubric,
and find out whether you would have caught it.

## Two places this diverges from the printed script, both on purpose

**`before.json`.** The book reads it from the current directory. Every other artifact
is run-scoped, so two configs in sequence overwrite each other's before-state and this
row then reconciles run B's output against run A's input, closing perfectly. `verify.sh`
prefers `$RUN/before.json`, falls back to the printed behaviour, and prints which one
it read.

**Three config keys.** Rows 1, 2, 6 and 8 read files the printed `config.yaml` has no
key for: the sample-to-patient map, the sample-to-site map, and the draft. Chapter 6's
rule is that every path lives in the config, so they are `paths.sample_to_patient`,
`paths.sample_to_site` and `paths.draft`. Leave any of them out and the row that needs
it reports INCONCLUSIVE, which is the honest verdict and not a pass.

Row 2 has a wrinkle the rubric acknowledges and the script cannot. Zero site overlap is
often impossible, because sometimes all your cases come from three hospitals. When that
is true the honest move is not to make the check pass. It is to record that the check
cannot pass and say so in your methods, which is a much better position than
discovering it in review.

Row 6 needs the draft to state its n where a machine can find it, so it looks for
`n = <integer>`. A draft that phrases it any other way comes back INCONCLUSIVE. Write
the number down.

Row 8 is a grep, and the book says so. It is a floor, not a proof: a substring match
means 91 is satisfied by S091. What it catches is the number in your discussion section
that appears nowhere in your outputs, which came from either your memory or the model's
and both need checking.

## The line you must not cross

NIH prohibits its scientific peer reviewers from using natural language processors,
large language models or other generative AI technologies for analyzing and formulating
peer review critiques, because uploading application content violates NIH peer review
confidentiality and integrity requirements.

**The reviewer workflow here audits your own work only.** Never somebody else's grant
application or manuscript under review. Not to summarise it, not to check its
statistics, not "just to see". See DISCLAIMER.md.

## Your own run directory

`skills/reviewer/` goes to `~/.claude/skills/reviewer/`, carrying
`references/verification-rubric.md` and `references/trust-boundary.md` with it. Replace
both with your own before you rely on it: the rubric rows that run are the ones in
`references/`, not the ones in this folder.

Then wire the mechanical rows against your own config:

```bash
bash chapters/08-catch-what-review-misses/verify.sh ~/my-project/config.yaml
```

And then plant an error, because a detector you haven't watched fire is a belief. Pick
one and do not tell yourself which failure you expect it to catch first: move three
samples so a patient appears in both splits, delete the positive control from the
samplesheet, remove one line from your drop log, or change one number in the draft so
it no longer appears in any output file.

Run A returns RELEASE. Run B returns HOLD, and it names the specific row and the
specific evidence. A check that says "something is wrong" produces exactly the same
behaviour as no check at all: you look for two minutes, find nothing, and continue.

## What is not tested

`agentskills validate` checks the reviewer Skill's frontmatter contract. Nothing here
tests its judgment. The rows in `verify.sh` are tested, by the two fixtures above,
because they are arithmetic and arithmetic can be checked.
