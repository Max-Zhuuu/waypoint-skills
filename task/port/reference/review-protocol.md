# Review Protocol

Checklist for reviewing subagent output after a /port implementation.

## Review checklist

After the subagent completes, verify against spec and source:
- Fields present and correct against spec?
- Controls match source system behavior?
- Conditional visibility rules implemented?
- Navigation paths work?
- Tests pass?

## Concern emission

When cross-reference finds discrepancies between spec and reality:
- DO NOT update the spec. DO NOT update shared docs.
- Emit each discrepancy as a concern in CONCERNS.md (type: issue, source: /port, refs: entity spec):

```markdown
### C-{NNN} [open] Spec says field X is editable, source has it read-only in status=Closed
type: issue | raised: {date} | source: /port
refs: docs/reference/features/{entity}.md
```

These concerns are /wrapup's input.

## Pre-commit verification

Run mini-wrapup before committing:
- **Spec sync:** does the built screen match the feature spec?
- **Term/pattern capture:** did porting reveal domain terms or patterns?
- **Concern resolution:** does this work resolve any open concerns?

See [the engagement protocol](../../../internals/engagement/README.md) section 6 for the full exit protocol.
