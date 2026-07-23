# Resume Path

Instructions for /setup when all outputs already exist and the user wants to review or revise decisions.

## When to activate

/setup detects all expected outputs exist (SCOPE.md, GLOSSARY.md, CLAUDE.md, docs/ tree, CONVENTIONS.md, TESTING.md).
Instead of "Resuming at {phase}", activate the resume path.

## Decision registry

The agent reads each canonical location and assembles a summary table.

| Decision | Canonical location | Set by |
|---|---|---|
| Archetypes | SCOPE.md frontmatter `archetypes:` | /buildout setup |
| Ship tier | SCOPE.md frontmatter `ship-tier:` | /buildout setup |
| Testing philosophy | SCOPE.md frontmatter `testing-philosophy:` | /setup Phase 1 |
| Parity strategy | SCOPE.md frontmatter `parity-strategy:` | /migrate setup |
| Cutover approach | SCOPE.md frontmatter `cutover-approach:` | /migrate setup |
| Architecture areas | docs/adr/ (list ADR titles) | /setup Phase 1 |
| Hooks | .claude/settings.json `hooks:` | /setup Phase 1 |

Not all decisions exist in every project.
Migration projects have parity strategy and cutover approach.
Buildout projects have archetypes and ship tier.
All projects have testing philosophy, architecture areas, and hooks.

## Phase 1: Read

Print the summary table with current values. No AskUserQuestion - just display.

```
Project decisions:

| Decision | Current value | Source |
|---|---|---|
| Archetypes | product, design-system | SCOPE.md |
| Ship tier | users | SCOPE.md |
| Testing philosophy | integration-first | SCOPE.md |
| Architecture areas | 6 ADRs (component-arch, state-mgmt, ...) | docs/adr/ |
| Hooks | Claims (UserPromptSubmit) | .claude/settings.json |

To revisit any of these, select below. Otherwise, setup is complete.
```

## Phase 2: Reinvest

Present multiSelect AskUserQuestion:

**"Which decisions do you want to revisit?"**

Options are built dynamically from the decisions that exist in the project.
Only include decisions that have stored values - don't offer to revisit what was never set.

## Phase 3: Edit

For each selected decision, re-present its original AskUserQuestion gate.
The user picks a new value (or confirms the current one).

### Edit operations per decision

**Archetypes** (multiSelect):
- Gate: "What kind of project is this?" with product/feature/deliverable/design-system options
- On change: update SCOPE.md frontmatter `archetypes:`
- Cascade: if design-system added, add Design Exploration Policy and Design Archival to CLAUDE.md. If removed, warn if docs/_local/design-journal.md has content before removing sections.
- Cascade: docs/_local/ structure scales by archetype (see PHASE-1.md doc structure section)

**Ship tier**:
- Gate: "What ship standard does this project need?" with hobby/users/growth options
- On change: update SCOPE.md frontmatter `ship-tier:`
- Cascade: none (Phase 4 re-confirms before ship checklist)

**Testing philosophy**:
- Gate: "What's your testing approach?" with integration-first/tdd/structural-enforcement options
- On change: update SCOPE.md frontmatter `testing-philosophy:`
- Cascade: TESTING.md emphasis may need updating to match new philosophy. Warn: "TESTING.md was generated with {old} philosophy. Review and update the emphasis sections."

**Parity strategy** (migrate only):
- Gate: "How are you approaching migration?" with strangler-fig/big-bang/parallel-run options
- On change: update SCOPE.md frontmatter `parity-strategy:`
- Cascade: warn if Phase 3+ work has started: "Changing parity strategy after vertical slice affects how remaining screens are built. Review Phase 4+ approach."

**Cutover approach** (migrate only):
- Gate: "How will you cut over?" with incremental/flag-day/parallel-run options
- On change: update SCOPE.md frontmatter `cutover-approach:`
- Cascade: 07-cutover.md CP1 references this value. Warn if cutover planning has started.

**Architecture areas**:
- No re-gate. Print list of existing ADRs. Ask: "Any new areas to decide, or existing ADRs to revisit?"
- If new: invoke /grill-with-docs for the new area
- If revisit: open the ADR, grill whether the decision still holds, update or supersede

**Hooks**:
- Print current hooks from .claude/settings.json
- Ask: "Add, remove, or modify hooks?"
- On change: update .claude/settings.json directly

## Cascade warnings

When a change has downstream effects on files with existing content, warn before applying:

```
Changing {decision} from {old} to {new}.

This affects:
  - {file}: {what changes}
  - {file}: {what changes}

Proceed? (yes / no / let me think about this)
```

The cascade warning is intentional friction on destructive changes.
It does not fire for changes with no downstream effects (e.g., ship-tier change cascades to nothing).

## Generation

This file is a static reference - the agent reads it during the resume path.
It is NOT generated per-project. The decision registry table above is the canonical map.
The agent reads the actual project files to discover which decisions exist and their current values.
