# Waypoint Skills - Reference Tree Proposal

Status: draft for /grill-with-docs
Date: 2026-07-24
Problem: token efficiency - skills load too much content upfront

---

## Problem Statement

Total corpus: 87 files, 8,184 lines across 21 skills + shared infrastructure.
When a skill fires, SKILL.md is auto-loaded in full. Everything else requires an agent-driven Read.

Current token cost profile:

| Tier | Skills | SKILL.md lines | Pattern |
|------|--------|---------------|---------|
| Lean adapters | tdd(70), diagnose(67), prototype(58), learn(63) | 58-70 | Reference methodology doc, tool-specific notes only |
| Mid-weight | spec(81), grill-with-docs(104), create(129) | 81-129 | Self-contained but manageable |
| Monolithic | check-in(152), how-to-start(156), wrapup(148), reorient(170), breakdown(148), port(149) | 148-170 | Everything inline, nothing deferred |
| Heavy orchestrators | setup(342), migrate(191), design(165), buildout(144) | 144-342 | Already split, but SKILL.md still fat |

The lean adapters prove the pattern works: 60-70 line SKILL.md + conditional reference reads.
The monolithic skills are 2-3x heavier than they need to be.

Additionally, 694 lines of engagement protocol are duplicated across 15 skills (remediation plan Section 1).
ENGAGEMENT-REFERENCE.md (339 lines) and CONCEPTS-REFERENCE.md (336 lines) exist but skills don't use them efficiently.

---

## Design Principles

1. **SKILL.md is the entry point, not the encyclopedia.**
   It answers: what does this skill do, what's the entry flow, what does it output.
   It does NOT contain: detailed protocols, format specs, reference tables, methodology.

2. **Conditional loading via directive verbs.**
   Two patterns, used deliberately:
   - **Imperative** (always read): "Read [phases/phase-1.md](phases/phase-1.md) before starting Phase 1."
   - **Contextual** (read if needed): "See [reference/priority-stack.md](reference/priority-stack.md) for detailed logic."
   Use imperative for phase gates. Use contextual for reference material.

3. **Subfolders when file count warrants it.**
   - 0-2 reference files: flat alongside SKILL.md
   - 3+ reference files: group into `phases/` and/or `reference/`
   - Never more than one level of subfolder depth

4. **Shared infrastructure stays centralized.**
   internals/, templates/ are shared. Skills link to them, never duplicate.

5. **SKILL.md content contract.**
   Target: 50-80 lines. Max: 100 lines (enforced by convention, not tooling).

---

## SKILL.md Content Contract

Every SKILL.md follows this structure:

```
---
frontmatter (name, description, status)
---

# Skill Name
One-line purpose.

## On invocation
Entry flow. The decision tree. 20-40 lines max.
Contains: what to check, what to read, what to decide.
Does NOT contain: detailed logic for each decision branch.

## [Core logic sections - skill-specific]
The minimum viable instruction set. Only content that is ALWAYS
relevant regardless of which path the entry flow takes.
Examples: output format, cross-skill handoffs, tone.

## Engagement
Tier declaration (~12-15 lines per remediation plan).
Link to ENGAGEMENT-REFERENCE.md.
```

What moves OUT of SKILL.md:
- Detailed decision logic (priority stacks, enforcement rules, classification tables)
- Format specifications (concern format, ADR format, glossary format)
- Phase-specific instructions (already done for migrate, design, buildout)
- Methodology content (already done for tdd, diagnose, spec, learn via process/)
- Reference tables (architecture catalogs, vague term resolution)

---

## Proposed Directory Structure

### Shared Infrastructure (no changes)

```
~/.claude/
  internals/
    ENGAGEMENT-REFERENCE.md    (339 lines - protocol spec, tier detection, write discipline)
    CONCEPTS-REFERENCE.md      (336 lines - extended concept definitions)
  templates/                   (326 lines across 11 files - scaffolding templates)
  CONCERNS-FORMAT.md           (314 lines - tracking format spec)
```

No process/ directory currently exists (per-skill analysis describes it as planned).
Process content lives inside skill reference files (tdd/mocking.md, etc.) or is embedded in SKILL.md.

### Per-Skill Restructure

Below: skills that need restructuring. Skills already lean (tdd, diagnose, spec, grill-me,
learn, chrome-devtools-axi) stay as-is.

---

#### check-in/ (currently 152 lines monolithic -> 60 + 90 in reference)

