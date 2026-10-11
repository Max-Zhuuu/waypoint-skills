---
name: prot-paper
description: "Prototype in Paper: build two or more structurally different design directions on the canvas from real source data and existing tokens."
status: draft
---

# /prot-paper - Paper-First Design Prototyping

Read [skill.json](./skill.json). Initialize checklists. Execute steps sequentially.
Designs new or redesigned pages in Paper from real source data, the project's tokens and a bold interactive direction.
This is a creative skill; for pixel-accurate replication use `/to-paper`.

## Hard rules

1. **No static boxes with text.** Every section shows a real interactive concept. If the source has the component, use its data and show it working; a new interaction gets enough fidelity to evaluate.
2. **No all-caps eyebrow labels** or small-caps overlines above headings. The heading does the work.
3. **Reuse the project's tokens and font.** Resolve `{prefix}`, `{token_files}`, `{framework}` and `{font}` with [project-conventions.md](../from-paper/reference/project-conventions.md) before any HTML. Use `var({prefix}*)` values; never a new typeface or raw color or spacing value.
4. **Real data from the source.** Read the codebase for component names, state shapes, data models and content before designing a section. No lorem ipsum.
5. **Clone before rebuilding.** A component already in the Paper file is cloned with `duplicate_nodes`, never rebuilt.
6. **Two variants minimum,** with different interaction models, not color or layout tweaks.
7. **Motion as frame strips.** Paper drops `transition` and `animation`, so never write them. Show motion a variant depends on as a frame strip (Start/Mid/End, captioned with duration, curve and token names) beside the component.

## Input

The page or feature, the source repo for data, and optionally a target Paper file and page.

## Exit

Report: variant artboard names, cloned component count, sections per variant, key design decisions, and which variant you'd pick and why.
Then print the artifacts manifest and follow the chain in skill.json (/from-paper once a variant is chosen).

## Engagement
See [engagement protocol](../../internals/engagement/README.md). Writes to the Paper canvas, not the repo.
