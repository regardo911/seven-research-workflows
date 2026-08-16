<!-- Chapter 6. Six questions to ask a generated script before you run it on real data,
     and three real bugs that only these questions catch. Every one of them runs clean.
     None of them errors. -->
# The six-item read-through

Do this before you run the script on real data, not after. Reading a script that has
not yet produced a result is a neutral activity. Reading one that has already produced
a result you like is not, because you will be reading to confirm.

1. **Does every threshold in the code come from the config?** Search the script for
   bare numbers. A `0.05` sitting in the code rather than read from `padj_cutoff` means
   two sources of truth and one of them is invisible.
2. **Is the contrast the one you meant, in the direction you meant?** Find where the
   reference level is set. Say it out loud: "treated relative to control, so positive
   fold change means higher in treated." Then check that the code says that.
3. **Are the group sizes what you expect?** Have the script print n per group before it
   does anything else. Six and five where you expected six and six means something
   upstream dropped a sample and you just caught it for free.
4. **Did anything get hardcoded that should be a parameter?** Paths are the usual
   offender. Watch for a hardcoded column name, chromosome list, or species.
5. **Is there a step that silently subsets?** `head()`, a `[1:1000]`, a `sample(n=...)`
   left over from iterating fast. Common, and dangerous, because the code runs and the
   answer is computed on a tenth of your data.
6. **Does the covariate structure match your actual design?** If `batch` is in your
   samplesheet and not in your model, ask why. If it is in your model and perfectly
   confounded with condition, nothing will warn you.

## Three bugs this catches

**The leftover subset**, caught by item five:

```r
counts <- read_tsv(cfg$paths$counts)
counts <- counts[1:2000, ]          # <- speeds up testing
```

Two thousand genes instead of forty thousand. Every enrichment term that comes out is
an artefact of a positionally arbitrary subset. The filtering logic below it is
correct; the extra line is the bug.

**The reversed contrast**, caught by item two and only by saying it out loud:

```r
res <- results(dds, contrast = c("condition", "control", "treated"))
```

That is control relative to treated, the reverse of what the config says in English.
Every fold change has the wrong sign, the volcano plot is symmetrical so it looks
normal, and the biology you write will be a coherent, well-referenced, inverted story.
The defence is to make the script state its own interpretation:

```r
message(sprintf("Contrast: %s relative to %s. Positive LFC = higher in %s.",
                num, ref, num))
```

**The hardcoded assumption**, caught by item four:

```r
gene_map <- AnnotationDbi::select(org.Hs.eg.db, keys = ids, ...)
```

Human, because most of the documentation is human. On mouse data, half your
identifiers silently fail to map and the mapped subset proceeds happily. The tell is
that the species is nowhere in your config. Anything that is a property of your
experiment and is not in your config is an assumption somebody else made for you.
