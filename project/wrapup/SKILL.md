---
name: wrapup
description: "Resolve concerns, cascade to shared docs, evaluate gate criteria. Run after /tdd or any implementation verb."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Single reconciliation point for all doc updates after implementation.
Ending the session? Say "I'm wrapping up" or invoke with `handoff` to write a continuity doc and boot prompt.

Does NOT: ship, merge, review code (that is /review), or promote.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: issues, resolution notes
Writes: CONCERNS.md (creates if absent), docs/_local/handoffs/ (handoff mode)
Override: cascade only fires for docs that exist

## Exit
- /review for a critic pass before shipping.
- /check-in for next session.

## Tone
Brief and mechanical. Resolve, cascade, report.
