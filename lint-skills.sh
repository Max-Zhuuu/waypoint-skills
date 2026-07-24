#!/usr/bin/env bash
# Lint SKILL.md files against the line budget.
# Warn >80, fail >100. Exit 1 if any file exceeds 100 lines.

set -euo pipefail

warn=80
fail=100
exit_code=0

for f in $(find task project in-progress third-party -name SKILL.md 2>/dev/null | sort); do
  lines=$(wc -l < "$f")
  skill=$(dirname "$f" | sed 's|.*/||')

  if [ "$lines" -gt "$fail" ]; then
    echo "FAIL: $skill ($lines lines, max $fail) - $f"
    exit_code=1
  elif [ "$lines" -gt "$warn" ]; then
    echo "WARN: $skill ($lines lines, target <=$warn) - $f"
  fi
done

if [ "$exit_code" -eq 0 ]; then
  echo "All SKILL.md files within line budget."
fi

exit $exit_code
