---
name: port
description: Migration implementation verb. Reads spec + logic doc + source, briefs subagents, reviews output, flags discrepancies. Use when /check-in proposes a migration screen to build.
status: stable
disable-model-invocation: true
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

# Port

The migration implementation verb. Backward-looking: capture current behavior, replicate, verify parity.

Distinct from `/tdd` which is forward-looking: define desired behavior, test first, build to satisfy.

## Role

/port is an **orchestrator**, not a laborer. Its responsibilities:
1. **Brief** - read inputs, synthesize a focused build instruction for subagents
2. **Review** - evaluate subagent output against spec and source
3. **Flag** - collect discrepancies as structured flags for /wrapup

/port does NOT update specs or shared docs. It flags discrepancies for /wrapup to resolve.

## Inputs (three required)

1. **Feature spec** - `docs/reference/features/{entity}.md`
2. **Logic doc** - `docs/reference/logic/{entity}.md`
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

The brief is a digested instruction, not a full pass-through of the inputs.

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
- Emit each discrepancy as a concern in CONCERNS.md (type: flag, source: /port, refs: entity spec):

```markdown
### C-{NNN} [open] Spec says field X is editable, source has it read-only in status=Closed
type: flag | raised: {date} | source: /port
refs: docs/reference/features/{entity}.md
```

These concerns are /wrapup's input.

### 6. Report complete

Run test suite - zero failures required.
Mark `[P]` in inventory.
Suggest /wrapup to the user:

```
Build complete. {N} concerns emitted. Run /wrapup to resolve, or continue to next entity.
```

## Concurrency

### Within session

Multiple subagents can run in parallel IF:
- Non-overlapping entity-local files
- No shared file changes in the parallel set

Shared file changes (router config, type exports, shared components) serialize through the main context.

### Cross-session

Cross-session coordination (ACTIVE-WORK tracker, file claiming, stale entry policy) is owned by the project's CLAUDE.md and hook infrastructure, not this skill.
/port respects whatever coordination protocol the project defines.

## UX improvements

When you spot a UX improvement during porting: write a one-liner in `docs/improvements/{entity}.md` and keep porting. Do NOT implement improvements. Design work waits for Phase 6b.

## Engagement

/port requires its three inputs (feature spec, logic doc, source) regardless of engagement tier.
CONVENTIONS.md enhances pattern enforcement during review but is not required.

On invocation, detect engagement tier:

| Signal | Tier |
|--------|------|
| No CONCERNS.md, no CLAUDE.md | Tier 1 - just working |
| CONCERNS.md exists | Tier 2 - tracking |
| CONCERNS.md + Documentation Map in CLAUDE.md | Tier 2+ |
| Tier 2+ and `concerns: auto-emit` in CLAUDE.md | Tier 3 - automated |

**Tier 1:** Execute the full methodology. Skip cross-referencing.
Substitute inline: no CONTEXT.md -> define terms inline; no CONVENTIONS.md -> infer from code;
no SCOPE.md -> ask scope inline; no TESTING.md -> state default philosophy.
State each adaptation once, then move on.

**Tier 2:** Read CONCERNS.md at start. Note relevant open concerns.
After work, follow the nudge protocol for discoveries. Emit as `[open]` with type, date, refs.

**Tier 3:** Emit concerns without asking. Log what was emitted at session end.

**Nudge protocol:**
1. **What** - the specific discovery, concrete names
2. **Why** - impact beyond this session
3. **Ask** - one question, one time. If declined, do not re-offer.

**Concern format:** `### C-{next_id} [open] {description}` / `type: {question|assumption|flag} | raised: {date} | source: /{skill-name}`

**Emit when:** cross-cutting, contradicts assumption, can't resolve now, time-bound risk.
**Don't emit:** things just fixed, generic advice, duplicates, current-context-only.

**Don't:** block on missing scaffolding; repeatedly mention what's missing; prompt for /setup more than once (`.claude/.setup-prompted`); create scaffolding owned by another skill; degrade silently.

## References

Methodology references in [REFERENCES.md](REFERENCES.md): characterization tests, Strangler Fig, seam identification, structural enforcement, review depth classification.
Apply them as judgment calls during briefing and review.
