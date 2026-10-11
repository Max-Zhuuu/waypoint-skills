#!/usr/bin/env bash
# AC8: scripts/discover-project-state.sh is workspace-aware and never writes into the project tree.
#   - A workspace root (not inside git, 2+ child repos) emits workspace: true and repos[].
#   - A single repo emits the same fields and values as the pre-workspace script (main@ac73e2d).
#   - A repo without commits, an empty dir, one child repo, and a repo holding repos are not workspaces.
#   - Output goes to $CLAUDE_CONFIG_DIR/projects/<slug>/project-state.json.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="$REPO_ROOT/scripts/discover-project-state.sh"
ERRORS=0
fail() { echo "FAIL: $1"; ERRORS=$((ERRORS + 1)); }
ok() { echo "OK: $1"; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
TMP="$(cd "$TMP" && pwd -P)"
export CLAUDE_CONFIG_DIR="$TMP/claude"

slug() { printf '%s' "$1" | sed 's/[^A-Za-z0-9]/-/g'; }
json() { python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(eval(sys.argv[2], {"d": d}))' "$@" 2>/dev/null || echo "<unreadable>"; }

# run <dir>: runs the script there, checks nothing in <dir> changed, sets $state to the state file.
# Not called inside $(...), so fail() counts in this shell.
run() {
  local dir="$1" marker="$TMP/marker"
  touch "$marker"; sleep 1
  (cd "$dir" && bash "$SCRIPT" >/dev/null) || fail "script exited non-zero in $dir"
  local changed
  changed="$(find "$dir" -newer "$marker" -not -path '*/.git/*' | head -5)"
  [[ -z "$changed" ]] || fail "wrote inside the project tree: $changed"
  state="$CLAUDE_CONFIG_DIR/projects/$(slug "$dir")/project-state.json"
  [[ -f "$state" ]] || { fail "no state file at $state"; state="/dev/null"; }
}

# Workspace: three repos (two nested one level down, one .NET), a worktree checkout (.git file) and a plain folder.
WS="$TMP/My Workspace"
mkdir -p "$WS/web" "$WS/group/api" "$WS/group/app" "$WS/web-wt" "$WS/_docs"
touch "$WS/group/app/App.sln"; git -C "$WS/group/app" init -q
printf '{"dependencies":{"vue":"^3"}}' > "$WS/web/package.json"; touch "$WS/web/pnpm-lock.yaml"
printf '[project]\nname="api"\ndependencies=["fastapi"]\n' > "$WS/group/api/pyproject.toml"; touch "$WS/group/api/uv.lock"
git -C "$WS/web" init -q; git -C "$WS/group/api" init -q
echo "gitdir: elsewhere" > "$WS/web-wt/.git"
run "$WS"
[[ "$(json "$state" 'd.get("workspace")')" == "True" ]] && ok "workspace detected" || fail "workspace: want true"
got="$(json "$state" 'sorted((r["path"], r["framework"], r["package_manager"]) for r in d["repos"])')"
want="[('group/api', 'fastapi', 'uv'), ('group/app', 'dotnet', 'nuget'), ('web', 'vue3', 'pnpm')]"
[[ "$got" == "$want" ]] && ok "repos[] has all three repos, worktree skipped" || fail "repos: want $want, got $got"
[[ "$(json "$state" '"framework" in d')" == "False" ]] && ok "no single-project fields in a workspace" || fail "workspace output has single-project fields"

# Single repo: same output as the pre-workspace script (main@ac73e2d), apart from generated_at.
# GOLDEN is that script's output on this fixture, captured once (CI's shallow clone can't run it).
GOLDEN='{"ci_platform": "github_actions", "deploy_provider": "vercel", "external_connectors": ["posthog"], "file_count": 1, "framework": "react", "git": {"age_days": 0, "commits": 1}, "linter": "unknown", "package_manager": "npm", "project_docs": {"ARCHITECTURE.json": false, "ARCHITECTURE.md": false, "CLAUDE.md": true, "CONCERNS.md": false, "CONTEXT.json": false, "CONVENTIONS.json": false, "CONVENTIONS.md": false, "DEPLOY.json": false, "DEPLOY.md": false, "GLOSSARY.md": false, "SCOPE.json": false, "SCOPE.md": false, "TESTING.md": false}, "test_runner": "unknown"}'
ONE="$TMP/one"
mkdir -p "$ONE/src" "$ONE/.github/workflows"
printf '{"dependencies":{"react":"^18","posthog-js":"1"}}' > "$ONE/package.json"; touch "$ONE/package-lock.json" "$ONE/vercel.json" "$ONE/CLAUDE.md"
echo "x" > "$ONE/src/a.tsx"
git -C "$ONE" init -q
git -C "$ONE" -c user.name=t -c user.email=t@t add -A
git -C "$ONE" -c user.name=t -c user.email=t@t commit -qm init
run "$ONE"
same="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); d.pop("generated_at"); print(d == json.loads(sys.argv[2]))' "$state" "$GOLDEN" 2>/dev/null)" || same="unreadable"
[[ "$same" == "True" ]] && ok "single repo output matches the old script" || fail "single repo output differs from the old script: $(cat "$state")"

# A fresh repo with no commits reports 0 commits instead of failing.
FRESH="$TMP/fresh"; mkdir -p "$FRESH"; git -C "$FRESH" init -q
run "$FRESH"
[[ "$(json "$state" 'd["git"]["commits"]')" == "0" ]] && ok "fresh repo without commits" || fail "fresh repo: $(cat "$state")"

# Empty directory: not a workspace, unknown fields.
EMPTY="$TMP/empty"; mkdir -p "$EMPTY"
run "$EMPTY"
[[ "$(json "$state" '(d.get("workspace", False), d["framework"])')" == "(False, 'unknown')" ]] && ok "empty dir" || fail "empty dir: $(cat "$state")"

# One child repo is not a workspace.
SOLO="$TMP/solo"; mkdir -p "$SOLO/only"; git -C "$SOLO/only" init -q
run "$SOLO"
[[ "$(json "$state" 'd.get("workspace", False)')" == "False" ]] && ok "one child repo is not a workspace" || fail "one child repo counted as a workspace"

# A repo holding nested repos is a repo, not a workspace.
OUTER="$TMP/outer"; mkdir -p "$OUTER/a" "$OUTER/b"
git -C "$OUTER" init -q; git -C "$OUTER/a" init -q; git -C "$OUTER/b" init -q
run "$OUTER"
[[ "$(json "$state" 'd.get("workspace", False)')" == "False" ]] && ok "nested repos inside a repo" || fail "a repo with nested repos counted as a workspace"

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "FAILED: $ERRORS error(s)"
  exit 1
fi
echo ""
echo "PASSED: project state discovery"
