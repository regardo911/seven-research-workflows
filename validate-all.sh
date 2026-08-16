#!/usr/bin/env bash
# validate-all.sh — usage: bash validate-all.sh [directory ...]
#
# The book's own self-test, run over the Skills this repo ships. With no arguments it
# checks every Skill under chapters/*/skills/. Give it directories and it checks those
# instead, which is how you point it at ~/.claude/skills after you have copied them:
#
#     bash validate-all.sh ~/.claude/skills
#
# Two things beyond the book's loop, both deliberate. An empty search exits non-zero
# rather than printing nothing and returning 0, because a loop over an empty directory
# looks exactly like a clean pass. And the reserved-word rule is checked here: a name
# containing "claude" or "anthropic" is invalid, agentskills does not catch it, and
# the book tells you to check it yourself. This is checking it yourself.
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -gt 0 ]]; then
  ROOTS=("$@")
else
  ROOTS=("$ROOT"/chapters/*/skills)
fi

command -v agentskills >/dev/null || {
  echo "MISSING TOOL: agentskills" >&2
  echo "  pip install skills-ref          # the package is skills-ref, the command is agentskills" >&2
  echo "  If it is already installed, pip put it in a Python you are not using." >&2
  exit 1
}

found=0
bad=0
for base in "${ROOTS[@]}"; do
  [[ -d "$base" ]] || continue
  while IFS= read -r d; do
    [[ -f "$d/SKILL.md" ]] || continue
    found=$(( found + 1 ))
    agentskills validate "$d" || { echo "FAILED: $d"; bad=1; }
    case "$(basename "$d")" in
      *claude*|*anthropic*)
        echo "FAILED: $d"
        echo "  Skill name '$(basename "$d")' may not contain 'claude' or 'anthropic'."
        echo "  agentskills returns Valid skill on this. It is still invalid."
        bad=1 ;;
    esac
  done < <(find "$base" -maxdepth 1 -type d 2>/dev/null | sort)
done

if [[ $found -eq 0 ]]; then
  echo "NO SKILLS FOUND — check the path before you read this as a pass"
  exit 1
fi

echo "$found Skills checked, $( [[ $bad -eq 0 ]] && echo "all valid" || echo "see failures above" )"
exit $bad
