---
name: reorient
description: "Snapshot project state, surface deferred decisions, audit progress. Use when scattered or between milestones."
status: deprecated
---

> **Deprecated.** Absorbed into `/check-in --deep` mode.

A periodic checkpoint that forces clarity on direction, surfaces what you have been avoiding, and produces a focused plan.
This is not a status report - it is a course correction.

Throughout, reorient surfaces and records; it does not fix.
When the snapshot turns up a bug, a failing test, or a broken build, capture it as a finding and propose it as next work - do not repair it mid-audit, which turns a compass check into an unplanned debugging session.

## Phase 1 - Snapshot the landscape

Build an honest picture of where the project stands.
Do not rely on memory, conversation history, or the user's self-assessment.
Read actual state.

Read [reference/snapshot-checklist.md](reference/snapshot-checklist.md) and work through it in order: CONCERNS.md, tracking docs, recent git history, test health.

### Present the snapshot

Compact dashboard:

```
Inventory: 45 ported / 12 remaining / 8 blocked
Recent momentum: 18/30 commits on wiring, 0 on testing (drift)
Concerns: 14 open (6 questions, 5 flags, 3 assumptions), oldest: 3 weeks
Tests: 142 pass, 2 skip, 0 fail
```

Flag **drift indicators**: any axis with 0 commits in the last 30, any tracker category that has not advanced in 2+ weeks, any concern open > 1 week.

## Phase 2 - State the goal

In 1-2 sentences, state what the current milestone goal appears to be, derived from recent work patterns and roadmap docs.

Challenge it with `AskUserQuestion`:

- **Stay the course** - the goal is correct and progress is real
- **Narrow it** - goal is right but scope has crept; need to cut
- **Pivot** - the goal itself should change based on what we have learned
- **No clear goal** - that is the problem

If "Narrow": ask what to cut.
If "Pivot": ask what the new goal is.
If "No clear goal": make Phase 3 heavier on goal-setting.

## Phase 3 - Surface hard questions

The point of this phase is to make the user decide things they have been deferring.
Deferred decisions accumulate drag.

Read [reference/hard-questions.md](reference/hard-questions.md) for where to look and how to frame each question via `AskUserQuestion`.
Each decision becomes a concern resolution or a new concern.

## Phase 4 - Axis audit

Read [reference/axis-audit.md](reference/axis-audit.md) for the axis table, adapt it to the project, and rate each axis.

## Phase 5 - Reprioritize and record

Based on Phases 2-4, produce a plan and emit findings.

### Emit findings to CONCERNS.md

- Each drift indicator from Phase 1 -> issue concern (source: /reorient)
- Each decision from Phase 3 -> resolved concern (with decision:) or new question/assumption
- Each "behind" or "blocking" axis rating -> issue concern if not already tracked

Read [reference/output-format.md](reference/output-format.md) for the work-items format, the deprioritized list, the concurrent agent plan, and how to print the summary.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: flags, audit results, concern triage
Writes: creates CONCERNS.md if absent (seeded with this run's findings)
Override: Tier 1 behavior differs - creates CONCERNS.md rather than working without it.
## Exit

When the audit is complete, suggest next steps:
- If priorities shifted -> "/check-in reads your open concerns and proposes what to work on next."
- If concerns need resolution -> "/wrapup updates GLOSSARY.md, conventions, and specs to match resolved decisions."
- If scope needs revision -> "/grill-with-docs to stress-test and update SCOPE.md."
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#exit-sequence).

## Tone

Direct. This skill exists because the user asked to be challenged on their direction.
Do not soften hard questions. If a feature should be cut, recommend cutting it.
Keep the whole interaction under 15 minutes. This is a compass check, not a strategy offsite.
