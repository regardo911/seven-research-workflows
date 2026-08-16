---
name: citation-check
description: Resolves every reference in a draft against Crossref, PubMed or the PMC
  ID Converter, compares the returned metadata field by field against what was cited,
  and reports one of three verdicts per reference. Use when checking a literature
  review, a manuscript bibliography, a grant reference list, or any drafted set of
  references, including ones a human wrote.
---

# Citation check

Never assert that a reference is correct because it looks correct. Every verdict must
come from a record retrieved this session.

## Steps

1. Extract every reference and every in-text claim it supports. Number them.

2. For each reference, retrieve the record by DOI or PMID. If neither identifier is
   present, search by exact title and report that the identifier was missing.

3. Compare four fields against the citation as written: title, first author, year,
   journal. Report each comparison, not just the summary.

4. Assign exactly one verdict:
   - resolves: identifier exists and all four fields match.
   - metadata mismatch: identifier exists, at least one field disagrees. State which.
   - fabricated: no record retrieved.

5. Record access level for each: full text read, abstract only, or paywalled and not
   retrieved.

6. For every claim in the text, state whether the cited paper supports it, and quote
   the sentence from the paper that does. If you cannot quote it, mark the claim
   unsupported rather than assuming.

## Output

A table with one row per reference: number, cited claim, identifier, resolved title,
resolved first author, resolved year, resolved journal, verdict, access level. Then a
list of every row that is not "resolves" and not "full text read". Never summarise the
table without printing it.
