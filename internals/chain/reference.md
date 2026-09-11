# The chain dispatcher

The chain auto-advances through the skill flow so the user need not retype a prompt at every clean hop, and hard-stops when a step needs a human decision.
Edge data (source, target, guard, clean/gate) lives in each skill's `skill.json` `chain` field.
The test suite (`tests/test-chain.sh`) assembles and validates the full graph from those declarations.
This doc defines only the semantics: what guards mean, what the dispatch step does, and the three safety rules.

The switch that turns the chain on is `chain` in the settings registry ([../../task/review/reference/settings.md](../../task/review/reference/settings.md)).
Modes: `off` (plain next-step suggestion), `suggest` (resolved hop as prompt, wait), `auto` (experimental: launch on clean edges, halt on gates).

## The master invariant

The chain is a dispatcher, not an executor.
It decides which skill to launch next and whether to launch it without asking.
It never performs a skill's gated actions and never relaxes a skill's internal gates.
An `auto` chain is provably equivalent to a human running the same skills in the same order - it removes retyping and nothing else.

## The dispatch step

Fires at every skill's Exit, after the artifacts manifest.
Derives structural state from typed homes (spec existence, concern count, reviewed-state hash, done markers).
Resolves the one outgoing edge whose guard holds, classifies it clean or gate, acts per the switch.
A gate always returns control to the human.
No self-wakeup, no daemon, no poll.
`auto` is a within-turn continuation, not an autonomous loop.

## Guard vocabulary

| Guard | Predicate |
|-------|-----------|
| `SPEC` | A spec file exists for the feature |
| `SLICED` | The spec has an `## Implementation Slices` section |
| `REM` | Slices remaining > 0 (defined minus marked; see [slice-marker.md](../../task/tdd/reference/slice-marker.md)) |
| `NEXT_HITL` | Next slice tagged `hitl` or untagged (untagged = `hitl`, fail-safe) |
| `TRIAGED` | An item has been selected and categorized by /triage |
| `BUG` | The triaged item is categorized as a bug |
| `CONC` | Open concern count > 0 |
| `REVIEWED` | Reviewed-state hash matches current diff |

All read trusted or derived state.
`NEXT_HITL` reads the repo-authored autonomy tag (untrusted), handled fail-safe: untagged stops.

## The three hardening rules

**R1 - Backward edges are always gates.**
Content must never steer navigation.
Every loop-back (review -> spec, review -> breakdown) is a hard stop.
The auto-traversable subgraph is therefore a DAG.

**R2 - A repo tag can add caution, never remove a crossing gate.**
An `afk` tag enables auto-traversal of a slice hop, but the slice's diffs are still gated inside `/tdd` (crossing 4) and ship is always a gate.
A hostile `afk` tag buys removal of a pre-slice pause, never removal of a gate on an irreversible action.

**R3 - Entering review is clean only when `review.autorun: auto`.**
Auto-entering review is capped by the dedicated crossing-3 setting.
Every exit from review is a gate (ship is outward/irreversible, loop-back is R1).
