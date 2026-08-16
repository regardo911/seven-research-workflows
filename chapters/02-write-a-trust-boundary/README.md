# Chapter 2 — Write a trust boundary

Nothing in this folder runs. That is the point of it: the artifact is a decision you
make before you touch anything, and a decision is not a program.

## What you build

`trust-boundary.md`, in two columns. What you let Claude do without checking, and what
always gets checked by you. Minimum five rows each.

One rule makes it a real artifact rather than a resolution: every row in the
unsupervised column carries a detection method that resolves outside the model. A
count. A checksum. A resolvable identifier. A control's presence. If the only way you
would catch the error is "I would probably notice", the row belongs in the other
column.

| File | What it is |
|---|---|
| `trust-boundary.blank.md` | The shape, with the gate stated. Copy this one. |
| `trust-boundary.filled.md` | The author's, for bulk RNA-seq differential expression. A shape to copy, not an answer. |

## Success looks like

You wrote a row, read it back, asked "what fact outside this conversation would tell me
this went wrong", could not answer, and moved the row to the right-hand column. That
reshuffle is the exercise. A boundary where nothing moved is a boundary you wrote to
agree with yourself.

## On your own project

```bash
cp chapters/02-write-a-trust-boundary/trust-boundary.blank.md ~/my-project/trust-boundary.md
```

List the ten to fifteen computational tasks in your actual week. Not aspirational ones.
The ones you did last week. Sort them, fill both columns, and keep the file open.

It gets used twice more. In Chapter 8 the right-hand column becomes the rows of your
verification rubric, and the file itself gets copied into the reviewer Skill's
`references/` so the workflow reads it instead of relying on you to remember. In
Chapter 11 it seeds your failure runbook.

That is also why it is worth writing before you do the work rather than after. A
document specifying what you would and would not delegate, dated earlier than the
analysis, is evidence of intent. Anyone can describe a careful process in hindsight.
