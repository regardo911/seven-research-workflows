#!/usr/bin/env bash
# run_analysis.sh — usage: ./run_analysis.sh config.yaml
#
# Chapter 6, transcribed verbatim. Wants yq and Rscript on PATH. The three R steps
# it calls are the stubs in ../07-make-it-reproduce/scripts/; see that README.
set -euo pipefail          # fail on error, unset variable, or broken pipe

CONFIG="${1:?usage: run_analysis.sh <config.yaml>}"
command -v yq >/dev/null || { echo "MISSING TOOL: yq (needed to read $CONFIG)" >&2; exit 1; }
OUTDIR=$(yq -r '.paths.outdir' "$CONFIG")

# Fail before doing any work if an input is missing.
for key in counts samplesheet annotation; do
  f=$(yq -r ".paths.$key" "$CONFIG")
  [[ -f "$f" ]] || { echo "MISSING INPUT: $key -> $f" >&2; exit 1; }
done

mkdir -p "$OUTDIR"
cp "$CONFIG" "$OUTDIR/config.used.yaml"       # the config and the outputs travel together

{
  echo "run:    $(yq -r '.run.name' "$CONFIG")"
  echo "note:   $(yq -r '.run.note' "$CONFIG")"
  echo "host:   $(hostname)"
  echo "git:    $(git rev-parse --short HEAD 2>/dev/null || echo 'not a git repo')"
} > "$OUTDIR/run_info.txt"

Rscript scripts/01_filter.R      "$CONFIG" 2>&1 | tee "$OUTDIR/01_filter.log"
Rscript scripts/02_de.R          "$CONFIG" 2>&1 | tee "$OUTDIR/02_de.log"
Rscript scripts/03_enrichment.R  "$CONFIG" 2>&1 | tee "$OUTDIR/03_enrichment.log"

echo "DONE -> $OUTDIR"
