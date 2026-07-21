---
name: spec
description: Feature-level requirements skill. Grills on scope and acceptance criteria, outputs a spec file. Use when starting a new feature, when requirements are vague, or when the user says "spec this", "write a spec", "PRD".
---

# Spec

Follow the requirements methodology in [process/requirements.md](../process/requirements.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read any existing context first: SCOPE.md, CONTEXT.md, ARCHITECTURE.md, related specs in `docs/specs/`.

Grill inline. Print questions with your recommended answer so the user can challenge.
Do not use `AskUserQuestion` for the grilling loop - inline conversation lets the user redirect naturally.

If scaffolding is missing, follow [ENGAGEMENT-REFERENCE.md](../ENGAGEMENT-REFERENCE.md).

### Phase 2 - Acceptance criteria

Present options where trade-offs exist, per the methodology.
Mark the recommendation and state why. The user picks or challenges.

### Phase 3 - Write the spec

Output to `docs/specs/{feature-slug}.md` using the template from the methodology.

### Phase 4 - Update shared artifacts

1. New domain terms -> update CONTEXT.md (domain terms only, not general programming concepts).
2. Architecture decision -> suggest invoking `/grill-with-docs` for an ADR.
3. Feature tracked in an inventory or roadmap -> add it.

## Tone

Concise. A spec is a contract, not a narrative.
Every sentence should either constrain scope or define behavior.
If a sentence does neither, cut it.
