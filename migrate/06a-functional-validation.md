# Phase 6a - Functional Validation

**Goal:** confirm the migration is functionally correct. Design doesn't matter yet.

## Checkpoints

### CP1: Post-validation review (per screen)
- **Trigger:** after a screen has been validated side-by-side against the source system
- **References:** feature spec, source system screen, docs/improvements/ file for this entity
- **Action:** categorize every discrepancy (bug, intentional difference, unknown). Flag discrepancies in spec's ## Flags section. If UX improvement spotted: capture in docs/improvements/, do not implement. Suggest /wrapup.
- **Pass:** all discrepancies categorized (bugs fixed, intentional diffs documented, unknowns logged in QUESTIONS.md), /wrapup resolved flags.

## Process

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

### At scale (30+ screens)

Manual side-by-side comparison doesn't scale. Automation should cover what it can (visual diffs, output comparison). Manual validation focuses on what automation can't capture (interaction flows, conditional visibility, permission-based behavior).

How to automate is a methodology decision for the implementation verb.

### Performance

- Page load times acceptable?
- Data-heavy screens responsive?
- No memory leaks on navigation?

## Gate

- [ ] All screens validated side-by-side for functional parity
- [ ] All bugs fixed or triaged
- [ ] All discrepancies categorized (no uncategorized diffs)
- [ ] Performance acceptable
- [ ] All items at `[V-func]` in inventory
