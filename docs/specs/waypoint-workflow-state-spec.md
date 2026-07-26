# Spec: workflow-state - the chain, a derived position and a skill-completion trigger

Status: draft for review.
Companion to the artifacts-manifest spec, the settings spec, the `/review` loop-back spec, and the `/ship` seam spec.
Sequenced after the manifest (which it reads) and alongside the settings spec (whose switch registry holds its one switch).
The `auto` behavior ships experimental and is not a default-capable value until the validation slice passes.
Written in plain English on purpose.

## The idea in one paragraph

A confident user who trusts the system should not retype `/breakdown`, `/review`, `/ship` at every hop of a flow they run twenty times a week.
Waypoint's aspiration is to make the well-worn path `spec -> breakdown -> tdd -> review -> ship` first-class, so the developer chooses how far they lean on the tools instead of reinventing long prompts.
The discipline that keeps this from becoming careless velocity is a single rule: a chain compresses navigation, never judgment.
It removes the typing between steps and stops dead the instant a step requires a human to decide.
This spec defines what "where am I in the flow" means, how the next hop is chosen and classified, and what actually fires the advance.

## The spine: the position is derived, not stored

There is no `WORKFLOW.md`, no chain-instance object, no session pointer.
"Where am I" is re-computed each turn from structural records, most of which already exist: a spec on disk, an `## Implementation Slices` section, `CONCERNS.md`, and (once the settings spec builds it) the reviewed-state hash.
Every skill already ends with "X written, `/next` to do Y", so the successor graph is already latent in those Exit lines; this spec only makes it resolvable and gated.

One record the spine needs does not exist today, and this spec must add it.
Nothing in the shipped skills records that a slice was built: `/tdd` declares `Writes: none` and emits only `[provisional]` commit markers with no slice identity, and the slice format has no done field.
So the intra-`tdd` walk (advance from slice N to slice N+1, and know when none remain) has no completion signal to read.
This spec adds one as skill-authored structural bookkeeping: a per-slice done marker homed in the user-global trusted config, keyed by (project identity, slice id), exactly analogous to reviewed-state and under the same exemption to the chat-write rule (its payload is purely structural, so no observed content enters trusted config through it).
It is deliberately not a position pointer and not a chain object: position stays derived (remaining equals defined minus built), so nothing drifts and nothing resumes itself.

Why deriving position is the spine, and not an implementation detail:

- The manifest spec already ruled that a persisted mirror drifts and the files are the record.
  The same logic applies here with higher stakes, because a stored "you are here" pointer can lie about position and a derived one cannot.
- It collapses a whole class of bugs.
  There is no interrupted chain to resume, no stale chain-instance, no orphaned session state, because the chain is not a stored thing.
  The artifacts, plus the per-slice done markers, are the state; the chain is a switch plus a re-derivation each turn.
- It keeps the Waypoint thesis intact.
  The only new storage is the chain switch and the per-slice done marker, both narrow and structural; everything else is read back from the typed homes the method already writes.

Neither new persisted thing is a workflow store: the switch is one entry in the settings switch registry, and the done marker is per-slice structural bookkeeping, not a record of "where you are".

## The conditional graph

Nodes are skills.
Edges are guarded transitions.
Every guard is a structural predicate, never a stored pointer.
All but one read trusted or derived state; the single exception is `NEXT_HITL`, which reads the repo-authored `autonomy` tag and is handled fail-safe (untagged or `hitl` stops), exactly as section 13.3 already treats that tag and bounded by R2 below:

- `SPEC` a spec file exists for the feature
- `SLICED` the spec has an `## Implementation Slices` section
- `REM` slices remaining to build is greater than zero
- `NEXT_HITL` the next slice is tagged `hitl`, or is untagged and therefore treated as `hitl`
- `CONC` the open-concern count is greater than zero
- `REVIEWED` the reviewed-state hash matches the current diff

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

The auto-traversable clean run is exactly `spec -> breakdown -> tdd(afk slices...) -> review`, then stop, where that last hop into review is clean only when `review.autorun: auto` (see R3).
After review every outgoing edge is a gate, so `auto` walks a user from a bare spec to "reviewed, parked at the ship gate", touching nothing irreversible, and halts the moment judgment is required.

The edge table, authored in trusted built-in reference and never in any repo under review:

