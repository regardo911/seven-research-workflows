# Chapter 9 — Write the disclosure

Nothing runs here either. What this folder holds is the paperwork nobody teaches and
every journal and funder now wants.

## Three bodies, three answers

There is no single correct AI disclosure statement, and the honest version of that is
annoying: Elsevier, ICMJE and Nature Portfolio disagree with each other about where it
goes and what it says.

So the deliverable is a statement plus a decision about where it goes. `disclosure.md`
has Elsevier's wording verbatim, the four-row placement table, and a line to write your
own venue decision on before you submit.

One correction worth carrying, because the wrong version is everywhere: Nature's live
policy names no manuscript section. If you have read that Nature requires AI disclosure
in the Methods, you would be writing to a rule that does not exist, and assuming you
were covered because you followed it.

## What you produce

`methods_skeleton.md` maps each clause of a methods paragraph to the file it comes
from. The ordering is the trick: the methods section is downstream of the checks, not
parallel to them. Every number comes out of a file, every threshold is quoted from the
config rather than recalled, and every citation has already passed the metadata
comparison.

Three questions a skeptic actually asks, and the artifact that answers each. Have all
three ready before you submit, not after. "How do I know the AI didn't make this up" is
answered by the Chapter 4 audit table, not by a description of how careful you were.
"Can you reproduce this" is answered by the lockfile and the equivalence check, and by
the sentence that costs nothing and is hard to fake, which is that somebody else
already did it on a different machine. "What exactly did the AI do" is answered by the
disclosure plus the trust boundary you wrote in Chapter 2, and that last clause is
worth more than the rest combined: a document specifying what you would and would not
delegate, dated before the analysis, is evidence of intent. Anyone can describe a
careful process in hindsight.

## Your venue

1. Regenerate the figure through the pipeline. Not from the export you already have.
   A figure produced outside the pipeline has parameters that are not in the config,
   your rubric cannot check it, and your collaborator cannot reproduce it.
2. Write the methods with the run directory open. If you find yourself typing a number
   you have not looked up, stop and look it up.
3. Fill the disclosure with specific named tasks. "Assisted with the manuscript" is not
   a disclosure, it is an evasion, and it is worse than saying nothing because it looks
   like compliance.
4. Write the placement decision down in one line. If you cannot say which row of the
   table your venue falls under, you haven't finished; that decision is half the
   deliverable.
5. Run rows 8, 9 and 10 of the Chapter 8 rubric against the draft.

The single question to hold every panel to: if a reviewer asks how this was made, is my
answer a command or a memory?

## What this repo cannot give you

The figure. It regenerates from your data, through your pipeline, which is the point of
it, so there is nothing here to ship. That is a limit of the artifact, not a gap in the
chapter.

And no compliance coverage of any kind. No HIPAA claim, no validated-system claim. See
DISCLAIMER.md.
