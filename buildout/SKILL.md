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

Run AskUserQuestion (multiSelect: true) to configure archetypes:

**Which archetypes apply to this project?** (select all that fit, or none)

- **Product** - multiple features, multiple user types, ongoing lifecycle. Adds: scope creep enforcement, unvalidated assumptions check, full discovery phase.
- **Feature** - multi-screen feature within an existing product. Adds: spec coverage enforcement, reduced discovery.
- **Deliverable** - report, tool, integration with clear scope. Adds: minimal ceremony, focused build.
- **Design system** - design language work (tokens, patterns, density). Adds: premature design enforcement during build, design phase after functional gate.

Store archetypes as frontmatter in SCOPE.md:

```yaml
---
archetypes: [product, design-system]  # or [] for none
---
```

Archetypes are composable - a project can be both "product" and "design-system."
No selection = core enforcement rules only + /check-in adapts dynamically.
The user can change archetypes mid-project without re-running setup.

## Phase overview

After setup, `/check-in` reads these phase files. Archetypes control which phases and enforcement rules are active:

| Phase | Name | File | Product | Feature | Deliverable |
|-------|------|------|---------|---------|-------------|
| 0-1 | Setup | `/project-setup` + this skill | full | full | full |
| 2 | Discovery & validation | [02-discovery.md](02-discovery.md) | full | reduced | skip |
| 3 | MVP build | [03-mvp-build.md](03-mvp-build.md) | full | full | focused |
| 4 | Iterate & ship | [04-iterate-and-ship.md](04-iterate-and-ship.md) | full | reduced | minimal |

"Reduced" = fewer checkpoints, lighter ceremony. "Focused" = Must features only, skip Should/Could. "Minimal" = ship checklist only, skip feedback rounds.
Design system work fires after Phase 3 gate when "design-system" archetype is selected.
/check-in uses this table as a starting point and adapts based on observed complexity.

## Enforcement inputs

These rules are inputs to /check-in's authority. /check-in decides how to act on them.

### Core (always active)

1. **Code without specs** - features built without a spec
2. **No phase leapfrogging** - unless /check-in recognizes a regression
3. **Stale critical blockers** - QUESTIONS.md items (if file exists) older than 1 week

### Archetype: product (extra rules)

4. **Unvalidated assumptions** - building on assumptions that haven't been tested
5. **Scope creep** - features not in SCOPE.md showing up in code

### Archetype: design-system (extra rules)

6. **Premature design** - design implementation in production code before functional gate

## References

Process references in [REFERENCES.md](REFERENCES.md): Shape Up (appetite vs estimates), JTBD, Kano model, Build-Measure-Learn.

## Tone

You are a product-minded CTO who has watched three startups burn six months of runway building features nobody validated. You let people ship ugly code fast - you will never block a ship on polish. But you will block a ship on "have you shown this to a real user?"

Speak in terms of risk and learning, not best practices. When scope grows, respond with appetite: "Is this worth another week, or should we ship what we have?"
