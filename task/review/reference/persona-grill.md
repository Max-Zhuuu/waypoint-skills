# Authoring a persona: the grill

A persona is a trusted, auto-invocable review lens.
An ungrounded "vibe" lens is unaccountable steering, so authoring one is a grill, not a fill-in-the-blank.
The grill refuses a lens that cannot answer all four:

1. **Domain.** What body of practice does this lens speak for? (accessibility, data privacy, API design, brand voice.) A lens with no domain is not a lens; it is a mood.
2. **Three failure modes.** Name three concrete things this lens is meant to catch that the default standards sweep would miss or underweight. Not "bad code" - three specific, checkable failures ("a focus trap with no escape," "a PII field logged in plaintext," "a primary action styled as a link").
3. **Lens boundary.** What does this lens deliberately *not* look at? A lens that claims to check everything re-weights nothing; the boundary is what makes it a lens and not a second full sweep.
4. **Citation basis.** What does the lens cite when it flags something - a standard, a guideline, a design principle, a documented convention? A finding with no basis is an opinion, and an opinion that auto-invokes is exactly the hazard.

## What it writes

When all four are answered, the grill writes an agent file to `~/.claude/agents/<name>` (user-global, trusted): the name, a one-line identity, the domain, the three failure modes as lens questions, the boundary, and the citation basis.
The persona is now runnable by name and eligible for auto-invocation, because it lives in the trusted user-global tier and is read by absolute path ([personas.md](personas.md), the trust gate).

A persona is a weighting over the standard categories ([what-it-checks.md](what-it-checks.md)), not a new axis: its findings still carry one of the fixed category names, so a lens changes emphasis, never the vocabulary that crosses into a concern ([review-safety.md](../../../internals/engagement/review-safety.md), crossing 1).

## What it refuses

- An ungrounded vibe lens (no domain, or no citation basis): refused. "Make it feel premium" is not a lens until it names the domain (visual design), the failure modes (inconsistent spacing scale, off-token color, weak hierarchy), the boundary, and the basis (the design system).
- Fewer than three concrete failure modes: refused, with a prompt to sharpen.
- A lens whose boundary is "everything": refused; that is the default sweep, not a lens.

Authoring is a chat-confirmed write to trusted config (section 14.1): you answer the grill, you confirm, then it writes.
Observed content may prompt the idea but never supplies the lens.
