# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Repository Overview

{{one-paragraph-summary}}

## Development

```bash
{{install-command}}
{{build-command}}
{{test-command}}
{{dev-server-command}}
```

## Project Structure

```
{{directory-tree}}
```

## Project Scaffold

| Field | Value |
|-------|-------|
| Tier | {{tier}} |
| Setup date | {{date}} |
| Last re-entry | {{date}} |
| Last check-in | - |

## Documentation Map

| Concept | Path | Status |
|---------|------|--------|
| Domain glossary | {{glossary-path}} | {{status}} |
| Naming conventions | {{conventions-path}} | {{status}} |
| Test expectations | {{testing-path}} | {{status}} |
| Scope boundaries | SCOPE.md | Active |
| Architecture decisions | docs/adr/ | {{status}} |
| Architecture overview | {{architecture-path}} | {{status}} |
| Skill state | .claude/ | Active |

## Branch Workflow

{{branch-workflow}}

## Agent Coordination

- When to use workflows: multi-step orchestration with fan-out (audits, bulk migrations)
- When to use parallel agents: independent tasks touching different file areas
- When to work inline: main loop already has sufficient context
- Task brief: What, Files claimed, Inputs, Output, Model (Sonnet for mechanical / Opus for judgment), Constraints
- Concurrent agent protocol: register in `docs/local/ACTIVE-WORK.md` before modifying files, claim file areas, check for stale entries (>4 hours)

## Change Protocol

1. When a dependency changes: update spec first, then code. Never code without updating spec.
2. When scope changes: update SCOPE.md, update inventory, ADR if significant.
3. When updating a spec: add entry to the Change Log section at bottom (date + one-liner).
