# Waypoint Skills

A skill family for building software products with AI agents.
Two layers: invoke a verb for single-session work, or set up a project for multi-session continuity.

## Getting Started

Install the plugin, then invoke any skill directly - no setup required.

```bash
npx claude-plugins install waypoint-skills
```

**Task layer** (single-session work): invoke a verb and go.

```
/tdd CreateVessel         # test-driven build
/spec VesselParticulars   # grill requirements, output spec
/diagnose flaky-test      # disciplined debug loop
```

**Project layer** (multi-session work): run /project-setup once, pick a workflow, then /check-in each session.

```
/project-setup            # architecture, docs, CLAUDE.md, conventions
/migrate                  # or /buildout, or /create
/check-in                 # every session after that
```

/project-setup creates a Documentation Map in CLAUDE.md - a table mapping logical concepts to physical file paths.
Skills resolve references through the map, never hardcoded paths.
The structure scales with project size (None/Small/Moderate/Large tiers), and /project-setup can be re-run to change tiers without losing decisions.

`docs/local/` is the gitignored working state for questions, assumptions, audits, and handoffs.
See [LOCAL-DOCS-REFERENCE.md](project-setup/LOCAL-DOCS-REFERENCE.md) for structure and scaling rules.

## Design Keywords

Four properties that shape how every skill in the family behaves:

- **Memoized** - decisions persist in CLAUDE.md. Re-running /project-setup doesn't re-ask answered questions. /check-in records what it resolved and when. Concurrent sessions don't re-resolve what another session already handled.
- **Reentrant** - /project-setup can be re-run at any time. It reads current state, detects what exists, and only asks about what's new or changed. Tier transitions, convention upgrades, and workflow changes are all re-entry, not fresh setup.
- **Self-healing** - when a referenced file is deleted, moved, or becomes stale, the system detects the inconsistency. /check-in flags Documentation Map entries pointing to missing files. Scope creep across concurrent sessions triggers /reorient suggestions.
- **Bias to action** - when the answer is inferrable from the codebase, existing docs, or conventions, act on it and propose the result. AskUserQuestion is reserved for genuinely ambiguous forks where both paths are reasonable and the wrong choice wastes significant work. Skills should just work.

### Decision gates

When a skill does use AskUserQuestion, two behavioral conventions apply:

**Conversational fallback:** if the user selects "Other" and writes something conversational, the agent drops back to chat - explains trade-offs, discusses, then re-presents the original question when the user is ready.
The gate stays pending until explicitly answered.

**Learn-mode elaboration:** if the user asks for more context, the agent gives /learn-style depth scoped to the specific decision: one terms block (3-5 terms max), one further reading pointer.
After elaboration, re-present the original question.

## Two-Layer Model

**Project layer** (multi-session work): `/project-setup` + a workflow (`/migrate`, `/buildout`, or `/create`) + `/check-in`.
Each workflow writes an Active Workflow record to CLAUDE.md so /check-in knows the context without guessing.

**Task layer** (single-session work): `/tdd`, `/port`, `/spec`, `/prototype`, `/diagnose`, `/grill-me`, `/learn`, `/grill-with-docs`, `/improve-codebase-architecture`.
Self-contained verbs that work without project setup.
Missing scaffolding degrades gracefully: no domain term cross-referencing without CONTEXT.md, no convention enforcement without CONVENTIONS.md, but core skill loops always work.

Boundary: if you need to track progress across sessions, you need the project layer.

## Skill Map

### User-invoked

```
PROJECT SETUP
  /project-setup          Foundation: architecture, docs, CLAUDE.md, conventions

WORKFLOWS (pick one)
  /migrate                Replace an existing system layer by layer
  /buildout               Build a new product from scratch
  /create                 Add features to an existing codebase

SESSION
  /check-in               Orient, propose next task, fire checkpoints

IMPLEMENTATION
  /tdd                    Test-driven: define behavior, test first, build to satisfy
  /port                   Migration: capture current behavior, replicate, verify parity

SUPPORTING
  /spec                   Grill requirements, output spec file
  /wrapup                 Resolve flags, spec drift check, cascade to shared docs
  /grill-with-docs        Architecture decisions that meet the ADR threshold
  /reorient               Strategic course correction, axis audit, re-prioritize
  /learn                  Trade-off exploration with options, terms, quiz
  /prototype              Quick validation mockup
  /diagnose               Disciplined debug loop for hard bugs
  /grill-me               Open-ended interview on any plan or decision
  /improve-codebase-architecture  Surface architectural friction, propose deepening
```

