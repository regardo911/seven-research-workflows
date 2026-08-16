#!/usr/bin/env bash
# scripts/verify.sh — usage: bash scripts/verify.sh config.yaml
# The rubric rows that are pure file operations. No model is consulted.
#
# Rows 3 and 4 are the book's, transcribed. Rows 1, 2, 6 and 8 are the ones Chapter 8
# tells you to add "in the same file on the same pattern", written here so you can read
# them rather than reinvent them. Every check prints its comparison and sets fail=1
# instead of exiting, so one run tells you everything that is broken. And every field
# comparison is awk, not grep -P, because the stock grep on macOS rejects -P outright
# and a check that errors out looks exactly like a check that failed.
#
# Rows 5, 7, 9 and 10 are not here and never will be. They need reading comprehension.
# They belong to the reviewer Skill.
set -uo pipefail
CONFIG="${1:?usage: verify.sh <config.yaml>}"
command -v yq >/dev/null || { echo "MISSING TOOL: yq (needed to read $CONFIG)" >&2; exit 1; }

# Paths in a config are relative to the config, which is how the book's project layout
# works (config.yaml at the project root). Resolving them here means a config can be
# run from any directory instead of only from the one it was written in.
CFGDIR=$(cd "$(dirname "$CONFIG")" && pwd)
rel() { case "$1" in /*|"") echo "$1";; *) echo "$CFGDIR/$1";; esac; }

RUN=$(rel "$(yq -r '.paths.outdir' "$CONFIG")")
DRAFT=$(rel "$(yq -r '.paths.draft // ""' "$CONFIG")")
S2P=$(rel "$(yq -r '.paths.sample_to_patient // ""' "$CONFIG")")
S2S=$(rel "$(yq -r '.paths.sample_to_site // ""' "$CONFIG")")
fail=0

# A row that cannot read its file is INCONCLUSIVE, never PASS, and INCONCLUSIVE is not
# a pass here either: the rubric says never RELEASE with one outstanding.
inconclusive() { echo "INCONCLUSIVE $1  cannot read: $2"; fail=1; }

# ROW 1 — patient-level leakage
overlap() {
  local row="$1" what="$2" map="$3"
  if [[ ! -f "$RUN/splits/train_ids.txt" || ! -f "$RUN/splits/test_ids.txt" ]]; then
    inconclusive "$row" "$RUN/splits/{train,test}_ids.txt"; return
  fi
  if [[ -z "$map" || ! -f "$map" ]]; then
    inconclusive "$row" "the sample-to-$what map (paths.sample_to_$what)"; return
  fi
  join -1 1 -2 1 \
    <(sort "$RUN/splits/train_ids.txt" | join - <(sort "$map") | cut -d' ' -f2 | sort -u) \
    <(sort "$RUN/splits/test_ids.txt"  | join - <(sort "$map") | cut -d' ' -f2 | sort -u) \
    > "$RUN/.leak_$what.txt"
  local n; n=$(wc -l < "$RUN/.leak_$what.txt" | tr -d ' ')
  echo "$row  train x test $what overlap: $n"
  if [[ "$n" -gt 0 ]]; then
    echo "FAIL $row  ${what}s in both splits: $(tr '\n' ' ' < "$RUN/.leak_$what.txt")"; fail=1
  else
    echo "PASS $row  no $what overlap between train and test"
  fi
  rm -f "$RUN/.leak_$what.txt"
}

overlap row1 patient "$S2P"

# ROW 2 — site-level leakage. Zero overlap is often impossible, and when it is, the
# honest move is not to pass the check: it is to record that the check cannot pass and
# say so in your methods. So this fails, and you write the sentence.
overlap row2 site "$S2S"

# ROW 3 — controls present, with a non-zero count
for c in $(yq -r '.design.controls[]' "$CONFIG"); do
  if awk -F'\t' -v c="$c" '$1 == c && $2 + 0 > 0 {found = 1} END {exit !found}' "$RUN/final_table.tsv"; then
    echo "PASS row3  control present, count > 0: $c"
  else
    echo "FAIL row3  control missing or zero: $c"; fail=1
  fi
done

# ROW 4 — row reconciliation.
# The book reads before.json from the current directory. Every other artifact is
# run-scoped, so two configs in sequence overwrite each other's before-state and this
# row then reconciles run B's output against run A's input, closing perfectly. Prefer
# the run-scoped copy, fall back to the printed behaviour, and say which one was read.
SNAP="$RUN/before.json"; [[ -f "$SNAP" ]] || SNAP="before.json"
if [[ -f "$SNAP" ]]; then
  echo "row4  before-state read from $SNAP"
  rows_in=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["n_rows"])' "$SNAP")
  rows_out=$(( $(wc -l < "$RUN/final_table.tsv") - 1 ))
  dropped=$(awk -F'\t' 'NR>1 {s+=$3} END {print s+0}' "$RUN/drop_log.tsv")
  echo "row4  $rows_in in = $rows_out out + $dropped dropped"
  if [[ $(( rows_out + dropped )) -ne $rows_in ]]; then
    echo "FAIL row4  arithmetic does not close"; fail=1
  else
    echo "PASS row4  arithmetic closes"
  fi
else
  inconclusive row4 "before.json (run snapshot.py before you clean)"
fi

# ROW 6 — n matches. The draft has to state its n where a machine can find it: this
# looks for "n = <integer>". A draft that phrases it any other way is INCONCLUSIVE,
# which is the honest verdict, and the fix is to write the number down.
if [[ -z "$DRAFT" || ! -f "$DRAFT" ]]; then
  inconclusive row6 "the draft (paths.draft)"
else
  post_qc=$(( $(wc -l < "$RUN/final_table.tsv") - 1 ))
  reported=$(grep -oE 'n *= *[0-9]+' "$DRAFT" | grep -oE '[0-9]+' | sort -u)
  if [[ -z "$reported" ]]; then
    inconclusive row6 "no 'n = <integer>' in $DRAFT"
  else
    for r in $reported; do
      echo "row6  draft says n = $r, post-QC rows = $post_qc"
      [[ "$r" -ne "$post_qc" ]] && { echo "FAIL row6  reported n differs from post-QC n"; fail=1; } \
                                || echo "PASS row6  reported n equals post-QC n"
    done
  fi
fi

# ROW 8 — numbers trace. A grep, and the book says so. It is a floor, not a proof:
# a substring match means 91 is satisfied by S091. A number it cannot find anywhere
# under the run directory came from your memory or the model's, and both need checking.
if [[ -z "$DRAFT" || ! -f "$DRAFT" ]]; then
  inconclusive row8 "the draft (paths.draft)"
else
  missing=""; total=0
  for n in $(grep -oE '[0-9]+(\.[0-9]+)?' "$DRAFT" | sort -u); do
    total=$(( total + 1 ))
    grep -qrF -- "$n" "$RUN" || missing="$missing $n"
  done
  echo "row8  $total distinct numbers in $(basename "$DRAFT"), searched $RUN"
  if [[ -n "$missing" ]]; then
    echo "FAIL row8  numbers appearing in no run file:$missing"; fail=1
  else
    echo "PASS row8  every prose number appears in a run file"
  fi
fi

exit $fail
