---
name: setup
description: "Kickoff a project with scoping grill, architecture decisions, and documentation structure. Use at project start."
status: stable
---

Does NOT build features. Creates project scaffolding and foundational decisions.
Framework-agnostic. Produces documentation structure, architecture decisions, spec templates, and process definition.

Check for existing outputs: SCOPE.md, GLOSSARY.md, CLAUDE.md, docs/ tree.

**Starting fresh** (none exist): announce two phases (scope grill, then architecture & standards), start Phase 0. After the opening block, add: `Related: /spec, /grill-with-docs, /reorient`

**Resuming** (some exist, some missing): list done/missing, pick up at first incomplete phase.

**Restructuring** (user explicitly asks, or docs don't follow three-tier layout): read [reference/restructuring.md](reference/restructuring.md) and follow its instructions.

**Reviewing** (all exist): read [reference/resume-path.md](reference/resume-path.md) and follow its instructions.

## On completion

After Phase 1 gate passes, read [reference/completion.md](reference/completion.md) for the adaptive completion message template.

## Phase 0 - Discovery & Scoping

**Goal:** know what you are building, what you are not, and what you need from others.

### Grill the implementer

Print questions inline with your recommended answer. Do not use `AskUserQuestion`. Skip any already answered.

**Product:** What problem does this solve? For whom? What does "done" look like in 2 sentences?

**Scope:** What is IN? What is OUT? What is UNCERTAIN? For each uncertain item: who decides, by when?

**Dependencies:** Backend API (exists fully/partially/not at all, who builds, contract, timeline). Design assets (mockups, design system, brand). Infrastructure (hosting, CI/CD, environments). Domain expertise (who knows the rules, availability).

**Constraints:** Compliance (SOC II, ISO 27001, WCAG 2.1 AA, GDPR). Performance requirements. Browser/device support. Timeline and milestones.

**Risks:** What worries you most? What domain knowledge exists only in people's heads?

### Outputs

**SCOPE.md** - read [../../templates/SCOPE.md](../../templates/SCOPE.md), populate from grill answers.

**CONCERNS.md** (docs/implementation/) - read [../../templates/CONCERNS.md](../../templates/CONCERNS.md), seed with assumptions and open questions. Format: [../../CONCERNS-FORMAT.md](../../CONCERNS-FORMAT.md). For moderate-to-large projects, offer concern type mini-grill (question, assumption, issue, milestone).

**_GLOSSARY.md** (docs/) - read [../../templates/_GLOSSARY.md](../../templates/_GLOSSARY.md), seed with domain terms from scoping.

### Gate

- [ ] SCOPE.md exists and implementer has reviewed it
- [ ] External dependencies identified
- [ ] Uncertain scope items have decision owners and validate-by dates
- [ ] GLOSSARY.md exists (even if minimal)
- [ ] CONCERNS.md seeded with assumptions and open questions

## Tier selection

After Phase 0, determine project tier conversationally. Read [reference/scope-tiers.md](reference/scope-tiers.md) to explain options if asked.

| Tier | When | Scaffolding |
|------|------|-------------|
| Small | Solo dev, few features, low ceremony | CLAUDE.md + basic SCOPE.md |
| Moderate | Standard project, team, conventions needed | Full flat files at root |
| Large | Complex domain, multiple teams | conventions/ folder + full docs tree |

Record tier in CLAUDE.md's Project Scaffold section. Tier can be changed by re-running /setup.

## Documentation Map

Read [reference/doc-map.md](reference/doc-map.md) before generating. Create `.claude/` for skill-internal state files if it doesn't exist.

## Phase 1 - Architecture & Standards

**Goal:** every decision that affects all screens/features is made once, before building.

Read [phases/phase-1.md](phases/phase-1.md) before proceeding.

### Gate

- [ ] Architecture decisions documented as ADRs in `docs/adr/`
- [ ] Project skeleton runs (dev server + tests)
- [ ] Documentation structure created with spec templates
- [ ] CLAUDE.md with Project Scaffold + Documentation Map sections
- [ ] ARCHITECTURE.md summary exists

## Exit

- /check-in for first working session.
- /breakdown to decompose initial scope into slices.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: assumption, question)
Writes: CLAUDE.md, SCOPE.md, CONVENTIONS.md, TESTING.md, ARCHITECTURE.md, .claude/ directory
Override: scaffolding creator - creates the files other skills read. No tier detection needed.

## Tone
Direct. Cut scope aggressively in Phase 0 - cheaper to add later than remove. Challenge vague answers: "all users" is not a user, "fast" is not a requirement.
