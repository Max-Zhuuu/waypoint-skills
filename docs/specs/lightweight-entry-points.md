# Lightweight Entry Points

**Status:** Draft - README alignment complete
**Created:** 2026-07-20
**Updated:** 2026-07-20

## Problem

The Waypoint skill family requires /project-setup before any verb skill works at full capacity.
Users who want to TDD a feature, spec a requirement, or diagnose a bug must first run a heavyweight scaffolding step.
This creates adoption friction - rated C on adoption velocity in the strategic comparison.

## Decisions

### D1: Degradation strategy
**Decision:** Silent degradation with a one-line soft prompt.
When scaffolding files (CONTEXT.md, CONVENTIONS.md, SCOPE.md) are missing, skills function at reduced capacity and print a single notice: "Tip: run /project-setup for domain-aware grilling and convention enforcement."
**Rationale:** Prompting for /project-setup recreates the friction we're solving. The notice preserves discoverability without blocking work.

### D2: Prompt frequency
**Decision:** Once per project, tracked by a marker file (.claude/.setup-prompted).
After the first notice, the marker is written and the prompt never repeats.
**Rationale:** Repeating the prompt turns a nudge into nag. A user who's seen it and chosen not to run /project-setup has made a deliberate choice.

### D3: /check-in scope
**Decision:** /check-in stays post-setup only. It does not degrade.
**Rationale:** /check-in's purpose is session continuity within an established workflow. Without Active Workflow, phase files, or SCOPE.md frontmatter, it has nothing to read. The lightweight path is: invoke verbs directly. The structured path is: /project-setup then /check-in. Two distinct user journeys, not one degraded version of the other.

### D4: Scope - all seven standalone skills get lightweight mode
**Decision:** /tdd, /spec, /diagnose, /grill-me, /grill-with-docs, /learn, /improve-codebase-architecture all work without scaffolding.
**Rationale:** Every one has a self-contained core loop. Scaffolding adds domain awareness and cross-referencing, not core behavior. /grill-me already has zero scaffolding dependencies.

### D5: Shared protocol file (LIGHTWEIGHT-REFERENCE.md)
**Decision:** Single LIGHTWEIGHT-REFERENCE.md at the skill family root, referenced by each skill with one line: "If scaffolding is missing, follow [LIGHTWEIGHT-REFERENCE.md](../LIGHTWEIGHT-REFERENCE.md)."
Follows the `-REFERENCE` naming class for skill-internal docs (see conventions-architecture D6).
**Contents:**
1. Detection logic (which files to check, in what order)
2. One-line notice template
3. Marker file convention (.claude/.setup-prompted)
4. Degradation table (per-artifact: what's lost, what still works)
5. Lazy creation rules (when a skill may create scaffolding vs. leaving it to /project-setup)
6. Recommended next step mapping (stateless triggers only)

### D6: Degradation table

| Missing artifact | What degrades | What still works |
|---|---|---|
| CONTEXT.md | No domain term cross-referencing, no glossary challenges | Core skill loop, codebase exploration, all outputs |
| CONVENTIONS.md | No convention enforcement during implementation | Code generation, testing, all outputs |
| SCOPE.md | No scope boundary checks, no archetype-aware behavior | Feature scoping, spec writing |
| TESTING.md | No project-specific test philosophy | Default test patterns (integration-style, public interfaces) |
| ARCHITECTURE.md | No architecture cross-referencing | All outputs, ADR creation still works |
| docs/adr/ | No existing decision cross-referencing | ADR creation (lazy - creates dir on first write) |
| Active Workflow in CLAUDE.md | /check-in non-functional, no phase awareness | All verb skills work standalone |

### D7: Recommended next steps - stateless triggers only
**Decision:** Two triggers only, no counters:
1. **First-ever invocation** (marker file doesn't exist) - one-line tip, write marker
2. **Lazy file creation** (skill creates CONTEXT.md or docs/adr/) - inline note: "Created CONTEXT.md. Run /project-setup to build the full docs tree."
**Rationale:** Counting invocations across sessions is fragile. Stateless file-existence checks are simpler and more robust.

### D8: LIGHTWEIGHT-REFERENCE.md owns the upgrade path
**Decision:** The mapping from usage patterns to setup recommendations lives in LIGHTWEIGHT-REFERENCE.md, not in individual skills.
**Rationale:** Skills should call the protocol, not decide when or how to nudge. Centralizes the upgrade UX in one place.

### D9: No lazy scaffolding
**Decision:** Skills create only their own output artifacts, never adjacent scaffolding.
/spec creates docs/implementation/specs/ and writes the spec file. It does not create SCOPE.md.
/grill-with-docs creates CONTEXT.md and docs/adr/ because those are its direct outputs.
**Rule:** If the file is the skill's output, create it. If the file is another skill's output, don't.
**Rationale:** Avoids half-built scaffolding that /project-setup would then have to detect and merge with.

### D10: docs/implementation/ as the shared container
**Decision:** Consolidate implementation artifacts under docs/implementation/.
Canonical structure definition owned by conventions-architecture U3.
This spec defers to that definition for the full subdirectory list and frontmatter pattern.
- Existing docs/improvements/ moves to docs/implementation/improvements/
- docs/local/handoffs/ moves to docs/implementation/handoffs/ (these are shared, not local)
**Rationale:** Three related artifact types that all track implementation work, all shared, all using the same status lifecycle.
Canonical ownership moved to conventions-architecture to prevent drift between specs.

### D11: Flat structure within subdirectories, metadata in frontmatter
**Decision:** No date folders. Each file gets frontmatter:
```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: Draft | In Progress | Done | Blocked
---
```
Temporal queries via `grep -l "status: In Progress" docs/implementation/specs/`.
**Rationale:** Date folders add structure that doesn't earn its keep. Git log tells you when a file was created. Status field answers "what's active?" without navigating folder hierarchy.

### D12: /create survives as the loop orchestrator
**Decision:** /create's value is sequencing spec -> build -> wrapup as a single session workflow, not low ceremony.
Lightweight entry points are "I just want to run /tdd right now." /create is "I want to add one feature, start to finish."
Different intents, both valid. No changes needed to /create - it gets the LIGHTWEIGHT-REFERENCE.md reference like everything else.
Note: /create is now classified as a bridge skill (see conventions-architecture U2).

## README Alignment

Decisions from the comprehensive README alignment grill.

### U1: Canonical fallback paths in LIGHTWEIGHT-REFERENCE.md
**Decision:** LIGHTWEIGHT-REFERENCE.md owns the canonical list of well-known fallback paths used when no Documentation Map exists:
- CONTEXT.md (root)
- CONVENTIONS.md (root)
- SCOPE.md (root)
- TESTING.md (root)
- ARCHITECTURE.md (root)
- docs/adr/ (directory)
- .claude/ (skill state directory)

When the Documentation Map is absent, skills check these paths in order.
When the Documentation Map is present, skills resolve through the map exclusively.
**Rationale:** Fallback paths were scattered across individual specs and the degradation table (D6).
Centralizing them in LIGHTWEIGHT-REFERENCE.md gives new skill authors one place to look.
The README principle "never hardcoded paths" applies when the map exists; the fallback list handles bootstrapping.

### U2: Marker files map-resolvable via Skill State
**Decision:** The .claude/.setup-prompted marker file and any future skill-internal markers are resolvable through the Documentation Map's "Skill State" concept (see conventions-architecture U5).
When no map exists, skills check .claude/ directly (part of the fallback path list above).
**Rationale:** Keeps the "everything through the map" principle clean.
Marker files are infrastructure, but they're still file references that benefit from map resolution.
