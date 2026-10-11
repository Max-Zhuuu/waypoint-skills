# Contributing

How waypoint-skills works internally.
Read this to understand the architecture, add a skill, or modify the system.

## Architecture: JSON-first (v3)

Every skill has two files:

1. **`skill.json`** - the source of truth. Steps, checklists, chain edges, capabilities, engagement declarations, safety rails. Machine-readable, test-validated.
2. **`SKILL.md`** - the bootloader. ~15-20 lines loaded by Claude Code on invocation. Points to skill.json, declares boundaries, engagement block, exit targets, tone.

A third layer - **process docs** (`process/*.md`) - holds tool-agnostic methodology. Not every skill has one.

| Layer | What it holds | Authoritative for |
|-------|--------------|-------------------|
| `skill.json` | Steps, checklists, chain, capabilities, engagement | Structure, dependencies, enterprise features |
| `SKILL.md` | Frontmatter, bootstrap, boundaries, tone | Identity, invocation, human context |
| `process/*.md` | Methodology (debugging, TDD, requirements) | How the work is done, tool-agnostic |

## Directory structure

```
task/           # Skills that do work (triage, spec, breakdown, tdd, diagnose, review, etc.)
project/        # Skills that manage projects (setup, check-in, wrapup)
design/         # Skills that design on a canvas (design, prototype)
in-progress/    # Skills in active development
third-party/    # Wrappers around external skills (no skill.json)
skill-categories.txt  # The one list of skill categories
process/        # Tool-agnostic methodology documents
schemas/        # JSON schemas (skill validation, output formats, safety rails)
tests/          # Test suite (scripts + helpers)
templates/      # Shared file templates (feature specs, logic docs, glossary)
internals/      # System design docs (engagement model, chain dispatcher, concepts)
adapters/       # Platform-specific adapters (cursor, opencode, codex)
deprecated/     # Retired skill SKILL.md files (phase/reference docs may stay in original location)
```

## skill.json schema

Every `skill.json` validates against `schemas/skill.schema.json`.
Required fields:

```jsonc
{
  "$schema": "../../schemas/skill.schema.json",
  "name": "skill-name",        // kebab-case, must match directory name
  "status": "stable",          // stable | draft | experimental | deprecated
  "description": "One line.",  // must match SKILL.md frontmatter

  "chain": {
    "from": ["upstream-skill"],
    "to": [{ "target": "downstream", "type": "clean", "guard": "GUARD_EXPR" }]
  },

  "steps": [{
    "id": "step-id",           // kebab-case, unique within skill
    "name": "Human name",
    "instruction": "What the agent does.",
    "enterprise": false,       // true = skip when no enterprise artefacts
    "reads": ["FILE.md"],      // project-relative or skill-relative
    "process": "process/X.md", // shared-infra-relative
    "references": ["reference/X.md"],  // skill-directory-relative
    "checklist": ["Item to verify before advancing"],
    "per_cycle_checklist": ["Item checked on every iteration"]
  }],

  "safety_rails": { "banned_ops": [...], "on_banned": "print_for_user" },

  "capabilities": {
    "scope_protection": false,
    "safety_rails": false,
    "convention_enforcement": false,
    "enterprise_context": false,
    "catalogue_grill": false
  },

  "engagement": {
    "emits": ["concerns"],
    "writes": ["artifact name"],
    "override": "commit-producing",
    "manifest": true,
    "chain_dispatch": true
  },

  "tone": "One sentence."
}
```

## SKILL.md bootloader contract

~15-20 lines. CI warns >80, fails >100. Every token costs on every invocation.

```markdown
---
name: skill-name
description: "One line."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Process methodology: [process/X.md](../../process/X.md).

Does NOT: {boundary, only if non-obvious}

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: {from skill.json}
Writes: {from skill.json}
Override: {if declared}

## Exit
- {2-4 handoff targets from skill.json chain}

## Tone
{from skill.json}
```

**Rules:**
- No H1 header. Frontmatter `name` + directory is identity.
- Body opens with `Read [skill.json]` - the bootstrap instruction.
- All structural content (steps, checklists, reads) lives in skill.json.
- `## Engagement`, `## Exit`, `## Tone` are mandatory.
- Frontmatter `status` must match skill.json `status` (test-enforced).

## Frontmatter schema

