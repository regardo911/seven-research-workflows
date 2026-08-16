<!-- Chapter 4, transcribed verbatim: a real audit from a short review, trimmed to five
     rows. Two of the rows are fakes planted before the check ran. Diff your own run
     against this to see whether your workflow produces the same shape. -->
# Citation audit, the output shape

```
# Citation audit — preprocessing and reproducibility review

| # | Cited as                          | Identifier                    | Resolved title                                                  | Author | Year | Journal              | Verdict           | Access
|---|-----------------------------------|-------------------------------|-----------------------------------------------------------------|--------|------|----------------------|-------------------|--------------
| 1 | Chen 2018, Bioinformatics         | 10.1093/bioinformatics/bty560 | fastp: an ultra-fast all-in-one FASTQ preprocessor              | Chen S | 2018 | Bioinformatics       | resolves          | full text
| 2 | Chen 2019, Nucleic Acids Research | 10.1093/bioinformatics/bty560 | fastp: an ultra-fast all-in-one FASTQ preprocessor              | Chen S | 2018 | Bioinformatics       | metadata mismatch | full text
|   |   -> year cited 2019, record says 2018; journal cited Nucleic Acids Research, record says Bioinformatics
| 3 | Baker 2016, Nature 533:452        | 10.1038/533452a               | 1,500 scientists lift the lid on reproducibility                | Baker M| 2016 | Nature               | resolves          | ABSTRACT ONLY
| 4 | Page 2021, PRISMA 2020 statement  | (searched by title)           | The PRISMA 2020 statement: An updated guideline for reporting…  | Page MJ| 2021 | (multiple)           | resolves          | full text
|   |   -> no identifier supplied in draft; resolved by exact title match. Add the DOI before submission.
| 5 | Okonkwo 2023, Genome Biology      | 10.1186/s13059-023-99999-x    | (no record retrieved)                                           | —      | —    | —                    | FABRICATED        | none

## Rows requiring action
- #2 metadata mismatch: two fields wrong. The claim is fine; the citation is not. Fix both fields.
- #3 abstract only: cannot support any methodological claim. Currently cited for a
  percentage that appears in the body of the paper. Either obtain the full text or cut
  the number and cite the survey qualitatively.
- #4 no identifier in the draft. Resolved, but a reference with no DOI is a reference
  nobody can check quickly. Add it.
- #5 FABRICATED: no record. Remove the citation and the sentence it supports, or find a
  real source for the claim.

## Summary
5 references · 2 clean · 1 metadata mismatch · 1 fabricated · 1 restricted to abstract
```

Row 5 is the easy one: suspicious DOI suffix, no paper, any check catches it. Row 2 is
a real paper with a real DOI cited under the wrong year and the wrong journal, and it
is invisible unless something compares fields. Row 3 resolves cleanly and is still not
honest, because it implies a level of reading that did not happen.

You can reproduce rows 1, 2 and 5 offline with `resolve.sh`. See the README.
