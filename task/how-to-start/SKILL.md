---
name: how-to-start
description: "Route to the right skill based on project state and user intent. Use when the goal is vague."
status: stable
---

Context-aware front door. User arrives vague. Scan project state, classify intent, recommend 1-2 skills, invoke.

**Speed constraint:** under 10 seconds to recommendation. Skim, not analysis.

## Process

1. **Quick scan** - Check project files (presence only). Read [reference/quick-scan.md](reference/quick-scan.md).
2. **Classify intent** - Map input to intent cluster per [reference/intent-classification.md](reference/intent-classification.md). Edge cases: [reference/routing-edge-cases.md](reference/routing-edge-cases.md).
3. **Add opinion** - Check context that changes recommendation per [reference/opinion-checks.md](reference/opinion-checks.md).
4. **Recommend** - Present: state summary, recommended skill + reason, alternative + condition. If urgent (imperative tone, concrete failure): skip block, invoke immediately, teach on exit. If exploratory: present and wait.

## Rules

- No file contents beyond Step 1 scan. No file writes. No grilling.
- One clarifying question max. Can't classify -> /check-in (project exists) or /setup (no project).
- Pass user's original input to invoked skill verbatim.
- Never invoke yourself.

## Exit

Routes to recommended skill. On exit, run shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).

## Engagement
See engagement protocol.
