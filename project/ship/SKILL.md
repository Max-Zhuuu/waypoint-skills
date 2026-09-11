---
name: ship
description: "Assemble a spec-grounded PR and propose an afk/hitl routing. The outbound seam from local completion to a delivery pipeline. Run after /wrapup."
status: draft
---

The outbound verb. Assembles a PR from pre-registered intent and proposes a routing; it never holds merge authority.

## Inputs

1. The spec - via Documentation Map "Feature specs" or `docs/specs/{feature}.md`.
2. wrapup's gate-evaluation output for this change (blocking-concern verdict, resolved `decision:` lines).
3. The ADR delta the change touched.
4. DEPLOY.md - resolve via Documentation Map, else the well-known repo-root path. Holds the adapter, targets, and load-bearing globs.
5. The diff - for glob membership and slice-to-file tracing only, never as a source for Intent prose.

## Process

### 1. Resolve the adapter

Read DEPLOY.md's `# --- waypoint:deploy ---` fenced block. If it is absent or malformed, fail loud (see reference/adapters.md): never treat "no load-bearing globs" as vacuously safe.

### 2. Author the Intent block

Write `## Intent` from the spec, the ADR delta, and the resolved concern `decision:` lines - the human's pre-registered ground truth. Do not read the diff to describe the change: a diff-derived Intent grades the diff against itself and is green by construction. Mark the block "spec-derived" so the target's reviewer checks spec-versus-diff. Template and PR-body shape: [reference/intent-template.md](reference/intent-template.md).

### 3. Precondition check (structural, not a review)

Verify the change is shippable, cheaply: Intent present and non-empty; every slice traces to an acceptance criterion (reuse breakdown's tracing); tests green per the adapter's command, or reported "unverified"; no open blocking concern (from Step 4, key 1b). This does NOT critique the diff for quality (leaked exceptions, hard-coded values) - that is inner-loop /review work, a separate skill.

### 4. Compose the afk gate (a proposal)

The `autonomy` axis is defined once in [autonomy.md](../../internals/engagement/autonomy.md). Compose the gate from already-authored inputs; never re-derive them:

- **key 1a** - every shipped slice's `Autonomy:` tag (authored by breakdown) reads `afk`. An untagged slice counts as `hitl`.
- **key 1b** - wrapup's `Blocking:` verdict line reads `none`. A missing verdict counts as `hitl`. Do not re-read raw CONCERNS.md to decide "blocking."
- **key 2** - no diff path matches a DEPLOY.md `load-bearing` glob (dialect: section 13.4).

Propose `afk` iff all three hold; any single failure yields `hitl`. `afk` is necessary, not sufficient: it means only "propose the auto lane and open the PR." The target's own enforcement is the authority at merge (section 13.2), so `afk` never means "merged."

### 5. Route by the composition table

Route per the 2x3 engagement table (section 13.5). Open-vs-hold is set by engagement: on-demand prepares and holds for an explicit go; connected and autonomous open. The merge lane is set by autonomy: `afk` gets the auto-eligible label, `hitl` gets ready-for-human. Per-adapter behavior and fail-loud cases: [reference/adapters.md](reference/adapters.md).

### 6. Present, then act

Print the compact session digest and the clickable link before anything opens. Then open or hold, and report.
Surface reviewed-state as a non-blocking note ([reference/reviewed-state.md](../../task/review/reference/reviewed-state.md)): say whether this exact diff was already reviewed, but never gate shipping on it - ship does not review.

## Output surfaces

- **PR body** - durable and authoritative: `## Intent` (spec-derived), `## Concern decisions` (C-NNN + one-line, references CONCERNS.md), `## Routing` (autonomy + why, engagement, adapter, target tier, load-bearing paths touched), `## Slices` (each tagged, traced).
- **Session inline** - an ephemeral echo plus the clickable link.
- No standalone SHIP.md; the PR is the record.

Does NOT: hold merge authority, run /review, or execute a deploy (DEPLOY.md destinations are routing strings, not commands).

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: none
Writes: none - the PR is an outbound artifact, not a repo file.
Override: needs network and an adapter; not Tier-1-offline like wrapup.

## Exit
- The target holds the merge decision; /check-in surfaces staged-but-unpromoted work next session.
- /review first if the change wants a critic pass (sibling skill).
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#13-exit-sequence).

## Tone
Mechanical and honest. Ship proposes, the target disposes. Never imply `afk` means merged.
