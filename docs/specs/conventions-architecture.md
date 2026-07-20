# Conventions Architecture

**Status:** Draft - grilling complete
**Created:** 2026-07-20
**Updated:** 2026-07-20
**Origin:** Discovered during issue-tracker-integration grilling (Q4/D8)

## Problem

CONVENTIONS.md is a single file that covers naming patterns.
As the MZ skill family grows, project conventions expand beyond naming: decomposition preferences, testing philosophy, review standards, documentation structure.
A single file becomes overloaded for large projects.

The current shared reference file pattern (CONTEXT.md, CONVENTIONS.md, SCOPE.md, TESTING.md) treats each as a standalone document.
Some of these are really convention subtypes that could live under a unified conventions structure.

## Context

- Lightweight-entry-points spec (D6) defines a degradation table per missing artifact
- /project-setup Phase 1 scaffolds these files during initial setup
- CLAUDE.md references them early so agents pick them up
- Small projects may not need the folder structure - single files are fine

## Design Keywords

Three anchoring properties for the skill family, discovered during this grilling session:

- **Memoized** - /project-setup's decisions are persisted in CLAUDE.md. Re-running doesn't re-ask answered questions. The scaffold knows what it knows. /check-in records what it resolved and when. Concurrent sessions don't re-resolve what another session already resolved.
- **Reentrant** - /project-setup can be re-run at any time. It reads current state from CLAUDE.md, detects what exists, and only asks about what's new or changed. Tier transitions (Moderate -> Large, Large -> Moderate) are just re-running /project-setup. Concurrent check-ins propose work in non-conflicting areas without re-asking.
- **Self-healing** - If a referenced file is deleted, moved, or becomes stale, the system detects the inconsistency. /check-in or /project-setup notices and offers repair. Scope creep triggers /reorient suggestions. Documentation Map entries pointing to missing files are flagged.

These keywords should be documented in the family README as design anchors.

## Decisions

### D1: Tiered project scaffold
**Decision:** Four project tiers, selected during /project-setup or inferred from state:

| Tier | Setup | Scaffolding | Skills available |
|---|---|---|---|
| None (lightweight) | No /project-setup | Nothing | All verbs in degraded mode |
| Small | /project-setup ran | CLAUDE.md + basic SCOPE.md | /create + lightweight verbs |
| Moderate | /project-setup ran | Full flat files at root | Everything including /check-in |
| Large | /project-setup ran or upgraded | conventions/ folder + full docs tree | Everything + full enforcement |

Tier is recorded in CLAUDE.md's Project Scaffold section.
Upgrade and downgrade between tiers via re-running /project-setup (reentrant).
**Rationale:** Different project scales need different ceremony levels.
Small projects shouldn't deal with folder structures.
Large projects need organized conventions.
The reentrant property means you're never locked into a tier.

### D2: CLAUDE.md as the master anchor
**Decision:** CLAUDE.md contains three skill-family-managed sections:

**Project Scaffold** - tier, setup date, last re-entry date, last check-in date.
Written by /project-setup, updated by /check-in.

**Documentation Map** - table mapping logical concepts to physical paths.
Skills resolve "conventions" or "testing" by reading this map, not by hardcoding file paths.
Written by /project-setup, updated on tier transitions.

```markdown
## Documentation Map
| Concept | Path | Status |
|---------|------|--------|
| Domain glossary | CONTEXT.md | Active |
| Naming conventions | CONVENTIONS.md | Active |
| Test expectations | TESTING.md | Active |
| Scope boundaries | SCOPE.md | Active |
| Architecture decisions | docs/adr/ | Active |
```

**Active Workflow** - current skill, phase, activation date.
Written by /create, /buildout, /migrate.
Read by /check-in.

Prose sections (Repository Overview, Development, Tech Stack) stay human-authored.
/project-setup owns the machine-readable sections; humans own the context sections.
**Rationale:** CLAUDE.md is already the first file every agent reads.
Making it the resolution layer means skills never hardcode file paths.
Tier transitions update the map; skills follow automatically.
The memoized property: past /project-setup decisions persist here.
The self-healing property: /check-in verifies map entries point to existing files.

### D3: Documentation Map replaces Key Documents
**Decision:** The Documentation Map replaces hand-written "Key Documents" tables in CLAUDE.md.
Single source of truth for file locations.
/project-setup generates and maintains the map.
**Rationale:** Two tables mapping files (one machine-readable, one prose) creates duplication and drift.
The Documentation Map serves both audiences - agents read it programmatically, humans read it as reference.

