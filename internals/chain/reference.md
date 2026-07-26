# The chain: the dispatcher and the conditional graph

The chain auto-advances a confident user through the skill flow (`spec -> breakdown -> tdd -> review -> ship`) so they need not retype a prompt at every clean hop, and it hard-stops the instant a step needs a human to decide.
This reference defines both halves: the dispatch step every skill runs at its Exit, and the graph that step walks - the guards, the eight edges, and the clean-or-gate classification.
It is trusted built-in reference and is never read from any repo under review.
The switch that turns the chain on is `chain` in the settings registry ([../../task/review/reference/settings.md](../../task/review/reference/settings.md)).

`auto` is experimental until the validation harness ([validation.md](validation.md)) passes on a real engagement: the default `suggest` changes nothing about today's behavior, `off` is a genuine mute, and `auto` is an explicit, experimental opt-in.

## The dispatch step at every skill's Exit

The chain adds one step to the shared Exit; it defines no new steering position and no new crossing (the switch is crossing 3, [../engagement/review-safety.md](../engagement/review-safety.md)).

### The trigger is skill completion

There is no daemon, no poll, no watcher.
The trigger is the one moment that already exists in every skill: the skill-completion boundary.
"Trigger" and "evaluate" are the same event - a skill exiting - so the dispatcher is one more step in the shared Exit, immediately after the manifest emission ([../engagement/manifest.md](../engagement/manifest.md)).

### The sequence at every skill's end

