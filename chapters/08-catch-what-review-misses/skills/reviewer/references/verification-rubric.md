<!-- Chapter 8, transcribed verbatim, and the only copy in this repo. Step 1 of SKILL.md
     reads this file, so these are the rows that actually run. Edit it here, for your
     own subfield, rather than keeping a second copy somewhere that can drift. -->
# verification-rubric.md

Every row must terminate in a fact outside the model. A row whose verdict could
change because the model felt differently today is not a row.

| # | Row | Reads | Asserts | External fact | Fails if |
|---|-----|-------|---------|---------------|----------|
| 1 | patient-level leakage | splits/*.txt, sample_to_patient.tsv | zero ID intersection | set intersection | overlap > 0; names patients |
| 2 | site-level leakage | splits/*.txt, sample_to_site.tsv | zero site intersection, or documented | set intersection | overlap > 0 and undocumented |
| 3 | controls present | config.used.yaml, final_table.tsv | every named control present, count > 0 | string match on disk | any missing or zero |
| 4 | row reconciliation | before.json, drop_log.tsv, final_table.tsv | rows_in = rows_out + logged drops | arithmetic | does not close |
| 5 | correction applied | config.used.yaml, de_results.tsv | correction method named and applied | column present, method in config | absent or unnamed |
| 6 | n matches | draft.md, before.json, final_table.tsv | reported n equals post-QC n | integer comparison | differs |
| 7 | statistic recomputes | draft.md, de_results.tsv | headline number recomputes | independent recomputation | differs beyond tolerance |
| 8 | numbers trace | draft.md, runs/** | every prose number appears in a run file | grep | any number unfound |
| 9 | citations resolve | draft.md | every reference passes the Ch4 metadata check | Crossref / PMC / PubMed | any fabricated or mismatched |
| 10 | conclusions grounded | draft.md, runs/** | every claim traces to a file or a verified citation | provenance | any claim traces only to model output |
