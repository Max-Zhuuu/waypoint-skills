# Issue Tracker Integration

**Status:** Draft - grilling complete
**Created:** 2026-07-20
**Updated:** 2026-07-20

## Problem

The MZ skill family has no issue tracker integration.
Implementation work is tracked in files (ACTIVE-WORK.md, specs, phase gates) but not where PMs and external collaborators look.
/to-issues and /triage exist as installed skills but belong to the MP family and reference MP infrastructure (setup-matt-pocock-skills, ask-matt router).
Two skill families with different conventions coexist in the same install.

## Decisions

### D1: Absorb /to-issues and /triage into MZ family
**Decision:** Fork, adapt to MZ conventions, maintain independently.
Both skills are small (84 and 104 lines).
The adaptation surface is well-defined.
**Rationale:** Keeping them as MP externals means convention mismatches and split mental models.
Absorbing is cheaper than the ongoing cognitive tax of two families.

### D2: Tracker configuration lives in /project-setup
**Decision:** Fold tracker config into /project-setup Phase 1 as an optional section.
AskUserQuestion: "Do you use an issue tracker?" with options (GitHub Issues, Linear, Local files only, None).
If yes, write config to a TRACKER.md reference file at the skill family root.
For lightweight mode: /to-issues and /triage ask on first invocation if TRACKER.md is missing, then write it themselves.
Stateless - file exists = use it, doesn't = ask once.
**Rationale:** /project-setup already handles one-time project decisions.
Tracker config is the same kind of decision.
TRACKER.md follows the REFERENCES.md pattern.

### D3: Chain integration
**Decision:** Four integration points:
1. **/create:** After /spec completes, offers /to-issues as optional next step. "Spec written. Publish to tracker with /to-issues, or continue building?" Skip if building now; publish if speccing for a team or AFK agent.
2. **/buildout:** Offers /to-issues at the end of Phase 2 discovery, after MoSCoW breakdown is confirmed. Issues become the backlog, each referencing its spec file.
3. **/check-in:** Insert "triaged issues" as priority layer 3 (after blockers, before advance-phase). Surfaces `ready-for-agent` issues as work candidates.
4. **/migrate:** No integration. Migration inventory is internal tracking with fine-grained statuses that don't map to issue statuses. If migration produces external work, /to-issues handles it as a separate step.
**Rationale:** Each integration point offers, never forces.
/create and /buildout are "push to tracker" moments.
/check-in is "pull from tracker."
/migrate stays file-based.

### D4: /grill-with-docs offers /to-issues as terminal step
**Decision:** After grilling completes and the plan is settled, /grill-with-docs asks: "Plan is grilled. Break it into tracker issues with /to-issues?"
If yes, chains directly - no context loss, no re-exploration.
/to-issues also works standalone for pre-grilled specs.
**Rationale:** The primary path (grill then decompose) flows through /grill-with-docs as the orchestrator.
Same pattern as /create chaining spec -> build -> wrapup, and /diagnose recommending /improve-codebase-architecture.

### D5: Drop /to-prd
**Decision:** Do not absorb /to-prd.
Remove it from the install.
**Rationale:** /to-prd's value proposition is no-interview synthesis - "just write from context, don't grill."
This conflicts with the MZ family's grill-first philosophy.
/grill-with-docs produces decision-rich specs; /spec produces formal specs with acceptance criteria.
A no-interview synthesizer is the same kind of shallow shortcut that led to deleting the superpowers plugin.
If context is fully resolved, /spec's grill is naturally short.

### D6: Keep /to-issues and /triage names
**Decision:** No rename.
/to-issues follows the "to-X" conversion pattern (verb: convert to).
/triage is a well-understood action verb in software ("triage the backlog").
**Rationale:** Both names are verb-oriented in practice, consistent with MZ conventions (/spec, /tdd, /diagnose).
Renaming adds churn without clarity.

### D7: No shared agent brief format
**Decision:** Each skill owns its output shape.
No family-wide AGENT-BRIEF.md template.
The only interface contract: /triage's output must be parseable by /check-in (D3 integration point 3).
**Rationale:** Three different purposes produce three different shapes:
- /check-in produces task proposals (for the human/session agent to decide)
- /port produces subagent work orders (terse, file-scoped, consumed by Agent() calls)
- /triage produces async handoffs (self-contained, for future agent sessions)
A shared format would force lowest-common-denominator output.

### D8: Decomposition quiz is sufficient, conventions capture preferences
**Decision:** Keep /to-issues's existing decomposition quiz (present breakdown, ask about granularity/dependencies).
Do not add /grill-me invocation - plan grilling already happened upstream in /grill-with-docs.
Decomposition preferences (granularity, dependency ordering, cross-cutting concern handling) live in project conventions.
**Rationale:** The quiz confirms "did I slice correctly?" not "is the plan sound?" - different questions.
When invoked standalone (not chained from /grill-with-docs), the user has chosen to skip grilling.
The exact structure of conventions (single file vs. folder) is deferred to a separate conventions-architecture spec.

### D9: Local issues go in docs/implementation/issues/
**Decision:** Extend the lightweight-entry-points D10 structure:
```
docs/implementation/
  specs/          - feature specs from /spec
  improvements/   - improvement proposals
  handoffs/       - cross-boundary work
  issues/         - work items from /to-issues (local mode only)
```
Same frontmatter pattern as lightweight-entry-points D11 (created, updated, status).
When a real tracker is configured, /to-issues writes there instead.
**Rationale:** Follows the established `docs/implementation/` container pattern.
Local issues are shared implementation artifacts, not ephemeral scratch.

### D10: Field validation expected
**Decision:** Implement with a light touch, expect one revision cycle after first use.
All decisions are internally consistent with established MZ patterns and the lightweight-entry-points spec.
Risk areas requiring field validation:
- Decomposition UX (D8 quiz flow)
- /triage-to-/check-in interface contract (D7)
- Local files workflow (D9)
**Rationale:** Decisions are grounded in documented patterns, but /to-issues and /triage usage is new to the user.
Not a blocker - implement and iterate.

## Discovery: Conventions Architecture

During Q4 grilling, a broader insight surfaced: CONVENTIONS.md is overloaded for large projects.
Conventions naturally subdivide (naming, decomposition, testing, review, documentation).
A conventions folder structure - root-level or under docs/ - would let each subtype be its own file.
/project-setup would scaffold the structure during initial setup.

This affects every skill in the family, not just issue tracking.
**Captured as a separate spec: conventions-architecture.md**
