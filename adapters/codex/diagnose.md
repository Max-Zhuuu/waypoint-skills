# Debugging Protocol

Read `process/debugging.md` in full before touching any code.
It defines the complete methodology: feedback loop, reproduce, hypothesize, instrument, fix, cleanup, learn.
Follow it phase by phase. Do not skip phases.

## Context

If `CONTEXT.md` exists in the project root, read it first for domain terminology.
If `docs/local/CONCERNS.md` exists, check for related open concerns.
If `docs/adr/` exists, check ADRs in the area you are touching.

## Rules

- Build a fast, deterministic feedback loop (Phase 1) before doing anything else.
  Spend disproportionate time here. A 2-second loop beats a 30-second loop.
- Generate 3-5 ranked hypotheses before testing any of them (Phase 3).
  Present them to the user and wait for confirmation before proceeding.
- Tag every debug log with `[DEBUG-xxxx]` (random 4-char hex).
  Grep-remove them all during cleanup. Untagged logs survive; tagged logs die.
- Write a failing regression test BEFORE writing the fix (Phase 5).
  Watch it fail. Apply fix. Watch it pass.
- Before declaring done (Phase 6): confirm original repro is gone,
  regression test passes, all debug tags removed, root cause in commit message.
- If no correct test seam exists for the regression test, note that as
  an architectural finding. Do not force a test at the wrong seam.
