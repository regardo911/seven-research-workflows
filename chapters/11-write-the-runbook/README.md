# Chapter 11 — Write the runbook

A runbook is not a list of things that can go wrong. Anyone can write that in ten
minutes and nobody ever reads it. It is a list of things that *have* gone wrong, with
the signal that announced each one and the recovery you have already executed at least
once.

## Seed it, then break something

`runbook.seed.md` is the five rows the author hit, plus the four tells of confident
garbage and the six times the right move is not to use it. `refusals.md` is the log:
one line each, what you asked, which surface, whether a rephrase worked.

Copy both into your project, adapt the paths, then execute every recovery once on
something that does not matter. Break the environment on purpose and restore it from
the lockfile. Remove a control and watch the assertion fail. A recovery you have never
run is a plan, and plans behave differently under pressure.

Mark the Tested column honestly. Three honest NOs beat five dishonest YESes, because
the NOs tell you where you are exposed.

## assert_controls, and the bug in it

`assert_controls.smk` promotes the Chapter 8 rubric row into the pipeline itself, so a
missing control is a hard failure that stops the run rather than a finding you discover
later. That transformation, from a thing you notice to a thing that fails, is the most
valuable pattern in the book.

Read the awk before you trust it. It tests presence:

```awk
$1 == c {found = 1}
```

The rubric row it promotes asserts `count > 0`, and so does `verify.sh`:

```awk
$1 == c && $2 + 0 > 0 {found = 1}
```

A control that reaches the final table at zero passes the DAG gate and fails the
script, in the same project, on the same file. The `.smk` here is transcribed as
printed so it matches the page you are reading. The worked example is the one that is
right. Add `&& $2 + 0 > 0` before you rely on it.

## Your rows

The five seeded rows are the author's. Yours will diverge within a month, and the ones
you add are worth more than the ones you were given, because they are the failure modes
of your actual work.

Then the real check: pick your worst-case row, have someone else trigger that failure
on a copy of your project without telling you which one, and recover from the runbook
alone. If you have to improvise, the row isn't finished.
