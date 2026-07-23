---
name: create
description: Add features to an existing codebase. Lighter than /buildout, structured enough to ensure specs exist and docs stay current. Use when adding a feature or small batch of features to a project that already has docs and conventions.
status: stable
inputs:
  scope-md: SCOPE.md (project context)
  conventions-md: CONVENTIONS.md (naming patterns)
  context-md: GLOSSARY.md (domain glossary)
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
- The project already has SCOPE.md, CONVENTIONS.md, and a docs structure (from /setup or equivalent)
- You know roughly what you want to build

## When NOT to use - recommend alternatives

- **No project docs exist:** recommend /setup first
- **Replacing an existing system layer by layer:** recommend /migrate (parity tracking, inventory, phased cutover)
- **Building a new product from scratch with unknown scope:** recommend /buildout (MoSCoW prioritization, MVP-first, feedback rounds)
- **Scope is large (5+ features needing architecture decisions):** recommend /buildout - /create doesn't have gates to catch architectural drift at that scale

Print the recommendation with a plain-language explanation of why, not just the skill name.

## On invocation

1. Read existing project docs: SCOPE.md, CONVENTIONS.md, GLOSSARY.md, TESTING.md, CLAUDE.md.
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

## Local docs

/create does not eagerly scaffold docs/local/.
When a question, assumption, or cross-boundary issue surfaces during work, create the relevant file using the format in [setup/LOCAL-DOCS-REFERENCE.md](../../project/setup/LOCAL-DOCS-REFERENCE.md).
If the file already exists, append to it.

## Process

### Per feature

1. **Spec:** invoke /spec. If a spec already exists for this entity, read it and ask whether to update or start fresh.
2. **Build:** invoke the user's chosen implementation verb (/tdd default). If the user has a methodology preference from a previous /check-in, use that.
3. **Before committing:** follow the exit protocol (see [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) section 6). At natural boundaries, ask "Stable or provisional?" If the build verb is /tdd, it handles per-commit exit protocol internally.
4. **Wrapup:** suggest /wrapup when the verb reports complete. /wrapup runs the spec drift check, resolves flags, cascades to shared docs.

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

## Bridge behavior

/create is a bridge skill: works as a single-session orchestrator by default, but can write an Active Workflow record for multi-session features.

**Task-layer mode (default):** user describes a feature, /create sequences spec -> build -> wrapup in one session. No Active Workflow record needed.

**Project-layer mode:** when the feature is large enough to span sessions, /create writes the Active Workflow record (step 3 in On invocation). /check-in picks it up next session.

The user doesn't choose the mode explicitly - /create writes the workflow record by default (step 3). If the work completes in one session, the record is cleared at the end. If the user leaves mid-feature, /check-in finds the record and continues.

**Without scaffolding:** core orchestration loop works (spec -> build -> wrapup). No SCOPE.md cross-referencing, no convention enforcement. Workflow record still written to CLAUDE.md if the file exists.

## Engagement

See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.

- **Emits:** concerns (type: issue, question)
- **Scaffolding writes:** none (task-layer skill)
- **Override:** commit-producing skill - follows exit protocol (ENGAGEMENT-REFERENCE.md section 6)
- **Nudge protocol:** detect tier -> suggest setup/upgrade once -> back off if declined
- **Concern format:** `### C-NNN [open] <summary>` with type, raised date, source skill
- **Prohibitions:** no file creation outside owned paths, no silent scaffolding, no tier-skipping
- **Before writing** to shared-append or owned files, check Claims in CONCERNS.md

## Tone

Lightweight. This is the daily driver for "I need to add something."
Don't impose ceremony the scope doesn't warrant.
