---
name: to-paper
description: "Code to Paper: replicate a running page as a pixel-accurate, editable static layout in Paper from extracted DOM and computed styles."
status: draft
---

# /to-paper - Source-to-Paper Layout Replication

Read [skill.json](./skill.json). Initialize checklists. Execute steps in order, reading each step file when you reach it.
Replicates a page from any web framework as a pixel-accurate static layout in Paper.
Steps 2-6 repeat per page; step 1 runs once per session.

## Hard rules

1. **Screenshot first, build second.** Capture a full-page screenshot of the running page before writing any HTML. It is the ground truth for every section.
2. **No fake images.** Every source image (`<img>`, CSS `background-image`, framework image components) appears in Paper via `paper-asset://` absolute paths, never as a gradient or colored placeholder.
3. **Extract the real DOM.** Read the rendered DOM in a browser and copy every element with its computed styles inlined. Never insert component screenshots as images, and never hand-trace components from source. Method: `dom_extraction` in [steps/build.json](steps/build.json).
4. **Verify against the real page,** not your mental model. If the artboard doesn't look like the same page, it's wrong.
5. **Project values are resolved, never assumed.** Session init runs [project-conventions.md](../from-paper/reference/project-conventions.md) for `{prefix}`, `{token_files}`, `{framework}` and `{font}`.
6. **No motion CSS in Paper.** Paper drops `transition` and `animation`. Write resting states only; where motion matters, draw a frame strip (Start/Mid/End, captioned with duration and curve).

## Input

The page, its source repo, and optionally a target Paper page and modifications.

## Exit

Report: artboard name, page, node count, font used, image count, deviations from source.
Flag Paper-token vs source font mismatches and any missing image.
Then print the artifacts manifest and follow the chain in skill.json: /prot-paper to explore directions, /from-paper to bring a design back to code.

## Engagement
See [engagement protocol](../../internals/engagement/README.md). Writes to the Paper canvas, not the repo.
