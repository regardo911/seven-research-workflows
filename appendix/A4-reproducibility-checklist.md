<!-- Appendix A.4. Five things to pin, two gates that must pass before real data, and
     five things a lockfile does not pin. The last list is why the bar is equivalence
     at a written tolerance rather than a bitwise diff. -->
# A.4 The reproducibility checklist

The five things this book pins. This is the book's framing rather than an external
standard, adopted because it is useful. If somebody asks you where the five-part
definition comes from, the honest answer is that it is a convention, not a standard.

| Element | Pinned by |
|---|---|
| Code | git commit, recorded in `run_info.txt` |
| Data | accession number, or `sha256sum` of the raw files |
| Config | `config.yaml`, copied into every run directory as `config.used.yaml` |
| Environment | `conda-lock.yml` |
| Seed | a named key in the config, never in the script body |

**Why the lockfile and not the `environment.yml`.** From the generated lockfile's own
header: *"A 'lock file' contains a concrete list of package versions (with checksums) to
be installed. Unlike e.g. `conda env create`, the resulting environment will not change
as new package versions become available."*

Each locked package carries `md5` and/or `sha256`, plus name, version, platform and
URL. Multi-platform in one file: `linux-64`, `osx-64`, `osx-arm64`.

```bash
sha256sum raw/*.fastq.gz > data.sha256
conda-lock -f environment.yml -p osx-64 -p linux-64
conda-lock install -n YOURENV conda-lock.yml
conda-lock render --kind explicit --kind env
conda create --name YOURENV --file conda-linux-64.lock
```

The unified lockfile must keep the `.conda-lock.yml` extension to parse correctly.
`env.lock` looks tidier and stops working.

**The two gates before real data**, adopted from Anthropic's own Nextflow Skill
checklist. Note where both of them sit: before your real data is touched.

- [ ] **Environment check MUST pass.** For Snakemake, `snakemake -n`.
- [ ] **Test profile MUST pass.** For Snakemake, a run against a tiny subsampled input.

**Five things the lockfile does not pin**, each needing its own handling: reference data
and annotation versions (download once, checksum, record the release) · thread count
(put it in the config) · hardware and numerical library dispatch · anything stochastic
you did not seed (run a step twice on the same input and diff it) · timestamps and path
ordering (compare the columns you care about, not whole files).

There is a sixth that is not a technical limit and defeats more reproducibility efforts
than the other five combined: **the manual step**. The one where you open the results in
a spreadsheet, fix a label, and save. A pipeline with one manual step in the middle is
not a pipeline, it is two pipelines with a rumour between them.

**Do not claim byte-identical output.** Nobody has established when a bioinformatics
pipeline is byte-reproducible and plenty of legitimate steps are not. The bar is:
installs from the lockfile on a clean environment, runs to completion, and is
equivalent at a tolerance written down in advance. Identical top-N lists and identical
row counts is a good bar. "Looks about the same" is not.

Write the tolerance into the repo before you look at the results. A tolerance chosen
after seeing the difference is not a tolerance, it is a rationalisation.