### Model-invoked

```
  chrome-devtools-axi     Browser automation via Chrome DevTools
  find-skills             Skill discovery and installation from the ecosystem
```

## Session Flows

### Task session

```
                    invoke verb directly
                           |
                           v
              +-----------------------+
              |  /tdd, /spec, /port,  |
              |  /diagnose, /proto... |
              +-----------------------+
                           |
                           v
                   verb completes
                           |
                 +---------+---------+
                 |                   |
           done (exit)        /wrapup (optional)
                                     |
                                     v
                            doc sync, flag resolution
```

### Project session

```
          /check-in
               |
               v
    +---------------------+
    | read Active Workflow |
    | read phase files     |
    | read ACTIVE-WORK.md  |
    +---------------------+
               |
       +-------+-------+
       |               |
  drift detected    propose task
       |               |
       v               v
  /reorient     pre-build checkpoint
       |         (verify spec, load refs)
       v               |
  re-prioritize        v
       |         /port or /tdd
       v               |
  resume here          v
                 verb completes
                       |
                       v
                 post-build checkpoint
                 (review, doc sync, inventory)
                       |
                       v
                 suggest /wrapup
                       |
                       v
                 propose next task or
                 flag stale questions
```

## Glossary

**Active Workflow** - record in CLAUDE.md written by /migrate, /buildout, or /create.
Contains skill name, activation date, scope, and status.
/check-in reads it to orient each session.

**Checkpoint** - named block inside phase files with four fields: trigger (when it fires), references (files to validate against), action (what to do), pass condition (what "done" looks like).
Distinct from gates (end-of-phase go/no-go) and enforcement (per-invocation checks in SKILL.md).

**Documentation Map** - table in CLAUDE.md mapping logical concepts (e.g., "Naming conventions") to physical file paths.
Skills resolve references through the map.
When an entry points to a missing file, /check-in flags it (self-healing).

**Naming classes** - suffix taxonomy for skill-internal files:
`FOO.md` (user-facing project doc), `FOO-REFERENCE.md` (skill-internal reference), `FOO-FORMAT.md` (format template).

**Resolution cascade** - when a checkpoint finds a mismatch: (1) read the authoritative source for ground truth, (2) write or run a test that proves which side is correct, (3) escalate to the user with specifics if source and tests are ambiguous.

**Single-writer discipline** - only /wrapup writes to shared docs (CONVENTIONS.md, CONTEXT.md, DESIGN-SYSTEM.md).
Other skills create only their own output artifacts.

See [CONCEPTS-REFERENCE.md](CONCEPTS-REFERENCE.md) for extended definitions and examples.

## Phase Overview

Phase systems belong to the project layer.
Task-layer skills have no phases.

### Migration (/migrate)

| Phase | Name | Verb | Key Checkpoint |
|-------|------|------|----------------|
| 0-1 | Setup | /project-setup + /migrate | - |
| 2 | Documentation Sprint | manual | Gate: every entity spec'd |
| 3 | Vertical Slice | /port | Pre-build spec check, post-slice architecture grill |
| 4 | Horizontal Buildout | /port | Pre-build spec prerequisite, post-build review + doc sync |
| 5 | Integration | /port | Pre-wire dependency + shape check, post-wire review |
| 6a | Functional Validation | manual | Post-validation review per screen |
| 6b | Design System + UX | /prototype | See migrate/REFERENCES.md for design phase details |
| 7 | Cutover | manual | Ship checklist |

### Buildout (/buildout)

| Phase | Name | Verb | Key Checkpoint |
|-------|------|------|----------------|
| 0-1 | Setup | /project-setup + /buildout | Project intake |
| 2 | Discovery & Validation | /spec | Gate: persona, MoSCoW, specs |
| 3 | MVP Build | /tdd | Pre-build spec check, post-slice architecture grill |
| 4 | Iterate & Ship | /tdd | Pre-build for new Must, design consolidation |
| - | Design System | - | After Phase 3 gate; see buildout/REFERENCES.md |
