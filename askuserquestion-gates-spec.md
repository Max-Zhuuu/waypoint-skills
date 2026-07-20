# AskUserQuestion Gates Spec

Decisions for adding structured decision gates across the skill family.
Created 2026-07-19. Survives compaction.

## Meta-decisions

### M1: AskUserQuestion UX pattern

**Problem:** AskUserQuestion is fast when the user knows what they want, but annoying when they want to discuss further before deciding.

**Decision:** Every AskUserQuestion that gates a non-trivial decision should include two standing options beyond the domain choices:

- **"Let me think about this"** - drops back to chat. The agent explains the trade-offs conversationally, then re-presents the question when the user is ready.
- **"Explain more (/learn mode)"** - agent switches to /learn-style elaboration: terms in play, further reading, concrete examples from the repo. After elaboration, re-presents the original question.

These are NOT additional AskUserQuestion options (that would clutter every gate). They are behavioral: if the user selects "Other" and types something conversational, the agent treats it as "let me think about this." If the user explicitly asks for more context or says "explain," the agent invokes learn-mode depth.

**Status:** IMPLEMENTED

**Context bloat mitigation:** When learn-mode fires mid-gate, scope the elaboration to the specific decision. Don't elaborate all options - only the ones the user asks about. Cap at one terms block + one further reading link. Re-present the AskUserQuestion after elaboration, not a second elaboration.

### M2: Decision registry for /project-setup resume

**Problem:** As more AskUserQuestion gates are added, the user has no way to review past decisions without re-reading each file.

**Decision:** Option (a) - /project-setup resume path reads canonical locations and presents as reviewable AskUserQuestion sequence.

Implementation:
- **Read phase:** fast summary table of all decisions with current values. No AskUserQuestion - just print.
- **Reinvest phase:** multiSelect "Which decisions to revisit?" Only selected items get the full gate re-presentation.
- **Edit phase:** surgical updates. Each gate has a spec that maps choice -> exact file edits (what to rewrite, what to leave). Agent reads the spec, not its own judgment.
- **Cascade warning:** when a change has downstream effects on files with content, warn with specific impact before confirming. Intentional friction on destructive cascades.
- **Spec requirement:** a resume-path spec doc must be generated during /project-setup that maps each decision to: canonical location, AskUserQuestion shape, edit operations per choice, cascade effects. This is the agent's instruction set for the resume path - without it, the agent flails.

**Status:** IMPLEMENTED

### M3: Resolution cascade deduplication

**Problem:** The resolution cascade (source validation -> test validation -> human validation) is defined in three places: check-in/SKILL.md, wrapup/SKILL.md, migrate/05-integration.md.

**Decision:** Define once in README.md under "Key Concepts > Resolution Cascade" (already the most complete version at lines 89-94). Replace inline definitions in check-in, wrapup, and integration with a one-liner reference: "Apply the resolution cascade (see README.md)."

**Status:** IMPLEMENTED

### M4: README.md staleness

**Problem:** README.md has three contradictions with post-restructure state:
- Lines 109-113: old 3-question intake vs new composable archetypes
- Lines 71-76: old review-agent model vs new /wrapup suggestion
- Lines 96-99: review allocation duplicated from port/REFERENCES.md

**Decision:** Fix all three. No separate doc needed - the fixes are mechanical (bring README current with existing skill files). The spec doc you're reading is the record of what and why.

**Status:** IMPLEMENTED

---

## Gate decisions

### G1: Parity strategy gate

**Location:** migrate/SKILL.md:33-36
**Current state:** Text in setup actions, no user gate
**Proposed:** AskUserQuestion with two sequential questions:

Q1: "What's the migration strategy?"
- 1:1 parity port (Recommended for most migrations) - replicate source behavior exactly, improve later
- Selective redesign - port core, redesign specific areas (list which)
- Full redesign - new UX informed by old, not constrained by it

Q2: "What's the cutover approach?"
- Strangler fig (Recommended) - incremental, run both systems, shift traffic gradually
- Big-bang - build everything, cut over at once
- Parallel run - both systems live, compare output, switch when confident

Both questions stand independently. If the combination creates tension (e.g., full redesign + strangler fig), the agent notes it conversationally after both answers - doesn't filter or restrict options.

**Store:** SCOPE.md ## Source System section
**Status:** IMPLEMENTED

### G2: Vertical slice picks gate

**Location:** migrate/03-vertical-slice.md:23-29
**Current state:** Agent picks and justifies, no confirmation
**Proposed:** Agent proposes 3 screens with justification, then AskUserQuestion:

"Confirm vertical slice picks?"
- Accept these 3 (show the picks + justification)
- I want to adjust (drop to chat, user modifies)

Single-select, not multiSelect. The agent's job is to propose well; the user's job is to confirm or redirect.

Re-present AskUserQuestion after conversational detour per M1 pattern.

**Status:** IMPLEMENTED

### G3: Ship checklist tier

**Location:** buildout/04-iterate-and-ship.md:75-90
**Current state:** Three tiers exist but agent self-selects
**Proposed:** AskUserQuestion:

"What ship standard does this project need?"
- Hobby/side project - deployed, README, no crashes on happy path
- Has real users - pipeline, error handling, persistence, someone else used it
- May grow - monitoring, perf, security, v2 scope

**Store:** SCOPE.md frontmatter as `ship-tier: hobby | users | growth`
**Timing:** Ask during /buildout setup for initial calibration. Phase 4 ship checklist re-confirms: "You set this as '{tier}' tier. Still right?" Quick single-select, no ceremony.
**Status:** IMPLEMENTED

### G4: Architecture decision relevance

**Location:** project-setup/PHASE-1.md:9-18
**Current state:** 8 areas prescribed, all required
**Proposed:** multiSelect AskUserQuestion:

