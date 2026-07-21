# Scope Reference

Reference for /setup tier selection.
Read by /setup when explaining tier options to the user during setup.

## Tiers

### Small

**When:** solo dev, few features, low ceremony.
Example: a CLI tool, a small API, a single-purpose library.

**What you get:**
- CLAUDE.md with Project Scaffold and Documentation Map
- Basic SCOPE.md (summary, in/out/uncertain)
- .claude/ directory for skill state

**What you skip:**
- No CONVENTIONS.md (project is too small for naming drift to matter)
- No TESTING.md (test expectations are self-evident)
- No CONTEXT.md (domain is simple enough to hold in your head)
- No docs/adr/ (decisions are few and obvious)

**Skills available:** all verb skills in degraded mode (no convention enforcement, no domain term cross-referencing). /create works as the workflow. /check-in works with the Active Workflow record.

### Moderate

**When:** standard project, small team, conventions needed.
Example: a web app, a service with an API, a migration project.

**What you get:**
- Everything from Small, plus:
- CONVENTIONS.md (flat file, naming patterns)
- TESTING.md (test expectations by tier)
- CONTEXT.md (domain glossary)
- ARCHITECTURE.md (architecture overview)
- docs/adr/ (architecture decision records)
- docs/implementation/ structure (specs, improvements, handoffs)
- docs/local/ structure (questions, assumptions, active work)
- Full Documentation Map

**Skills available:** everything, including /check-in with full enforcement.

### Large

**When:** complex domain, multiple teams, extensive conventions.
Example: an enterprise platform, a multi-service system, a domain with deep business rules.

**What you get:**
- Everything from Moderate, restructured:
- conventions/ folder replaces flat CONVENTIONS.md
  - conventions/naming.md
  - conventions/decomposition.md
  - conventions/testing.md (moved from TESTING.md)
  - conventions/review.md
- Full docs tree with all subdirectories

**Skills available:** everything with full enforcement.

## Tier selection guidance

/setup should not cold-ask "which tier?" with a dropdown.
Instead, open conversationally - ask what the user is building, how many people are involved, how complex the domain is.
Then recommend a tier based on the answers.

Signals for each tier:

| Signal | Small | Moderate | Large |
|--------|-------|----------|-------|
| Team size | 1 | 2-5 | 5+ |
| Entity count | < 5 | 5-30 | 30+ |
| Domain complexity | Simple | Moderate | Deep business rules |
| Expected lifespan | Weeks-months | Months-years | Years |
| Convention drift risk | Low | Medium | High |

These are heuristics, not rules. A solo dev building a complex domain system might choose Large.
A team of 10 building a straightforward CRUD app might choose Moderate.

## Tier transitions

Tiers are not permanent. Re-run /setup to upgrade or downgrade.

**Upgrade (Small -> Moderate):**
- /setup detects the existing Small scaffold
- Asks about the new files (CONVENTIONS.md, TESTING.md, etc.)
- Generates them and updates the Documentation Map
- Existing decisions in CLAUDE.md are preserved (memoized)

**Upgrade (Moderate -> Large):**
- /setup reads existing flat files
- Proposes the conventions/ folder structure
- Extracts sections from CONVENTIONS.md into separate files
- Moves TESTING.md to conventions/testing.md
- Updates the Documentation Map (skills follow automatically)

**Downgrade (Large -> Moderate):**
- /setup consolidates conventions/ back into flat files
- Updates the Documentation Map
- No data loss - content is merged, not deleted

## Documentation Map generation

After tier selection, /setup generates the Documentation Map in CLAUDE.md.
See [CONCEPTS-REFERENCE.md](../CONCEPTS-REFERENCE.md#documentation-map) for the tier-dependent table and format.