| # | Source | Target | Guard | Class |
|---|---|---|---|---|
| 1 | spec | breakdown | `SPEC` | clean |
| 2 | breakdown | tdd(next) | `SLICED · REM · ¬NEXT_HITL` | clean |
| 3 | breakdown | tdd(next) | `SLICED · REM · NEXT_HITL` | gate |
| 4 | tdd | tdd(next) | `REM · ¬NEXT_HITL` | clean |
| 5 | tdd | tdd(next) | `REM · NEXT_HITL` | gate |
| 6 | tdd | review | `¬REM · review.autorun=auto` | clean (entering review only; stops otherwise) |
| 7 | review | ship | `¬CONC · REVIEWED` | gate (ship is always a gate) |
| 8 | review | loop back | `CONC` | gate (routing needs the human) |

The graph is tier-parameterized where the flow genuinely differs (at Tier 3 edge 2 routes through GitHub issues and `/check-in` rather than straight to `tdd`), but the clean-or-gate classification is tier-independent: a gate is a gate at every tier.
Adjunct skills (`/wrapup` nudging `/review`, `/learn` generating docs) attach as edges into this spine and do not change its shape.

## The master invariant

The chain is a dispatcher, not an executor.
It only ever decides which skill to launch next and whether to launch it without asking.
It never performs a skill's gated actions and never relaxes a skill's internal gates.
An `auto` chain is therefore provably equivalent to a human running the same skills, in the same order, answering the same confirmations, minus the typing.

This is the property the whole spec must preserve.
Crossing 4 still gates every diff inside `/tdd`.
Crossing 2 still gates every persona inside `/review`.
The ship confirmation still fires inside `/ship`.
The chain removes retyping and nothing else, so it can never be more permissive than doing the work by hand.

## The three hardening rules

**R1 - Backward edges are always gates.**
When `/review` opens a concern, the next step is a loop-back, and which way back (fix the spec versus fix the code) can only be decided by reading why the concern exists.
Content must never steer navigation, so the chain never auto-routes a loop-back.
Every loop is a hard stop handed to the human.
The auto-traversable subgraph is therefore a DAG, and every cycle in the flow is a gate.

**R2 - A repo tag can add caution freely, but can never remove a crossing gate.**
The slice `autonomy` tags live in the spec file, which is repo content and therefore untrusted, and the clean edges do read them: a hop is clean only when the next slice is tagged `afk` (untagged is `hitl`, fail-safe).
So an `afk` tag genuinely enables auto-traversal; it is not inert, and honesty demands saying so rather than claiming the repo cannot influence the path.
It is safe for two reasons, neither of which is the tag itself.
First, the master invariant: auto-launching `/tdd` on an `afk` slice does exactly what a human reading that same tag would do and no more, because the slice's diffs are still gated inside `/tdd` by crossing 4, and ship is always a gate.
Second, the load-bearing backstop: an `afk` tag can never carry a load-bearing change through, because the load-bearing list is repo-authored but monotonic (section 13.4), so it can only ever force `hitl` and never grant `afk`.
That backstop is itself this rule in miniature: a repo-authored input that can add caution but never remove a veto.
So the only thing a hostile repo buys by flipping `hitl -> afk` is the removal of a pre-slice pause; it can never remove a gate on an irreversible action, because those gates live in trusted built-ins, not in the tag.
The asymmetry that does hold is the safe one: flipping `afk -> hitl` always adds a stop, and no tag edit can ever carry the chain across a crossing unattended.

**R3 - Entering review is clean; every exit from review is a gate.**
Auto-entering `/review` is safe in principle, because the default lens is a trusted built-in standards sweep and crossing 2 already guards any persona.
But auto-entering review is itself an unattended review, so it is capped by the setting that governs unattended reviews: the chain auto-enters review only when `review.autorun: auto`.
If `review.autorun` is `suggest` or `off`, edge 6 resolves to a stop, so the chain can never escalate review's autonomy past the dedicated crossing-3 setting that owns it, and the two switches never contradict, because at the review node `review.autorun` wins.
On the way out, `review -> ship` is always a gate, since ship is outward and irreversible and the chain gets a user to the gate, never through it, and `review -> loop-back` is R1.

## The trigger mechanism

The trigger is the one moment that already exists in every skill: the skill-completion boundary.
There is no daemon, no poll, no watcher.
The shared Exit protocol carries one more step, and "trigger" and "evaluate" are the same event, a skill exiting.

The sequence at every skill's end:

