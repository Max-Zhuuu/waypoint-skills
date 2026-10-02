# Engagement Protocol

Read [engagement-protocol.json](engagement-protocol.json) first.
It is the authoritative, machine-readable contract for tier detection, step tracking, concern emission, write discipline, and enforcement.

This file exists only for behavioral narrative that JSON cannot express - tone, examples, and the "how" behind the structured "what."

## Related references

- [autonomy.md](autonomy.md) - the autonomy axis (afk/hitl)
- [review-safety.md](review-safety.md) - review safety invariant (5 untrusted-text crossings)
- [manifest.md](manifest.md) - artifacts manifest emission
- [../chain/reference.md](../chain/reference.md) - chain dispatcher

## Behavioral guidance

### Tier 1 adaptations

State each adaptation once, in one sentence, then move on.
Do not repeatedly mention what's missing.
The substitution table in engagement-protocol.json#tier_defaults.tier_1.cross_reference_substitutions is exhaustive - don't invent new ones.

### Nudge tone

Nudges are specific and grounded, not abstract.

Good: "Undocumented rule: vessel status requires confirmation before transition."
Bad: "Found an undocumented business rule."

Good: "This affects VesselCard, VesselList, and FixtureCard - all have status transitions."
Bad: "Undocumented rules can cause inconsistencies."

### Deepening suggestions

At most once per session, when concern history shows a pattern:

```
You have 8 open assumptions, 3 with medium risk and no validate-by date.
/setup can run a structured validation pass if you want
to stress-test these before they become real problems.
```

### Deferred-doc escalation

Never blocking.
The user can always say "not now."
But the debt is visible and escalates per the pressure curve in engagement-protocol.json#exit_protocol.deferred_doc_pressure.

### Multi-skill invocation

When the user names more than one skill in a single request, do not start executing.
Stop and confirm the order first: restate the skills you detected, propose a sequence with a one-line reason, ask the user to confirm.
Then run one at a time, carrying output into the next.

## Exit sequence

Every skill ends with the same two-step sequence (see engagement-protocol.json#exit_sequence).
A skill's `## Exit` cites it in one line and lists only its own unique handoffs:

```markdown
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md).
```

Conditional handoffs: when a condition plainly does not hold, skip silently.
Do not narrate the skip.
