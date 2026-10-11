---
name: from-paper
description: "Paper to code: extract an artboard or section into components with exact CSS from get_computed_styles, mapped to project tokens."
status: draft
---

# /from-paper - Paper-to-Code Pixel-Accurate Extraction

Read [skill.json](./skill.json). Initialize checklists. Step 1 runs once; steps 2-8 run in strict order per section, never skipped or combined.
Extracts a Paper artboard, or a section of one, into components in the project's own framework.
The result must be visually indistinguishable from the Paper design: no creative interpretation, no "close enough".

## Hard rules

1. **Never write CSS from memory or spec prose.** Every `font-size`, `padding`, `gap`, `color`, `border-radius`, `box-shadow` or `background` comes from `get_computed_styles` or `get_jsx` in this session.
2. **Recursive extraction is mandatory.** Walk every child, grandchild and leaf. A missing 6px gap between a label and its icon is a defect.
3. **Extract before you build.** Finish the section's extraction before writing component code; building while extracting produces drift.
4. **Token mapping goes one way: Paper to project.** Map Paper's `var(--token)` to the project's `{prefix}*` tokens. No equivalent: add one to `{token_files}`. Literal Paper values get added as tokens too.
5. **Visual verification is not optional.** Load each section in the browser and compare with the Paper screenshot; fix it before moving on.
6. **Interactions come from the spec, motion from frame strips.** Paper is static and drops `transition`/`animation`. Behavior comes from `{spec}`; motion comes from the component's Paper frame strip (Start/Mid/End with duration and curve), else `{spec}`. The resting state matches Paper exactly.
7. **Project values are resolved, never assumed.** Run [reference/project-conventions.md](reference/project-conventions.md) first; the project's own rules override this skill.

## Input

Paper file and artboard (or section node), target component and CSS paths, and the implementation spec `{spec}` for behavior.

## Exit

Report per section: nodes extracted, tokens created, properties spot-checked, and a pass/fail visual verdict with specific discrepancies.
Then print the artifacts manifest and follow the chain in skill.json (/review).

## Engagement
See [engagement protocol](../../internals/engagement/README.md).
