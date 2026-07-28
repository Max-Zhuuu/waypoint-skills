# Verifiable Workflows

A discipline for making large parallel fan-out auditable: a success metric, a reconciliation ledger, and a default-fail validation posture so incorrect output is flagged, never assumed correct.
Works for any fan-out over many near-identical components (endpoints, screens, entities, modules), with any toolchain.

## Who this is for

Anyone building N roughly homogeneous components that must each be checked against something.
If the work is a single feature down the ordinary spec-to-tdd-to-review path, this document is overhead.
If forty components are about to collapse into one "done" with no record of what was actually verified, what was assumed, and what roadblocks arose, start here.

## The core principle

Correctness is never assumed.
A component is unverified until it produces evidence from a named oracle.
Silence is a fail, not a pass.
Completion is the aggregate of individually-passed components in a ledger, never one reviewer verdict over the batch.

## When it applies

The shape is triggered, not assumed.
It fires when the work is a fan-out over many components validated against something: a breakdown that yields N roughly homogeneous components measured against a source of truth, any migrate horizontal-buildout, or any explicit parallel build.
As a rule of thumb, reach for this machinery at roughly five or more homogeneous components sharing one validation target; below that, the ordinary path is correct and this is overhead.
Homogeneity is a spectrum: the more the components share a shape and a source of truth, the more the ledger and the metric pay off.

## Elicitation is a harness generator, not a questionnaire

The point of the questions is that their answers deterministically select the validation harness for this project.
Answer the context-agnostic questions and a project-specific harness falls out; that is how a customized solution arises without bespoke work.

| The answer to ... | selects ... |
|---|---|
| unit of parallelization (endpoint / screen / entity / module) | the ledger's row identity and the fan-out lanes |
| source of truth each unit is checked against | the oracle class (see the flow below) |
| "is there an exact expected output?" | specified oracle vs metamorphic/property oracle |
| "does a reference implementation or legacy system exist?" | differential / parallel-run against it |
| per-unit acceptance criteria | the denominator of criterion completeness |
| target pass-rate and why not 100% | the SLO and the error budget |

The questions, grouped:

- **Parallelization:** what is the unit, how many, homogeneous or not, what is shared vs isolated per lane, and what source of truth is each unit validated against?
- **Metric:** what is the target pass-rate and why not 100%, what makes one unit fully accurate (its per-unit criteria), and what is the zero-error definition?
- **Validation:** how does the validator get expected-vs-actual independently of the implementer, what evidence class is required to pass a unit, where do discrepancies go with what deadline, and what is the roadblock-escalation path when a lane stalls?
- **Documentation:** where does the ledger live and who updates it per unit?

## The generalized validation flow

One reusable loop, task-agnostic; only the oracle changes.

> build component -> the validator independently obtains expected, never from the implementer's self-report -> select the oracle by task shape -> grade the evidence by rank -> write the ledger row -> gate the batch on the metric.

The oracle-selection branch is the adaptable part:

- A trusted source of truth exists (legacy system, reference library, a second independent build): differential / parallel run on identical inputs; a mismatch is loud, silence is never proof.
- A reference output can be pinned: golden-master / approval; any unreviewed diff is a hard fail, and a changed master needs a recorded human approve.
- No exact answer but relations hold: metamorphic relations (round-trip, permutation-invariance, monotonicity, cross-surface consistency); a violation proves a defect with no reference answer.
- Invariants or round-trips exist: property-based tests with shrinking to a minimal reproducing case.
- A spec with acceptance criteria: the specified oracle, the criteria as assertions.
- Always, as a floor: the implicit oracle (it builds, it typechecks, it does not crash).

## The evidence hierarchy

Every "correct" verdict names which oracle produced it, ordered by how independently the expected answer was obtained from the implementer.

| Rank | Mechanism | Oracle class | How expected is obtained |
|---|---|---|---|
| 1 | Differential / Parallel Run vs a trusted reference | derived, independent | a second source of truth computes it on the same input |
| 2 | Golden-master / approval vs pinned output | derived | prior/reference snapshot, diffed |
| 3 | Metamorphic relations | derived | relation between related inputs' outputs |
| 4 | Property-based with shrinking | specified/derived | author-declared invariants under randomized attack |
| 5 | Specified oracle (assertions, acceptance criteria) | specified | human-written expected values |
| 6 | Implicit oracle (builds, typechecks, no crash) | implicit | universal must-not properties |
| 7 | Human or LLM "looks correct" | human | reviewer judgment |

