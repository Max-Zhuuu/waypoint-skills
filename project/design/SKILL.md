---
name: design
description: "Create and evolve a design system through three waves: Soul, Tokens, Proof. Prototypes to validate each wave."
status: stable
metadata:
  hermes:
    tags: [design-system, tokens, visual-design, interaction-design]
    category: project
  status: stable
---

Does NOT write component code. Produces design tokens and system specs.

Design system coordinator.
Routes to the right wave based on project state, tracks cross-wave concerns, and manages the design document family.

Each wave is a separate document with its own instructions:
- [WAVE-1-SOUL.md](WAVE-1-SOUL.md) - find the product's design identity
- [WAVE-2-TOKENS.md](WAVE-2-TOKENS.md) - distill the soul into a finite token system
- [WAVE-3-PROOF.md](WAVE-3-PROOF.md) - stress-test the tokens on real screens

Other skills consume the outputs: /prototype for visual exploration, /spec for component specs, /tdd and /create for implementation.

## Context gate

This skill requires project context. Before proceeding, check for:

1. `SCOPE.md` - what the product is, its boundaries
2. `GLOSSARY.md` - domain glossary
3. `conventions/NAMING.md` - naming patterns
4. Business logic docs (resolve via Documentation Map: features/, legacy reference/)
5. Existing styles (`styles/tokens.css` or equivalent)
6. Existing `docs/program/DESIGN.md` (if present)
7. Legacy/reference system source (if migrating)

Design output: `docs/program/DESIGN.md` - visual conventions, tokens, spacing, density.
This file is optional. /design creates it when the project warrants a design system doc.

If SCOPE.md is missing and no equivalent context exists, hard-stop:
"I need to understand what this product does before I can design for it. Answer these questions or run /setup first."

Then ask:
1. What does this product do in one sentence?
2. Who uses it and how often? (Daily tool vs. occasional visit)
3. What's the information density? (Dashboard-dense, form-heavy, content-light)
4. Is there a system being replaced? What does it look like?
5. What's the team size consuming these design decisions?

If the user provides enough inline context without SCOPE.md, proceed. The gate is on understanding, not on file existence.


Check for existing design artifacts:

| File exists | Mode | Action |
|------------|------|--------|
| Nothing in `docs/design/` | **Greenfield** | Enter wave 1 |
| `docs/design/DESIGN-BRIEF.md` only | **Resume mid-soul** | Report state, offer wave 1 continue or wave 2 entry |
| `docs/design/DESIGN-BRIEF.md` + `docs/design/system/TOKEN-RATIONALE.md` | **Resume mid-tokens** | Report state, offer wave 2 continue or wave 3 entry |
| `docs/design/system/COMPONENT-SPECS.md` exists | **Resume mid-proof** | Report state, offer wave 3 continue or evolve |
| `styles/tokens.css` exists but no `docs/design/` | **Retrofit** | Extract implicit decisions, then enter wave 1 or 2 |
| Design system complete, user describes new surface | **Evolve** | Ask: "Extend existing brief or revisit foundations?" |

### Resume detection

If design docs exist, read them and report:

```
Design system status:
- Brief: {exists/missing} {one-line summary if exists}
- Decisions: {N} settled, {N} active, {N} archived
- Design language: {N} terms defined
- Token rationale: {exists/missing}
- Interaction states: {exists/missing}
- Component specs: {exists/missing}
- Unified document: {exists/missing}

Last wave activity: {wave N, topic}
Continue from here, revisit an earlier decision, or jump to wave {next}?
```

### Retrofit detection

If code artifacts exist (tokens.css, component styles) but no design docs:

1. Read the existing token/style files
2. Extract implicit decisions: "Your tokens.css tells me you've already decided on 4px spacing base, compact density, and a blue-gray neutral palette."
3. Present the extracted brief: "Here's what your code says about your design system. Is this intentional or accidental?"
4. User validates or corrects
5. Document validated decisions in DESIGN-DECISIONS.md
6. Show gaps: "You have spacing and layout tokens but no semantic color roles, no type scale rationale, no motion philosophy, no interaction state definitions."
7. Route to the appropriate wave based on what's missing

