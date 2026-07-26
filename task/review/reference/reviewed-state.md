# Reviewed-state: the double-review guard

Two skills should not both review the same diff, and a repo must not be able to mark itself reviewed to skip its own auto-review.
Reviewed-state is the one durable fact that serves both: "this exact diff was reviewed."

## What it is

- **Pinned to the diff snapshot.** The key includes a commit or diff hash, so a new commit re-opens eligibility: reviewing diff A never marks diff B reviewed.
- **One durable fact.** Just "this exact diff was reviewed," nothing about the findings. It is distinct from the session-only findings note ([findings-note.md](findings-note.md), throwaway routing state) and from wrapup's gate verdict (a criteria tally); it replaces neither.

## Where it lives, and why

Reviewed-state is kept in the same user-global trusted config as the switches ([settings.md](settings.md)), keyed by (project identity, diff hash), with the same key-provenance rule: a user-asserted identity, never repo-supplied metadata (see [autorun.md](autorun.md)).
Suppressing a review is itself a scrutiny-reducing behavior, so it lives in trusted config for the same crossing-3 reason `autorun` does ([review-safety.md](../../../internals/engagement/review-safety.md)).
That is exactly why it cannot live in the repo: a repo-authored "already reviewed" marker would let a hostile pull request skip its own auto-review - the autorun key-provenance bug in a new costume.
It is never read from a repo-authored marker.

## How it is written

`/review` writes reviewed-state when it completes a review of the current diff, without a chat confirmation.
That is not an exception to section 14.1's write rule so much as outside its subject: 14.1 and crossing 5 guard *user-authored* trusted content - the personal note and your preferences - against being set from observed content ([settings.md](settings.md)).
Reviewed-state is neither. It is skill-authored bookkeeping whose entire payload is structural - a diff hash the review just computed and a user-asserted project key - so there is no user content to confirm and no observed content that could ride in. The rule that guards user-authored content has nothing to guard here, because a hash is not steering text.

## How it is read

- **wrapup** and the **pre-ship moment** defer to a *suggestion* when the current diff is already reviewed ("this diff was already reviewed; review again?") and re-open the nudge when the diff changes. They never block on it.
- An explicit **`/review` always runs**, reviewed-state or not: the guard suppresses a redundant *automatic* nudge, never a review you asked for.
- **ship** reads it as a non-blocking note only, honoring ship's "does not review" boundary: it never gates shipping on reviewed-state.