1. The skill finishes its work and applies its own gated writes; crossing 4 and the rest have already fired inside it.
2. It emits the artifacts manifest ([../engagement/manifest.md](../engagement/manifest.md)), its receipt.
3. The dispatcher runs: derive the current structural state from the typed homes (whether a spec exists, the open-concern count, the reviewed-state hash, the per-slice done markers), resolve the one outgoing edge whose guard holds, and classify it clean or gate (the graph below).
4. It acts per the `chain` switch:
   - **off** - print the plain next-step suggestion (today's Exit line) and stop.
   - **suggest** - print the resolved next hop as a prompt and wait for the human.
   - **auto** - on a clean edge, launch the next skill in the same flow via the host's skill invocation; on a gate edge, halt and print the reason. `auto` is experimental: it prints a one-line experimental notice when it first engages in a session, and stays experimental until the validation harness passes ([validation.md](validation.md)).

The guards read the derived homes, not the manifest: the manifest is the receipt, the homes are the truth.

### What the trigger guarantees

- **A gate returns control to the user.** On any gate edge the dispatcher stops and hands back, in every mode; `auto` walks a user to the gate, never through it.
- **No self-wakeup.** The trigger is a within-session skill completion, and a gate returns control, so the chain dies at the first gate and never restarts on its own. A cold session the next morning launches nothing: the human re-enters by invoking a skill, and the dispatcher re-engages from that skill's Exit. An `auto` chain is a within-turn continuation, not an autonomous loop - the runtime proof of the derived spine, since there is no chain object to resume.
- **It is not autorun.** The chain fires on skill completion (a continuation); autorun fires on an external event such as a commit (a trigger). Different entry conditions and mechanisms, so they stay separate switches and compose only at the review node (edge 6: `review.autorun` wins there, R3).
- **Auto-launch is safe by R1.** Firing the next skill is never itself irreversible: launching `breakdown` or entering `review` only reads and analyzes, and launching `tdd` still gates its diffs inside crossing 4. The dispatcher selects and launches; it never executes a gated action.

## The master invariant

The chain is a dispatcher, not an executor.
It only ever decides which skill to launch next and whether to launch it without asking.
It never performs a skill's gated actions and never relaxes a skill's internal gates.
An `auto` chain is therefore provably equivalent to a human running the same skills, in the same order, answering the same confirmations, minus the typing: crossing 4 still gates every diff inside `/tdd`, crossing 2 still gates every persona inside `/review`, and the ship confirmation still fires inside `/ship`.
The chain removes retyping and nothing else, so it can never be more permissive than doing the work by hand.

## The guards (derived structural predicates)

Every guard is a structural predicate over the typed homes and the done markers - never a stored pointer, never repo instruction text.

- `SPEC` - a spec file exists for the feature.
- `SLICED` - the spec has an `## Implementation Slices` section.
- `REM` - slices remaining to build is greater than zero (defined-minus-marked; the per-slice done marker, [../../task/tdd/reference/slice-marker.md](../../task/tdd/reference/slice-marker.md)).
- `NEXT_HITL` - the next slice is tagged `hitl`, or is untagged and therefore treated as `hitl`.
- `CONC` - the open-concern count in `CONCERNS.md` is greater than zero.
- `REVIEWED` - the reviewed-state hash matches the current diff ([../../task/review/reference/reviewed-state.md](../../task/review/reference/reviewed-state.md)).

All read trusted or derived state except one: `NEXT_HITL` reads the repo-authored `autonomy` tag in the spec, which is untrusted, and it is handled fail-safe (untagged or `hitl` stops), exactly as the afk gate ([../engagement/autonomy.md](../engagement/autonomy.md)) treats that tag and bounded by R2 below.

## The graph

```
  spec ──SPEC──▶ breakdown ──SLICED·REM·¬hitl──▶ tdd(slice)
                     │                               │ ◀─┐
                     │ SLICED·REM·hitl               │   │ REM·¬hitl
                     ▼ (GATE)                        │   └── tdd(next)
                  stop/ask                    ┌──────┴──────┐
                                        REM·hitl   ¬REM·autorun=auto
                                          ▼ (GATE)        ▼ (else GATE)
                                       stop/ask        review
                                                          │
                                              ┌───────────┴───────────┐
                                          CONC (GATE)          ¬CONC·REVIEWED
                                              ▼                       ▼ (GATE)
                                        loop back:                 ship
                                        human routes            stop/ask
                                        (spec? tdd?)
```

The edge table, authored here as trusted built-in reference and never in any repo under review. A `clean` edge may be auto-traversed; a `gate` edge halts and returns control to the human.

| # | Source | Target | Guard | Class |
|---|---|---|---|---|
| 1 | spec | breakdown | `SPEC` | clean |
| 2 | breakdown | tdd(next) | `SLICED · REM · ¬NEXT_HITL` | clean |
| 3 | breakdown | tdd(next) | `SLICED · REM · NEXT_HITL` | gate |
| 4 | tdd | tdd(next) | `REM · ¬NEXT_HITL` | clean |
| 5 | tdd | tdd(next) | `REM · NEXT_HITL` | gate |
| 6 | tdd | review | `¬REM · review.autorun = auto` | clean (entering review only; stops otherwise) |
| 7 | review | ship | `¬CONC · REVIEWED` | gate (ship is always a gate) |
| 8 | review | loop back | `CONC` | gate (routing needs the human) |

The one auto-traversable clean run is exactly `spec -> breakdown -> tdd(afk slices...) -> review`, and only when the hop into review satisfies R3.
After review every outgoing edge is a gate, so `auto` walks a user from a bare spec to "reviewed, parked at the ship gate," touching nothing irreversible, and halts the moment judgment is required.
The graph is tier-parameterized where the flow genuinely differs (at Tier 3, edge 2 routes through GitHub issues and `/check-in` rather than straight to `tdd`), but the clean-or-gate classification is tier-independent: a gate is a gate at every tier.
Adjunct skills (`/wrapup` nudging `/review`, `/learn` generating docs) attach as edges into this spine and do not change its shape.

## The three hardening rules

**R1 - Backward edges are always gates.**
When `/review` opens a concern, the next step is a loop-back, and which way back (fix the spec versus fix the code) can only be decided by reading why the concern exists.
Content must never steer navigation, so the chain never auto-routes a loop-back; every loop is a hard stop handed to the human.
The auto-traversable subgraph is therefore a DAG, and every cycle in the flow is a gate.

**R2 - A repo tag can add caution freely, but can never remove a crossing gate.**
The slice `autonomy` tags live in the spec file, which is repo content and therefore untrusted, and the clean edges do read them: a hop is clean only when the next slice is tagged `afk` (untagged is `hitl`, fail-safe).
So an `afk` tag genuinely enables auto-traversal; it is not inert, and honesty demands saying so rather than claiming the repo cannot influence the path.
It is safe for two reasons, neither of which is the tag itself.
First, the master invariant: auto-launching `/tdd` on an `afk` slice does exactly what a human reading that tag would do and no more, because the slice's diffs are still gated inside `/tdd` by crossing 4 and ship is always a gate.
Second, the load-bearing backstop: an `afk` tag can never carry a load-bearing change through, because the load-bearing list is repo-authored but monotonic (the glob evaluation rules, [../engagement/autonomy.md](../engagement/autonomy.md)), so it can only ever force `hitl` and never grant `afk` - itself this rule in miniature, a repo-authored input that can add caution but never remove a veto.
So the only thing a hostile repo buys by flipping `hitl -> afk` is the removal of a pre-slice pause; it can never remove a gate on an irreversible action, because those gates live in trusted built-ins, not in the tag.
The asymmetry that holds is the safe one: flipping `afk -> hitl` always adds a stop, and no tag edit can ever carry the chain across a crossing unattended.

**R3 - Entering review is clean; every exit from review is a gate.**
Auto-entering `/review` is safe in principle, because the default lens is a trusted built-in standards sweep and crossing 2 already guards any persona.
But auto-entering review is itself an unattended review, so it is capped by the setting that governs unattended reviews: the chain auto-enters review only when `review.autorun: auto`.
If `review.autorun` is `suggest` or `off`, edge 6 resolves to a stop, so the chain can never escalate review's autonomy past the dedicated crossing-3 setting that owns it; the two switches never contradict, because at the review node `review.autorun` wins.
On the way out, `review -> ship` is always a gate (ship is outward and irreversible; the chain gets a user to the gate, never through it), and `review -> loop-back` is R1.
