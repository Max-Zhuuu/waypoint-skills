# UI Prototype

Generate **several radically different UI variations** on a single route, switchable from a floating bottom bar. The user flips between variants in the browser, picks one (or steals bits from each), then throws the rest away.

If the question is about logic/state rather than what something looks like - wrong branch. Use [LOGIC.md](LOGIC.md).

## When this is the right shape

- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- Any time the user would otherwise spend a day picking between three vague mockups in their head.

## Two sub-shapes - strongly prefer sub-shape A

A UI prototype is much easier to judge when it's **butting up against the rest of the app** - real header, real sidebar, real data, real density. A throwaway route on its own is a vacuum: every variant looks fine in isolation. Default to sub-shape A whenever there's a plausible existing page to host the variants. Only reach for sub-shape B if the prototype genuinely has no nearby home.

### Sub-shape A - adjustment to an existing page (preferred)

The route already exists. Variants are rendered **on the same route**, gated by a `?variant=` URL search param. The existing data fetching, params, and auth all stay - only the rendering swaps. This is the default; pick it unless there's a specific reason not to.

If the prototype is for something that doesn't yet have a page but *would naturally live inside one* (a new section of the dashboard, a new card on the settings screen, a new step in an existing flow) - that's still sub-shape A. Mount the variants inside the host page.

### Sub-shape B - a new page (last resort)

Only use this when the thing being prototyped genuinely has no existing page to live inside - e.g. an entirely new top-level surface, or a flow that can't be embedded anywhere sensible.

Create a **throwaway route** following whatever routing convention the project already uses - don't invent a new top-level structure. Name it so it's obviously a prototype (e.g. include the word `prototype` in the path or filename). Same `?variant=` pattern.

Before committing to sub-shape B, sanity-check: is there really no existing page this could be embedded in? An empty route hides design problems that a populated one would expose.

In both sub-shapes the floating bottom bar is identical.

## Process

### 1. Ground the design

Before generating any variants, read the context that should inform them:

**Design system:** Read the project's design tokens, CSS custom properties, component library, and any existing styled pages. The variants must look like they belong in this app, not in an AI demo.

**Domain context:** Read GLOSSARY.md, relevant feature specs, and any logic docs for this screen. Understand what workflow this serves, what data the user is looking at, and what actions they need to take. A vessel list for a fleet manager has different priorities than a product catalog for a shopper.

**User workflow:** Before designing, answer: What is the user's primary task on this screen? What do they look at first? What action do they take most often? How long do they spend here - a glance or a deep session?

### 2. Pick design axes and assign positions

Default to **3 variants**. Cap at 5, and only go above 3 when the user explicitly asks AND names what additional axis the extra variants explore. "Give me 5" should prompt "what dimension should variants 4 and 5 test that 1-3 don't?"

Before generating, pick 2-3 design axes relevant to this screen from the list below (or invent one that fits better). Assign each variant a different position:

- **Information density:** dense/tabular vs spacious/card-based vs progressive disclosure
- **Primary affordance:** search-first vs browse-first vs action-first
- **Navigation model:** everything visible vs drill-down vs wizard/stepper
- **Data relationship:** flat list vs grouped/nested vs spatial/visual
- **Interaction model:** mouse-driven vs keyboard-driven vs hybrid
- **Chrome level:** full UI frame vs minimal/immersive vs content-only

Write down the plan, including what thesis each variant defends:

> "Three variants of the vessel list. A: dense tabular, optimizes for scan speed (users check 50+ vessels daily). B: grouped by status, optimizes for triage (users act on exceptions). C: map-first with list sidebar, optimizes for spatial reasoning (users think in routes)."

Each variant is defending a **thesis about how the user works**. If you can't state the thesis, the variant doesn't have one and you're just rearranging boxes.

### 3. Generate variants

Hold each variant to:

- The page's purpose and the data it has access to.
- The project's design system (tokens, CSS variables, component library, existing patterns).
- A clear exported component name, e.g. `VariantA`, `VariantB`, `VariantC`.

