---
name: improve-codebase-architecture
description: Find deepening opportunities in a codebase, informed by the domain language in GLOSSARY.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
status: stable
---

# Improve Codebase Architecture

Follow the architecture review methodology in [process/architecture-review.md](../../process/architecture-review.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Explore

Use the Agent tool with `subagent_type=Explore` to walk the codebase.
Read the project's domain glossary (GLOSSARY.md) and ADRs before exploring.

See [LANGUAGE.md](LANGUAGE.md) for the full vocabulary and principles.

### Phase 2 - Present candidates

Write a self-contained HTML report to the OS temp directory (nothing in the repo).
Use Tailwind via CDN for layout, Mermaid via CDN for dependency/flow diagrams.
Each candidate gets a before/after visualization as a card.
See [HTML-REPORT.md](HTML-REPORT.md) for the HTML scaffold and styling guidance.

Open the file for the user and tell them the absolute path.
Ask: "Which of these would you like to explore?"

### Phase 3 - Deepen

See [DEEPENING.md](DEEPENING.md) for dependency categories and seam discipline.

For interface design alternatives, spawn 3+ parallel agents with different constraints
(minimize interface, maximize flexibility, optimize for common caller, ports & adapters).
See [INTERFACE-DESIGN.md](INTERFACE-DESIGN.md) for the sub-agent pattern.

Side effects happen inline:
- New domain term -> update GLOSSARY.md (see task/grill-with-docs/GLOSSARY-FORMAT.md).
- Rejected candidate with load-bearing reason -> offer an ADR (see task/grill-with-docs/ADR-FORMAT.md).

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** concerns (type: issue, question)
- **Scaffolding writes:** none (task-layer skill)
- **Override:** none
- **Nudge protocol:** detect tier -> suggest setup/upgrade once -> back off if declined
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no file creation outside owned paths, no silent scaffolding, no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

## Exit

When proposals are written, suggest next steps:
- If a high-priority proposal emerged -> "/spec the highest-priority one to formalize scope?"
- If multiple proposals need prioritization -> "/check-in to rank and pick the first target?"
- If proposals affect architecture -> "/grill-with-docs to validate with an ADR?"
