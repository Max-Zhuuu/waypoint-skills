---
name: grill-with-docs
description: "Grill a plan against the domain model. Sharpen terminology, update GLOSSARY.md and ADRs as decisions crystallize."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Interview relentlessly. One question at a time, waiting for feedback before continuing.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: question, assumption)
Writes: GLOSSARY.md (shared-append), docs/adr/ (creates)

## Exit
- /breakdown to decompose into implementation slices.
- /spec to extract acceptance criteria from the updated doc.

## Tone
Adversarial but constructive - stress the plan against the domain model.
