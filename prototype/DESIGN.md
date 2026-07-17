# Design Prototype

A persistent **design toggle panel** for exploring visual variants across the whole app in-situ. Unlike [UI.md](UI.md) which creates separate variant components on a single route, this approach adds runtime switches that change the look of the entire application - shell theme, ribbon style, tab treatments, spacing, color palettes, etc.

## When this is the right shape

- "Try a few shell themes" / "explore ribbon density options"
- "What if the card tabs looked like pills instead of underlines?"
- "I want to compare shadow vs flat across real screens, not just one page"
- Any time the design question spans the whole app surface, not a single page

If the question is about a single page's layout or content structure - wrong branch. Use [UI.md](UI.md).
If the question is about logic or state - wrong branch. Use [LOGIC.md](LOGIC.md).

## How it works

The design panel is a small fixed-position overlay (bottom-right corner) with toggle buttons for each design dimension being explored. Each toggle updates a reactive ref in a composable (`useRibbonStyle` or similar), which CSS and template bindings read to swap between visual treatments.

This lets the user flip between options while navigating any screen - seeing how each variant looks on a list view, a card form, during breadcrumb navigation, etc.

## Process

### 1. Check for existing infrastructure

Look for `src/composables/useRibbonStyle.ts` and `src/components/shell/DesignPanel.vue`.

If **both exist**: read them, understand what toggles are already wired, then add your new dimension(s) by extending the composable and the panel template. Skip to step 4.

If **neither exists**: create them from scratch (steps 2-3).

If **only the composable exists** (panel was cleaned up after a decision): recreate the panel and wire it into AppShell.

### 2. Create the composable

`src/composables/useRibbonStyle.ts` holds the reactive refs and type unions for each design dimension:

```ts
// PROTOTYPE - design variant switcher, delete when decided
import { ref } from 'vue'

export type ShellTheme = 'baseline' | 'shadow' | 'lift' | 'etch'
// ... one type per dimension

const activeShellTheme = ref<ShellTheme>('shadow')
// ... one ref per dimension, default to the current production choice

export function useRibbonStyle() {
  return {
    shellTheme: activeShellTheme,
    setShellTheme(v: ShellTheme) { activeShellTheme.value = v },
    // ... getter + setter per dimension
  }
}
```

Each dimension gets a type union, a ref with a sensible default, and a getter/setter pair. Mark the file `PROTOTYPE` so it's obvious this is throwaway.

### 3. Create the DesignPanel

`src/components/shell/DesignPanel.vue` - a fixed-position dark overlay with toggle buttons:

- Fixed bottom-right, z-index 9999, dark theme (so it's visually distinct from the app)
- Collapsible - shows just a small "Design" label when collapsed
- One row per design dimension: label + button group
- Active button highlighted in indigo (`#6366f1`)
- Buttons call the composable's setter functions

Wire it into `AppShell.vue` alongside `CommandPalette`:

```vue
<CommandPalette />
<DesignPanel />
```

### 4. Add the new variants

For each new design dimension the user wants to explore:

1. **Add the type, ref, and getter/setter** to `useRibbonStyle.ts`
2. **Add a toggle row** to `DesignPanel.vue`
3. **Wire the CSS/template** - the interesting part. Each variant needs to actually change the visual:
   - **CSS-only variants** (e.g., tab styling): use a dynamic class (`:class="`tabs--${style}`"`) and write CSS rules per variant
   - **Shadow/depth variants**: change backgrounds, box-shadows, z-index, borders in the shell components
   - **Spacing/density variants**: update CSS custom properties via `watchEffect` on `document.documentElement.style`
   - **Color variants**: swap CSS custom property values or apply a class to the root

Make each variant **genuinely different** - not just slightly different hex values. The point is to feel the structural difference while using the real app.

### 5. When a decision is made

When the user picks a winner:

1. **Bake the decision** - hard-code the winning variant's CSS into the production styles. Remove the dynamic class binding if only one variant survives.
2. **Remove the toggle row** from DesignPanel (or archive it with reduced opacity if you want to keep the option to revisit).
3. **Update the composable** - remove the decided dimension's type/ref/setter, or change the default to the winning value.
4. **If all decisions are made** - delete DesignPanel.vue, remove it from AppShell, simplify useRibbonStyle back to production-only code.

Capture the decision in the commit message: "Adopt pill card tabs (over underline/raised/inset/compact)".

## Dev server port

Design exploration branches should use port `520x` (e.g., 5200, 5201) to run alongside the main dev server. Configure in `vite.config.ts`:

```ts
server: { port: 520x }
```

## Anti-patterns

- **Variants that only differ in one hex value.** That's a tweak, not a design question. Make variants structurally different.
- **Too many dimensions at once.** More than 5-6 active toggles makes comparison impossible. Decide in batches.
- **Forgetting to bake decisions.** A DesignPanel with 10 archived rows and no active ones should have been deleted 8 decisions ago.
- **Using this for single-page layouts.** If the variants only affect one route, use [UI.md](UI.md) instead - it's faster to evaluate.
