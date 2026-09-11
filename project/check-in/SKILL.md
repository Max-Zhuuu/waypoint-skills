---
name: check-in
description: "Session entry point. Loads context, reports state, detects enterprise artefacts. Use at every session start."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Context loader, not a project manager. Reports state without prescribing work.
Invoke with `--deep` (or "I'm stuck") for the full reorient sequence: snapshot, hard questions, axis audit.

Does NOT: implement, update docs, or prescribe next task. /triage handles prioritization.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: flags, session plan
Writes: .claude/.setup-prompted (first Tier 1 invocation)

## Exit
- /triage to pick next task from backlog.
- Invokes the user's chosen implementation verb directly.

## Tone
Brief. Read state, report, move on.
