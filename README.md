# Skills

A process toolkit for building software products with AI agents.
Three layers: setup the project, check in every session, build with the right verb.

## Skill Map

```
SETUP (run once per project)
  /project-setup        Foundation: architecture, docs, CLAUDE.md, templates,
                        CONVENTIONS.md, TESTING.md
    -> /migrate         Configure as migration (source system, parity gates, inventory)
    -> /buildout        Configure as greenfield (intake: scope/validation/design profile)

SESSION (run every time you sit down)
  /check-in             Orient, propose next task, fire checkpoints, update inventory
    reads:              Phase files from /migrate or /buildout
                        PROGRESS-AUDIT.md from /reorient
                        ACTIVE-WORK.md, inventory, CONVENTIONS.md, TESTING.md
    fires:              Pre-build checkpoint (load references, verify spec exists)
                        Post-build checkpoint (review agent, doc sync, inventory update)
    invokes:            /reorient when drift detected (same phase 2+ weeks, stale questions)

IMPLEMENTATION (the building verbs)
  /tdd                  Greenfield: define desired behavior, test first, build to satisfy
  /port                 Migration: capture current behavior, replicate, verify parity

SUPPORTING (invoked by checkpoints, other skills, or directly)
  /spec                 Grill requirements, output spec file
                        Hard prerequisite in buildout, conditional in migration
  /grill-with-docs      Architecture decisions that meet the ADR threshold
                        Hard at Phase 3 post-slice, conditional in Phases 4-5
  /reorient             Strategic course correction, axis audit, re-prioritize
                        Invoked by /check-in on drift, or directly between sprints
  /learn                Trade-off exploration with options, terms, quiz
                        Soft recommendation in early phases, user-driven later
  /prototype            Quick validation mockup
                        Recommended for mature improvements entering design phase
  /diagnose             Debug a specific issue
  /grill-me             Open-ended interview on any plan or decision
```

## Two-Layer Model

The skill family operates at two layers:

**Project layer** (multi-session work): `/project-setup` + `/buildout` or `/migrate` + `/check-in` + inventory + gates. Use when you need to track progress across sessions.

**Task layer** (single-session work): `/tdd`, `/port`, `/spec`, `/prototype`. Self-contained verbs. Use directly for small work without project setup ceremony.

Boundary: if you need to track progress across sessions, you need the project layer.

## How a Session Flows

```
You sit down.
  |
  v
/check-in
  "Phase 4. 12 screens left. VesselParticulars is next -
   3 dependents waiting on it. Spec is current."
  |
  v  (pre-build checkpoint fires: spec verified, references loaded)
  |
/port VesselParticulars          (migration)
/tdd  CreateVessel               (greenfield)
  |
  v  (implementation happens)
  |
/check-in fires post-build checkpoint
  -> review agent validates against spec + source
  -> doc sync: spec updated, shared docs checked
  -> inventory updated
  -> "Done. 11 remaining. PortAgents is next, or resolve
     the 2 stale questions in QUESTIONS.md first?"
```

## Key Concepts

### Checkpoints
Named blocks inside phase files with four fields:
- **Trigger** - when it fires (before each build, after slice, etc.)
- **References** - exact files to read and validate against
- **Action** - what to do (invoke /spec, spawn reviewer, block)
- **Pass condition** - what "done" looks like

Distinct from gates (end-of-phase go/no-go) and enforcement (per-invocation checks in SKILL.md).

### Resolution Cascade
When a checkpoint finds a mismatch:
1. **Source code validation** - read the authoritative source for ground truth
2. **Test case validation** - write or run a test that proves which side is correct
3. **Human validation** - escalate with specifics if source and tests are ambiguous

### Review Agent Allocation
Complexity derived from spec content, not judgment:
- **Moderate** (5:1 ratio, Sonnet reviewer): no conditional visibility 3+ rules, no status lifecycle, fewer than 4 tabs
- **High** (3:1 ratio, Opus reviewer): conditional visibility 3+ rules, OR status lifecycle, OR 4+ tabs
- Every screen gets reviewed. No skip tier.

