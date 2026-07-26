# Chain validation: exercise every guard and gate before leaning on `auto`

`auto` self-invokes skills, so it is the riskiest surface in the method, and it ships experimental.
This harness is the gate it must pass before `auto` is documented as safe to lean on.
Until every check here passes on a real engagement, `auto` stays experimental: the default is `suggest`, which changes nothing about today's behavior, and `auto` prints a one-line experimental notice when it engages.

## What "validated" means

Three things must hold on a real flow, not just on paper:

1. Every guard predicate is exercised - both branches of each - and resolves the edge the table ([CHAIN-REFERENCE.md](CHAIN-REFERENCE.md)) says it should.
2. Every gate actually halts and returns control to the human.
3. R1's equivalence property holds: an `auto` run of a flow is identical to a hand-run of the same flow, minus the typing.

## Guard matrix

Run a real engagement (a small spec through to the ship gate) and confirm each guard resolves as specified. Exercise both the true and the false side of each.

| Guard | Exercise it false | Exercise it true |
|---|---|---|
| `SPEC` | no spec file: nothing auto-advances into breakdown (spec is the entry) | a spec on disk: edge 1 clean to breakdown |
| `SLICED` | a spec with no `## Implementation Slices`: no tdd hop, breakdown has not run | slices present: edge 2/3 eligible |
| `REM` | every slice carries a done marker (`REM = 0`): leave tdd toward review | a remaining slice: edge 4 (or 2) fires; an absent or unresolvable marker reads as remaining (fail-safe) |
| `NEXT_HITL` | next slice tagged `afk`: edge 2/4 clean | next slice tagged `hitl` or untagged: edge 3/5 is a GATE, stop and ask |
| `CONC` | no open concern: edge 7 eligible | open-concern count greater than zero after review: edge 8, loop-back GATE |
| `REVIEWED` | reviewed-hash does not match the current diff: not ship-eligible | reviewed-hash matches: edge 7's `¬CONC · REVIEWED` holds (still a GATE - ship is always a gate) |

## Gate halts to confirm

Each of these must stop and hand control back, in `auto` mode, with a printed reason:

- Edge 3 / 5 (`NEXT_HITL`): a `hitl` or untagged slice halts before `tdd`.
- Edge 6 with `review.autorun` not `auto`: the hop into review is a stop, never a silent escalation (R3).
- Edge 7 (`review -> ship`): always a gate; `auto` parks at the ship gate, never through it.
- Edge 8 (`CONC`, the loop-back): a hard stop; the human routes (R1 - backward edges are always gates).
- Any backward or loop edge: never auto-routed (R1).

## R1 equivalence check

Take one flow (for example a two-slice `afk` spec through review) and run it twice: once under `chain: auto`, once by hand invoking the same skills.
Assert they are identical in everything that matters:

- the same skills run in the same order,
- the same confirmations are surfaced to the human (crossing 4 on each `tdd` diff, crossing 2 on any persona, the ship confirmation),
- the same commits and diffs result,
- `auto` halts at exactly the gates the hand-run would have stopped to think at.

The only permitted difference is that `auto` did not require the human to retype the next-skill invocation between clean hops.
If any other difference appears, `auto` is more or less permissive than manual, which violates the master invariant - a failure, not a tuning issue.

## The downgrade condition

When every guard row, every gate halt, and the equivalence check pass on a real engagement, and only then:

- remove `auto`'s experimental notice and this experimental caveat,
- document `auto` as safe to lean on.

Until then, `auto` remains experimental and is not a recommended default-capable value.
This harness records what "validated" requires; it is not itself a pass.
