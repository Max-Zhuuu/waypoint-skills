# Resume Path

Instructions for /setup when all outputs already exist and the user wants to review or revise decisions.

## When to activate

/setup detects CLAUDE.md exists with the expected section structure (## Commands, ## Architecture at minimum).
Instead of "Resuming at {phase}", activate the resume path.

## Decision registry

The agent reads CLAUDE.md sections and .claude/ to assemble a summary table.

| Decision | Canonical location | Set by |
|---|---|---|
| Template type | CLAUDE.md structure (lean vs. full) | /setup Phase 1 |
| Testing philosophy | CLAUDE.md frontmatter `testing-philosophy:` | /setup Phase 1 |
| Parity strategy | CLAUDE.md frontmatter `parity-strategy:` | /migrate setup |
| Cutover approach | CLAUDE.md frontmatter `cutover-approach:` | /migrate setup |
| Architecture areas | docs/decisions/ (list ADR titles) + ### Key design decisions in CLAUDE.md | /setup Phase 1 |
| Hooks | .claude/settings.json `hooks:` | /setup Phase 1 |

Not all decisions exist in every project.
Migration projects have parity strategy and cutover approach.
All projects have testing philosophy, architecture areas, and hooks.

## Phase 1: Read

Print the summary table with current values.
No AskUserQuestion - just display.

```
Project decisions:

| Decision | Current value | Source |
|---|---|---|
| Template | full | CLAUDE.md structure |
| Testing philosophy | integration-first | CLAUDE.md frontmatter |
| Architecture areas | 6 ADRs + 5 key decisions | docs/decisions/ + CLAUDE.md |
| Hooks | Claims (UserPromptSubmit) | .claude/settings.json |

To revisit any of these, select below. Otherwise, setup is complete.
```

## Phase 2: Reinvest

Present multiSelect AskUserQuestion:

**"Which decisions do you want to revisit?"**

Options are built dynamically from the decisions that exist in the project.
Only include decisions that have stored values.

## Phase 3: Edit

For each selected decision, re-present its original AskUserQuestion gate.

### Edit operations per decision

**Template type**:
- Gate: "Switch to lean or full template?"
- On change: add or remove CLAUDE.md sections accordingly
- Cascade: warn if removing sections that have content

**Testing philosophy**:
- Gate: "What's your testing approach?" with integration-first/tdd/structural-enforcement options
- On change: update CLAUDE.md frontmatter `testing-philosophy:`
- Cascade: ## Testing section emphasis may need updating

**Parity strategy** (migrate only):
- Gate: "How are you approaching migration?" with strangler-fig/big-bang/parallel-run
- On change: update CLAUDE.md frontmatter `parity-strategy:`
- Cascade: warn if Phase 3+ work has started

**Cutover approach** (migrate only):
- Gate: "How will you cut over?" with incremental/flag-day/parallel-run
- On change: update CLAUDE.md frontmatter `cutover-approach:`

**Architecture areas**:
- No re-gate. Print list of existing ADRs and key design decisions.
- Ask: "Any new areas to decide, or existing decisions to revisit?"
- Simple decisions: update ### Key design decisions in CLAUDE.md
- Complex decisions: invoke /grill-with-docs, produce ADR in docs/decisions/

**Hooks**:
- Print current hooks from .claude/settings.json
- Ask: "Add, remove, or modify hooks?"
- On change: update .claude/settings.json

## Cascade warnings

When a change has downstream effects on content, warn before applying:

```
Changing {decision} from {old} to {new}.

This affects:
  - CLAUDE.md ## {section}: {what changes}

Proceed? (yes / no / let me think about this)
```

## Generation

This file is a static reference - the agent reads it during the resume path.
It is NOT generated per-project.
The agent reads the actual project files to discover which decisions exist and their current values.