The operational rule: a component is unverified until it has evidence at rank 1-5 with a named oracle.
Rank 6 is necessary hygiene and rank 7 is necessary judgment, but neither is ever sufficient to mark a component correct.
Absence of evidence is a fail, not a pass; "no oracle possible" (Weyuker's non-testable case) escalates for design attention and never licenses a pass.

## The two-level success metric

Success is defined on two levels plus a process-health guard, so "passed" stays honest and separable from "partially done."

- **Component pass-rate** = components passing their own independent gate / components required.
  Completion is the aggregate of individually-passed shards, never one monolithic "done."
  The target is an SLO strictly below 100% with a declared error budget: for example at least 95% must fully pass, and the remaining budget is a tracked set of known-incomplete components, each logged with a reason.
  A sub-100% target is therefore an auditable decision, not sloppiness.
- **Criterion completeness (granular)** = a component's met acceptance criteria over its total (k/n), rolled up across the batch.
  Reported as precision (of components produced, the fraction correct), recall (of components required, the fraction produced correctly), and their F1, so silently dropping the hard components cannot inflate the headline score.
  A component is Passed only when k equals n, tests are green, and no discrepancy is open; otherwise it is Partial (with its k/n) or Missing/Failed.
- **Process-health guard (statistical process control).**
  Track the per-shard failure rate against a baseline control limit; a shard breaching well above baseline is a special-cause signal, so halt and diagnose the shared root cause before producing the rest of the batch rather than grinding through a bad run.
  Track an escape rate (defects found after a component's gate versus before) to measure how good the gate itself is.

## The reconciliation ledger

The ledger is the missing output document, a committed artifact at `docs/workflows/{name}/ledger.md` built from [the ledger template](../templates/workflow-ledger.md).
It has one row per component: component id, spec ref, lane or agent, status (built / partial / failed / not-started), criteria (k/n with the unmet ones named), evidence class and named oracle, discrepancy pointers into CONCERNS.md, and roadblocks encountered.
Its header carries the target pass-rate, the current pass-rate, and the current criterion completeness, all computed from the rows.
The metric is defined once, in the ledger, and every other surface cites it and never recomputes it, exactly as the autonomy axis is authored once and rendered everywhere else.
This is what structurally prevents the squash: the reviewer cannot collapse the batch into a single verdict, because each row demands its own evidence and named oracle before it counts.

## Controlled adversarial validation

The validator receives expected and actual per component but not the implementer's claim of success.
"Tests pass" is re-run fresh at validation time.
Verdicts are per component, never aggregate.
The posture is stop-the-line: a detected defect halts that lane and is surfaced, never logged-and-passed downstream (jidoka), and checks that make a defect class structurally impossible (types, schemas, pre-commit gates) are preferred over catching it late (poka-yoke).

### The Knight-Leveson guardrail

When multiple validators are used, independently-built checkers share correlated blind spots on ambiguous inputs, so validator agreement is evidence and never proof.
Diversify what the validators attack (different oracle classes, adversarial inputs, spec-ambiguity probes) rather than running the same check many times.
Treat an unresolved spec ambiguity as its own failure mode that consensus cannot paper over.

## Dynamic control flow and validator roles

When a fan-out grows an orchestrator that decides its own paths, the validation discipline has to extend with it.
The load-bearing commitment holds throughout: validation strength comes from independence and external oracles, not from more agents or more introspection.
Two consequences follow.
Intrinsic self-correction degrades accuracy, so a reflection loop is admissible only when it is keyed to a real failing signal (a failed test, a metamorphic violation, a differential divergence), never to introspection alone.
And a validator built from the same model, prompt, and spec-reading as the generator shares its blind spots and will agree with a wrong answer, so independence has to be engineered rather than assumed.
The frame is the workflow-versus-agent distinction: a workflow runs predefined paths, an agent directs its own, and self-direction is added only when a simpler path falls short.

This section is itself a worked example of the evidence hierarchy.
The article that prompted it (a marketing post on "dynamic workflows") was a rank-7 source that failed verification: its illustrative config and its headline speedup figure were invented, and no primary source corroborated the named feature.
So what follows rests only on the corroborated patterns beneath it, never on the product claims.

### The validator roles

Each role carries a contract and the failure mode it defends; use only the ones a given fan-out earns.

| Role | Contract (in -> out) | Defends against |
|---|---|---|
| Oracle-selector | component spec + interface -> a ranked oracle plan, or a "no strong oracle" flag | weak-oracle laziness, defaulting to rank-7 judgment when a stronger oracle exists |
| Metamorphic-relation generator | spec + I/O types, never the implementation -> executable relations (transform + assertion) | the oracle problem and correlated blind spots, since relations come from the spec not the code |
| Differential / parallel-run executor | component + an independently produced twin + input corpus -> divergence set with minimal repro | self-reported correctness, provided the twin is genuinely diverse |
| Adversarial spec-ambiguity prober | spec + component -> inputs that split interpretations at the ambiguous regions | Knight-Leveson coincident faults, which cluster on the hard, ambiguous parts of a spec |
| Jury of diverse critics | output + rubric -> per-juror score, aggregated verdict, recorded dissent | LLM-as-judge self-preference, position, and verbosity bias, mitigated only by disjoint model families |
| Reconciliation-ledger auditor | all validator outputs -> graded ledger, unresolved-conflict list, batch-gate recommendation | the squash, task-graph drift, and a node marked done on weak evidence |
| Externally-grounded reflection agent | component + concrete failure evidence -> revised component keyed to that signal | intrinsic-self-correction degradation, by forbidding introspection-only revision |

The jury is a last resort, used only where no mechanical oracle exists; its verdict is recorded as weak (rank-5-or-below) evidence, never as proof, and a panel drawn from one model family is not a jury.

### The control-flow patterns

Each attaches at a specific point in the flow.

- **Oracle-first gating** at the build-to-validate boundary: no component is validated until the oracle-selector has produced a plan, and a component whose only check is a jury is flagged low-evidence from birth.
- **Bounded evaluator-optimizer loops** at each validation node: generate, check, repair, under a hard iteration cap, with the evaluator always a mechanical oracle or a diverse jury, never the generator judging itself.
- **As-needed decomposition** at orchestration: fan out a subtask only when a worker demonstrably fails it, never eagerly into hundreds of agents, so fan-out is a response to shown complexity rather than a default.
- **Budget-driven validator depth** at the policy layer: spend more validation on the nodes the ambiguity-prober flagged, the nodes with only weak oracles, and the high-blast-radius nodes, and give cheap components cheap checks.
- **Stop-the-line on coincident failure** at the ledger auditor: when diverse twins diverge on a spec-ambiguous input or a jury splits sharply, halt and escalate rather than auto-repairing, because coincidence is the Knight-Leveson danger signal.

### The risks specific to dynamic fan-out

| Risk | Why it bites | Mitigation |
|---|---|---|
| Unbounded fan-out | more agents is more cost and un-auditable state, not more correctness | as-needed decomposition, hard concurrency and depth caps, budget-driven sizing |
| Task-graph drift | a runtime planner can assert its own subtasks done with no external check | every node carries an externally checkable success predicate, a parent is done only when its children's oracles pass, and the auditor refuses planner-asserted completion |
| Correlated validator failure | a same-family validator shares the generator's blind spots and agrees with a wrong answer | prefer mechanical oracles, derive relations from the spec not the code, make juries genuinely disjoint, and run the ambiguity-prober |
| Self-judgment theater | introspective revision without ground truth degrades accuracy | ban introspection-only validation and key every reflection loop to an external failing signal |
| Unearned green batches | fan-in makes "all workers finished" look like "all work is correct" | the batch gate is a threshold on graded evidence, not a completion count, and any open coincident-failure flag blocks it |

## Adapting to your context

### Solo developer

Keep the ledger as a single committed markdown table; it doubles as your progress board.
Pick the strongest oracle you can afford per component and record the rank honestly; a rank-5 specified oracle on every row still beats a rank-7 glance.

### Team

The ledger is the shared contract: one row per component, each owned by whoever built it, each demanding its own evidence before it counts as done.
The process-health guard is where a team catches a systemic mistake early instead of shipping it forty times.

### AI agent

The agent runs the fan-out, writes each ledger row with its named oracle and rank, and stops the line on a special-cause spike rather than grinding through a bad batch.
The agent never marks a component correct on rank 6-7 evidence alone, and it surfaces a "no oracle possible" component for human design attention instead of passing it.

## Grounding

The evidence hierarchy is the test-oracle taxonomy (Barr, Harman, McMinn, Shahbaz, Yoo, IEEE TSE 2015; Weyuker, 1982).
Validation without a reference answer is metamorphic testing (Chen et al., 1998) and property-based testing (Claessen and Hughes, QuickCheck, 2000).
Validation against a source of truth is differential testing (McKeeman 1998; Regehr et al., Csmith, 2011), the Parallel Run (Fowler), golden-master/characterization (Feathers, 2004), and GitHub's Scientist.
The sub-100% target is an SLO with an error budget (Google SRE, 2016); the granular metric is precision/recall/F1; the batch-health guard is statistical process control (Shewhart; Deming).
The at-scale operating model is Google's Large-Scale Changes / Rosie (Software Engineering at Google, 2020, ch. 22).
The stop-the-line posture is the Toyota Production System (Ohno's jidoka; Shingo's poka-yoke), with the correlated-failure caveat that validator agreement is evidence not proof (Knight and Leveson, 1986).
The dynamic-control-flow section builds on Anthropic's "Building Effective Agents" (2024) for the workflow-versus-agent frame and the evaluator-optimizer and orchestrator-workers patterns, ADaPT (Prasad et al., NAACL Findings 2024) for as-needed decomposition, the panel of diverse LLM evaluators (Verga et al., 2024) for the jury, and the self-correction literature (Huang et al., ICLR 2024; Shinn et al., Reflexion, 2023; Madaan et al., Self-Refine, 2023) for the rule that reflection helps only with an external signal, with the judge-bias caveats from Wu et al. (2024) and Ye et al. (2024).
The prompting n1n.ai "dynamic workflows" post was assessed as a rank-7 source and rejected as non-credible, so none of its product claims are load-bearing here.
