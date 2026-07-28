## Task proposal - priority stack

Three layers, checked in order. Propose the first match:

1. **Resolve open concerns.** Read CONCERNS.md open section.
   - Issues first (implementation discrepancies need immediate resolution).
   - Questions with validate-by dates approaching or risk: high.
   - Milestones: check which specs are complete, propose next work toward the nearest open milestone.
   - Stale claims (>4 hours) signal interrupted work - propose resuming.
   - If a concern references an entity: propose "/wrapup on {entity}."
   - If a concern has no entity reference: propose direct resolution.

2. **Advance phase.** Pick the next item from the current phase's work list.
   Order by dependency (parents before children), then risk (uncertain before routine).

3. **Gate check.** If all phase work is done, evaluate gate criteria.
   If met, prompt to advance. If not, show specific remaining items.

## Methodology selection

When proposing implementation work, ask the user which verb to invoke via AskUserQuestion:

- For migration screens: /tdd (default, with port checklist as reference)
- For new features: /tdd (default)
- For design work: /design or user's chosen methodology

The process layer does not hardcode which methodology skill to use.
