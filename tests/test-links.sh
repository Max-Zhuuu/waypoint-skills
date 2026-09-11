#!/usr/bin/env bash
# Verify every path in skill.json references and reads resolves in the repo layout.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ERRORS=0
WARNINGS=0

while IFS= read -r json; do
  dir="$(dirname "$json")"

  # Check step-level reads (project-root-relative paths and globs)
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    # Skip glob patterns (contain *)
    if [[ "$path" == *"*"* ]]; then
      continue
    fi
    if [[ ! -e "$REPO_ROOT/$path" && ! -e "$dir/$path" ]]; then
      echo "WARN: $json references '$path' (not found - may be project-relative)"
      WARNINGS=$((WARNINGS + 1))
    fi
  done < <(jq -r '.steps[]?.reads[]? // empty' "$json" 2>/dev/null)

  # Check step-level references (skill-directory-relative paths)
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    if [[ ! -f "$dir/$path" ]]; then
      echo "FAIL: $json references '$path' (not found at $dir/$path)"
      ERRORS=$((ERRORS + 1))
    fi
  done < <(jq -r '.steps[]?.references[]? // empty' "$json" 2>/dev/null)

  # Check step-level process refs (shared-infra-relative, resolve via ../../)
  while IFS= read -r path; do
    [[ -z "$path" ]] && continue
    # Strip #anchor
    file_path="${path%%#*}"
    resolved="$REPO_ROOT/$file_path"
    if [[ ! -f "$resolved" ]]; then
      echo "FAIL: $json process ref '$path' (not found at $resolved)"
      ERRORS=$((ERRORS + 1))
    fi
  done < <(jq -r '.steps[]?.process? // empty' "$json" 2>/dev/null)

done < <(find "$REPO_ROOT/task" "$REPO_ROOT/project" "$REPO_ROOT/in-progress" -name "skill.json" 2>/dev/null)

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "FAILED: $ERRORS broken link(s), $WARNINGS warning(s)"
  exit 1
else
  echo "PASSED: all links resolve ($WARNINGS warnings - project-relative paths not verified)"
fi