```
check-in/
  SKILL.md                      # ~60 lines: entry flow, output format, tone
  reference/
    priority-stack.md           # ~35 lines: 3-layer priority logic, concern scanning
    enforcement.md              # ~25 lines: core rules, archetype extras, pre-build checkpoint
    methodology-selection.md    # ~15 lines: verb selection (port/tdd/design), methodology table
```

SKILL.md keeps: On invocation (steps 1-5 as concise flow), authority model (3 lines),
phase regression (5 lines), dynamic adaptation (4 lines), concurrent sessions (5 lines),
engagement tier declaration, tone.

Moves to reference/:
- Priority stack detailed logic (currently 25 lines inline)
- Enforcement rules + archetype extras (currently 20 lines inline)
- Methodology selection + AskUserQuestion guidance (currently 10 lines inline)

Directive pattern:
- "Apply priority stack to propose next task. See [reference/priority-stack.md] for layer details."
- "Fire pre-build checkpoint. See [reference/enforcement.md] for rules."

---

#### wrapup/ (currently 148 lines monolithic -> 55 + 90 in reference)

```
wrapup/
  SKILL.md                      # ~55 lines: 5-step process summary, output, tone
  reference/
    resolution-cascade.md       # ~30 lines: source -> test -> escalate protocol
    doc-cascade.md              # ~30 lines: which shared docs to check, append-only rules
    milestone-closure.md        # ~15 lines: milestone lifecycle, spec archival
```

SKILL.md keeps: On invocation (5 steps as one-liners), concern gathering,
engagement tier declaration, tone.

---

#### reorient/ (currently 170 lines monolithic -> 65 + 105 in reference)

```
reorient/
  SKILL.md                      # ~65 lines: 5-phase overview, output format, tone
  reference/
    snapshot-protocol.md        # ~35 lines: what to read, git log categorization
    axis-audit.md               # ~30 lines: 5-axis rating criteria
    hard-questions.md           # ~25 lines: deferred decision detection, rework loops
```

---

#### how-to-start/ (currently 156 lines monolithic -> 70 + 85 in reference)

```
how-to-start/
  SKILL.md                      # ~70 lines: 4-step flow, rules, engagement
  reference/
    signal-table.md             # ~40 lines: 18-row intent classification table
    opinion-checks.md           # ~20 lines: context checks before recommending
    urgency-protocol.md         # ~15 lines: skip/invoke/teach-on-exit pattern
```

The signal table is the biggest win here - 40 lines of classification logic
that's only relevant during Step 2, loaded after Step 1 completes.

---

#### setup/ (currently 342 lines SKILL.md -> 100 + 240 restructured)

```
setup/
  SKILL.md                      # ~100 lines: entry modes, phase 0 grill, gate, completion
  phases/
    phase-1.md                  # 204 lines (exists as PHASE-1.md, rename + move)
  reference/
    scope-tiers.md              # 104 lines (exists as SCOPE-REFERENCE.md, rename + move)
    resume-path.md              # 120 lines (exists as RESUME-PATH.md, move)
    local-docs.md               # 44 lines (exists as LOCAL-DOCS-REFERENCE.md, rename + move)
    references.md               # 110 lines (exists as REFERENCES.md, move)
```

This is mostly a rename + move. The existing flat files become subfolder files.
SKILL.md needs trimming: the file classification rules (30 lines), restructure flow (20 lines),
and content merge rules (15 lines) could move to reference/restructure-guide.md.

---

#### migrate/ (currently 191 lines SKILL.md, 403 in phase files -> 80 + phases/)

```
migrate/
  SKILL.md                      # ~80 lines: setup flow, enforcement inputs, improvement rule
  phases/
    02-documentation-sprint.md  # 33 lines (exists, just move)
    03-vertical-slice.md        # 57 lines (exists, just move)
    04-horizontal-buildout.md   # 55 lines (exists, just move)
    05-integration.md           # 55 lines (exists, just move)
    06a-functional-validation.md # 48 lines (exists, just move)
    06b-design-pass.md          # 74 lines (exists, just move)
    07-cutover.md               # 51 lines (exists, just move)
  reference/
    references.md               # 30 lines (exists as REFERENCES.md, move)
```

Phase files are already split. Just move them into phases/ subfolder.
SKILL.md needs trimming: the per-phase summary table (currently ~60 lines of
phase descriptions) can shrink to one-liners now that phases/ holds the detail.

---

#### design/ (currently 165 lines SKILL.md, 439 in wave files -> 70 + waves/)

