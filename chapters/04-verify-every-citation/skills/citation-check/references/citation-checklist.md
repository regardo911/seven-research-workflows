<!-- Appendix A.3, copied into the Skill's references/ at the path Chapter 12's tree
     names. references/ loads only when the Skill reads it, so length is cheap here. -->
# The citation verification checklist

The reason this checklist compares metadata rather than existence: in a study of 100
hallucinated citations that survived expert review, the categories were Total
Fabrication 66%, Partial Attribute Corruption 27%, Identifier Hijacking 4%,
Placeholder Hallucination 2%, Semantic Hallucination 1%. An existence check passes the
27% and the 4%, which is nearly a third.

For every reference:

- [ ] An identifier is present in the draft (DOI or PMID). If absent, that is itself a finding.
- [ ] The identifier resolves to a record retrieved this session.
- [ ] **Title** matches the record.
- [ ] **First author** matches the record.
- [ ] **Year** matches the record.
- [ ] **Journal** matches the record.
- [ ] Verdict recorded as exactly one of: `resolves` · `metadata mismatch` (naming the field) · `fabricated`.
- [ ] **Access level** recorded: full text read · abstract only · paywalled and not retrieved.
- [ ] The cited claim is actually supported by the paper, with the supporting sentence quoted.
- [ ] Nothing marked abstract-only supports a methodological claim.

## Endpoints

```
https://api.crossref.org/works?rows=0&mailto=you@example.org
    No sign-up required. Identify yourself with mailto for the polite pool.

https://eutils.ncbi.nlm.nih.gov/entrez/eutils/
    3 requests/sec without a key. 10/sec with one. Register tool and email:
    a blocked IP is not restored unless those parameters were registered.
    Large jobs: weekends, or 9:00 PM to 5:00 AM US Eastern on weekdays.

https://pmc.ncbi.nlm.nih.gov/tools/idconv/api/v1/articles/
    PMID / PMCID / DOI conversion via ?ids= and &format=json. XML and CSV also available.
    (The older www.ncbi.nlm.nih.gov/pmc/tools/xref-ids/ address 301-redirects here.)
```

Single existence check:

```bash
curl -s "https://pmc.ncbi.nlm.nih.gov/tools/idconv/api/v1/articles/?ids=10.1093/bioinformatics/bty560&format=json"
```

Crossref does not publish a requests-per-second figure, and the PMC ID Converter's
documentation states no authentication requirement, rate limit, or maximum number of
IDs per request. No number is given here for any of them. Treat the E-utilities
three-per-second figure as the ceiling for anything hosted at NCBI.

For systematic reviews, the reporting standard is PRISMA 2020: Page MJ, McKenzie JE,
Bossuyt PM, and colleagues, Moher D, *The PRISMA 2020 statement: An updated guideline
for reporting systematic reviews.* Get the checklist from the source.
