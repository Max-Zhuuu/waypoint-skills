---
name: learn
description: Learning-oriented approach to any code task - new features, refactors, fixes, design patterns, architecture choices. Presents meaningfully different options with trade-off explanations and a terminology bridge. Use when you want to understand why one solution beats another.
---

# Learn

A structured mini-decision that surfaces 3 meaningfully different approaches so the user learns while deciding.
Works for any code task: new features, refactors, bug fixes, styling, data modeling, architecture choices, performance work.

## Phase 1 - Scope the task

1. Read the code the user is pointing at (file + surrounding context).
2. Identify what needs to happen and the constraints that matter (performance, consistency with existing patterns, API boundaries, UX requirements).
3. Grep `CONTEXT.md` for any domain terms relevant to this area.
4. If the intent is unclear, defer back to the user for additional context.
5. If the task is trivial (typo, import reorder, rename), say so and just do it - don't force options on a non-decision.

## Phase 2 - Implementation options

Present exactly 3 approaches using `AskUserQuestion` with `preview` on each option showing the actual code diff.
If only 2 meaningfully different approaches exist, present 2 - never invent a filler.

Each option must differ in its **most significant dimension** - not syntactic sugar or naming variations, but one of:

- **Algorithm / strategy**: a fundamentally different way to solve the problem (iterative vs recursive, pull vs push, eager vs lazy, event-driven vs polling, composition vs inheritance, normalization vs denormalization)
- **Architecture / pattern**: a different structural approach (component split, state management strategy, data flow direction, API shape, error handling pattern, caching layer)
- **Implementation / API**: a different tool, property, or built-in to achieve the effect (`gap` vs `margin`, `computed` vs `watch`, `Map` vs plain object, `filter()` vs `reduce()`, middleware vs decorator)

Choose the dimension that teaches the most for the specific task:
- For **CSS**: vary at the property/layout-strategy level. CSS has many ways to achieve the same visual result - show which properties exist and when each is the right tool.
- For **data modeling**: vary at the schema/relationship level. Show different ways to represent the same domain concept.
- For **state management**: vary at the reactivity/flow level. Show where state lives and how it propagates.
- For **new features**: vary at the architecture level. Show different ways to decompose the feature.

### Option format

Each option in `AskUserQuestion`:
- **Label**: Short name for the approach (e.g., "Grid gap", "Flexbox margin", "CSS clamp()")
- **Description**: One sentence on what it does + one sentence on when it wins
- **Preview**: The actual code block showing what the edit looks like

Mark the recommended option "(Recommended)" and list it first.

### What makes a good recommendation

