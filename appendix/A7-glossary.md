<!-- Appendix A.7. Terms a bench scientist meets crossing into dry-lab work. Your own
     biology is not defined here. -->
# A.7 Glossary

**Agent Skill**: a directory containing `SKILL.md`, holding instructions Claude loads
when the description matches the situation.

**Connector (MCP)**: a small server speaking a common protocol that sits between the
model and a resource, advertising what it can do.

**DAG**: directed acyclic graph. The dependency structure of a pipeline: each step
declares what it consumes and produces, and the run order is derived rather than
written.

**Held-out split**: data withheld from training, used to estimate performance. Its
value depends entirely on nothing from it having leaked into training.

**Lockfile**: a file listing exact package versions with checksums. Distinct from an
environment specification, which is a request rather than a receipt.

**MAD-based filtering**: thresholds set from the median absolute deviation of the data
itself rather than from a fixed number. Outlier-resistant and dataset-adaptive, which
is why the resulting cell count is not predictable in advance.

**Pinned environment**: an environment installed from a lockfile, so it does not change
as new package versions are released.

**Progressive disclosure**: the Skill loading model. Metadata is always in context
(about 100 tokens), the body loads when the Skill fires, and `references/` load only
when read.

**Provenance record**: the recorded history of how an output was made: the code, the
environment, and the parameters.

**Samplesheet**: the table mapping sample identifiers to files and experimental
variables. Where confounds become visible if you cross-tabulate it, and invisible if
you do not.

**DOI / PMID / PMCID**: three identifier systems for the literature. DOIs are
publisher-issued and resolve through Crossref; PMIDs are PubMed; PMCIDs are PubMed
Central full text. The ID converter maps between them.
