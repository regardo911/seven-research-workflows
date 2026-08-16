# Chapter 4 — Verify every citation

An existence check passes about a third of fabricated citations. That is the whole
reason this folder exists.

## Three verdicts, not two

`resolves` means the identifier exists and the title, first author, year and journal
all match what was cited. `metadata mismatch` means the identifier exists and at least
one field disagrees, which is the 27 percent that a resolve-only check waves through
with a green light. `fabricated` means nothing came back.

The green light is the dangerous part. A check that only asks whether an identifier
resolves makes you less careful than you were before you ran it.

## Run it, with no network

```bash
bash chapters/04-verify-every-citation/resolve.sh --fixture \
     10.1093/bioinformatics/bty560 --year 2018 --journal Bioinformatics
```

```
identifier   10.1093/bioinformatics/bty560
source       fixture crossref-10.1093_bioinformatics_bty560.json
record       fastp: an ultra-fast all-in-one FASTQ preprocessor
             first author Chen S  year 2018  journal Bioinformatics
pmc          pmid 30423086  pmcid PMC6129281
compared     year: cited 2018, record 2018   match
compared     journal: cited Bioinformatics, record Bioinformatics   match
VERDICT: resolves
```

Now cite the same real paper under the wrong year and the wrong journal, which is
exactly row 2 of the worked audit table:

```bash
bash chapters/04-verify-every-citation/resolve.sh --fixture \
     10.1093/bioinformatics/bty560 --year 2019 --journal "Nucleic Acids Research"
```

```
VERDICT: metadata mismatch (year, journal)
```

And a DOI with nothing behind it:

```bash
bash chapters/04-verify-every-citation/resolve.sh --fixture 10.1186/s13059-023-99999-x
```

```
VERDICT: fabricated
```

The exit code is the verdict: 0 resolves, 1 metadata mismatch, 2 fabricated, 3 could
not read. Three could not read is never a pass.

The fixtures are real responses from Crossref and the PMC ID Converter, saved to disk
with `curl`, so the offline run and the live run agree. Drop `--fixture` and it goes to
the network instead. Neither endpoint needs a key, an account or a signup.

## What success looks like

Run all three and you have watched a detector fire on a fake you already knew about.
That is the discipline the whole chapter is built on, and it is why the build step has
you plant two references in your own bibliography before auditing it: one invented
outright, one real paper with a single field corrupted. The invented one proves
nothing. The corrupted one is the test.

## Your own reference list

Two things to add to your drafting Skill before the audit is worth running.

`source-marker.md` makes every factual statement carry `[source: author year id]` and
returns anything it cannot mark as `UNSUPPORTED:`. Without it, references attach to the
document rather than to the sentences, and you can verify all twelve references and
still have no idea whether paragraph three is supported by any of them.

`skills/citation-check/SKILL.md` goes in `~/.claude/skills/citation-check/`, and it
carries `references/citation-checklist.md` with it. Run it over a real draft, then
compare the shape of what comes back against `audit-table.example.md`.

One column in that table catches more people than fabrication does: access level. Full
text read, abstract only, or paywalled and not retrieved. Anything not marked
full-text-read cannot support a methodological claim, because the abstract of a paper
is the authors' most optimistic account of their own work and it is the source that is
always available.

## Rate limits, and the ones not printed here

E-utilities publishes its limits: three requests per second without a key, ten with
one, and large jobs at weekends or between 9:00 PM and 5:00 AM US Eastern. Register a
`tool` and an `email`, because a blocked institutional IP is not restored unless those
parameters were registered.

Crossref doesn't state a requests-per-second figure and the PMC ID Converter's
documentation states no authentication requirement, rate limit, or maximum IDs per
request. No number for any of those appears in this repo. Treat the E-utilities figure
as the ceiling for anything at NCBI and do not run an unthrottled loop.
