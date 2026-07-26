---
name: diagnose
description: "Run a disciplined diagnosis loop for hard bugs: reproduce, hypothesize, instrument, fix, regression-test."
status: stable
---

Follow the debugging methodology in [process/debugging.md](../../process/debugging.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Feedback loop

Use project tools to build the loop:
- Bash/PowerShell for test runners, curl scripts, CLI invocations (see [hitl-loop.template.sh](reference/hitl-loop.template.sh) for interactive reproduction)
- chrome-devtools-axi for browser-based reproduction
- The project's test framework for failing-test loops

If the project has a domain glossary (check Documentation Map or GLOSSARY.md), read it before exploring the codebase.
If ADRs exist, check the ones in the area you are touching.

### Phase 3 - Hypotheses

Show the ranked list to the user before testing.
Do not block on their response - proceed with your ranking if they are not available, but give them the opportunity to re-rank.

### Phase 4 - Instrumentation

Use the `[DEBUG-xxxx]` tagging convention from the methodology.
Grep for your tag prefix during Phase 6 cleanup.

### Phase 5 - Fix

For the regression test seam assessment: if no correct seam exists and the architecture is preventing the bug from being locked down, hand off to `/improve-codebase-architecture` with the specifics after the fix is in.

### Phase 7 - Learn

Follow the quiz and practice protocols in [learn/learn-reference.md](../../task/learn/reference/learn-reference.md) if the user opts in.
Update GLOSSARY.md with domain terms only (not general programming concepts).
Link further-reading sources per [learn/references.md](../../task/learn/reference/references.md#source-trust-tiers).

## Exit

Bug fixes are typically stable commits. Run mini-wrapup:
- Spec sync: does the fix invalidate any spec assumptions?
- Term/pattern capture: did this bug reveal an undocumented rule?
- Concern resolution: does this fix resolve any open concerns?

If the fix is a workaround or the root cause is unclear, commit as provisional with `[provisional]` marker and emit an issue concern explaining what's uncertain.

State next step: "/wrapup to update shared docs, or another bug?"

See [the engagement protocol](../../internals/engagement/README.md) section 6 for the full exit protocol.
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.

## Tone

Clinical. Follow the evidence, not the hunch.

Does NOT skip straight to a fix. Runs the full diagnosis loop.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: issue, question)
Writes: none
