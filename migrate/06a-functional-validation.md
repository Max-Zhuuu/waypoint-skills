# Phase 6a - Functional Validation

**Goal:** confirm the migration is functionally correct. Design doesn't matter yet.

## Checkpoints

### CP1: Post-validation review (per screen)
- **Trigger:** after a screen has been validated side-by-side against the source system
- **References:** feature spec, source system screen, docs/improvements/ file for this entity
- **Action:** spawn review agent. Categorize every discrepancy (bug, intentional difference, unknown). Run doc sync: update spec with any discoveries. If UX improvement spotted during validation: capture in docs/improvements/, do not implement.
- **Pass:** all discrepancies categorized and resolved (bugs fixed, intentional diffs documented, unknowns logged in QUESTIONS.md), spec updated.

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

### Visual regression

For 30+ screens, manual side-by-side comparison doesn't scale. Use visual regression testing: automated screenshot capture at defined viewports, overlaid with pixel-diff highlighting.

Run characterization test diffs in parallel - compare legacy output against migrated output for the same inputs. Manual validation focuses on what automation can't capture (interaction flows, conditional visibility, permission-based behavior).

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
