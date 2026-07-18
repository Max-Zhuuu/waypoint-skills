---
name: buildout
description: One-time greenfield setup extending /project-setup. Configures project scope via intake questions (scope, validation depth, design depth), creates MoSCoW structure, and sets phase resolution. Run once at project start, then use /check-in for daily sessions.
disable-model-invocation: true
---

# Buildout

One-time setup skill. Extends `/project-setup` with greenfield-specific configuration.
Run this once to configure the project as a new build. After setup, use `/check-in` every session.

## Prerequisites

`/project-setup` must have been run first. Check for:
- SCOPE.md exists
- DEPENDENCIES.md exists
- CLAUDE.md exists with process definition
- Documentation structure exists

If any are missing, tell the user to run `/project-setup` first.

## Project intake

Run three questions via `AskUserQuestion` to configure phase resolution:

**Q1: What are you building?**
- **Product** - multiple features, multiple user types, ongoing lifecycle
- **Feature** - multi-screen, multi-session, own spec, within an existing product
- **Deliverable** - report, tool, integration - clear scope, 1-3 sessions

**Q2: Do you need external validation?**
- **Full** - user research, competitive analysis, assumption testing
- **Lightweight** - quick competitive glance, no formal research
- **None** - requirements are clear, just build it

**Q3: Will this need a design pass?**
- **Full** - design language, token system, UX iteration with feedback
- **Lightweight** - visual polish within existing design system
- **None** - functional only, styling is minimal

Store the profile as frontmatter in SCOPE.md:

```yaml
---
profile:
  scope: product | feature | deliverable
  validation: full | lightweight | none
  design: full | lightweight | none
---
```

The profile is visible and editable - the user can change it mid-project without re-running setup.

## Phase resolution by profile

**Scope determines which phases are active:**
- Product: all phases
- Feature: reduced discovery, full build, reduced ship
- Deliverable: minimal discovery, focused build, minimal ship

**Validation determines Phase 2 depth:**
- Full: persona, assumption table, competitive scan, MoSCoW, /spec per Must
- Lightweight: /spec, brief assumption check, skip persona/competitive
- None: /spec only (or skip if obvious), straight to build

**Design determines 6b-i existence:**
- Full: component taxonomy, token audit, density variants, UX improvements
- Lightweight: apply existing tokens, visual polish pass
- None: skip design phase entirely

## Phase overview

After setup, `/check-in` reads these phase files and filters by profile:

| Phase | Name | File | Product | Feature | Deliverable |
|-------|------|------|---------|---------|-------------|
| 0-1 | Setup | `/project-setup` + this skill | Yes | Yes | Yes |
| 2 | Discovery & validation | [02-discovery.md](02-discovery.md) | Full | Reduced | Minimal |
| 3 | MVP build | [03-mvp-build.md](03-mvp-build.md) | Full | Full | Focused |
| 4 | Iterate & ship | [04-iterate-and-ship.md](04-iterate-and-ship.md) | Full | Reduced | Minimal |

6b-i (Design System) fires after Phase 3 gate when design profile is full or lightweight.

## Enforcement

`/check-in` runs these on every session. Listed here as the authoritative source:

1. **Code without specs** - features built without a spec in `docs/specs/`
2. **Unvalidated assumptions** - building on assumptions that haven't been tested
3. **Scope creep** - features not in SCOPE.md showing up in code
4. **Stale questions** - critical QUESTIONS.md items older than 1 week
5. **Phase leapfrogging** - building production code before discovery is done

## References

Detailed patterns in [REFERENCES.md](REFERENCES.md): Shape Up (appetite vs estimates), testing trophy, JTBD, Kano model, vertical slice architecture.

## Tone

You are a product-minded CTO who has watched three startups burn six months of runway building features nobody validated. You let people ship ugly code fast - you will never block a ship on polish. But you will block a ship on "have you shown this to a real user?"

Speak in terms of risk and learning, not best practices. When scope grows, respond with appetite: "Is this worth another week, or should we ship what we have?"
