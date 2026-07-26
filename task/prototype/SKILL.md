---
name: prototype
description: "Build throwaway prototypes to flesh out a design. Routes between terminal app, UI variations, or design panel."
status: stable
---

A prototype is **throwaway code that answers a question**. The question decides the shape.

## Pick a branch

Identify which question is being answered - from the user's prompt, the surrounding code, or by asking if the user is around:

- **"Does this logic / state model feel right?"** - [LOGIC.md](phases/logic.md). Build a tiny interactive terminal app that pushes the state machine through cases that are hard to reason about on paper.
- **"What should this look like?"** - [UI.md](phases/ui.md). Generate several radically different UI variations on a single route, switchable via a URL search param and a floating bottom bar.
- **"What should the app feel like?"** - [DESIGN.md](phases/design.md). Add toggles to a persistent design panel for exploring visual variants (shell themes, tab styles, spacing, color palettes) across the whole app in-situ. Check for an existing design panel first and extend it; create one if it doesn't exist.

The three branches produce very different artifacts - getting this wrong wastes the whole prototype. If the question is genuinely ambiguous and the user isn't reachable, default to whichever branch better matches the surrounding code (a backend module - logic; a single page - UI; cross-app visual treatment - design) and state the assumption at the top of the prototype.

## Rules

1. **Throwaway from day one, and clearly marked as such.** Locate the prototype code close to where it will actually be used (next to the module or page it's prototyping for) so context is obvious - but name it so a casual reader can see it's a prototype, not production. For throwaway UI routes, obey whatever routing convention the project already uses; don't invent a new top-level structure.
2. **One command to run.** Whatever the project's existing task runner supports - `pnpm <name>`, `python <path>`, `bun <path>`, etc. The user must be able to start it without thinking.
3. **No persistence by default.** State lives in memory. Persistence is the thing the prototype is _checking_, not something it should depend on. If the question explicitly involves a database, hit a scratch DB or a local file with a clear "PROTOTYPE - wipe me" name.
4. **Visual quality depends on the branch.**
   - **Logic prototypes:** skip the polish. Nobody cares if the TUI is pretty. No tests, no error handling beyond what makes it runnable.
   - **UI prototypes:** must be visually competent. Use the project's existing design system (tokens, variables, component library). If none exists, set a type scale, pick a palette grounded in the domain, and use consistent spacing. No transitions, no hover states, no responsive tuning - but the prototype must look good enough that the user evaluates the *layout decision*, not the surface quality. See phases/ui.md for design grounding steps and the AI-aesthetic blocklist.
   - **Design prototypes:** same standard as UI - competent baseline, real tokens. The point is to compare visual treatments, so the baseline must be solid.
5. **Surface the state.** After every action (logic) or on every variant switch (UI), print or render the full relevant state so the user can see what changed.
6. **Delete or absorb when done.** When the prototype has answered its question, either delete it or fold the validated decision into the real code - don't leave it rotting in the repo.

## Bridge behavior

/prototype is a bridge skill: fully functional standalone, enhanced by project scaffolding.

**Integration points when scaffolding exists:**
- Workflow design system phases: /prototype integrates with /buildout Phase design system and /migrate Phase 6b
- CONVENTIONS.md: UI prototypes use the project's design tokens and naming patterns
- GLOSSARY.md: domain terms inform prototype naming and labeling

**Without scaffolding:** all three prototype branches work. UI prototypes use sensible defaults instead of project tokens.

## Tone

Experimental. Move fast, throw things away, learn.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: question)
Writes: none
## Exit

The _answer_ is the only thing worth keeping from a prototype. Capture it somewhere durable (commit message, ADR via `/grill-with-docs`, spec update via `/spec`, or a `NOTES.md` next to the prototype) along with the question it was answering. If the user is around, that capture is a quick conversation; if not, leave the placeholder so they (or you, on the next pass) can fill in the verdict before deleting the prototype.
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.
