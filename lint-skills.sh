#!/usr/bin/env bash
# Lint SKILL.md files.
#   Pass 1 - line budget: warn >80, fail >100.
#   Pass 2 - Writes/manifest convention (section 12 + section 15):
#     a skill's `Writes:` declaration must be honest and manifest-linked, so a
#     nonstandard declaration can never silently skip the artifacts manifest.
# Exit 1 if any file fails either pass.

set -euo pipefail

warn=80
fail=100
exit_code=0

files=$(find task project in-progress third-party -name SKILL.md 2>/dev/null | sort)

echo "Line budget:"
for f in $files; do
  lines=$(wc -l < "$f")
  skill=$(dirname "$f" | sed 's|.*/||')

  if [ "$lines" -gt "$fail" ]; then
    echo "  FAIL: $skill ($lines lines, max $fail) - $f"
    exit_code=1
  elif [ "$lines" -gt "$warn" ]; then
    echo "  WARN: $skill ($lines lines, target <=$warn) - $f"
  fi
done

echo ""
echo "Writes/manifest convention:"
for f in $files; do
  skill=$(dirname "$f" | sed 's|.*/||')

  # Skills that carry no `## Engagement` block opt out of the convention
  # (e.g. third-party wrappers, in-progress skills). Flag, but do not fail.
  if ! grep -qE '^## Engagement' "$f"; then
    echo "  WARN: $skill has no ## Engagement block (convention checks skipped) - $f"
    continue
  fi

  # The two declaration lines are mandatory (section 12).
  grep -qE 'Emits:'  "$f" || { echo "  FAIL: $skill Engagement block has no Emits: line - $f";  exit_code=1; }
  grep -qE 'Writes:' "$f" || { echo "  FAIL: $skill Engagement block has no Writes: line - $f"; exit_code=1; continue; }

  # `Writes: none` (any trailing prose after `none` is fine, e.g. ship's PR note).
  if grep -qiE 'Writes:[[:space:]]*none' "$f"; then
    writes_none=yes
  else
    writes_none=no
  fi

  cites_manifest=no
  grep -qiE 'artifacts manifest|section 15' "$f" && cites_manifest=yes

  # Check B - manifest linkage: a writing skill must cite section 15 at its
  # Exit, or its manifest is silently skipped at run time (section 15.4).
  if [ "$writes_none" = "no" ] && [ "$cites_manifest" = "no" ]; then
    echo "  FAIL: $skill declares Writes but never cites the section 15 manifest (manifest would be silently skipped) - $f"
    exit_code=1
  fi

  # Check C - outputs/Writes honesty: every frontmatter `outputs:` key other
  # than `concerns` names a produced artifact, so `Writes:` cannot be `none`.
  nonconcern_output=no
  while IFS= read -r key; do
    [ -z "$key" ] && continue
    [ "$key" != "concerns" ] && nonconcern_output=yes
  done < <(awk '
    /^outputs:[[:space:]]*$/         { inblock=1; next }
    inblock && /^[^[:space:]]/       { inblock=0 }
    inblock && /^[[:space:]]+[A-Za-z][A-Za-z0-9_-]*:/ {
      k=$1; sub(/:.*/,"",k); gsub(/[[:space:]]/,"",k); print k
    }
  ' "$f")

  if [ "$nonconcern_output" = "yes" ] && [ "$writes_none" = "yes" ]; then
    echo "  FAIL: $skill frontmatter outputs declares produced artifacts but footer says Writes: none - $f"
    exit_code=1
  fi
done

echo ""
if [ "$exit_code" -eq 0 ]; then
  echo "All SKILL.md files pass line budget and the Writes/manifest convention."
fi

exit $exit_code
