# Enforcement core

Shared phase-regression and gate-override patterns. Referenced by /check-in and /migrate enforcement steps.

## Phase regression

A phase is regressed when a gate criterion that previously passed now fails (e.g., a passing test breaks, a spec drifts from built code, a resolved concern reopens).

- Surface regression as a priority concern: `type: issue`, `source: enforcement`.
- Never silently re-advance past a regressed gate. The agent reports it; the user decides.
- The regression is context for the priority stack, not a blocker. Work can continue on other items while the regression is being resolved.
- If the same criterion regresses twice, escalate: "This gate item has regressed again. Root-cause the regression before advancing."

## Gate override

When a gate item cannot be satisfied and the user wants to proceed:

1. Present the specific item: "Gate item '{criterion}' is not met."
2. Offer two paths: "Skip it (with recorded reason) or resolve it?"
3. On skip: record in CONCERNS.md as `type: assumption`, with `owner`, `validate-by` date (max 90 days), and the reason for skipping.
4. Accumulated skips surface in subsequent /check-in and /wrapup runs. They do not disappear.
5. A gate with 3+ skipped items triggers a mandatory pause: "This gate has {N} skipped items. Review them before continuing."

## Dynamic adaptation

When observed complexity diverges from the declared tier:
- Small project accumulating >10 concerns, >3 ADRs, or >5 convention docs -> suggest upgrade to Moderate.
- Large project with <3 concerns and minimal ceremony used -> suggest downgrade.
- Never auto-adjust. Always ask: "This looks more like a {tier} project. Adjust tier?"
- Tier changes cascade to scaffolding: doc structure, ceremony level, convention depth.
