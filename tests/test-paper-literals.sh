#!/usr/bin/env bash
# AC1 + AC9 for the Paper skill family (design/{to,from,prot}-paper).
#   1. No project literals from the skills' IvyPi origin (prefix, token file, framework, fonts, components).
#   2. Every JSON file parses.
#   3. Every relative link resolves.
#   4. Project values come from the shared resolution block, not literals.
#   5. AC9: motion is read from or drawn as frame strips; nothing writes transition/animation into Paper.
# PAPER_SKILLS_DIR checks another layout, such as the installed ~/.claude/skills.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="${PAPER_SKILLS_DIR:-$REPO_ROOT/design}"
RESOLUTION="from-paper/reference/project-conventions.md"
SKILLS=(to-paper from-paper prot-paper)
ERRORS=0
fail() { echo "FAIL: $1"; ERRORS=$((ERRORS + 1)); }

[[ -f "$SKILLS_DIR/$RESOLUTION" ]] || fail "resolution block $RESOLUTION missing"

for skill in "${SKILLS[@]}"; do
  dir="$SKILLS_DIR/$skill"
  [[ -d "$dir" ]] || { fail "$skill missing"; continue; }

  while IFS= read -r hit; do
    fail "project literal: ${hit#"$SKILLS_DIR"/}"
  done < <(grep -rniE --exclude-dir=.git 'ivy|tokens\.css|Next\.js|next/font|Geist|Jost|ScrollReveal|use client' "$dir" || true)

  while IFS= read -r json; do
    python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$json" 2>/dev/null || fail "invalid JSON: ${json#"$SKILLS_DIR"/}"
  done < <(find "$dir" -name '*.json' -not -path '*/.git/*')

  while IFS=: read -r file link; do
    [[ -e "$(dirname "$file")/$link" ]] || fail "${file#"$SKILLS_DIR"/} -> $link does not resolve"
  done < <(grep -roE --exclude-dir=.git '\]\(\.\.?/[^)#]+|\]\([a-z][a-z0-9/._-]*\.(md|json)|"\.\.?/[^"#]+\.(md|json)' "$dir" | sed -E 's/:\]\(/:/; s/:"/:/')

  grep -rqF --exclude-dir=.git 'project-conventions.md' "$dir" || fail "$skill does not use the shared resolution block"

  while IFS= read -r hit; do
    fail "writes motion CSS into Paper: ${hit#"$SKILLS_DIR"/}"
  done < <(grep -rniE --exclude-dir=.git '(write_html|update_styles)[^.]*(transition|animation|@keyframes)' "$dir" | grep -viE 'never|not|no |forbid|drop' || true)
  grep -rqiE --exclude-dir=.git 'frame strip' "$dir" || fail "$skill never mentions the motion frame-strip format"
done

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "FAILED: $ERRORS error(s)"
  exit 1
fi
echo "PASSED: Paper skills (${SKILLS[*]}) in ${SKILLS_DIR/#$HOME/~}"