### Doc Sync
Embedded in every post-build checkpoint. Not a separate task - a side effect of completion:
1. Diff build against reference list
2. Update mechanical diffs inline, flag intentional deviations
3. Cascade check: CONVENTIONS.md, DESIGN-SYSTEM.md, CONTEXT.md
4. Pass condition includes "shared docs are current"

### Project Intake (buildout only)
Three questions at setup, stored as SCOPE.md frontmatter:
- **Scope**: product / feature / deliverable
- **Validation**: full / lightweight / none
- **Design**: full / lightweight / none

The profile determines which phase sections are active and which docs get created.

### Shared References
Repo-root files that all skills and subagents read:
- **CONVENTIONS.md** - naming patterns (seeded Phase 1, refined Phase 3)
- **TESTING.md** - test expectations by complexity tier (seeded Phase 1, refined Phase 3)
- **CONTEXT.md** - domain glossary (updated whenever terms are resolved)

## Phase Overview

### Migration (/migrate)

| Phase | Name | Verb | Key Checkpoint |
|-------|------|------|----------------|
| 0-1 | Setup | /project-setup + /migrate | - |
| 2 | Documentation Sprint | manual | Gate only (every entity spec'd) |
| 3 | Vertical Slice | /port | Pre-build spec check, post-slice architecture grill |
| 4 | Horizontal Buildout | /port | Pre-build spec prerequisite per screen, post-build review + doc sync |
| 5 | Integration | /port | Pre-wire dependency + shape check, post-wire review |
| 6a | Functional Validation | manual | Post-validation review per screen |
| 6b-i | Design System | - | Component taxonomy audit, post-token doc sync |
| 6b-ii | UX Improvements | /prototype | Research protocol (3-step), impact classification (Tier 1/2/3) |
| 7 | Cutover | manual | Ship checklist |

### Buildout (/buildout)

| Phase | Name | Verb | Key Checkpoint |
|-------|------|------|----------------|
| 0-1 | Setup | /project-setup + /buildout | Project intake (3 questions) |
| 2 | Discovery & Validation | /spec | Gate only (persona, MoSCoW, specs) |
| 3 | MVP Build | /tdd | Pre-build spec check, post-slice architecture grill |
| 4 | Iterate & Ship | /tdd | Pre-build for new Must, design consolidation (3+ design items) |
| - | Design System (shared) | - | After Phase 3 gate when design profile is full/lightweight |

## Design Phase

### 6b-i (shared - both project types)
Component taxonomy audit -> token audit -> semantic layering -> density variants -> prototype and compare. Gate: zero hardcoded values, density toggle works, DESIGN-SYSTEM.md written.

### 6b-ii (migration-only)
Top-down macro -> meso -> micro interaction refinement. Research protocol required before prototyping component-level or page-level improvements. Improvements classified by impact tier (frontend-only / API-shape / schema-logic). Cross-boundary work flows through docs/local/handoffs/.

### Buildout design work
No 6b-ii. Design refinement is feedback-driven inside Phase 4 via the design consolidation checkpoint (fires when 3+ design observations accumulate).

### Design during build phases
Allowed but unmanaged. Ideas go to docs/improvements/, experiments go on design branches, nothing merges until the design phase.

## Cross-Boundary Handoffs

When design or build work crosses the frontend boundary:

| Tier | What changes | Output | Where it lives |
|------|-------------|--------|----------------|
| 1 | Frontend only | Nothing | Proceed |
| 2 | API shape | Design brief + data contract | docs/local/handoffs/api-contracts/ |
| 3 | Schema/logic | ADR via /grill-with-docs + handoff | docs/local/handoffs/schema-changes/ + docs/adr/ |

Handoff format: `{date}-{slug}.md` with frontmatter `status: requested | in-progress | delivered | deferred`.
