# Lightweight Reference

Protocol for task-layer skills operating without /project-setup scaffolding.
Every task-layer SKILL.md references this file. When a skill reads it, the skill should
adapt its behavior to the scaffolding state it finds - not just note what's missing.

## Detection

On invocation, determine the scaffolding state:

1. **Full scaffolding** - CLAUDE.md has a Documentation Map section. Resolve all references through the map. No lightweight behavior needed.
2. **Partial scaffolding** - CLAUDE.md exists but no Documentation Map. Check the fallback paths below for individual files. Use what exists, adapt for what doesn't.
3. **No scaffolding** - No CLAUDE.md. Full lightweight mode. The skill works on its own strengths.

## Fallback paths

When no Documentation Map exists, check these locations:

| Concept | Path | What it gives the skill |
|---------|------|------------------------|
| Domain glossary | CONTEXT.md | Term validation, glossary challenges, domain-aware naming |
| Naming conventions | CONVENTIONS.md | Pattern enforcement, naming suggestions |
| Scope boundaries | SCOPE.md | In/out checks, scope cross-referencing |
| Test expectations | TESTING.md | Project-specific test philosophy |
| Architecture overview | ARCHITECTURE.md | Architecture cross-referencing, ADR context |
| Architecture decisions | docs/adr/ | Existing decision cross-referencing |
| Skill state | .claude/ | Marker files, setup-prompted flag |

## How skills adapt

When a file is missing, the skill doesn't just lose a feature - it actively substitutes.
The substitution depends on what kind of skill is running.

### Grilling skills (/spec, /grill-me, /grill-with-docs)

**Without CONTEXT.md:**
- Skip glossary challenges ("your glossary defines X as Y, but you said Z")
- Instead, pay extra attention to ambiguous terms in what the user says. When a term could mean two things, ask: "You said 'account' - do you mean the billing entity or the user login? I'd usually cross-check against a domain glossary, but there isn't one yet."
- If new terms are resolved during the grill, offer to create CONTEXT.md: "We just defined 3 domain terms. Want me to start a CONTEXT.md?"

**Without SCOPE.md:**
- Skip scope boundary checks ("is this feature in scope?")
- Instead, ask scope questions inline: "Is this feature in your v1, or is it a future enhancement?"
- Don't assume scope - ask directly where you'd normally cross-reference.

**Without CONVENTIONS.md:**
- Skip naming enforcement
- Instead, infer conventions from existing code: "I see your composables use `useXxx` and your stores use `xxxStore`. I'll follow that pattern."
- State what you inferred so the user can correct it.

### Implementation skills (/tdd, /port)

**Without TESTING.md:**
- Use the default testing philosophy: integration-style tests through public interfaces.
- State the assumption: "No TESTING.md found. Defaulting to integration-style tests through public interfaces. If your project prefers a different approach, let me know."

**Without CONVENTIONS.md:**
- Read the surrounding code to infer naming patterns.
- State inferences in the implementation plan: "Following the naming pattern I see in existing files: `useXxx` for composables, `XxxView` for views."

**Without ARCHITECTURE.md or docs/adr/:**
- Don't cross-reference architecture decisions.
- If the implementation involves an architectural choice, flag it: "This touches state management. Normally I'd check your ADRs, but none exist. I'll use the pattern I see in the nearest existing code."

### Diagnostic skills (/diagnose, /improve-codebase-architecture)

**Without CONTEXT.md:**
- Use code identifiers as-is, don't map them to domain terms.
- When explaining the root cause, define terms inline instead of linking to the glossary.

**Without docs/adr/:**
- When /improve-codebase-architecture finds a refactoring candidate that might contradict a past decision, it can't check. Flag it: "This refactoring might reverse a deliberate decision. No ADRs exist to check against - confirm this is intentional."

### Learning skills (/learn)

**Without CONTEXT.md:**
- In the Terms in play block, skip the "link to CONTEXT.md" step.
- Define domain terms inline and move on.
- Skip the "append to CONTEXT.md" step in Phase 4.

## First-invocation notice

On first-ever invocation in a project without scaffolding:

```
Tip: run /project-setup for domain-aware grilling and convention enforcement.
```

### Marker file

Write `.claude/.setup-prompted` after showing the notice.
If `.claude/` doesn't exist, create it.
If the marker exists, never show the notice again.

Content doesn't matter (write the date for debugging), only existence is checked.

## Lazy creation

Skills create only their own output artifacts, never another skill's scaffolding.

| Skill | Creates (its own output) | Does NOT create |
|-------|--------------------------|-----------------|
| /spec | docs/implementation/specs/{slug}.md | SCOPE.md, CONVENTIONS.md |
| /grill-with-docs | CONTEXT.md, docs/adr/ | CONVENTIONS.md, SCOPE.md |
| /tdd | Test files, implementation files | TESTING.md |
| /diagnose | Fix files | Any scaffolding |
| /learn | docs/local/learning/ | Any scaffolding |

Exception: /grill-with-docs creates CONTEXT.md and docs/adr/ because those ARE its direct outputs. After creating one, add an inline note:

```
Created CONTEXT.md with 3 domain terms from this session.
Run /project-setup to build the full docs tree.
```

## What skills should NOT do

- Don't block on missing scaffolding. Every skill has a core loop that works without it.
- Don't repeatedly mention what's missing. State it once (in the adaptation), then move on.
- Don't prompt for /project-setup more than once (the marker file prevents this).
- Don't create scaffolding files that belong to /project-setup. Flag what would be useful, let the user decide.
- Don't degrade silently. When you skip a check you'd normally do, say what you skipped and what you did instead, in one sentence.
