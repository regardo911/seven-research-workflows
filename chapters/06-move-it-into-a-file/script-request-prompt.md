<!-- Chapter 6, transcribed verbatim. Write the config by hand first. Then hand over
     this prompt, which asks for properties rather than for code. This is also the
     prompt that produces the three R steps the book never prints. -->
# The script-request prompt

Write `config.yaml` by hand, on your own, before you ask for any code. Ten minutes.
Doing that first changes what you get back, because you are now specifying rather than
describing.

Then:

```
Write run_analysis.sh plus the step scripts it calls, reading every parameter from
config.yaml. Requirements: set -euo pipefail; fail with a named error before doing any
work if an input path is missing; create the output directory; copy the config into it
as config.used.yaml; write run_info.txt with the run name, hostname and git commit;
tee every step's output to its own log in the run directory. No hardcoded paths, no
hardcoded thresholds, no subsetting anywhere. Print n per group before analysis.
```

Then run the six-item read-through in `read-through.md` with the script open. Expect to
find at least one thing.

Then run it on a deliberately broken config: point `counts` at a file that does not
exist. It must exit with your named error and produce no output directory. If it
creates the directory and then fails halfway, your failure handling is in the wrong
order and you will eventually get a half-populated run directory that looks complete.
