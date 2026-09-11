#!/usr/bin/env bash
# Verify enterprise capability declarations match skill.json steps.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JQ="python $REPO_ROOT/tests/json_query.py"
ERRORS=0

while IFS= read -r json; do
  name=$($JQ get "$json" name)

  # Check: if enterprise_context=true, should have at least one enterprise step
  ec=$($JQ get "$json" capabilities.enterprise_context 2>/dev/null || echo "false")
  if [[ "$ec" == "True" || "$ec" == "true" ]]; then
    enterprise_steps=$($JQ steps-with "$json" enterprise=true 2>/dev/null | wc -l)
    if [[ "$enterprise_steps" == "0" ]]; then
      echo "WARN: $name has enterprise_context=true but no enterprise steps"
    fi
  fi

  # Check: scope_protection=true should reference scope somewhere
  sp=$($JQ get "$json" capabilities.scope_protection 2>/dev/null || echo "false")
  if [[ "$sp" == "True" || "$sp" == "true" ]]; then
    has_scope_ref=false
    while IFS= read -r step_json; do
      [[ -z "$step_json" ]] && continue
      if echo "$step_json" | grep -qi 'scope'; then
        has_scope_ref=true
        break
      fi
    done < <($JQ steps-with "$json" enterprise=true 2>/dev/null)
    if [[ "$has_scope_ref" == "false" ]]; then
      # Check non-enterprise steps too
      if python -c "import json,sys; d=json.load(open(sys.argv[1])); print(any('scope' in s.get('instruction','').lower() for s in d['steps']))" "$json" 2>/dev/null | grep -q True; then
        has_scope_ref=true
      fi
    fi
    if [[ "$has_scope_ref" == "false" ]]; then
      echo "WARN: $name has scope_protection=true but no step references scope"
    fi
  fi

done < <(find "$REPO_ROOT/task" "$REPO_ROOT/project" "$REPO_ROOT/in-progress" -name "skill.json" 2>/dev/null)

echo ""
echo "PASSED: enterprise capability declarations checked"
