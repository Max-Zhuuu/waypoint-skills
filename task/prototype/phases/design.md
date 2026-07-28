# Design Prototype

A persistent **design toggle panel** for exploring visual variants across the whole app in-situ. Unlike [ui.md](ui.md) which creates separate variant components on a single route, this approach adds runtime switches that change the look of the entire application - shell theme, tab treatments, spacing, color palettes, etc.

## When this is the right shape

- "Try a few shell themes" / "explore density options"
- "What if the card tabs looked like pills instead of underlines?"
- "I want to compare shadow vs flat across real screens, not just one page"
- Any time the design question spans the whole app surface, not a single page

If the question is about a single page's layout or content structure - wrong branch. Use [ui.md](ui.md).
If the question is about logic or state - wrong branch. Use [logic.md](logic.md).

## How it works

The design panel is a small fixed-position overlay (bottom-right corner) with toggle buttons for each design dimension being explored. Each toggle updates a reactive value in a shared store, which CSS and template bindings read to swap between visual treatments.

This lets the user flip between options while navigating any screen - seeing how each variant looks on a list view, a detail form, during navigation, etc.

## Architecture pattern

The pattern is the same regardless of framework. Three pieces:

1. **Design store** - a reactive store holding the current value for each design dimension. Put it where the project keeps shared state (Vue composable, React context, Svelte store, Zustand store, or even CSS custom properties toggled via JS).

```
// pseudo-code - adapt to project's framework and conventions
// PROTOTYPE - design variant switcher, delete when decided

type ShellTheme = 'baseline' | 'shadow' | 'lift' | 'etch'
// ... one type per dimension

store = reactive({
  shellTheme: 'baseline',   // default to current production choice
  // ... one field per dimension
})

export function useDesignToggles() {
  return { store, setShellTheme(v) { store.shellTheme = v } }
}
```

Each dimension gets a type/enum, a default matching the current production state, and a setter. Mark the file `PROTOTYPE` so it's obvious this is throwaway.

2. **Design panel component** - a fixed-position dark overlay with toggle buttons:
   - Fixed bottom-right, high z-index, dark theme (visually distinct from the app)
   - Collapsible - shows just a small "Design" label when collapsed
   - One row per design dimension: label + button group
   - Active button highlighted distinctly
   - Buttons call the store's setter functions
   - Hidden in production builds via environment check

3. **Mount point** - wire the panel into the app's root layout component, alongside any existing overlays (command palette, dev tools, etc).

## Process

### 1. Check for existing infrastructure and ground the design

**Taste profile:** Identify which taste profile (consumer-indulgent, brutal-minimalist, institutional) matches this project. State the assumption. The profile's reference anchors inform what "baseline" means for each variant - a shell theme variant for a trading desk looks nothing like one for a consumer app.

**Existing panel:** Look for an existing design store and panel in the project.

If **both exist**: read them, understand what toggles are already wired, then add your new dimension(s) by extending the store and the panel template. Skip to step 4.

If **neither exists**: offer to create them. "No design panel found. Create one? (default: yes)" If declined, proceed without a panel (variant switcher only, per [ui.md](ui.md)). Otherwise, create from scratch (steps 2-3).

If **only the store exists** (panel was cleaned up after a decision): recreate the panel and wire it into the root layout.

### 2. Create the store

Put it where the project keeps shared state. Use the architecture pattern above, adapted to the project's framework. Default each dimension's value to the current production choice so the baseline is familiar.

### 3. Create the panel and mount it

Build the panel component following the architecture pattern. Wire it into the root layout component alongside any existing overlays.

### 4. Add the new variants

For each new design dimension the user wants to explore:

1. **Add the type, field, and setter** to the design store
2. **Add a toggle row** to the panel
3. **Wire the CSS/template** - the interesting part. Each variant needs to actually change the visual:
   - **CSS-only variants** (e.g., tab styling): use a dynamic class and write CSS rules per variant
   - **Shadow/depth variants**: change backgrounds, box-shadows, borders in the shell components
   - **Spacing/density variants**: update CSS custom properties on the document root
   - **Color variants**: swap CSS custom property values or apply a class to the root

Make each variant **genuinely different** - not just slightly different hex values. The point is to feel the structural difference while using the real app.

The same AI-aesthetic blocklist from [ui.md](ui.md) applies here. If your variants all converge on the same AI-default look (soft shadows, rounded everything, indigo accent), redo them.

### 5. When a decision is made

When the user picks a winner:

1. **Bake the decision** - hard-code the winning variant's CSS into the production styles. Remove the dynamic class binding if only one variant survives.
2. **Archive the dimension** - move it to a collapsed "Decided" section in the panel. Record: dimension name, winning variant, date, and one-line rationale (e.g. "shellTheme: shadow - 2026-07-26 - depth without visual weight"). This section is collapsed by default so it doesn't clutter active exploration.
3. **Update the store** - remove the decided dimension's type/field/setter.
4. **If all dimensions are decided** - capture the archival content in a commit message or ADR on the canonical branch (the decision trail must not vanish with the panel). Then delete the panel component, remove it from the root layout, simplify the store back to production-only code.

## Worktree lifecycle

The design panel is exploration infrastructure - it lives on worktrees, never on the canonical branch. See the [engagement protocol's worktree section](../../internals/engagement/README.md) for the general convention. The prototype-specific rule:

**Merge decisions, not the panel.** Cherry-pick or rebase only the baked CSS changes and the decision record (ADR or commit message). The panel component, store, and mount point stay on the worktree. Tag before each new direction per the project's design archival policy.

## Anti-patterns

- **Variants that only differ in one hex value.** That's a tweak, not a design question. Make variants structurally different.
- **Too many dimensions at once.** More than 5-6 active toggles makes comparison impossible. Decide in batches.
- **Merging the panel to the canonical branch.** The panel is worktree-scoped. Only baked CSS and decision records merge.
- **Forgetting to bake decisions.** A panel with 10 archived rows and no active ones should have been cleaned up 8 decisions ago.
- **Using this for single-page layouts.** If the variants only affect one route, use [ui.md](ui.md) instead - it's faster to evaluate.
- **Ignoring the project's design system.** Variants must use the project's existing tokens and spacing. A variant that invents its own visual language can't be evaluated in context.
