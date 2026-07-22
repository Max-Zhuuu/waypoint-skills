# Concerns

A single tracking artifact for everything a project doesn't know yet, is assuming, or has flagged as wrong.
One file, one format, one scroll.
Volatile entries (claims) and persistent entries (questions, assumptions) coexist through section ordering and clear marking.

## The file

`CONCERNS.md` in `docs/local/` (gitignored) or project root (tracked), depending on whether the project wants concern history in version control.

## Concern format

Each concern is a block. The header line is the contract:

```
### C-{NNN} [{status}] {one-line description}
```

Everything below the header is free-form. Conventions, not schema:

```markdown
### C-041 [open] Should vessel status transitions require confirmation?
type: question | raised: 2026-07-18
Context from VesselList.vue - WPF app has a confirmation dialog before
status transitions. Our implementation doesn't. Intentional or gap?
refs: docs/wpf-reference/features/vessel-list.md
```

Common detail fields (all optional - a valid concern can be just the header):

| Field | Used by | Purpose |
|-------|---------|---------|
| `type:` | all | question, assumption, flag, deferred-doc |
| `raised:` | all | date concern was opened |
| `refs:` | all | links to specs, ADRs, code, other concerns |
| `risk:` | assumptions | low / medium / high |
| `deadline:` | assumptions | validate by when |
| `source:` | flags | which skill or observation emitted it |
| `decision:` | resolved questions | what was decided and why |
| `resolved:` | resolved concerns | date resolved |

A solo developer might write:

```markdown
### C-003 [open] Does the API paginate?
```

That's a valid concern. The fields exist for when you need them, not as ceremony.

## Claims section

Claims replace ACTIVE-WORK.md. They are session-scoped coordination, not persistent tracking.
They use a table because they have fixed columns and churn frequently:

```markdown
## Claims
<!-- Volatile. Entries here are session-lifetime. Stale after 4 hours. -->

| ID | Session | Started | Working On | Files |
|----|---------|---------|------------|-------|
| C-050 | fcadd763 | 2026-07-21 | Login gate: router guard, layout switching | src/router/, src/views/LoginView.vue |
```

Claims share the C-NNN ID space. When a claim is released, it moves to Resolved with a one-liner.
If claims feel like noise in the ID sequence, that's a signal the project isn't generating many persistent concerns - which is fine.

## Sections

Concerns are grouped by status, in this order:

```markdown
# Concerns

## Claims
## Open
## Investigating
## Blocked
## Resolved
```

Empty sections can be omitted.
Moving a concern between statuses means moving it between sections and changing the bracket word.
Keep the last ~20 resolved concerns. Archive older ones if the file gets long.

## Types

**question** - needs a decision or answer.
"Should X work like Y?" / "Which auth provider?" / "Does the WPF app handle this case?"

**assumption** - working theory that hasn't been validated.
"We assume Azure SQL Edge matches Azure SQL for JSON queries."
Add `risk:` and `deadline:` when the assumption is load-bearing.

**flag** - something looks wrong or needs attention.
"Mock API returns 200 for invalid IDs." / "No test seam for this bug."
Often emitted by task-layer skills during their work.

**deferred-doc** - documentation intentionally skipped at commit time.
Emitted by the exit protocol (ENGAGEMENT-REFERENCE.md section 6) when a commit is provisional.
Includes: what needs documenting, why it was deferred, and the commit SHA.
Age-based pressure: /check-in escalates deferred-docs from mention (< 3 days) to flag priority (> 7 days) to top of stack (> 14 days).

## Status lifecycle

```
open --> investigating --> resolved
  |          |
  |          +--> blocked --> resolved
  |                  |
  +--> stale         +--> stale
```

- **open** - raised, not yet being worked on
- **investigating** - someone (or something) is actively looking into it
- **blocked** - waiting on external input, a dependency, or another concern
- **resolved** - answered, validated, or fixed (add decision/resolution note and commit SHAs)
- **stale** - no activity for 2+ weeks; review or close

### Resolved format

When resolving a concern, include the commits that addressed it:

```markdown
### C-015 [resolved] FE not consuming real BE for Claims, Pool, Search
type: flag | raised: 2026-07-20 | resolved: 2026-07-25
Resolution: Wired Claims list to real API. Field mappings verified against C# source.
Commits: abc1234, def5678
```

Concerns reference commits. Commits don't reference concerns.
Commit messages describe what changed and why - concern IDs are project-management metadata that becomes noise in the long-term commit log.

Claims skip this lifecycle. They are active or removed.

## ID scheme

Monotonically increasing integers: C-001, C-002, C-003.
New concern = current max ID + 1.

