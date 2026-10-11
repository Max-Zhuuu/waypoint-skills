#!/usr/bin/env bash
# Sourced by the tests. Prints the absolute path of every skill category in
# skill-categories.txt, one per line. Usage: find $(category_dirs) -name skill.json
category_dirs() {
  local root
  root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  grep -vE '^[[:space:]]*(#|$)' "$root/skill-categories.txt" | tr -d '\r' | while IFS= read -r c; do
    [[ -d "$root/$c" ]] && echo "$root/$c"
  done
}
