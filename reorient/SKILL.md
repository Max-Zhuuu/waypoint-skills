---
name: reorient
description: Strategic course correction. Snapshots real project state, surfaces deferred decisions, audits progress across axes, and outputs a focused plan with concurrency splits. Use when scattered, between milestones, or before a work sprint.
---

# Reorient

A periodic checkpoint that forces clarity on direction, surfaces what you have been avoiding, and produces a focused plan.
This is not a status report - it is a course correction.

## Phase 1 - Snapshot the landscape

Build an honest picture of where the project stands.
Do not rely on memory, conversation history, or the user's self-assessment.
Read actual state.

### What to read

1. **Tracking docs.** Look for progress-tracking files (inventory, migration status, kanban, PAGES, roadmap).
   Count items by status category.
   If no formal tracker exists, note that - it is a finding for Phase 3.
2. **Recent git history.** `git log --oneline -30`.
   Categorize each commit into an axis: architecture, wiring/integration, design/UI, bugfix, docs, tests, chore.
   Identify which axes got attention and which did not.
3. **Open questions.** Look for deferred-question files, TODO comments in recently touched files, or stale branches.
4. **Active work.** Check for concurrent agent trackers or in-progress branches.
5. **Test health.** Run the test suite (or check the most recent run) - are tests passing? Any skipped or flaky?

### Present the snapshot

A compact dashboard, not a wall of text:

```
Inventory: 45 ported / 12 remaining / 8 blocked
Recent momentum: 18/30 commits on wiring, 0 on testing (drift)
Open questions: 6 (oldest: 3 weeks)
Tests: 142 pass, 2 skip, 0 fail
```

Flag **drift indicators**: any axis with 0 commits in the last 30, any tracker category that has not advanced in 2+ weeks, any open question older than 1 week.

## Phase 2 - State the goal

In 1-2 sentences, state what the current milestone or sprint goal appears to be, derived from recent work patterns and any roadmap docs.

Then challenge it with `AskUserQuestion`:

- **Stay the course** - the goal is correct and progress is real
- **Narrow it** - goal is right but scope has crept; need to cut
- **Pivot** - the goal itself should change based on what we have learned
- **No clear goal** - that is the problem

If "Narrow": ask what to cut (free text).
If "Pivot": ask what the new goal is.
If "No clear goal": make Phase 3 heavier on goal-setting.

## Phase 3 - Surface hard questions

The point of this phase is to make the user decide things they have been deferring.
Deferred decisions accumulate drag.

### Where to find them

- Open question docs with entries older than 1 week
- Git log patterns: same area touched 3+ times without a milestone marker advancing (rework without resolution)
- Structural gaps: routes without views, views without data, types without consumers, mock data where real APIs exist, dead code, commented-out blocks
- Scoping ambiguity: features built that may not be needed, features needed that have not started, modules with unclear ownership

### How to present them

Use `AskUserQuestion` for each hard question.
Frame as a concrete decision, not an open discussion.
Not "should we think about X?" but "X: keep, cut, or defer with a date?"

Examples (project-dependent):
- "Module Y has been at 'documented' status for 4 weeks with no activity. Start it now, defer to next milestone, or cut it?"
- "12 views still use mock data where API endpoints exist. Wire them now or batch into a dedicated integration sprint?"
- "Screen Z was ported but has zero navigation paths to it. Keep and wire, or remove?"
- "The test suite has no coverage for [critical path]. Add tests now or accept the risk?"

Rules:
- Limit to 3-5 questions. More than that dilutes focus.
- Each question must be actionable in the next 1-2 work sessions.
- Every option must be something you would actually do - no "we should discuss further."
- If you cannot find 3 hard questions, the project is either very healthy or you are not looking hard enough. Check again.

## Phase 4 - Axis audit

Evaluate progress across the project's key axes.
Adapt the axes to the project - a migration has different axes than a greenfield product.

Common axes:

