---
name: design
description: "Design system creation and evolution. Three fluid waves: soul-finding (product verb, emotional range, competitive audit), token architecture (color roles, type scale, spacing, motion), and proof (real screens stress-tested against the tokens). Produces documented decisions, not artifacts - flows into /spec, /prototype, /tdd for implementation."
status: stable
user-invocable: true
metadata:
  hermes:
    tags: [design-system, tokens, visual-design, interaction-design]
    category: project
  status: stable
---

# /design

Design system creation and evolution for a product.
Not a builder - a decision-making skill that produces documented design decisions, token definitions, and component specifications.
Other skills consume these outputs: /prototype for visual exploration, /spec for component specs, /tdd and /create for implementation.

## Context gate

This skill requires project context. Before proceeding, check for:

1. `SCOPE.md` - what the product is, its boundaries
2. `CONTEXT.md` - domain glossary
3. `CONVENTIONS.md` - naming patterns
4. Business logic docs (e.g., `docs/wpf-reference/logic/`, `docs/specs/`)
5. Existing styles (`styles/tokens.css` or equivalent)
6. Existing design docs (`docs/design/`)
7. Legacy/reference system source (if migrating)

If SCOPE.md is missing and no equivalent context exists, hard-stop:
"I need to understand what this product does before I can design for it. Answer these questions or run /setup first."

Then ask:
1. What does this product do in one sentence?
2. Who uses it and how often? (Daily tool vs. occasional visit)
3. What's the information density? (Dashboard-dense, form-heavy, content-light)
4. Is there a system being replaced? What does it look like?
5. What's the team size consuming these design decisions?

If the user provides enough inline context without SCOPE.md, proceed. The gate is on understanding, not on file existence.

## On invocation - detect mode

Check for existing design artifacts:

| File exists | Mode |
|------------|------|
| Nothing in `docs/design/` | **Greenfield** - full wave 1-2-3 |
| `docs/design/DESIGN-BRIEF.md` exists | **Resume** - show state, offer continue/revisit/jump |
| `styles/tokens.css` exists but no `docs/design/` | **Retrofit** - extract implicit decisions, validate, extend |
| Design system exists, user describes new surface | **Evolve** - inline question: "Extend existing brief or revisit foundations?" |

### Resume detection

If DESIGN-BRIEF.md or DESIGN-DECISIONS.md exists, read them and report:

```
Design system status:
- Brief: {exists/missing} {one-line summary if exists}
- Decisions: {N} settled, {N} active, {N} archived
- Design language: {N} terms defined
- Token rationale: {exists/missing}
- Interaction states: {exists/missing}
- Component specs: {exists/missing}
- Unified document: {exists/missing}

Last wave activity: {wave N, topic}
Continue from here, revisit an earlier decision, or jump to wave {next}?
```

### Retrofit detection

If code artifacts exist (tokens.css, component styles) but no design docs:

1. Read the existing token/style files
2. Extract implicit decisions: "Your tokens.css tells me you've already decided on 4px spacing base, compact density, and a blue-gray neutral palette."
3. Present the extracted brief: "Here's what your code says about your design system. Is this intentional or accidental?"
4. User validates or corrects
5. Document validated decisions in DESIGN-DECISIONS.md
6. Show gaps: "You have spacing and layout tokens but no semantic color roles, no type scale rationale, no motion philosophy, no interaction state definitions."
7. User chooses: fill gaps wave-by-wave, or validate brief first

## Wave 1 - Soul

Find the product's design identity. This wave is explosive - breadth over depth.

### Step 1: Product verb

Every product has a primary verb. Identify it.

- **Monitor/decide/act** - operational tools, dashboards, control systems
- **Browse/discover/consume** - content platforms, marketplaces, feeds
- **Create/edit/publish** - authoring tools, editors, design tools
- **Communicate/collaborate/share** - messaging, project management
- **Configure/manage/maintain** - admin panels, settings, infrastructure

The verb shapes everything: density, hierarchy, color semantics, motion philosophy.
A monitoring tool needs glanceable density and semantic status colors.
A creation tool needs generous canvas space and unobtrusive chrome.

State the verb. Ask the user to confirm or adjust.

### Step 2: Competitive audit

Identify 3-5 tools in the same task class. Not aesthetic inspiration - functional peers.

For a shipping VMS: Bloomberg terminal, Flexport dashboard, Maersk operations, MarineTraffic, IMOS.
For a project management tool: Linear, Jira, Asana, Shortcut.
For a content platform: Medium, Substack, Ghost.

