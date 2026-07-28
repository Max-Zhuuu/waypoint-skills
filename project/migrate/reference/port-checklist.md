# Port Checklist

Reference checklist for migration screen implementation.
Formerly the standalone `/port` skill - now integrated as reference material under `/migrate`.

## Three-input gate

Resolve paths via the Documentation Map in CLAUDE.md. Defaults if no map exists:

1. **Feature spec** - Documentation Map "Feature reference" or `docs/reference/features/{entity}.md`
2. **Logic doc** - Documentation Map "Logic reference" or `docs/reference/logic/{entity}.md`
3. **Source system** - files listed in the feature spec's reference section

If any input is missing, stop and report. Do not build without all three.

## Process

### 1. Read and synthesize

Read all three inputs fully. Identify fields, controls, conditional visibility, navigation paths, applicable CONVENTIONS.md patterns, and whether shared file changes are needed (route, type export, shared component).

### 2. Generate subagent brief

Synthesize a focused build instruction: entity name/purpose (one sentence), fields table (name, type, source, editable, default), controls and behaviors, conditional visibility rules, patterns to follow, files to create/modify, reference files for detail checks.

### 3. Spawn subagent(s)

- **Entity-local only** (no shared file changes): safe to parallelize
- **Touches shared files** (router, types, shared components): serialize

Subagent builds from the brief with read access to full spec/source for detail checks.

### 4. Parity review

Review subagent output against spec and source using this checklist:
- Fields present and correct against spec?
- Controls match source system behavior?
- Conditional visibility rules implemented?
- Navigation paths work?
- Tests pass?

Grade each check by how independently the expected answer was obtained, not by whether the output looks right: a value confirmed against the source system or a re-run assertion outranks an inspection, and an inspection outranks a pattern-match.
See the evidence hierarchy in [verifiable workflows](../../../process/verifiable-workflows.md).

When cross-reference finds discrepancies between spec and reality:
- DO NOT update the spec. DO NOT update shared docs.
- Emit each discrepancy as a concern in CONCERNS.md (type: issue, refs: entity spec).

Run test suite - zero failures required.
When this phase runs under a reconciliation ledger, write this screen's row: status, criteria k/n with the unmet ones named, the evidence rank and named oracle, and any discrepancy pointers.
A screen is done only when its row Passes - k equals n, tests green, no open discrepancy, evidence at rank 1-5; mark `[P]` in inventory only then.
A partial or rank-6-7-only result stays Partial, spends the error budget with a logged reason, and commits with a `[provisional]` marker.

## Concurrency

### Within session

Multiple subagents can run in parallel IF:
- Non-overlapping entity-local files
- No shared file changes in the parallel set

Shared file changes (router config, type exports, shared components) serialize through the main context.

### Cross-session

Cross-session coordination (CONCERNS.md Claims section, file claiming, stale entry policy) is owned by the project's CLAUDE.md and hook infrastructure, not this checklist.

## UX improvements

Spot an improvement during porting: write a one-liner in `docs/improvements/{entity}.md` and keep porting. Do NOT implement.

## Review depth

Classify each ported screen's complexity to calibrate review effort:

- **Moderate** (lighter review, Sonnet reviewer): no conditional visibility 3+ rules, no status lifecycle in logic doc, fewer than 4 tabs.
- **High** (deeper review, Opus reviewer): conditional visibility 3+ rules, OR status lifecycle, OR 4+ tabs.

Derived from spec content, not judgment.
