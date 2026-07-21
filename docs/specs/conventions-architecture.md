# Conventions Architecture

**Status:** Draft - README alignment complete
**Created:** 2026-07-20
**Updated:** 2026-07-20
**Origin:** Discovered during issue-tracker-integration grilling (Q4/D8)

## Problem

CONVENTIONS.md is a single file that covers naming patterns.
As the Waypoint skill family grows, project conventions expand beyond naming: decomposition preferences, testing philosophy, review standards, documentation structure.
A single file becomes overloaded for large projects.

The current shared reference file pattern (CONTEXT.md, CONVENTIONS.md, SCOPE.md, TESTING.md) treats each as a standalone document.
Some of these are really convention subtypes that could live under a unified conventions structure.

## Context

- Lightweight-entry-points spec (D6) defines a degradation table per missing artifact
- /project-setup Phase 1 scaffolds these files during initial setup
- CLAUDE.md references them early so agents pick them up
- Small projects may not need the folder structure - single files are fine

## Design Keywords

Four anchoring properties for the skill family, discovered and refined during grilling:

- **Memoized** - /project-setup's decisions are persisted in CLAUDE.md. Re-running doesn't re-ask answered questions. The scaffold knows what it knows. /check-in records what it resolved and when. Concurrent sessions don't re-resolve what another session already resolved.
- **Reentrant** - /project-setup can be re-run at any time. It reads current state from CLAUDE.md, detects what exists, and only asks about what's new or changed. Tier transitions (Moderate -> Large, Large -> Moderate) are just re-running /project-setup. Concurrent check-ins propose work in non-conflicting areas without re-asking.
- **Self-healing** - If a referenced file is deleted, moved, or becomes stale, the system detects the inconsistency. /check-in or /project-setup notices and offers repair. Scope creep triggers /reorient suggestions. Documentation Map entries pointing to missing files are flagged.
- **Bias to action** - When the answer is inferrable from the codebase, existing docs, or conventions, act on it. Propose the result; don't ask the question. AskUserQuestion is reserved for genuinely ambiguous forks where both paths are reasonable and the wrong choice wastes significant work. Skills adapt to existing documentation structure rather than demanding their own.

These keywords are documented in the family README as design anchors.

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

## README Alignment

Decisions from the comprehensive README alignment grill.
These extend the original D1-D7 decisions with cross-cutting concerns surfaced by the finalized README.

### U1: Content vs state writer split
**Decision:** Single-writer discipline applies to content docs (CONVENTIONS.md, CONTEXT.md, DESIGN-SYSTEM.md) - only /wrapup writes to these.
Machine-readable state in CLAUDE.md has designated writers per section:
- **Project Scaffold** - owned by /project-setup, timestamps updated by /check-in
- **Documentation Map** - owned by /project-setup, updated on tier transitions
- **Active Workflow** - owned by the workflow skill (/create, /buildout, /migrate)

This is not an exception to single-writer - it IS single-writer, applied per artifact.
The ownership table lives in CONCEPTS-REFERENCE.md as the canonical reference.
**Rationale:** The original "only /wrapup writes to shared docs" was imprecise.
/project-setup and /check-in clearly write to CLAUDE.md.
Making the per-section ownership explicit removes ambiguity without weakening the principle.

### U2: Bridge skill pattern
**Decision:** Formalize "bridge skill" as a named pattern for skills that span both layers.
Three levels of formalization:

1. **Glossary entry:** "Bridge skill - a task-layer skill with project-layer integration points.
   Works standalone; gains context when project scaffolding exists."
2. **Skill Map annotation:** Bridge skills marked with `*` in the Skill Map.
   Readers see at a glance which skills enhance with project setup.
3. **Spec section (this section):** A bridge skill must:
   - Have a self-contained core loop that works without any scaffolding
   - Define specific integration points (what project-layer data it reads, what it writes)
   - Degrade gracefully per LIGHTWEIGHT-REFERENCE.md when integration data is missing
   - Never require project setup to function at its core purpose

