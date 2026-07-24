# Wave 2 - Tokens

Distill the soul into a finite set of design decisions. This wave is systematic - precision over breadth.

Read `docs/design/DESIGN-BRIEF.md` and `docs/design/DESIGN-DECISIONS.md` before starting.
Every token decision must trace back to the brief.

## Token architecture

Design tokens are the design system. Everything else consumes them.
Tokens are CSS custom properties (or equivalent) with semantic names.

Define tokens in these categories:

**Color roles** (not colors - roles):
- `surface` - backgrounds (page, card, elevated, sunken)
- `text` - foreground (primary, secondary, tertiary, disabled)
- `border` - boundaries (subtle, default, strong)
- `interactive` - clickable elements (default, hover, active, focus)
- `semantic` - status meaning (success, warning, critical, info)
- `accent` - brand/emphasis (primary, secondary)

Each role needs light and dark theme values.
Neutral colors should have a slight hue bias toward the accent - pure mid-gray reads as unconsidered.

**Type scale:**
- Scale ratio and base size
- Heading levels (how many, what sizes)
- Body text (size, line height, measure)
- Data text (tabular, monospace where numbers align)
- Caption/label text
- Font stacks with intentional fallbacks

**Spacing scale:**
- Base unit (usually 4px or 8px)
- Scale (linear or powers-of-2)
- Named sizes (tight, default, loose, section)
- Component-internal vs. layout spacing

**Motion:**
- Philosophy: what moves and what doesn't
- Duration scale (instant, fast, normal, slow)
- Easing curves (enter, exit, standard)
- Reduced-motion behavior

**Elevation/depth:**
- Shadow scale or border-based depth
- When depth is used (popovers, modals, sticky headers)
- Z-index strategy

**Density:**
- Row height (compact, default, comfortable)
- Cell padding
- Touch target minimums (if applicable)
- Header vs. body density relationship

## Token naming

Every token gets a semantic name. The Design Language section in DESIGN-DECISIONS.md tracks the vocabulary.

When the user uses a vague term, probe for specificity. See [REFERENCES.md](REFERENCES.md) for the vague-term resolution table.
Pin every resolved term to a specific, reusable name in the Design Language section.
New resolutions discovered during the project get logged in `docs/design/TERM-LOG.md` to expand the skill's reference over time.

## Interaction states

Read business logic docs. Map compound states:

"What happens when a vessel row is selected, an off-hire period is active, and a bunker report is overdue - simultaneously?"

Build a state matrix in `docs/design/system/INTERACTION-STATES.md`:
- Entity states from business logic (active, pending, closed, overdue)
- UI states (selected, hovered, focused, disabled, loading, error, empty)
- Compound states (which combinations are possible, how they stack visually)
- Transitions (what triggers state changes, what animation accompanies them)

This is where the design system meets the domain. Skip it and screen 47 will handle "overdue + selected" differently from screen 183.

## Convergence, not exploration

Wave 2 is conservative. Token values need stability.
When tempted to explore alternatives: "Is this a real problem with the current value, or curiosity? If curiosity, note it in DESIGN-DECISIONS.md as a future exploration, don't change the token now."

Exception: when a token value conflicts with another settled decision (the spacing scale fights the density model), resolve the conflict immediately. Log the revision in DESIGN-DECISIONS.md with rationale.

## Prototype triggers

Prototype eagerly at two points in wave 2:

1. **After defining color roles and type scale** - invoke `/prototype` on a representative data-dense screen using only the new tokens. This catches color/type conflicts before the rest of the token system is built on top of them.

2. **After completing the full token system** - invoke `/prototype` on a different representative screen to validate the complete system. A token system that hasn't touched a real screen is theory, not design.

Pass the token definitions and brief as context to `/prototype`.
Prototypes should be isolated HTML with mocked data - real components placed on the token system, easily modified without touching the codebase.

## Output

Update `styles/tokens.css` (or create it).
Write `docs/design/system/TOKEN-RATIONALE.md` - why each token value, not just what it is.
Write `docs/design/system/INTERACTION-STATES.md` - state matrix.
Update DESIGN-DECISIONS.md with token-level decisions and design language terms.

**Exit checkpoint:** "Wave 2 complete. Token system defined, {N} token decisions logged, interaction states mapped. Prototype confirms tokens work on real screens. Ready for wave 3 (Proof), or revisit any tokens?"
