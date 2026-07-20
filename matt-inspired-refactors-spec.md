# Matt-Inspired Refactors Spec

Decisions from grill session 2026-07-20. Three changes to the skill family informed by analysis of mattpocock/skills.

## Decisions summary

| # | Decision | Action | File |
|---|---|---|---|
| Q1 | No separate /code-review skill | Strengthen /wrapup instead | wrapup/SKILL.md |
| Q2 | Spec drift check: structural + behavioral | New step 1.5 in /wrapup | wrapup/SKILL.md |
| Q3 | Verify both feature spec and logic doc | Same step 1.5 | wrapup/SKILL.md |
| Q4 | Flag absence when no docs exist | One-line notice, not a blocker | wrapup/SKILL.md |
| Q5 | Update /grill-with-docs | Broader cascade awareness + read-what-exists | grill-with-docs/SKILL.md |
| Q6 | Adaptive project-setup completion | Two templates + /check-in mention | project-setup/SKILL.md |
| Q7 | No Matt skill imports | Revisit /handoff if needed | - |
| Q8 | Keep /migrate and /buildout separate | Revisit after real-world buildout | - |
| Q9 | Hard phase numbering stays | Existing conditionals sufficient | - |

## Changes

### C1: /wrapup spec drift check (Q1-Q4)

**What:** Add step 1.5 "Spec drift check" between current steps 1 (Read flags) and 2 (Resolve each flag).

**Behavior:**
- Read the feature spec sections: Fields & Controls, Interaction Behaviors, Conditional Visibility, Navigation
- Read the logic doc sections: Data Model, Relationships, Status Lifecycle, Business Rules
- Compare each section against what was actually built on disk
- Any unflagged mismatch becomes a new flag, fed into step 2's normal resolution cascade
- If feature spec or logic doc doesn't exist: print one-line notice ("No feature spec found for {entity}. Spec drift check skipped."), continue without blocking

**Why:** /wrapup currently trusts the flags the implementation verb left behind. If /port or /tdd missed a discrepancy, /wrapup won't catch it. This is a documentation-focused safety net, not a code review - it runs same-session (possibly post-compact) and verifies docs match the built artifact.

### C2: /grill-with-docs cascade awareness (Q5)

**What:** Two updates to the supporting-info section.

**Update 1 - Broader cascade:** After "Update CONTEXT.md inline" section, add awareness of other project docs. When a grill decision affects project-wide docs beyond CONTEXT.md, update them inline: CONVENTIONS.md for naming patterns, SCOPE.md for scope changes, DEPENDENCIES.md for dependency status. Read the project's CLAUDE.md for the full doc structure.

**Update 2 - Read what exists:** Replace the hardcoded file structure examples (lines 24-51) with a "read what exists" instruction. If /project-setup has run, the project has a richer doc structure. Check for existing CLAUDE.md, SCOPE.md, CONVENTIONS.md, and docs/ tree. Don't prescribe the layout - discover it.

**Why:** /grill-with-docs currently only knows about CONTEXT.md and ADRs. After /project-setup runs, the project has SCOPE.md, DEPENDENCIES.md, CONVENTIONS.md, TESTING.md, feature specs, logic docs. The skill should cascade to these when relevant.

### C3: Project-setup adaptive completion (Q6)

**What:** Replace the flat "Related:" list (SKILL.md lines 36-39) with an adaptive completion message.

**Template A (source system detected in Phase 0):**
```
Setup complete. You described migrating from {system name}.
  -> /migrate - sets up parity tracking, spec extraction from the source,
     and a phased plan to replace it screen by screen
  -> or invoke /spec, /tdd, /port directly if you already know what to build

If this isn't a migration, /buildout structures a fresh product with
prioritized features and an MVP-first build cycle.

Next session: run /check-in to orient and pick up where you left off.
```

**Template B (no source system):**
```
Setup complete. Ready to start building.
  -> /buildout - structures the work into prioritized features, builds
     an MVP first, then iterates with user feedback
  -> or invoke /spec, /tdd directly if you already know what to build

If you're replacing an existing system, /migrate sets up parity tracking
and phased replacement instead.

Next session: run /check-in to orient and pick up where you left off.
```

**Selection logic:** Agent reads SCOPE.md and Phase 0 conversation. If a source system was discussed (repositories section mentions an existing system, or scope describes replacing/migrating from something), use Template A. Otherwise Template B.

**Why:** The flat list doesn't use Phase 0 context and uses jargon ("greenfield"). The adaptive message recommends based on what was discussed and explains what each skill does in plain terms. /check-in mention fills a real gap - it's the most important skill after setup.
