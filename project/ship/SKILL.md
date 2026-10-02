---
name: ship
description: "Assemble spec-grounded PR, propose afk/hitl routing. Run after /wrapup."
status: draft
---

Outbound verb. Assembles PR from pre-registered intent, proposes routing. Never holds merge authority.

Inputs: spec, wrapup gate-evaluation, ADR delta, DEPLOY.md (adapter + load-bearing globs), diff (glob membership only).

Intent block: write from spec + ADR delta + resolved concern decisions. Never read diff to describe change (diff-derived Intent grades itself). Mark "spec-derived".

Autonomy gate (3 keys): (1a) every slice tagged afk, (1b) wrapup blocking verdict "none", (2) no diff path matches load-bearing glob. All three hold = propose afk. Any fail = hitl.

Does NOT: hold merge authority, run /review, execute deploys.

## Exit
- Target holds merge decision. /check-in surfaces staged-but-unpromoted work.
- /review first if change wants critic pass.
- On exit, run the shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).

## Engagement
See engagement protocol.
