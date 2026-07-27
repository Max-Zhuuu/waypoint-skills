# What /review checks

Two kinds of "is this good," kept apart. Never merge them into one score.

## Standards - always

Does the code follow portable good-practice categories, plus this project's own conventions?
This is `/review`'s job on every run.

Portable categories (the default lens sweeps all of them):

- **auth** - authn/authz boundaries, session handling, privilege checks.
- **security** - input validation, injection surfaces, secret handling.
- **data handling** - persistence, migrations, serialization, PII.
- **operations** - logging, error surfacing, retries, observability. For critical paths: can you debug this in production without deploying new instrumentation? If the project defines SLIs (ARCHITECTURE.md or SLOs.md), check that modified paths have corresponding spans or structured events.
- **architecture** - module boundaries, coupling, testability seams.
- **theming** - design-token use, no hard-coded style values.
- **internationalization** - no hard-coded user-facing strings, locale-safe formatting.

A persona is a weighting over these categories, not a new axis: a named lens (`architect`, `creative-director`, or one you author) leans the same sweep toward the failure modes it cares about, while the default lens sweeps them evenly. A lens changes emphasis; a recorded finding still carries one of the fixed category names, so the vocabulary that crosses into a concern never changes (see [personas.md](personas.md) and [persona-grill.md](persona-grill.md)).

Project conventions come from the Documentation Map: read CONVENTIONS.md / NAMING.md / UX.md and DESIGN-SYSTEM.md when they exist, and check the diff against them.
A finding's category is one of the fixed names above, or a project-convention id that resolves to an existing entry in the convention docs and matches a fixed id token (for example `NAMING-03`); only the resolved token crosses, never a repo-authored free-text string, and if none resolves the finding falls back to a standards category. That is what keeps a recorded concern a pointer ([review-safety.md](../../../internals/engagement/review-safety.md), crossing 1).

## Intent - only when nobody downstream will

Does the change match the spec it was built from?

Normally the delivery pipeline's own reviewer checks spec-versus-diff after the PR opens, so `/review` does not duplicate it.
Resolve DEPLOY.md's adapter: when it names a remote pipeline (`github-pipeline`, or `other` with a documented authority), skip the Intent pass and let the pipeline own it.
When the adapter is `local`, or there is no DEPLOY.md, nobody downstream will check intent, so `/review` runs the Intent pass too: trace each slice to its acceptance criterion, spec-derived (never grade the diff against itself).

State which mode ran in the findings note, so the reader knows whether intent was checked here or deferred to the pipeline.
