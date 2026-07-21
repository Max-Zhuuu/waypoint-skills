# Waypoint Skills

A collection of engineering skills that guide you through common software tasks - debugging, writing specs, test-driven development, architecture review, and project management.

Each skill is a structured methodology.
You can follow them as a human with a checklist, use them with an AI coding tool, or run them fully automated.

## What you get

**Task skills** - invoke when you need one:

| Skill | What it does |
|-------|-------------|
| `/diagnose` | Structured debugging: build a feedback loop, hypothesize, instrument, fix, regression test |
| `/spec` | Grill requirements until they're sharp, output a spec file with acceptance criteria |
| `/tdd` | Test-driven build: plan slices, tracer bullet, incremental red-green-refactor |
| `/port` | Migrate a screen from a legacy system: read source, build, verify parity |
| `/grill-me` | Open-ended interview on any plan or decision |
| `/grill-with-docs` | Architecture decisions that meet the ADR threshold |
| `/improve-codebase-architecture` | Surface architectural friction, propose structural improvements |
| `/learn` | Explore a topic with options, terminology bridging, quiz |
| `/prototype` | Quick throwaway mockup to validate an idea |
| `/create` | Add a feature end-to-end: spec, build, wrapup |

**Project skills** - for ongoing work across sessions:

| Skill | What it does |
|-------|-------------|
| `/check-in` | Start-of-session: reads project state, proposes what to work on next |
| `/wrapup` | End-of-task: resolves discrepancies, updates shared docs |
| `/reorient` | Course correction: audits progress, surfaces deferred decisions, re-prioritizes |
| `/project-setup` | One-time: establishes scope, conventions, and doc structure |
| `/migrate` | Multi-phase workflow for replacing a legacy system |
| `/buildout` | Multi-phase workflow for building a new product |

## Install

### Claude Code

```bash
npx skills add max-zhu-bv/waypoint-skills
```

Invoke any skill directly:

```
/diagnose flaky-test
/spec VesselParticulars
/tdd CreateVessel
```

### OpenCode

OpenCode reads `.claude/skills/` natively, so the Claude Code install works as-is.
For standalone use, copy adapters from `adapters/opencode/` to `.opencode/skills/{name}/SKILL.md`.

### Cursor

Copy adapter files from `adapters/cursor/` to `.cursor/rules/` in your project.
Each `.mdc` file uses Agent Requested activation - Cursor's agent reads the description and applies it when relevant.

### Codex

Add the contents of files in `adapters/codex/` to your project's `AGENTS.md`.
Keep AGENTS.md lean - Codex has a 32KiB combined instruction budget (configurable in `~/.codex/config.toml`).

### No AI

Read the process documents in `process/` directly.
They are the complete methodology without any tool-specific instructions.

## Process documents

The methodology behind each skill is a standalone document that works without any AI tool:

| Document | What it covers |
|----------|---------------|
| [process/debugging.md](process/debugging.md) | 7-phase debugging discipline: feedback loop, reproduce, hypothesize, instrument, fix, cleanup, learn |
| [process/requirements.md](process/requirements.md) | Scope grilling, acceptance criteria, trade-off presentation, spec writing |
| [process/tdd.md](process/tdd.md) | Vertical slice planning, tracer bullet, incremental red-green-refactor |
| [process/architecture-review.md](process/architecture-review.md) | Vocabulary, principles, explore-present-deepen-record |
| [process/learning.md](process/learning.md) | Scoped learning with options, terminology bridging, reinforcement |

Each ends with an "Adapting to your context" section covering solo developer, team, AI-assisted, and AI agent modes.

The AI skill files (e.g., `diagnose/SKILL.md`) are thin adapters that reference these documents and add tool-specific execution notes.

## Tracking with Concerns

Skills can optionally track what a project doesn't know yet, is assuming, or has flagged as wrong - in a single file called `CONCERNS.md`:

```markdown
### C-041 [open] Should vessel status transitions require confirmation?
type: question | raised: 2026-07-18
WPF app has a confirmation dialog. Our implementation doesn't. Intentional or gap?
```

Skills read from and write to this file. Humans read from and write to this file.
It is a markdown document - no special tooling required.

You don't need CONCERNS.md to use the skills.
Task skills (/diagnose, /spec, /tdd) work standalone.
Project skills (/check-in, /wrapup, /reorient) become more useful when concerns exist to operate on.

See [CONCERNS-FORMAT.md](CONCERNS-FORMAT.md) for the full specification.

## How skills adapt

Skills meet you where you are:

**Just working** - invoke a skill, it works. At the end it may suggest tracking something it discovered. If you say no, nothing changes.

**Tracking** - CONCERNS.md exists. /check-in reads it and proposes what to work on. /wrapup resolves concerns after implementation. /project-setup is available when you want more structure.

**Automated** - skills emit concerns silently during work, resolve what they can, surface only what needs human judgment.

These tiers emerge from usage. You never select one.

## Design properties

- **Memoized** - decisions persist across sessions and agents
- **Reentrant** - re-running a skill is always safe
- **Self-healing** - broken references get caught and offered for repair
- **Bias to action** - skills infer when they can, ask only at genuine forks

## Reference

- [CONCERNS-FORMAT.md](CONCERNS-FORMAT.md) - Tracking format specification
- [CONCEPTS-REFERENCE.md](CONCEPTS-REFERENCE.md) - Documentation Map, Resolution Cascade, Single-Writer, naming classes
- [ENGAGEMENT-REFERENCE.md](ENGAGEMENT-REFERENCE.md) - Tier detection, nudge protocol, concern emission rules
- [adapters/](adapters/) - Cursor, OpenCode, and Codex adapter files
- [process/](process/) - Standalone methodology documents

## Multi-phase workflows

/migrate and /buildout have phase tracking for large efforts.
These are optional - you can start with /create and upgrade later if scope warrants it.

| Workflow | Phases | When to use |
|----------|--------|-------------|
| /migrate | 7 phases (docs sprint through cutover) | Replacing an existing system |
| /buildout | 4 phases (discovery through iterate-and-ship) | Building a new product |
| /create | No phases | Adding features to an existing codebase |
