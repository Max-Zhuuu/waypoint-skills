---
name: spec
description: Feature-level requirements skill. Grills on scope and acceptance criteria, outputs a spec file. Use when starting a new feature, when requirements are vague, or when the user says "spec this", "write a spec", "PRD".
---

# Spec

Follow the requirements methodology in @process/requirements.md.
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read any existing context first: SCOPE.md, GLOSSARY.md, ARCHITECTURE.md, related specs in `docs/specs/`.

Grill inline. Print questions with your recommended answer so the user can challenge.
Do not gate the conversation on structured prompts - inline back-and-forth lets the user redirect naturally.

If scaffolding docs are missing, proceed without them. They enhance cross-referencing but are not required.

### Phase 2 - Acceptance criteria

Present options where trade-offs exist.
Mark the recommendation and state why. The user picks or challenges.
OpenCode has no structured choice tool - present options conversationally and ask "Which approach do you prefer?"

### Phase 3 - Write the spec

Output to `docs/specs/{feature-slug}.md` using the template from the methodology.

### Phase 4 - Update shared artifacts

1. New domain terms -> update GLOSSARY.md (domain terms only, not general programming concepts).
2. Architecture decision -> suggest an ADR in `docs/adr/`.
3. Feature tracked in an inventory or roadmap -> add it.
4. Open questions or assumptions surfaced -> add to `docs/local/CONCERNS.md` if it exists.

## Tone

Concise. A spec is a contract, not a narrative.
Every sentence should either constrain scope or define behavior.
If a sentence does neither, cut it.
