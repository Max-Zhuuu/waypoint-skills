---
name: buildout
description: Greenfield product buildout extending /project-setup. Discovery, MVP scoping, iterative build, and ship. Use for new products, hobby projects, side projects, or any build that isn't a migration.
disable-model-invocation: true
---

# Buildout

Extends `/project-setup` with phases for building something new from scratch.
Lighter than `/migrate` - no source system, no parity gates, no doc sprint from legacy code.
Emphasis on validation: are you building the right thing?

## Orientation (print this on every invocation)

```
/buildout - Greenfield product buildout.
  Phase 0-1: Foundation       (handled by /project-setup)
  Phase 2:   Discovery        -> validate the idea before building (02-discovery.md)
  Phase 3:   MVP build        -> smallest thing that proves the concept (03-mvp-build.md)
  Phase 4:   Iterate & ship   -> expand, polish, launch (04-iterate-and-ship.md)

  Key rule: validate before building. Code is the most expensive way to test an idea.
  Key rule: every feature goes through /spec first. No spec, no build.

Related: /spec (feature reqs), /grill-with-docs (ADRs), /reorient (strategic checkpoint), /learn (trade-offs)
```

Then state: current phase, what's been validated so far, and any open risks.

## Prerequisites

`/project-setup` must have been run first. Check for:
- SCOPE.md exists
- DEPENDENCIES.md exists
- CLAUDE.md exists with process definition
- Documentation structure exists

If any are missing, tell the user to run `/project-setup` first. Do not proceed without the foundation.

## How this skill works

1. Detect current phase from project state (docs, git history, existing code).
2. Run enforcement checks (bottom of this file).
3. Report violations before phase work.
4. Check gate criteria. If met: prompt to advance. If not: show blockers.
5. Delegates to: `/spec` for feature requirements, `/grill-with-docs` for architecture decisions, `/learn` for trade-offs, `/reorient` for checkpoints.

## Phase overview

| Phase | Name | File |
|-------|------|------|
| 0-1 | Setup | Handled by `/project-setup` |
| 2 | Discovery & validation | [02-discovery.md](02-discovery.md) |
| 3 | MVP build | [03-mvp-build.md](03-mvp-build.md) |
| 4 | Iterate & ship | [04-iterate-and-ship.md](04-iterate-and-ship.md) |

Read only the file for the current phase. Each file contains detailed instructions and gate criteria.

## Enforcement

On every invocation, before phase work:

1. **Code without specs** - features built without a spec in `docs/specs/`
2. **Unvalidated assumptions** - building on assumptions that haven't been tested
3. **Scope creep** - features not in SCOPE.md showing up in code
4. **Stale questions** - critical QUESTIONS.md items older than 1 week
5. **Phase leapfrogging** - building production code before discovery is done

Report violations first. Require acknowledgment before proceeding.

## Tone

Startup advisor who has seen founders waste months building the wrong thing.
"Are you sure people want this?" before "How should we build this?"
Bias toward shipping something small over planning something big.
