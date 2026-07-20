---
name: project-setup
description: Structured project kickoff with scoping grill, architecture decisions, documentation structure, and CLAUDE.md generation. Use at project start, when setting up a new repo, or when foundational decisions are missing.
disable-model-invocation: true
---

# Project Setup

Establishes the foundation every project needs before building starts.
Framework-agnostic. Produces documentation structure, architecture decisions, spec templates, and process definition.

## On invocation

Check for existing outputs: SCOPE.md, CONTEXT.md, CLAUDE.md, docs/ tree.

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
     and a phased plan to replace it screen by screen
  -> or invoke /spec, /tdd, /port directly if you already know what to build

If this isn't a migration, /buildout structures a fresh product with
prioritized features and an MVP-first build cycle.

Next session: run /check-in to orient and pick up where you left off.
```

**If no source system was identified:**

```
Setup complete. Ready to start building.
  -> /buildout - structures the work into prioritized features, builds
     an MVP first, then iterates with user feedback
  -> or invoke /spec, /tdd directly if you already know what to build

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

**SCOPE.md** (docs root):
- One-paragraph summary
- In / out / uncertain table with decision owners
- Repositories section (active repos, what each does, how they relate)
- Constraints section (compliance, performance, browser support)
- "Done" in 2 sentences

**DEPENDENCIES.md** (docs root):
- Per dependency: what, status (available / promised by date / unknown), owner, resolution instructions for unknowns

**docs/local/ASSUMPTIONS.md** (gitignored):
- Per assumption: description, risk level (low/medium/high), resolution deadline, owner
- Optimistic planning is fine; invisible assumptions are not

**CONTEXT.md** (repo root, if not exists):
- Seed with domain terms that surfaced during scoping
- Follow existing CONTEXT-FORMAT if `/grill-with-docs` format file exists

### Gate

- [ ] SCOPE.md exists and implementer has reviewed it
- [ ] DEPENDENCIES.md has all external contracts identified
- [ ] Uncertain scope items have decision owners and deadlines
- [ ] CONTEXT.md exists (even if minimal)

## Phase 1 - Architecture & Standards

**Goal:** every decision that affects all screens/features is made once, before building.

Detailed instructions in [PHASE-1.md](PHASE-1.md). Read that file before proceeding with Phase 1.

### Gate

- [ ] Architecture decisions documented as ADRs in `docs/adr/` (via `/grill-with-docs`)
- [ ] Project skeleton runs (dev server + tests)
- [ ] Documentation structure created with spec templates
- [ ] CLAUDE.md process definition written
- [ ] ARCHITECTURE.md summary exists

## Tone

Direct. This skill produces the foundation everything else builds on.
Cut scope aggressively in Phase 0 - it is cheaper to add later than to remove.
Challenge vague answers: "all users" is not a user, "fast" is not a requirement.
