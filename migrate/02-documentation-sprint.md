# Phase 2 - Documentation Sprint

**Goal:** every in-scope entity has a spec before any code is written.

For each entity/screen in the inventory:

1. **Logic doc** (`docs/reference/logic/{entity}.md` from `_TEMPLATE.md`): data model, relationships, business rules, status lifecycles, calculated fields, edge cases.
2. **Feature spec** (`docs/reference/features/{entity}.md` from `_TEMPLATE.md`): screen layout, controls, field list, interaction behaviors, actions, conditional visibility, validation.

Source material: legacy codebase, running instance, domain experts.
Cross-reference specs against the source system - do not invent fields or behaviors.

## Inventory tracking

- `[ ]` -> `[D]` when logic doc written
- `[D]` -> `[S]` when feature spec written and cross-referenced

## Concurrency

Parallelizes well. Multiple agents document different entities with no file conflicts.

## Assumption handling

1. Log unknowns in `docs/local/QUESTIONS.md` (entity, question, who might know, date)
2. If reasonable assumption exists: mark `[ASSUMPTION]` in spec, add to ASSUMPTIONS.md with risk level
3. Do not block. Document what you know, flag what you don't.

## Gate

- [ ] Every in-scope entity has logic doc + feature spec
- [ ] Inventory shows no items at `[ ]`
- [ ] QUESTIONS.md triaged: critical escalated, non-critical deferred with deadlines
- [ ] High-risk assumptions have resolution plans
