#!/usr/bin/env bash
# Verify every SKILL.md stays within line budget. Warn >80, fail >100.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

while IFS= read -r skill_md; do
  lines=$(wc -l < "$skill_md")
  name="$(basename "$(dirname "$skill_md")")"

  if [[ $lines -gt 100 ]]; then
    echo "FAIL: $name ($lines lines, max 100)"
    ERRORS=$((ERRORS + 1))
  elif [[ $lines -gt 80 ]]; then
    echo "WARN: $name ($lines lines, target <80)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "OK: $name ($lines lines)"
  fi
done < <(find "$REPO_ROOT/task" "$REPO_ROOT/project" "$REPO_ROOT/in-progress" -name "SKILL.md" 2>/dev/null)

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS file(s) over 100 lines"
  exit 1
else
  echo "PASSED ($WARNINGS warning(s) over 80 lines)"
fi