Prefer the option that is:
1. Most idiomatic for the project's existing patterns (check nearby code)
2. Most maintainable (fewer moving parts, fewer things to remember)
3. Most robust (handles edge cases the user didn't mention)

State the reason in the description: "(Recommended) - matches the flexbox pattern already used in this file." When the problem is visible but the root cause is unclear, state the context and offer the /diagnose skill.

## Phase 3 - Bridge terminology

In the same response as the options (not after), include a **Terms in play** block.
List every domain term and software term that appeared in the options, connecting them:

```
**Terms in play:**
- **`gap`** (CSS) - Spacing between grid/flex children without affecting outer edges. Only works on flex/grid containers. The `row-gap` / `column-gap` longhands control each axis independently.
- **`clamp(min, preferred, max)`** (CSS) - Fluid value that stays between min and max. Replaces media-query breakpoints for font sizes and widths.
- **Fixture** (domain) - A single voyage charter period. The central operational record in this system. See CONTEXT.md > Core Operations.
```

Rules for the terms block:
- For **CSS properties**: include what it controls, what context it requires (flex? grid? block?), and one common gotcha or browser consideration.
- For **domain terms**: connect to CONTEXT.md language. If the term is already defined there, reference the section. If not, define it here and flag it for Phase 4.
- For **software patterns** (e.g., computed vs watcher, reactive vs ref): one sentence on the mental model, one on when to pick it.
- Skip terms that any mid-level developer would know (`const`, `if`, `map`). Explain terms that are specific to a framework, a CSS spec, or this project's domain.

### Further reading

After the Terms block, include a **Further reading** section: 2-3 curated links to the most relevant resource for the central concept in the chosen (or recommended) option.

```
**Further reading:**
- [MDN: gap](https://developer.mozilla.org/en-US/docs/Web/CSS/gap) - full spec behavior, browser compat table
- [CSS-Tricks: A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) - visual reference for all flex properties
```

Rules:
- Never more than 3 links. Fewer is better.
- If nothing adds value beyond the Terms explanation, skip the section entirely.
- For domain concepts: point to the relevant `docs/wpf-reference/logic/` or `docs/wpf-reference/features/` file if one exists.

### Source trust tiers

Only link sources from these tiers. If you cannot find a trusted source for a concept, omit the link rather than linking something questionable.

**Tier 1 - Primary sources (always prefer these):**
- Official specs: W3C/WHATWG (CSS, HTML), TC39 (ECMAScript), IETF RFCs
- Platform references: MDN Web Docs, TypeScript Handbook, Node.js docs
- Framework docs: vuejs.org, pinia.vuejs.org, tanstack.com, vitejs.dev, vitest.dev

**Tier 2 - Trusted authors and publishers (fine as second or third link):**
- web.dev (Google's web platform guidance)
- CSS-Tricks (now DigitalOcean) - the "Complete Guide" series especially
- Josh Comeau (joshwcomeau.com) - CSS and React deep dives
- Lea Verou (lea.verou.me) - CSS and web standards
- Ahmad Shadeed (ishadeed.com) - CSS layout and debugging
- Smashing Magazine - long-form technical articles
- Vue.js core team blogs (e.g., Evan You, Anthony Fu)

**Tier 3 - Verified community (use sparingly, only when T1/T2 has nothing):**
- Stack Overflow answers with 50+ upvotes on the specific topic
- Dev.to or Medium posts ONLY from authors who are known contributors to the relevant project
- Conference talks from framework/spec authors (link the video or slides, not a recap)

**Never link:**
- Generic tutorial farms (w3schools, tutorialspoint, geeksforgeeks, javatpoint)
- SEO-optimized "What is X?" articles that restate the docs with less precision
- AI-generated content aggregators
- Paywalled content without noting the paywall
- Links you are not confident still resolve to the right content (training data URLs may be stale; when uncertain, link the parent docs site and describe where to navigate)

## Phase 4 - Apply and update

After the user picks:

1. Apply the chosen approach.
2. If any **project-specific domain terms** were explained that are not already in `CONTEXT.md`, append them using the existing format:
   ```
   **Term**:
   Definition in one or two sentences.
   _Avoid_: alternate names
   ```
3. Do NOT add general CSS, JavaScript, or Vue terms to CONTEXT.md - only terms specific to this project's maritime/shipping/VMS domain.
4. If CONTEXT.md was updated, mention it: "Added [term] to CONTEXT.md."

## Phase 5 - Quiz (opt-in)

After applying the edit, offer a one-liner: **"Quiz me on this?"**

If the user accepts, present 2-3 quick multiple-choice/short answer questions inline (one question at a time).

### Quiz design

Questions should test the **conceptual model**, not syntax memorization:
- "What happens if you apply `gap` to a `display: block` element?" (tests: understanding that gap requires flex/grid context)
- "You set `clamp(1rem, 4vw, 2rem)` on font-size. At a 300px viewport, which value wins?" (tests: understanding the clamp evaluation)
- "A fixture has status 'Voyage Commenced'. Can you still edit its cargo records?" (tests: domain lifecycle understanding)

Rules:
- Questions must reference the specific concepts from the options the user just compared - not generic trivia.
- Each question gets 3 choices. Wrong answers should be plausible misconceptions, not obviously absurd.
- After the user answers, give a one-sentence explanation of why the right answer is right (or why their answer was wrong). Connect it back to the code they just touched.
- If the user gets all questions right, acknowledge it briefly and move on.
- If they miss one, explain the gap and link to the relevant Further Reading resource.
- Never quiz on more than 3 questions. The point is a quick check, not an exam.

### When to skip the quiz offer

- The edit was trivial (Phase 1 routed around options entirely)
- The user is clearly in a hurry (short prompts, multiple edits in quick succession)
- The concepts involved are ones the user has demonstrated mastery of in this session

## Tone

Keep it brisk.
This is a 60-second decision point, not a lecture.
The user is mid-flow; get them back to building quickly.
