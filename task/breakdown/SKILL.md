---
name: breakdown
description: "Decompose a spec into implementable slices with dependency ordering. Use when a spec exists and the user wants a clear build plan, mentions 'break down', 'decompose', 'slices', or 'implementation plan'."
status: draft
---

# Breakdown

Decompose a spec into implementable slices.
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

Output format (written to the spec file as a new section):

```markdown
## Implementation Slices

### Slice 1: {name}
**Depends on:** none
**Files:** {list of files this slice creates or modifies}
**Done when:** {testable condition}
**Notes:** {any context that helps the implementer}

### Slice 2: {name}
**Depends on:** Slice 1
**Files:** {files}
**Done when:** {condition}
```

### Step 3 - Validate against scope

Check each slice against the spec's acceptance criteria.
Every acceptance criterion must be covered by at least one slice.
Every slice must trace back to at least one acceptance criterion.

If a slice doesn't trace to an acceptance criterion, it's scope creep - flag it:
"Slice {N} ({name}) doesn't trace to any acceptance criterion. Cut it or add the criterion to the spec?"

If an acceptance criterion isn't covered by any slice, it's a gap:
"Acceptance criterion '{criterion}' has no implementing slice. Add a slice?"

### Step 4 - Present for review

Show the decomposition:

```
Spec: {spec name}
{N} slices, estimated {M} TDD cycles

Build order:
  1. {slice 1 name} (no dependencies)
  2. {slice 2 name} (depends on: 1)
  3. {slice 3 name} (depends on: 1)  <- can run in parallel with 2
  ...

Coverage: {N}/{M} acceptance criteria mapped.
{any gaps or scope creep flagged}

Write slices to spec, or adjust?
```

### Step 5 - Write

Append the `## Implementation Slices` section to the spec file.
Do not modify existing spec content - slices are additive.

If a previous `## Implementation Slices` section exists (re-decomposition), replace it entirely.

## Tier-adapted output

| Tier | Output |
|------|--------|
| Tier 1 | Ordered list in session context, passed to /tdd |
| Tier 2 | Written to spec file as `## Implementation Slices` section |
| Tier 3 | Written to spec + GitHub sub-issues via `gh` CLI |

At Tier 1 (no spec file infrastructure), present slices inline and pass to /tdd directly.
At Tier 3, after writing to the spec, create GitHub sub-issues:

```bash
gh issue create --title "Slice 1: {name}" --body "{details}" --project "{project}" --parent "{parent-issue-number}"
```

## Edge cases

**Spec changes after /breakdown:** if the spec has been modified since the last breakdown (compare the spec's Change Log dates against the slice section timestamp), warn:
"Spec was updated since breakdown. Re-decompose, or keep current slices?"

**Slice too big:** if a slice's file list exceeds 5 files, offer to sub-decompose.

**Circular dependencies:** if the dependency graph has cycles, flag: "Slices {A} and {B} depend on each other. One must go first - which?"

**No acceptance criteria in spec:** if the spec lacks acceptance criteria, the coverage check can't run. Suggest: "Spec has no acceptance criteria. /spec to add them, or skip coverage check?"

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