IDs are never reused. A resolved concern keeps its ID forever.
Other docs reference concerns as `C-041` in prose, or `[C-041]` as a link.

If exported to Linear: add `linear: PROJ-123` to the detail lines.
The concern ID is canonical within the project; the Linear ID is the external handle.

## How skills interact

**Task-layer skills emit concerns:**
- /diagnose: "No correct test seam exists" -> flag
- /tdd: "Discovered undocumented business rule" -> question
- /tdd: "Provisional commit, spec sync deferred" -> deferred-doc
- /port: "Spec says X, reality is Y" -> flag
- /spec: "This requirement is ambiguous" -> question

**Project-layer skills consume concerns:**
- /check-in reads open concerns, prioritizes by type and age
- /wrapup resolves concerns tagged to the current entity
- /reorient generates a progress summary from concern stats (not persisted - printed or saved as a dated snapshot)

**No skill is required.**
A developer can open the file, type a `### C-0xx [open] ...` line, and close it.
The format works whether you invoke it through a skill, type it by hand, or paste it from a conversation.

## What this replaces

| Was | Becomes |
|-----|---------|
| QUESTIONS.md | Concerns of type `question` |
| ASSUMPTIONS.md | Concerns of type `assumption` with `risk:` and `deadline:` |
| ACTIVE-WORK.md | Claims section (volatile, session-lifetime) |
| PROGRESS-AUDIT.md | Generated on demand by /reorient from concern stats. Not a file. |

## Progressive disclosure

**Solo developer:** Header lines only. No types, no dates, no refs.
Add structure when it helps you, not because the format demands it.

**Small team:** Add `type:` for filtering. Add `raised:` so stale concerns surface.
Add `refs:` so people find context without asking.

**Large project / migration:** Add `risk:` and `deadline:` for assumptions.
Use claims for session coordination. Track the file in git so concern history is versioned.
Consider the Linear adapter for external visibility.

## Adapting to your context

### Human, no AI

Open the file. Read the Open section.
Add new concerns by copying a header line, changing the ID and text.
Change status by editing the bracket word and moving the block to the right section.
That's it. If you can use a text editor and Ctrl+F, you can maintain this file.

### Human with AI assistant

"Add a concern about X." "What's blocking us?" "Resolve C-041, we went with Entra ID."
The assistant reads and writes CONCERNS.md. You review the changes in your diff tool like any other file.

### AI agent (automated)

Read CONCERNS.md at session start.
Emit new concerns during task-layer work.
/check-in reads them to propose work. /wrapup resolves them.
Claims section is the coordination mutex for concurrent sessions.

### Exported to a tracker

An adapter script reads CONCERNS.md, creates issues for open concerns, writes the external ID back:

```markdown
### C-041 [open] Should vessel status transitions require confirmation?
type: question | raised: 2026-07-18 | linear: GLOM-234
```

Bidirectional sync is possible but optional.
For lightweight projects, the file is the source of truth.
For team-scale projects, the external tracker takes over and the file becomes a local cache.

## Full example

```markdown
# Concerns

## Claims

| ID | Session | Started | Working On | Files |
|----|---------|---------|------------|-------|
| C-012 | fcadd763 | 2026-07-21 | Login gate implementation | src/router/, src/views/LoginView.vue |

## Open

### C-011 [open] Should ribbon buttons grey out or hide when unavailable?
type: question | raised: 2026-07-19
WPF app greys them out. Modern convention is to hide.
Design decision needed before building remaining ribbon layouts.
refs: docs/improvements/ribbon-disabled-link-tiers.md

### C-009 [open] Azure SQL Edge JSON behavior matches Azure SQL
type: assumption | raised: 2026-07-14 | risk: medium
deadline: before beta deployment
We're using JSON_VALUE in several mock queries. Need to verify
these work identically on the real Azure SQL instance.

## Investigating

### C-010 [investigating] Mock API returns 200 for invalid entity IDs
type: flag | raised: 2026-07-16 | source: /diagnose
mock-backend/src/server.js returns empty result set, not 404.
Real API behavior unknown - need to check Azure Functions spec.
refs: C-009

## Resolved

### C-008 [resolved] Which authentication provider?
type: question | raised: 2026-07-10 | resolved: 2026-07-15
decision: Entra ID. See ADR-0005. Auth0 considered but rejected
due to existing Microsoft 365 tenant.
refs: docs/adr/0005-entra-id-auth.md

### C-007 [resolved] Is accounting data in-house or ERP-integrated?
type: question | raised: 2026-07-08 | resolved: 2026-07-12
decision: In-house CRUD. No ERP integration. Integration screens
repurposed for native financial reference data.
```