For each reference:
- What density model do they use?
- How do they handle the primary verb?
- What's their emotional range?
- What's distinctive vs. generic about their visual language?

Document findings in `docs/design/RESEARCH.md`. Include screenshots or URLs where possible.
When something "doesn't feel right" later in the process, return here and investigate.
Flag findings explicitly: "Bloomberg uses monospace for all numerical data - this prevents column misalignment when values change. Worth adopting? Reference: Bloomberg Terminal position blotter."

### Step 3: Emotional range mapping

Most products have 3-5 emotional states the user moves through. Map them:

| State | When it happens | Visual character |
|-------|----------------|-----------------|
| Calm monitoring | Default state, scanning data | Neutral palette, even hierarchy |
| Focused entry | Filling forms, editing records | Reduced chrome, clear field boundaries |
| Urgent attention | Alerts, overdue items, errors | Semantic color, elevated prominence |
| Confirmation/success | Completed actions, saved states | Brief positive signal, then return to calm |
| Decision point | Choosing between options, approvals | Clear comparison layout, action prominence |

The user's product may have different states. Ask: "Walk me through a typical session. What emotional states does the user move through?"

### Step 4: Density decision

This is a first-class design decision, not a toggle added later.

- **Compact** - 8+ rows visible without scrolling, tight padding, small type. For power users in the app 8 hours/day.
- **Default** - 5-7 rows visible, comfortable padding, standard type. For regular users with moderate data.
- **Comfortable** - 3-5 rows visible, generous padding, large type. For occasional users or consumer products.

One density is primary. Others are optional future modes.
If replacing a desktop application: compact is almost always correct. Desktop users will revolt at airy web spacing.

### Step 5: Parallel directions

Produce 3 distinct design directions. Each direction includes:
- Type pairing (display + body, with rationale)
- Color direction (roles and mood, not final hex values)
- Density expression (how the chosen density model manifests)
- One distinctive element (what makes this direction recognizable)
- Reference touchstone ("think X meets Y" with concrete examples the user can look at)

Present all three side by side. Ask the user to react:
- Which direction resonates most?
- Any elements from the others worth carrying over?
- What's missing from all three?

Synthesize feedback into a single direction. This becomes the brief.

### Step 6: The indulgence gate

Before finalizing any direction, ask explicitly:
"Is this solving a real UX problem for your users, or is it aesthetic indulgence?"

This is not judgment. It's a forcing function for honest design decisions.
Aesthetic choices are valid when they serve brand differentiation or user satisfaction.
But they must be named as such, not disguised as UX improvements.

### Output: DESIGN-BRIEF.md

Write `docs/design/DESIGN-BRIEF.md`:
- Product verb
- Emotional range
- Density model
- Chosen direction (type, color, distinctive element)
- Reference touchstones
- What was explicitly rejected and why

Start `docs/design/DESIGN-DECISIONS.md` with wave 1 direction decisions and the Design Language section.
Start `docs/design/RESEARCH.md` with competitive audit findings.

Suggest `/prototype` for visual exploration of the chosen direction if the user wants to see it before committing.

## Wave 2 - Tokens

Distill the soul into a finite set of design decisions. This wave is systematic - precision over breadth.

### Token architecture

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

### Token naming

Every token gets a semantic name. The Design Language section in DESIGN-DECISIONS.md tracks the vocabulary.

When the user uses a vague term, probe for specificity. See [REFERENCES.md](REFERENCES.md) for the vague-term resolution table.
Pin every resolved term to a specific, reusable name in the Design Language section.
New resolutions discovered during the project get logged in `docs/design/TERM-LOG.md` to expand the skill's reference over time.

### Interaction states

Read business logic docs. Map compound states:

"What happens when a vessel row is selected, an off-hire period is active, and a bunker report is overdue - simultaneously?"

Build a state matrix in `docs/design/system/INTERACTION-STATES.md`:
- Entity states from business logic (active, pending, closed, overdue)
- UI states (selected, hovered, focused, disabled, loading, error, empty)
- Compound states (which combinations are possible, how they stack visually)
- Transitions (what triggers state changes, what animation accompanies them)

This is where the design system meets the domain. Skip it and screen 47 will handle "overdue + selected" differently from screen 183.

### Convergence, not exploration

Wave 2 is conservative. Token values need stability.
When tempted to explore alternatives: "Is this a real problem with the current value, or curiosity? If curiosity, note it in DESIGN-DECISIONS.md as a future exploration, don't change the token now."

