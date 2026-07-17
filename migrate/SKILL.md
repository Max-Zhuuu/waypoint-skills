---
name: migrate
description: End-to-end migration methodology with strict phase gates, documentation-first workflow, and concurrent work planning. Framework-agnostic. Use at migration start, between phases, when process discipline has slipped, or when the user says "migrate", "migration status", "what phase are we in".
---

# Migrate

A structured process for porting legacy systems to modern stacks.
Framework-agnostic. Enforces phase gates. Refuses to let you skip steps.

## How this skill works

Each invocation:

1. Detect current phase from project state (docs structure, inventory markers, git history).
2. Run enforcement checks (see bottom of this file).
3. If violations found: report them before any phase work.
4. Check gate criteria for the current phase.
5. If gate met: prompt to advance.
6. If gate not met: show what is blocking and guide work.

Between phases, use `/reorient` for strategic checkpoints.

---

## Phase 0 - Discovery & Scoping

**Goal:** Know exactly what you are building, what you are not, and what you need from others.

### Grill the implementer

Use `AskUserQuestion` to force decisions.
Do not proceed until each category has a concrete answer.
If the implementer cannot answer, that is a finding - document it in DEPENDENCIES.md with a resolution owner.

**Source system:**
- What is it? (stack, age, size: approximate screen count, entity count, integration count)
- Where is the source code? Can agents read it?
- Is there a running instance to compare against?

**Target system:**
- What stack? (framework, language, styling, state management)
- Hosting target? (cloud, deployment model)
- 1:1 port or redesign? If redesign: what changes and why?

**Scope:**
- What is definitely IN? (core workflows, must-have screens)
- What is definitely OUT? (legacy features, deprecated modules)
- What is UNCERTAIN? For each: who decides, by when?

**Backend contract:**
- Does the API exist? (fully / partially / not at all)
- Who builds it? (same team / different team / vendor)
- Contract format? (OpenAPI spec / ad-hoc / TBD)
- API delivery timeline relative to frontend work?
- If API is not ready: will a mock match the real shape, or will integration require rework?

**Timeline & capacity:**
- Hard deadline? (regulatory, contractual, business)
- Milestones? (demo dates, reviews, beta)
- How many concurrent developers or agent sessions?

**Risks:**
- What worries you most?
- Previous migration attempts? Known pitfalls?
- Domain knowledge that exists only in people's heads?

### Outputs

Generate two documents:

**docs/SCOPE.md:**
- One-paragraph project summary
- In / out / uncertain table with decision owners and deadlines for uncertain items
- Backend contract summary with delivery timeline
- Timeline with milestones
- "What does done look like?" in 2 sentences

**docs/DEPENDENCIES.md:**
External dependencies and status. For each:
- What it is (API, design assets, infra, data, domain expertise)
- Status: **available now**, **promised by [date]**, or **unknown**
- Owner: who to contact
- If unknown: specific instructions for resolving (who to email, what to ask, what meeting to schedule)

### Assumptions

When the implementer cannot confirm something but work needs to proceed:
1. Document the assumption in `docs/local/ASSUMPTIONS.md` (gitignored)
2. Assign a risk level: low (cosmetic if wrong), medium (rework 1-5 screens), high (rework architecture or > 5 screens)
3. Assign a resolution deadline and owner
4. Proceed with the assumption, marking dependent work with `[ASSUMPTION: brief description]` in specs

This is optimistic planning, not guessing. Every assumption is visible, tracked, and has a deadline.

### Gate

- [ ] SCOPE.md reviewed by implementer
- [ ] DEPENDENCIES.md has all external contracts identified
- [ ] Entity/screen inventory exists (rough counts and categories)
- [ ] All "uncertain" scope items have decision owners and deadlines
- [ ] Implementer can answer "what does done look like?" in 2 sentences

---

## Phase 1 - Architecture & Standards

**Goal:** Every decision that affects all screens is made ONCE, before building any screen.

### Required decisions

Log each in `docs/decisions/` as a numbered file (ADR format if the project uses one).
Each decision: state the choice, alternatives considered, and why this one wins.

