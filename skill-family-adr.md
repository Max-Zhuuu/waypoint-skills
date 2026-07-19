# ADR: Skill Family Architecture Redesign

## Status

Accepted (2026-07-18)

## Context

The project-setup / buildout / migrate / check-in / port skill family had accumulated internal contradictions:
- Dual authority between phase files and /check-in
- Dual-write conflicts on shared docs (specs, CONVENTIONS.md)
- Framework-specific methodology baked into framework-agnostic process files
- No failure/rollback model between phases
- Uneven depth (6b overengineered, Phase 7 skeletal)
- Unclear concurrency model
- No explicit completion verb

These contradictions meant the system fought itself during implementation rather than aiding it.

## Decision

Restructure the skill family around three layers with clear ownership boundaries.

### Layer model

| Layer | Owns | Examples |
|-------|------|----------|
| Process | When to decide, what criteria to meet, gate evaluation | /project-setup, /buildout, /migrate, /check-in, /wrapup |
| Decisions | Project-specific choices, generated during setup | CONVENTIONS.md, TESTING.md, ADRs, DESIGN-SYSTEM.md |
| Methodology | How to build, how to test, opinionated patterns | /tdd, /port, /design (personal skills) |

### Specific decisions

#### 1. /check-in is authority, not dispatcher

/check-in reads enforcement rules from phase files as inputs but makes the final call on what to propose.
Its priority stack governs; enforcement violations surface as blockers in the report but don't prevent proposing their resolution.

#### 2. Single-writer: /port flags, /wrapup resolves

/port never updates specs or shared docs itself.
It appends structured flags to the feature spec's ## Flags section.
/wrapup is the single reconciliation point for all doc updates and cascade to shared docs.

#### 3. Execution model: one session, subagents for implementation

/check-in, /port, /wrapup all run within one conversation session.
/port spawns subagents for implementation labor.
Main context holds process state; subagents do the building.

#### 4. Subagent contract: digested brief + review

/port reads the full inputs (spec, logic doc, source), synthesizes a focused build brief for the subagent.
Subagent builds from the brief with read access to full sources if needed.
/port reviews subagent output against spec before reporting complete.
Discrepancies come back as structured flags.

#### 5. Phase regression: allowed, no new artifact

When a gate can't pass because an earlier-phase decision is invalidated, /check-in proposes regression.
Tracked via: ADR (rationale) + inventory reversion (state) + git history (timeline).
No separate regression journal or timestamp file.
Regression is not leapfrogging - /check-in recognizes the difference.

#### 6. /wrapup: optional completion verb

Resolves flags from /port (updates docs, runs cascade).
Evaluates gate criteria and reports what's left.
Flags live in a structured ## Flags section at bottom of feature spec.
If skipped: flags persist, /check-in surfaces them next session as priority-2 blockers.
/port suggests /wrapup on completion; user decides.

#### 7. Phase files = requirements layer only

Phase files define what to build, what criteria to meet, what gate to pass.
They never prescribe methodology (how to test, how to structure implementation).
REFERENCES.md content splits:
- Process refs stay: Shape Up, Kano, JTBD, Build-Measure-Learn, Spolsky
- Methodology refs move to verbs: testing trophy, characterization tests, Strangler Fig, etc.

#### 8. Methodology selection via AskUserQuestion

When the process layer reaches a point where a methodology verb is needed, it asks the user which skill to invoke.
Users can swap in their own methodology skills without editing process files.
The process layer is a pluggable pipeline.

#### 9. Frontmatter contracts on verbs

Each verb declares its contract:

```yaml
inputs:
  - feature-spec: docs/reference/features/{entity}.md
  - logic-doc: docs/reference/logic/{entity}.md
  - source: referenced in feature-spec
outputs:
  - flags: appended to feature-spec ## Flags section
  - inventory: marker updated to [P]
signals:
  - complete: triggers /wrapup suggestion
```

Process layer validates inputs before invocation (CP1).

#### 10. Composable archetypes replace the 3-axis profile system

Named archetypes (multi-select or none) replace the 27-combination scope/validation/design matrix.
Each archetype is a composable enforcement module that adds rules to the core set.
No selection = core rules only + dynamic adaptation from /check-in.

Core enforcement rules (always fire):
1. Specs exist before implementation begins
2. No phase leapfrogging (unless regression - see #5)
3. No stale critical blockers (QUESTIONS.md items if file exists)

Archetype-specific extras stack on top.

#### 11. Within-session concurrency only

/port classifies each subagent brief as "entity-local" (safe to parallelize) or "touches shared files" (serialize).
Cross-session coordination is a tooling/git problem outside the skill system's scope.

#### 12. Enforcement degrades gracefully

If docs/local/ files don't exist (fresh machine, new session), enforcement rules for those files don't fire.
No false violations from missing personal files.

#### 13. docs/local/ is personal scratchpad

Gitignored. Ephemeral. Contains: ACTIVE-WORK.md, QUESTIONS.md, ASSUMPTIONS.md, PROGRESS-AUDIT.md, learning/, handoffs/.
Durable knowledge promotes out to committed artifacts (ADRs, specs, CONVENTIONS.md).

#### 14. Framework-agnostic process, interrogation-based setup

Phase files never name specific technologies (no `useX`, no PascalCase, no `tokens.css`).
project-setup Phase 1 interrogates the implementer about their stack and generates project-specific docs (CONVENTIONS.md, TESTING.md) from their answers.
Framework-specific design methodology lives in personal /design skill, invoked during Phase 6b by choice.

### Session loop

```
/check-in (authority: proposes work)
  -> user invokes verb (/port, /tdd, or chosen methodology)
    -> verb completes, suggests /wrapup
      -> /wrapup (resolves flags, evaluates gate, reports remaining)
      -> OR user continues (flags persist in spec, /check-in catches next session)
```

## Consequences

### New skills needed
- /wrapup - completion verb (resolve flags, cascade, gate evaluation)
- /design (or user's equivalent) - design methodology, split from 6b

### Skill files that need modification
- /project-setup PHASE-1.md - remove framework-specific prescriptions, make interrogation-based
- /buildout SKILL.md - replace 3-axis profile with archetypes, remove methodology from phase files
- /buildout 03-mvp-build.md - remove testing philosophy, express as acceptance criteria only
- /buildout 04-iterate-and-ship.md - remove testing methodology, keep process
- /buildout REFERENCES.md - remove methodology refs (testing trophy, etc.)
- /migrate SKILL.md - replace enforcement ownership language, add regression model
- /migrate 03-vertical-slice.md - remove methodology prescriptions
- /migrate 04-horizontal-buildout.md - remove review agent model ratios (methodology)
- /migrate 06b-design-pass.md - strip to process only, methodology moves to /design
- /check-in SKILL.md - add regression recognition, graceful degradation, dynamic adaptation
- /port SKILL.md - add frontmatter contract, add flag-only output model, add subagent brief model

### What doesn't change
- The phase gate concept
- The improvement capture rule
- The documentation-first principle (specs before code)
- The inventory tracking system
- The resolution cascade (source -> test -> human)
