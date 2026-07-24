# Waypoint Skills - Reference Tree Restructure Spec

Status: spec (post-grill)
Date: 2026-07-24
Grilled by: /grill-with-docs (10 questions resolved)
Target repo: git@github.com:max-zhu-bv/waypoint-skills.git

---

## Goal

Restructure the Waypoint skill family for token efficiency and structural reinforcement.
Every previous feature preserved or extended.
No skill degrades in capability.

## Acceptance Criteria

1. Every SKILL.md is <=100 lines (CI enforced), targeting 50-80.
2. Every skill-specific reference file is loaded via imperative directive ("Read [X] before Y").
3. Shared infrastructure (ENGAGEMENT-REFERENCE.md, CONCEPTS-REFERENCE.md) is declaration + on-demand in each skill.
4. No content is duplicated between SKILL.md and reference files.
5. All 21 skills pass manual invocation test after restructure.
6. sync-skills.ps1 syncs all children recursively (skills, internals, templates, process, root files).
7. CI lint check warns >80, fails >100 lines in any SKILL.md.
8. CONTRIBUTING.md documents all structural rules.
9. process/ deployed to ~/.claude/process/ (5 files, 870 lines).
10. README.md reflects the new structure.

---

## Design Decisions (from /grill-with-docs)

### D1. Directive verbs - all imperative for skill-specific reference
Skill-specific reference files (reference/*.md, phases/*.md) use imperative directives:
"Read [reference/priority-stack.md](reference/priority-stack.md) before proposing work."
No contextual "See [X] for details" for skill-owned content - silent degradation risk too high.

### D2. Content ownership - declare, don't define
Every piece of instruction content has exactly one authoritative location.
SKILL.md may declare (what this skill does differently) but never define (restate shared protocol).

### D3. Engagement declaration contract
The ## Engagement section becomes a pure declaration - only fields where this skill diverges:

```markdown
## Engagement
Read [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md).
Emits: concerns (type: issue, question)
Writes: none
Override: commit-producing skill - follows exit protocol (section 6)
```

3-5 lines per skill. No boilerplate (nudge protocol, concern format, prohibitions, claims check).
Those are shared protocol defined in ENGAGEMENT-REFERENCE.md.

### D4. Shared infrastructure = declaration + on-demand
Shared infrastructure files (internals/*.md, process/*.md) are NOT loaded imperatively on every invocation.
Skills declare their relationship and consult on demand when performing an engagement action.
This preserves the token savings that engagement deduplication creates.

### D5. Six ownership rules

| Content type | Where it lives | SKILL.md contains |
|-------------|---------------|-------------------|
| Engagement protocol | ENGAGEMENT-REFERENCE.md | Declaration only (emits, writes, override) |
| Skill hints mechanic | CONCEPTS-REFERENCE.md | Integration point ("during Step N") |
| Exit handoffs | SKILL.md | 2-4 bullets, unique per skill |
| Tone | SKILL.md | 1 sentence, mandatory |
| Routing/purpose | Frontmatter description | Nothing restated in body |
| Boundaries | SKILL.md opening line | "Does NOT: {guardrail}" mandatory |

### D6. SKILL.md body contract
No H1 header (frontmatter name + directory is identity).
No "## On invocation" header (skill runs on invocation - the body is sequential).
No opening paragraph restating the description.

Body structure:
```
---
name, description, status
---
Does NOT: {boundary guardrail}.

{Instructions start here. Sequential. No preamble header.}

## {Skill-specific sections only where genuine logical break}

## Engagement
{declaration only - 3-5 lines}

## Exit
{2-4 bullets - handoff targets}

## Tone
{1 sentence}
```

### D7. Two subfolder types only

| Subfolder | Semantic | Examples |
|-----------|----------|---------|
| phases/ | Routed-one-at-a-time based on current state | Phase files, wave files, branch files |
| reference/ | Conditionally loaded material | Priority stacks, format specs, methodology |

Design's waves -> phases/wave-1-soul.md (file name carries the concept).
Prototype's branches -> phases/logic.md, phases/ui.md, phases/design.md.
Format specs (ADR, glossary) -> reference/.
No waves/, branches/, or formats/ subfolder types.

### D8. process/ is a peer directory
process/ stays as a sibling to skills/, internals/, templates/ under ~/.claude/.
Contains 5 tool-agnostic methodology docs (870 lines).
The five adapter skills (tdd, diagnose, spec, learn, improve-codebase-architecture) reference these.
Ghost references resolved by deploying process/ via sync script.

### D9. CI enforcement
CI lint check: `wc -l` on every SKILL.md.
Warn >80 lines. Fail >100 lines.

### D10. Migration strategy B
Infrastructure first, then skills in batches.
Per-skill atomicity within batches (create files -> update SKILL.md -> test -> commit).

---

## Frontmatter description audit

All descriptions follow: verb-first, what it does, when to use it.
Current flabby examples:
- find-skills: "This skill helps you discover and install skills from the open agent skills ecosystem."
- setup: "Structured project kickoff with scoping grill, architecture decisions, documentation structure, and CLAUDE.md generation. Use at project start, when setting up a new repo, or when foundational decisions are missing."

Target: sharp, verb-led, routing-ready.
Audit all 21 descriptions in a single pass.

---

## Implementation Slices

### Slice 1: Sync script fix
**Depends on:** none
**Files:** sync-skills.ps1
**Done when:** Running sync-skills.ps1 copies skills/ (flattened), internals/, templates/, process/, CONCERNS-FORMAT.md, and README.md to ~/.claude/. All five process/ files resolve from skill links.
**Notes:** Updated script already drafted in this session. Commit to the waypoint-skills repo.

### Slice 2: CONTRIBUTING.md structural rules
**Depends on:** none
**Files:** CONTRIBUTING.md
**Done when:** CONTRIBUTING.md documents:
- SKILL.md body contract (D6): no H1, no "On invocation", body starts with "Does NOT:", mandatory Tone/Exit
- Content ownership rules (D5): six rules table
- Directive verb rules (D1, D4): imperative for skill-specific, declaration for shared
- Engagement declaration contract (D3): 3-5 line template
- Subfolder convention (D7): two types only (phases/, reference/), when to use each
- Line budget: target 50-80, max 100, CI enforced
**Notes:** Extends existing CONTRIBUTING.md which already documents process/adapter split, frontmatter schema, and engagement model.

### Slice 3: CI lint check
**Depends on:** none
**Files:** .github/workflows/ (or equivalent CI config), lint-skills.sh (or inline)
**Done when:** CI warns on SKILL.md >80 lines, fails on >100 lines. Clear error message names the file and current count.
**Notes:** Simple wc -l check. Runs on every PR.

### Slice 4: Engagement deduplication (all 19 skills)
**Depends on:** Slice 2 (rules documented)
**Files:** All 19 SKILL.md files with ## Engagement sections, internals/ENGAGEMENT-REFERENCE.md
**Done when:**
- Every ## Engagement section is 3-5 lines (declaration only)
- No SKILL.md restates nudge protocol, concern format, prohibitions, or claims check
- ENGAGEMENT-REFERENCE.md is updated if the declaration contract changes what it needs to specify
- Saved ~6 lines per skill (~114 lines total across 19 skills)
**Notes:** Mechanical find-and-replace. All boilerplate lines are identical - grep confirms.
Per-skill the unique fields are: Emits, Writes, Override. Everything else is shared protocol.

### Slice 5: Structural cleanup (all 21 skills)
**Depends on:** Slice 2 (rules documented), Slice 4 (engagement done)
**Files:** All 21 SKILL.md files
**Done when:**
- No SKILL.md has an H1 header
- No SKILL.md has "## On invocation" or "## When to use" or "## Role" preamble
- Every SKILL.md opens with "Does NOT: {boundary}" as first body line
- Every SKILL.md has a ## Tone section (1 sentence)
- Every SKILL.md has a ## Exit section (2-4 bullets) or explicitly opts out (e.g., /setup completion message serves as exit)
- Opening paragraphs that restate the frontmatter description are removed
- "## Skill hints config" sections in check-in and how-to-start replaced with one-line CONCEPTS-REFERENCE.md reference
**Notes:** Cosmetic + structural. No behavioral change. Skills read identically by the agent.
The "Does NOT" line must be written fresh for skills that don't have one (most skills).
Tone sections exist in 12/21 skills - write the missing 9.

### Slice 6: Frontmatter description audit
**Depends on:** Slice 5 (structural cleanup done - descriptions are now the sole identity)
**Files:** All 21 SKILL.md frontmatter blocks, skills/README.md skill map table
**Done when:**
- Every description is verb-first, sharp, routing-ready
- No description exceeds ~120 chars
- README.md skill map Purpose column matches frontmatter descriptions
- Thematic alignment: consistent voice across all 21 descriptions
**Notes:** Single audit pass. Update frontmatter + README.md together.

### Slice 7: Content extraction - monolithic skills
**Depends on:** Slice 5 (structural cleanup done)
**Files:** check-in/, wrapup/, reorient/, how-to-start/, breakdown/, port/, create/
**Done when:**
- check-in/SKILL.md ~60 lines + reference/priority-stack.md, reference/enforcement.md, reference/methodology-selection.md
- wrapup/SKILL.md ~55 lines + reference/resolution-cascade.md, reference/doc-cascade.md, reference/milestone-closure.md
- reorient/SKILL.md ~65 lines + reference/snapshot-protocol.md, reference/axis-audit.md, reference/hard-questions.md
- how-to-start/SKILL.md ~70 lines + reference/signal-table.md, reference/opinion-checks.md, reference/urgency-protocol.md
- breakdown/SKILL.md ~60 lines + reference/decomposition-rules.md, reference/edge-cases.md
- port/SKILL.md ~70 lines + reference/ (REFERENCES.md moved) + reference/subagent-brief.md
- create/SKILL.md ~65 lines + reference/bridge-behavior.md (if needed)
- Every extracted reference file linked with imperative directive in SKILL.md
- No content lost - every line moved, not deleted
- Each skill passes manual invocation test
**Notes:** This is the highest-risk slice. Per-skill atomicity: create reference/ -> extract content -> update SKILL.md links -> test invocation -> commit. One skill at a time within this slice.

### Slice 8: Directory reorganization - multi-file skills
**Depends on:** Slice 5 (structural cleanup done)
**Files:** setup/, migrate/, design/, buildout/, prototype/, grill-with-docs/, improve-codebase-architecture/
**Done when:**
- setup/: PHASE-1.md -> phases/phase-1.md, SCOPE-REFERENCE.md -> reference/scope-tiers.md, RESUME-PATH.md -> reference/resume-path.md, LOCAL-DOCS-REFERENCE.md -> reference/local-docs.md, REFERENCES.md -> reference/references.md. SKILL.md trimmed to ~100 lines.
- migrate/: 7 phase files -> phases/. REFERENCES.md -> reference/. SKILL.md trimmed to ~80 lines.
- design/: WAVE-*.md -> phases/wave-*.md. REFERENCES.md -> reference/. SKILL.md trimmed to ~70 lines.
- buildout/: phase files -> phases/. REFERENCES.md -> reference/. SKILL.md trimmed to ~70 lines.
- prototype/: LOGIC.md, UI.md, DESIGN.md -> phases/. SKILL.md stays at ~58 lines.
- grill-with-docs/: GLOSSARY-FORMAT.md, ADR-FORMAT.md -> reference/. SKILL.md stays at ~104 lines (above target, below max - accepted).
- improve-codebase-architecture/: DEEPENING.md, HTML-REPORT.md, INTERFACE-DESIGN.md, LANGUAGE.md -> reference/. SKILL.md stays at ~60 lines.
- All relative links updated in SKILL.md
- Each skill passes manual invocation test
**Notes:** Mostly mechanical moves. Per-skill atomicity same as Slice 7.

### Slice 9: README.md and directory layout update
**Depends on:** Slice 7, Slice 8 (all skills restructured)
**Files:** skills/README.md
**Done when:**
- Directory layout section reflects phases/ and reference/ subfolders
- Skill map table reflects updated descriptions from Slice 6
- process/ documented as peer directory
- Glossary updated if any concepts changed
**Notes:** Final documentation pass. Reflects actual state after all restructuring.

### Slice 10: Validation
**Depends on:** all previous slices
**Files:** none (test-only)
**Done when:**
- Every SKILL.md passes the CI lint check (<=100 lines)
- sync-skills.ps1 deploys all content correctly
- 5 representative skills manually invoked and tested: check-in (monolithic split), migrate (directory reorg), tdd (adapter + process/), grill-with-docs (format files moved), setup (heaviest skill)
- No dead links in any SKILL.md (grep for markdown links, verify targets exist)
- CONTRIBUTING.md rules are followed by every skill
**Notes:** This is the gate. If any skill degrades, fix before merging.

---

## Build Order

```
Slice 1 (sync script)  ─┐
Slice 2 (CONTRIBUTING)  ─┼─ no dependencies, can run in parallel
Slice 3 (CI lint)       ─┘
         │
Slice 4 (engagement dedup) ── depends on 2
         │
Slice 5 (structural cleanup) ── depends on 2, 4
         │
Slice 6 (description audit) ── depends on 5
         │
Slice 7 (monolithic extraction) ─┐
                                  ├─ depend on 5, can run in parallel
Slice 8 (directory reorg)       ─┘
         │
Slice 9 (README update) ── depends on 7, 8
         │
Slice 10 (validation) ── depends on all
```

Slices 1-3 are independent. Slices 7-8 are independent of each other.
Critical path: 2 -> 4 -> 5 -> 7 -> 9 -> 10

---

## Change Log

- 2026-07-24: Created from reference-tree-proposal.md + 10 /grill-with-docs decisions
