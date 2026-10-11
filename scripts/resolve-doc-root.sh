#!/usr/bin/env bash
# Print the doc root {DOCS} for the current directory, relative to the project root,
# with a trailing slash. Rule: internals/engagement/doc-root.md.
#
#   Project root: the git top level if inside a repo, else the nearest ancestor
#   (up to, not including, $HOME) holding CLAUDE.md or _docs/, else the current directory.
#   1. The project root's CLAUDE.md declares it under "## Docs" as: Doc root: `path/`
#   2. Else _docs/ if it exists at the project root.
#   3. Else docs/.
#
# Usage: resolve-doc-root.sh          -> e.g. "_docs/"
#        resolve-doc-root.sh --root   -> the absolute project root
# Read-only. Works on macOS bash 3.2, Linux and Git Bash.
set -euo pipefail

project_root() {
  local top dir
  if top="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    echo "$top"
    return
  fi
  dir="$(pwd -P)"
  while [[ "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ -f "$dir/CLAUDE.md" || -d "$dir/_docs" ]]; then
      echo "$dir"
      return
    fi
    dir="$(dirname "$dir")"
  done
  pwd -P
}

root="$(project_root)"
if [[ "${1:-}" == "--root" ]]; then
  echo "$root"
  exit 0
fi

declared=""
if [[ -f "$root/CLAUDE.md" ]]; then
  declared="$(awk '/^## Docs[[:space:]]*$/{f=1;next} /^## /{f=0} f' "$root/CLAUDE.md" \
    | sed -nE 's/^Doc root:[[:space:]]*`([^`]+)`.*/\1/p' | head -1)"
fi

if [[ -n "$declared" ]]; then
  echo "${declared%/}/"
elif [[ -d "$root/_docs" ]]; then
  echo "_docs/"
else
  echo "docs/"
fi
