<!-- Chapter 4. Add this to citation-check, or to whatever Skill drafts your prose.
     Without it the references attach to the document rather than to the sentences,
     and an audit of the reference list proves nothing about paragraph three. -->
# The inline source marker

Paste this into the Skill that drafts your text:

```markdown
Every factual statement must end with an inline marker naming its source, in the form
[source: <first author> <year> <identifier>]. A statement you cannot mark is written as
"UNSUPPORTED:" followed by the statement. Do not silently drop an unsupported statement
and do not attach a marker to a source that does not contain the claim.
```

What comes back is uglier, which does not matter because you are editing it anyway:

```
Preprocessing with fastp consolidates the functions of several earlier tools into a
single pass [source: Chen 2018 10.1093/bioinformatics/bty560]. UNSUPPORTED: this
reduces total pipeline runtime by roughly half in typical RNA-seq workflows.
```

That second sentence is the whole reason to do this. It is the kind of claim that
sounds right, that you might well believe, and that would otherwise have sailed into
your introduction attached to whatever citation happened to be nearest.

Two things follow. Your audit table gets a row per claim rather than a row per
reference, which is the level at which a real paper cited for something it never said
becomes visible. And the volume of confident claims drops, which tells you something
about how many of them were load-bearing.
