# The per-slice done marker

The chain walks the implementation slices of a spec: build slice N, advance to N+1, and stop when none remain.
To know "none remain" it needs a completion signal, and shipped `/tdd` produces none - it commits, but a commit is not a per-slice done record.
This marker is that signal, and nothing more.

## What it is

- **Skill-authored structural bookkeeping.** On completing a slice, `/tdd` writes a done marker keyed by (project identity, slice id). Its entire payload is structural - the project key and the slice id. It carries no observed content, no prose, and no "where you are": it is not a position pointer and not a chain object.
- **The same exemption as reviewed-state.** Because its payload is purely structural, it is skill-authored bookkeeping outside section 14.1's chat-confirmation rule, exactly as reviewed-state is ([reviewed-state.md](../../review/reference/reviewed-state.md)): there is no user content to confirm and no observed content that could ride in.

## Where it lives, and why

It is kept in the user-global trusted config, keyed by (project identity, slice id), under the switches' key-provenance rule: a user-asserted identity - the worktree path or an id you confirmed in chat - never repo-supplied metadata ([settings.md](../../review/reference/settings.md)).
Because the project half of the key is user-asserted, a repo cannot write this marker for itself.

## How the position is derived: `REM`

Position is not stored; it is re-derived each turn.
`REM` (slices remaining to build) is defined-minus-marked: the slices the spec's `## Implementation Slices` section defines, minus the ones that carry a done marker.

- If every defined slice has a marker, `REM = 0` and the intra-`tdd` walk is complete.
- If a marker is **absent or unresolvable** - no marker, or an id that matches no defined slice - that slice collapses to "remaining unknown," which counts as remaining: a gate, never a false clean. The chain re-gates the work rather than skipping it.
- Slice-id drift between runs therefore fails safe. An unmatched id reads as unbuilt, so the work is re-offered, never silently skipped; even a coincidental id reuse only skips re-building that one slice, and never bypasses `/tdd`'s own crossing-4 diff gate or the ship gate.

## What it does not do

It stores no ordering, no "current slice," and no resume point.
The chain never resumes itself from a stored position; it re-derives `REM` from the spec plus the markers every turn, so nothing drifts and nothing resumes itself.
