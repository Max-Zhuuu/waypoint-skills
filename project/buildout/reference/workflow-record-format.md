# Workflow Record Format

Template for the `## Active Workflow` section `/buildout` writes to CLAUDE.md.

```markdown
## Active Workflow

| Field | Value |
|-------|-------|
| Skill | /buildout |
| Activated | {date} |
| Archetypes | {selected archetypes} |
| Ship tier | {hobby / users / growth} |
| Current phase | Phase 2 - Discovery & Validation |
| Status | in progress |
```

/check-in reads this to know the workflow and current phase without guessing.
Update `Current phase` each time a phase gate passes.
When /buildout completes (Phase 4 gate), update Status to `completed ({date})`.
