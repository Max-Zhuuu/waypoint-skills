# Method Selection

A discipline for turning a method fork into a recommendation with a reason.
Works at any fork between a lighter and a heavier path (build directly or slice it, one pass or a parallel fan-out, ship or review first), with any toolchain.

## Who this is for

Any skill or person standing at a fork with two valid methods and no obvious pick.
If the method is already obvious (a one-line typo fix does not need a spec), this document is overhead.
If you are about to present a menu ("/breakdown to decompose, or /tdd to build directly?"), stop and read this: a fork is a recommendation, not a menu.

## The core rule

A recommendation names a method, cites a quantifiable signal, and says when the lighter method is fine anyway.
The reason is never a feeling.
It is a count Waypoint already has: file count, component count, acceptance-criteria count, or whether the change touches a DEPLOY.md load-bearing surface.

## The three axes

Rigor is recommended along three orthogonal axes.

- **Problem shape (Cynefin) decides what kind of work comes first.**
  A clear task with a known pattern: just build.
  A complicated task that needs expertise: spec or analyze first.
  A complex or novel task where you cannot specify what you do not yet understand: prototype a throwaway experiment before committing.
- **Reversibility (one-way vs two-way doors) decides how much upfront caution.**
  A reversible change justifies moving light and fast.
  An irreversible change (a schema or data migration, a public API, a security boundary) justifies heavyweight spec and review.
  This axis already exists in Waypoint as the afk/hitl autonomy tag and the DEPLOY.md load-bearing list; render that signal, do not recompute it.
- **Option timing (the Last Responsible Moment) decides when to spend the rigor.**
  Keep options open while uncertainty is high and the decision is cheap to defer.
  Commit, and add rigor, as the moment approaches where further delay would foreclose an option you need.

## The two deltas

On top of the axes, a recommendation answers two questions explicitly.

- **Output-quality delta:** will the heavier path produce a measurably better, more detailed artifact here?
- **Documentation delta:** will the heavier path leave more comprehensive and accurate documentation?
  A test suite documents behavior; a reconciliation ledger documents what actually shipped; a direct build leaves neither.

## The signal table

| When the signal is ... | favor the heavier method ... | because |
|---|---|---|
| more than roughly 5 files or more than 1 domain touched | `/breakdown` over a single pass | a sliced plan is a better and more detailed artifact than one big diff |
| forward-looking, testable behavior | `/tdd` over a direct build | the test suite is the documentation of behavior |
| many near-identical components (endpoints, screens, entities) | a verifiable parallel workflow with a ledger | the ledger is the only record that each component was actually verified (see [verifiable-workflows.md](verifiable-workflows.md)) |
| output must match a source of truth | the verifiable-workflow path | correctness needs an oracle, not a glance (see [verifiable-workflows.md](verifiable-workflows.md)) |
| the change touches a DEPLOY.md load-bearing surface | `/review` before `/ship` | an irreversible surface justifies a critic pass |

## The phrasing contract

Every fork emits one line in this shape:

> Recommend X, because {quantified output reason} and {documentation reason}. Y is fine if {condition}.

## The default is the lightest method that preserves the option

Applying the heavy process everywhere is the failure all three axes warn against: Cynefin's category error, the scaled-org one-way-door reflex, and premature commitment at once.
So the default is the lightest method that still preserves the option you need, and the burden of proof is on escalating rigor, never on skipping it.

## Grounding

Cynefin: Snowden and Boone, "A Leader's Framework for Decision Making," HBR 2007.
Reversible vs irreversible: Bezos, one-way/two-way doors, Amazon 2015 shareholder letter.
Last Responsible Moment: Poppendieck, "Lean Software Development," 2003; Matts and Maassen, real options.
