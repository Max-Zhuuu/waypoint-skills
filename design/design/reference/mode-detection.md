# Mode Detection

Check for existing design artifacts:

| File exists | Mode | Action |
|------------|------|--------|
| Nothing in `{DOCS}/design/` | **Greenfield** | Enter wave 1 |
| `{DOCS}/design/DESIGN-BRIEF.md` only | **Resume mid-soul** | Report state, offer wave 1 continue or wave 2 entry |
| `{DOCS}/design/DESIGN-BRIEF.md` + `{DOCS}/design/system/TOKEN-RATIONALE.md` | **Resume mid-tokens** | Report state, offer wave 2 continue or wave 3 entry |
| `{DOCS}/design/system/COMPONENT-SPECS.md` exists | **Resume mid-proof** | Report state, offer wave 3 continue or evolve |
| `styles/tokens.css` exists but no `{DOCS}/design/` | **Retrofit** | Extract implicit decisions, then enter wave 1 or 2 |
| Design system complete, user describes new surface | **Evolve** | Ask: "Extend existing brief or revisit foundations?" |

## Resume detection

If design docs exist, read them and report:

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

## Retrofit detection

If code artifacts exist (tokens.css, component styles) but no design docs:

1. Read the existing token/style files
2. Extract implicit decisions: "Your tokens.css tells me you've already decided on 4px spacing base, compact density, and a blue-gray neutral palette."
3. Present the extracted brief: "Here's what your code says about your design system. Is this intentional or accidental?"
4. User validates or corrects
5. Document validated decisions in DESIGN-DECISIONS.md
6. Show gaps: "You have spacing and layout tokens but no semantic color roles, no type scale rationale, no motion philosophy, no interaction state definitions."
7. Route to the appropriate wave based on what's missing
