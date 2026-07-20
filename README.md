# Skills

A process toolkit for building software products with AI agents.
Three layers: setup the project, check in every session, build with the right verb.

## Skill Map

```
SETUP (run once per project)
  /project-setup        Foundation: architecture, docs, CLAUDE.md, templates,
                        CONVENTIONS.md, TESTING.md

WORKFLOW (pick one - writes Active Workflow record to CLAUDE.md)
  /migrate              Replace an existing system layer by layer
                        (parity tracking, inventory, phased cutover)
  /buildout             Build a new product from scratch
                        (MoSCoW prioritization, MVP-first, feedback rounds)
  /create               Add features to an existing codebase
                        (spec, build, wrapup - no phases or inventory)

SESSION (run every time you sit down)
  /check-in             Orient, propose next task, fire checkpoints
    reads:              Active Workflow record in CLAUDE.md
                        Phase files from /migrate or /buildout (if active)
                        PROGRESS-AUDIT.md from /reorient
                        ACTIVE-WORK.md, inventory, CONVENTIONS.md, TESTING.md
    fires:              Pre-build checkpoint (load references, verify spec exists)
                        Post-build checkpoint (review agent, doc sync, inventory update)
    invokes:            /reorient when drift detected (same phase 2+ weeks, stale questions)

IMPLEMENTATION (the building verbs)
  /tdd                  Define desired behavior, test first, build to satisfy
  /port                 Migration: capture current behavior, replicate, verify parity

SUPPORTING (invoked by checkpoints, other skills, or directly)
  /spec                 Grill requirements, output spec file
  /wrapup               Resolve flags, spec drift check, cascade to shared docs
  /grill-with-docs      Architecture decisions that meet the ADR threshold
  /reorient             Strategic course correction, axis audit, re-prioritize
  /learn                Trade-off exploration with options, terms, quiz
  /prototype            Quick validation mockup
  /diagnose             Debug a specific issue
  /grill-me             Open-ended interview on any plan or decision
```

## Two-Layer Model

The skill family operates at two layers:

**Project layer** (multi-session work): `/project-setup` + a workflow skill (`/migrate`, `/buildout`, or `/create`) + `/check-in`. Each workflow writes an Active Workflow record to CLAUDE.md so /check-in knows the context without guessing.

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
Verb reports complete, suggests /wrapup
  -> /wrapup resolves flags, cascades to shared docs
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

### AskUserQuestion Gates
Decision gates use `AskUserQuestion` to confirm non-trivial choices before the agent elaborates or implements. Two behavioral conventions apply to all gates:

**Conversational fallback:** If the user selects "Other" and writes something conversational, the agent drops back to chat - explains trade-offs, discusses, then re-presents the original AskUserQuestion when the user is ready. The gate stays pending until explicitly answered.

**Learn-mode elaboration:** If the user asks for more context or says "explain," the agent gives /learn-style depth scoped to the specific decision: one terms block (3-5 terms max), one further reading link. After elaboration, re-present the original question. Don't elaborate all options - only the ones the user asks about. This is "/learn lite," not the full Phase 2 flow.

These are behavioral conventions, not additional AskUserQuestion options. They keep gates from feeling like locked doors while preserving their value as decision records.

### Review Agent Allocation
See `port/REFERENCES.md > Review Depth` for the complexity classification and reviewer model assignment.

### Doc Sync
/wrapup is the single reconciliation point for all doc updates after implementation. It resolves flags left by implementation verbs, cascades changes to shared docs (CONVENTIONS.md, CONTEXT.md, DESIGN-SYSTEM.md), and evaluates gate criteria. See `wrapup/SKILL.md` for the full process.

### Project Intake (buildout only)
Composable archetypes via multiSelect AskUserQuestion, stored as SCOPE.md frontmatter:
- **Product** - multiple features, multiple user types, ongoing lifecycle
- **Feature** - multi-screen feature within an existing product
- **Deliverable** - report, tool, integration with clear scope
- **Design system** - design language work (tokens, patterns, density)

Archetypes are composable (a project can be both "product" and "design-system"). The selection determines which phase sections are active, which enforcement rules fire, and which docs get created.

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

## Local Documentation

`docs/local/` is the gitignored working state that tracks what's happening right now - questions, assumptions, audits, handoffs, and learning artifacts.
Canonical reference: [project-setup/LOCAL-DOCS.md](project-setup/LOCAL-DOCS.md) (file list, formats, scaling rules, ownership).
