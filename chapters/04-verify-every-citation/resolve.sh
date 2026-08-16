#!/usr/bin/env bash
# resolve.sh — usage: bash resolve.sh [--fixture] <identifier> [--year Y] [--journal J]
#                                     [--first-author A] [--title T]
#
# One reference, resolved and compared field by field. Crossref is the DOI authority
# and answers the existence question; the PMC ID Converter adds the PMID and PMCID
# when the paper is in PMC. Neither needs a key, an account or a signup.
#
# Three verdicts, and the exit code is the verdict:
#   0  resolves            record exists and every field you supplied matches
#   1  metadata mismatch   record exists, at least one field disagrees. Names which.
#   2  fabricated          no record retrieved
#   3  could not read      the fixture or the network was not there. Never a pass.
#
# --fixture reads committed responses from fixtures/ instead of the network, so the
# three verdicts are demonstrable with no connection. The fixture filename is the
# identifier with slashes turned into underscores.
#
# Supplying no fields gets you an existence check, and an existence check passes about
# a third of fabricated citations, so the output says so out loud.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAILTO="${CROSSREF_MAILTO:-you@example.org}"

FIXTURE=0; ID=""; C_TITLE=""; C_AUTHOR=""; C_YEAR=""; C_JOURNAL=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --fixture) FIXTURE=1; shift ;;
    --title) C_TITLE="${2:-}"; shift 2 ;;
    --first-author) C_AUTHOR="${2:-}"; shift 2 ;;
    --year) C_YEAR="${2:-}"; shift 2 ;;
    --journal) C_JOURNAL="${2:-}"; shift 2 ;;
    -h|--help) sed -n '2,26p' "${BASH_SOURCE[0]}"; exit 0 ;;
    -*) echo "unknown flag: $1" >&2; exit 3 ;;
    *) ID="$1"; shift ;;
  esac
done
[[ -n "$ID" ]] || { echo "usage: resolve.sh [--fixture] <identifier> [--year Y] [--journal J] [--first-author A] [--title T]" >&2; exit 3; }

SLUG="${ID//\//_}"
CROSSREF_JSON=""; IDCONV_JSON=""; SOURCE=""

if [[ "$FIXTURE" -eq 1 ]]; then
  cf="$HERE/fixtures/crossref-$SLUG.json"
  idf="$HERE/fixtures/idconv-$SLUG.json"
  if [[ ! -f "$cf" ]]; then
    echo "COULD NOT READ: no fixture at $cf"
    echo "  Fetch one and commit it, or drop --fixture and use the network."
    exit 3
  fi
  CROSSREF_JSON=$(cat "$cf")
  [[ -f "$idf" ]] && IDCONV_JSON=$(cat "$idf")
  SOURCE="fixture $(basename "$cf")"
else
  command -v curl >/dev/null || { echo "MISSING TOOL: curl" >&2; exit 3; }
  CROSSREF_JSON=$(curl -s --max-time 30 -H "User-Agent: seven-research-workflows (mailto:$MAILTO)" \
                  "https://api.crossref.org/works/$ID") || { echo "COULD NOT READ: Crossref did not answer"; exit 3; }
  IDCONV_JSON=$(curl -s --max-time 30 \
                "https://pmc.ncbi.nlm.nih.gov/tools/idconv/api/v1/articles/?ids=$ID&format=json")
  SOURCE="live: api.crossref.org + pmc.ncbi.nlm.nih.gov"
fi

read_record() {
  python3 - "$1" <<'PY'
import json, sys
try:
    m = json.loads(sys.argv[1])["message"]
except Exception:
    print("NONE"); raise SystemExit(0)
title = (m.get("title") or [""])[0]
authors = m.get("author") or [{}]
first = " ".join(x for x in (authors[0].get("family"), authors[0].get("given", "")[:1]) if x)
issued = (m.get("issued", {}).get("date-parts") or [[""]])[0]
year = str(issued[0]) if issued and issued[0] else ""
journal = (m.get("container-title") or [""])[0]
print("\t".join([title, first, year, journal]))
PY
}

RECORD=$(read_record "$CROSSREF_JSON")
echo "identifier   $ID"
echo "source       $SOURCE"

if [[ "$RECORD" == "NONE" ]]; then
  echo "record       (no record retrieved)"
  echo "VERDICT: fabricated"
  echo "  Remove the citation and the sentence it supports, or find a real source."
  exit 2
fi

R_TITLE=$(cut -f1 <<<"$RECORD"); R_AUTHOR=$(cut -f2 <<<"$RECORD")
R_YEAR=$(cut -f3 <<<"$RECORD");  R_JOURNAL=$(cut -f4 <<<"$RECORD")
echo "record       $R_TITLE"
echo "             first author $R_AUTHOR  year $R_YEAR  journal $R_JOURNAL"

if [[ -n "$IDCONV_JSON" ]]; then
  ids=$(python3 - "$IDCONV_JSON" <<'PY'
import json, sys
try:
    rec = (json.loads(sys.argv[1]).get("records") or [{}])[0]
except Exception:
    rec = {}
if rec.get("status") == "error":
    print("not in PMC: " + rec.get("errmsg", "no reason given"))
else:
    print("  ".join(f"{k} {rec[k]}" for k in ("pmid", "pmcid") if rec.get(k)) or "no PMC identifiers returned")
PY
)
  echo "pmc          $ids"
fi

mismatch=""
compare() {
  local field="$1" cited="$2" record="$3"
  [[ -n "$cited" ]] || return 0
  if [[ "$(tr '[:upper:]' '[:lower:]' <<<"$cited")" == "$(tr '[:upper:]' '[:lower:]' <<<"$record")" ]]; then
    echo "compared     $field: cited $cited, record $record   match"
  else
    echo "compared     $field: cited $cited, record $record   MISMATCH"
    mismatch="$mismatch $field"
  fi
}
compare title "$C_TITLE" "$R_TITLE"
compare "first author" "$C_AUTHOR" "$R_AUTHOR"
compare year "$C_YEAR" "$R_YEAR"
compare journal "$C_JOURNAL" "$R_JOURNAL"

if [[ -n "$mismatch" ]]; then
  echo "VERDICT: metadata mismatch ($(echo "$mismatch" | sed 's/^ //;s/ /, /g'))"
  echo "  The identifier is real. The citation is not. Fix the field, not the check."
  exit 1
fi

if [[ -z "$C_TITLE$C_AUTHOR$C_YEAR$C_JOURNAL" ]]; then
  echo "VERDICT: resolves (EXISTENCE ONLY)"
  echo "  Nothing was compared. An existence check passes about a third of fabricated"
  echo "  citations, because a corrupted year or journal still resolves. Pass --year,"
  echo "  --journal, --first-author or --title to make this mean something."
  exit 0
fi

echo "VERDICT: resolves"
exit 0
