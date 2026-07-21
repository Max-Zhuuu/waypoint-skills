# Skill-Authoring Skill

**Status:** Draft - README alignment complete
**Created:** 2026-07-20
**Updated:** 2026-07-20

## Problem

The Waypoint skill family has no meta-skill for writing new skills.
Patterns are learned by reading existing skills, not from a codified reference.
MP has writing-great-skills (a pure reference skill with a failure mode vocabulary and information hierarchy framework).
Waypoint-specific patterns (frontmatter contracts, authority model, phase gates, resolution cascade, single-writer discipline, ACTIVE-WORK.md coordination) are not documented in a skill-consumable format.

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

### D1: Waypoint patterns only
**Decision:** Scope to Waypoint family conventions only.
Reference writing-great-skills for general skill authoring principles.
The skill's intro states: "For general skill authoring principles, see writing-great-skills. This document covers Waypoint family conventions."
**Rationale:** MP's writing-great-skills already covers general principles well.
Duplicating that content doubles the maintenance surface.
The Waypoint family's value comes from its specific patterns, not from restating general principles.
A skill author working in this family either already knows fundamentals or can consult writing-great-skills as a companion.

### D2: Hybrid reference + checklist
**Decision:** Structured reference documenting Waypoint patterns with a terminal validation checklist.
Not a full workflow skill, not a pure reference.
- Reference sections: one per Waypoint pattern, with examples from existing skills
- Terminal checklist: mechanically verifiable items for pre-merge validation
- Usable by both humans (consult reference) and agents (follow checklist)
**Rationale:** Pure reference relies on the author knowing when to look things up.
Full workflow adds overhead for experienced authors.
The hybrid serves both audiences without over-constraining either.

### D3: Pattern catalog with propose-then-correct flow
**Decision:** Codify 8 Waypoint patterns in priority order, with the authoring flow being propose-then-correct:
1. Author describes what the skill does (plain language)
2. Agent proposes frontmatter fields, tone, conventions based on the description and existing family patterns
3. Author corrects the proposal
4. Agent scaffolds the skill with corrected values
5. Terminal checklist validates the result

**Must-codify (high risk of getting wrong):**
1. **Frontmatter contracts** - inputs/outputs/signals format and semantics
2. **Authority model** - /check-in decides, verbs execute; new skills must not be their own authority
3. **LIGHTWEIGHT-REFERENCE.md protocol** - graceful degradation without /project-setup
4. **Single-writer discipline** - only /wrapup writes to shared docs; skills create only their own output artifacts
5. **Shared reference file pattern** - CONTEXT-FORMAT.md, ADR-FORMAT.md, LIGHTWEIGHT-REFERENCE.md consumption

**Should-codify (medium risk):**
6. **AskUserQuestion conventions** - conversational fallback, learn-mode elaboration
7. **Tone definitions** - characteristic tone per skill, avoiding generic assistant tone
8. **Phase gates with regression handling** - relevant when new skill participates in the phase system

**Should-codify (added during README alignment):**
9. **Bridge skill pattern** - when a new skill spans both layers: standalone core loop, project-layer integration points, graceful degradation. Author must decide if their skill is a bridge and declare integration points.
10. **Content vs state writer split** - what the skill is allowed to write: content docs (owned by /wrapup), machine-readable state (per-section ownership in CLAUDE.md), or only its own output artifacts. Critical to get right during authoring.

**Reference only (documented elsewhere):**
11. ACTIVE-WORK.md coordination - runtime protocol, not authoring concern
12. Resolution cascade - documented in README.md, reference don't duplicate

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
- Mechanically checkable: has frontmatter with required fields, references LIGHTWEIGHT-REFERENCE.md, declares signals, plugin.json entry exists
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
- Cross-family compatibility (out of scope for Waypoint-specific reference)
**Rationale:** Publishing is a follow-on concern to authoring, not the core activity.
Light coverage prevents the "I wrote a skill but forgot to register it" failure mode without scope-creeping into infrastructure docs.

### D6: Named /author-skill
**Decision:** The skill is named /author-skill.
**Rationale:** "Author" signals intent and craft, matching the hybrid reference + guided flow.
The two-word form "/author-skill" makes the object explicit even outside the skill family context.
Single-word "/author" was considered but is slightly vague when seen in isolation (author what?).
Consistent with Waypoint verb-oriented naming convention.

## README Alignment

Decisions from the comprehensive README alignment grill.

### U1: Patterns 9-10 integrated into D3
**Decision:** Bridge skill pattern and content-vs-state writer split added to D3's pattern catalog as should-codify items 9 and 10.
Both are authoring-relevant - a skill author needs to know:
- Whether their skill is a bridge (and if so, declare integration points)
- What their skill is allowed to write (content docs, state sections, or only own artifacts)

Pattern 9 references conventions-architecture U2 for the full bridge skill specification.
Pattern 10 references conventions-architecture U1 for the full ownership table.
**Rationale:** The propose-then-correct flow (D3) needs these patterns to make good proposals.
Without bridge awareness, the agent might propose a task-only skill when bridge behavior is appropriate.
Without writer awareness, the agent might propose writing to shared docs that /wrapup owns.
