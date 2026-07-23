# Waypoint Skills

Understand what you're building before you build it.

Most AI-assisted development starts with a prompt and ends with code.
What's missing is the middle - understanding the system you're changing, deciding what to build before building it, and verifying that what you built matches what you decided.

Waypoint skills enforce that middle.
Every skill reads project state before acting and writes decisions down before moving on.
The result is a codebase where decisions are traceable, specs are grillable, and context survives between sessions.

## Getting started

Any skill works standalone - `/diagnose` a bug without project context, `/spec` a feature without a glossary.

But when a skill discovers something worth remembering (a domain term, an assumption, a decision), it offers to write it down.
Say yes and sessions start linking together.
Say no and it moves on.
Structure accumulates when it helps and stays out of the way when it doesn't.

### New to this?

```
you:   /how-to-start

agent: Read: Project has models, routes, and views but no spec docs.
       What are you trying to do?
       /diagnose for bugs, /spec for features, /tdd to build test-first,
       /design for visual system, /learn to understand something.

you:   I need to add notifications to the app

agent: Read: No spec exists for notifications.
       Recommend: /spec - underspecified feature, nail down requirements
       before building.
       Proceed with /spec?

you:   yes

agent: [invokes /spec with "notifications"]
```

### Typical daily session

```
you:   /check-in

agent: 8 endpoints and 4 screens remaining. 2 specs ready to build.
       Concerns: 3 issues (oldest: 4 days), 1 assumption unvalidated
       Next: Invite flow - spec is fresh, the mailer service is wired,
       and the API contract is defined. Build now before it drifts.
```

### Speccing a feature

```
you:   /spec notifications

agent: What problem does this solve?
       My read: users have no way to know when something changes without
       manually checking. Notifications close that feedback loop. Right?

you:   yes, in-app and email for mentions and status changes

agent: Scope for v1:
       In - in-app notification feed, email delivery, mention and status
            change triggers, read/unread state, preference toggles
       Out - push notifications, digest batching, custom trigger rules

       Two trade-offs to decide:
       1. Delivery: queue-based (reliable, handles spikes) vs synchronous
          (simpler, one fewer service)?
          Recommend queue - notifications spike on batch operations and
          synchronous delivery blocks the request.
       2. Storage: dedicated notifications table vs append to activity log?
          Recommend dedicated table - different retention, different
          indexes, simpler queries for the feed endpoint.

you:   agree on both, but add a webhook option to the spec too

agent: [writes spec to docs/specs/notifications.md with acceptance criteria]
```

### Debugging a hard bug

```
you:   /diagnose order total wrong after applying a discount code

agent: Building a feedback loop...
       [reproduces: add 3 items, apply 20% code, total shows full price
        but the discount row appears in the breakdown]

       Reproduced. Three hypotheses, ranked:
       1. Discount is calculated but not subtracted in the total query
       2. Total is cached and the cache isn't invalidated on discount apply
       3. Frontend reads the pre-discount total from a stale API response

       Proceed with this ranking?

you:   1 is most likely, we just refactored the pricing module

agent: Testing hypothesis 1. Adding [DEBUG-7c3a] instrumentation to the
       order total calculation...
       [confirms: discount row inserted but SUM query filters by
        line_type = 'item', excluding type = 'discount']

       Fixed. Root cause: the pricing refactor introduced a line_type
       column but the total query still used a hardcoded WHERE clause
       that only summed item rows.
       Regression test at order_pricing_test.py:142.
```

## Install

### Claude Code

**Plugin** (managed, auto-updates):

```bash
claude plugin install --source https://github.com/max-zhu-bv/waypoint-skills
```

**skills.sh** (copies into your project, editable):

```bash
npx skills add max-zhu-bv/waypoint-skills
```

Either way, invoke any skill directly:

