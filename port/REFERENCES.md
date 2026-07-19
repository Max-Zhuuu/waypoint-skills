# Port Methodology References

Loaded by `/port` when briefing subagents and reviewing output.
These are implementation techniques - the *how* of migration work.
Process references (the *when* and *what criteria*) live in the phase files.

## Architecture Patterns

### Strangler Fig (Fowler)
Build the new system alongside the old one, routing traffic gradually from legacy to replacement.
Replace one capability at a time, keep both running, shift traffic when the new path is proven.
The old system stays live as the safety net until each piece is validated.
**When to apply:** Phase 2-4, when deciding how to cut over from legacy to new.

### Branch by Abstraction (Fowler)
Introduce an abstraction layer between consumers and the implementation you want to replace.
Swap the implementation behind the abstraction without changing callers.
Lets you merge incomplete migrations to main without breaking anything.
**When to apply:** Phase 4-5, when migrating shared infrastructure that many screens depend on.

### Parallel Change / Expand-Contract (Beck)
Three steps: expand (add new alongside old), migrate (move callers), contract (remove old).
Never remove something in the same change that introduces its replacement.
Each step is independently deployable and reversible.
**When to apply:** Phase 5 integration, any API shape change, any shared component replacement.

### Seam Identification (Feathers)
A seam is a place where you can alter behavior without editing the code at that point.
In legacy code, find the seams first - they're where you can inject tests, swap implementations, or redirect flow.
Types: object seams (polymorphism), preprocessing seams (build config), link seams (dependency injection).
**When to apply:** Phase 3 vertical slice, when deciding where to cut boundaries between migrated and unmigrated code.

## Testing Techniques

### Characterization Tests / Golden Master (Feathers)
Capture the legacy system's actual output for a set of inputs.
Don't assert what the output *should* be - assert what it *is*.
The test doesn't prove correctness; it proves you haven't changed behavior.
Discrepancies are either bugs in the migration or intentional improvements - categorize each one.
**When to apply:** Phase 3-4, especially for screens with complex calculations or business rules where the spec may be incomplete.

### Structural Enforcement Tests
Automated tests that verify project conventions, not business logic.
Examples: every route has a feature spec, every form uses sanctioned controls, every list view has mock data.
Catches structural drift during horizontal buildout when many agents work in parallel.
**When to apply:** Phase 4 horizontal buildout at scale.

### Contract Tests (Pact-style)
Consumer-driven contracts: the frontend describes what it expects from the API.
The backend runs the same contract against its implementation.
Both sides verify independently, so breaking API changes are caught before deployment.
**When to apply:** Phase 5 integration, when frontend and backend teams work on different timelines.

### Approval Tests / Snapshot Tests
Render a component, serialize the output, save as the "approved" version.
Future runs diff against the approved snapshot - any change requires explicit approval.
Complements characterization tests: golden master captures legacy behavior, snapshots capture migrated behavior.
**When to apply:** Phase 4-6a, after a screen is ported so later changes don't silently break it.

### Visual Regression Testing
Automated screenshot comparison between source and target, or between target's previous and current state.
Catches CSS regressions, layout shifts, and missing elements that unit tests can't see.
**When to apply:** Phase 6a functional validation at scale (30+ screens).

## Review Depth

Classify each ported screen's complexity to calibrate review effort:

- **Moderate** (lighter review, Sonnet reviewer): no conditional visibility 3+ rules, no status lifecycle in logic doc, fewer than 4 tabs.
- **High** (deeper review, Opus reviewer): conditional visibility 3+ rules, OR status lifecycle, OR 4+ tabs.

Derived from spec content, not judgment. The classification determines how much review scrutiny the subagent output gets.
