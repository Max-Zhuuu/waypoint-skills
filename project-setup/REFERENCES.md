# Project Setup References

Hook templates and infrastructure patterns for `/project-setup` Phase 1.
This file grows as new hooks and coordination mechanisms are developed.

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
