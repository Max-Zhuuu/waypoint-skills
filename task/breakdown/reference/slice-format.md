Output format (written to the spec file as a new section):

```markdown
## Implementation Slices

### Slice 1: {name}
**Depends on:** none
**Files:** {list of files this slice creates or modifies}
**Done when:** {testable condition}
**Notes:** {any context that helps the implementer}

### Slice 2: {name}
**Depends on:** Slice 1
**Files:** {files}
**Done when:** {condition}
```
