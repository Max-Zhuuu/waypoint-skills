---
name: port
description: "Implement a migration screen from spec + logic doc + source. Brief subagents, review output, flag discrepancies."
status: stable
inputs:
  feature-spec: docs/reference/features/{entity}.md
  logic-doc: docs/reference/logic/{entity}.md
  source: files referenced in feature-spec
outputs:
  concerns: emitted to CONCERNS.md with entity reference
  inventory: marker updated to [P]
signals:
  complete: suggests /wrapup to user
---

The migration implementation verb. Backward-looking: capture current behavior, replicate, verify parity.
Distinct from `/tdd` which is forward-looking: define desired behavior, test first, build to satisfy.

Orchestrator: brief subagents from inputs, review output against spec, flag discrepancies for /wrapup.

## Inputs (three required)

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

### 4. Review and finalize

Review subagent output against spec and source using the [review protocol](reference/review-protocol.md): field/control/visibility checklist, concern emission format, and pre-commit verification.
Fix issues directly or redirect the subagent.

Run test suite - zero failures required. Mark `[P]` in inventory.
If parity is partial or uncertain, commit with `[provisional]` marker.

```
Build complete. {N} concerns emitted. /wrapup to resolve, or continue to next entity.
```

## Concurrency

See [reference/concurrency.md](reference/concurrency.md) for within-session and cross-session rules.

## UX improvements

Spot an improvement during porting: write a one-liner in `docs/improvements/{entity}.md` and keep porting. Do NOT implement.

## Tone

Faithful to the source system. Deviate only when documented.

## Exit

- /wrapup to resolve concerns and cascade docs.
- /check-in for next migration screen.
- On exit, emit the artifacts manifest for the paths this run wrote, per [the artifacts manifest](../../internals/engagement/manifest.md); a run that wrote nothing prints the empty manifest.

Does NOT write specs or logic docs. Reads them and implements.

## Engagement
See [the engagement protocol](../../internals/engagement/README.md). Emits: concerns (type: issue, question). Writes: the migration inventory marker (`[P]`/`[provisional]`) and `docs/improvements/{entity}.md`; per-entity screen source via subagents, enumerated in the run manifest.
Override: commit-producing skill. Pre-condition: all three inputs required.

## References
See [reference/references.md](reference/references.md): characterization tests, Strangler Fig, seam identification, structural enforcement, review depth.
