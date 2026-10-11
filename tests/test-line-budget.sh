#!/usr/bin/env bash
# Verify every skill stays within line and step budgets.
# SKILL.md alone: fail >80 (it is a bootloader; detail belongs in skill.json, phases/ or reference/).
# Combined SKILL.md + skill.json: fail >150. Max steps: 8.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/tests/lib-categories.sh"
JQ="python $REPO_ROOT/tests/json_query.py"
ERRORS=0
WARNINGS=0

while IFS= read -r skill_json; do
  dir="$(dirname "$skill_json")"
  name=$($JQ get "$skill_json" name)
  skill_md="$dir/SKILL.md"

  # Skip deprecated/experimental
  json_status=$($JQ get "$skill_json" status 2>/dev/null || echo "unknown")
  if [[ "$json_status" == "deprecated" || "$json_status" == "experimental" ]]; then
    echo "SKIP: $name ($json_status)"
    continue
  fi

  # Combined line count
  json_lines=$(wc -l < "$skill_json")
  md_lines=0
  [[ -f "$skill_md" ]] && md_lines=$(wc -l < "$skill_md")
  combined=$((json_lines + md_lines))

  # Step count
  steps=$($JQ count "$skill_json" steps 2>/dev/null || echo "0")

  if [[ $combined -gt 150 ]]; then
    echo "FAIL: $name ($combined combined lines, max 150)"
    ERRORS=$((ERRORS + 1))
  elif [[ $combined -gt 120 ]]; then
    echo "WARN: $name ($combined combined lines, target <120)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "OK: $name ($combined lines)"
  fi

  if [[ $md_lines -gt 80 ]]; then
    echo "FAIL: $name (SKILL.md $md_lines lines, max 80)"
    ERRORS=$((ERRORS + 1))
  fi

  if [[ $steps -gt 8 ]]; then
    echo "FAIL: $name ($steps steps, max 8)"
    ERRORS=$((ERRORS + 1))
  fi
done < <(find $(category_dirs) -name "skill.json" 2>/dev/null)

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS budget violation(s)"
  exit 1
else
  echo "PASSED ($WARNINGS warning(s) over 120 lines)"
fi
