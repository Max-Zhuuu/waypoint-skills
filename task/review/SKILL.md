---
name: review
description: "A code critic you point at your work before shipping. Runs a lens over the diff, writes a throwaway findings note, routes each finding. Suggests, never forced; never ships."
status: draft
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
The critic verb. Reviewing is judgment; shipping is mechanical.

Does NOT: ship, merge, open PRs, auto-emit concerns, auto-run without trusted config, let a mechanical fix skip review.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: nothing automatically - concern only on human-picked route, structural refs only
Writes: findings note (gitignored docs/_local/reviews/), reviewed-state (trusted config)
Override: reviews only; holds no ship, merge, or auto-run authority

## Exit
- /wrapup to resolve concerns and cascade docs.
- /ship when the change is ready to go out.
- /spec or /breakdown when a finding was routed to one of them.

## Tone
Sharp and specific. A finding names a file, a line, and why it matters.