**Bridge skills identified:**
- `/to-issues` - task verb (convert spec to issues) + /check-in integration (triaged issues as priority layer)
- `/triage` - task verb (triage backlog) + /check-in pull (surfaces ready-for-agent issues)
- `/create` - single-session orchestrator (spec -> build -> wrapup) + can write Active Workflow for multi-session features
- `/prototype` - task verb (quick validation mockup) + integrates with /buildout Phase design system
- `/spec` - task verb (grill requirements) + cross-references SCOPE.md boundaries and CONVENTIONS.md naming when present

**Rationale:** The two-layer model creates a clean separation, but some skills genuinely participate in both.
Naming the pattern prevents them from being misclassified as purely one layer or the other.
The annotation in the Skill Map gives readers immediate visibility.

### U3: docs/implementation/ canonical structure
**Decision:** Conventions-architecture owns the canonical docs/implementation/ structure definition.
Other specs (lightweight-entry-points, issue-tracker-integration) reference it.

```
docs/implementation/
  specs/          - feature specs from /spec
  improvements/   - improvement proposals
  handoffs/       - cross-boundary work that pauses implementation
  issues/         - work items from /to-issues (local mode only)
```

Same frontmatter pattern for all files:
```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
status: Draft | In Progress | Done | Blocked
---
```

Flat structure within subdirectories - no date folders.
Temporal queries via grep on status field.
**Rationale:** Multiple specs were independently defining the same container.
Centralizing the canonical structure here prevents drift between specs.
Lightweight-entry-points D10 and issue-tracker D9 defer to this definition.

### U4: /check-in full specification
**Decision:** Fold /check-in's complete behavior into this spec rather than a standalone spec.
/check-in is tightly coupled to the Documentation Map, tier system, and coordination fabric.

**Single-session behavior (existing, now codified):**
1. Read Active Workflow record from CLAUDE.md
2. Read phase files for current workflow
3. Read ACTIVE-WORK.md for concurrent session state
4. Detect drift (scope creep, stale questions, missing files) -> suggest /reorient
5. If no drift: propose next task based on phase state and remaining work
6. Fire pre-build checkpoint (verify spec, load references) before implementation
7. Fire post-build checkpoint (review, doc sync, inventory update) after implementation
8. Suggest /wrapup for session close
9. Propose next task or flag stale questions

**Coordination fabric (evolution):**
- CLAUDE.md records last check-in date in Project Scaffold section
- /check-in notes session progress: what it resolved, which docs it touched, when
- Concurrent sessions read this state:
  - **Memoized** - don't re-resolve what another session already resolved
  - **Reentrant** - propose work in non-conflicting areas without re-asking
  - **Self-healing** - detect scope creep across sessions, suggest /reorient

**Rationale:** The README's project session flow promises behavior that was underdocumented.
Splitting /check-in behavior across a SKILL.md and a separate evolution spec fragments the specification.
This spec already owns the tier system and Documentation Map that /check-in depends on.

### U5: Documentation Map includes Skill State
**Decision:** The Documentation Map includes a "Skill State" concept pointing to the .claude/ directory.
Marker files (.claude/.setup-prompted) and other skill-internal state are map-resolvable.

```markdown
| Concept | Path | Status |
|---------|------|--------|
| ... | ... | ... |
| Skill state | .claude/ | Active |
```

The canonical fallback path list (CONTEXT.md, CONVENTIONS.md at root, etc.) lives in LIGHTWEIGHT-REFERENCE.md.
When no Documentation Map exists, skills use the fallback list to detect what's present.
**Rationale:** "Never hardcoded paths" should be a universal principle, not one with ad-hoc exceptions.
Map-resolving marker files keeps the principle clean.
The fallback list in LIGHTWEIGHT-REFERENCE.md handles the bootstrapping case (no map yet).
