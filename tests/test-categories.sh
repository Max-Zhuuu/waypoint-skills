#!/usr/bin/env bash
# Verify skill-categories.txt is the single list of skill categories.
#   1. Every top-level directory holding */SKILL.md is a listed category or third-party/.
#   2. No test, sync script or CI file hard-codes the category list.
#   3. plugin.json lists every skill outside in-progress/, and every entry exists.
#   4. CI triggers on every category.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LIST="$REPO_ROOT/skill-categories.txt"
ERRORS=0
fail() { echo "FAIL: $1"; ERRORS=$((ERRORS + 1)); }

[[ -f "$LIST" ]] || { echo "FAIL: skill-categories.txt missing"; exit 1; }
categories=$(grep -vE '^[[:space:]]*(#|$)' "$LIST" | tr -d '\r')

# 1. Every directory that holds skills is declared.
while IFS= read -r top; do
  [[ "$top" == "third-party" ]] && continue
  grep -qxF "$top" <<<"$categories" || fail "$top/ holds skills but is not in skill-categories.txt"
done < <(cd "$REPO_ROOT" && find . -mindepth 3 -maxdepth 3 -name SKILL.md -not -path './.git/*' | cut -d/ -f2 | sort -u)

while IFS= read -r c; do
  [[ -d "$REPO_ROOT/$c" ]] || fail "category '$c' in skill-categories.txt has no directory"
done <<<"$categories"

# 2. No hard-coded category lists. Two adjacent category names inside quotes,
#    a find over "$REPO_ROOT/<category>", or a ("task", ...) tuple all count.
pattern='"\$REPO_ROOT/(task|project|design|in-progress)"|\("task", *"project"|@\("task"|find task project'
while IFS= read -r hit; do
  fail "hard-coded category list: $hit"
done < <(cd "$REPO_ROOT" && grep -rnE "$pattern" tests sync-skills.ps1 sync-skills.sh .github 2>/dev/null | grep -v 'tests/test-categories.sh' || true)

for f in sync-skills.ps1 sync-skills.sh tests/test_chain.py; do
  grep -q 'skill-categories.txt' "$REPO_ROOT/$f" || fail "$f does not read skill-categories.txt"
done

# 3. plugin.json matches the tree.
plugin="$REPO_ROOT/.claude-plugin/plugin.json"
entries=$(python3 -c 'import json,sys; [print(s.removeprefix("./")) for s in json.load(open(sys.argv[1]))["skills"]]' "$plugin")
while IFS= read -r e; do
  [[ -f "$REPO_ROOT/$e/SKILL.md" ]] || fail "plugin.json lists '$e', which has no SKILL.md"
done <<<"$entries"
for c in $(grep -vx 'in-progress' <<<"$categories") third-party; do
  for d in "$REPO_ROOT/$c"/*/; do
    [[ -f "$d/SKILL.md" ]] || continue
    rel="${d#"$REPO_ROOT"/}"; rel="${rel%/}"
    grep -qxF "$rel" <<<"$entries" || fail "plugin.json does not list '$rel'"
  done
done

# 4. CI runs on a change to any category.
ci="$REPO_ROOT/.github/workflows/test-skills.yml"
while IFS= read -r c; do
  grep -qF "'$c/**'" "$ci" || fail "test-skills.yml paths miss '$c/**'"
done <<<"$categories"
grep -qF 'skill-categories.txt' "$ci" || fail "test-skills.yml paths miss 'skill-categories.txt'"

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "FAILED: $ERRORS error(s)"
  exit 1
fi
echo "PASSED: skill categories consistent ($(wc -l <<<"$categories" | tr -d ' ') categories)"
