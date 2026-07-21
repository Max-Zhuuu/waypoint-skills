---
name: improve-codebase-architecture
description: Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
status: stable
---

# Improve Codebase Architecture

Follow the architecture review methodology in [process/architecture-review.md](../../process/architecture-review.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Explore

Use the Agent tool with `subagent_type=Explore` to walk the codebase.
Read the project's domain glossary (CONTEXT.md) and ADRs before exploring.

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
- New domain term -> update CONTEXT.md (see task/grill-with-docs/CONTEXT-FORMAT.md).
- Rejected candidate with load-bearing reason -> offer an ADR (see task/grill-with-docs/ADR-FORMAT.md).

## Engagement

On invocation, detect engagement tier:

| Signal | Tier |
|--------|------|
| No CONCERNS.md, no CLAUDE.md | Tier 1 - just working |
| CONCERNS.md exists | Tier 2 - tracking |
| CONCERNS.md + Documentation Map in CLAUDE.md | Tier 2+ |
| Tier 2+ and `concerns: auto-emit` in CLAUDE.md | Tier 3 - automated |

**Tier 1:** Execute the full methodology. Skip cross-referencing.
Substitute inline: no CONTEXT.md -> define terms inline; no CONVENTIONS.md -> infer from code;
no SCOPE.md -> ask scope inline; no TESTING.md -> state default philosophy.
State each adaptation once, then move on.

**Tier 2:** Read CONCERNS.md at start. Note relevant open concerns.
After work, follow the nudge protocol for discoveries. Emit as `[open]` with type, date, refs.

**Tier 3:** Emit concerns without asking. Log what was emitted at session end.

**Nudge protocol:**
1. **What** - the specific discovery, concrete names
2. **Why** - impact beyond this session
3. **Ask** - one question, one time. If declined, do not re-offer.

**Concern format:** `### C-{next_id} [open] {description}` / `type: {question|assumption|flag} | raised: {date} | source: /{skill-name}`

**Emit when:** cross-cutting, contradicts assumption, can't resolve now, time-bound risk.
**Don't emit:** things just fixed, generic advice, duplicates, current-context-only.

**Don't:** block on missing scaffolding; repeatedly mention what's missing; prompt for /setup more than once (`.claude/.setup-prompted`); create scaffolding owned by another skill; degrade silently.
