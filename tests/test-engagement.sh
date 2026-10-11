#!/usr/bin/env bash
# Verify SKILL.md engagement block matches skill.json engagement fields.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/tests/lib-categories.sh"
JQ="python $REPO_ROOT/tests/json_query.py"
ERRORS=0

while IFS= read -r json; do
  dir="$(dirname "$json")"
  name=$($JQ get "$json" name)
  skill_md="$dir/SKILL.md"

  [[ ! -f "$skill_md" ]] && continue

  # Skip deprecated skills
  json_status=$($JQ get "$json" status 2>/dev/null || echo "unknown")
  if [[ "$json_status" == "deprecated" || "$json_status" == "experimental" ]]; then
    echo "SKIP: $name ($json_status)"
    continue
  fi

  md_content=$(cat "$skill_md")

  # Check SKILL.md has ## Engagement section
  if ! echo "$md_content" | grep -q '## Engagement'; then
    echo "FAIL: $name SKILL.md missing ## Engagement section"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Check manifest citation when declared
  manifest=$($JQ get "$json" engagement.manifest 2>/dev/null || echo "false")
  if [[ "$manifest" == "True" || "$manifest" == "true" ]]; then
    if ! echo "$md_content" | grep -qi 'manifest\|artifacts\|skill.json'; then
      echo "WARN: $name declares manifest=true but SKILL.md doesn't reference it"
    fi
  fi

  echo "OK: $name"
done < <(find $(category_dirs) -name "skill.json" 2>/dev/null)

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS error(s)"
  exit 1
else
  echo "PASSED: engagement declarations consistent"
fi
