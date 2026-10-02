---
name: improve-codebase-architecture
description: "Find deepening opportunities informed by domain language and ADRs. Consolidate modules, improve testability."
status: stable
---

Follow [process/architecture-review.md](../../process/architecture-review.md). Execute each phase with available tools.

Phase 1 - Explore: Use Agent(subagent_type=Explore). Read glossary + ADRs first. See [language.md](reference/language.md).

Phase 2 - Present: HTML report to OS temp dir (Tailwind + Mermaid CDN). Before/after cards per candidate. See [html-report.md](reference/html-report.md). Open for user, ask which to explore.

Phase 3 - Deepen: See [deepening.md](reference/deepening.md) and [interface-design.md](reference/interface-design.md). Spawn 3+ parallel agents with different constraints. New term -> GLOSSARY.md. Rejected candidate with reason -> offer ADR.

Does NOT refactor. Identifies and proposes.

## Exit
- High-priority proposal -> "/spec to formalize."
- Proposals affect architecture -> "/grill-with-docs for ADR."
- Run shared exit sequence: see [the exit sequence](../../internals/engagement/README.md#exit-sequence).

## Engagement
See engagement protocol.