1. **Component architecture:** Layout wrapper, detail view, list view, form pattern
2. **State management:** Store vs composable/hook vs component-local vs URL state
3. **Data fetching:** Where fetch calls live, caching strategy, loading/error states
4. **Routing:** URL structure, navigation model, deep link support
5. **Styling:** Tokens, component styling approach, responsive strategy
6. **Testing:** What layers, minimum bar, structural enforcement
7. **Error handling:** User-facing errors, logging, recovery
8. **Mock data strategy:** Structure, location, replacement path to real API

### Project skeleton

A running project with:
- Dev server boots
- Test suite runs (even if empty)
- One placeholder route renders
- Linter/formatter configured
- Documentation structure created (see below)

### Documentation structure

Create this tree (adapt names to project):

```
docs/
  SCOPE.md
  DEPENDENCIES.md
  ARCHITECTURE.md             # Summary of all architecture decisions
  decisions/                  # Individual ADRs
  reference/
    features/                 # Per-screen UI specs
    logic/                    # Per-entity data models and business rules
  inventory.md                # Master tracker: entity, status, owner, notes
  local/                      # Gitignored
    ACTIVE-WORK.md
    QUESTIONS.md
    PROGRESS-AUDIT.md
    ASSUMPTIONS.md
```

### Process definition

Write the project's CLAUDE.md (or equivalent).
Split concerns into sections, not a monolith:
- Repository overview (one paragraph)
- Development commands
- Project structure
- Migration workflow (reference this skill)
- Documentation rules
- Concurrent agent protocol (if applicable)

### Concurrent agent setup

If concurrent agents will be used:
- Define the protocol: file claiming, session registration, stale entry policy
- Create the ACTIVE-WORK tracker
- Document which phases allow concurrency (2, 4, 5) and which are single-threaded (0, 1, 3)

### Gate

- [ ] All 8 architecture decisions documented in `docs/decisions/`
- [ ] Project skeleton runs (dev server + tests)
- [ ] Documentation structure created
- [ ] Process definition written
- [ ] ARCHITECTURE.md exists as a summary reference
- [ ] At least one other person has reviewed ARCHITECTURE.md

---

## Phase 2 - Documentation Sprint

**Goal:** Every in-scope entity has a spec BEFORE any code is written.

### Per-entity documentation

For each entity/screen in the inventory:

1. **Logic doc** (`docs/reference/logic/{entity}.md`): data model, relationships, business rules, status lifecycles, calculated fields, edge cases.
2. **Feature spec** (`docs/reference/features/{entity}.md`): screen layout, controls, field list with types, actions, conditional visibility, validation rules.

Source material: legacy codebase, running instance, domain experts, existing docs.
Cross-reference specs against the source - do not invent fields or behaviors.

### Inventory tracking

- `[ ]` -> `[D]` when logic doc written
- `[D]` -> `[S]` when feature spec written and cross-referenced

### Concurrency

This phase parallelizes well.
Multiple agents can document different entities with no file conflicts.
Each entity owns its own spec files.

### Assumption handling

When you encounter unknowns:
1. Log in `docs/local/QUESTIONS.md` with: entity, question, who might know, date
2. If a reasonable assumption exists: document it in the spec marked `[ASSUMPTION]`, add to ASSUMPTIONS.md with risk level
3. Do not block the sprint. Document what you know, flag what you don't.

### Gate

- [ ] Every in-scope entity has a logic doc and a feature spec
- [ ] Inventory shows no items at `[ ]`
- [ ] QUESTIONS.md triaged: critical questions escalated, non-critical deferred with deadlines
- [ ] High-risk assumptions in ASSUMPTIONS.md have resolution plans

---

## Phase 3 - Vertical Slice

**Goal:** Validate architecture decisions with 3 real screens before committing to them at scale.

This phase is the most important gate in the process.
Skipping it means discovering broken patterns after building 30 screens instead of 3.

### Pick 3 screens

Select screens that together exercise the full architecture:

1. **Simple:** Basic list + detail. Tests: routing, layout, data fetching, form pattern.
2. **Medium:** Relationships, conditional logic, or tabs. Tests: state management, composition, navigation.
3. **Complex:** Most fields, most rules, most integrations. Tests: performance, edge cases, pattern limits.

Present picks to the implementer. Justify why these 3 cover the architecture.

### Build end-to-end

For each: route -> layout -> view -> data layer -> mock data -> tests.
Cross-reference against source system side-by-side.

### Architecture checkpoint

After all 3:
- What worked as designed?
- What required workarounds? Are workarounds acceptable or do patterns need revision?
- What needs to change before Phase 4?

