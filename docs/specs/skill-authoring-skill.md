# Skill-Authoring Skill

**Status:** Draft - grilling not started
**Created:** 2026-07-20
**Updated:** 2026-07-20

## Problem

The MZ skill family has no meta-skill for writing new skills.
Patterns are learned by reading existing skills, not from a codified reference.
MP has writing-great-skills (a pure reference skill with a failure mode vocabulary and information hierarchy framework).
MZ-specific patterns (frontmatter contracts, authority model, phase gates, resolution cascade, single-writer discipline, ACTIVE-WORK.md coordination) are not documented in a skill-consumable format.

## Context from MP's writing-great-skills

MP's skill covers:
- **Invocation axis:** model-invoked vs user-invoked, description writing, router skills
- **Information hierarchy:** in-skill step, in-skill reference, external reference, progressive disclosure
- **When to split:** by invocation (distinct leading word) or by sequence (post-completion steps)
- **Pruning:** single source of truth, relevance, no-ops
- **Leading words:** compact pretrained concepts that anchor behavior
- **Failure modes:** premature completion, duplication, sediment, sprawl, no-op, negation
- Plus a GLOSSARY.md companion with per-term "Avoid" lists

## Open Questions

### Q1: Scope
Just MZ patterns, or general skill authoring?
MP's writing-great-skills is general-purpose. MZ could either:
a) Fork and extend MP's with MZ-specific patterns
b) Write a new skill that covers both general principles and MZ conventions
c) Write a pure MZ-patterns reference, assuming the author already knows general principles

### Q2: Reference vs workflow
MP's writing-great-skills is a pure reference ("this skill is all reference").
Should the MZ version be:
a) Pure reference (same as MP - consult when writing skills)
b) Workflow (guided process: scope -> draft -> validate -> publish)
c) Hybrid (workflow that references the protocol docs)

### Q3: MZ-specific patterns to codify
Which patterns are MZ-specific and need documentation?
Candidates:
- Frontmatter contracts (inputs/outputs/signals)
- Authority model (check-in decides, verbs execute)
- Phase gates with regression handling
- Resolution cascade (source -> test -> human)
- Single-writer discipline (only wrapup writes to shared docs)
- ACTIVE-WORK.md coordination protocol
- Shared reference file pattern (CONTEXT-FORMAT.md, ADR-FORMAT.md, LIGHTWEIGHT.md)
- Tone definitions per skill
- AskUserQuestion conventions (conversational fallback, learn-mode elaboration)
- Graceful degradation (LIGHTWEIGHT.md protocol)

### Q4: Validation / lint step
Should the skill include a validation step that checks a draft skill against the family's conventions?
e.g., "Does it have a frontmatter contract? Does it reference LIGHTWEIGHT.md? Does it declare signals?"

### Q5: Relationship to /find-skills
/find-skills helps discover and install external skills.
Should the authoring skill also cover publishing to the ecosystem (npx skills conventions)?

### Q6: Naming
/write-skill? /author-skill? /skill-template? /new-skill?
MZ convention is verb-oriented. "author" or "write" as the leading word?
