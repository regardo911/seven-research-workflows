# Chapter 10 — Assemble the system

Eight chapters of artifacts are things you did. One entry point makes them one thing
you have.

## Assemble it

`system-tree.md` is the layout, chapter-annotated, and the important property is not
the layout. It is that nothing in it lives inside a conversation.

Move every artifact you have built into it. This is a genuinely tedious hour and it is
the hour that turns nine exercises into one tool. Then write `connectors.md` (Chapter
3) with the account column filled in, because in four months when a connector fails,
that file is what tells you whether it is a credential problem.

## go.sh, as printed, including the line that contradicts the book

`go.sh` is four lines of actual work: snapshot, then the DAG, then the mechanical
rubric rows, then an echo that stops and tells you to run the reviewer Skill.

That last echo is deliberate. The mechanical rows run automatically because they are
arithmetic. The rows that need reading comprehension stay a separate, conscious step,
because a review you did not notice happening is a review you will stop reading.

It needs `yq`, Snakemake, conda and R, so it doesn't run in this repo. What does run
is its pre-flight:

```bash
env PATH=/usr/bin:/bin bash chapters/10-assemble-the-system/go.sh /dev/null
```

```
MISSING TOOL: yq (needed to read /dev/null)
```

Exit 1, before it touched anything.

Now read line 3. `snakemake --use-conda --configfile "$CONFIG" -j 4` hardcodes the
thread count, in a chapter about assembling the system honestly, four chapters after
the rule that thread counts belong in the config like every other parameter and get
recorded. It is also exactly what read-through item four asks about: did anything get
hardcoded that should be a parameter?

It is shipped as printed, because silently rewriting the book's own entry point would
leave you with a file that does not match the page you are reading. Move the 4 into
your config the first time floating-point summation order matters to you, which is the
first time a gene lands near a significance boundary.

## The model

`cost-model.filled.md` is the author's worked example, labelled as such at the top of
the file. The hours in it are described in the book as a plausible set so you can see
the shape and the arithmetic. They are not a measurement, and they are not a claim
about what this will do for you.

`cost-model.blank.md` is yours.

Four things make it survive a skeptical reader: it has a negative section, it totals
per quarter rather than per year, every rate cites something, and it does not claim any
discovery. If your negative section is empty you have not been honest, because this
system does cost time.

Two numbers you will not find in either file. There is no academic or nonprofit
discount figure, because the product page carries no discount terms, no percentage and
no eligibility rule, only a contact-sales link. And there is no productivity multiplier.
No 10x, no "three times faster". Those cannot be sourced, they will be challenged, and
the challenge is trivially easy to win.

## Your own numbers

Run `./go.sh config.yaml` on last month's work. Not a toy dataset. A real thing you
already did, where you know what the answer should be, so a wrong answer is visible.
You are the positive control.

Then fill the model against a named baseline, from your own calendar, and show it to
one person before you show it to the person who matters. Ask them which line they do
not believe. That line is the one that will be challenged, and you get to fix it in
private.

## How this goes wrong, which is quietly

Not that the system breaks. That it keeps working and you stop reading it.

Month one you read every reconciliation line. Month two they have passed eleven times
in a row, so you skim. Month three you are looking at the last line, the one that says
RELEASE or HOLD, and nothing above it. Month five a HOLD appears, you decide it is
probably the same inconclusive row as last time, and continue. At that point you have
built an elaborate apparatus for producing a word you no longer read.

Two dull fixes, and they work. Make a passing check cost you something small: the
reviewer Skill is instructed to print the values it compared even when a row passes,
which reads like a pointless requirement until you have skimmed a green line for three
months. And schedule a deliberate failure once a quarter, sabotaging a run the way you
did at the Chapter 8 checkpoint, to confirm the system still catches it after however
many changes you have made.
