<!-- Chapter 12, transcribed verbatim. Two rules for the whole plan: every milestone
     attaches to a real project you are working on right now, and every milestone
     produces a file rather than an understanding. Replace every generic noun below
     with a real one. A milestone that names no real artifact is a wish. -->
# plan-30.md

Day numbers, not calendar dates, so the plan survives being started whenever you
actually start it.

## Week 1: get connected, and get one verified output

**Day 1.** Setup, and it genuinely is one afternoon. Add the marketplace. Install
PubMed plus two connectors for your field. Configure credentials for the two that need
them and restart. Write one Skill for a task you already repeat, and run `agentskills
validate` against it until it exits 0. If you do nothing else this week, do this,
because everything downstream assumes it.

**Days 2 to 4.** One real literature review, on a question from the project on your
desk. Build the `citation-check` Skill. Run the review. Then plant two fakes in your own
reference list, one invented outright and one real paper with a single field corrupted,
and confirm your workflow catches both and names which field is wrong. The planted
corruption is the one that proves the workflow; the invented reference proves nothing.

**Days 5 to 7.** Clean one real dataset. Snapshot the before-state as the first thing
that touches the raw file. Demand a drop log with a reason per removal. Reconcile.
Expect it to fail the first time on a dtype you did not know had changed, and treat
that as the check working rather than as a setback.

By the end of Week 1 you have a validated Skill, a verified reference list, and a
dataset whose every removed record is accounted for.

## Week 2: get it out of the chat and make it repeat

**Days 8 to 11.** The config and the script, for the task you repeat weekly. Write the
config by hand first, before you ask for any code. Do the six-item read-through before
you run it on real data. Run it once on a deliberately broken config and confirm it
fails loudly and leaves nothing behind.

**Days 12 to 14.** Wrap it into a DAG. Author `environment.yml` by hand rather than
exporting one. Generate `conda-lock.yml` for every platform anyone on your project uses.
Pass the dry run and the small test run before real data, in that order. Then the part
that proves it: install from the lockfile into a clean environment and rerun, and
compare against a tolerance you wrote down before you looked.

By the end of Week 2 the thing runs from one command, and it runs the same way
somewhere else.

## Week 3: make it defensible

**Days 15 to 19.** The rubric and the reviewer Skill. Take the right-hand column of the
trust boundary you wrote in Chapter 2 and turn each row into an assertion that
terminates in an external fact. Move every mechanical row into `verify.sh` so it runs
without a model at all. Then plant an error, run it, and watch it produce HOLD with the
specific row named. Then look at the sabotaged run yourself, without the rubric, and
find out whether you would have caught it. That last step is the one that makes you
keep running the rubric in month four.

**Days 20 and 21.** The runbook's first five rows, and here is where most plans quietly
cheat: execute each recovery once. Break the environment on purpose and restore it from
the lockfile. Remove a control and watch the pipeline assertion fail. A recovery you
have never run is a plan, and plans behave differently under pressure.

By the end of Week 3 your work fails loudly when it should, and you know what to do
when it does.

## Week 4: make it count

**Days 22 to 26.** One real publication artifact. Regenerate the figure through the
pipeline rather than reusing the export. Write the methods from files, quoting
thresholds from the config rather than from memory. Fill the disclosure with specific
named tasks, and make the placement decision for your target venue in one written line.

**Days 27 to 30.** Assemble everything into one project with a single entry point, and
run it end to end on last month's work, where you already know what the answer should
be. Then fill the cost model against a named baseline, with a negative section that is
not empty, and show it to one person who will tell you which line they do not believe.

By Day 30 you have a system, and a document that prices it, and a paragraph you can put
in front of a journal.

If you fall behind, fall behind on Week 4. Weeks 1 through 3 are the ones that compound.

## Day 31

Put a reminder in your calendar to re-read your own cost model and your own runbook.
Both will be slightly wrong by then, and both are useless if they go stale.
