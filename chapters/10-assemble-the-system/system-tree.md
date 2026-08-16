<!-- Chapter 10, transcribed verbatim. This is where the files in this repo end up in
     YOUR project. The important property is not the layout, it is that nothing in it
     lives inside a conversation. -->
# The assembled system

```
research-system/
├── .claude/skills/
│   ├── samplesheet-audit/     SKILL.md              (Ch3)
│   ├── citation-check/        SKILL.md              (Ch4)
│   ├── data-cleaning-verify/  SKILL.md              (Ch5)
│   └── reviewer/              SKILL.md
│                              references/verification-rubric.md   (Ch8)
│                              references/trust-boundary.md        (Ch2)
├── connectors.md              which plugins, which need accounts   (Ch3)
├── environment.yml            what you asked for                   (Ch7)
├── conda-lock.yml             what you got, with checksums         (Ch7)
├── config.yaml                the run you are doing now            (Ch6)
├── workflow/Snakefile         the DAG                              (Ch7)
├── scripts/                   the analysis steps                   (Ch6)
│   ├── snapshot.py            before-state, typed as strings       (Ch5)
│   ├── 00_clean.py            the Ch5 cleaning step, in the DAG    (Ch5)
│   └── verify.sh              the mechanical rubric rows           (Ch8)
├── templates/
│   ├── disclosure.md          statement + venue placement table    (Ch9)
│   └── methods_skeleton.md    the shape, not the text              (Ch9)
├── runbook.md                 failure modes and recoveries         (Ch11)
└── runs/                      one directory per run, never edited
```

Two things about that tree that this repo does differently, and why.

`conda-lock.yml` is not in this repo and cannot be. Generating one requires a conda
solve on your platforms; writing one by hand would mean inventing per-package
checksums, in the companion to the chapter that exists to explain why checksums matter.
Run `conda-lock -f environment.yml -p osx-64 -p linux-64 -p osx-arm64` yourself and it
lands next to your `environment.yml`.

The `.claude/skills/` directory at the top is where the Skills go in **your** project.
This repo keeps them at `chapters/NN-.../skills/<name>/` instead. Copy them across with
`cp -r chapters/*/skills/* ~/.claude/skills/`, or into a project's own
`.claude/skills/` if they encode that project's conventions.

The Snakefile sits at `workflow/Snakefile` here and at the chapter root in this repo.
Snakemake resolves `conda:` and `script:` relative to the Snakefile, so whichever you
pick, `environment.yml` and `scripts/` go beside it.
