# Skill-Authoring Skill

**Status:** Draft - grilling complete
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

## Decisions

### D1: MZ patterns only
**Decision:** Scope to MZ family conventions only.
Reference writing-great-skills for general skill authoring principles.
The skill's intro states: "For general skill authoring principles, see writing-great-skills. This document covers MZ family conventions."
**Rationale:** MP's writing-great-skills already covers general principles well.
Duplicating that content doubles the maintenance surface.
The MZ family's value comes from its specific patterns, not from restating general principles.
A skill author working in this family either already knows fundamentals or can consult writing-great-skills as a companion.

### D2: Hybrid reference + checklist
**Decision:** Structured reference documenting MZ patterns with a terminal validation checklist.
Not a full workflow skill, not a pure reference.
- Reference sections: one per MZ pattern, with examples from existing skills
- Terminal checklist: mechanically verifiable items for pre-merge validation
- Usable by both humans (consult reference) and agents (follow checklist)
**Rationale:** Pure reference relies on the author knowing when to look things up.
Full workflow adds overhead for experienced authors.
The hybrid serves both audiences without over-constraining either.

### D3: Pattern catalog with propose-then-correct flow
**Decision:** Codify 8 MZ patterns in priority order, with the authoring flow being propose-then-correct:
1. Author describes what the skill does (plain language)
2. Agent proposes frontmatter fields, tone, conventions based on the description and existing family patterns
3. Author corrects the proposal
4. Agent scaffolds the skill with corrected values
5. Terminal checklist validates the result

**Must-codify (high risk of getting wrong):**
1. **Frontmatter contracts** - inputs/outputs/signals format and semantics
2. **Authority model** - /check-in decides, verbs execute; new skills must not be their own authority
3. **LIGHTWEIGHT.md protocol** - graceful degradation without /project-setup
4. **Single-writer discipline** - only /wrapup writes to shared docs; skills create only their own output artifacts
5. **Shared reference file pattern** - CONTEXT-FORMAT.md, ADR-FORMAT.md, LIGHTWEIGHT.md consumption

**Should-codify (medium risk):**
6. **AskUserQuestion conventions** - conversational fallback, learn-mode elaboration
7. **Tone definitions** - characteristic tone per skill, avoiding generic assistant tone
8. **Phase gates with regression handling** - relevant when new skill participates in the phase system

**Reference only (documented elsewhere):**
9. ACTIVE-WORK.md coordination - runtime protocol, not authoring concern
10. Resolution cascade - documented in README.md, reference don't duplicate

Each reference section needs examples from existing skills showing how the pattern manifests, not just the abstract rule.
The reference must be rich enough for the agent to make good field proposals, not just for humans to validate.
**Rationale:** The propose-then-correct pattern is lower friction than "fill in these 12 fields."
The agent does pattern-matching work; the human applies judgment.
Prioritization is by "would a skill author get this wrong without documentation."

### D4: Both inline and standalone validation
**Decision:** Two validation modes:
- **Inline** (during authoring): the propose-then-correct flow (D3) handles validation as part of the process
- **Standalone** (post-hoc): run the checklist against an existing skill file for audit

Checklist items by verifiability:
- Mechanically checkable: has frontmatter with required fields, references LIGHTWEIGHT.md, declares signals, plugin.json entry exists
- Agent judgment: tone consistency, single-writer discipline compliance, authority model adherence
**Rationale:** Inline validation handles the authoring case.
Standalone handles convention audits after the family evolves, and reviews of contributed skills.

### D5: Light publishing coverage
**Decision:** Include a "publishing" reference section covering:
- How to add the skill to plugin.json (field semantics, ordering)
- Naming conventions for npx discoverability
- Checklist item for plugin.json update before merge

Does NOT cover:
- npm/npx publishing mechanics (infrastructure, not authoring)
- Marketplace submission process (separate workflow)
- Cross-family compatibility (out of scope for MZ-specific reference)
**Rationale:** Publishing is a follow-on concern to authoring, not the core activity.
Light coverage prevents the "I wrote a skill but forgot to register it" failure mode without scope-creeping into infrastructure docs.

### D6: Named /author-skill
**Decision:** The skill is named /author-skill.
**Rationale:** "Author" signals intent and craft, matching the hybrid reference + guided flow.
The two-word form "/author-skill" makes the object explicit even outside the skill family context.
Single-word "/author" was considered but is slightly vague when seen in isolation (author what?).
Consistent with MZ verb-oriented naming convention.