### D4: Tier-dependent convention structure
**Decision:** Conventions map across tiers:

| Logical Concept | Small | Moderate | Large |
|---|---|---|---|
| Domain glossary | - | CONTEXT.md | CONTEXT.md |
| Naming conventions | - | CONVENTIONS.md | conventions/naming.md |
| Decomposition prefs | - | CONVENTIONS.md (section) | conventions/decomposition.md |
| Test expectations | - | TESTING.md | conventions/testing.md |
| Review standards | - | - | conventions/review.md |
| Scope boundaries | SCOPE.md (basic) | SCOPE.md | SCOPE.md |
| Architecture decisions | - | docs/adr/ | docs/adr/ |
| Architecture overview | - | - | ARCHITECTURE.md |

TESTING.md moves into conventions/testing.md for Large projects.
CONTEXT.md and SCOPE.md never merge into conventions - they're project facts, not conventions.
Moderate -> Large upgrade extracts CONVENTIONS.md sections into separate files and moves TESTING.md.
**Rationale:** Moderate keeps familiar flat files with low overhead.
Large organizes conventions for teams and complex projects.
The Documentation Map makes the physical restructuring invisible to skills.

### D5: Conversational tier selection
**Decision:** /project-setup opens conversationally, not with a cold multi-select.
The user describes their project, asks questions about what each tier involves.
The skill reads its own SCOPE-REFERENCE.md to explain options during uncertainty.
AskUserQuestion for tier comes after context is established.
**Rationale:** Matches /grill-with-docs's pattern - explore first, crystallize decisions after.
The user might not know upfront whether they need Moderate or Large.
Conversation surfaces project characteristics that inform the recommendation.

### D6: `-REFERENCE` naming class for skill-internal docs
**Decision:** Formalize `-REFERENCE` as a naming suffix for skill-internal documentation:
- `FOO.md` = user-facing project doc (CONVENTIONS.md, CONTEXT.md, SCOPE.md)
- `FOO-REFERENCE.md` = skill-internal doc that informs skill behavior, can be surfaced to users during uncertainty
- `FOO-FORMAT.md` = format template for user-facing docs (stays - already established with CONTEXT-FORMAT.md, ADR-FORMAT.md)

Rename existing files:
- `LIGHTWEIGHT.md` -> `LIGHTWEIGHT-REFERENCE.md`
- `LOCAL-DOCS.md` -> `LOCAL-DOCS-REFERENCE.md`

New files follow the pattern: `SCOPE-REFERENCE.md` in /project-setup describes tier options.
**Rationale:** Current naming is inconsistent (LIGHTWEIGHT.md, LOCAL-DOCS.md, CONTEXT-FORMAT.md - no pattern).
The `-REFERENCE` suffix creates a clear taxonomy.
Skills can read their own `-REFERENCE` files to explain options to users.

### D7: Dynamic degradation via Documentation Map
**Decision:** Degradation detection uses the Documentation Map with hardcoded fallback:
1. Check for CLAUDE.md with Documentation Map section
   - Found: resolve each concept from the map. Missing file = degraded for that concept.
   - Not found: check well-known root paths (CONVENTIONS.md, CONTEXT.md, etc.)
2. If neither CLAUDE.md nor well-known paths exist: tier is None (full lightweight mode)
3. First-ever invocation marker: .claude/.setup-prompted (unchanged from lightweight-entry-points spec)

Degradation is tier-relative: a Small project missing CONVENTIONS.md isn't degraded - it never had one.
A Moderate project whose Documentation Map points to a missing CONVENTIONS.md is degraded.
Self-healing: /check-in detects map entries pointing to missing files and offers repair.
**Rationale:** Hardcoded paths break when tiers restructure files.
The Documentation Map makes detection tier-aware.
Fallback to well-known paths preserves backward compatibility with pre-map projects.

## Discovery: Check-in as Coordination Fabric

During Q3 grilling, a broader concept surfaced:

CLAUDE.md records last check-in date in the Project Scaffold section.
/project-setup (moderate/large) writes a hook that surfaces check-in state to every session.
/check-in notes session progress: what it resolved, which docs it touched, when.

Concurrent sessions read this state and coordinate:
- **Memoized** - don't re-resolve what another session already resolved
- **Reentrant** - propose work in non-conflicting areas without re-asking
- **Self-healing** - detect scope creep across sessions, suggest /reorient, recommend user focus on one area

This evolves ACTIVE-WORK.md from "avoid file conflicts" to "coordinate on decisions and progress."
Implementation details deferred to a /check-in evolution spec.
