# Phase 6a - Functional Validation

**Goal:** confirm the migration is functionally correct. Design doesn't matter yet.

## Side-by-side parity check

For each screen, source system and target side by side:
- Fields present and correct?
- Controls behave the same? (dropdowns, tables, forms)
- Data matches? (same records, same calculations)
- Edge cases handled? (empty states, permission variations, status transitions)
- Navigation paths match? (can reach the same workflows)

## Categorize discrepancies

- **Bug** - should match source but doesn't -> fix now
- **Intentional difference** - documented improvement or simplification -> note in spec
- **Unknown** - can't determine if source behavior is correct -> add to QUESTIONS.md

## Performance

- Page load times acceptable?
- Data-heavy screens responsive?
- No memory leaks on navigation?

## Gate

- [ ] All screens validated side-by-side for functional parity
- [ ] All bugs fixed or triaged
- [ ] Performance acceptable
- [ ] All items at `[V-func]` in inventory
