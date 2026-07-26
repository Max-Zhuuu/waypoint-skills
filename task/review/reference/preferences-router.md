# The preferences router: where "remember this" goes

When you say "remember X" - or a skill proposes remembering something - the point is to file it where it belongs, not to dump it into a junk drawer.
Most "preferences" are a symptom that something has not been filed yet.
So the router prefers a typed home, and the narrow personal note is the last resort, not the first.

## The routing order

Try each in order; the first that fits wins. The personal note is reached only when every typed route declines.

1. **Architecture** - a decision about how the system is built, with a trade-off worth recording? Route to an ADR (`/grill-with-docs`) or ARCHITECTURE.md.
2. **Convention** - a rule about how code or UX is written ("validate at the boundary," "a button never styled as a link")? Route to CONVENTIONS.md / NAMING.md / UX.md.
3. **Scope** - what is in, out, or uncertain this cycle? Route to SCOPE.md.
4. **Glossary** - a domain term with a definition? Route to GLOSSARY.md.
5. **Soft working style** - a cross-project feeling about how you like to work ("I like terse commit messages," "explain before you code")? That is not a Waypoint setting; route it to your host's native memory, which already stores this. Waypoint does not rebuild it.
6. **The narrow personal note** - what survives all five: genuinely personal, specific to this one project, not something you would commit, and neither a switch nor a fact any typed doc will take. This is the residual; it stays narrow or it becomes the muddy bucket the typed docs exist to prevent. It lives in the user-global config, keyed to the project ([settings.md](settings.md)), never committed.

A switch (a deterministic "when X, always Y") is not a note: it goes in the switch registry ([settings.md](settings.md)), not here.
The routing is the anti-junk-drawer discipline: the earlier a route fits, the better the thing is filed, and the note only ever holds what genuinely fits nowhere else.

## The write path (into the trusted note)

The personal note is trusted context ([review-safety.md](../../../internals/engagement/review-safety.md), crossing 5), so a write to it is exactly the one rule:

1. **Propose in chat.** "Want me to remember X?" where X is drawn from what *you* said in this conversation.
2. **Confirm in chat.** Confirmation is mandatory, never implied by silence.
3. **Write** - in your words, or a paraphrase you approved.

Observed content may *prompt* the question but never *supplies* the answer.
Reading a repo that always validates at the boundary may make the assistant ask "want me to remember you prefer that?", but the thing stored is your confirmation, not the repo's content: the repo suggested a question, you supplied the stored answer.
An inferred-from-repo preference is never written to the note without a fresh chat confirmation.

Routes 1-4 write to a typed project doc, an ordinary shared-file write that follows that doc's own conventions and Claims discipline; the chat-confirmation ceremony is what guards the trusted *note* specifically, because the note is trusted context injected as ground truth and a typed doc under review is not.

## Forgetting is low-ceremony

Removal can only ever reduce what steers the assistant, never introduce steering, so "forget that" just removes the note.
Writing is the high-ceremony direction; forgetting is not.
