# Migration Phases

Read by `/migrate` on demand for the current phase.

---

## Phase 2 - Documentation Sprint

**Goal:** every in-scope entity has a spec before any code is written.

For each entity/screen in the inventory:

1. **Logic doc** (`docs/reference/logic/{entity}.md` from `_TEMPLATE.md`): data model, relationships, business rules, status lifecycles, calculated fields, edge cases.
2. **Feature spec** (`docs/reference/features/{entity}.md` from `_TEMPLATE.md`): screen layout, controls, field list, interaction behaviors, actions, conditional visibility, validation.

Source material: legacy codebase, running instance, domain experts.
Cross-reference specs against the source system - do not invent fields or behaviors.

### Inventory tracking

- `[ ]` -> `[D]` when logic doc written
- `[D]` -> `[S]` when feature spec written and cross-referenced

### Concurrency

Parallelizes well. Multiple agents document different entities with no file conflicts.

### Assumption handling

1. Log unknowns in `docs/local/QUESTIONS.md` (entity, question, who might know, date)
2. If reasonable assumption exists: mark `[ASSUMPTION]` in spec, add to ASSUMPTIONS.md with risk level
3. Do not block. Document what you know, flag what you don't.

### Gate

- [ ] Every in-scope entity has logic doc + feature spec
- [ ] Inventory shows no items at `[ ]`
- [ ] QUESTIONS.md triaged: critical escalated, non-critical deferred with deadlines
- [ ] High-risk assumptions have resolution plans

---

## Phase 3 - Vertical Slice

**Goal:** validate architecture with 3 real screens before scaling.

This is the most important gate. Skipping it means discovering broken patterns after 30 screens.

### Pick 3

1. **Simple** - basic list + detail. Tests: routing, layout, data fetching, form.
2. **Medium** - relationships, conditional logic, tabs. Tests: state management, composition, navigation.
3. **Complex** - most fields, most rules, most integrations. Tests: performance, edge cases, pattern limits.

Present picks and justify why these 3 cover the architecture.

### Build end-to-end

For each: route -> layout -> view -> data layer -> mock data -> tests.
Cross-reference against source system side-by-side.

### Architecture checkpoint

After all 3:
- What worked as designed?
- What required workarounds?
- What needs to change before Phase 4?

If changes needed: update ADRs, update skeleton, re-validate all 3.
Do NOT proceed with a known-broken pattern.

### Characterization tests

For complex screens, consider characterization tests (golden master approach): capture the legacy system's output for specific inputs, then assert the new system matches. Proves parity without understanding every edge case.

### Gate

- [ ] 3 screens working end-to-end with mock data
- [ ] All 3 cross-referenced against source system
- [ ] Architecture checkpoint documented
- [ ] Required changes applied and validated
- [ ] Test patterns established
- [ ] Inventory shows 3 screens at `[P]`

---

## Phase 4 - Horizontal Buildout

**Goal:** systematically port all remaining screens.

Order by dependency (parents before children).

Per screen:
1. Read feature spec + logic doc
2. Build: route -> view -> data -> mock data -> tests
3. Cross-reference against source system
4. Fix code AND docs where discrepancies found
5. Run test suite - zero failures
6. Mark `[P]` in inventory

### Concurrency

Primary fan-out opportunity. Multiple agents can build different screens IF:
- Non-overlapping entities claimed in ACTIVE-WORK
- Shared infra changes (router, shared components, types) are single-threaded
- One agent proposes shared changes, merges; others pull

### Enforcement

- Screen built without spec -> stop, write spec first
- New pattern not in ARCHITECTURE.md -> document or use existing pattern
- Tests failing -> fix before marking `[P]`
- UX improvement spotted -> capture in `docs/improvements/`, keep porting

### Gate

- [ ] All in-scope entities at `[P]`
- [ ] Test suite: zero failures
- [ ] No process violations
- [ ] Inventory current and accurate

---

## Phase 5 - Integration

**Goal:** replace all mock data with real API calls.

### Prerequisites

Review DEPENDENCIES.md:
- Is the API available? If partial: which endpoints?
- Does API shape match mock data? What's the gap?
- If not ready: partial integration or wait?

### Per-screen wiring

1. Replace mock data with API calls
2. Implement loading, error, empty states
3. Verify data shape (types catch most; edge cases surface here)
4. Test with real data
5. Mark `[M]` in inventory

### When API doesn't match

1. Check spec: is mock wrong or API wrong?
2. API wrong: file bug with backend, document in QUESTIONS.md, keep mock as fallback
3. Mock wrong: fix frontend, update spec, add Change Log entry

### Gate

- [ ] All screens consuming real API (or documented exceptions)
- [ ] No mock data in production code paths
- [ ] Loading/error/empty states implemented
- [ ] All items at `[M]`

---

## Phase 6a - Functional Validation

**Goal:** confirm the migration is functionally correct. Design doesn't matter yet.

### Side-by-side parity check

For each screen, source system and target side by side:
- Fields present and correct?
- Controls behave the same? (dropdowns, tables, forms)
- Data matches? (same records, same calculations)
- Edge cases handled? (empty states, permission variations, status transitions)
- Navigation paths match? (can reach the same workflows)

### Categorize discrepancies

- **Bug** - should match source but doesn't -> fix now
- **Intentional difference** - documented improvement or simplification -> note in spec
- **Unknown** - can't determine if source behavior is correct -> add to QUESTIONS.md

### Performance

- Page load times acceptable?
- Data-heavy screens responsive?
- No memory leaks on navigation?

### Gate

- [ ] All screens validated side-by-side for functional parity
- [ ] All bugs fixed or triaged
- [ ] Performance acceptable
- [ ] All items at `[V-func]` in inventory

---

## Phase 6b - Design Pass

**Goal:** apply visual system and UX improvements uniformly.

Only begin after Phase 6a gate is met. This is the reward for disciplined parity work.

### Process

1. Review `docs/improvements/` - all the ideas captured during Phases 2-5
2. Prioritize: which improvements have the highest user impact?
3. Apply design system (tokens, typography, spacing, color) across all screens uniformly
4. Implement approved improvements
5. Validate: does the design enhance usability without breaking parity?

### Invoke /learn

For design decisions with multiple valid approaches (layout strategy, component patterns, animation), invoke `/learn` to understand trade-offs before committing.

### Gate

- [ ] Design system applied uniformly
- [ ] Prioritized improvements implemented
- [ ] No functional regressions (re-run Phase 6a spot checks)
- [ ] All items at `[V]` in inventory
- [ ] Stakeholder sign-off

---

## Phase 7 - Cutover

**Goal:** ship it.

- Deployment plan documented
- Rollback plan documented
- User communication sent
- Source system sunset date set (or parallel-run period defined)
- Post-launch monitoring in place
- Branch by abstraction or feature flags for gradual traffic shift if applicable