1. The skill finishes its work and applies its own gated writes; crossing 4 and the rest have already fired inside it.
2. It emits the artifacts manifest, its receipt.
3. The dispatcher runs: derive the current structural state from the typed homes, resolve the outgoing edge whose guard holds, classify it clean or gate.
4. It acts per the switch:
   - `off`: print the plain next-step suggestion (today's Exit line) and stop.
   - `suggest`: print the resolved next hop as a prompt and wait.
   - `auto`: on a clean edge, launch the next skill in the same flow via the host skill invocation; on a gate edge, halt and print the reason.

The guards read the derived homes (spec exists, concern count, reviewed-hash), not the manifest.
The manifest is the receipt; the homes are the truth.

Three properties fall out of choosing this trigger:

- **No self-wakeup.**
  The trigger is a within-session skill-completion, and a gate returns control to the user, so the chain dies at the first gate and never restarts on its own.
  A cold session the next morning launches nothing; the human re-enters by invoking a skill, and the dispatcher re-engages from that skill's Exit.
  An `auto` chain is a within-turn continuation, not an autonomous loop, and this is the runtime proof of the derived spine: there is no chain object to resume, so nothing resumes itself.
- **It is what separates the chain from autorun.**
  The chain fires on skill completion, a continuation.
  Autorun fires on an external event such as a commit, a trigger.
  Different entry conditions and different mechanisms, so they stay separate switches and compose only at the review node.
- **Auto-launch is safe by R1.**
  Firing the next skill is never itself irreversible: launching `breakdown` or entering `review` only reads and analyzes, and launching `tdd` still gates its diffs inside crossing 4.
  The dispatcher selects and launches; it never executes a gated action.

## The switch

One entry in the settings switch registry, sharing the `off / suggest / auto` vocabulary, trusted, user-global, keyed per-project by user-asserted identity, exactly like `autorun`.

- `off`: every hop is manual; a genuine mute.
- `suggest`: at each clean hop, name the next step and wait.
  This is the default, and it is essentially today's behavior, since the Exit lines already suggest the next step, so the default is both fail-safe and a no-op relative to what ships today.
- `auto`: traverse clean hops without asking, stop at gates.
  Experimental (see below), and the only value that self-invokes a skill.

Absent config falls back to `suggest`, the careful behavior, for the same fail-safe reason `autorun` falls back to `suggest`.

## How this extends section 14

The chain adds no new steering position.
The edge table and its guards live in trusted built-in reference, never in a repo under review.
The guards read trusted or derived state, with one repo-authored input, the `autonomy` tag, which is read fail-safe (R2) and can never carry the chain across a crossing, exactly the treatment section 13.3 already gives that tag, so it opens no new exposure.
By R1 the chain performs no gated action, so it introduces no new crossing.

The one new trusted thing is the switch, and turning `off -> auto` is a setting escalating behavior, which is crossing 3 already, the same slot the settings spec puts `autorun` in.
So S0 names the chain switch as another crossing-3 setting and stops there; no new crossing, no surgery to the two positions or the four crossings.

## Experimental

`auto` self-invokes skills, so it is the riskiest surface in the method, and it ships flagged experimental.

- The spec carries an experimental banner, and `auto` prints a one-line experimental notice when engaged.
- The default stays `suggest`, which changes nothing about today's behavior.
  `auto` is an explicit opt-in; `off` is a genuine mute.
- `auto` is not recommended as a default-capable value until the validation slice passes.

An honest limit worth naming: the acceleration `auto` delivers is exactly "walk the `afk` slices", so a project that tags most slices `hitl`, or leaves them untagged (which is `hitl`), will see `auto` behave much like `suggest`.
That is correct rather than a defect: a cautious project should see little acceleration, and the tag that unlocks acceleration is the same one a human would have read before proceeding by hand.

## Non-goals

- It does not store a chain object or a position pointer.
  The position is derived every turn; nothing about "where you are" is persisted.
- It does not weaken any within-skill gate.
  Diffs, personas, and ship all keep their own confirmations under R1.
- It does not auto-route a loop-back, ever.
  Deciding why a concern exists is the human's, under R1.
- It does not fire on external events.
  That is autorun; the chain fires only on skill completion.
- It does not draw the workflow map.
  A map is a downstream read over manifests and this graph, never a control surface that feeds back into behavior, as the manifest spec fixed.

## Implementation Slices

Decomposed for build.
Safety-first ordering: the graph and trigger are defined and proven to stop before `auto` is offered.

### Slice W0 - the chain switch as a crossing-3 setting
**Depends on:** the settings spec's switch registry (S2)
**Autonomy:** hitl
**Files:** internals/ENGAGEMENT-REFERENCE.md (section 14, one sentence naming the chain switch as a crossing-3 setting alongside `autorun`), the settings switch registry entry
**Done when:** the chain switch exists in the registry with `off / suggest / auto` and default `suggest`, keyed per-project in user-global trusted config; section 14 names it as another crossing-3 setting and confirms the chain adds no new steering position and no new crossing.
**Notes:** documentation-of-behavior slice; it stores the switch, not the graph.

### Slice W1 - the per-slice done marker
**Depends on:** the settings spec's trusted home (S1)
**Autonomy:** hitl
**Files:** task/tdd/SKILL.md (write the marker on slice completion); a new reference defining the marker; task/breakdown/reference/slice-format.md (note that completion is recorded, not stored in the spec)
**Done when:** on completing a slice, `/tdd` writes a structural done marker to the user-global trusted config keyed by (project identity, slice id), carrying no observed content; `REM` is derived as defined-minus-marked, so an unresolvable or absent marker collapses to "remaining unknown" and yields a gate, never a false clean.
**Notes:** this is the record the derived spine needs and that shipped `/tdd` does not produce; it mirrors reviewed-state's chat-write exemption (S4) because its payload is purely structural; it is bookkeeping, not a position pointer, so nothing about "where you are" is stored.
Because it keys on the user-asserted project identity, a repo cannot write it; and because an unmatched slice id reads as unbuilt, id drift between runs fails safe (it re-gates the work rather than skipping it, and even a coincidental id reuse only skips building, never bypasses crossing 4 or the ship gate).

### Slice W2 - the edge table and guards, defined once
**Depends on:** W0, W1
**Autonomy:** hitl
**Files:** a new trusted reference (e.g. internals or the review reference) holding the edge table, the derived predicates, and the clean-or-gate classification
**Done when:** the eight edges, their guards, and the three hardening rules are written as trusted built-in reference; the guards are structural predicates over the typed homes and the done markers; the reference states explicitly that the table is never read from any repo under review, that the one repo-authored input (the `autonomy` tag) is read fail-safe and can never carry the chain across a crossing (R2), and that edge 6 is clean only when `review.autorun: auto` (R3).

### Slice W3 - the dispatcher at the Exit boundary
**Depends on:** W2, the artifacts-manifest emission (A0), and the settings reviewed-state slice (S4, for the `REVIEWED` guard)
**Autonomy:** hitl
**Files:** internals/ENGAGEMENT-REFERENCE.md (the standard Exit protocol gains a dispatch step after the manifest emission)
**Done when:** the shared Exit defines: derive state, resolve the guarded edge, classify, and act per the switch (`off` prints the plain suggestion, `suggest` prompts and waits, `auto` launches on clean and halts with a reason on a gate); it states that the trigger is skill-completion only, that the chain never self-wakes, and that a gate returns control to the user.

### Slice W4 - skills carry the dispatch Exit
**Depends on:** W3
**Autonomy:** hitl
**Files:** every skill in the graph (spec, breakdown, tdd, review, ship, and the adjuncts wrapup and learn), one Exit reference line each
**Done when:** each skill's Exit cites the shared dispatch protocol rather than restating it, so the behavior is byte-uniform across skills; a skill with no outgoing clean edge simply resolves to a gate and stops.

### Slice W5 - validation, and only then recommend auto
**Depends on:** W4
**Autonomy:** hitl
**Files:** a validation note or test harness exercising the graph on a real engagement
**Done when:** every guard predicate is exercised on a real flow, every gate is shown to actually halt, and R1's equivalence property (`auto` equals manual minus typing) is checked against a hand-run of the same flow; only after this passes is `auto` documented as safe to lean on, and the experimental banner is downgraded accordingly.

## Decisions resolved (for the record)

- Position is derived, not stored; there is no chain-instance and nothing to resume.
  The one new structural record is a per-slice done marker (skill-authored, user-global, keyed by project and slice id, like reviewed-state), because shipped `/tdd` records no completion signal.
- One switch in the shared `off / suggest / auto` vocabulary, default `suggest`, trusted and project-keyed like `autorun`.
- The chain is a dispatcher, not an executor (R1); it never relaxes a within-skill gate.
- Backward edges are always gates (R1); a repo `autonomy` tag can add caution but can never carry the chain across a crossing gate (R2); entering review is clean only when `review.autorun: auto`, and every exit from review is a gate (R3).
- The trigger is the skill-completion boundary; the chain never self-wakes and never fires on external events (that is autorun).
- The chain adds no new steering position and no new crossing; the switch is a crossing-3 setting.
- `auto` ships experimental; default `suggest` changes nothing about today's behavior.

## Open for your review

None blocking.
The one judgment call left for the build is where exactly the edge table reference file lives (a new internals file versus folding it into the review reference), which W2 settles without touching the design.
