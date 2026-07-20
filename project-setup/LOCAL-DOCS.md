# Local Documentation Structure

Canonical reference for `docs/local/` - the gitignored working state that lives alongside the project.
Skills that create, read, or write these files reference this page.

## Core files

These are the working-state files that track what's happening right now.

| File | Purpose | Created by | Read by |
|------|---------|------------|---------|
| ACTIVE-WORK.md | Concurrent agent session tracker | /project-setup (REFERENCES.md template) | /check-in, hook injection |
| QUESTIONS.md | Unresolved issues needing human input | First write (any skill surfacing an unknown) | /check-in (priority stack layer 3) |
| ASSUMPTIONS.md | Working assumptions with risk levels and deadlines | /project-setup Phase 0 scoping | /check-in (enforcement), phase checkpoints |
| PROGRESS-AUDIT.md | Structured audit of project health across axes | /reorient Phase 6 | /reorient (reads prior audit to carry forward) |

### QUESTIONS.md format

```markdown
# Questions

Unresolved issues requiring human input, external team response, or domain clarification.

| # | Question | Raised | Severity | Owner | Status |
|---|----------|--------|----------|-------|--------|
| 1 | {question} | {date} | critical/normal | {person or team} | open |
```

Severity levels:
- **critical** - blocks current phase work
- **normal** - needs resolution before the next gate

### ASSUMPTIONS.md format

```markdown
# Assumptions

Working assumptions that let work proceed. Each needs a resolution deadline.

| # | Assumption | Risk | Deadline | Owner | Status |
|---|------------|------|----------|-------|--------|
| 1 | {assumption} | low/medium/high | {date} | {person} | open |
```

## Folders

| Folder | Purpose | Created by | Populated by |
|--------|---------|------------|--------------|
| learning/ | /learn exercises and session notes | /learn (on demand) | /learn Phase 5-6 |
| handoffs/ | Cross-team requests and contracts | /project-setup scaffolding | /migrate Phase 6b, any skill surfacing cross-boundary work |
| handoffs/api-contracts/ | Tier 2: endpoint requests, data contracts | /project-setup scaffolding | Phase 5+ integration work |
| handoffs/schema-changes/ | Tier 3: DB migrations, business rule changes | /project-setup scaffolding | Phase 6b design pass |
| archive/ | Superseded specs, retired docs, old audit snapshots | Any skill (lazy) | /wrapup (superseded specs), /reorient (old audits) |

## Scaling by intake profile

Not every project needs every file.
/project-setup scaffolds based on the intake profile selected during setup:

| Profile | Gets |
|---------|------|
| **Product** | All core files + all folders |
| **Feature** | All core files + handoffs/ + archive/ (drop learning/) |
| **Deliverable** | ACTIVE-WORK.md + QUESTIONS.md only |

Files not scaffolded eagerly can still be created lazily by any skill that needs them.
PROGRESS-AUDIT.md is never pre-scaffolded - /reorient creates it when run.

## Lazy creation rule

Any skill that needs to write to a docs/local/ file that doesn't exist should create it using the format above.
Don't block on a missing file - create it, write to it, move on.
This keeps /create and task-layer verbs lightweight while ensuring the structure materializes as needed.
