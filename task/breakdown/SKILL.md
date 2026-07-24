---
name: breakdown
description: "Decompose a spec into implementable slices with dependency ordering. Use when a spec needs a build plan."
status: draft
---

Does NOT implement. Decomposes specs into build-ready slices.

Each slice maps to one TDD cycle or one /create invocation.

## Inputs

1. **Spec file** - resolve via Documentation Map "Feature specs" or `docs/specs/{feature}.md`
2. **SCOPE.md** (optional) - for boundary checks
3. **CONVENTIONS.md** (optional) - for naming patterns in slice descriptions

If no spec exists, suggest /spec first: "No spec found for {topic}. /spec to write one?"

## Process

### Step 1 - Read and understand

Read the spec. Identify:
- **Entities** - what data structures are involved?
- **Behaviors** - what interactions does the spec define?
- **Dependencies** - what needs to exist before what?
- **Scope boundaries** - what's explicitly out? (check SCOPE.md if it exists)

Do not add features the spec doesn't describe. If the spec is ambiguous, flag it as a concern - do not fill in the gap.

### Step 2 - Decompose into slices

Each slice must be:
- **Implementable** - can be built and tested in one session
- **Testable** - has a clear "done" condition
- **Scoped** - touches a bounded set of files
- **Ordered** - dependencies are explicit

Slice granularity: one slice per screen, per API endpoint, or per behavioral unit.
If a slice touches more than ~5 files, it's too big - decompose further.

Output format written to the spec file as a new section - see [reference/slice-format.md](reference/slice-format.md).

### Step 3 - Validate against scope

Check each slice against the spec's acceptance criteria.
Every acceptance criterion must be covered by at least one slice.
Every slice must trace back to at least one acceptance criterion.

If a slice doesn't trace to an acceptance criterion, it's scope creep - flag it:
"Slice {N} ({name}) doesn't trace to any acceptance criterion. Cut it or add the criterion to the spec?"

If an acceptance criterion isn't covered by any slice, it's a gap:
"Acceptance criterion '{criterion}' has no implementing slice. Add a slice?"

### Step 4 - Present for review

Show the decomposition - see [reference/review-format.md](reference/review-format.md) for the presentation template.

### Step 5 - Write

Append the `## Implementation Slices` section to the spec file.
Do not modify existing spec content - slices are additive.

If a previous `## Implementation Slices` section exists (re-decomposition), replace it entirely.

Tier-adapted output (Tier 1/2/3 differences, GitHub sub-issues at Tier 3) - see [reference/tier-output.md](reference/tier-output.md).

Edge cases (spec changes after breakdown, oversized slices, circular deps, missing acceptance criteria) - see [reference/edge-cases.md](reference/edge-cases.md).

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: question, issue)
Writes: none
## Exit

After slices are written, suggest next steps:
- "Start Slice 1? It's {one-line summary of what Slice 1 does}."
- "/tdd to build Slice 1, or come back when ready - slices are in the spec."
- If Tier 3: "GitHub issues created. /check-in reads open issues and proposes which to start."

## Tone

Precise. Each slice is a contract for the implementer.
Slice descriptions should be specific enough that someone unfamiliar with the grill session can pick one up and build it.
No vague slices like "set up infrastructure" - name the specific files and behaviors.
