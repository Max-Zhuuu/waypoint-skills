# Migration References

Loaded on demand by `/migrate` phase files. Named patterns and testing techniques the agent should cite when making recommendations - not as decoration, but because each one solves a specific problem that recurs in every migration.

## Architecture Patterns

### Strangler Fig (Fowler)
Build the new system alongside the old one, routing traffic gradually from legacy to replacement. Never rewrite in one shot - replace one capability at a time, keep both running, shift traffic when the new path is proven. The key insight: the old system stays live as the safety net until each piece is validated.
**When to cite:** Phase 2-4, any time someone proposes a big-bang cutover or wants to shut down legacy early.

### Branch by Abstraction (Fowler)
Introduce an abstraction layer between consumers and the implementation you want to replace. Swap the implementation behind the abstraction without changing callers. Lets you merge incomplete migrations to main without breaking anything - the abstraction routes to old or new code based on readiness.
**When to cite:** Phase 4-5, when migrating shared infrastructure (auth, data layer, API clients) that many screens depend on.

### Parallel Change / Expand-Contract (Beck)
Three steps: expand (add the new way alongside the old), migrate (move all callers to the new way), contract (remove the old way). Never remove something in the same change that introduces its replacement. Each step is independently deployable and reversible.
**When to cite:** Phase 5 integration, any API shape change, any shared component replacement.

### Seam Identification (Feathers)
A seam is a place where you can alter behavior without editing the code at that point. In legacy code, find the seams first - they're where you can inject tests, swap implementations, or redirect flow without rewriting the surrounding code. Types of seams: object seams (polymorphism), preprocessing seams (build config), link seams (dependency injection).
**When to cite:** Phase 3 vertical slice, when deciding where to cut boundaries between migrated and unmigrated code.

### Spolsky's Rewrite Warning
Old code looks messy because it embodies years of bug fixes, edge case handling, and hard-won domain knowledge. A rewrite that starts clean will re-encounter every bug the original code already solved - but this time without knowing which behaviors are load-bearing. The ugly conditional on line 347 exists for a reason you haven't discovered yet.
**When to cite:** Any time someone wants to "simplify" legacy behavior they don't fully understand. Especially Phase 6a when parity discrepancies surface.

## Testing Techniques

### Characterization Tests / Golden Master (Feathers)
Capture the legacy system's actual output for a set of inputs. Don't assert what the output *should* be - assert what it *is*. The test doesn't prove correctness; it proves you haven't changed behavior. Run the same inputs through the new system and diff. Discrepancies are either bugs in the migration or intentional improvements - categorize each one.
**When to cite:** Phase 3 vertical slice. Especially valuable for screens with complex calculations or business rules where the spec may be incomplete.

### Structural Enforcement Tests
Automated tests that verify project conventions, not business logic. Examples: every route has a matching feature spec, every form field uses a sanctioned control type, every list view has mock data, every screen has scoped styles. Catches structural drift during horizontal buildout when many agents work in parallel.
**When to cite:** Phase 4 horizontal buildout. The bv-glomaris migration-structure test suite is an example - it enforces ribbon entries, CardShell wiring, route naming, and spec coverage.

### Contract Tests (Pact-style)
Consumer-driven contracts: the frontend writes a test describing what it expects from the API (shape, status codes, edge cases). The backend runs the same contract against its implementation. Both sides verify independently, so a breaking API change is caught before deployment - not after.
**When to cite:** Phase 5 integration, especially when frontend and backend teams work on different timelines.

### Approval Tests / Snapshot Tests
Render a component or screen, serialize the output (DOM, screenshot, JSON), save it as the "approved" version. Future runs diff against the approved snapshot. Any change requires explicit approval - prevents accidental regressions in screens you're not actively working on. Complements characterization tests: golden master captures legacy behavior, snapshots capture migrated behavior.
**When to cite:** Phase 4-6a. After a screen is ported, snapshot it so later changes (shared component updates, style changes) don't silently break it.

### Visual Regression Testing
Automated screenshot comparison between the source system and the target, or between the target's previous and current state. Tools capture screenshots at defined viewports, overlay them, and highlight pixel differences. Catches CSS regressions, layout shifts, and missing elements that unit tests can't see.
**When to cite:** Phase 6a functional validation. Side-by-side screenshots are faster and more reliable than manual visual comparison for 30+ screens.

### Smoke Tests
The smallest set of tests that prove the app isn't fundamentally broken. Hit the main entry points, verify they render without crashing, confirm the critical user path works end-to-end. Not comprehensive - just a "did we break the building" check. Run these on every commit; run the full suite less often.
**When to cite:** Phase 4 during rapid buildout, Phase 7 cutover. The first thing to automate in CI.

## Testing Playbook by Phase

| Phase | Primary technique | Why this one |
|-------|------------------|--------------|
| 3 - Vertical slice | Characterization tests | Capture legacy behavior before you've understood every edge case. The spec might be incomplete; the golden master isn't. |
| 4 - Horizontal buildout | Structural enforcement + snapshots | Many screens, possibly many agents. Enforce conventions automatically. Snapshot each screen after porting so later work doesn't regress it. |
| 5 - Integration | Contract tests + smoke tests | API shape mismatches surface here. Contract tests catch them before they become runtime bugs. Smoke tests verify nothing broke during the swap from mock to real. |
| 6a - Functional validation | Visual regression + characterization diffs | Side-by-side comparison at scale. Automate what you can; the remaining manual checks are for behavior the automation can't capture (conditional visibility, interaction flows). |

## Product & Process References

### "Legacy code is code without tests" (Feathers)
The defining characteristic of legacy code isn't age or messiness - it's the absence of tests that let you change it safely. Before modifying any legacy behavior, add a test that locks in the current behavior. Then change the behavior. This sequence - lock, change, verify - is the atomic unit of safe migration.
**When to cite:** Phase 3-4, any time someone wants to change behavior without first capturing what the current behavior is.

### Make the Change Easy, Then Make the Easy Change (Beck)
When a change is hard, don't force it. First, refactor until the change is easy (this might be the bulk of the work). Then make the now-easy change. Applied to migrations: don't fight the legacy architecture. Build the abstraction layer, the adapter, the seam - then the actual migration becomes mechanical.
**When to cite:** Phase 3 architecture checkpoint, when a pattern feels forced. The friction is a signal that the foundation needs work, not that you should push harder.
