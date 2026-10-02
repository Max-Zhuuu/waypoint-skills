---
name: reorient
description: "Snapshot project state, surface deferred decisions, audit progress. Use when scattered or between milestones."
status: deprecated
---

> **Deprecated.** Absorbed into `/check-in --deep` mode.

Periodic checkpoint forcing clarity on direction. Surfaces what you've been avoiding, produces focused plan.
Not a status report - a course correction. Surfaces and records; does not fix. Bugs found -> capture as findings, propose as next work. No mid-audit debugging.

## Phase 1 - Snapshot

Build honest picture from actual state, not memory or self-assessment.
Read [reference/snapshot-checklist.md](reference/snapshot-checklist.md): CONCERNS.md, tracking docs, recent git, test health.

Present compact dashboard:

```
Inventory: 45 ported / 12 remaining / 8 blocked
Momentum: 18/30 commits on wiring, 0 on testing (drift)
Concerns: 14 open (6 questions, 5 flags, 3 assumptions), oldest: 3 weeks
Tests: 142 pass, 2 skip, 0 fail
```

Flag drift: any axis with 0 commits in 30 days, any category stalled 2+ weeks, any concern open > 1 week.

## Phase 2 - State goal

1-2 sentences: what current milestone goal appears to be from work patterns and roadmap.

Challenge with AskUserQuestion:
- **Stay the course** - goal correct, progress real
- **Narrow** - scope crept, need cuts
- **Pivot** - goal should change
- **No clear goal** - that's the problem

Narrow -> ask what to cut. Pivot -> ask new goal. No clear goal -> heavier goal-setting in Phase 3.

## Phase 3 - Hard questions

Force decisions on deferred items. Deferred decisions accumulate drag.
Read [reference/hard-questions.md](reference/hard-questions.md). Each decision -> concern resolution or new concern.

## Phase 4 - Axis audit

Read [reference/axis-audit.md](reference/axis-audit.md). Adapt to project, rate each axis.

## Phase 5 - Reprioritize

From Phases 2-4, produce plan and emit findings to CONCERNS.md:
- Drift indicators -> issue concerns
- Decisions -> resolved or new concerns
- Behind/blocking axes -> issue concerns if not tracked

Read [reference/output-format.md](reference/output-format.md) for work-items format, deprioritized list, summary.

## Exit

- Priorities shifted -> /check-in
- Concerns need resolution -> /wrapup
- Scope needs revision -> /grill-with-docs
- On exit, run the shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).
