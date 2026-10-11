#!/usr/bin/env bash
# AC7: every doc-writing skill resolves {DOCS} through one rule (internals/engagement/doc-root.md).
#   1. Invariant: no skill or internals file hard-codes docs/specs or docs/design.
#   2. scripts/resolve-doc-root.sh picks the right branch in fixture trees.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
source "$REPO_ROOT/tests/lib-categories.sh"
RESOLVE="$REPO_ROOT/scripts/resolve-doc-root.sh"
ERRORS=0
fail() { echo "FAIL: $1"; ERRORS=$((ERRORS + 1)); }

# 1. Invariant.
while IFS= read -r hit; do
  fail "hard-coded doc path: ${hit#"$REPO_ROOT"/}"
done < <(grep -rnE '(^|[^_{A-Za-z])docs/(specs|design)' $(category_dirs) "$REPO_ROOT/internals" \
  | grep -v "internals/engagement/doc-root.md:" || true)

# 2. Resolution in fixture trees.
[[ -x "$RESOLVE" ]] || { echo "FAIL: $RESOLVE missing or not executable"; exit 1; }
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

expect() { # expect <dir> <want> <case>
  local got
  got="$(cd "$1" && "$RESOLVE")" || { fail "$3: resolver exited non-zero"; return; }
  [[ "$got" == "$2" ]] && echo "OK: $3 -> $got" || fail "$3: want '$2', got '$got'"
}

# Declared in CLAUDE.md ## Docs.
mkdir -p "$TMP/declared"
printf '# X\n\n## Docs\n\nDoc root: `documentation/`\n\n## Other\n' > "$TMP/declared/CLAUDE.md"
expect "$TMP/declared" "documentation/" "declared root"

# _docs/ present, nothing declared.
mkdir -p "$TMP/underscore/_docs"
expect "$TMP/underscore" "_docs/" "_docs/ present"

# Neither: default.
mkdir -p "$TMP/plain"
expect "$TMP/plain" "docs/" "default"

# Declaration and _docs/ disagree: the declaration wins.
mkdir -p "$TMP/both/_docs"
printf '## Docs\n\nDoc root: `docs/`\n' > "$TMP/both/CLAUDE.md"
expect "$TMP/both" "docs/" "declaration beats _docs/"

# A ## Docs section without a Doc root line does not count as a declaration.
mkdir -p "$TMP/nodecl/_docs"
printf '## Docs\n\nSee the table.\n' > "$TMP/nodecl/CLAUDE.md"
expect "$TMP/nodecl" "_docs/" "## Docs without a Doc root line"

# Workspace: a git repo inside a workspace uses its own root, not the parent's declaration or _docs/.
mkdir -p "$TMP/ws/_docs" "$TMP/ws/repo-a/src"
printf '## Docs\n\nDoc root: `_docs/`\n' > "$TMP/ws/CLAUDE.md"
git -C "$TMP/ws/repo-a" init -q
expect "$TMP/ws" "_docs/" "workspace root"
expect "$TMP/ws/repo-a/src" "docs/" "child repo inside a workspace"

# Non-git subdirectory of a workspace resolves from the workspace root.
mkdir -p "$TMP/ws/_docs/specs"
expect "$TMP/ws/_docs/specs" "_docs/" "non-git subdirectory"

# --root prints the project root the answer is relative to.
got="$(cd "$TMP/ws/repo-a/src" && "$RESOLVE" --root)"
[[ "$(cd "$got" && pwd -P)" == "$(cd "$TMP/ws/repo-a" && pwd -P)" ]] && echo "OK: --root" || fail "--root: got '$got'"

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "FAILED: $ERRORS error(s)"
  exit 1
fi
echo ""
echo "PASSED: doc root resolution"
