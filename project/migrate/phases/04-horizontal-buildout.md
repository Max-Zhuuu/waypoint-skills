# Phase 4 - Horizontal Buildout

**Goal:** systematically port all remaining screens.

## Checkpoints

### CP1: Pre-build spec prerequisite (per screen)
- **Trigger:** before building each screen
- **References:** feature spec, logic doc, CONVENTIONS.md, CONCERNS.md
- **Action:** verify spec exists and is complete. If missing: block - leaked Phase 2 work. If spec exists but incomplete: flag specific gaps. Invoke `/spec` only if no source system to extract from (new feature not in legacy).
- **Pass:** feature spec and logic doc exist, are cross-referenced against source, and no related assumptions in CONCERNS.md are past their resolution deadline.

### Post-build (per screen)
- **Trigger:** when `/tdd` reports a screen complete
- **References:** CONCERNS.md (entity concerns), CONVENTIONS.md, GLOSSARY.md
- **Action:** /tdd suggests /wrapup. If invoked: /wrapup resolves concerns, cascades to shared docs, updates inventory to `[P]`. If skipped: concerns persist, /check-in surfaces next session.
- **Pass:** /wrapup resolved concerns (or concerns persist for next session).

## Process

Order by dependency (parents before children).

### Reconciliation ledger

When the in-scope screens are a homogeneous fan-out checked against the source system, this phase owns a reconciliation ledger ([verifiable workflows](../../../process/verifiable-workflows.md)) built from [the ledger template](../../../templates/workflow-ledger.md) at `docs/workflows/{migration-name}/ledger.md`.
Create it at phase start with one row per in-scope entity, seeded from the breakdown's lane and criteria-count tags, every row `not-started`.
Each [port checklist](../reference/port-checklist.md) run fills its own row with an evidence-graded verdict; the row, not the reviewer's say-so, is what marks a screen done.
The header metric (pass-rate against the spec's target, criterion completeness, and a clean error-budget log with zero rank-6-7-only passes) is computed from the rows and read by the gate below.
This is the structural fix for the squash: forty screens can no longer collapse into one "done", because each demands its own row with a named oracle before it counts.

### Per-screen process

Invoke `/tdd` for each screen, using the [port checklist](../reference/port-checklist.md) as reference. The process:
1. Read feature spec + logic doc + source system
2. Generate subagent brief
3. Spawn implementation subagent(s)
4. Review output against spec and source
5. Emit discrepancies as concerns in CONCERNS.md
6. Run test suite - zero failures
7. Report complete (signals contract: suggests /wrapup)

### Concurrency

This is the primary fan-out: recommend the parallel verifiable-workflow path (a reconciliation ledger and a success metric) whenever the in-scope screens are homogeneous components checked against the source system, with the screen count as the reason (see [method selection](../../../process/method-selection.md) and [verifiable workflows](../../../process/verifiable-workflows.md)).

Multiple agents can build different screens IF:
- Non-overlapping entities claimed in CONCERNS.md (see [../../../CONCERNS-FORMAT.md](../../../CONCERNS-FORMAT.md#claims-section) for format)
- Shared infra changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, merges; others pull

### Testing acceptance criteria

At horizontal buildout scale:
- Every ported screen has at least one test verifying its primary workflow
- The full test suite passes after each screen is added
- No regressions in previously-ported screens

Testing methodology (structural enforcement, snapshots, characterization tests) is owned by the implementation verb, not this phase file. See [references.md](../reference/references.md) for the catalog.

## Gate

- [ ] All in-scope entities at `[P]`
- [ ] Under a reconciliation ledger: pass-rate meets the spec's target with a clean error-budget log, and no component Passed on rank-6-7 evidence alone
- [ ] Test suite: zero failures
- [ ] No process violations (all /wrapup runs passed or flags documented)
- [ ] Inventory current and accurate
