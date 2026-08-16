# gotchas

things that actually bit while putting this together, with the output that proves it.
three of them. the build was otherwise uneventful, and padding this file with plausible
ones would be the same category of dishonesty the whole repo is about.

## the install one-liner had a trailing slash and ate three of the four skills

`cp -r chapters/*/skills/*/ ~/.claude/skills/` looks right and is wrong on macOS. bsd
`cp` treats a trailing slash on the source as "copy the contents", so all four SKILL.md
files landed on top of each other in `~/.claude/skills/` and the last one won. gnu `cp`
does not do this, so it would have worked fine on linux and quietly destroyed three
skills on a mac. the book says macOS or linux.

it was caught by running the repo's own first command into a throwaway HOME:

```
Validation failed for /tmp/fakehome/.claude/skills:
  - Directory name 'skills' must match skill name 'reviewer'
FAILED: /tmp/fakehome/.claude/skills
1 Skills checked, see failures above
```

one skill checked, not four, and the one it found was a directory called `skills`
containing a `SKILL.md` that said `name: reviewer`. drop the trailing slash on the
source and it copies the directories:

```
cp -r chapters/*/skills/* ~/.claude/skills/
```

worth noting how it got caught. `validate-all.sh` reports a count, and the count was
1 when it should have been 4. a loop that printed "done" would have said done.

## snakemake -n resolves paths against the working directory, not the snakefile

first attempt at the dry run, from the repo root with `-s` pointing at the snakefile:

```
MissingInputException in rule clean in file ".../07-make-it-reproduce/Snakefile", line 10:
Missing input files for rule clean:
    output: runs/dryrun/final_table.tsv, runs/dryrun/drop_log.tsv
    affected files:
        data/counts.tsv
        data/sheet.csv
```

both files existed. `-s` sets where the rules are, not where the paths point from, so
every relative path in the config was being resolved against the shell's cwd. the fix
is `-d`, which is in the documented command in the chapter 7 readme, and it is the
reason that command is three lines long instead of one.

the `conda:` and `script:` lines are the opposite: those *are* relative to the
snakefile. so a snakemake project has two different relative-path origins in one file,
which is worth knowing before you move anything.

## `.snakemake/` appears in the repo after a dry run

harmless, and it is gitignored, but the first dry run leaves a cache directory inside
whatever you passed to `-d`. it turns up in `git status` looking like something you
did. it isn't.
