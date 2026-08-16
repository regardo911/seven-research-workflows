# seven-research-workflows

**Seven Claude research workflows and the verification layer that proves each one, as
files you own.** Companion repository to the book *Claude for Life Sciences: Build 7
Research Workflows*, from [youcanbuildthings.com](https://youcanbuildthings.com).

In plain words: this is a folder of instruction files and small scripts that make an AI
assistant check its own work against facts on disk, so your results survive somebody
asking where a number came from. Two words you will meet in a minute, *Skill* and
*rubric*, are just a markdown file with rules in it and a checklist whose every row
resolves against a file. You don't need to know either one yet. Start below, at
whichever line describes you.

![The chapter-to-chapter artifact chain. Chapter 2's trust-boundary.md is copied into the reviewer Skill's references directory in Chapter 8. Chapter 5's 00_clean.py produces final_table.tsv and drop_log.tsv, which verify.sh reads for rows 3 and 4, and which go.sh runs in Chapter 10. Chapter 6's config.yaml travels into every run directory as config.used.yaml and supplies the numbers for the Chapter 9 methods paragraph. Chapter 7's conda-lock.yml is what the reproduction claim rests on. Every arrow is one file being handed from the chapter that makes it to the tool that reads it.](images/hero.png)

## Start here

**I finished the book and want the files.**

```bash
mkdir -p ~/.claude/skills && cp -r chapters/*/skills/* ~/.claude/skills/ && bash validate-all.sh ~/.claude/skills
```

```
Valid skill: /Users/you/.claude/skills/citation-check
Valid skill: /Users/you/.claude/skills/data-cleaning-verify
Valid skill: /Users/you/.claude/skills/reviewer
Valid skill: /Users/you/.claude/skills/samplesheet-audit
4 Skills checked, all valid
```

Four directories land in `~/.claude/skills/` and Claude Code loads them in every
session from now on. If you already have a Skill by one of those names, copy them one
at a time instead. `pip install skills-ref` first if `agentskills` is missing; the
package name and the command name are different and that catches everybody once.

**I want to see the verification actually catch something.**

```bash
bash chapters/08-catch-what-review-misses/verify.sh chapters/08-catch-what-review-misses/fixtures/run-sabotaged.yaml
```

Exit 1, naming the row that failed and printing the two values that disagree. Run it
against `run-clean.yaml` for exit 0. One of those two shipped run directories has
something wrong with it and nothing in the fixture says which; that is the exercise.

**I have Claude Code but have not set up the connectors.** Start at
[`chapters/03-equip-claude/install.md`](chapters/03-equip-claude/install.md). Twenty
minutes, one restart, and PubMed needs no account.

**I want to read the code that does the checking.**
[`chapters/08-catch-what-review-misses/verify.sh`](chapters/08-catch-what-review-misses/verify.sh)
is the whole idea in eighty lines.

## The copy table

The fastest path if you followed along. Chapter, the file here, where it goes in your
own project.

| Chapter | In this repo | Where it goes |
|---|---|---|
| 2 | `chapters/02-write-a-trust-boundary/trust-boundary.blank.md` | your project root, as `trust-boundary.md` |
| 3 | `chapters/03-equip-claude/skills/samplesheet-audit/` | `~/.claude/skills/samplesheet-audit/` |
| 3 | `chapters/03-equip-claude/connectors.md` | your project root |
| 4 | `chapters/04-verify-every-citation/skills/citation-check/` | `~/.claude/skills/citation-check/` |
| 5 | `chapters/05-reconcile-your-cleaning/skills/data-cleaning-verify/` | `~/.claude/skills/data-cleaning-verify/` |
| 5 | `chapters/05-reconcile-your-cleaning/snapshot.py`, `00_clean.py` | `scripts/` |
| 6 | `chapters/06-move-it-into-a-file/config.yaml`, `run_analysis.sh` | your project root |
| 7 | `chapters/07-make-it-reproduce/Snakefile`, `environment.yml`, `scripts/` | keep these three together, wherever you put them |
| 8 | `chapters/08-catch-what-review-misses/skills/reviewer/` | `~/.claude/skills/reviewer/` |
| 8 | `chapters/08-catch-what-review-misses/verify.sh` | `scripts/` |
| 9 | `chapters/09-write-the-disclosure/disclosure.md`, `methods_skeleton.md` | `templates/` |
| 10 | `chapters/10-assemble-the-system/go.sh` | your project root |
| 11 | `chapters/11-write-the-runbook/runbook.seed.md` | your project root, as `runbook.md` |
| 12 | `chapters/12-keep-it-in-git/plan-30.md` | wherever you will actually reread it |

## Chapter map

| Chapter | What you build | The command | Success looks like |
|---|---|---|---|
| [02](chapters/02-write-a-trust-boundary/) | The two-column trust boundary | none, it is a decision | five rows a side, every unsupervised row naming a fact outside the model |
| [03](chapters/03-equip-claude/) | Connectors and your first Skill | `bash validate-all.sh` | `4 Skills checked, all valid`, exit 0 |
| [04](chapters/04-verify-every-citation/) | The citation check, three verdicts | `bash chapters/04-verify-every-citation/resolve.sh --fixture 10.1093/bioinformatics/bty560 --year 2019` | `VERDICT: metadata mismatch (year)`, exit 1 |
| [05](chapters/05-reconcile-your-cleaning/) | The integrity reconciliation | `python3 00_clean.py ... \| diff - reconciliation.example.txt` | an empty diff, ending `VERDICT: FAIL` |
| [06](chapters/06-move-it-into-a-file/) | Config plus entry point | `bash run_analysis.sh broken.yaml` | `MISSING INPUT: counts -> ...`, exit 1, no directory created |
| [07](chapters/07-make-it-reproduce/) | The DAG and the locked environment | `snakemake -n -s ... --configfile ...` | five rules resolved, `clean` first, exit 0 |
| [08](chapters/08-catch-what-review-misses/) | The rubric, the reviewer Skill, `verify.sh` | `bash verify.sh fixtures/run-sabotaged.yaml` | exit 1, naming the row and the values |
| [09](chapters/09-write-the-disclosure/) | Disclosure and methods, from files | none | a placement decision written down before you submit |
| [10](chapters/10-assemble-the-system/) | One entry point, one cost model | `bash go.sh config.yaml` | a run directory holding outputs, config, logs and a verdict |
| [11](chapters/11-write-the-runbook/) | The runbook and the refusals log | `snakemake --cores 1 assert_controls` | it fails, printing `MISSING CONTROLS:` |
| [12](chapters/12-keep-it-in-git/) | The Skill repository and the 30-day plan | `bash validate-all.sh ~/research-skills` | every Skill exits 0, checked by running it |

Chapter 1 has no folder. It is the book's opening argument and it has no build step,
which is what the outline says it is.

## How the pieces connect

The diagram at the top is the whole system: every arrow is one file being handed from the
chapter that makes it to the tool that reads it.

The thesis under all of it is one sentence, and it is why the reviewer here is a
checklist runner rather than a second opinion: **every rubric row terminates in a fact
outside the model.** A DOI that resolves or does not. A row count that reconciles or
does not. A set of patient IDs that intersects or does not. A control that is present
or absent. Nothing in the list can change because the model felt differently today.

## What it needs to run

macOS or Linux, `python3`, `bash`, `git`, and `curl`. That is the whole floor for
everything in the table above.

Four things want a little more, and each one says so where it is used. `validate-all.sh`
wants `agentskills` (`pip install skills-ref`). `snapshot.py` wants `pandas`, and fails
with one line naming it rather than a traceback. `verify.sh` and the entry points want
`yq`. The dry run wants `snakemake`.

No key, no account, no `.env`, and no network for any of it. The citation fixtures are
real API responses saved to disk, so `resolve.sh --fixture` works on a plane.

**The exception, and it is the main event.** The four `SKILL.md` files are instruction
files that Claude Code reads and follows. Running them needs Claude Code and your own
Pro, Max or Team subscription, which you have if you bought a book called *Claude for
Life Sciences*. Nothing in this repo simulates a Skill firing, because a simulated
Skill would teach you nothing about the real one.

And the honest limit on that: `agentskills validate` checks those four files against a
frontmatter contract. It does not check their judgment, and neither does anything else
here. The two fixture runs of `verify.sh` test `verify.sh`. Nothing tests a Skill.

## Design rationale

*Why the Skills are not in a `.claude/` folder.* A `.claude/skills/` directory at the
root of this repo would be picked up automatically by any Claude Code session opened
inside a clone, quietly loading four instruction files into anyone who was only
browsing. Keeping them at `chapters/NN-.../skills/<name>/` also keeps them validatable,
because `agentskills validate` requires the directory name to equal the `name:` field.

*Why there is no CI.* There is nothing continuous integration would run that
`validate-all.sh` and the two `verify.sh` fixture runs do not run locally in under two
seconds, and a green badge on a repository of markdown instruments is decoration.

*Why there is no `conda-lock.yml`.* Generating one requires a conda solve on your
platforms. Writing one by hand would mean inventing per-package checksums, in the
companion to the chapter that exists to explain why checksums matter. Chapter 7 has the
command that makes yours.

*Why the appendix is two files.* The book's appendix repeats what the chapters already
said, which is right for a book you read at 6pm and wrong for a repository, where the
same table in three places is three things to keep in sync. Only the reproducibility
checklist and the glossary appear nowhere else, so only those two are here.

## The line you must not cross

NIH prohibits its scientific peer reviewers from using large language models or other
generative AI for analysing and formulating peer review critiques, because uploading
application content violates peer review confidentiality requirements. The reviewer
workflow here audits your own work only. It never touches somebody else's grant
application or manuscript under review, not to summarise it, not to check its
statistics, not "just to see". Full text in [DISCLAIMER.md](DISCLAIMER.md).

## Known bugs, gotchas, testing

[GOTCHAS.md](GOTCHAS.md) is what actually bit while this was being built, with the
output that proves each one.

Two places this repo knowingly diverges from a printed snippet, both flagged where they
live: `verify.sh` prefers a run-scoped `before.json` over the current directory
(`chapters/05-reconcile-your-cleaning/README.md` has the reason), and
`assert_controls.smk` is shipped as printed even though its `awk` tests presence where
the rubric asserts `count > 0` (`chapters/11-write-the-runbook/README.md` has the
one-character fix).

Every fixture in this repository is synthetic. Every number any script here prints is
computed from those fixtures and describes no real dataset.

## Contributing

Fixes are welcome: a command that doesn't run, an output that doesn't match, a
transcription that drifted from the book. New features are out of scope, because this
repository mirrors the book on purpose and a companion that grew past its book stops
being recognisable to the person holding the book.

## License

MIT. See [LICENSE](LICENSE).

Educational software. Not research, medical, legal or regulatory advice, and no
compliance coverage of any kind.
