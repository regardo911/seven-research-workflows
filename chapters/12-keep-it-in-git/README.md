# Chapter 12 — Keep it in git

The app is beta and it will change. Menus will move, features will land, the connector
roster will grow and some of it will be renamed. What survives is the files, and that
asymmetry is why this is the last chapter rather than one about what is coming next.

## Day 1

`plan-30.md` is thirty day-numbered milestones. Two rules for the whole plan: every
milestone attaches to a real project you are working on right now, and every milestone
produces a file rather than an understanding.

Replace every generic noun with a real one. Not "one real literature review": the
specific question for the specific manuscript. Not "one real dataset": the file name.
A milestone that names no real artifact is a wish, and you will know which of yours are
wishes as you write them.

If you fall behind, fall behind on Week 4. Weeks 1 through 3 compound.

## The repository

`skills-repo-tree.md` is the tree, the naming rules that fail silently, and the three
maintenance habits that come to about twenty minutes a month. It also has the copy
commands that turn this repo into that tree.

```bash
mkdir -p ~/research-skills
cp -r chapters/*/skills/* ~/research-skills/
cd ~/research-skills && git init
```

Then the checkpoint, run rather than remembered:

```bash
bash /path/to/seven-research-workflows/validate-all.sh ~/research-skills
```

```
4 Skills checked, all valid
```

A repository you haven't validated since you wrote it is a folder. Re-validate before
you trust: the file has not changed but your environment has, and finding out it is
broken while you are using it is worse than finding out on purpose.

## Your plan

Write it against your own project, `git init`, commit, and put a reminder in your
calendar for Day 31 to re-read your own cost model and your own runbook. Both will be
slightly wrong by then and both are useless if they go stale.

Month two is much lighter than month one, which is what makes it survivable: two or
three more Skills, one rubric row promoted into the pipeline, a runbook row you did not
predict, one stale thing refreshed, and one conversation. That last one is worth doing
on purpose. Sit with a colleague who is drowning in the same glue work and walk them
through your reconciliation output, or the audit table with the caught citation in it.
You will find out which parts of your setup you cannot actually explain, and the
objection they raise will be a real one from somebody in your field.
