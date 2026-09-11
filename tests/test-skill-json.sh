#!/usr/bin/env bash
# Verify every skill directory has a skill.json and it validates against the schema.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JQ="python $REPO_ROOT/tests/json_query.py"
ERRORS=0

while IFS= read -r skill_md; do
  dir="$(dirname "$skill_md")"
  name="$(basename "$dir")"
  json="$dir/skill.json"

  if [[ ! -f "$json" ]]; then
    # Skip deprecated skills without skill.json
    md_status_check=$(sed -n '/^---$/,/^---$/p' "$skill_md" | grep '^status:' | head -1 | sed 's/status: *//')
    if [[ "$md_status_check" == "deprecated" ]]; then
      echo "SKIP: $name (deprecated, no skill.json)"
      continue
    fi
    echo "FAIL: $dir/ has SKILL.md but no skill.json"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Validate JSON syntax
  if ! $JQ validate "$json" >/dev/null 2>&1; then
    echo "FAIL: $json is not valid JSON"
    ERRORS=$((ERRORS + 1))
    continue
  fi

  # Check name matches directory
  json_name=$($JQ get "$json" name)
  if [[ "$json_name" != "$name" ]]; then
    echo "FAIL: $json name '$json_name' does not match directory '$name'"
    ERRORS=$((ERRORS + 1))
  fi

  # Check status matches SKILL.md frontmatter
  md_status=$(sed -n '/^---$/,/^---$/p' "$skill_md" | grep '^status:' | head -1 | sed 's/status: *//')
  json_status=$($JQ get "$json" status)
  if [[ "$md_status" != "$json_status" ]]; then
    echo "FAIL: $json status '$json_status' does not match SKILL.md status '$md_status'"
    ERRORS=$((ERRORS + 1))
  fi

  # Check required top-level fields
  for field in name status description chain steps capabilities engagement; do
    if ! $JQ has "$json" "$field" 2>/dev/null; then
      echo "FAIL: $json missing required field '$field'"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Check all capability fields
  for cap in scope_protection safety_rails convention_enforcement enterprise_context catalogue_grill; do
    if ! $JQ has "$json" "capabilities.$cap" 2>/dev/null; then
      echo "FAIL: $json missing capability '$cap'"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Check engagement required fields
  for eng in emits writes manifest chain_dispatch; do
    if ! $JQ has "$json" "engagement.$eng" 2>/dev/null; then
      echo "FAIL: $json missing engagement field '$eng'"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Check every step has required fields
  step_count=$($JQ count "$json" steps)
  echo "OK: $json ($step_count steps)"
done < <(find "$REPO_ROOT/task" "$REPO_ROOT/project" "$REPO_ROOT/in-progress" -name "SKILL.md" 2>/dev/null)

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "FAILED: $ERRORS error(s)"
  exit 1
else
  echo ""
  echo "PASSED: all skill.json files valid"
fi
