# Project Setup References

Reference material for `/project-setup` Phase 1.
This file grows as new architecture areas, hooks, and coordination mechanisms are developed.

## Architecture Decision Catalog

Areas available for the G4 gate (multiSelect AskUserQuestion in PHASE-1.md). The agent assembles 6-8 relevant areas based on Phase 0 context and marks 4 as Recommended. Descriptions adapt to the project profile.

| Area | Base description | Surfaces when |
|------|-----------------|---------------|
| Component architecture | Layout patterns, view composition, shared vs local | UI layer detected |
| State management | Store vs composable vs component-local vs URL state | Always (universal) |
| Data fetching | Where fetch calls live, caching, loading/error/empty | External data source |
| Routing | URL structure, navigation model, deep links | UI layer with navigation |
| Styling | Tokens/variables, component styling, responsive strategy | UI layer detected |
| Testing | Layers, minimum bar, structural enforcement | Always (universal) |
| Error handling | User-facing errors, logging, recovery | Always (universal) |
| Mock data strategy | Structure, location, replacement path to real API | API dependency exists |
| Data modeling | Entity relationships, normalization, constraints, schema | Domain entities detected |
| Validation strategy | Where rules live (boundary, domain, DB), composition | User input or business rules |
| Algorithm / computation | Pure vs stateful, streaming vs batch, precision | Computational logic detected |
| Concurrency model | Async patterns, workers, queues, race conditions | Parallel processing needed |
| Observability | Logging strategy, metrics, tracing, alerting | Production service |
| API design | Contract shape, versioning, error format, auth model | Producing an API |
| Security model | Auth, authorization, input sanitization, secrets | User-facing or multi-tenant |

### Description adaptation

Base descriptions are starting points. The agent rewrites them to match the project's Phase 0 profile:
- "Error handling" for a CLI: "Exit codes, user-facing error messages, graceful failure on malformed input"
- "Error handling" for a pipeline: "Retry policies, dead letter queues, partial failure recovery"
- "State management" for a pipeline: "Pipeline state, checkpointing, resume-from-failure"

### Recommended marks by project type

Agent infers from Phase 0 scoping grill answers:
- **UI layer detected:** Component architecture, State management, Data fetching, Testing
- **Backend service:** Data modeling, Validation strategy, API design, Testing
- **Data pipeline:** Data modeling, Concurrency model, Error handling, Observability
- **CLI tool:** Error handling, Testing (only 2 recommended - light ceremony)
- **Full-stack product:** Component architecture, State management, Data modeling, Security model

## Hook Catalog

### Concurrent Agent Coordination

**Purpose:** Prevents file conflicts when multiple agent sessions modify the codebase simultaneously.
Two artifacts work together: a tracker file that agents read/write, and a hook that injects it into every prompt.

**When to offer:** Phase 1, after CLAUDE.md generation. Strongly recommended for any project that will use parallel sessions.

**1. Tracker file** - `docs/local/ACTIVE-WORK.md` (gitignored):

```markdown
# Active Work

Concurrent agent sessions register here to avoid duplicate work and file conflicts.
Read by every agent via the `UserPromptSubmit` hook. Updated by agents during work.
See CLAUDE.md "Concurrent agent protocol" for full instructions.

## Protocol

- **Always read** this file (the hook injects it automatically).
- **Register** before your first file modification (not before - pure discussion sessions skip registration).
- **Update** your entry when you claim new plugins or touch new files.
- **Remove** your entry when the session ends.
- Entries older than 4 hours are considered stale. Ask the user if they should be removed.

## In Progress

<!-- One row per active agent session. Session = first 8 chars of scratchpad UUID. -->

| Session | Slug | Started | Last Update | Working On | Claimed | Files |
|---------|------|---------|-------------|------------|---------|-------|
```

**2. Hook** - merge into `.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=\"docs/local/ACTIVE-WORK.md\"; if [ -f \"$FILE\" ]; then cat \"$FILE\"; else echo \"No active work tracker at docs/local/ACTIVE-WORK.md\"; fi'"
          }
        ]
      }
    ]
  }
}
```

If `.claude/settings.json` already exists, merge the hook entry - do not overwrite existing hooks or settings.
The hook injects the tracker contents into every agent prompt, so all sessions see claimed files before modifying anything.

## Local Docs Reference

See [LOCAL-DOCS.md](LOCAL-DOCS.md) for the canonical docs/local/ structure, file formats, scaling rules, and which skills own each file.
