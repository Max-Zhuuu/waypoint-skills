## Concurrency

### Within session

Multiple subagents can run in parallel IF:
- Non-overlapping entity-local files
- No shared file changes in the parallel set

Shared file changes (router config, type exports, shared components) serialize through the main context.

### Cross-session

Cross-session coordination (CONCERNS.md Claims section, file claiming, stale entry policy) is owned by the project's CLAUDE.md and hook infrastructure, not this skill.
/port respects whatever coordination protocol the project defines.
