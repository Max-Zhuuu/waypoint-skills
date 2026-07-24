## Workflow Record

On invocation, write or update the `## Active Workflow` section in CLAUDE.md:

```markdown
## Active Workflow

| Field | Value |
|-------|-------|
| Skill | /create |
| Activated | {date} |
| Scope | {one-line description of what's being added} |
| Features | {list of feature names, updated as specs are written} |
| Status | in progress |
```

/check-in reads this section to know what workflow is active and orient accordingly.
When /create completes, update Status to `completed ({date})`.
