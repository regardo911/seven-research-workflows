<!-- Chapter 3. The commands for one afternoon, in order. Every one of them runs
     inside Claude Code, not in your shell, except the last three. -->
# Install

## 1. Add the marketplace

In Claude Code:

```
/plugin marketplace add anthropics/life-sciences
```

The success line reads `Successfully added marketplace: life-sciences`.

## 2. Install PubMed first

```
/plugin install pubmed@life-sciences
```

PubMed is the only connector in the set that needs no account, no key and no signup,
which is why every checkpoint in Chapter 3 runs through it. Nothing can block you on
step one.

Then two more from your own field's row in `connectors.md`. Four or five total, not
twenty-one.

## 3. Configure credentials, then restart

`/plugin`, then Manage plugins, then Configure. Then quit Claude Code properly and
start it again.

Do not skip the restart. The plugin surface is loaded at startup, so a connector you
configured in this session is not live in this session. Nine times out of ten, "the
connector is broken" is this.

## 4. Write a Skill

The directory name and the `name:` field must be identical.

```bash
mkdir -p ~/.claude/skills/samplesheet-audit
```

Or take all four of this repo's at once:

```bash
cp -r chapters/*/skills/* ~/.claude/skills/
```

## 5. Install the validator and run it

```bash
pip install skills-ref
agentskills validate ~/.claude/skills/samplesheet-audit
echo $?
```

The package is `skills-ref`; the command it installs is `agentskills`. That mismatch
catches everybody once. You want exit 0.

A valid Skill prints:

```
Valid skill: /tmp/sktest/citation-check
exit=0
```

An invalid one names every problem at once:

```
Validation failed for /tmp/sktest/bad-skill:
  - Skill name 'Citation_Check' must be lowercase
  - Skill name 'Citation_Check' contains invalid characters. Only letters, digits, and hyphens are allowed.
  - Directory name 'bad-skill' must match skill name 'Citation_Check'
exit=1
```

## The five ways this fails

1. **The plugin ID is wrong.** Almost always a hyphen. Check any ID you read on a web
   page against the twenty-one in `connectors.md`, which came off the manifest.
2. **The connector installs and then does nothing.** You did not restart.
3. **Credentials are on the wrong account.** Confirm which account is signed in before
   you debug anything else, and write it in the last column of `connectors.md`.
4. **`agentskills` is command-not-found.** `pip` put it in a Python you are not using.
   Run `which python` and `which pip` and confirm they agree.
5. **The Skill validates, sits on disk, and never fires.** The `description` says what
   it does and not when to use it. Open it and ask whether the exact nouns and verbs
   you would type appear in it. This one costs people a month.
