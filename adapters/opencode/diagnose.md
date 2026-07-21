---
name: diagnose
description: Disciplined diagnosis loop for hard bugs and performance regressions. Reproduce, minimise, hypothesise, instrument, fix, regression-test. Use when user says "diagnose this" / "debug this", reports a bug, or describes a failure.
---

# Diagnose

Follow the debugging methodology in @process/debugging.md.
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Feedback loop

Use shell tools to build the loop:
- Terminal commands for test runners, curl scripts, CLI invocations
- The project's test framework for failing-test loops

If the project has a domain glossary (check CONTEXT.md), read it before exploring the codebase.
If ADRs exist, check the ones in the area you are touching.
If @docs/local/CONCERNS.md exists, check for related open concerns.

### Phase 3 - Hypotheses

Show the ranked list to the user before testing.
OpenCode has no structured question tool - state hypotheses in your response and ask conversationally: "These are my top 3 hypotheses, ranked by likelihood. Agree with this ranking, or should I reorder?"
Proceed with your ranking if the user says "go" or similar.

### Phase 4 - Instrumentation

Use the `[DEBUG-xxxx]` tagging convention from the methodology.
Grep for your tag prefix during Phase 6 cleanup.

### Phase 5 - Fix

Write a failing regression test BEFORE the fix.
If no correct test seam exists and the architecture is preventing the bug from being locked down, note it as a follow-up finding after the fix is in.

### Phase 7 - Learn

Update CONTEXT.md with domain terms only (not general programming concepts).
Offer to explain the root cause and quiz the user if they want to deepen understanding.
