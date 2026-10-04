# Scope Reference

Reference for /setup tier selection.
Read by /setup when explaining tier options to the user during setup.

## Tiers

### Small

**When:** solo dev, few features, low ceremony.
Example: a CLI tool, a small API, a single-purpose library.

**What you get:**
- CLAUDE.md with one-liner, ## Commands, ## Agent constraints, ## Architecture (with ### Key design decisions and ### Source layout)
- .claude/ directory for skill state

**What you skip:**
- No ## Conventions section (project too small for naming drift)
- No ## Scope section (scope is self-evident)
- No ## Product context section (domain is simple)
- No docs/_GLOSSARY.md (domain terms fit in the head)
- No docs/decisions/ (decisions are few and obvious)

Small tier projects typically get the **lean template** (see phase-1.md).

**Skills available:** all verb skills in degraded mode (no convention enforcement, no domain term cross-referencing).

### Moderate

**When:** standard project, small team, conventions needed.
Example: a web app, a service with an API, a migration project.

**What you get:**
- Everything from Small, plus CLAUDE.md sections:
  - ## Scope (In/Out/Uncertain, Constraints, Resources)
  - ## Conventions (naming, file placement, required/prohibited patterns)
  - ## Deployment (environments, promotion gates)
  - ## Product context (personas, external connectors)
  - ## Testing (philosophy, layers, framework)
  - ## References (pointers to ADRs, glossary, catalogue, contracts)
- docs/_GLOSSARY.md (domain glossary)
- docs/decisions/ (architecture decision records)
- docs/_local/ (gitignored working state)

Moderate tier projects typically get the **full template** (see phase-1.md).

**Skills available:** everything, including /check-in with full enforcement.

### Large

**When:** complex domain, multiple teams, extensive conventions.
Example: an enterprise platform, a multi-service system.

**What you get:**
- Everything from Moderate, with expanded conventions:
  - ## Conventions section in CLAUDE.md references a conventions/ folder for detailed rules
  - conventions/naming.md
  - conventions/decomposition.md
  - conventions/testing.md
  - conventions/review.md
- Full docs tree with all subdirectories

**Skills available:** everything with full enforcement.

## Tier selection guidance

/setup should not cold-ask "which tier?" with a dropdown.
Instead, open conversationally - ask what the user is building, how many people are involved, how complex the domain is.
Then recommend a tier based on the answers.

| Signal | Small | Moderate | Large |
|--------|-------|----------|-------|
| Team size | 1 | 2-5 | 5+ |
| Entity count | < 5 | 5-30 | 30+ |
| Domain complexity | Simple | Moderate | Deep business rules |
| Expected lifespan | Weeks-months | Months-years | Years |
| Convention drift risk | Low | Medium | High |

These are heuristics, not rules.

## Tier transitions

Tiers are not permanent.
Re-run /setup to upgrade or downgrade.

**Upgrade (Small -> Moderate):**
- /setup detects the existing CLAUDE.md with minimal sections
- Asks about new sections (## Scope, ## Conventions, ## Deployment, etc.)
- Adds sections to CLAUDE.md and generates docs/_GLOSSARY.md, docs/decisions/
- Existing content in CLAUDE.md is preserved

**Upgrade (Moderate -> Large):**
- /setup reads existing CLAUDE.md ## Conventions section
- Proposes extracting detailed conventions into a conventions/ folder
- CLAUDE.md ## Conventions references the folder
- Updates ## References section

**Downgrade (Large -> Moderate):**
- /setup consolidates conventions/ folder back into CLAUDE.md ## Conventions section
- No data loss - content is merged, not deleted
