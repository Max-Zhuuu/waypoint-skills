# Wave 3 - Proof

Prove the token system works on real screens. This wave is explosive again - provocations welcome where data says the conservative choice isn't working.

Read `docs/design/DESIGN-BRIEF.md`, `docs/design/DESIGN-DECISIONS.md`, and `docs/design/system/TOKEN-RATIONALE.md` before starting.
Every proof screen must use only defined tokens. No one-off values.

## Representative screens

Select 5-7 screens that stress-test the token system:
- The densest data screen (table with 15+ columns)
- The most complex form (20+ fields, conditional visibility)
- The simplest view (dashboard widget, single-purpose card)
- A map or visualization (if applicable)
- An empty state or first-run experience
- An error/alert-heavy state
- A drill-down chain (list -> detail -> sub-detail)

For each proof screen, eagerly invoke `/prototype` to render it as isolated HTML with mocked data.
Don't describe what a screen would look like - build it and see.
Isolated prototypes are easily modified alongside the design without touching the real codebase.
Pass the token system and brief as context.

## Stress tests

For each proof screen, test:
- **Long content** - vessel name is 60 characters, comment field is 500 words
- **Empty state** - no data, no results, first-time user
- **Dense data** - 200 rows, all columns populated
- **Error state** - 3 validation errors, 1 system error, 1 overdue warning simultaneously
- **Compound interaction** - selected row + active filter + sort applied + inline edit open
- **Both themes** - light and dark with equal care

## Token failures

When a proof screen breaks (and it will):
1. Identify which token is failing and why
2. Check if the fix is local (this screen needs an override) or systemic (the token value is wrong for the system)
3. If systemic: revise the token in wave 2, update TOKEN-RATIONALE.md with the revision reason, archive the old value
4. If local: document the override as a component-specific token and justify why the system token doesn't apply here

## Component extraction

Patterns that appear across 3+ proof screens become component specs:
- Data table (sortable, filterable, selectable, editable)
- Form field group (label, input, validation, help text)
- Status indicator (badge, pill, icon + text)
- Navigation pattern (breadcrumb, tab, drill-down)
- Action group (primary, secondary, destructive, disabled)

Document in `docs/design/system/COMPONENT-SPECS.md` with:
- Token usage (which tokens, how composed)
- States (all interaction states from the matrix)
- Variants (if any, with rationale for each)
- Accessibility requirements (focus, contrast, screen reader)

## Selective provocations

When proof screens reveal that the conservative wave 2 choice isn't working, propose alternatives.
Every provocation gets the gate: "Real UX problem or aesthetic indulgence?"
Include a concrete reference: "Flexport uses alternating row tints instead of borders for dense tables. Reduces visual noise by ~30%. Worth testing?"

When a provocation is accepted, invoke `/prototype` immediately to validate the alternative before committing the token change.

## Output

Write `docs/design/system/COMPONENT-SPECS.md`.
Write `docs/design/system/DESIGN-SYSTEM.md` - the unified shareholder-readable document:
- Design philosophy (verb, emotional range, density rationale)
- Color system with swatches
- Typography with examples
- Spacing and density model
- Interaction patterns
- Component catalog with visual examples

This document synthesizes everything from waves 1-3.
It's the seed for the next design cycle - when the product evolves, start a new wave 1 using this as the brief.

**Exit checkpoint:** "Wave 3 complete. {N} proof screens tested, {N} components extracted, design system document written. The system is proven. Hand off to /tdd for token infrastructure, /create for component implementation, or start a new wave 1 cycle to evolve."
