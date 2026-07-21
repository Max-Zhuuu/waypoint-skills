# Migration References

Process-layer references for `/migrate` phase files. These inform *when to decide* and *what criteria to apply* - they do not prescribe implementation methodology.

Testing methodology (characterization tests, structural enforcement, contract tests, visual regression, snapshots) and architecture methodology (Strangler Fig, branch by abstraction, seam identification, expand-contract) belong to the implementation verbs (/port, /tdd) and are applied by those skills as judgment calls.

## Process References

### Spolsky's Rewrite Warning
Old code looks messy because it embodies years of bug fixes, edge case handling, and hard-won domain knowledge. A rewrite that starts clean will re-encounter every bug the original code already solved - but this time without knowing which behaviors are load-bearing.
**When to cite:** Any time someone wants to "simplify" legacy behavior they don't fully understand. Especially Phase 6a when parity discrepancies surface.

### "Legacy code is code without tests" (Feathers)
The defining characteristic of legacy code isn't age or messiness - it's the absence of tests that let you change it safely. Before modifying any legacy behavior, add a test that locks in the current behavior. Then change the behavior. This sequence - lock, change, verify - is the atomic unit of safe migration.
**When to cite:** Phase 3-4, any time someone wants to change behavior without first capturing what the current behavior is.

### Make the Change Easy, Then Make the Easy Change (Beck)
When a change is hard, don't force it. First, refactor until the change is easy (this might be the bulk of the work). Then make the now-easy change. Applied to migrations: don't fight the legacy architecture. The friction is a signal that the foundation needs work, not that you should push harder.
**When to cite:** Phase 3 architecture checkpoint, when a pattern feels forced.

## Acceptance criteria by phase

These are requirements (what must be true), not methodology (how to achieve it):

| Phase | Acceptance criteria |
|-------|--------------------|
| 3 - Vertical slice | Each screen's behavior is captured and reproducible. Discrepancies between source and target are categorized. |
| 4 - Horizontal buildout | Every ported screen has tests. Full suite passes. No regressions in previously-ported screens. |
| 5 - Integration | All screens consume real API (or documented exceptions). Loading/error/empty states implemented. |
| 6a - Functional validation | All screens validated side-by-side. All discrepancies categorized (bug, intentional, unknown). |
