---
name: diagnose
description: Disciplined diagnosis loop for hard bugs and performance regressions. Reproduce, minimise, hypothesise, instrument, fix, regression-test. Use when user says "diagnose this" / "debug this", reports a bug, says something is broken/throwing/failing, or describes a performance regression.
---

# Diagnose

Follow the debugging methodology in [process/debugging.md](../process/debugging.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Feedback loop

Use project tools to build the loop:
- Bash/PowerShell for test runners, curl scripts, CLI invocations
- chrome-devtools-axi for browser-based reproduction
- The project's test framework for failing-test loops

If the project has a domain glossary (check Documentation Map or CONTEXT.md), read it before exploring the codebase.
If ADRs exist, check the ones in the area you are touching.

If scaffolding is missing, follow [ENGAGEMENT-REFERENCE.md](../ENGAGEMENT-REFERENCE.md).

### Phase 3 - Hypotheses

Show the ranked list to the user before testing.
Do not block on their response - proceed with your ranking if they are not available, but give them the opportunity to re-rank.

### Phase 4 - Instrumentation

Use the `[DEBUG-xxxx]` tagging convention from the methodology.
Grep for your tag prefix during Phase 6 cleanup.

### Phase 5 - Fix

For the regression test seam assessment: if no correct seam exists and the architecture is preventing the bug from being locked down, hand off to `/improve-codebase-architecture` with the specifics after the fix is in.

### Phase 7 - Learn

Follow the quiz and practice protocols in [learn/LEARN-REFERENCE.md](../learn/LEARN-REFERENCE.md) if the user opts in.
Update CONTEXT.md with domain terms only (not general programming concepts).
Link further-reading sources per [learn/REFERENCES.md](../learn/REFERENCES.md#source-trust-tiers).