| Axis | Check | Behind signal |
|------|-------|---------------|
| Architecture | Component patterns, state management, type system | Ad-hoc solutions, pattern drift, one-offs |
| Wiring | API integration, data flow, route connectivity | Mock data lingering, dead routes, unconnected views |
| Design | Visual consistency, layout compliance, responsiveness | Style drift, hardcoded values, inconsistent spacing |
| Testing | Coverage, health, CI | Flaky tests, untested critical paths, skipped suites |
| Docs | Spec accuracy, tracker currency | Stale specs, unmarked completions, outdated diagrams |

For each axis: one sentence on status, then a rating: **ahead**, **on track**, **behind**, or **blocking** (behind AND preventing other axes from advancing).

Highlight the 1-2 axes that are furthest behind or actively blocking.

## Phase 5 - Reprioritize

Based on Phases 2-4, produce a concrete plan.

### Next 3-5 work items

Ordered by impact (what unblocks the most, what retires the most risk).

Each item:
- **What**: one sentence
- **Why now**: what it unblocks or what risk it retires
- **Effort**: S / M / L
- **Solo or parallel**: can an independent agent session handle this without file conflicts?

### Explicitly deprioritized

2-3 things the user might be tempted to work on that should wait.
Say why each one should wait - "because X needs to land first" or "because the effort-to-impact ratio is poor right now."

### Concurrent agent plan

If 2+ items are parallelizable and independent, propose a specific split:
- Which items go to which agent session
- What files each session claims
- What the coordination boundary is (where they must not overlap)

Tie this to the project's concurrent agent protocol if one exists.

### Decision log

Bullet-list the decisions made in Phase 3.
If any decision affects a tracking doc (inventory, roadmap, PAGES), update it now.
If any decision means removing code or screens, list what to remove but do not remove it in this skill - that is a separate work session.

## Phase 6 - Save the audit

Persist the audit to `docs/local/PROGRESS-AUDIT.md`.

### If the file already exists

Read it first. The previous audit is context, not dead weight:

1. **Carry forward unresolved decisions.** If Phase 3 of a prior audit listed a decision that was deferred ("defer to next milestone"), and this run's Phase 3 did not revisit it, append it to the Decisions section with a `(carried from {prior date})` tag. Decisions that were acted on or explicitly reversed get dropped.
2. **Compare axis ratings.** If an axis was "behind" last time and is still "behind", flag it as **persistent** in the Axis Audit table. Two consecutive "behind" ratings on the same axis is a louder signal than one.
3. **Check prior plan items.** For each work item in the previous plan, determine: done (drop it), still relevant (carry or re-rank), or overtaken by events (drop with a note). Summarize in a `### Prior plan reconciliation` block.

### File structure

```markdown
# Progress Audit - {date}

## Snapshot
{Phase 1 dashboard}

## Goal
{Phase 2 stated goal + user's decision}

## Decisions
{Phase 3 decisions with outcomes}
{Carried-forward decisions tagged with original date}

## Axis Audit
{Phase 4 table, with "persistent" flags where applicable}

## Plan
### Prior plan reconciliation
{What happened to last audit's plan items: done / carried / dropped}

### Priority work items
{Phase 5 ordered list}

### Deprioritized
{Phase 5 deprioritized list}

### Concurrent agent plan
{Phase 5 agent split, if applicable}
```

### If the file does not exist

Write it fresh with the structure above, omitting the reconciliation block.

### File purpose

This file is gitignored (lives in `docs/local/`).
It serves as a reference for the current sprint direction - any agent session can read it to understand strategic context without re-running the skill.
One audit per file. Each run reconciles with and replaces the previous one.

## When to use this skill

- **Start of a work week or sprint** - set direction before diving into tasks
- **After a marathon session** - when you have been heads-down and lost the big picture
- **When you catch yourself jumping between unrelated tasks** - that is the signal
- **Before spinning up parallel agents** - make sure they are working on the right things
- **After a milestone ships** - reassess what is next

## Tone

Direct.
This skill exists because the user asked to be challenged on their direction.
Do not soften hard questions.
Do not present 5 options when 2 are obviously wrong.
If an axis is behind, say it plainly.
If a feature should be cut, recommend cutting it.

Keep the whole interaction under 15 minutes.
This is a compass check, not a strategy offsite.
