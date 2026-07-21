# Waypoint Skills

Engineering methodology for building software products.
Works standalone as process documentation, with manual tracking, or fully automated through AI agents.

## Install (Claude Code)

```bash
npx skills add max-zhu-bv/waypoint-skills
```

Then invoke any skill directly. No setup required.

```
/diagnose flaky-test       # disciplined debug loop
/spec VesselParticulars    # grill requirements, output spec
/tdd CreateVessel          # test-driven build
```

## How It Works

### The substrate: Concerns

Every project accumulates unknowns, assumptions, and flags.
Waypoint tracks these in a single flat file - `CONCERNS.md` - where each entry has an ID, a status, and a type:

```markdown
### C-041 [open] Should vessel status transitions require confirmation?
type: question | raised: 2026-07-18
WPF app has a confirmation dialog. Our implementation doesn't. Intentional or gap?
```

Skills read from and write to this file.
Humans read from and write to this file.
No special tooling required - it is a markdown document.

See [CONCERNS-FORMAT.md](CONCERNS-FORMAT.md) for the full specification.

### Three engagement tiers

Tiers emerge from usage. You never select one.

**Tier 1 - Just working.**
Invoke a skill. It works.
At the end, the skill may suggest tracking something: "This bug revealed an undocumented business rule about vessel status transitions. It affects 3 other views. Worth tracking?"
If yes, it emits one concern. If no, nothing changes.

**Tier 2 - Tracking.**
CONCERNS.md exists and has content.
/check-in reads it and proposes what to work on next.
/wrapup resolves concerns after implementation.
Discovery (/project-setup) is available when you want to think bigger - not as a gate, but as an option: "You have 8 assumptions, 3 medium-risk with no deadline. Want to do a validation pass?"

**Tier 3 - Automated.**
For practitioners who already know why tracking matters.
Skills emit concerns silently during work, resolve them where they can, and surface only what needs human judgment.
Suggestions shift from "track this?" to "I notice you've manually resolved 4 spec-drift concerns this week. Want me to add a drift check to your commit hook?"

### Process documents

The engineering methodology behind each skill is extracted into standalone documents that work without AI:

| Document | Covers | Derived from |
|----------|--------|-------------|
| [process/debugging.md](process/debugging.md) | 7-phase debugging discipline | /diagnose |
| [process/requirements.md](process/requirements.md) | Requirements grilling and spec writing | /spec |
| [process/tdd.md](process/tdd.md) | Test-driven development philosophy | /tdd |
| [process/architecture-review.md](process/architecture-review.md) | Codebase architecture assessment | /improve-codebase-architecture |
| [process/learning.md](process/learning.md) | Structured technical learning | /learn |

Each document ends with an "Adapting to your context" section covering solo developer, team session, AI-assisted, and fully automated modes.

The Claude Code skills are thin adapters that reference these documents and add platform-specific execution notes (which tools to use, how to handle user interaction, where to emit concerns).

## Skill Map

### Task layer (standalone verbs)

```
IMPLEMENTATION
  /tdd                    Test-driven build
  /port                   Migration: capture, replicate, verify parity

REQUIREMENTS
  /spec*                  Grill requirements, output spec
  /grill-me               Open-ended interview on any plan or decision
  /grill-with-docs        Architecture decisions that meet the ADR threshold

DIAGNOSTIC
  /diagnose               Disciplined debug loop for hard bugs
  /improve-codebase-architecture  Surface architectural friction, propose deepening

LEARNING
  /learn                  Explore trade-offs with options, terms, quiz

CREATION
  /prototype*             Quick validation mockup (logic, UI, or design)
  /create*                Add a feature to an existing codebase

TRACKER
  /to-issues*             Convert specs to tracker issues
  /triage*                Triage and prioritize backlog

* = bridge skill: works standalone, gains cross-referencing with project docs
```

### Project layer (operations over concerns)

```
SESSION
  /check-in               Read concerns, propose next task
  /wrapup                 Resolve concerns after implementation, cascade to shared docs
  /reorient               Analyze concern stats, emit new flags, re-prioritize

SETUP (optional, not a gate)
  /project-setup          Seed initial concerns, establish conventions and doc structure
  /migrate                Legacy replacement workflow with phase tracking
  /buildout               Greenfield product workflow with phase tracking
```

### Model-invoked (not user-facing)

```
  chrome-devtools-axi     Browser automation via Chrome DevTools
  find-skills             Skill discovery and installation
  author-skill            Guided skill authoring with Waypoint conventions
```

## Design Properties

Four properties shape every skill:

- **Memoized** - decisions persist.
  Your test runner is Vitest? That's written to CLAUDE.md once and never asked again, even across sessions and agents.

- **Reentrant** - re-running is safe.
  Project outgrew flat config files? Re-run /project-setup. It reads what exists, keeps your answers, asks only about the new structure.

- **Self-healing** - broken references get caught.
  Someone deletes CONVENTIONS.md? Next /check-in notices the Documentation Map points to a missing file and offers to fix it.

- **Bias to action** - skills should just work.
  If /spec can infer the naming convention from existing code, it uses it and says what it chose.
  Questions are reserved for genuine forks where either path is reasonable and the wrong one wastes real work.

### The nudge protocol

When a skill discovers something worth tracking, it follows three steps:

1. **What** - state the specific discovery. Not abstract: "Undocumented rule: vessel status requires confirmation before transition."
2. **Why** - state why it matters. Not generic: "This affects 3 other views with status transitions."
3. **Ask** - offer once, respect the answer, never nag.

This protocol appears in the process documents as a human checklist item ("before closing a debugging session, check: did you discover anything that affects other parts of the system?") and in the AI adapters as concern emission logic.

### Decision gates

When a skill asks a question:

**Conversational fallback:** pick "Other" and write "I'm not sure, what would you recommend?" - the agent drops into discussion, explains trade-offs, then re-presents the question.

**Learn-mode elaboration:** ask "what does that mean?" - the agent gives a scoped explainer (key terms, one link), then re-presents the question.

## For Non-AI Users

The process documents in `process/` are the complete engineering methodology without any AI-specific instructions.
Read them as guides. Follow them as checklists. Adapt them to your team's tools.

CONCERNS.md is a markdown file you maintain by hand.
Open it, Ctrl+F for `[open]`, add new entries by copying a header line and changing the ID and text.
No tooling required.

The AI skills are one way to execute the methodology - not the only way.

## Reference

- [CONCERNS-FORMAT.md](CONCERNS-FORMAT.md) - Tracking substrate format specification
- [CONCEPTS-REFERENCE.md](CONCEPTS-REFERENCE.md) - Extended definitions: Documentation Map, Resolution Cascade, Single-Writer, naming classes
- [ENGAGEMENT-REFERENCE.md](ENGAGEMENT-REFERENCE.md) - How skills adapt to engagement tier, nudge protocol, concern emission rules
- [process/](process/) - Standalone engineering methodology documents

## Phase Systems

/migrate and /buildout have phase tracking for large efforts.
These are optional deepening, not prerequisites.

| Workflow | Phases | When to use |
|----------|--------|-------------|
| /migrate | 7 phases (docs sprint through cutover) | Replacing an existing system |
| /buildout | 4 phases (discovery through iterate-and-ship) | Building a new product |
| /create | No phases | Adding features to an existing codebase |

Phase details live in each skill's directory.
You can start with /create and upgrade to /migrate or /buildout later if the scope warrants it.
