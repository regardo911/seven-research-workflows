<!-- Chapter 11, transcribed verbatim. Five rows the author hit. Copy it into your
     project as runbook.md, adapt the paths, then execute every recovery once on
     something that does not matter. Rows you add are worth more than these five. -->
# runbook.md

| # | Failure mode | Detection signal | Recovery | Tested |
|---|---|---|---|---|
| 1 | Biology guardrail false positive | Refusal on a legitimate analysis request | Reframe around the analysis, not the organism; move the task to Claude Code; log the phrasing in refusals.md | YES |
| 2 | Positive control vanished | Control ID absent from final_table.tsv, or count 0 | `snakemake --cores 1 assert_controls` fails; restore control to samplesheet, rerun from the clean step | YES |
| 3 | Confident garbage | Result improved with no data change; unrequested step in log; runtime dropped sharply | `diff runs/<last-good>/config.used.yaml config.yaml`; `git diff`; run verify.sh BEFORE looking at results | YES |
| 4 | Environment drift | Pipeline that ran last month now fails, or numbers moved | `conda-lock install -n rescue conda-lock.yml`; rerun; compare against recorded tolerance | YES |
| 5 | Reference passes existence, fails metadata | citation-check reports metadata mismatch | Open the actual paper; correct year/authors/journal; if the claim does not survive, cut the sentence | YES |

Four fields, and the third one is what separates this from a wish list:

- **Failure mode.** What broke.
- **Detection signal.** What it looked like, specifically enough that you would
  recognise it at 6pm.
- **Recovery action.** The commands. Not a description of an approach.
- **Tested?** Yes or no. Honestly.

Mark the Tested column honestly. A runbook with three honest NOs is more useful than
one with five dishonest YESes, because the NOs tell you where you are exposed.

Then the real check: pick your worst-case row, have someone else trigger that failure
on a copy of your project without telling you which one, and recover from the runbook
alone. If you have to improvise, the row is not finished.

## The four tells of confident garbage

Row 3's detection signals are behavioural rather than technical. You do not need to
spot the bug; you need to notice the tell and stop.

- **The result got better and you did not change the data.** The strongest single
  signal there is. Real biology does not improve because you reran it.
- **A step appeared in the log that you did not ask for.** Read your logs after a
  troubleshooting session, not during.
- **It apologised and then produced the same bug.** The session has stopped
  converging. Start fresh and bring the specific file, not the conversation.
- **The runtime dropped sharply.** Either something got much more efficient, which is
  rare and would have been mentioned, or something is no longer being done.

The recovery is the same for all four and it is deliberately mechanical, because the
moment you notice one is the moment you are most tempted to look at the output and
reassure yourself.

## Six times the right move is not to use it

1. The material is somebody else's, under review. This is a rule, not a risk
   calculation. See DISCLAIMER.md.
2. The data is identifiable or restricted, under an MTA, embargoed, or the consent form
   did not anticipate this.
3. You cannot evaluate the output and nobody nearby can either. The rubric checks that
   your analysis did what you specified; it cannot tell you that what you specified was
   wrong. The move is to find a person.
4. You are up against a deadline and cannot verify. Under time pressure people generate
   more and check less, which is exactly the wrong direction.
5. You are trying to learn the thing. If you automate the first time, you never build
   the calibration that tells you whether an output is reasonable.
6. It has refused three times and you are starting to negotiate. On attempt six,
   getting creative about how to describe your own experiment, stop and do that piece by
   hand. The cost of that decision is an hour. The cost of the alternative is a habit.
