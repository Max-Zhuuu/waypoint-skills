# Adapters and fail-loud cases

`/ship` reads this at Step 1 (resolve adapter) and Step 5 (route).
The adapter names the delivery mechanism only.
The Intent block, the afk gate, and the escalate rule are adapter-independent: switching adapters changes how a change ships, never what counts as shippable.

## Adapter behavior

| Adapter | PR surface | Auto path | On an `afk` change |
|---|---|---|---|
| `github-pipeline` | Yes | Yes (server-side enforcement is the authority) | Open PR, auto-eligible label, leave the merge to the pipeline |
| `github-plain` | Yes | No (no server-side authority exists) | Open a labelled PR, but a human merges - never auto-merge |
| `local` | No | No | Prepare the branch, write the Intent template, present inline, exit |
| `other` | Per its own note in DEPLOY.md | Only if that note names a real authority | Treat as `github-plain` unless the note documents server-side enforcement |

`github-plain` never auto-merges because there is no server-side enforcement to be the authority.
The auto-eligible label is a routing hint for a human, not a merge trigger.

## Fail-loud and degenerate cases

- **No DEPLOY.md, or a malformed fenced block.**
  Error and stop, matching the fail-loud tier read of a real pipeline.
  Print what is missing and suggest `/setup` (or the one-time `/ship` fallback ask) to author it.
  Never treat "no load-bearing globs" as vacuously safe - a missing config is `hitl`, not `afk`.

- **`adapter: local`.**
  No remote, no PR, no auto path.
  Prepare the branch, write the Intent template, present inline, and exit.
  There is no unattended-merge path resting on a local list.

- **A slice left untagged.**
  Counts as `hitl` (key 1a), so the change escalates rather than silently auto-shipping.

- **Tests unverifiable (no known command).**
  Annotate the PR "tests: unverified" and route `hitl`; do not block, and do not claim green.

## Why load-bearing is deny-only

The `load-bearing` list can only ever force `hitl` earlier; it can never grant `afk`.
That is safe because Waypoint no longer holds merge authority: the list is an advisory shift-left hint, not an auto-approve mechanism.
For `github-pipeline`, the pipeline's own never-auto-approve list is the authority; where it is machine-readable, DEPLOY.md should point at it rather than re-enumerate it.
Glob dialect, rename/deletion handling, and the match-only rule are pinned in ENGAGEMENT-REFERENCE.md section 13.4.