```
/diagnose tests pass locally but fail in CI
/spec user notifications with email and in-app
/tdd checkout flow with discount codes
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

## Skills

### Orient

- **[setup](project/setup/SKILL.md)** - Project kickoff: scoping grill, architecture decisions, doc structure, CLAUDE.md generation. The foundation every other skill builds on.
- **[how-to-start](task/how-to-start/SKILL.md)** - Context-aware skill router. Reads project state, classifies intent, recommends the right skill with a one-line reason.
- **[check-in](project/check-in/SKILL.md)** - Session authority. Reads concerns, proposes next task, fires checkpoints. The daily verb.
- **[reorient](project/reorient/SKILL.md)** - Strategic course correction. Snapshots real project state, surfaces deferred decisions, audits progress. Use when scattered or between milestones.

### Plan

- **[spec](task/spec/SKILL.md)** - Grill requirements until they're precise, then write a spec with acceptance criteria. The gateway to building anything non-trivial.
- **[breakdown](task/breakdown/SKILL.md)** - Decompose a spec into implementable slices with dependency ordering. Each slice maps to one TDD cycle.
- **[grill-me](task/grill-me/SKILL.md)** - Open-ended interview on any plan or decision. Walk down each branch of the design tree, resolving dependencies one by one.
- **[grill-with-docs](task/grill-with-docs/SKILL.md)** - Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates GLOSSARY.md and ADRs inline.
- **[design](project/design/SKILL.md)** - Design system creation in three waves: Soul (product verb, emotional range, competitive audit), Tokens (color, type, spacing, motion), Proof (real screens stress-tested against the tokens).

### Build

- **[tdd](task/tdd/SKILL.md)** - Test-driven development with red-green-refactor loop. Plans slices, fires a tracer bullet, then builds incrementally.
- **[create](task/create/SKILL.md)** - Add a feature end-to-end: spec, build, wrapup. Lighter than /buildout, structured enough to keep docs current.
- **[port](task/port/SKILL.md)** - Migration implementation verb. Reads spec, logic doc, and source system, briefs subagents, reviews output, flags discrepancies.
- **[diagnose](task/diagnose/SKILL.md)** - Disciplined diagnosis loop: reproduce, minimise, hypothesise, instrument, fix, regression-test. For hard bugs and performance regressions.
- **[prototype](task/prototype/SKILL.md)** - Quick throwaway mockup. Routes between a terminal app (state/logic questions), UI variations (toggleable from one route), or a persistent design panel (visual exploration).

### Sustain

- **[wrapup](project/wrapup/SKILL.md)** - Completion verb. Resolves concerns from implementation, cascades to shared docs, evaluates gate criteria.
- **[improve-codebase-architecture](task/improve-codebase-architecture/SKILL.md)** - Surface architectural friction informed by the domain glossary and ADRs. Propose improvements, don't just list problems.
- **[learn](task/learn/SKILL.md)** - Learning-oriented approach to any code task. Presents meaningfully different options with trade-off explanations and terminology bridging.

### Workflows

- **[migrate](project/migrate/SKILL.md)** - Replace an existing system layer by layer across 7 phases (docs sprint through cutover). One-time setup extending /setup, then /check-in drives daily sessions.
- **[buildout](project/buildout/SKILL.md)** - Build a new product across 4 phases (discovery through iterate-and-ship). MoSCoW structure, phase resolution, validation depth tuning.

## How it fits together

```mermaid
stateDiagram-v2
    direction LR

    state "New to this project" as newcomer
    state "Know the codebase" as experienced

    state "Orient" as orient
    state "Plan" as plan
    state "Build" as build
    state "Verify" as verify

    [*] --> newcomer
    [*] --> experienced

    newcomer --> orient : /setup, /how-to-start
    experienced --> build : /diagnose, /tdd, /create

    orient --> plan : /spec, /design
    plan --> build : /breakdown, /tdd, /create, /port
    build --> verify : /wrapup, /check-in
    verify --> orient : gaps found

    experienced --> orient : system nudges
```

Both paths lead to the same place.
If you skip orientation and jump to building, the system catches gaps and nudges you back when it matters - missing domain glossary, unresolved assumptions, specs that drifted from the code.

## Principles

```mermaid
mindmap
  root((Waypoint))
    Decide before building
      Spec before code
      Grill before spec
      Scope before grill
    Write decisions down
      GLOSSARY.md for terms
      ADRs for trade-offs
      CONCERNS.md for unknowns
    Structure accumulates
      On-demand first
      Connected when useful
      Autonomous when natural
    Verify against source
      Never fabricate
      Cross-reference always
      Flag discrepancies
```

## Changelog

| Version | Change |
|---------|--------|
| v2.1 | Naming convention picker in /setup (underscore-prefixed vs clean names). Root-level docs/ enforcement. |
| v2.0 | Three-tier doc layout (program/ + implementation/ + _local/). CONTEXT.md renamed to _GLOSSARY.md. Concern type `flag` renamed to `issue`. `deadline:` renamed to `validate-by:`. |
| v1.0 | Initial release. 20 skills, concerns tracking, engagement model, process/adapter split. |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how the system works internally: the process/adapter split, concerns tracking, engagement tiers, and the skill directory structure.

## Reference

- [CONCERNS-FORMAT.md](CONCERNS-FORMAT.md) - Tracking format specification
- [process/](process/) - Standalone methodology documents (no AI required)
- [adapters/](adapters/) - Cursor, OpenCode, and Codex adapter files
- [internals/](internals/) - System design docs (concepts, engagement model)
