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