If changes needed: update decisions, update skeleton, re-validate all 3 screens.
Do NOT proceed with a known-broken pattern.

### Gate

- [ ] 3 screens working end-to-end with mock data
- [ ] All 3 cross-referenced against source system
- [ ] Architecture checkpoint documented
- [ ] Required architecture changes applied and validated
- [ ] Test patterns established and documented
- [ ] Inventory shows the 3 screens at `[P]`

---

## Phase 4 - Horizontal Buildout

**Goal:** Systematically port all remaining screens.

### Per-screen process

Order by dependency (parents before children):

1. Read feature spec + logic doc
2. Build: route -> view -> data -> mock data -> tests
3. Cross-reference against source system
4. Fix code AND docs where discrepancies found
5. Run test suite - all tests pass
6. Mark `[P]` in inventory

### Concurrency

Primary fan-out opportunity. Multiple agents can build different screens IF:
- They claim non-overlapping entities in ACTIVE-WORK
- Shared infrastructure changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, gets approved, merges; others pull

### Gate

- [ ] All in-scope entities at `[P]`
- [ ] Test suite: zero failures
- [ ] No process violations outstanding
- [ ] Inventory current and accurate
- [ ] No critical items in QUESTIONS.md

---

## Phase 5 - Integration

**Goal:** Replace all mock data with real API calls.

### Prerequisites

Review DEPENDENCIES.md before starting:
- Is the API available? If partial: which endpoints exist?
- Does the API shape match mock data? If not: what is the gap?
- If API not ready: can we do partial integration? What is the ETA for the rest?

### Per-screen wiring

1. Replace mock data with API calls
2. Implement loading, error, and empty states
3. Verify data shape matches (types catch most; edge cases surface here)
4. Test with real data
5. Mark `[M]` in inventory

### When the API does not match

1. Is the mock wrong or the API wrong? Check the spec.
2. API wrong: file bug with backend team, document in QUESTIONS.md, keep mock as fallback
3. Mock wrong: fix frontend, update spec

### Gate

- [ ] All screens consuming real API data (or documented exceptions with fallbacks)
- [ ] No mock data in production code paths
- [ ] Loading/error/empty states implemented everywhere
- [ ] All items at `[M]`

---

## Phase 6 - Validation

**Goal:** Confirm the migration is correct, not just complete.

### Side-by-side validation

For each screen:
1. Source system and target side by side
2. Compare: fields, layout, behavior, edge cases
3. Categorize discrepancies: intentional improvement vs bug

### Performance

- Page load times acceptable?
- Data-heavy screens responsive?
- No memory leaks on navigation?

### Gate

- [ ] All screens validated side-by-side
- [ ] Performance acceptable
- [ ] All items at `[V]`
- [ ] Bug list triaged: critical fixed, non-critical ticketed
- [ ] Stakeholder sign-off obtained

---

## Phase 7 - Cutover

**Goal:** Ship it.

- Deployment plan documented
- Rollback plan documented
- User communication sent
- Source system sunset date set (or parallel-run period defined)
- Post-launch monitoring in place

---

## Enforcement

On EVERY invocation, before routing to the current phase:

### Check for violations

1. **Code without specs:** Screens/components that exist in code but have no corresponding feature spec. This means someone built before documenting.
2. **Stale inventory:** Status markers that do not match actual state (marked `[P]` but tests fail, marked `[S]` but spec is missing).
3. **Overdue assumptions:** Items in ASSUMPTIONS.md past their resolution deadline.
4. **Stale questions:** Critical items in QUESTIONS.md older than 1 week without escalation.
5. **Phase leapfrogging:** Work being done in Phase N+1 while Phase N gate is not met.

### Report violations first

Before any phase work, list violations.
Require acknowledgment before proceeding.
Violations are not warnings - they are blockers until explicitly addressed or accepted with documented justification.

### Gate override

If the implementer wants to skip a gate item:
- They must state which item and why
- Document the override in `docs/decisions/` with: what was skipped, why, and what risk is accepted
- The skill records this but does not forget - it will remind at the next phase gate

## Tone

This skill is a project manager who has seen migrations fail.
Prescriptive, not suggestive.
"You should consider..." -> "Do this."
"It might be good to..." -> "Required before proceeding."

The implementer asked to be held to a high standard.
Hold them to it.
