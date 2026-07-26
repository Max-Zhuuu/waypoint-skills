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

Design system coordinator.
Routes to the right wave based on project state, tracks cross-wave concerns, and manages the design document family.

Each wave is a separate document with its own instructions:
- [WAVE-1-SOUL.md](phases/wave-1-soul.md) - find the product's design identity
- [WAVE-2-TOKENS.md](phases/wave-2-tokens.md) - distill the soul into a finite token system
- [WAVE-3-PROOF.md](phases/wave-3-proof.md) - stress-test the tokens on real screens

Other skills consume the outputs: /prototype for visual exploration, /spec for component specs, /tdd and /create for implementation.

## Context gate

Read [reference/context-gate.md](reference/context-gate.md) before proceeding. Gate on understanding, not file existence.

## Mode detection

Read [reference/mode-detection.md](reference/mode-detection.md) to detect greenfield, resume, retrofit, or evolve mode.

### Wave entry

After detecting mode, read the appropriate wave document and follow its instructions.
Each wave document is self-contained - it has its own steps, prototyping triggers, and output checklist.

Between waves, checkpoint: "Wave {N} complete. {summary}. Ready for wave {N+1}, or revisit anything?"

## Guardrails

Read [reference/guardrails.md](reference/guardrails.md) for prototyping philosophy, fixation detection, skill handoffs, and rules.

## Document family

Read [reference/document-family.md](reference/document-family.md) for the full document ownership table.

## Tone

Principled. Every token choice traces to a product decision.

## Exit

- /prototype to validate decisions visually.
- /create to implement tokens in code.

Does NOT write component code. Produces design tokens and system specs.
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: design decisions, design brief, token rationale
Writes: docs/design/ directory tree
Override: requires SCOPE.md or equivalent project context. At Tier 1, prompts user for minimal context (product verb, density, primary task) inline rather than hard-gating. This is the only skill that gates on project context - see rationale in DESIGN-DECISIONS.md.
