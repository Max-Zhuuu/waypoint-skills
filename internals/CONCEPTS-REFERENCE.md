# Concepts Reference

Extended definitions and examples for Waypoint skill family concepts.
The README glossary provides one-line summaries; this file provides the full specification.

## Active Workflow

Record in CLAUDE.md written by a workflow skill (/migrate, /buildout, or /create).

### Format

```markdown
## Active Workflow

| Field | Value |
|-------|-------|
| Skill | /migrate |
| Phase | 4 - Horizontal Buildout |
| Activated | 2026-03-15 |
| Scope | Full VMS frontend replacement |
| Status | Active |
```

### Ownership

- **Written by:** the workflow skill on activation (/migrate, /buildout, /create)
- **Read by:** /check-in (every session), /reorient (drift detection)
- **Updated by:** /check-in (phase transitions), the workflow skill (scope changes)
- **Cleared by:** /wrapup (on project completion)

### Behavior

When no Active Workflow record exists, /check-in detects the project type from SCOPE.md frontmatter and recommends setting one.
/create writes the record but may also function as a single-session orchestrator without one (bridge behavior).

## Bridge Skill

A task-layer skill with project-layer integration points.
Works standalone; gains context when project scaffolding exists.

### Qualification criteria

A skill qualifies as a bridge when it:
1. Has a self-contained core loop that works without any scaffolding
2. Defines specific integration points (what project-layer data it reads or writes)
3. Degrades gracefully per ENGAGEMENT-REFERENCE.md when integration data is missing
4. Never requires project setup to function at its core purpose

### Identified bridge skills

| Skill | Standalone core | Project integration |
|-------|----------------|---------------------|
| /spec | Grill requirements, output spec file | Cross-references SCOPE.md boundaries and CONVENTIONS.md naming |
| /create | Sequence spec -> build -> wrapup | Can write Active Workflow record for multi-session features |
| /to-issues | Convert spec to tracker issues | Chains from /create and /buildout; feeds /check-in backlog |
| /triage | Triage and prioritize backlog | Surfaces ready-for-agent issues as /check-in priority layer |
| /prototype | Quick validation mockup | Integrates with workflow design system phases |

### Skill Map annotation

Bridge skills are marked with `*` in the Skill Map.

## Checkpoint

Named block inside phase files with four fields.
Distinct from gates (end-of-phase go/no-go) and enforcement (per-invocation checks in SKILL.md).

### Format

```markdown
### Checkpoint: {name}

**Trigger:** {when this checkpoint fires - e.g., "before implementation begins", "after spec is written"}
**References:** {files to validate against - e.g., "feature spec, CONVENTIONS.md, source system screen"}
**Action:** {what to do - e.g., "verify spec covers all source system fields", "run parity test suite"}
**Pass condition:** {what "done" looks like - e.g., "all source fields mapped or explicitly excluded in spec"}
```

### Examples

**Pre-build checkpoint (used by /check-in):**

```markdown
### Checkpoint: pre-build

**Trigger:** Before the user starts implementation of a proposed task.
**References:** The verb's frontmatter contract (inputs section), feature spec.
**Action:** Validate each required file exists. Report what's missing.
**Pass condition:** All declared inputs present, spec status is Approved or In Progress.
```

**Post-build checkpoint (used by /check-in):**

```markdown
### Checkpoint: post-build

**Trigger:** After implementation verb completes.
**References:** Feature spec acceptance criteria, CONVENTIONS.md.
**Action:** Review implementation against spec. Check naming conventions. Suggest /wrapup.
**Pass condition:** All acceptance criteria addressed. No convention violations.
```

### Checkpoint vs gate vs enforcement

| Mechanism | Scope | When | Who fires it |
|-----------|-------|------|-------------|
| Checkpoint | Named, per-task | Before/after specific work | /check-in |
| Gate | End-of-phase | Phase transition | /check-in (gate check in priority stack) |
| Enforcement | Per-invocation | Every /check-in run | /check-in (core rules + archetype extras) |

## Documentation Map

Table in CLAUDE.md mapping logical concepts to physical file paths.
Skills resolve references through the map, never hardcoded paths.

### Format

```markdown
## Documentation Map

| Concept | Path | Status |
|---------|------|--------|
| Domain glossary | CONTEXT.md | Active |
| Naming conventions | CONVENTIONS.md | Active |
| Test expectations | TESTING.md | Active |
| Scope boundaries | SCOPE.md | Active |
| Architecture decisions | docs/adr/ | Active |
| Architecture overview | ARCHITECTURE.md | Active |
| Skill state | .claude/ | Active |
```

### Resolution behavior

1. Skill needs a concept (e.g., "Naming conventions")
2. Read Documentation Map from CLAUDE.md
3. Look up the concept -> get path
4. Read the file at that path
5. If file is missing: self-healing triggers (see below)

### Self-healing

When /check-in reads the Documentation Map and finds an entry pointing to a missing file:
- Report the inconsistency in the session summary
- Propose repair: recreate the file, update the map entry, or remove the entry
- Never silently ignore a broken map entry

