## Bridge behavior

/create is a bridge skill: works as a single-session orchestrator by default, but can write an Active Workflow record for multi-session features.

**Task-layer mode (default):** user describes a feature, /create sequences spec -> build -> wrapup in one session. No Active Workflow record needed.

**Project-layer mode:** when the feature is large enough to span sessions, /create writes the Active Workflow record (step 3 in On invocation). /check-in picks it up next session.

The user doesn't choose the mode explicitly - /create writes the workflow record by default (step 3). If the work completes in one session, the record is cleared at the end. If the user leaves mid-feature, /check-in finds the record and continues.

When the feature crosses the method-selection signal (more than ~5 files or more than one domain, or it plainly spans sessions), recommend project-layer mode explicitly and say why, rather than leaving it implicit: cite the file/domain count as the reason (see [method selection](../../../process/method-selection.md)). Below that signal, the default single-session task-layer mode is the lighter method and needs no ceremony.

**Without scaffolding:** core orchestration loop works (spec -> build -> wrapup). No SCOPE.md cross-referencing, no convention enforcement. Workflow record still written to CLAUDE.md if the file exists.
