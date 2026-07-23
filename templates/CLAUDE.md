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

```
docs/
  **_GLOSSARY.md**               # Domain glossary
  program/
    **ARCHITECTURE.md**          # Stack, state management, data flow, deps
    **TESTING.md**               # Test expectations by tier
    conventions/
      **NAMING.md**              # Variables, functions, components
      UX.md                      # Interaction patterns
    adr/                         # Architecture decision records
  implementation/
    **SCOPE.md**                 # In/out/uncertain
    **CONCERNS.md**              # Questions, assumptions, issues, milestones
    specs/                       # Feature specs
  _local/                        # Gitignored working state
```

## Branch Workflow

{{branch-workflow}}

## Agent Coordination

- When to use workflows: multi-step orchestration with fan-out (audits, bulk migrations)
- When to use parallel agents: independent tasks touching different file areas
- When to work inline: main loop already has sufficient context
- Task brief: What, Files claimed, Inputs, Output, Model (Sonnet for mechanical / Opus for judgment), Constraints
- Concurrent agent protocol: register in the CONCERNS.md Claims section before modifying files, claim file areas, check for stale entries (>4 hours)

## Change Protocol

1. When a dependency changes: update spec first, then code. Never code without updating spec.
2. When scope changes: update SCOPE.md, update inventory, ADR if significant.
3. When updating a spec: add entry to the Change Log section at bottom (date + one-liner).