### Tier-dependent content

The Documentation Map grows with the project tier:

| Concept | Small | Moderate | Large |
|---------|-------|----------|-------|
| Domain glossary | - | CONTEXT.md | CONTEXT.md |
| Naming conventions | - | CONVENTIONS.md | conventions/naming.md |
| Decomposition prefs | - | CONVENTIONS.md (section) | conventions/decomposition.md |
| Test expectations | - | TESTING.md | conventions/testing.md |
| Review standards | - | - | conventions/review.md |
| Scope boundaries | SCOPE.md | SCOPE.md | SCOPE.md |
| Architecture decisions | - | docs/adr/ | docs/adr/ |
| Architecture overview | - | - | ARCHITECTURE.md |
| Skill state | .claude/ | .claude/ | .claude/ |

### Fallback

When no Documentation Map exists (pre-/setup), skills fall back to well-known root paths.
See ENGAGEMENT-REFERENCE.md for tier detection and fallback behavior.

## Naming Classes

Suffix taxonomy for files in the skill family.

| Class | Suffix | Purpose | Examples |
|-------|--------|---------|----------|
| User-facing doc | `FOO.md` | Project documentation authored or consumed by humans | CONVENTIONS.md, CONTEXT.md, SCOPE.md |
| Skill-internal reference | `FOO-REFERENCE.md` | Informs skill behavior, can be surfaced to users during uncertainty | ENGAGEMENT-REFERENCE.md, LOCAL-DOCS-REFERENCE.md, TRACKER-REFERENCE.md |
| Format template | `FOO-FORMAT.md` | Template for user-facing docs | CONTEXT-FORMAT.md, ADR-FORMAT.md |

### Naming rules

- User-facing docs use bare names (no suffix beyond .md)
- Skill-internal references use `-REFERENCE` suffix
- Format templates use `-FORMAT` suffix
- REFERENCES.md (plural, per-skill directory) contains skill-specific reference material that doesn't fit the other classes

## Resolution Cascade

When a checkpoint finds a mismatch (spec vs code, spec vs API, spec vs source system):

1. **Read the authoritative source for ground truth.**
   Example: spec says 12 fields, source system screen shows 14.
   Read the source to determine which is correct.

2. **Write or run a test that proves which side is correct.**
   Example: write a test asserting 14 fields.
   If it passes, the spec is outdated.
   If it fails, the source system documentation is wrong.

3. **Escalate to the user with specifics if source and tests are ambiguous.**
   Example: "Spec says 12 fields, source shows 14.
   Two extra fields (LastModifiedBy, LastModifiedDate) appear in the source but aren't in the spec.
   Are these audit fields we should include?"

Never skip to step 3 without trying steps 1 and 2.
The cascade biases toward machine-verifiable answers before asking the human.

## Write Discipline

Files are classified by write semantics, not by a single-writer rule.
See [ENGAGEMENT-REFERENCE.md](ENGAGEMENT-REFERENCE.md) section 7 for the full file classification table.

### Categories

| Category | Semantics | Who writes | Conflict resolution |
|----------|-----------|------------|-------------------|
| **Shared-append** | Any skill adds entries; never modifies existing | Any skill | Merge by appending |
| **Owned** | One designated writer per section | Designated skill | Owner resolves |
| **Volatile** | Session-scoped, auto-expires | Any skill in session | Last writer wins |

### The append-only contract

The rule isn't "one writer" - it's "append-only during work, modifications through /wrapup."

- /spec can add a term to CONTEXT.md when it discovers one during a grill
- /diagnose can add a convention to CONVENTIONS.md when it notices a pattern
- Neither skill can modify or delete existing entries
- Modifications (corrections, consolidation, conflict resolution) happen in /wrapup

### Machine-readable state

CLAUDE.md sections have designated writers per section:

| Section | Owner | Updated by |
|---------|-------|-----------|
| Project Scaffold | /setup | /check-in (timestamps only) |
| Documentation Map | /setup | /setup (on tier transitions) |
| Active Workflow | Workflow skill (/migrate, /buildout, /create) | /check-in (phase transitions) |
| Canonical branch | Human (in Active Workflow table) | /reorient (flags stale designations) |
| Prose sections (Overview, Dev, Tech Stack) | Human | Human |

### Default for unlisted files

If a file doesn't have a documented write policy, default to Owned.
Only its creator (or /wrapup) should modify it.

## Skill State

The .claude/ directory contains skill-internal state files.
Map-resolvable through the Documentation Map's "Skill State" concept.

### Known state files

| File | Purpose | Written by |
|------|---------|-----------|
| .claude/.setup-prompted | Marker: one-line setup tip has been shown | First task-layer skill invocation |

### Rules

- Skill state files are infrastructure, not documentation
- They are map-resolvable but not user-authored
- They survive across sessions (not gitignored unless the user chooses to)
- Skills create state files lazily on first need
