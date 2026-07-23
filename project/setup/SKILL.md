---
name: setup
description: Structured project kickoff with scoping grill, architecture decisions, documentation structure, and CLAUDE.md generation. Use at project start, when setting up a new repo, or when foundational decisions are missing.
status: stable
---

# Project Setup

Establishes the foundation every project needs before building starts.
Framework-agnostic. Produces documentation structure, architecture decisions, spec templates, and process definition.

## On invocation

Check for existing outputs: SCOPE.md, GLOSSARY.md, CLAUDE.md, docs/ tree.

**Starting fresh** (none exist): print this, then start Phase 0.

```
Setting up project foundation. Two phases:
  1. Scope grill - what you're building, what you're not, what you need from others
  2. Architecture & standards - decisions, docs structure, CLAUDE.md

Let's start with scope.
```

**Resuming** (some exist, some missing): list what's done and what's missing, then pick up at the first incomplete phase.

```
Found: {list existing outputs}
Missing: {list missing outputs}

Picking up at {phase}.
```

**Restructuring** (user explicitly asks to restructure, or docs exist but don't follow the three-tier layout): read the current Documentation Map from CLAUDE.md, classify each file by tier, and propose moves.

### File classification rules

Classify every doc file by asking: "Does this describe what the system IS, or what we're DOING to it?"

**program/** - what the system IS (changes rarely):
- Architecture, stack decisions, data flow diagrams
- Test policy and expectations
- Naming conventions, UX conventions, design tokens
- ADRs (architecture decision records)
- Feature docs for the TARGET system being built
- Design system docs (DESIGN.md)

**program-legacy-{source}/** - source system reference (migration projects):
- Feature specs FROM the source system (WPF screens, Rails views, etc.)
- Logic docs, business rules extracted from source
- Plugin inventories, entity catalogs from the source system
- Templates for documenting the source system

**implementation/** - what we're DOING (changes often):
- Scope (in/out/uncertain)
- Concerns (questions, assumptions, issues, milestones)
- Feature specs for work IN PROGRESS (specs/)
- Migration trackers, progress trackers (PAGES.md, FE-UPDATES.md)
- Handoffs, cross-team contracts
- Improvement proposals (deferred ideas)
- Backend integration notes, endpoint specs
- Archive of superseded docs

**local/** - working state (gitignored):
- Session notes, investigations, scratch
- Learning exercises

### Content merge rules

Not every file is a simple move. When restructuring, check for:
- **Merge candidates**: small files (<60 lines) whose content is a natural section of a larger doc. Example: DEPENDENCIES.md becomes `## External Dependencies` in ARCHITECTURE.md.
- **Split candidates**: files covering multiple concerns. Example: CONVENTIONS.md splits into conventions/NAMING.md + conventions/UX.md.
- **Distribute candidates**: directories where files belong in different tiers. Example: design/ may have system-level design rules (program/DESIGN.md), API design docs (program/), and exploration files (implementation/improvements/ui/).
- **Delete candidates**: files replaced by the Documentation Map or by other structural changes. Example: docs/README.md that just lists what's in docs/.

### Restructure flow

```
Current layout doesn't match the program/implementation/local structure.

Classification:
  program/:      ARCHITECTURE.md, TESTING.md, adr/, NAMING.md
  legacy-wpf/:   wpf-reference/*, inventory-plugins.md
  implementation/: SCOPE.md, PAGES.md, specs/, improvements/
  merge:         DEPENDENCIES.md -> ARCHITECTURE.md section
  split:         CONVENTIONS.md -> conventions/NAMING.md + UX.md
  delete:        docs/README.md (Documentation Map replaces it)

Proposed moves:
  git mv docs/wpf-reference/ docs/program-legacy-wpf/
  git mv TESTING.md docs/program/TESTING.md
  ...
{N} moves total. Execute, or adjust?
```

Use `git mv` for all moves to preserve history. Create directories first, move in dependency order. After moves, rewrite the Documentation Map in CLAUDE.md to match new paths.

**Reviewing** (all exist): activate the resume path. Read [RESUME-PATH.md](RESUME-PATH.md) and follow its instructions.
The resume path lets the user review and revise project decisions without re-running setup from scratch.

After the starting-fresh block, add one line:

```
Related: /spec (feature specs), /grill-with-docs (architecture decisions), /reorient (checkpoint)
```

## On completion

After Phase 1 gate passes, print an adaptive completion message. Read SCOPE.md and the Phase 0 conversation to determine which template to use.

**If a source system was identified** (SCOPE.md repositories section mentions an existing system, or scope describes replacing/migrating from something):

```
Setup complete. You described migrating from {system name}.
  -> /migrate - sets up parity tracking, spec extraction from the source,
     and a phased plan to replace it layer by layer

Other options:
  -> /create  - add specific features without the full migration workflow
  -> /buildout - structure a new product with prioritized features and
     an MVP-first build cycle

Next session: run /check-in to orient and pick up where you left off.
```

**If no source system was identified:**

```
Setup complete. Ready to start building.
  -> /buildout - structures the work into prioritized features, builds
     an MVP first, then iterates with user feedback
  -> /create  - add a feature or small batch of features with light
     structure (spec, build, wrapup - no phases or inventory)

If you're replacing an existing system, /migrate sets up parity tracking
and phased replacement instead.

Next session: run /check-in to orient and pick up where you left off.
```

## Phase 0 - Discovery & Scoping

**Goal:** know what you are building, what you are not, and what you need from others.

### Grill the implementer

Print questions inline with your recommended answer. Do not use `AskUserQuestion` - inline options make it easier for the implementer to challenge back.

Work through these categories. Skip any the implementer has already answered clearly.

**Product:**
- What problem does this solve? For whom?
- What does "done" look like in 2 sentences?

**Scope:**
- What is IN? (core features, must-have screens/workflows)
- What is OUT? (explicitly excluded, deferred, or someone else's problem)
- What is UNCERTAIN? For each: who decides, by when?

**Dependencies:**
- Backend API: exists (fully/partially/not at all), who builds it, contract format, delivery timeline
- Design assets: mockups, design system, brand guidelines - available or TBD?
- Infrastructure: hosting, CI/CD, environments
- Domain expertise: who knows the business rules? Are they available?

**Constraints:**
- Compliance/standards that apply (SOC II, ISO 27001, WCAG 2.1 AA, GDPR, other)
- Performance requirements
- Browser/device support
- Timeline and milestones

**Risks:**
- What worries you most?
- What domain knowledge exists only in people's heads?

### Outputs

**SCOPE.md** - read [../../templates/SCOPE.md](../../templates/SCOPE.md), populate from grill answers.

**CONCERNS.md** (docs/implementation/, tracked) - read [../../templates/CONCERNS.md](../../templates/CONCERNS.md), seed with assumptions and open questions from scoping. Format: see [../../CONCERNS-FORMAT.md](../../CONCERNS-FORMAT.md).

For moderate-to-large projects, offer a concern type mini-grill:
```
Which concern types does this project need?
[x] question - decisions needed
[x] assumption - theories to validate
[x] issue - things that look wrong
[ ] milestone - checkpoints grouping specs and handoffs
```

**GLOSSARY.md** (docs/, if not exists) - read [../../templates/GLOSSARY.md](../../templates/GLOSSARY.md), seed with domain terms from scoping. Follow existing GLOSSARY-FORMAT if `/grill-with-docs` format file exists.

### Gate

- [ ] SCOPE.md exists and implementer has reviewed it
- [ ] External dependencies identified (in ARCHITECTURE.md or noted for later)
- [ ] Uncertain scope items have decision owners and validate-by dates
- [ ] GLOSSARY.md exists (even if minimal)
- [ ] CONCERNS.md seeded with assumptions and open questions from scoping

## Tier selection

After Phase 0 scoping, determine the project tier conversationally.
Read [SCOPE-REFERENCE.md](SCOPE-REFERENCE.md) to explain options if the user asks.

| Tier | When | Scaffolding |
|------|------|-------------|
| Small | Solo dev, few features, low ceremony | CLAUDE.md + basic SCOPE.md |
| Moderate | Standard project, team, conventions needed | Full flat files at root |
| Large | Complex domain, multiple teams, extensive conventions | conventions/ folder + full docs tree |

Record the tier in CLAUDE.md's Project Scaffold section:

```markdown
## Project Scaffold

| Field | Value |
|-------|-------|
| Tier | Moderate |
| Setup date | {date} |
| Last re-entry | {date} |
| Last check-in | - |
```

Tier can be changed by re-running /setup (reentrant).

## Documentation Map

After scaffolding, write the Documentation Map to CLAUDE.md.
Tree format with bold markers (**) for key docs. Skills resolve through this map, never hardcoded paths.

```markdown
## Documentation Map

docs/
  **GLOSSARY.md**                # Domain glossary - canonical terms, avoid-lists
  program/                       # What the system IS
    **ARCHITECTURE.md**          # Stack, state management, data flow, deps
    **TESTING.md**               # Test expectations by complexity tier
    conventions/
      **NAMING.md**              # Variables, functions, components
      UX.md                      # Interaction patterns, confirmations
    adr/                         # Architecture decision records
  implementation/                # What we're DOING
    **SCOPE.md**                 # In/out/uncertain
    **CONCERNS.md**              # Questions, assumptions, issues, milestones
    specs/                       # Feature specs (flat, active)
  local/                         # Gitignored working state
```

Tier-dependent: small projects may flatten (SCOPE.md at root, no program/ directory).
Large projects add: program/STRUCTURE.md, program/DESIGN.md, program/features/, program-legacy-{source}/, implementation/handoffs/, implementation/improvements/.

On re-entry, read the existing map and only update entries that changed. Don't regenerate from scratch.
As scope scales, nudge the user to add entries for new doc areas (e.g., "You have 5 specs now - worth adding a specs/ entry to the map?").

### Skill State directory

Create `.claude/` if it doesn't exist. This directory holds skill-internal state files (marker files, setup state).
Map-resolvable through the "Skill state" concept in the Documentation Map.

## Phase 1 - Architecture & Standards

**Goal:** every decision that affects all screens/features is made once, before building.

Detailed instructions in [PHASE-1.md](PHASE-1.md). Read that file before proceeding with Phase 1.

### Gate

- [ ] Architecture decisions documented as ADRs in `docs/adr/` (via `/grill-with-docs`)
- [ ] Project skeleton runs (dev server + tests)
- [ ] Documentation structure created with spec templates
- [ ] CLAUDE.md with Project Scaffold + Documentation Map sections
- [ ] ARCHITECTURE.md summary exists

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** concerns (type: assumption, question)
- **Scaffolding writes:** CLAUDE.md, SCOPE.md, CONVENTIONS.md, TESTING.md, ARCHITECTURE.md, .claude/ directory
- **Override:** this is the scaffolding creator - it creates the files other skills read. No tier detection needed (setup IS how you reach Tier 2).
- **Nudge protocol:** not applicable (setup is the setup)
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no silent scaffolding (always confirm with user), no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

## Tone

Direct. This skill produces the foundation everything else builds on.
Cut scope aggressively in Phase 0 - it is cheaper to add later than to remove.
Challenge vague answers: "all users" is not a user, "fast" is not a requirement.
