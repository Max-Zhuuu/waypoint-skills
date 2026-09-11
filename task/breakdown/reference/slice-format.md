Output format (written to the spec file as a new section):

```markdown
## Implementation Slices

### Slice 1: {name}
**Depends on:** none
**Autonomy:** afk | hitl
**Files:** {list of files this slice creates or modifies}
**Done when:** {testable condition}
**Notes:** {any context that helps the implementer}

### Slice 2: {name}
**Depends on:** Slice 1
**Autonomy:** afk | hitl
**Files:** {files}
**Done when:** {condition}
```

## The Autonomy tag

`breakdown` authors the per-slice `autonomy` value; every downstream consumer renders it, none recomputes it ([the autonomy axis](../../../internals/engagement/autonomy.md)).

Tag a slice `afk` only when both hold:
- its **Done when** is machine-verifiable (a test or check can confirm it without a human judgment call), and
- it touches no `load-bearing` surface listed in DEPLOY.md.

Otherwise tag it `hitl`.
Every slice carries a tag.
An untagged slice is treated as `hitl` everywhere downstream (fail-safe), so tag deliberately rather than leaving it to the default.
When DEPLOY.md is absent, the load-bearing condition is unresolved, so the slice cannot be `afk` - tag it `hitl` and note the load-bearing check was unavailable.

## The lane and criteria-count tags (workflow-shaped specs)

When the spec carries a Parallelization Plan, the feature is a fan-out and the execution phase builds a reconciliation ledger from these slices ([verifiable workflows](../../../process/verifiable-workflows.md)).
So each slice in a workflow-shaped spec carries two more tags that the execution phase reads:

- **Lane:** the fan-out unit this slice belongs to (the endpoint, screen, or entity), which becomes the ledger's row identity.
- **Criteria:** `n`, the count of acceptance criteria this slice must satisfy, which seeds the ledger's per-component denominator (the `total_i` in criterion completeness).

`breakdown` authors these two values; the execution phase renders them into ledger rows and never recomputes them, exactly as it renders the autonomy tag.
Omit both tags for ordinary specs that carry no Parallelization Plan.

## Completion is recorded, not stored here

A slice has no done or status field, and it never gets one: the format above is the slice's *definition*, not its state.
When `/tdd` completes a slice it records that out-of-band, as a per-slice done marker in trusted config ([task/tdd/reference/slice-marker.md](../../tdd/reference/slice-marker.md)), keyed by (project identity, slice id).
The spec stays the definition; the marker is the record.
Position is derived - remaining equals the slices defined here minus the ones marked done - so the spec is never edited to reflect progress, and nothing in the repo tracks "where you are".
