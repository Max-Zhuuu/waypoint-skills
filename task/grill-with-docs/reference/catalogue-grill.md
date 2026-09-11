# Catalogue-driven grill

When an architecture rule catalogue exists, replace open-ended design questions with systematic per-family interrogation.

## With existing catalogue

1. Read the catalogue. Parse rule families, severity tiers, execution tiers.
2. For each family: note ID, name, rule count, severity distribution, open items.
3. Initialize a checklist - one row per family:
   ```
   [ ] A (Style) - 7 rules, 2 open items
   [ ] B (File placement) - 8 rules, 0 open items
   ...
   ```
4. Grill each family systematically, one at a time, depth-first:
   - "Does the current plan address family {ID}? What decisions are needed?"
   - "The catalogue has {N} rules here. Which need project-specific decisions?"
   - For each open item: "Open item: {description}. What's your position?"
   - Do not ask vague questions. Each question references a specific rule or open item.
5. Cross-reference against existing ADRs. Map each ADR to the families it addresses. Identify families with no ADR coverage - these are high-priority grill targets.
6. Open items in the catalogue's `## Open items` section are the highest-priority targets. Each blocks specific rules.

## ADR consolidation

Each ADR answers a root question with branching sub-decisions.
Target: 6-8 ADRs for a complex project, each covering 2-3 related rule families.

Bad: "ADR-001: Use Vue 3", "ADR-002: Use PrimeVue", "ADR-003: Use valibot" (granular, per-decision).
Good: "ADR-001: Stack, structure, and contract chain" (consolidated, covers A + B + D + E families).

Every ADR must pass three gates:
1. **Hard to reverse** - the cost of changing later is meaningful.
2. **Surprising without context** - a future reader will wonder "why this way?"
3. **Result of a real trade-off** - genuine alternatives existed and you picked one for specific reasons.

If any gate fails, skip the ADR. The decision is real but doesn't need recording.

## Bootstrapping (no catalogue exists)

Offer when the project is moderate or large tier.

1. Start with severity definitions:
   - **BLOCK** - correctness, security, tenant isolation. Fails pre-commit and CI.
   - **RATCHET** - coverage or debt metric. Fails only on baseline regression.
   - **WARN** - convention drift. Non-blocking, aggregated.
2. Start with execution tiers:
   - **T0** (<2s, on save / agent inner loop)
   - **T1** (<20s, pre-commit)
   - **T2** (<8min, CI on PR)
   - **T3** (unbounded, nightly / scheduled)
3. Seed families from the grill, not from another project. Ask: "What rule families does THIS project need?"
4. Common starting families: Style, File placement, Contracts/schemas, Testing coverage, Config/hardcoded strings, Auth/security. Add domain-specific families as the grill reveals them.
5. Mark all initial rules as WARN. Let the team ratchet up severity as conventions mature.
6. Record open items for decisions that can't be made yet (e.g., component library choice blocks style rules).