```yaml
---
name: skill-name                    # Required. Kebab-case.
description: "One-line description" # Required.
status: stable | draft | experimental | deprecated  # Required.
user-invocable: true | false        # Optional. Default: true.
---
```

## Reference doc policy

| Category | Where it lives | Example |
|----------|---------------|---------|
| Methodology (how to do X) | `reference/*.md` as prose | tests.md, mocking.md, personas.md, catalogue-grill.md |
| Format specs (output shapes) | `schemas/*.json` | slice-format.json, glossary-format.json |
| Procedures (step-by-step) | Inlined into skill.json `steps[].instruction` and `checklist` | archive procedure, cascade rules |
| Routed conditionals (one-at-a-time) | `phases/*.md` or `reference/*.md` | phase-1.md, restructuring.md, resume-path.md |
| Trust-critical (shared by multiple skills) | `reference/*.md` as prose | settings.md, slice-marker.md |

Process docs use `../../process/` from SKILL.md.
Per-skill references use `reference/` from SKILL.md.
Both resolve in repo and installed layouts because SKILL.md sits exactly two levels above shared-infra root (the flatten invariant).
**Process docs cannot reference `../../templates/`** in installed layout - templates referenced from SKILL.md only.

## Chain

Edge data lives in each skill.json `chain` field.
`internals/chain/reference.md` defines guard vocabulary, dispatch semantics, and three hardening rules.
`tests/test_chain.py` assembles the full graph and validates it.

**Core chain (v3):**
```
triage -> spec -> breakdown -> tdd -> review
            \-> diagnose (bugs)           |-> wrapup
```

**Guard vocabulary:** `SPEC`, `SLICED`, `REM`, `NEXT_HITL`, `TRIAGED`, `BUG`, `CONC`, `REVIEWED`.
**Edge types:** `clean` (auto-advance possible), `gate` (always stops for human).
**Hardening:** R1 (backward edges = gates), R2 (repo tags add caution only), R3 (review entry clean, exit always gate).

## Enterprise auto-detect

Steps with `"enterprise": true` are skipped when no enterprise artefacts exist.
Enterprise artefacts: architecture rule catalogues, endpoint registries, parity verification systems, SCOPE.md scope-protection directives, CLAUDE.md phase-aware constraints.
Detection is per-step, not per-skill. A skill can mix enterprise and non-enterprise steps.

## Content ownership

Every piece of content has exactly one authoritative location.
skill.json declares structure. SKILL.md declares identity and human context.
Neither restates the other. Tests enforce the match.

| Content | Authoritative location | Tests verify |
|---------|----------------------|-------------|
| Steps, checklists | skill.json | test-skill-json |
| Chain edges | skill.json | test-chain |
| Capabilities | skill.json | test-enterprise |
| Engagement fields | skill.json (SKILL.md declares for invocation) | test-engagement |
| Status | skill.json = SKILL.md frontmatter | test-skill-json |
| Tone, boundaries, exit | SKILL.md | (human review) |
| Guard semantics | internals/chain/reference.md | (human review) |
| Review safety | internals/engagement/review-safety.md | (human review) |
| Autonomy axis | internals/engagement/autonomy.md | (human review) |

## Test suite

It replaces the retired `lint-skills.sh`.
All scripts live in `tests/` and use `json_query.py` (Python stdlib, no external deps).

| Script | What it checks |
|--------|---------------|
| `test-categories.sh` | `skill-categories.txt` is the only category list; plugin.json and CI match the tree |
| `test-skill-json.sh` | Every skill dir has skill.json, required fields present, name/status match SKILL.md |
| `test-links.sh` | All reference paths in skill.json resolve in repo layout |
| `test-chain.sh` | Graph assembled from skill.json is connected, targets exist, no clean-edge cycles |
| `test-line-budget.sh` | SKILL.md: fail >80; SKILL.md + skill.json: warn >120, fail >150; max 8 steps |
| `test-engagement.sh` | SKILL.md engagement block present, manifest/chain citations when declared |
| `test-enterprise.sh` | Capability=true implies enterprise steps exist with reads |
| `test-process-docs.sh` | All process doc refs in skill.json resolve on disk |

Run locally: `for t in tests/test-*.sh; do bash "$t"; done`
CI: `.github/workflows/test-skills.yml` triggers on PRs touching skill/schema/test/process files.

## Skill topology (v3)

