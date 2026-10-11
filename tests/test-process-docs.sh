#!/usr/bin/env bash
# Verify every process doc referenced by a skill.json exists.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/tests/lib-categories.sh"
JQ="python $REPO_ROOT/tests/json_query.py"
ERRORS=0

while IFS= read -r json; do
  dir="$(dirname "$json")"
  name=$($JQ get "$json" name)

  while IFS= read -r proc; do
    [[ -z "$proc" ]] && continue
    file_path="${proc%%#*}"

    # Check repo root, skill directory, and ../../ from skill dir
    if [[ -f "$REPO_ROOT/$file_path" ]]; then
      continue
    elif [[ -f "$dir/$file_path" ]]; then
      continue
    elif [[ -f "$dir/../../$file_path" ]]; then
      continue
    fi

    echo "FAIL: $name references '$proc' (not found at repo root, skill dir, or ../../)"
    ERRORS=$((ERRORS + 1))
  done < <($JQ flat-list "$json" steps.process 2>/dev/null)
done < <(find $(category_dirs) -name "skill.json" 2>/dev/null)

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS missing process doc(s)"
  exit 1
else
  echo "PASSED: all referenced process docs exist"
fi
