# Architecture Review

A discipline for finding and fixing architectural friction in a codebase.
The goal is deepening: turning shallow modules into deep ones to improve testability, locality, and leverage.

## Who this is for

Anyone maintaining a codebase that has grown harder to change, test, or understand.
If the architecture is clean and changes land easily, this document is overhead.
If you keep bouncing between files to understand one concept, start here.

## Vocabulary

Use these terms consistently. Drifting into "component," "service," "API," or "boundary" blurs the concepts.

**Module** - anything with an interface and an implementation. Scale-agnostic: function, class, package, or tier-spanning slice.

**Interface** - everything a caller must know to use the module. Not just the type signature: includes invariants, ordering constraints, error modes, configuration, and performance characteristics.

**Implementation** - the code inside a module.

**Depth** - leverage at the interface. A module is deep when a lot of behavior sits behind a small interface. A module is shallow when the interface is nearly as complex as the implementation.

**Seam** - where an interface lives. A place you can alter behavior without editing in that place.

**Adapter** - a concrete thing satisfying an interface at a seam.

**Leverage** - what callers get from depth. More capability per unit of interface they learn.

**Locality** - what maintainers get from depth. Changes, bugs, and knowledge concentrate in one place.

### Principles

- **Depth is a property of the interface, not the implementation.** A deep module can be internally composed of small parts - they just are not part of the interface.
- **The deletion test.** Imagine deleting the module. If complexity vanishes, it was a pass-through. If complexity reappears across N callers, it was earning its keep.
- **The interface is the test surface.** Callers and tests cross the same seam.
- **One adapter means a hypothetical seam. Two adapters means a real one.** Do not introduce a seam unless something actually varies across it.

## Phase 1 - Explore

Read the project's domain glossary and architecture decisions first.
Then walk the codebase, noting where you experience friction:

- Where does understanding one concept require bouncing between many small modules?
- Where are modules shallow - interface nearly as complex as the implementation?
- Where have pure functions been extracted for testability, but the real bugs hide in how they are called?
- Where do tightly-coupled modules leak across their seams?
- Which parts are untested, or hard to test through their current interface?

Apply the deletion test to anything you suspect is shallow.
"Would deleting this concentrate complexity?" is the signal you want.

Use the project's domain language when naming what you find.
The domain gives names to good seams; architecture decisions record choices not to re-litigate.

## Phase 2 - Present candidates

For each candidate, document:

- **Files** - which modules are involved.
- **Problem** - why the current architecture causes friction. Be specific.
- **Solution** - what would change, in plain language.
- **Benefits** - stated in terms of locality and leverage, including how tests would improve.
- **Before/after** - a visualization or description showing the shallowness and the deepening.
- **Strength** - one of: Strong, Worth exploring, Speculative.

End with a top recommendation: which candidate you would tackle first and why.

Do not propose interfaces yet. Present the candidates and let the reviewer choose.

## Phase 3 - Deepen

Once a candidate is chosen, work through the design:

### Classify dependencies

The dependency category determines how the deepened module is tested.

**In-process** - pure computation, in-memory state, no I/O.
Always deepenable. Merge the modules and test through the new interface directly. No adapter needed.

**Local-substitutable** - dependencies with local test stand-ins (e.g. an in-process database, in-memory filesystem).
Deepenable when a stand-in exists. Tests run with the stand-in. The seam is internal.

**Remote but owned** - your own services across a network boundary.
Define a port at the seam. The deep module owns the logic; transport is injected as an adapter. Tests use an in-memory adapter. Production uses the real transport.

**True external** - third-party services you do not control.
The deepened module takes the dependency as an injected port. Tests provide a mock adapter.

### Design the interface

Explore at least two radically different interfaces before committing. Your first idea is unlikely to be your best.

For each alternative, define:
1. The interface: methods, parameters, invariants, error modes.
2. A usage example showing how callers use it.
3. What the implementation hides behind the seam.
4. The dependency strategy and adapters.
5. Trade-offs: where leverage is high, where it is thin.

Evaluate alternatives against the seam discipline:
- One adapter means a hypothetical seam. Two adapters means a real one.
- Internal seams (private to implementation, used by tests) and external seams (the module's interface) are different. Do not expose internal seams just because tests use them.

### Replace tests, don't layer them

Old unit tests on shallow modules become waste once tests at the deepened module's interface exist. Delete them.
Write new tests at the interface. Tests assert on observable outcomes, not internal state.
Tests should survive internal refactors. If a test changes when the implementation changes but behavior does not, it was testing past the interface.

## Phase 4 - Record decisions

If a candidate is rejected for a load-bearing reason (not "not worth it right now"), record the decision so future reviews do not re-suggest it.
If the deepening introduces a term not in the project glossary, add it.
If the deepening contradicts an existing architecture decision, make that conflict explicit before proceeding.

## Adapting to your context

### Solo developer

Run Phase 1 as a journal exercise. The friction you feel daily is the signal.
Phase 2 can be a text list - the visualization matters more in team settings.
Phase 3 benefits from writing two interface alternatives even solo. The comparison reveals assumptions.

### Team session

Phase 1 works well as a collective walk-through: each person names their friction points.
Phase 2 becomes a shared document or whiteboard. Vote on which candidate to tackle.
Phase 3 is a design session: assign two people to independently design an interface, then compare.

### With an AI assistant

Use the AI for Phase 1 exploration - it can read more code faster than you.
Challenge the AI's candidates: it will over-report shallow modules that are intentionally thin (adapters, mapping layers).
Own the Phase 3 interface design. The AI can generate alternatives, but the trade-off judgment is yours.

### AI agent

The agent runs Phase 1 and presents Phase 2 as a visual report.
The agent pauses for the reviewer to choose a candidate.
Phase 3 becomes a grilling conversation: the agent walks the design tree, surfacing constraints and dependencies.
Side effects happen inline: glossary updates, architecture decision records, scope changes.
