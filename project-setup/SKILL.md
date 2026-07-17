---
name: project-setup
description: Structured project kickoff with scoping grill, architecture decisions, documentation structure, and CLAUDE.md generation. Use at project start, when setting up a new repo, or when foundational decisions are missing.
disable-model-invocation: true
---

# Project Setup

Establishes the foundation every project needs before building starts.
Framework-agnostic. Produces documentation structure, architecture decisions, spec templates, and process definition.

## Orientation (print this on every invocation)

Before doing any work, print a compact orientation block so the user knows what this skill does and how it connects to the family:

```
/project-setup - You are here. Scoping, architecture, docs structure, CLAUDE.md.
  Phase 0: Scope grill -> SCOPE.md, DEPENDENCIES.md, ASSUMPTIONS.md, CONTEXT.md
  Phase 1: Architecture -> ADRs (via /grill-with-docs), spec templates, CLAUDE.md generation
  Outputs: the foundation that /migrate, /spec, and /reorient build on.

Related skills:
  /migrate     - Extends this with migration-specific phases (docs sprint, vertical slice,
                 buildout, integration, parity validation, design pass, cutover)
  /spec        - Feature-level requirements (invoke anytime during a project's life)
  /grill-with-docs - Architecture decisions as ADRs, domain term sharpening
  /reorient    - Strategic checkpoint between phases or when feeling scattered
  /learn       - Trade-off exploration when multiple approaches exist
```

Then state which phase you are about to work on and why.

## How this skill works

1. Detect what already exists (SCOPE.md, CONTEXT.md, CLAUDE.md, docs/ tree).
2. Skip phases whose outputs already exist - don't re-grill settled decisions.
3. For missing pieces: run the relevant phase.
4. Delegates to other skills: `/grill-with-docs` for architecture decisions (ADRs), `/reorient` for strategic checkpoints.

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