Exception: when a token value conflicts with another settled decision (the spacing scale fights the density model), resolve the conflict immediately. Log the revision in DESIGN-DECISIONS.md with rationale.

### Output

Update `styles/tokens.css` (or create it).
Write `docs/design/system/TOKEN-RATIONALE.md` - why each token value, not just what it is.
Update DESIGN-DECISIONS.md with token-level decisions and design language terms.

## Wave 3 - Proof

Prove the token system works on real screens. This wave is explosive again - provocations welcome where data says the conservative choice isn't working.

### Representative screens

Select 5-7 screens that stress-test the token system:
- The densest data screen (table with 15+ columns)
- The most complex form (20+ fields, conditional visibility)
- The simplest view (dashboard widget, single-purpose card)
- A map or visualization (if applicable)
- An empty state or first-run experience
- An error/alert-heavy state
- A drill-down chain (list -> detail -> sub-detail)

Build each using only the defined tokens. No one-off values.

### Stress tests

For each proof screen, test:
- **Long content** - vessel name is 60 characters, comment field is 500 words
- **Empty state** - no data, no results, first-time user
- **Dense data** - 200 rows, all columns populated
- **Error state** - 3 validation errors, 1 system error, 1 overdue warning simultaneously
- **Compound interaction** - selected row + active filter + sort applied + inline edit open
- **Both themes** - light and dark with equal care

### Token failures

When a proof screen breaks (and it will):
1. Identify which token is failing and why
2. Check if the fix is local (this screen needs an override) or systemic (the token value is wrong for the system)
3. If systemic: revise the token in wave 2, update TOKEN-RATIONALE.md with the revision reason, archive the old value
4. If local: document the override as a component-specific token and justify why the system token doesn't apply here

### Component extraction

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

### Selective provocations

When proof screens reveal that the conservative wave 2 choice isn't working, propose alternatives.
Every provocation gets the gate: "Real UX problem or aesthetic indulgence?"
Include a concrete reference: "Flexport uses alternating row tints instead of borders for dense tables. Reduces visual noise by ~30%. Worth testing?"

### Output

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

## Fixation detection

Watch for the user spending disproportionate time on one detail.
If a single topic (typography, one color value, one component) spans 3+ exchanges without resolution:

Don't gate or time-limit. Instead, show connections:
"You've been refining the table header typography. The spacing scale and row density connect directly to this - want to zoom out and see how they interact? Sometimes the header problem is actually a density problem."

The goal is redirecting by showing the bigger picture, not cutting off exploration.

## Skill handoffs

/design does not build. When the work shifts to building:

- **Visual exploration needed** -> "This direction needs a visual test. `/prototype` with the brief as context?"
- **Component needs speccing** -> "The data table pattern needs a full spec. `/spec` with token constraints from DESIGN-DECISIONS.md?"
- **Ready to implement** -> "Token system is proven. `/tdd` for the token infrastructure, `/create` for component implementation?"
- **Something feels off** -> Update RESEARCH.md with a new investigation. Include the sector reference or design vibe so the implementer can look at it themselves and get fresh perspective.

Pass the relevant design docs as context to the invoked skill.

## Rules

- Never produce visual artifacts directly. Document decisions, suggest /prototype for visual exploration.
- Every vague aesthetic term gets pinned to a specific, reusable name. No ambiguity survives a session.
- Every departure from the brief gets the indulgence gate question. State the question; don't sneak changes through.
- Both themes (light and dark) get equal care. Never invert naively.
- Density is a first-class decision made early, not a mode toggle added later.
- When something doesn't feel right, investigate with competitive research. Flag explicitly with a reference the implementer can go look at.
- Archive discarded directions in `docs/design/archive/`. Never delete - the "can we bring back X" question is always valid.
- Log new vague-term resolutions to `docs/design/TERM-LOG.md` for skill evolution.

## Engagement

Read project maturity from SCOPE.md and existing design docs.

- **No project setup** - hard gate. Need context before design.
- **Project setup, no design docs** - greenfield mode. Start wave 1.
- **Design docs exist** - resume mode. Show state, offer options.
- **Mature project with concerns** - check CONCERNS.md for design-related flags. Surface them before new work.

When concerns exist that relate to visual consistency, interaction patterns, or design drift, surface them:
"C-{id} flags design drift in {area}. Address this before extending the system?"
