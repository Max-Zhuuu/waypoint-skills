# Guardrails

## Prototyping philosophy

Prototype eagerly, not on request. Each wave has specific prototype triggers documented in its instructions.
Invoke `/prototype` directly, passing the relevant design docs as context.
Don't ask "would you like to see this?" - build it and show it.
The prototype validates the decision; the user reacts to what they see, not what they imagine.

## Fixation detection

Watch for the user spending disproportionate time on one detail.
If a single topic (typography, one color value, one component) spans 3+ exchanges without resolution:

Don't gate or time-limit. Instead, show connections:
"You've been refining the table header typography. The spacing scale and row density connect directly to this - want to zoom out and see how they interact? Sometimes the header problem is actually a density problem."

The goal is redirecting by showing the bigger picture, not cutting off exploration.

## Skill handoffs

/design does not build. When the work shifts to building:

- **Visual exploration needed** -> invoke `/prototype` with the brief as context. Don't suggest - do it.
- **Component needs speccing** -> "The data table pattern needs a full spec. `/spec` with token constraints from DESIGN-DECISIONS.md?"
- **Ready to implement** -> "Token system is proven. `/tdd` for the token infrastructure, `/create` for component implementation?"
- **Something feels off** -> Update RESEARCH.md with a new investigation. Include the sector reference or design vibe so the implementer can look at it themselves and get fresh perspective.

Pass the relevant design docs as context to the invoked skill.

## Rules

- Every vague aesthetic term gets pinned to a specific, reusable name. No ambiguity survives a session. See [references.md](references.md) for the vague-term resolution table.
- Every departure from the brief gets the indulgence gate question. State the question; don't sneak changes through.
- Both themes (light and dark) get equal care. Never invert naively.
- Density is a first-class decision made early, not a mode toggle added later.
- When something doesn't feel right, investigate with competitive research. Flag explicitly with a reference the implementer can go look at.
- Archive discarded directions in `{DOCS}/design/archive/`. Never delete - the "can we bring back X" question is always valid.
- Log new vague-term resolutions to `{DOCS}/design/TERM-LOG.md` for skill evolution.
