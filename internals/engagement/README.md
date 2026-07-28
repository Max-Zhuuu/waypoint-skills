# Engagement Protocol

Protocol spec for the waypoint skill family.
Every skill carries a tier declaration that states what it emits, what it writes, and any overrides.
This document is the authoritative source for how tier detection, nudging, concern emission, and enforcement work.

Skills link here from their `## Engagement` section.
The tier declaration is the contract; this document is the specification.

The engagement tiers answer "may I act unattended right now" (a permission).

## Related references

Three concerns that once lived here as sections now sit beside this file, each cited only by the skills that need it:

- [autonomy.md](autonomy.md) - the `autonomy` axis (`afk`/`hitl`): "could this change ship unattended at all" (a capability), and the table that composes it with engagement.
- [review-safety.md](review-safety.md) - the review safety invariant: the five points where untrusted text could reach a position that steers a later turn, and the gate at each.
- [manifest.md](manifest.md) - the artifacts manifest emission: the run-time receipt of what a skill wrote, the sibling of concern emission (section 4).
- [../chain/reference.md](../chain/reference.md) - the chain dispatcher and the graph it walks, run at each skill's Exit after the manifest.

## Multiple skills invoked at once

When the user names more than one skill in a single request (`/spec then /breakdown`, "reorient and check in", a comma-separated list), do not start executing in the order written and do not silently pick one.
Stop and confirm the order first: restate the skills you detected, propose a sequence with a one-line reason (usually the chain's natural precedence - orient before plan, spec before breakdown, plan before build), and ask the user to confirm or reorder.
Then run them one at a time, carrying each skill's output into the next, never interleaving their phases.

## 1. Tier Detection

On invocation, determine the engagement tier by reading project state.
Check in order - first match wins:

```
1. Does CLAUDE.md contain `concerns: auto-emit` under `## Waypoint`?
   YES -> Tier 3 (automated)

2. Does CONCERNS.md exist (any content)?
   YES -> Does CLAUDE.md have a Documentation Map section?
          YES -> Tier 2+ (full cross-referencing)
          NO  -> Tier 2 (tracking)

3. Neither exists -> Tier 1 (just working)
```

Tier 3 requires explicit opt-in. Without the marker, always ask before emitting concerns.

## 2. Per-Tier Behavioral Defaults

These defaults apply to every skill unless overridden in the skill's tier declaration.

### Tier 1 - Just working

The skill executes its full methodology.
No scaffolding files are expected. No concern tracking is available.

**Path resolution:** Resolve all doc paths through the Documentation Map in CLAUDE.md. Never hardcode paths in skill logic.
When no Documentation Map exists (pre-/setup), fall back to well-known root paths.

**GLOSSARY.md fallback:** Check `_GLOSSARY.md` first (underscore convention, current default). If not found, check `GLOSSARY.md` (clean convention). If not found, check `CONTEXT.md` (legacy name). This fallback lives here, not in individual skills.

**Cross-reference substitutions:**
- No _GLOSSARY.md, GLOSSARY.md, or CONTEXT.md -> define terms inline, don't link to a glossary
- No CONVENTIONS.md (or conventions/) -> infer conventions from existing code, state what you inferred
- No SCOPE.md -> ask scope questions inline ("is this v1 or future?")
- No TESTING.md -> state the default test philosophy, offer to adjust
- No docs/adr/ -> flag when a decision might reverse a past choice, note that no ADRs exist to check

State each adaptation once, in one sentence, then move on.

### Tier 2 - Tracking

CONCERNS.md exists. Skills read from it and write to it (with permission).

- Read the summary header (line 2) first. Use `@L` offsets to read only the section you need.
- Task-layer skills: read only the Open section to check for relevant concerns.
- /check-in, /reorient: read Open + Investigating + Blocked for the full picture. Skip Resolved.
- /wrapup: read Open (to resolve), then Resolved (to check archival threshold).
- After work, follow the nudge protocol (section 3) for discoveries.
- Emit concerns as `[open]` with type, raised date, and refs.
- Resolve concerns addressed by the current work (move to Resolved, add resolution note).
- After any write to CONCERNS.md, recalculate the summary header (counts + line offsets).
- When cross-referencing files exist, use them. When they don't, use Tier 1 substitutions.

**Deepening suggestions** (at most once per session, when concern history shows a pattern):

```
You have 8 open assumptions, 3 with medium risk and no validate-by date.
/setup can run a structured validation pass if you want
to stress-test these before they become real problems.
```

### Tier 3 - Automated

User has opted in to automatic concern emission.
The nudge protocol's "ask" step is skipped.

- Emit concerns silently during work. Log what was emitted at session end. (Exception: `/review` findings never auto-emit, at any tier - see [review-safety.md](review-safety.md), crossing 1.)
- Resolve concerns automatically when the skill's work directly addresses them.
- Surface only concerns that need human judgment (blocked, ambiguous, or high-risk).

**Automation suggestions** (Tier 3 only, requires all three):
- A pattern of repeated manual work (at least 3 instances of the same concern type)
- A concrete automation proposal (hook, script, check), not vague advice
- User confirmation before implementing

## 3. Nudge Protocol

Every nudge, at every tier, follows three steps:

1. **What** - the specific discovery. Use concrete names, not abstractions.
   - Good: "Undocumented rule: vessel status requires confirmation before transition."
   - Bad: "Found an undocumented business rule."

2. **Why** - why it matters beyond this session. Reference scope, not theory.
   - Good: "This affects VesselCard, VesselList, and FixtureCard - all have status transitions."
   - Bad: "Undocumented rules can cause inconsistencies."

3. **Ask** - one question, one time.
   - Tier 1: "Want me to start CONCERNS.md to track this?"
   - Tier 2: "Added as C-039 [open]." (or "Want me to add this as a concern?")
   - Tier 3: Silent emission, logged at session end.

Never nag. If the user declines a nudge, do not re-offer the same concern.
If the user says "stop suggesting concerns," respect it for the rest of the session.

## 4. Concern Emission

### Format

```markdown
### C-{next_id} [open] {one-line description}
type: {question|assumption|issue} | raised: {date} | source: /{skill-name}
{1-3 lines of context}
refs: {paths to relevant files or other concern IDs}
```

Read the current max ID from CONCERNS.md and increment.
Place the new concern in the Open section.
Recalculate the summary header after adding.

Exception: a concern sourced from a `/review` finding is never auto-emitted at any tier, including the Tier 3 silent emission above; recording one is always a human pick, and its fields carry structural refs only ([review-safety.md](review-safety.md), crossing 1).

### When to emit

Emit a concern when the skill discovers something that:
- Affects code or decisions beyond the current task (cross-cutting)
- Contradicts an existing assumption or spec (discrepancy)
- Cannot be fully resolved within the current skill invocation (deferred)
- Represents a risk that should be revisited later (time-bound)

### When NOT to emit

- Things the skill just fixed (the fix is the resolution)
- Generic best practices ("you should add more tests")
- Things already tracked (check CONCERNS.md for duplicates first)
- Observations that only matter in the current context

### Resolved concern format

When resolving a concern, include commit references:

```markdown
### C-015 [resolved] FE not consuming real BE for Claims, Pool, Search
type: issue | raised: 2026-07-20 | resolved: 2026-07-25
Resolution: Wired Claims list to real API. Field mappings verified against C# source.
Commits: abc1234, def5678
```

Concern emission is one of two run emissions a skill can make; the other is the artifacts manifest ([manifest.md](manifest.md)), the receipt of what the run actually wrote.

## 5. First-Invocation Notice

On first-ever invocation in a project without scaffolding (Tier 1), if `.claude/.setup-prompted` does not exist:

```
This project has no waypoint scaffolding.
Run /how-to-start to get oriented, or /setup to scaffold.
This notice won't repeat.
```

Write `.claude/.setup-prompted` after showing. If `.claude/` doesn't exist, the notice repeats until the user runs /setup (which creates `.claude/`). This is acceptable - the repetition reinforces the suggestion.

This is handled by the engagement protocol, not by individual skills.
The tier declaration inherits this behavior automatically.

## 6. Exit Protocol (Commit-Producing Skills)

Skills that produce commits (/tdd, /create, /diagnose) run this before committing:

```
1. Is this a mid-cycle commit or a natural boundary?
   - Mid-cycle (individual test passing, incremental refactor):
     Auto-provisional. Emit issue concern silently.
     Commit with [provisional] marker. No question asked.
   - Natural boundary (all slices complete, user signals done):
     Ask: "Stable enough to document, or provisional?"

2. If stable: run mini-wrapup
   - Spec sync: does the spec still match what was built?
   - Term/pattern capture: new domain term or convention worth logging?
   - Concern resolution: did this work resolve any open concerns?
   Commit code + doc updates together.

3. If provisional: emit issue concern with what needs documenting.
   Commit with [provisional] or [doc-deferred: <reason>] marker.

4. State next step: another cycle, /wrapup, or hand off.
```

### Provisional commit concern format

```markdown
### C-NNN [open] Deferred documentation: <topic>
type: issue | raised: <date> | source: /<skill>
<What needs documenting and why it was deferred.>
Commit: <short SHA>
refs: <spec or file that needs updating>
```

### Deferred-doc pressure curve

| Age | /check-in behavior |
|-----|-------------------|
| < 3 days | Mention in summary, no special treatment |
| 3-7 days | Note as aging: "oldest deferred doc is 5 days, context getting stale" |
| > 7 days | Promote to issue priority: "deferred doc from 12 days ago - resolve or re-document now" |
| > 14 days | Top of priority stack, above feature work |

Never blocking. The user can always say "not now." But the debt is visible and escalates.

### Mini-wrapup write authority

Mini-wrapup can:
- Append to shared-append files (GLOSSARY.md, conventions/NAMING.md, conventions/UX.md)
- Emit issue concerns for deferred documentation

Mini-wrapup cannot:
- Modify owned files (spec drift fixes remain /wrapup's responsibility)
- Delete or rewrite existing entries in shared-append files

## 7. Write Discipline

### File classification

| Category | Semantics | Who writes | Conflict resolution |
|----------|-----------|------------|-------------------|
| **Shared-append** | Any skill adds entries; never modifies existing | Any skill | Merge by appending |
| **Owned** | One designated writer per section | Designated skill | Owner resolves |
| **Volatile** | Session-scoped, auto-expires | Any skill in session | Last writer wins |

| File | Category | Writers | Constraint |
|------|----------|---------|------------|
| GLOSSARY.md | Shared-append | Any skill resolving a term | Add new terms only. Never modify/delete existing. |
| conventions/NAMING.md | Shared-append | /grill-with-docs, /wrapup, /setup | Add new patterns only. Modifications require /wrapup. |
| conventions/UX.md | Shared-append | /grill-with-docs, /wrapup, /setup | Add new patterns only. Modifications require /wrapup. |
| SCOPE.md | Owned | /setup (create), /grill-with-docs (scope grills) | Only during explicit scope discussions |
| TESTING.md | Owned | /setup (create), /grill-with-docs (strategy grills) | Only during explicit testing strategy discussions |
| ARCHITECTURE.md | Owned | /setup (create), /grill-with-docs (architecture grills) | Includes external dependencies section |
| CONCERNS.md (persistent) | Shared-structured | Any skill (emit), /wrapup (resolve) | Typed entries with lifecycle. ID-based. |
| CONCERNS.md (Claims) | Volatile | Any skill in session | Session-scoped. Stale after 4 hours. |
| Active Workflow | Owned | Workflow skill, /check-in (phase only) | Per-section owners |
| Feature specs | Owned | /spec (create), /wrapup (drift-fix) | Creator owns until /wrapup reviews |
| docs/patterns/*.md | Shared-append | Any skill discovering a cross-cutting pattern | Add new patterns only. |
| CLAUDE.md | Owned | /setup (scaffold), human (prose) | Per-section owners documented |

### The append-only contract

The rule isn't "one writer" - it's "append-only during work, modifications through /wrapup."
Two agents can both append to GLOSSARY.md without conflict (different terms, different IDs).
If they append conflicting definitions, that's a merge conflict - which surfaces the disagreement.

### Before writing to any shared file

Check the Claims section of CONCERNS.md. If another session claims the same file area, warn and ask before proceeding. This check is encoded in every skill's tier declaration.

## 8. Multi-Agent Enforcement

Three levels, each compensating for failures in the level above:

| Level | Mechanism | What it prevents |
|-------|-----------|-----------------|
| **1. Hook** | UserPromptSubmit hook injects Claims | File-area conflicts between concurrent agents |
| **2. Skill** | Skills read Claims/Concerns before writing | Working on an area with unresolved blockers |
| **3. Boundary** | /wrapup and /check-in verify consistency | Drift accumulated during session |

**Hook contract:** Projects with concurrent agents SHOULD install a UserPromptSubmit hook that injects CONCERNS.md content into every prompt.

Hook injection scales with project size:
- **<30 open concerns:** inject Claims + full Open section.
- **30+ open concerns:** inject Claims + summary header only. Skills read the file from disk using `@L` offsets when they need full details.

The hook checks for file-area conflicts and surfaces them before the agent acts.

Skills must not depend on the hook existing - they must also do their own checks (Level 2).

## 9. Scaffolding File Table

When scaffolding files exist, skills gain capabilities.
When they don't, skills substitute (see Tier 1 adaptations in section 2).

| File | What it gives skills | Created by |
|------|---------------------|------------|
| CONCERNS.md | Concern tracking (questions, assumptions, issues, milestones), cross-session continuity | Any skill (Tier 1 nudge), /reorient, /wrapup, or /setup |
| GLOSSARY.md | Term validation, glossary challenges | /grill-with-docs |
| conventions/NAMING.md | Naming enforcement | /setup |
| conventions/UX.md | Interaction pattern consistency | /setup |
| SCOPE.md | Scope boundary checks | /setup |
| TESTING.md | Project-specific test philosophy | /setup |
| ARCHITECTURE.md | Architecture cross-referencing, external dependencies | /setup |
| DESIGN.md | Visual convention enforcement (optional) | /design |
| docs/adr/ | Decision history | /grill-with-docs |
| Documentation Map (in CLAUDE.md) | Indirection layer for all of the above | /setup |

Skills create only their own output artifacts.
Exception: /grill-with-docs creates GLOSSARY.md and docs/adr/ because those ARE its outputs.

## 10. Prohibitions

These apply to every skill regardless of tier:

1. **Don't block on missing scaffolding.** Every skill works at Tier 1.
2. **Don't repeatedly mention what's missing.** Adapt once, move on.
3. **Don't prompt for /setup more than once.** The first-invocation notice (section 5) handles this.
4. **Don't create scaffolding that belongs to another skill.** /spec creates specs, not SCOPE.md.
5. **Don't degrade silently.** When you skip a check, say what you skipped and what you did instead, in one sentence.
6. **Don't nudge more than once per discovery.** Ask, respect the answer.
7. **Don't emit concerns at Tier 2 without the nudge protocol.** The user chose to track - that doesn't mean they want every observation recorded.
8. **Don't offer automation suggestions below Tier 3.** Premature automation is worse than manual work.
9. **Don't write to shared files without checking Claims.** See section 7.
10. **Don't skip the exit protocol on commit-producing skills.** See section 6.

## 11. Canonical Branch Convention

One designated branch holds the canonical CONCERNS.md.
The canonical branch is implicitly designated by where `## Active Workflow` lives in CLAUDE.md.

Development uses worktrees branched from the canonical branch:
- Every worktree inherits CONCERNS.md from the source branch at creation time
- Changes merge back when the worktree merges
- No cross-branch reads needed - the worktree has the right context from birth

CLAUDE.md Active Workflow table includes:

```markdown
| Canonical branch | main |
```

Claims (volatile, session-scoped) are worktree-local by nature.

/check-in warns when a worktree is behind the canonical branch's CONCERNS.md.
/reorient flags stale canonical branch designations.

## 12. Skill Tier Declaration Template

Every skill's `## Engagement` section uses this format:

```markdown
## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: {concerns (type: ...), flags, audit results, nothing}
Writes: {files this skill creates or appends to - or "none"}
Override: {behavioral deviation from defaults - or omit line}
```

Skills with overrides expand the Override field to explain the deviation.
Skills that opt out entirely (e.g., /how-to-start) state the opt-out and reason.

## 13. Exit Sequence

Every skill ends with the same two-step sequence, after it has applied its own gated writes.
This sequence is shared protocol: a skill's `## Exit` cites it in one line and lists only its own unique handoffs, never restating the two steps.

1. **Emit the artifacts manifest** ([manifest.md](manifest.md)) - the run-time receipt of what the run wrote. A run that wrote nothing prints the empty manifest.
2. **Run the chain dispatcher** ([../chain/reference.md](../chain/reference.md)) for the next hop, immediately after the manifest. On a clean edge it advances; on a gate, or when there is no clean outgoing edge, it stops and hands back, so for a skill off the chain spine this step is a no-op hand-back.

The one-line citation each skill's `## Exit` carries:

```markdown
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#13-exit-sequence).
```

### Conditional handoffs

A skill's unique Exit handoffs may be conditional - a tier-specific line, a workflow-shaped recommendation.
When a condition plainly does not hold, skip its handoff silently.
Do not narrate the skip, and do not spend attention evaluating a conditional whose trigger is obviously absent.
