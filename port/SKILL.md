---
name: port
description: Migration implementation verb. Ports a screen from the source system to the target. Reads spec + logic doc + source code, writes characterization tests first, builds to match, verifies parity. Use when /check-in proposes a migration screen to build.
disable-model-invocation: true
---

# Port

The migration implementation verb. Backward-looking: capture current behavior, replicate, verify parity.

Distinct from `/tdd` which is forward-looking: define desired behavior, test first, build to satisfy.

## Inputs (three required)

1. **Feature spec** - `docs/reference/features/{entity}.md` (or `docs/wpf-reference/features/` for this project)
2. **Logic doc** - `docs/reference/logic/{entity}.md` (or `docs/wpf-reference/logic/`)
3. **Source system** - WPF source files listed in the feature spec's reference section

If any input is missing, stop and report. Do not build without all three.

## Process

### 1. Lock current behavior (Feathers)

Write characterization tests first. Capture the legacy system's actual output for a set of inputs, then assert the new system matches. Don't assert what the output *should* be - assert what it *is*.

The spec might be incomplete; the golden master isn't. Discrepancies are either bugs in the migration or intentional improvements - categorize each one explicitly.

### 2. Build to match

Follow the per-screen build process:

1. Route (add to router)
2. View component (layout, fields, controls per spec)
3. Data layer (composable, types, API shape)
4. Mock data (matching spec's field list and types)
5. Tests (structural enforcement + characterization)

Cross-reference against source system side-by-side throughout.

### 3. Verify parity

After the build:
- Fields present and correct against spec?
- Controls match source system behavior?
- Conditional visibility rules implemented?
- Navigation paths work (breadcrumb, tabs, drill-down)?

### 4. Fix both code and docs

When cross-reference finds discrepancies:
- Fix the Vue code
- Update the feature spec where it was incomplete
- Add Change Log entry to the spec

### 5. Report complete

Run `pnpm test` - zero failures required.
Mark `[P]` in inventory.
Report to `/check-in` for post-build checkpoint (review agent, doc sync).

## Concurrency

Multiple `/port` sessions can run simultaneously IF:
- Non-overlapping entities claimed in ACTIVE-WORK.md
- Shared infra changes are single-threaded
- Each agent reads the spec before building

## UX improvements

When you spot a UX improvement during porting: write a one-liner in `docs/improvements/{entity}.md` and keep porting. Do NOT implement improvements. Design work waits for Phase 6b.

Design exploration on isolated branches is allowed per CLAUDE.md's design exploration policy.

## References

See REFERENCES.md for: characterization tests (Feathers), structural enforcement, seam identification, contract tests.
