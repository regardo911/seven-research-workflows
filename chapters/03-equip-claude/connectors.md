<!-- Chapter 3 and Chapter 10. The twenty-one IDs are the marketplace manifest, not a
     documentation page. Fill the last column in as you install; in four months this
     file is what tells you whether a failure is a credential problem. -->
# connectors.md

Setup is two commands. Add the marketplace once, then install what you need:

```
/plugin marketplace add anthropics/life-sciences
/plugin install <id>@life-sciences
```

Authentication is required for every plugin except PubMed. That is why PubMed is the
one to test with first: nothing can block you on step one. For the rest the route is
`/plugin`, then Manage plugins, then Configure, then restart Claude Code. The restart
is not optional and skipping it is the most common false alarm.

## The twenty-one IDs

| ID | What it reaches | Account needed | Installed? | Configured against |
|---|---|---|---|---|
| `pubmed` | PubMed literature | **No** |  |  |
| `biorxiv` | bioRxiv and medRxiv preprints | Yes |  |  |
| `consensus` | Search across 200M+ peer-reviewed papers with evidence synthesis (Anthropic's figure) | Yes |  |  |
| `clinical-trials` | ClinicalTrials.gov | Yes |  |  |
| `chembl` | ChEMBL bioactivity data | Yes |  |  |
| `open-targets` | Target-disease association data | Yes |  |  |
| `owkin` | Owkin | Yes |  |  |
| `tooluniverse` | 600+ vetted scientific tools: UniProt, Ensembl, RCSB PDB, ChEMBL, PubMed, PubChem, DrugBank, FDA databases, ClinicalTrials.gov. Built by MIMS Harvard, Apache-2.0 | Yes |  |  |
| `10x-genomics` | 10x Genomics | Yes |  |  |
| `synapse` | Synapse.org | Yes |  |  |
| `biorender` | BioRender | Yes |  |  |
| `wiley-scholar-gateway` | Scholar Gateway, developed by Wiley | Yes |  |  |
| `medidata` | Medidata | Yes |  |  |
| `cortellis` | Cortellis | Yes |  |  |
| `adisinsight` | AdisInsight | Yes |  |  |
| `single-cell-rna-qc` | **Skill.** scRNA-seq QC on `.h5ad`/`.h5`, scverse best practices, MAD-based filtering | Yes |  |  |
| `nextflow-development` | **Skill.** nf-core pipelines (rnaseq, sarek, atacseq), GEO/SRA fetch, samplesheet generation | Yes |  |  |
| `scvi-tools` | **Skill.** scvi-tools model selection and workflows | Yes |  |  |
| `instrument-data-to-allotrope` | **Skill.** Instrument data to Allotrope conversion | Yes |  |  |
| `scientific-problem-selection` | **Skill.** Scientific problem selection | Yes |  |  |
| `clinical-trial-protocol` | **Skill.** Clinical trial protocol work | Yes |  |  |

## The ID that is wrong in the vendor's own tutorial

Anthropic's ToolUniverse tutorial page prints `tool-universe@life-sciences`. That
fails, and the failure line reads:

```
Failed to install plugin "tool-universe@life-sciences":
  Plugin "tool-universe" not found in marketplace "life-sciences"
```

The working ID has no hyphen: **`tooluniverse@life-sciences`**.

## Which account is signed in

The last column matters more than it looks. Lab members frequently have two accounts,
a personal one from when they were trying it out and an institutional one. Configure
the connector against one, log into the other, and you get authentication failures
that read like the connector is down.

## Not in this marketplace

Scite (supporting vs contrasting citation context) is a paid third-party product; its
own documentation says the MCP bundles with a Scite subscription. Do not build a
workflow whose central step you cannot afford.

## Picking, by field

Genomics and transcriptomics: `pubmed`, `biorxiv`, `open-targets`, plus
`single-cell-rna-qc` and `10x-genomics` if relevant. Drug discovery and
cheminformatics: `chembl`, `open-targets`, `tooluniverse`. Clinic-adjacent:
`clinical-trials`, `clinical-trial-protocol`. Mostly reading: `pubmed`, `biorxiv`,
`consensus`.

Install four or five, not twenty-one. Every connector's metadata costs context in
every session.
