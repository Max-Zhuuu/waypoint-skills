---
name: create
description: Add features to an existing codebase. Lighter than /buildout, structured enough to ensure specs exist and docs stay current. Use when adding a feature or small batch of features to a project that already has docs and conventions.
disable-model-invocation: true
inputs:
  scope-md: SCOPE.md (project context)
  conventions-md: CONVENTIONS.md (naming patterns)
  context-md: CONTEXT.md (domain glossary)
outputs:
  workflow-record: CLAUDE.md ## Active Workflow section updated
  specs: feature specs for each feature via /spec
  built-features: implemented via chosen verb
signals:
  complete: suggests /wrapup
---

# Create

Add features to an existing codebase. No phases, no inventory, no MoSCoW.
Structured enough to ensure specs exist before building and docs get updated after.

## When to use

- Adding a feature or small batch of related features to an existing project
- The project already has SCOPE.md, CONVENTIONS.md, and a docs structure (from /project-setup or equivalent)
- You know roughly what you want to build

## When NOT to use - recommend alternatives

- **No project docs exist:** recommend /project-setup first
- **Replacing an existing system layer by layer:** recommend /migrate (parity tracking, inventory, phased cutover)
- **Building a new product from scratch with unknown scope:** recommend /buildout (MoSCoW prioritization, MVP-first, feedback rounds)
- **Scope is large (5+ features needing architecture decisions):** recommend /buildout - /create doesn't have gates to catch architectural drift at that scale

Print the recommendation with a plain-language explanation of why, not just the skill name.

## On invocation

1. Read existing project docs: SCOPE.md, CONVENTIONS.md, CONTEXT.md, TESTING.md, CLAUDE.md.
2. Check for `## Active Workflow` in CLAUDE.md:
   - **Same skill already active** (/create in progress): don't restart. Ask what feature to add next, or suggest `/check-in` to orient.
   - **Different skill active** (/migrate or /buildout in progress): warn that starting /create runs alongside that workflow, not inside it. Ask whether to proceed or fold this feature into the active workflow.
   - **Completed workflow** (Status: completed): clear automatically and proceed.

3. Write the workflow record to CLAUDE.md (see Workflow Record below).
4. Ask what the user wants to build. Inline grill - not AskUserQuestion. Keep it conversational:

```
What are you adding?
  - What does it do? (one sentence)
  - Who uses it?
  - What existing parts of the system does it touch?
```

5. If the user describes multiple features, group them. If the group is large (5+), recommend /buildout.

## Process

### Per feature

1. **Spec:** invoke /spec. If a spec already exists for this entity, read it and ask whether to update or start fresh.
2. **Build:** invoke the user's chosen implementation verb (/tdd default). If the user has a methodology preference from a previous /check-in, use that.
3. **Wrapup:** suggest /wrapup when the verb reports complete. /wrapup runs the spec drift check, resolves flags, cascades to shared docs.

### After all features

```
{N} features complete. /wrapup resolved flags across {files}.
Updated SCOPE.md with new capabilities.

Workflow record cleared. Next session: /check-in to orient.
```

Clear the Active Workflow section from CLAUDE.md (or mark as completed with date).

## Workflow Record

On invocation, write or update the `## Active Workflow` section in CLAUDE.md:

```markdown
## Active Workflow

| Field | Value |
|-------|-------|
| Skill | /create |
| Activated | {date} |
| Scope | {one-line description of what's being added} |
| Features | {list of feature names, updated as specs are written} |
| Status | in progress |
```

/check-in reads this section to know what workflow is active and orient accordingly.
When /create completes, update Status to `completed ({date})`.

## Tone

Lightweight. This is the daily driver for "I need to add something."
Don't impose ceremony the scope doesn't warrant.
