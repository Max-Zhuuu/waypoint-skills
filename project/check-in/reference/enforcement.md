## Enforcement

### Core rules (always fire)

1. Specs exist before implementation begins
2. No phase leapfrogging (unless regression)
3. No stale critical concerns (flags or high-risk assumptions past deadline)

### Archetype extras (composable, multi-select)

Selected archetypes in SCOPE.md add enforcement rules to the core set.
If no archetypes selected: core rules only + dynamic adaptation.

Provisional-doc pressure: surfaces issue concerns from provisional commits grouped by feature, with age-based escalation (see ENGAGEMENT-REFERENCE.md section 6).
Stale claims: warns about Claims older than 4 hours at session start.

## Phase regression

When a gate can't pass because an earlier-phase decision is invalidated:

1. Recognize this as regression, not leapfrogging.
2. Propose: "Phase {N} gate blocked - {decision} invalidated by {evidence}. Regressing to Phase {M}."
3. Tracked via: ADR (rationale) + inventory reversion (state) + git history (timeline).
4. On resolution, /check-in re-proposes the original phase work naturally.

## Dynamic adaptation

/check-in adapts ceremony to observed complexity:
- Few entities, simple specs -> lighter ceremony
- Many entities, complex interdependencies -> more structure
- Repeated concerns of the same type -> suggest /reorient

## Concurrent sessions

When claims in CONCERNS.md show multiple active sessions:
- Propose work in unclaimed file areas.
- If claims overlap, suggest resolving the overlap first.
- Stale claims (>4 hours) are noted but not auto-removed.

```
{N} concurrent sessions active. Proposing work in unclaimed areas.
```
