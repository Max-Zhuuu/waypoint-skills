# Convention enforcement

How to create and verify convention tests. Conventions enforced by tests that fail on drift - not just documentation.

## Convention test taxonomy

**Structure tests** - verify file placement matches the project's canonical taxonomy. Read the directory layout from CONVENTIONS.md or ARCHITECTURE.md, assert every source file sits in the correct bucket. Catches misplaced files before they accumulate.

**Import tests** - no cross-domain imports outside barrel files, no circular dependencies. Parse import statements statically. Each domain folder exports through its barrel `index.ts` (or equivalent); imports that bypass it are violations.

**Contract parity tests** - generated files match their source of truth. Hash the source (Pydantic models, OpenAPI spec, schema.json), hash the generated output, fail when they diverge. Drift means someone hand-edited a generated file or forgot to re-run codegen.

**Scope coverage tests** - every "in" endpoint in the endpoint registry has a corresponding route or handler. Parse `contracts/*-endpoints.json`, collect entries with `"status": "in"`, assert each maps to a registered route.

**Auth coverage tests** - every registered route has auth enforcement. Read function builders or route registrations programmatically (not source text grep). Assert total route count matches expected and every non-public route has the auth decorator or middleware.

**Convention drift tests** - naming patterns, file naming, export conventions. Parse the project's NAMING.md, derive rules (component prefix, file casing, function naming), scan source files for violations.

**Error envelope tests** - every error response matches the project's error schema. In integration tests, assert all non-2xx responses conform to the declared error shape (e.g., `{type, status, title}` or `{error, status, code?}`).

**Route collision tests** - no two routes match the same URL at the same HTTP method and depth. Register all routes, check for overlapping patterns. Wildcards that shadow literals are violations.

**Write envelope tests** - every mutation endpoint (POST/PUT/DELETE) returns the project's write envelope shape (e.g., `{record, affected}`). Run against integration test responses.

**No-leak assertions** - error responses never contain internal file paths, stack traces, or connection strings. Regex scan every error response body in the test suite for path separators, `Traceback`, `.py:`, `at Object.`, etc.

## How to create convention tests

1. Read the project's convention docs (CONVENTIONS.md, NAMING.md, API.md, TESTING.md, STRUCTURE.md).
2. Each section becomes a test case or test file. One convention = one test.
3. Tests emit structured output: `rule_id`, `severity`, `file`, `line`, `message`, `fix_hint`.
4. Register at execution tier: T0 (on save, <2s), T1 (pre-commit, <20s), T2 (CI on PR, <8min), T3 (nightly, unbounded).
5. Prefer elimination over enforcement: codegen and chokepoints beat lint rules. If you can generate the correct output, don't test whether someone wrote it correctly.
6. When a convention has no test: either write one or record a waiver with reason, owner, and expiry (max 90 days).

## Ratchet patterns

- **Coverage ratchets**: store current metric in a ratchet file, fail only on regression. Example: `echo 87 > .ratchets/test-coverage`.
- **Violation ratchets**: store current ceiling, fail only when exceeded. Example: `echo 12 > .ratchets/any-casts`.
- Ratchets move one direction only. No manual increases without an ADR.
- Custom merge driver for ratchet files: always take the stricter (lower violation, higher coverage) number. Prevents merge conflicts from resetting progress.
- Ratchet file format: plain text, one number per line, committed to repo.

## Hook-based enforcement

`.claude/settings.json` hooks are the delivery mechanism for agent-specific rules:

- **UserPromptSubmit**: load unresolved CONCERNS.md section so the agent always has current context.
- **PreToolUse (Bash/PowerShell)**: commit gates (only agent's files staged), push guards (build must pass), branch protection (no direct push to main/beta).
- **PostToolUse (Edit/Write)**: doc-sync reminders when related files change (edit a Vue screen -> remind to update the feature spec).
- **Deny lists** in `.claude/settings.local.json`: hard bans on destructive operations (`az *`, `git reset`, `git rebase`, `--rebase`).

When `/setup` scaffolds a project, offer to configure hooks derived from the project's conventions.
