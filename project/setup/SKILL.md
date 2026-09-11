---
name: setup
description: "Kickoff a project with scoping grill, architecture decisions, and documentation structure. Handles fresh builds, migrations, and resumptions."
status: stable
---

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Handles fresh builds, migrations, resumptions, and restructuring - detected automatically from project state.

Does NOT: implement features, build code, or run tests. Setup produces decisions and documentation.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md).
Emits: concerns (type: assumption, question)
Writes: CLAUDE.md, SCOPE.md, CONVENTIONS.md, TESTING.md, ARCHITECTURE.md, DEPLOY.md, .claude/
Override: scaffolding creator - creates the files other skills read

## Exit
- /check-in for first working session.
- /breakdown to decompose initial scope into slices.

## Tone
Direct. Cut scope aggressively in Phase 0. Challenge vague answers. For migrations: every source feature is accounted for.
