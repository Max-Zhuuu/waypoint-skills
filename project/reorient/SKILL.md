---
name: reorient
description: "Snapshot project state, surface deferred decisions, audit progress. Use when scattered or between milestones."
status: stable
---

Does NOT implement. Audits state, surfaces deferred decisions, outputs a plan.

A periodic checkpoint that forces clarity on direction, surfaces what you have been avoiding, and produces a focused plan.
This is not a status report - it is a course correction.

## Phase 1 - Snapshot the landscape

Build an honest picture of where the project stands.
Do not rely on memory, conversation history, or the user's self-assessment.
Read actual state.

### What to read

1. **CONCERNS.md.** Count by type and status. Note anything open > 2 weeks.
   If no CONCERNS.md exists, note that - it is a finding for Phase 3.
2. **Tracking docs.** Inventory, migration status, PAGES, roadmap. Count items by status.
   If no formal tracker exists, note that too.
3. **Recent git history.** `git log --oneline -30`.
   Categorize each commit into an axis: architecture, wiring/integration, design/UI, bugfix, docs, tests, chore.
   Identify which axes got attention and which did not.
4. **Test health.** Run the test suite (or check the most recent run).

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

### Where to find them

- CONCERNS.md entries open > 1 week
- Git log: same area touched 3+ times without a milestone advancing (rework without resolution)
- Structural gaps: routes without views, views without data, types without consumers, mock data where real APIs exist
- Scoping ambiguity: features built that may not be needed, features needed that have not started

### How to present them

Use `AskUserQuestion` for each hard question.
Frame as a concrete decision, not an open discussion.
Not "should we think about X?" but "X: keep, cut, or defer with a date?"

Rules:
- Limit to 3-5 questions
- Each must be actionable in 1-2 work sessions
- Every option must be something you would actually do
- If you cannot find 3, the project is either very healthy or you are not looking hard enough

Each decision becomes a concern resolution or a new concern.

## Phase 4 - Axis audit

Evaluate progress across the project's key axes.
Adapt the axes to the project.

| Axis | Check | Behind signal |
|------|-------|---------------|
| Architecture | Component patterns, state management, type system | Ad-hoc solutions, pattern drift |
| Wiring | API integration, data flow, route connectivity | Mock data lingering, dead routes |
| Design | Visual consistency, layout, responsiveness | Style drift, hardcoded values |
| Testing | Coverage, health, CI | Flaky tests, untested critical paths |
| Docs | Spec accuracy, tracker currency | Stale specs, unmarked completions |

For each axis: one sentence on status, then a rating: **ahead**, **on track**, **behind**, or **blocking**.
Highlight the 1-2 axes furthest behind.

## Phase 5 - Reprioritize and record

Based on Phases 2-4, produce a plan and emit findings.

### Emit findings to CONCERNS.md

- Each drift indicator from Phase 1 -> issue concern (source: /reorient)
- Each decision from Phase 3 -> resolved concern (with decision:) or new question/assumption
- Each "behind" or "blocking" axis rating -> issue concern if not already tracked

### Next 3-5 work items

Ordered by impact (what unblocks the most, what retires the most risk).

Each item:
- **What**: one sentence
- **Why now**: what it unblocks or what risk it retires
- **Effort**: S / M / L
- **Solo or parallel**: can an independent agent session handle this?

### Explicitly deprioritized

2-3 things the user might be tempted to work on that should wait.
Say why each one should wait.

### Concurrent agent plan

If 2+ items are parallelizable, propose a specific split:
- Which items go to which agent session
- What files each session claims
- What the coordination boundary is

### Print the summary

Print the full audit to the user. This is ephemeral output, not a persisted file.
The durable state lives in CONCERNS.md entries.
The summary is a compass reading, not a stored document.


- Start of a work week or sprint
- After a marathon session when you have lost the big picture
- When jumping between unrelated tasks
- Before spinning up parallel agents
- After a milestone ships

Canonical branch: flags stale canonical branch designations in Active Workflow.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: flags, audit results, concern triage
Writes: creates CONCERNS.md if absent (seeded with this run's findings)
Override: Tier 1 behavior differs - creates CONCERNS.md rather than working without it. This is the only skill besides /wrapup with CONCERNS.md creation permission.
## Exit

When the audit is complete, suggest next steps:
- If priorities shifted -> "/check-in reads your open concerns and proposes what to work on next."
- If concerns need resolution -> "/wrapup updates GLOSSARY.md, conventions, and specs to match resolved decisions."
- If scope needs revision -> "/grill-with-docs to stress-test and update SCOPE.md."

## Tone

Direct. This skill exists because the user asked to be challenged on their direction.
Do not soften hard questions. If a feature should be cut, recommend cutting it.
Keep the whole interaction under 15 minutes. This is a compass check, not a strategy offsite.
