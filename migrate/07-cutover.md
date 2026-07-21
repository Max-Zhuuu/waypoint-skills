# Phase 7 - Cutover

**Goal:** ship it. Replace the source system with the migrated system.

## Checkpoints

### CP1: Pre-cutover readiness
- **Trigger:** before cutover begins
- **References:** all gate criteria from Phases 3-6a, DEPENDENCIES.md, SCOPE.md (parity strategy + cutover approach from G1)
- **Action:** verify all prior phase gates passed. Confirm no open critical concerns. Confirm all inventory items at `[V-func]` or above. Review cutover approach set during /migrate setup (strangler fig / big-bang / parallel run) and confirm it still holds.
- **Pass:** all prior gates passed, no critical blockers, cutover approach confirmed.

### CP2: Post-cutover validation
- **Trigger:** after traffic shift (full or partial, depending on cutover approach)
- **References:** feature specs, monitoring dashboards, source system (for comparison)
- **Action:** verify production behavior matches validated state from Phase 6a. Check monitoring for errors, performance regressions, data integrity issues. Compare output against source system if parallel run.
- **Pass:** monitoring confirms parity, no critical errors, rollback not triggered.

## Process

### Deployment plan
- Environments and deployment order (staging -> canary -> production, or project-specific)
- Rollback procedure documented and tested before cutover
- Data migration steps if applicable (schema changes, backfill, sync)

### Communication plan
- Who needs to know (users, stakeholders, downstream systems)
- When they need to know (before, during, after)
- What they need to do (nothing, re-login, update bookmarks, learn new workflows)

### Monitoring plan
- What to watch (error rates, latency, key business metrics)
- Thresholds that trigger investigation vs rollback
- Who gets paged and escalation path
- Duration of heightened monitoring (first 24h, first week)

### Rollback criteria
Define before cutover, not during a crisis:
- Which metrics trigger rollback
- How to roll back (revert deploy, redirect traffic, restore data)
- Maximum acceptable rollback window
- What data created in the new system during rollback window

## Gate

- [ ] Deployed and serving traffic
- [ ] Monitoring confirms functional parity (CP2 passed)
- [ ] Rollback plan tested (not just documented)
- [ ] Source system sunset date set or parallel-run period defined
- [ ] User communication sent
- [ ] Post-launch monitoring period defined
