---
name: improve-codebase-architecture
description: "Find deepening opportunities informed by domain language and ADRs. Consolidate modules, improve testability."
status: stable
---

Follow the architecture review methodology in [process/architecture-review.md](../../process/architecture-review.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Explore

Use the Agent tool with `subagent_type=Explore` to walk the codebase.
Read the project's domain glossary (GLOSSARY.md) and ADRs before exploring.

See [language.md](reference/language.md) for the full vocabulary and principles.

### Phase 2 - Present candidates

Write a self-contained HTML report to the OS temp directory (nothing in the repo).
Use Tailwind via CDN for layout, Mermaid via CDN for dependency/flow diagrams.
Each candidate gets a before/after visualization as a card.
See [html-report.md](reference/html-report.md) for the HTML scaffold and styling guidance.

Open the file for the user and tell them the absolute path.
Ask: "Which of these would you like to explore?"

### Phase 3 - Deepen

See [deepening.md](reference/deepening.md) for dependency categories and seam discipline.

For interface design alternatives, spawn 3+ parallel agents with different constraints
(minimize interface, maximize flexibility, optimize for common caller, ports & adapters).
See [interface-design.md](reference/interface-design.md) for the sub-agent pattern.

Side effects happen inline:
- New domain term -> update GLOSSARY.md (see task/grill-with-docs/reference/glossary-format.md).
- Rejected candidate with load-bearing reason -> offer an ADR (see task/grill-with-docs/reference/adr-format.md).

## Tone

Observational. Report what you find, propose what you would change.

Does NOT refactor. Identifies opportunities and proposes changes.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: issue, question)
Writes: GLOSSARY.md (shared-append), docs/adr/ (shared-append)
## Exit

When proposals are written, suggest next steps:
- If a high-priority proposal emerged -> "/spec to write acceptance criteria for {proposal name}."
- If multiple proposals exist -> "Which proposal to tackle first? /spec to formalize it."
- If proposals affect architecture -> "/grill-with-docs to stress-test the approach and write an ADR."
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#exit-sequence).
