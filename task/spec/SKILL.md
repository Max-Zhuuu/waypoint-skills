---
name: spec
description: Feature-level requirements skill. Grills on scope and acceptance criteria, outputs a spec file. Use when starting a new feature, when requirements are vague, or when the user says "spec this", "write a spec", "PRD".
status: stable
---

# Spec

Follow the requirements methodology in [process/requirements.md](../../process/requirements.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read any existing context first: SCOPE.md, CONTEXT.md, ARCHITECTURE.md, related specs in `docs/specs/`.

Grill inline. Print questions with your recommended answer so the user can challenge.
Do not use `AskUserQuestion` for the grilling loop - inline conversation lets the user redirect naturally.

### Phase 2 - Acceptance criteria

Present options where trade-offs exist, per the methodology.
Mark the recommendation and state why. The user picks or challenges.

### Phase 3 - Write the spec

Output to Documentation Map "Feature specs" path or `docs/specs/{feature-slug}.md`.
Use template from Documentation Map "Feature reference" `_TEMPLATE.md` if it exists, otherwise [../../templates/feature-spec.md](../../templates/feature-spec.md).

### Phase 4 - Update shared artifacts

1. New domain terms -> update CONTEXT.md (domain terms only, not general programming concepts).
2. Architecture decision -> suggest invoking `/grill-with-docs` for an ADR.
3. Feature tracked in an inventory or roadmap -> add it.

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** concerns (type: question, assumption)
- **Scaffolding writes:** none (task-layer skill)
- **Override:** none
- **Nudge protocol:** detect tier -> suggest setup/upgrade once -> back off if declined
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no file creation outside owned paths, no silent scaffolding, no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

## Exit

After the spec is written:
- "Spec written. /breakdown to decompose into slices, or /tdd to build directly?"

## Tone

Concise. A spec is a contract, not a narrative.
Every sentence should either constrain scope or define behavior.
If a sentence does neither, cut it.