```
design/
  SKILL.md                      # ~70 lines: entry modes, context gate, wave routing
  waves/
    wave-1-soul.md              # 115 lines (exists as WAVE-1-SOUL.md, move)
    wave-2-tokens.md            # 104 lines (exists as WAVE-2-TOKENS.md, move)
    wave-3-proof.md             # 79 lines (exists as WAVE-3-PROOF.md, move)
  reference/
    references.md               # 141 lines (exists as REFERENCES.md, move)
```

Wave files function like phases - sequential, phase-gated.
Already well-structured; this is just a move into subfolders.

---

#### buildout/ (currently 144 lines SKILL.md, 305 in phase files -> 70 + phases/)

```
buildout/
  SKILL.md                      # ~70 lines: entry modes, archetype selection, ship tier
  phases/
    02-discovery.md             # 60 lines (exists, just move)
    03-mvp-build.md             # 78 lines (exists, just move)
    04-iterate-and-ship.md      # 113 lines (exists, just move)
  reference/
    references.md               # 54 lines (exists as REFERENCES.md, move)
```

---

#### breakdown/ (currently 148 lines monolithic -> 60 + 85 in reference)

```
breakdown/
  SKILL.md                      # ~60 lines: 5-step overview, tier-adapted output, tone
  reference/
    decomposition-rules.md      # ~40 lines: slice criteria, dependency ordering, coverage
    edge-cases.md               # ~25 lines: spec changes, circular deps, no acceptance criteria
```

---

#### port/ (currently 149 lines SKILL.md + 72 REFERENCES.md -> 70 + reference/)

```
port/
  SKILL.md                      # ~70 lines: 6-step overview, concurrency, tone
  reference/
    references.md               # 72 lines (exists as REFERENCES.md, move)
    subagent-brief.md           # ~30 lines: extracted from SKILL.md (brief generation protocol)
```

---

#### create/ (currently 129 lines monolithic -> 65 + reference/)

```
create/
  SKILL.md                      # ~65 lines: entry flow, per-feature loop, alternatives, tone
  reference/
    bridge-behavior.md          # ~25 lines: standalone vs Active Workflow behavior
```

create/ is borderline - 129 lines is manageable. Split only if the bridge behavior
section causes confusion when loaded unconditionally.

---

#### prototype/ (currently 58 lines SKILL.md + 347 in branch files -> keep as-is)

```
prototype/
  SKILL.md                      # 58 lines (already lean - just routes to branch files)
  branches/
    logic.md                    # 79 lines (exists as LOGIC.md, rename + move)
    ui.md                       # 155 lines (exists as UI.md, move)
    design.md                   # 113 lines (exists as DESIGN.md, move)
```

SKILL.md is already at 58 lines. Just move branch files into a subfolder.

---

#### grill-with-docs/ (currently 104 lines SKILL.md + 107 in format files -> keep SKILL.md as-is)

```
grill-with-docs/
  SKILL.md                      # 104 lines (borderline, but the flow is cohesive)
  formats/
    glossary-format.md          # 60 lines (exists as GLOSSARY-FORMAT.md, move)
    adr-format.md               # 47 lines (exists as ADR-FORMAT.md, move)
```

SKILL.md at 104 is above the 80-line target but below the 100-line max.
The grill flow is inherently sequential and cohesive - splitting it would create
artificial fragmentation. Keep as-is, move format docs into formats/.

---

#### improve-codebase-architecture/ (60 lines SKILL.md + 257 reference -> keep as-is)

```
improve-codebase-architecture/
  SKILL.md                      # 60 lines (already lean)
  reference/
    language.md                 # 53 lines (exists as LANGUAGE.md, move)
    deepening.md                # 37 lines (exists as DEEPENING.md, move)
    html-report.md              # 123 lines (exists as HTML-REPORT.md, move)
    interface-design.md         # 44 lines (exists as INTERFACE-DESIGN.md, move)
```

---

## Token Budget Impact

### Before (per invocation, SKILL.md auto-load)

| Skill | Auto-loaded lines | Est. tokens |
|-------|------------------|-------------|
| setup | 342 | ~2,400 |
| reorient | 170 | ~1,200 |
| how-to-start | 156 | ~1,100 |
| check-in | 152 | ~1,060 |
| port | 149 | ~1,040 |
| wrapup | 148 | ~1,040 |
| breakdown | 148 | ~1,040 |
| buildout | 144 | ~1,010 |
| design | 165 | ~1,160 |
| migrate | 191 | ~1,340 |

### After (SKILL.md trimmed, reference loaded conditionally)

