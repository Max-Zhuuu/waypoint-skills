# Concerns

A single tracking artifact for everything a project doesn't know yet, is assuming, or has identified as wrong.
One file, one format, one scroll.
Volatile entries (claims) and persistent entries (questions, assumptions, issues, milestones) coexist through section ordering and clear marking.

## The file

`docs/implementation/CONCERNS.md` (tracked, versioned).
Alternative placements: `docs/_local/CONCERNS.md` (gitignored) for solo/scratch projects, or project root for flat repos.

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
| `type:` | all | question, assumption, issue, milestone |
| `raised:` | all | date concern was opened |
| `refs:` | all | links to other concern IDs (e.g. C-015, C-017) |
| `risk:` | assumptions | low / medium / high |
| `validate-by:` | assumptions | milestone name or date to validate by |
| `source:` | issues | which skill or observation emitted it |
| `specs:` | milestones | paths to specs belonging to this milestone |
| `handoffs:` | milestones | paths to cross-team contracts |
| `decision:` | resolved questions | what was decided and why |
| `resolved:` | resolved concerns | date resolved |
| `github:` | any | external ref: `owner/repo#123` |
| `linear:` | any | external ref: `PROJ-123` |
| `jira:` | any | external ref: `PROJ-123` |
| `azure-devops:` | any | external ref: `org/project#123` |

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
Add `risk:` and `validate-by:` when the assumption is load-bearing.

**issue** - something looks wrong or needs attention.
"Mock API returns 200 for invalid IDs." / "No test seam for this bug."
Often emitted by task-layer skills during their work.
Age-based pressure: /check-in escalates issues from mention (< 3 days) to priority (> 7 days) to top of stack (> 14 days).

**milestone** - a checkpoint that groups related specs and concerns.
Milestones share the C-NNN ID space with other concerns.
Each spec belongs to exactly one milestone (single-assignment).
When a milestone closes, /wrapup suggests moving its specs to `specs/resolved/YYYY-MM/`.

```markdown
### CP-01 [open] Wire Claims/Pool/Search to real BE
type: milestone | raised: 2026-07-22
specs: docs/implementation/specs/claims-api-wiring.md
handoffs: docs/implementation/handoffs/be-endpoint-contract.md
refs: C-015, C-017
```

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
type: issue | raised: 2026-07-20 | resolved: 2026-07-25
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
Milestones use a CP-NN prefix but share the same ID space (no collisions).
Other docs reference concerns as `C-041` in prose, or `[C-041]` as a link.

### External issue refs

Concerns can link to external issue trackers with typed ref fields:

```markdown
### C-041 [open] Should vessel status transitions require confirmation?
type: question | raised: 2026-07-18 | github: burmester-vogel/bv-glomaris#42
```

Supported prefixes: `github:`, `linear:`, `jira:`, `azure-devops:`.
The concern ID is canonical within the project; the external ID is a cross-reference, not a replacement.
Bidirectional sync is possible via adapter scripts but optional.

## How skills interact

**Task-layer skills emit concerns:**
- /diagnose: "No correct test seam exists" -> issue
- /tdd: "Discovered undocumented business rule" -> question
- /tdd: "Provisional commit, spec sync deferred" -> issue
- /port: "Spec says X, reality is Y" -> issue
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
| ASSUMPTIONS.md | Concerns of type `assumption` with `risk:` and `validate-by:` |
| ACTIVE-WORK.md | Claims section (volatile, session-lifetime) |
| PROGRESS-AUDIT.md | Generated on demand by /reorient from concern stats. Not a file. |

## Progressive disclosure

**Solo developer:** Header lines only. No types, no dates, no refs.
Add structure when it helps you, not because the format demands it.

**Small team:** Add `type:` for filtering. Add `raised:` so stale concerns surface.
Add `refs:` so people find context without asking.

**Large project / migration:** Add `risk:` and `validate-by:` for assumptions.
Use milestones to group specs and track progress toward checkpoints.
Use claims for session coordination. Track the file in git so concern history is versioned.
Consider external issue refs (`github:`, `linear:`, etc.) for cross-tool visibility.

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

## Type mini-grill

/setup offers a type selection for moderate-to-large projects during initial scaffolding.
The default set is question, assumption, issue.
Milestone is offered when the project has multiple phases or parallel features.

```
Which concern types does this project need?
[x] question - decisions needed
[x] assumption - theories to validate
[x] issue - things that look wrong
[ ] milestone - checkpoints grouping specs and handoffs
```

Solo or small projects skip the grill - all types are available, just rarely used.

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
validate-by: CP-01
We're using JSON_VALUE in several mock queries. Need to verify
these work identically on the real Azure SQL instance.

### CP-01 [open] Wire Claims/Pool/Search to real BE
type: milestone | raised: 2026-07-22
specs: docs/implementation/specs/claims-api-wiring.md
handoffs: docs/implementation/handoffs/be-endpoint-contract.md
refs: C-009, C-010

## Investigating

### C-010 [investigating] Mock API returns 200 for invalid entity IDs
type: issue | raised: 2026-07-16 | source: /diagnose
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
