<!-- Chapter 12, transcribed verbatim, plus the naming rules that fail silently. This
     is the repository you maintain, and it is the durable half of everything you
     built. The app will be renamed twice; these files will not. -->
# The repository you maintain

One directory per Skill, in git, treated the way you would treat any other piece of
infrastructure you depend on.

```
research-skills/
├── samplesheet-audit/
│   └── SKILL.md
├── citation-check/
│   ├── SKILL.md
│   └── references/citation-checklist.md    Appendix A.3, copied in
├── data-cleaning-verify/
│   ├── SKILL.md
│   └── scripts/snapshot.py
├── reviewer/
│   ├── SKILL.md
│   └── references/
│       ├── verification-rubric.md
│       └── trust-boundary.md
├── connectors.md          which plugins, which need accounts, which account
├── runbook.md
└── README.md              what each Skill does and when it fires
```

Every file in that tree exists in this repo, under the chapter that built it. To get
the shape above, copy the four Skill directories out and add the two markdown
instruments:

```bash
mkdir -p ~/research-skills
cp -r chapters/*/skills/* ~/research-skills/
mkdir -p ~/research-skills/data-cleaning-verify/scripts
cp chapters/05-reconcile-your-cleaning/snapshot.py ~/research-skills/data-cleaning-verify/scripts/
cp chapters/03-equip-claude/connectors.md ~/research-skills/
cp chapters/11-write-the-runbook/runbook.seed.md ~/research-skills/runbook.md
cd ~/research-skills && git init
```

## The naming rules, all of which fail silently

| Rule | Detail | Caught by `agentskills validate` |
|---|---|---|
| Characters | Lowercase letters, digits and hyphens only | Yes |
| Hyphens | No leading, no trailing, none consecutive | Yes |
| Length | 64 characters maximum | Yes |
| Directory | The `name` must match the parent directory name | Yes |
| Reserved | Must contain neither "claude" nor "anthropic" | **No. Check it yourself** |

So `claude-lit-review` is out and `lit-review` is fine. The validator will not tell you
which: it returns `Valid skill` and exit 0 on the reserved-word name. That last row is
the one you enforce by reading it.

The `description` field is the other silent failure. Maximum 1024 characters, and it
must say what the Skill does **and when to use it**. The second half is what gets it
loaded. "Audits sample sheets" is accurate and will never fire, because nothing in it
matches the words you actually type.

## Three maintenance habits, twenty minutes a month combined

**Re-validate before you trust.** A Skill you have not run in a month gets `agentskills
validate` before you rely on it. The file has not changed but your environment has.

**Delete Skills you do not use.** A library of twenty where six are live is worse than
a library of six: the metadata for all twenty loads into every session. If it has not
fired in three months, archive it.

**Write the Skill when the annoyance happens, not later.** The moment you catch
yourself explaining the same convention for the third time is the moment to write it
down. That is the origin story of every useful Skill in this book.

## What survives

Skills do not sync across surfaces. A Skill written in Claude Code is not present in
the web app, and the API is a third separate place. Nothing warns you; you open a
different surface, the Skill does not fire, and you assume it is broken.

That constraint is the argument for git. A `SKILL.md` is markdown with frontmatter
against a published open specification, validated by an open-source tool that exits 0
or 1. A `conda-lock.yml` is a conda artifact with nothing to do with any AI vendor.
Your workflow belongs to a community project. Your config, rubric, runbook and run
directories are plain text. If every AI company vanished overnight, what you would lose
is the connectors, which are convenience wrappers over public APIs you could call
directly.
