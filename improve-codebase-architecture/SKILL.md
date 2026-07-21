---
name: improve-codebase-architecture
description: Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
---

# Improve Codebase Architecture

Follow the architecture review methodology in [process/architecture-review.md](../process/architecture-review.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Explore

Use the Agent tool with `subagent_type=Explore` to walk the codebase.
Read the project's domain glossary (CONTEXT.md) and ADRs before exploring.

If scaffolding is missing, follow [ENGAGEMENT-REFERENCE.md](../ENGAGEMENT-REFERENCE.md).

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
- New domain term -> update CONTEXT.md (see grill-with-docs/CONTEXT-FORMAT.md).
- Rejected candidate with load-bearing reason -> offer an ADR (see grill-with-docs/ADR-FORMAT.md).
