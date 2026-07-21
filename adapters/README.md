# Tool Adapters

Thin files that connect tool-agnostic process docs to specific AI coding tools.
Each adapter points to a process doc and translates execution idioms.

## Architecture

```
process/debugging.md          <-- methodology (tool-agnostic)
  |
  +-- task/diagnose/SKILL.md   <-- Claude Code adapter (43 lines)
  +-- adapters/cursor/         <-- Cursor adapter (.mdc)
  +-- adapters/opencode/       <-- OpenCode adapter (skill format)
  +-- adapters/codex/          <-- Codex adapter (AGENTS.md fragment)
```

All adapters reference the same process doc.
The process doc is the source of truth for the methodology.
Adapters only contain tool-specific execution notes.

## Installation per tool

### Cursor

Copy `adapters/cursor/diagnose.mdc` to your project's `.cursor/rules/diagnose.mdc`.
The file uses "Agent Requested" mode - Cursor's agent reads the description and activates it when debugging.

### OpenCode

OpenCode reads `.claude/skills/` natively.
If waypoint-skills is installed as a Claude Code skill family, the existing `diagnose/SKILL.md` works without changes.
For standalone use: copy `adapters/opencode/diagnose.md` to `.opencode/skills/diagnose/SKILL.md`.

### Codex

Add the contents of `adapters/codex/diagnose.md` to your project's `AGENTS.md` (or a subdirectory `AGENTS.md`).
Watch the 32KiB combined budget - keep AGENTS.md lean.

## Capability comparison

| Capability | Claude Code | Cursor | OpenCode | Codex |
|-----------|-------------|--------|----------|-------|
| Process doc reference | Read tool | @file inline | @file / Read tool | "Read this file" |
| Ask user questions | AskUserQuestion | Native ask tool | Conversational only | ask_user_question (TUI) |
| Subagents | Agent tool | @mention / subagents | @mention / Task tool | None |
| Structured output | ReportFindings | Markdown convention | Markdown convention | Markdown convention |
| Engagement tiers | design/ENGAGEMENT-REFERENCE.md | Manual check | Manual check | Manual check |

## Writing adapters for other skills

Each adapter needs three things:

1. **Reference the process doc.** Point to it using the tool's native file-reference mechanism.
2. **Translate interaction idioms.** Map "show hypotheses to user before testing" to whatever interactive mechanism the tool supports.
3. **Note capability gaps.** If the tool lacks subagents, say "work inline." If it lacks structured output, describe a markdown format.

A good adapter is 25-45 lines. If it's longer, methodology is leaking into the adapter.