### Wave entry

After detecting mode, read the appropriate wave document and follow its instructions.
Each wave document is self-contained - it has its own steps, prototyping triggers, and output checklist.

Between waves, checkpoint: "Wave {N} complete. {summary}. Ready for wave {N+1}, or revisit anything?"

## Prototyping philosophy

Prototype eagerly, not on request. Each wave has specific prototype triggers documented in its instructions.
Invoke `/prototype` directly, passing the relevant design docs as context.
Don't ask "would you like to see this?" - build it and show it.
The prototype validates the decision; the user reacts to what they see, not what they imagine.

## Fixation detection

Watch for the user spending disproportionate time on one detail.
If a single topic (typography, one color value, one component) spans 3+ exchanges without resolution:

Don't gate or time-limit. Instead, show connections:
"You've been refining the table header typography. The spacing scale and row density connect directly to this - want to zoom out and see how they interact? Sometimes the header problem is actually a density problem."

The goal is redirecting by showing the bigger picture, not cutting off exploration.

## Skill handoffs

/design does not build. When the work shifts to building:

- **Visual exploration needed** -> invoke `/prototype` with the brief as context. Don't suggest - do it.
- **Component needs speccing** -> "The data table pattern needs a full spec. `/spec` with token constraints from DESIGN-DECISIONS.md?"
- **Ready to implement** -> "Token system is proven. `/tdd` for the token infrastructure, `/create` for component implementation?"
- **Something feels off** -> Update RESEARCH.md with a new investigation. Include the sector reference or design vibe so the implementer can look at it themselves and get fresh perspective.

Pass the relevant design docs as context to the invoked skill.

## Rules

- Every vague aesthetic term gets pinned to a specific, reusable name. No ambiguity survives a session. See [REFERENCES.md](REFERENCES.md) for the vague-term resolution table.
- Every departure from the brief gets the indulgence gate question. State the question; don't sneak changes through.
- Both themes (light and dark) get equal care. Never invert naively.
- Density is a first-class decision made early, not a mode toggle added later.
- When something doesn't feel right, investigate with competitive research. Flag explicitly with a reference the implementer can go look at.
- Archive discarded directions in `docs/design/archive/`. Never delete - the "can we bring back X" question is always valid.
- Log new vague-term resolutions to `docs/design/TERM-LOG.md` for skill evolution.

## Document family

| Document | Written by | Purpose |
|----------|-----------|---------|
| `docs/design/DESIGN-BRIEF.md` | Wave 1 | Product verb, emotional range, density, chosen direction |
| `docs/design/DESIGN-DECISIONS.md` | All waves | Living tracker of design decisions + Design Language section |
| `docs/design/RESEARCH.md` | Wave 1, updated anytime | Competitive audit findings, reference investigations |
| `docs/design/TERM-LOG.md` | All waves | New vague-term resolutions for skill evolution |
| `docs/design/system/TOKEN-RATIONALE.md` | Wave 2 | Why each token value, not just what it is |
| `docs/design/system/INTERACTION-STATES.md` | Wave 2 | State matrix: entity states x UI states x compounds |
| `docs/design/system/COMPONENT-SPECS.md` | Wave 3 | Extracted component patterns with token usage |
| `docs/design/system/DESIGN-SYSTEM.md` | Wave 3 | Unified shareholder-readable document |
| `docs/design/archive/` | Any wave | Discarded directions, superseded decisions |

When concerns exist relating to visual consistency, interaction patterns, or design drift, surface them before starting new work.

## Tone

Principled. Every token choice traces to a product decision.

## Exit

- /prototype to validate decisions visually.
- /create to implement tokens in code.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: design decisions, design brief, token rationale
Writes: docs/design/ directory tree
Override: requires SCOPE.md or equivalent project context. At Tier 1, prompts user for minimal context (product verb, density, primary task) inline rather than hard-gating. This is the only skill that gates on project context - see rationale in DESIGN-DECISIONS.md.
