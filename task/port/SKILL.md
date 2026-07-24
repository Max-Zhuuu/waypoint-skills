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

Does NOT write specs or logic docs. Reads them and implements.

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

Read all three inputs fully. Identify:
- Fields, controls, and their behaviors
- Conditional visibility rules
- Navigation paths
- Patterns from CONVENTIONS.md that apply
- Whether this entity needs shared file changes (new route, new type export, new shared component)

### 2. Generate subagent brief

Synthesize a focused build instruction containing:
- Entity name and purpose (one sentence)
- Fields table (name, type, source, editable, default)
- Controls and behaviors (what each does)
- Conditional visibility rules
- Patterns to follow (from CONVENTIONS.md)
- Files to create or modify
- Reference files the subagent can read if it needs detail

### 3. Spawn implementation subagent(s)

Classify the work:
- **Entity-local only** (no shared file changes): safe to parallelize with other /port instances
- **Touches shared files** (router, shared types, shared components): serialize

The subagent builds from the brief. It has read access to full spec/source if needed for detail checks.

### 4. Review subagent output

After the subagent completes, review against the spec and source:
- Fields present and correct against spec?
- Controls match source system behavior?
- Conditional visibility rules implemented?
- Navigation paths work?
- Tests pass?

If the output has issues: direct the subagent to fix, or fix in the main context.

### 5. Emit concerns

When cross-reference finds discrepancies between spec and reality:
- DO NOT update the spec. DO NOT update shared docs.
- Emit each discrepancy as a concern in CONCERNS.md (type: issue, source: /port, refs: entity spec):

```markdown
### C-{NNN} [open] Spec says field X is editable, source has it read-only in status=Closed
type: issue | raised: {date} | source: /port
refs: docs/reference/features/{entity}.md
```

These concerns are /wrapup's input.

### 6. Before committing

Run test suite - zero failures required.
Port builds are typically stable (parity-verified). Run mini-wrapup:
- Spec sync: does the built screen match the feature spec?
- Term/pattern capture: did porting reveal domain terms or patterns?
- Concern resolution: does this work resolve any open concerns?

If parity is partial or uncertain, commit as provisional with `[provisional]` marker.
Mark `[P]` in inventory.

```
Build complete. {N} concerns emitted. /wrapup to resolve, or continue to next entity.
```

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) section 6 for the full exit protocol.

## Concurrency

See [reference/concurrency.md](reference/concurrency.md) for within-session and cross-session rules. Apply them when spawning or coordinating subagents.

## UX improvements

When you spot a UX improvement during porting: write a one-liner in `docs/improvements/{entity}.md` and keep porting. Do NOT implement improvements. Design work waits for Phase 6b.

## Tone

Faithful to the source system. Deviate only when documented.

## Exit

- /wrapup to resolve concerns and cascade docs.
- /check-in for next migration screen.

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: issue, question)
Writes: none
Override: commit-producing skill - follows exit protocol (ENGAGEMENT-REFERENCE.md section 6). Pre-condition: feature spec, logic doc, and source system access required regardless of tier.
## References

Methodology references in [reference/references.md](reference/references.md): characterization tests, Strangler Fig, seam identification, structural enforcement, review depth classification.
Apply them as judgment calls during briefing and review.
