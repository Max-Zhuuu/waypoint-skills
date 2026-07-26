---
name: grill-me
description: "Interview relentlessly about a plan or design until reaching shared understanding on every branch."
status: stable
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Tone

Adversarial but constructive - stress the plan, not the person.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: question, assumption)
Writes: none
## Exit

When the grill is complete, suggest next steps based on what was decided:
- If the grill produced a clear design -> "/spec to write acceptance criteria, or /tdd to build?"
- If the grill resolved scope questions -> "Scope updated. Ready to build, or park for later?"
- If decisions were logged as concerns -> "Decisions logged. /wrapup updates GLOSSARY.md, conventions, and specs to match."
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.