| Skill | Role | Status |
|-------|------|--------|
| `/triage` | Read backlog, categorize, route to verb | **new** |
| `/check-in` | Load context, report state, --deep mode | repurposed (absorbs /reorient) |
| `/spec` | Requirements grill | active |
| `/grill-with-docs` | Domain grilling, catalogue-driven when catalogue exists | active |
| `/breakdown` | Decompose into slices | active |
| `/tdd` | Test-first development | active |
| `/diagnose` | Bug debugging | active |
| `/review` | Code critic | active |
| `/wrapup` | Completion, scope validation | active |
| `/setup` | Project kickoff (fresh, migration, resume) | active (absorbs /migrate) |
| `/prototype` | Throwaway prototypes, variant switcher | active |
| `/create` | - | **deprecated** |
| `/buildout` | - | **deprecated** |
| `/reorient` | - | **deprecated** (in /check-in --deep) |
| `/migrate` | - | **deprecated** (in /setup migration mode) |

## Engagement model

How the system deepens over time (unchanged from v2):

**On demand** - invoke a skill, it does the work, done.
**Connected** - concerns flow, `/check-in` reads what's open.
**Autonomous** - skills emit, resolve, surface decisions.

The `## Engagement` section in SKILL.md is a pure declaration (3-5 lines). Shared protocol lives in `internals/engagement/README.md`.
The `Writes:` line is enforced by test: if skill.json `engagement.writes` is non-empty, SKILL.md `Writes:` must not say `none`.

## The outbound seam

`/ship` (deprioritized) is the one outbound verb. Two invariants:
- Waypoint proposes, the target disposes. `/ship` never holds merge authority.
- Intent is spec-derived, never diff-derived.

## Review safety invariant

Five crossings prevent untrusted repo text from steering later turns.
Defined in `internals/engagement/review-safety.md`. Every skill touching review must obey them.

## Branching

- `main` - stable, deployed via `sync-skills.ps1`.
- `revisions` - local development, specs, drafts.

## Local development

```bash
git clone git@github.com:max-zhu-bv/waypoint-skills.git
.\sync-skills.ps1       # Windows: deploy to ~/.claude/ via junctions
bash sync-skills.sh      # macOS/Linux: deploy to ~/.claude/ via copies
for t in tests/test-*.sh; do bash "$t"; done  # run test suite
```

Skill categories are listed once, in `skill-categories.txt` (`task/`, `project/`, `design/`, `in-progress/`).
Tests, both sync scripts and CI read that file, and `tests/test-categories.sh` fails if a hard-coded copy appears or `plugin.json` drifts from the tree.
To add a category, add a line there and a `paths` entry in `.github/workflows/test-skills.yml`.

The sync scripts flatten skills from every category and `third-party/` into `~/.claude/skills/`, link or copy shared infrastructure (`internals/`, `templates/`, `process/`, `schemas/`, `tests/`, `scripts/`) into `~/.claude/`, and copy root files into `~/.claude/skills/`.

### The flatten invariant

A skill's `../../internals/X.md` link resolves in both repo and installed layouts only because SKILL.md sits exactly two levels above the shared-infra root.
No skill may nest deeper than `{group}/{name}/SKILL.md`.
`tests/test-links.sh` enforces link resolution in the repo layout; installed-layout validation is a planned follow-up.

## Design references

- [internals/CONCEPTS-REFERENCE.md](internals/CONCEPTS-REFERENCE.md) - Documentation Map, Resolution Cascade, naming classes
- [internals/engagement/README.md](internals/engagement/README.md) - Tier detection, concern emission, shared spine
- [internals/engagement/manifest.md](internals/engagement/manifest.md) - Artifacts manifest
- [internals/engagement/autonomy.md](internals/engagement/autonomy.md) - Autonomy axis (afk/hitl)
- [internals/engagement/review-safety.md](internals/engagement/review-safety.md) - Review safety (five crossings)
- [internals/chain/reference.md](internals/chain/reference.md) - Chain dispatcher (guard vocabulary, hardening rules)
- [internals/enforcement-core.md](internals/enforcement-core.md) - Phase regression, gate override patterns
- [process/convention-enforcement.md](process/convention-enforcement.md) - Test-enforced conventions, ratchets, hooks
- [schemas/skill.schema.json](schemas/skill.schema.json) - skill.json validation schema
- [schemas/safety-rails.json](schemas/safety-rails.json) - Banned operations, branch rules
