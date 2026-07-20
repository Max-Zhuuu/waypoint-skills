# Issue Tracker Integration

**Status:** Draft - grilling in progress
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
Both skills are small (84 and 104 lines). The adaptation surface is well-defined.
**Rationale:** Keeping them as MP externals means convention mismatches and split mental models. Absorbing is cheaper than the ongoing cognitive tax of two families.

### D2: Tracker configuration lives in /project-setup
**Decision:** Fold tracker config into /project-setup Phase 1 as an optional section.
AskUserQuestion: "Do you use an issue tracker?" with options (GitHub Issues, Linear, Local files only, None).
If yes, write config to a TRACKER.md reference file at the skill family root.
For lightweight mode: /to-issues and /triage ask on first invocation if TRACKER.md is missing, then write it themselves. Stateless - file exists = use it, doesn't = ask once.
**Rationale:** /project-setup already handles one-time project decisions. Tracker config is the same kind of decision. TRACKER.md follows the REFERENCES.md pattern.

### D3: Chain integration
**Decision:** Four integration points:
1. **/create:** After /spec completes, offers /to-issues as optional next step. "Spec written. Publish to tracker with /to-issues, or continue building?" Skip if building now; publish if speccing for a team or AFK agent.
2. **/buildout:** Offers /to-issues at the end of Phase 2 discovery, after MoSCoW breakdown is confirmed. Issues become the backlog, each referencing its spec file.
3. **/check-in:** Insert "triaged issues" as priority layer 3 (after blockers, before advance-phase). Surfaces `ready-for-agent` issues as work candidates.
4. **/migrate:** No integration. Migration inventory is internal tracking with fine-grained statuses that don't map to issue statuses. If migration produces external work, /to-issues handles it as a separate step.
**Rationale:** Each integration point offers, never forces. /create and /buildout are "push to tracker" moments. /check-in is "pull from tracker." /migrate stays file-based.

### D4: /grill-with-docs offers /to-issues as terminal step
**Decision:** After grilling completes and the plan is settled, /grill-with-docs asks: "Plan is grilled. Break it into tracker issues with /to-issues?"
If yes, chains directly - no context loss, no re-exploration.
/to-issues also works standalone for pre-grilled specs.
**Rationale:** The primary path (grill then decompose) flows through /grill-with-docs as the orchestrator. Same pattern as /create chaining spec -> build -> wrapup, and /diagnose recommending /improve-codebase-architecture.

## Open Questions

### Q1: /to-prd disposition
/to-prd is also installed from MP family. Absorb? Or does /spec already cover its purpose?
/to-prd's distinguishing feature: no-interview synthesis (just writes from context, doesn't grill).
/spec's distinguishing feature: inline grilling with Given/When/Then acceptance criteria.
Are these different enough to keep both, or should /spec absorb /to-prd's "just synthesize" mode?

### Q2: Naming
Keep /to-issues and /triage names, or rename to fit MZ conventions?
Current MZ naming: verb-oriented (/spec, /tdd, /port, /diagnose, /learn).
/to-issues fits the "to-X" pattern (conversion skill). /triage is a noun - maybe /triage is fine as-is since it's a well-understood domain term.

### Q3: Agent brief format
/triage writes agent briefs for `ready-for-agent` issues.
How does this relate to /port's subagent briefs and /check-in's verb proposals?
Should there be a shared AGENT-BRIEF.md format (like CONTEXT-FORMAT.md)?

### Q4: /to-issues grilling depth
/to-issues has a "Quiz the user" step (present breakdown, ask about granularity/dependencies).
Is this sufficient grilling, or should /to-issues invoke /grill-me for deeper challenge on each slice?
Given D4 above (/grill-with-docs already grills upstream), probably not - double grilling is wasteful.

### Q5: Local files mode
MP's /to-issues supports local files (.scratch/<feature>/issues/<NN>-<slug>.md) as an alternative to a real tracker.
Does this overlap with docs/implementation/specs/? Should local-file mode write to docs/implementation/issues/ instead?

### Q6: Field validation needed
User is not deeply familiar with /to-issues usage patterns. These decisions need field testing before implementation.
