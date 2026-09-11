---
name: create
description: "Add features to an existing codebase. Ensures specs exist and docs stay current. Lighter than /buildout."
status: deprecated
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

> **Deprecated.** Use `/triage` -> `/spec` -> `/breakdown` -> `/tdd` workflow instead.

Add features to an existing codebase. No phases, no inventory, no MoSCoW.
Structured enough to ensure specs exist before building and docs get updated after.

If this request doesn't fit /create, see [reference/when-not-to-use.md](reference/when-not-to-use.md) and recommend the matching alternative instead of proceeding.

1. Read existing project docs: SCOPE.md, CONVENTIONS.md, GLOSSARY.md, TESTING.md, CLAUDE.md.
2. Check for `## Active Workflow` in CLAUDE.md:
   - **Same skill already active** (/create in progress): don't restart. Ask what feature to add next, or suggest `/check-in` to orient.
   - **Different skill active** (/migrate or /buildout in progress): warn that starting /create runs alongside that workflow, not inside it. Ask whether to proceed or fold this feature into the active workflow.
   - **Completed workflow** (Status: completed): clear automatically and proceed.

3. Write the workflow record to CLAUDE.md. Use the template in [reference/workflow-record.md](reference/workflow-record.md); see [reference/bridge-behavior.md](reference/bridge-behavior.md) for when this stays task-layer (single session, no record needed) versus project-layer (record written, /check-in picks it up).
4. Ask what the user wants to build. Inline grill - not AskUserQuestion. Keep it conversational:

```
What are you adding?
  - What does it do? (one sentence)
  - Who uses it?
  - What existing parts of the system does it touch?
```

5. If the user describes multiple features, group them. If the group is large (5+), recommend /buildout.

## Local docs

/create does not eagerly scaffold docs/_local/.
When a question, assumption, or cross-boundary issue surfaces during work, create the relevant file using the format in [setup/reference/local-docs.md](../../project/setup/reference/local-docs.md).
If the file already exists, append to it.

## Process

### Per feature

1. **Spec:** invoke /spec. If a spec already exists for this entity, read it and ask whether to update or start fresh.
2. **Build:** invoke the user's chosen implementation verb (/tdd default). If the user has a methodology preference from a previous /check-in, use that.
3. **Before committing:** follow the exit protocol (see [the engagement protocol](../../internals/engagement/README.md) section 6). At natural boundaries, ask "Stable or provisional?" If the build verb is /tdd, it handles per-commit exit protocol internally.
4. **Wrapup:** suggest /wrapup when the verb reports complete. /wrapup runs the spec drift check, resolves flags, cascades to shared docs.

### After all features

```
{N} features complete. /wrapup resolved flags across {files}.
Updated SCOPE.md with new capabilities.

Workflow record cleared. Next session: /check-in to orient.
```

Clear the Active Workflow section from CLAUDE.md (or mark as completed with date).

## Exit

- /tdd to build slices with tests.
- /wrapup to resolve concerns and cascade docs.

Does NOT scaffold project infrastructure (use /setup) or decompose (use /breakdown first).
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#13-exit-sequence).

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: concerns (type: issue, question)
Writes: the Active Workflow record in CLAUDE.md (written on start, cleared on completion); `docs/_local/` notes as questions surface (gitignored). Specs and built features are delegated to /spec and the build verb.
Override: commit-producing skill - follows exit protocol (engagement/README.md section 6)
## Tone

Lightweight. This is the daily driver for "I need to add something."
Don't impose ceremony the scope doesn't warrant.
