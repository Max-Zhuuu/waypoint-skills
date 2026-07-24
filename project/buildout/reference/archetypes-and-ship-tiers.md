# Archetypes and Ship Tiers

Definitions backing the `/buildout` project intake questions. Archetypes are composable - a project can be both "product" and "design-system." No selection = core enforcement rules only, and /check-in adapts dynamically. The user can change archetypes mid-project without re-running setup.

## Archetypes

- **Product** - multiple features, multiple user types, ongoing lifecycle. Adds: scope creep enforcement, unvalidated assumptions check, full discovery phase.
- **Feature** - multi-screen feature within an existing product. Adds: spec coverage enforcement, reduced discovery.
- **Deliverable** - report, tool, integration with clear scope. Adds: minimal ceremony, focused build.
- **Design system** - design language work (tokens, patterns, density). Adds: premature design enforcement during build, design phase after functional gate.

## Ship Tiers

- **Hobby/side project** - deployed, README, no crashes on happy path.
- **Has real users (Recommended)** - pipeline, error handling, persistence, someone else used it.
- **May grow** - monitoring, perf, security, v2 scope.

Store as `ship-tier: hobby | users | growth` in SCOPE.md frontmatter. Phase 4 re-confirms the tier before running the ship checklist.