"Which architecture areas need decisions?" (select all that apply)
- Component architecture (Recommended)
- State management (Recommended)
- Data fetching (Recommended)
- Routing
- Styling
- Testing (Recommended)
- Error handling
- Mock data strategy

Recommended marks adapt based on Phase 0 context. Agent assembles 6-8 relevant areas from a larger catalog (15 areas) stored in project-setup/REFERENCES.md. Catalog entries include: base description, "surfaces when" condition, and context-specific description variants. Agent rewrites descriptions to match the project profile (e.g., "Error handling" reads "exit codes" for CLI, "retry policies, dead letter queues" for pipelines).

Catalog areas: Component architecture, State management, Data fetching, Routing, Styling, Testing, Error handling, Mock data strategy, Data modeling, Validation strategy, Algorithm/computation, Concurrency model, Observability, API design, Security model.

4 areas marked Recommended based on project type. Unselected areas can be deferred to Phase 3 (surfaced by /check-in as pre-build checkpoint items) or skipped entirely.

**Status:** IMPLEMENTED

### G5: Testing philosophy

**Location:** project-setup/PHASE-1.md:44-55
**Current state:** TESTING.md generated from template, approach not gated
**Proposed:** AskUserQuestion:

"What's your testing approach?"
- Integration-first (Recommended) - test user workflows end-to-end, unit test complex logic only
- TDD - test-first for all features, high unit coverage
- Structural enforcement - automated convention checks, smoke tests, minimal unit tests

Single-select sets the default stance - shapes TESTING.md emphasis and /check-in checkpoint language. Not a contract: Phase 3 vertical slice refines from real patterns, /project-setup resume path (M2) allows revisiting. The philosophy is a seed, not a binding choice.

**Store:** SCOPE.md frontmatter as `testing-philosophy: integration-first | tdd | structural-enforcement`
**Status:** IMPLEMENTED

### G6: Documentation depth confirmation

**Location:** project-setup/PHASE-1.md:57-90
**Current state:** Tree prescribed by archetype, no confirmation
**Decision:** No AskUserQuestion gate. The archetype selection already determines the tree - a confirmation gate on a derived output adds friction without signal. Instead: print the generated tree as a summary and say "Adjust if needed." No structured question, no blocking. The user redirects organically if something's wrong.

**Status:** IMPLEMENTED (killed as gate, kept as summary)

### G7: Design branch policy

**Location:** project-setup/PHASE-1.md:135-156
**Current state:** Always generated into CLAUDE.md
**Decision:** Conditional on design-system archetype. No AskUserQuestion - the archetype is the gate. If design-system archetype is added later via M2 resume path, sections get added. If removed, sections get removed (with cascade warning if design-journal.md has content).

**Status:** IMPLEMENTED

### G8: Gate override confirmation

**Location:** migrate/SKILL.md:95-98
**Current state:** Process note, no structured confirmation
**Decision:** AskUserQuestion when user requests gate skip. The visual weight is the point - skipping a gate should feel deliberate, not casual.

"Skip gate item: {item}. This will be tracked in ADR and surfaced at next gate."
- Yes, skip and document
- No, let me address it first

Single-select. The friction is the feature.

**Status:** IMPLEMENTED

### G9: Integration order

**Location:** migrate/05-integration.md
**Current state:** No ordering guidance
**Decision:** No AskUserQuestion gate. Integration order is heavily constrained by API availability - not a meaningful choice point. Instead: sharpen 05-integration.md with an ordering heuristic (dependencies first, then by API readiness), print proposed order as summary. User redirects organically if needed.

**Status:** IMPLEMENTED (killed as gate, kept as summary)

### G10: 6b improvement triage

**Location:** migrate/06b-design-pass.md:52
**Current state:** Triage happens, build order not confirmed
**Decision:** Keep as gate. After triage, present prioritized list grouped by tier (token -> component -> page) and gate with AskUserQuestion: "Build in this order?" Same propose-confirm pattern as G2. Tiers are prescribed by the phase file's top-down ordering; priority within tiers is the user's call.

**Status:** IMPLEMENTED

---

## Sharpening decisions

### S1: Checkpoint format standardization

**Problem:** Phase files use inconsistent checkpoint formatting. README defines the 4-field pattern (trigger/references/action/pass) but not all checkpoints follow it.

**Decision:** Enforce the 4-field format literally in every checkpoint across all phase files. Consistency isn't cosmetic - the agent reads these fields to fire checkpoints. Drifted format forces prose interpretation instead of structure parsing. Mechanical fix across all phase files.

**Status:** IMPLEMENTED

### S2: "Suggest /wrapup" consolidation

**Problem:** Every verb and post-build checkpoint spells out "suggest /wrapup" procedurally. /port already declares this in frontmatter signals. Other verbs and phase files should reference the signal, not re-explain.

**Decision:** Every verb that suggests /wrapup declares it in frontmatter `signals: [complete: suggests /wrapup]`. Phase files reference the signal ("verb reports complete per its signals contract") instead of spelling out the behavior. Follow the pattern /port established.

**Status:** IMPLEMENTED

### S3: migrate/07-cutover.md expansion

**Problem:** 6-line stub for the highest-stakes phase. No checkpoints, no process, no gate structure.

**Decision:** Expand to match the structural skeleton of all other phase files. Checkpoints (4-field format per S1): pre-cutover readiness check (verify all prior gates passed), post-cutover validation (verify production behavior). Process sections: deployment plan, communication plan, monitoring plan, rollback criteria. Gate: deployed + monitoring confirms parity + rollback tested + sunset date set. Content stays lightweight - structure ensures nothing gets skipped, details are project-specific.

**Status:** IMPLEMENTED
