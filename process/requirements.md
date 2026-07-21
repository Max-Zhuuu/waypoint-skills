# Requirements Methodology

A discipline for turning vague feature ideas into specs that anyone can build from.
Works for greenfield features, migrations, and improvements - with any toolchain.

## Who this is for

Anyone who needs to define what a feature does before building it.
If the requirements are already clear and written down, this document is overhead - go build.
If you are about to write code and cannot state the acceptance criteria, start at Phase 1.

## Phase 1 - Scope the feature

Before writing anything, understand the problem well enough to draw a boundary around it.

### Problem

Answer three questions:

1. **What problem does this feature solve?**
   State the problem, not the solution. "Users can't find vessels quickly" not "We need a search bar."

2. **Who experiences this problem?**
   Name the specific user role. "Charter operator reviewing fixture status" not "users."

3. **How do they work around it today?**
   The workaround reveals the real need. Sometimes the workaround is good enough and the feature is not needed.

### Solution shape

One sentence: what does this feature do?
Where does it live? Existing screen, new screen, background process, API-only.
What is the smallest version that solves the problem? This is your MVP cut.

### Scope boundaries

Draw two lists:

**In for v1:**
- Each item is a concrete behavior, not a theme.
- "Search filters by vessel name and IMO number" not "search functionality."

**Explicitly out:**
- Adjacent features, nice-to-haves, future enhancements.
- Being explicit about what is out prevents scope creep more than being precise about what is in.

### Dependencies

What does this feature need? APIs, data, other features, infrastructure.
What depends on this feature? Other work that is blocked until this ships.

### Migration check

If a source system exists, check whether this feature exists there.
If yes: is this a parity port or an enhancement?
Enhancements should be proposed and deferred until parity is met, unless the enhancement is required for the port to function.

## Phase 2 - Define acceptance criteria

For each behavior in scope, write a Given/When/Then acceptance criterion.

```
Given the user is on the vessel list
When they type in the search box
Then the list filters to vessels matching the query by name or IMO number
```

This format works because it separates precondition, action, and assertion.
A criterion that cannot be written in this form is usually too vague.

### Error states

For each behavior, define what happens when things go wrong:
- Network failure
- Empty results
- Invalid input
- Permission denied
- Timeout

If a behavior has no error states, explicitly say so.
The worst error handling is the kind nobody thought about.

### Edge cases

Boundary conditions the implementer might miss.
These often live at intersections: what happens when feature A and feature B interact?
What happens with zero items? One item? Maximum items?

### Out-of-scope interactions

Explicitly state what this feature does NOT affect.
"Searching does not change the sort order" prevents the implementer from adding sort-by-relevance when nobody asked for it.

## Phase 3 - Present trade-offs

When a requirement has multiple valid approaches, present options with a recommendation.

Structure each option:
1. Name and short description
2. When it wins (the conditions that make this the right choice)
3. What it costs (complexity, performance, maintenance, user experience)

State your recommendation and why.
A recommendation without reasoning is an opinion.
An opinion without reasoning is a guess.

### How to decide

The decision-maker is whoever is accountable for the feature.
If that person is not available:

- State the default (your recommendation) and the deadline for overriding it.
- Note the cost of switching later. Sometimes the cost is zero and the decision is not urgent.
- When the cost of switching is high, escalate before proceeding.

## Phase 4 - Write the spec

A spec is a contract, not a narrative.
Every sentence either constrains scope or defines behavior.
If a sentence does neither, cut it.

### Structure

```
# {Feature Name}

Status: Draft | Approved | In Progress | Done
Author: {who wrote it}
Date: {date}

## Problem
{One paragraph from Phase 1}

## Solution
{One paragraph: what it does, where it lives}

## Scope
### In
- {bullet list}

### Out
- {bullet list}

## Acceptance Criteria
{Given/When/Then blocks from Phase 2}

## Error States
{Table or bullets}

## Dependencies
- {What this feature needs}
- {What depends on this feature}

## Open Questions
{Anything unresolved - who to ask, by when}

## Change Log
{Date - one liner, added as spec evolves}
```

### Principles

- **One spec per feature.** Not one spec per screen or per API endpoint.
  A feature crosses screens and endpoints; the spec covers the feature.

- **Open questions are not blockers.**
  Write the spec with your best current understanding.
  Mark unknowns as open questions, not as reasons to delay.

- **The spec evolves.**
  Add a change log entry when it changes. Don't version the spec file.
  The implementer should be able to read the spec top-to-bottom and get the current state.

## Phase 5 - Update shared artifacts

After the spec is written, check whether it surfaced anything that belongs in shared docs:

1. **New domain terms:** if you defined a term inline that other features will use, add it to the project glossary.
2. **Architecture decisions:** if the feature introduces a new pattern, state management approach, or API convention, that decision should be captured separately (an ADR or equivalent).
3. **Scope changes:** if the feature shifts what is in or out of the project's scope, update the scope document.

Do not create these artifacts preemptively.
Only update them when the spec actually surfaced something new.

## Adapting to your context

### Solo developer

Run through Phases 1-2 as a written exercise.
The act of writing acceptance criteria will catch gaps that "I know what I mean" misses.
Skip Phase 3 if there are no real trade-offs - when you are both the author and the decision-maker, a written options analysis for an obvious choice is theater.

### Team session

Use Phase 1 as a whiteboard exercise.
One person writes while others challenge.
Phase 2 becomes a group exercise: "what happens when...?" is the question that finds missing requirements.
Phase 3 options should be presented to the group, not decided by the spec author alone.

### With an AI assistant

Feed the AI your Phase 1 answers and have it generate Phase 2 acceptance criteria.
Challenge the AI on edge cases - it will miss domain-specific ones but catch structural ones (empty states, concurrent access, permission boundaries).
Use the AI to draft the spec structure, but own the scope decisions.

### AI agent

The agent runs all phases, presenting options at decision points.
Questions should include the agent's recommended answer so the human can challenge rather than generate.
The agent outputs the spec file and updates shared artifacts.
When scaffolding docs exist (glossary, scope, conventions), the agent cross-references against them and flags discrepancies.
