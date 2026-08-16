<!-- Chapter 5, transcribed verbatim. For data you did not generate: the person who
     understood the file has left, so ask for questions rather than for a clean file. -->
# The anomalies-only profiling prompt

```markdown
Profile this file and report anomalies only. Do not fix anything, do not drop anything,
do not impute anything. For each column report: dtype, n unique, n missing, min/max for
numerics, all distinct values for anything with fewer than 30 levels, and any change in
scale or format between the first and second half of the column. List every free-text
value verbatim. List every ID appearing more than once, with the fields that differ
between its rows. End with a numbered list of questions I need to answer before cleaning
can proceed.
```

The last sentence is the one that changes the interaction. You are asking for a list of
questions rather than a cleaned file, and the questions are the deliverable of this step.

What it is looking for, and how each one is detected:

| Failure | Detection |
|---|---|
| A column that changes meaning partway down | Plot every numeric column against row index. A step change in scale is obvious there and invisible in a summary statistic |
| Codes nobody wrote down | Value-count every categorical column and demand a meaning for every level, including the ones with two occurrences |
| Real data hiding in a notes column | Read every distinct value in every free-text column. All of them. There are usually fewer than fifty |
| Duplicates that are not identical | Count rows per ID; for every ID with more than one row, diff the rows and report the differing fields rather than dropping either |
| The header that is not the header | Print the first ten rows raw, as strings, before anything parses them |

Every one of these is something the model is good at finding and none of them is
something it should decide about. Ask it to enumerate; resolve them yourself.