Variants must be **structurally different** - different layout, different information hierarchy, different primary affordance, not just different colors. If two drafts come out too similar, redo one with an explicit constraint (e.g. "no card grid," "no sidebar," "table only").

#### AI-aesthetic blocklist

When generating variants, actively avoid these AI-default patterns that cluster in generated output:

- Oversized hero sections with gradient backgrounds
- 4 stat cards across the top of every "dashboard"
- Card grids with uniform rounded corners and soft shadows as the universal layout
- Purple/indigo accent on white as the default palette
- Inter, Space Grotesk, or system-ui as the "safe" typeface when the project has its own
- Emoji as section markers or decorative elements
- Everything centered with generous whitespace when the domain demands density
- Decorative illustrations or placeholder icons that convey no information

These patterns aren't inherently bad - they're bad when they're the unexamined default. If a card grid genuinely serves the user's workflow, use it - but choose it because the workflow demands it, not because the model defaults to it. If two of your variants use card grids, redo one.

### 4. Wire them together

Create a single switcher component on the route:

```
// pseudo-code - adapt to the project's framework
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

For sub-shape A (existing page): keep all the existing data fetching above the switcher; only the rendered subtree changes per variant.

For sub-shape B (new page): the throwaway route under `/prototype/<name>` mounts the same switcher.

### 5. Build the floating switcher

A small fixed-position bar at the bottom-centre of the screen with three pieces:

- **Left arrow** - cycles to the previous variant (wraps around).
- **Variant label** - shows the current variant key, its name, and its one-line thesis. e.g. `B - Grouped by status (optimizes for triage)`.
- **Right arrow** - cycles forward (wraps around).

Behaviour:

- Clicking an arrow updates the URL search param (use the framework's router) so the variant is shareable and reload-stable.
- Keyboard: left/right arrow keys also cycle. Don't intercept arrow keys when an input, textarea, or contenteditable is focused.
- Visually distinct from the page (e.g. high-contrast pill, subtle shadow) so it's obviously not part of the design being evaluated.
- Hidden in production builds - gate on environment check so a stray prototype merge can't ship the bar to users.

Put the switcher in a single shared component so both sub-shapes can reuse it. Locate it wherever shared UI lives in the project.

### 6. Hand it over with evaluation prompts

Surface the URL (and the `?variant=` keys). Then, for each variant, print a brief evaluation prompt:

> **Variant A - Dense tabular (scan speed)**
> - Does this information hierarchy match your actual task priority on this screen?
> - Can you complete the primary action without scrolling?
> - This variant assumes you scan linearly through many items. Is that how you actually work here?

The interesting feedback is usually **"I want the header from B with the sidebar from C"** - that's the actual design they want. The evaluation prompts turn "I like B" into "B works because the primary action is above the fold" - which is the design decision worth capturing.

### 7. Capture the answer and clean up

Once a variant has won, write down which one and why (commit message, ADR via `/grill-with-docs`, spec update via `/spec`, or a `NOTES.md` next to the prototype if running AFK). Include: the winning variant, the thesis it proved correct, and what was stolen from the losing variants. Then:

- **Sub-shape A** - delete the losing variants and the switcher; fold the winner into the existing page.
- **Sub-shape B** - promote the winning variant to a real route, delete the throwaway route and the switcher.

Don't leave variant components or the switcher lying around. They rot fast and confuse the next reader.

## Anti-patterns

- **Variants that differ only in colour or copy.** That's a tweak, not a prototype. Real variants disagree about structure.
- **Variants without a thesis.** If you can't say "this variant assumes the user works by doing X," it's not a variant - it's a reskin.
- **Sharing too much code between variants.** A shared header component is fine; a shared layout component defeats the point. Each variant should be free to throw out the layout.
- **Wiring variants to real mutations.** Read-only prototypes are fine. If a variant needs to mutate, point it at a stub - the question is "what should this look like", not "does the backend work".
- **Promoting the prototype directly to production.** The variant code was written under prototype constraints (minimal error handling). Rewrite it properly when you fold it in.
- **Ignoring the project's design system.** A variant that uses its own colors, spacing, and typography can't be evaluated in context. Use the project's tokens.
