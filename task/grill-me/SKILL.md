---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
status: stable
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: question, assumption)
Writes: none
## Exit

When the grill is complete, suggest next steps based on what was decided:
- If the grill produced a clear design -> "/spec to write acceptance criteria, or /tdd to build?"
- If the grill resolved scope questions -> "Scope updated. Ready to build, or park for later?"
- If decisions were logged as concerns -> "Decisions logged. /wrapup updates GLOSSARY.md, conventions, and specs to match."
