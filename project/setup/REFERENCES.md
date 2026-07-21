# Project Setup References

Reference material for `/setup` Phase 1.
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
A hook injects the Claims section from CONCERNS.md into every prompt so all sessions see claimed files.

**When to offer:** Phase 1, after CLAUDE.md generation. Strongly recommended for any project that will use parallel sessions.

**Claims format** lives in CONCERNS.md (see [../../CONCERNS-FORMAT.md](../../CONCERNS-FORMAT.md#claims-section)):
- Agents register a claim before their first file modification
- Claims are session-lifetime, stale after 4 hours
- Claims share the C-NNN ID space with other concerns

**Hook** - merge into `.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'FILE=\"docs/local/CONCERNS.md\"; if [ -f \"$FILE\" ]; then echo \"# Concerns\"; sed -n \"/^## Claims/,/^## [^C]/p\" \"$FILE\" | head -n -1; sed -n \"/^## Open/,//p\" \"$FILE\"; else echo \"No concerns file at $FILE\"; fi'"
          }
        ]
      }
    ]
  }
}
```

If `.claude/settings.json` already exists, merge the hook entry - do not overwrite existing hooks or settings.
The hook injects claims and open concerns into every agent prompt, so all sessions see claimed files and outstanding issues.

### Pre-Push Build Gate

**Purpose:** Prevents broken builds from reaching shared branches.
Intercepts `git push` commands targeting protected branches and runs the build first. Blocks the push if the build fails.

**When to offer:** Phase 1, alongside the agent coordination hook. Important for any project with a build step.

**Implementation:** Claude Code has no `PrePush` hook event. Use a `PreToolUse` hook on the `Bash` matcher with an `if` filter matching `git push*`. The hook reads the push command, checks if it targets a protected branch, and runs the build.

**Hook** - add to the existing `Bash` matcher's hooks array in `.claude/settings.json`:

```json
{
  "type": "command",
  "if": "Bash(git push*)",
  "command": "bash -c 'read -r INPUT; CMD=$(echo \"$INPUT\" | jq -r \".tool_input.command\" 2>/dev/null); if echo \"$CMD\" | grep -qE \"git push.*(origin )?(main|beta)\"; then echo \"Running build check...\"; npm run build > /dev/null 2>&1; if [ $? -ne 0 ]; then echo \"{\\\"hookSpecificOutput\\\":{\\\"hookEventName\\\":\\\"PreToolUse\\\",\\\"permissionDecision\\\":\\\"deny\\\",\\\"permissionDecisionReason\\\":\\\"Build failed. Push to protected branch blocked.\\\"}}\"; else echo \"Build passed.\"; fi; fi'",
  "timeout": 120,
  "statusMessage": "Build gate..."
}
```

Add the same entry to the `PowerShell` matcher with `"if": "PowerShell(git push*)"`.

Adapt the hook for the project:
- Replace `npm run build` with the project's build command (`pnpm build`, `cargo build`, `dotnet build`, etc.)
- Replace `main|beta` in the grep pattern with the project's protected branch names
- If the project has a type-check step separate from build, chain it: `npm run type-check && npm run build`

## Local Docs Reference

See [LOCAL-DOCS-REFERENCE.md](LOCAL-DOCS-REFERENCE.md) for the canonical docs/local/ structure, file formats, scaling rules, and which skills own each file.
