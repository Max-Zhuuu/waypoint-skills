# Project conventions resolution

Shared by `/from-paper`, `/to-paper` and `/prot-paper`.
Run it once per session, before touching Paper or code, and use the resolved values everywhere a step says `{prefix}`, `{token_files}`, `{framework}`, `{font}`, `{class_prefix}`, `{component_dir}` or `{typecheck}`.
No Paper skill may hard-code any of these values.

## Values

| Key | Meaning | Example (shape only) |
|-----|---------|----------------------|
| `{prefix}` | Custom-property prefix of the design tokens | `--acme-` |
| `{token_files}` | CSS files that declare the tokens | `src/styles/tokens/*.css` |
| `{framework}` | Component framework: `vue`, `react`, `svelte` or `html` | `vue` |
| `{font}` | Body font family; plus mono and display families if declared | `Inter`; mono `JetBrains Mono` |
| `{class_prefix}` | Prefix for new CSS class names | `acme-` |
| `{component_dir}` | Where shared UI components live | `src/components/ui/` |
| `{typecheck}` | Type-check command | `pnpm tsc` |
| `{spec}` | Where interaction behavior is specified | `{DOCS}/specs/<feature>.md` or a Linear issue |

## Resolution order

Resolve each key independently; stop at the first source that answers it.

1. **CLAUDE.md `## Conventions`.**
   Read the CLAUDE.md of the repo you are working in, then every CLAUDE.md above it up to the workspace root (a non-git directory holding several repos).
   Look for a key/value table or list with these keys: Framework, Token prefix, Token files, Font, Class prefix, Component dir.
   The nearest file wins on conflicts.
2. **Detect from the project.**
   - `{framework}`: `package.json` dependencies (`vue`, `react`, `svelte`); a meta-framework (Nuxt, Remix, SvelteKit and the like) counts as its base framework.
   - `{token_files}`: CSS files named `*token*` or under a `tokens/` directory, excluding `node_modules` and build output.
   - `{prefix}`: the most frequent `--<name>-` prefix among custom properties declared in `{token_files}`.
   - `{font}`: the first family in the root `font-family` declaration, or the font loader the app uses.
   - `{component_dir}`: the directory holding the shared UI components, usually `components/ui/`, `shared/ui/` or `components/` under `src/`; pick the one that most other components import from.
   - `{class_prefix}`: the most frequent class prefix in `{component_dir}`; else `{prefix}` without the leading dashes.
   - `{typecheck}`: the `package.json` script that runs `tsc` or `vue-tsc`, run with the package manager its lockfile names (`pnpm-lock.yaml`, `yarn.lock`, `bun.lock`, else npm).
   - `{spec}`: if the project's CLAUDE.md says implementation specs live in a tracker (Linear, Jira, GitHub issues), the issue for the work; else `{DOCS}/specs/`, where `{DOCS}` is the CLAUDE.md `## Docs` root, else `_docs/` at the workspace root, else `docs/`.
   Report each detected value with the file it came from.
3. **Ask once, then record.**
   For anything still unresolved, ask the user one combined question.
   Write the answers into the `## Conventions` key table of the repo's CLAUDE.md (create the table if missing) so the next session resolves at step 1.

If the project has no token file at all, ask once where tokens should live, create that file, and record it as above.

## Project rules override skill defaults

Before building, read the project's prohibited and required patterns (CLAUDE.md, lint config, design-guard tests).
Examples: "no bare HTML elements, use the component library", "no visual CSS inside the component directory", "no hard-coded colors".
Where a project rule conflicts with a step in a Paper skill, the project rule wins; note the conflict in the exit report.

## Framework branches

| Concern | `vue` | `react` | `html` |
|---------|-------|---------|--------|
| Component file | Single-file component, `<script setup lang="ts">` | Function component in `.tsx` | Static `.html` partial |
| Local state | `ref()` / `computed()` | `useState` / `useMemo` | none |
| Events | `@click`, `@keydown` | `onClick`, `onKeyDown` | none |
| Styles | the project's CSS files, or `<style scoped>` only if the project allows it | the project's CSS files or CSS modules | the project's CSS files |
| Type-check | `{typecheck}` (usually `vue-tsc --noEmit`) | `{typecheck}` (usually `tsc --noEmit`) | skip |

Other frameworks follow the same rows; ask if the mapping is unclear.

## Paper limits

Paper drops CSS `transition` and `animation` and ignores `@keyframes`.
Never write them into Paper through `write_html` or `update_styles`.
Motion is drawn as a frame strip (Start, Mid and End frames side by side, captioned with duration, curve and the motion token names), optionally with a curve plot.
When reading Paper, a frame strip next to a component is the motion spec for that component.