| Skill | Auto-loaded lines | Savings | Conditional reads |
|-------|------------------|---------|-------------------|
| setup | ~100 | 242 lines (~70%) | phases/, reference/ on demand |
| reorient | ~65 | 105 lines (~62%) | reference/ on demand |
| how-to-start | ~70 | 86 lines (~55%) | signal table only during Step 2 |
| check-in | ~60 | 92 lines (~61%) | priority stack, enforcement on demand |
| port | ~70 | 79 lines (~53%) | references, brief protocol on demand |
| wrapup | ~55 | 93 lines (~63%) | cascade protocols on demand |
| breakdown | ~60 | 88 lines (~59%) | decomposition rules on demand |
| buildout | ~70 | 74 lines (~51%) | phases on demand |
| design | ~70 | 95 lines (~58%) | waves on demand |
| migrate | ~80 | 111 lines (~58%) | phases on demand |

Average auto-load reduction: ~58% across the 10 heaviest skills.

### Engagement deduplication (separate, from remediation plan)

Current: ~46 lines per skill x 15 skills = 694 lines loaded across invocations.
After: ~13 lines per skill x 15 skills = 195 lines loaded.
Savings: 499 lines total, ~33 lines per skill invocation.

---

## Subfolder Convention

| Subfolder | Contains | Naming | When to use |
|-----------|----------|--------|-------------|
| `phases/` | Sequential, phase-gated content | `phase-N.md` or `NN-slug.md` | Workflow/orchestrator skills with distinct phases |
| `waves/` | Sequential design stages | `wave-N-slug.md` | Design skill only |
| `branches/` | Parallel, mutually exclusive paths | `slug.md` | Prototype skill only |
| `reference/` | Conditionally loaded reference material | `slug.md` | Any skill with 3+ reference files |
| `formats/` | Output format specifications | `slug-format.md` | Skills that write structured output |

Rules:
- Never nest subfolders (no `reference/engagement/`)
- SKILL.md always at skill root, never in a subfolder
- Subfolders are optional - flat is fine for 1-2 reference files
- REFERENCES.md (if it exists) always moves into reference/

---

## Migration Path

Phase 1: Engagement deduplication (remediation plan Section 1).
  - Restructure ENGAGEMENT-REFERENCE.md as protocol spec
  - Replace 15 inline engagement blocks with tier declarations
  - Canary: diagnose, reorient, design (per remediation plan)
  - This is independent of directory restructure

Phase 2: Monolithic skill splits (check-in, wrapup, reorient, how-to-start, breakdown).
  - Extract reference material into reference/ subfolders
  - Trim SKILL.md to 60-80 lines
  - Update directive verbs (imperative for phase-gated, contextual for reference)

Phase 3: Existing multi-file skills reorganize (setup, migrate, design, buildout, prototype).
  - Move flat files into phases/, waves/, branches/, reference/ subfolders
  - Rename files to match convention (PHASE-1.md -> phases/phase-1.md)
  - Update all relative links in SKILL.md

Phase 4: Validate token savings.
  - Measure actual token consumption before/after on representative tasks
  - Verify agent follows reference links when needed (degradation check)

---

## Open Questions for /grill-with-docs

1. **Degradation risk:** When SKILL.md shrinks to 60 lines and says "See reference/priority-stack.md
   for details," will the agent reliably follow the link when the priority stack is relevant?
   The imperative pattern ("Read [X] before Y") is reliable but costs a read.
   The contextual pattern ("See [X] for details") is cheaper but may be skipped.
   Where's the line between imperative and contextual?

2. **Phase files as subfolders vs flat:** migrate/ already has 7 phase files flat alongside SKILL.md.
   Moving them to phases/ changes 7 relative links and makes the directory cleaner, but adds
   a level of indirection. Is the cleaner listing worth the link churn?

3. **process/ directory:** The per-skill analysis describes 5 process docs (870 lines) that should
   live in ~/.claude/process/. These don't exist on disk. Were they planned and never created,
   or is the methodology content embedded in skill reference files?
   If process/ is created, adapter-style skills (tdd, diagnose, spec, learn) would become even
   leaner - their SKILL.md is mostly "follow process/X.md + tool-specific notes."

4. **Content contract enforcement:** The 50-80 line target for SKILL.md has no enforcement
   mechanism. A skill author can still write a 300-line SKILL.md.
   Should CONTRIBUTING.md state the target? Should there be a lint check?

5. **Naming: reference/ vs ref/:** reference/ is clearer but longer in paths.
   ref/ is terser. Convention should pick one and stick.

6. **find-skills at 143 lines:** This utility skill is as heavy as workflow skills.
   It embeds the entire skills.sh CLI reference. Should this be split, or is it
   inherently a reference-heavy skill that needs everything upfront?
