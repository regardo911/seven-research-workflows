#!/usr/bin/env bash
# equivalence-check.sh — usage: bash equivalence-check.sh <runA> <runB> <tolerance>
#
# Chapter 7's two-part check, taking the two run directories and the tolerance as
# arguments rather than baking them in. The tolerance is the argument that matters:
# write it down before you look at the results, because a tolerance chosen after
# seeing the difference is not a tolerance, it is a rationalisation.
#
# The bar is not "the output files are identical byte for byte". Nobody has
# established when a bioinformatics pipeline is byte-reproducible and plenty of
# legitimate steps are not. The bar is an identical top-100 gene list and a maximum
# absolute log2 fold-change difference below a number you committed to in advance.
#
# Exit 0 when both hold, 1 when either does not.
set -uo pipefail
A="${1:?usage: equivalence-check.sh <runA> <runB> <tolerance>}"
B="${2:?usage: equivalence-check.sh <runA> <runB> <tolerance>}"
TOL="${3:?usage: equivalence-check.sh <runA> <runB> <tolerance>   (e.g. 0.000001)}"

for f in "$A/de_results.tsv" "$B/de_results.tsv"; do
  [[ -f "$f" ]] || { echo "MISSING INPUT: $f" >&2; exit 1; }
done

fail=0

if diff <(cut -f1 "$A/de_results.tsv" | head -100) \
        <(cut -f1 "$B/de_results.tsv" | head -100); then
  echo "TOP-100 GENE LIST: identical"
else
  echo "TOP-100 GENE LIST: differs, see the diff above"; fail=1
fi

MAX=$(awk 'NR==FNR{a[$1]=$3; next} $1 in a {d=($3-a[$1]); if (d<0) d=-d; if (d>max) max=d}
     END{printf "%.6f\n", max}' \
     "$A/de_results.tsv" "$B/de_results.tsv")
printf 'max |log2FC| difference: %s\n' "$MAX"
printf 'tolerance recorded in advance: %s\n' "$TOL"

if awk -v m="$MAX" -v t="$TOL" 'BEGIN{exit !(m <= t)}'; then
  echo "WITHIN TOLERANCE"
else
  echo "OVER TOLERANCE"; fail=1
fi

exit $fail
