<!-- Chapter 8. The four rows the author wrote first, why each one is worthless, and the
     rewrite. Read this before you write your own rubric: you will produce all four. -->
# Four rows that look fine and are not

Each of these smuggles a judgment in behind an official-sounding verb. The test is
short and unforgiving: **if the verdict could change because the model felt differently
today, it is not a rubric row.**

## "Check that the statistical approach is appropriate."

Appropriate according to whom? The verdict is entirely an opinion, so it passes when
the model is feeling agreeable and fails when it is feeling cautious.

Rewrite, as four assertions over four files: is the test named in the config; does the
test named in the config match the test actually called in the code; is the correction
method named; are the group sizes above the minimum you wrote down. It does not check
appropriateness, which nothing automated can. It checks that what you claimed you did
is what the code did, which is the part that goes wrong silently.

## "Verify that the conclusions are supported by the data."

The entire job of peer review compressed into one row.

Rewrite, as provenance: every claim in the conclusion traces to either a file in the
run directory or a citation that passed the Chapter 4 metadata check. That does not
tell you whether the conclusion is right. It tells you whether it is grounded, which is
a strictly smaller question with a checkable answer.

## "Confirm there is no data leakage."

Sneakier, because it sounds mechanical. It is not: "no leakage" is unbounded. Leakage
enters through the split, through preprocessing applied before the split, through
feature selection on the full dataset, through tuning on the test set, through a
duplicated sample under two IDs. A model asked to confirm there is none checks the ones
it thinks of and reports clean.

Rewrite, as one row per channel, each naming its files and its set operation. Patient
overlap. Site overlap. Normalisation fitted on training rows only. Feature selection
inside the fold. The ones you cannot check yet are listed as INCONCLUSIVE rather than
absorbed into a green "no leakage detected". An honest list of six rows with two
inconclusive is far more useful than one row that says clean.

## "Ensure the code is correct."

The most tempting and the most useless. Correct against what? A model reading code
produces plausible commentary about it, which reads like verification and is not.

The rewrite is not a rubric row at all, and that is the limit of the whole approach.
Code correctness is caught by the Chapter 6 read-through, by the tiny-input test run
from Chapter 7, and by a positive control whose expected answer you already know. If
you find yourself writing a rubric row to cover something a test would cover, write the
test.

---

What links all four rewrites: the original asked a question that requires
understanding, and the rewrite asks several that require only comparison. You give up
the illusion that the check evaluates your science, and you get a set of assertions
that cannot be wrong about themselves. A rubric that claimed to evaluate your science
would be the easiest thing here for a skeptical colleague to dismiss, and they would be
right.
