# Chapter 3 — Equip Claude

Your first Skill, and the connectors under it. This is the afternoon everything else
assumes.

## The afternoon

`install.md` has the commands in order: add the marketplace, install PubMed plus two
connectors for your field, configure credentials, restart, write a Skill, validate it.

`connectors.md` is the twenty-one plugin IDs off the marketplace manifest, with an
account column and two empty columns you fill in as you install. The last column,
"configured against", is the one that saves you in month four when a connector starts
failing and you cannot remember which of your two accounts it was wired to.

`skills/samplesheet-audit/SKILL.md` is your first Skill, transcribed from the chapter.
It implements one row of the Chapter 2 trust boundary: the confounded-design check.
Six steps, ending PROCEED or a numbered list of blocking issues, and it will never say
PROCEED when a crosstab contains a zero.

## The one command

```bash
bash validate-all.sh
```

```
Valid skill: .../chapters/03-equip-claude/skills/samplesheet-audit
Valid skill: .../chapters/04-verify-every-citation/skills/citation-check
Valid skill: .../chapters/05-reconcile-your-cleaning/skills/data-cleaning-verify
Valid skill: .../chapters/08-catch-what-review-misses/skills/reviewer
4 Skills checked, all valid
```

Exit 0. If you get `MISSING TOOL: agentskills`, run `pip install skills-ref` and read
the next paragraph, because the package name and the command name are different and
that catches everybody once.

Then put the Skills where Claude Code will load them:

```bash
cp -r chapters/*/skills/* ~/.claude/skills/
bash validate-all.sh ~/.claude/skills
```

## The frontmatter contract, which fails silently

`name` is required. Maximum 64 characters, lowercase letters, digits and hyphens only,
no leading hyphen, no trailing hyphen, no two in a row, and it must match the parent
directory name. It may contain neither "claude" nor "anthropic".

That last rule is the one `agentskills validate` does not enforce. It returns `Valid
skill` and exit 0 on a directory named `claude-citation-check`. `validate-all.sh`
checks it anyway, because the book tells you to check it yourself and a checklist you
have to remember is a checklist you won't run.

`description` is required, 1024 characters maximum, and it must say what the Skill does
**and when to use it**. The second half is the half people skip and it is why a Skill
sits on disk for a month without ever firing. "Audits sample sheets" is accurate and
matches nothing anybody types.

Budget: metadata is loaded in every session, roughly 100 tokens, permanently. Keep the
body under about 5000 tokens and 500 lines. Anything longer goes in `references/`,
which loads only when read.

## When it does not fire

Five failure modes, in the order you are most likely to meet them, are at the bottom of
`install.md`. The short version: the plugin ID has a hyphen it shouldn't have, you
didn't restart, the credentials are on your other account, `pip` installed `agentskills`
into a Python you are not using, or your `description` says what the Skill does and not
when to use it.

## Your own Skill

Pick a row from your Chapter 2 trust boundary and write it. The directory name and the
`name:` field have to be identical:

```bash
mkdir -p ~/.claude/skills/<your-skill>
$EDITOR ~/.claude/skills/<your-skill>/SKILL.md
agentskills validate ~/.claude/skills/<your-skill> && echo "exit=$?"
```

The Skill worth writing first is not the impressive one. It is the thing you have
explained to the model three times this month.
