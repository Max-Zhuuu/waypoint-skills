# Local Documentation Structure

Canonical reference for `docs/local/` - the gitignored working state that lives alongside the project.
Skills that create, read, or write these files reference this page.

## Core tracking

All project tracking converges on a single artifact:

| File | Purpose | Created by | Read by |
|------|---------|------------|---------|
| CONCERNS.md | Questions, assumptions, flags, session claims | /project-setup (seed), any skill (emit) | /check-in, /wrapup, /reorient |

Format: see [../CONCERNS-FORMAT.md](../CONCERNS-FORMAT.md).

CONCERNS.md replaces the previous four-file pattern (QUESTIONS.md, ASSUMPTIONS.md, ACTIVE-WORK.md, PROGRESS-AUDIT.md).
See the "What this replaces" section in CONCERNS-FORMAT.md for the mapping.

## Folders

| Folder | Purpose | Created by | Populated by |
|--------|---------|------------|--------------|
| learning/ | /learn exercises and session notes | /learn (on demand) | /learn Phase 5-6 |
| handoffs/ | Cross-team requests and contracts | /project-setup scaffolding | /migrate Phase 6b, any skill surfacing cross-boundary work |
| handoffs/api-contracts/ | Tier 2: endpoint requests, data contracts | /project-setup scaffolding | Phase 5+ integration work |
| handoffs/schema-changes/ | Tier 3: DB migrations, business rule changes | /project-setup scaffolding | Phase 6b design pass |
| archive/ | Superseded specs, retired docs, old audit snapshots | Any skill (lazy) | /wrapup (superseded specs) |

## Scaling by intake profile

Not every project needs every folder.
/project-setup scaffolds based on the intake profile selected during setup:

| Profile | Gets |
|---------|------|
| **Product** | CONCERNS.md + all folders |
| **Feature** | CONCERNS.md + handoffs/ + archive/ |
| **Deliverable** | CONCERNS.md only |

## Lazy creation rule

Any skill that needs to write to a docs/local/ file or folder that doesn't exist should create it.
Don't block on a missing file - create it, write to it, move on.
This keeps /create and task-layer verbs lightweight while ensuring the structure materializes as needed.
