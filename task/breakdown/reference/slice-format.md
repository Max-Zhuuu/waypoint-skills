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

`breakdown` authors the per-slice `autonomy` value; every downstream consumer renders it, none recomputes it (ENGAGEMENT-REFERENCE.md section 13).

Tag a slice `afk` only when both hold:
- its **Done when** is machine-verifiable (a test or check can confirm it without a human judgment call), and
- it touches no `load-bearing` surface listed in DEPLOY.md.

Otherwise tag it `hitl`.
Every slice carries a tag.
An untagged slice is treated as `hitl` everywhere downstream (fail-safe), so tag deliberately rather than leaving it to the default.
When DEPLOY.md is absent, the load-bearing condition is unresolved, so the slice cannot be `afk` - tag it `hitl` and note the load-bearing check was unavailable.

## Completion is recorded, not stored here

A slice has no done or status field, and it never gets one: the format above is the slice's *definition*, not its state.
When `/tdd` completes a slice it records that out-of-band, as a per-slice done marker in trusted config ([task/tdd/reference/slice-marker.md](../../tdd/reference/slice-marker.md)), keyed by (project identity, slice id).
The spec stays the definition; the marker is the record.
Position is derived - remaining equals the slices defined here minus the ones marked done - so the spec is never edited to reflect progress, and nothing in the repo tracks "where you are".
