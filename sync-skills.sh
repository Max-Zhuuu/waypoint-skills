#!/usr/bin/env bash
# Sync waypoint skills to ~/.claude/ on macOS and Linux (sync-skills.ps1 is the Windows twin).
#
# Skills from every category in skill-categories.txt, plus third-party/, are flattened
# into ~/.claude/skills/{name}/. Shared infrastructure is copied to ~/.claude/{dir}/,
# agents into ~/.claude/agents/, and root files into ~/.claude/skills/.
# Copies, not symlinks: each skill and shared dir is made byte-identical to the repo
# (rsync --delete), so `diff -rq` against the repo is clean.
#
# Only directories with a matching repo source are touched; other skills are left alone.
#
# Usage: bash sync-skills.sh [--dry-run] [--target <claude-root>]
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.claude"
DRY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY="--dry-run"; shift ;;
    --target) TARGET="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

categories=$(grep -vE '^[[:space:]]*(#|$)' "$REPO/skill-categories.txt" | tr -d '\r')
skills=0
mkdir -p "$TARGET/skills"

for c in $categories third-party; do
  [[ -d "$REPO/$c" ]] || continue
  for dir in "$REPO/$c"/*/; do
    [[ -f "$dir/SKILL.md" ]] || continue
    name="$(basename "$dir")"
    rsync -a --delete $DRY "$dir" "$TARGET/skills/$name/"
    skills=$((skills + 1))
  done
done

shared=0
for d in internals templates process schemas tests scripts; do
  [[ -d "$REPO/$d" ]] || continue
  rsync -a --delete $DRY "$REPO/$d/" "$TARGET/$d/"
  shared=$((shared + 1))
done

# Agents are copied file by file, so agents that waypoint doesn't ship are kept.
# --update keeps an installed agent that is newer than the repo's (a local edit not yet upstreamed).
mkdir -p "$TARGET/agents"
rsync -a --update $DRY "$REPO/agents/" "$TARGET/agents/"

for f in CONCERNS-FORMAT.md README.md; do
  # A symlink here already points at the repo file; copying through it would be a no-op.
  [[ -L "$TARGET/skills/$f" ]] && continue
  rsync -a $DRY "$REPO/$f" "$TARGET/skills/$f"
done

echo "${DRY:+[dry run] }$skills skills and $shared shared dirs synced to $TARGET"
