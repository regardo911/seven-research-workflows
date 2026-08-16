#!/usr/bin/env bash
# go.sh — usage: ./go.sh config.yaml
#
# Chapter 10, transcribed verbatim, including the hardcoded -j 4 that Chapter 7
# argues against. The README next to this file explains why it stayed.
set -euo pipefail
CONFIG="${1:?usage: ./go.sh <config.yaml>}"
command -v yq >/dev/null || { echo "MISSING TOOL: yq (needed to read $CONFIG)" >&2; exit 1; }

python3 scripts/snapshot.py "$(yq -r '.paths.samplesheet' "$CONFIG")"   # before-state, first thing to touch the raw file
snakemake --use-conda --configfile "$CONFIG" -j 4    # clean, analyse, plot
bash scripts/verify.sh "$CONFIG"                     # mechanical rubric rows; exits non-zero on failure

echo "Run complete. Now run the reviewer Skill against the run directory."
