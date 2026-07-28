# Migration References

Process-layer references for `/migrate` phase files. These inform *when to decide* and *what criteria to apply* - they do not prescribe implementation methodology.

Testing methodology and architecture methodology are applied by implementation verbs (/tdd, or the [port checklist](port-checklist.md)) as judgment calls.
See below for the full catalog.

## Process References

### Spolsky's Rewrite Warning
Old code looks messy because it embodies years of bug fixes, edge case handling, and hard-won domain knowledge. A rewrite that starts clean will re-encounter every bug the original code already solved - but this time without knowing which behaviors are load-bearing.
**When to cite:** Any time someone wants to "simplify" legacy behavior they don't fully understand. Especially Phase 6a when parity discrepancies surface.

### "Legacy code is code without tests" (Feathers)
The defining characteristic of legacy code isn't age or messiness - it's the absence of tests that let you change it safely. Before modifying any legacy behavior, add a test that locks in the current behavior. Then change the behavior. This sequence - lock, change, verify - is the atomic unit of safe migration.
**When to cite:** Phase 3-4, any time someone wants to change behavior without first capturing what the current behavior is.

### Make the Change Easy, Then Make the Easy Change (Beck)
When a change is hard, don't force it. First, refactor until the change is easy (this might be the bulk of the work). Then make the now-easy change. Applied to migrations: don't fight the legacy architecture. The friction is a signal that the foundation needs work, not that you should push harder.
**When to cite:** Phase 3 architecture checkpoint, when a pattern feels forced.

## Acceptance criteria by phase

These are requirements (what must be true), not methodology (how to achieve it):

| Phase | Acceptance criteria |
|-------|--------------------|
| 3 - Vertical slice | Each screen's behavior is captured and reproducible. Discrepancies between source and target are categorized. |
| 4 - Horizontal buildout | Every ported screen has tests. Full suite passes. No regressions in previously-ported screens. |
| 5 - Integration | All screens consume real API (or documented exceptions). Loading/error/empty states implemented. |
| 6a - Functional validation | All screens validated side-by-side. All discrepancies categorized (bug, intentional, unknown). |

## Architecture Patterns

### Strangler Fig (Fowler)
Build the new system alongside the old one, routing traffic gradually from legacy to replacement.
Replace one capability at a time, keep both running, shift traffic when the new path is proven.
**When to apply:** Phase 2-4, when deciding how to cut over from legacy to new.

### Branch by Abstraction (Fowler)
Introduce an abstraction layer between consumers and the implementation you want to replace.
Swap the implementation behind the abstraction without changing callers.
**When to apply:** Phase 4-5, when migrating shared infrastructure that many screens depend on.

### Parallel Change / Expand-Contract (Beck)
Three steps: expand (add new alongside old), migrate (move callers), contract (remove old).
Never remove something in the same change that introduces its replacement.
**When to apply:** Phase 5 integration, any API shape change, any shared component replacement.

### Seam Identification (Feathers)
A seam is a place where you can alter behavior without editing the code at that point.
In legacy code, find the seams first - they're where you can inject tests, swap implementations, or redirect flow.
**When to apply:** Phase 3 vertical slice, when deciding where to cut boundaries between migrated and unmigrated code.

## Testing Techniques

### Characterization Tests / Golden Master (Feathers)
Capture the legacy system's actual output for a set of inputs.
Don't assert what the output *should* be - assert what it *is*.
Discrepancies are either bugs in the migration or intentional improvements - categorize each one.
**When to apply:** Phase 3-4, especially for screens with complex calculations or business rules where the spec may be incomplete.

### Structural Enforcement Tests
Automated tests that verify project conventions, not business logic.
Catches structural drift during horizontal buildout when many agents work in parallel.
**When to apply:** Phase 4 horizontal buildout at scale.

### Contract Tests (Pact-style)
Consumer-driven contracts: the frontend describes what it expects from the API.
The backend runs the same contract against its implementation.
**When to apply:** Phase 5 integration, when frontend and backend teams work on different timelines.

### Approval Tests / Snapshot Tests
Render a component, serialize the output, save as the "approved" version.
Complements characterization tests: golden master captures legacy behavior, snapshots capture migrated behavior.
**When to apply:** Phase 4-6a, after a screen is ported so later changes don't silently break it.

### Visual Regression Testing
Automated screenshot comparison between source and target, or between target's previous and current state.
**When to apply:** Phase 6a functional validation at scale (30+ screens).
