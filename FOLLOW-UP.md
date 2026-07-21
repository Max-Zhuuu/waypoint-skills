# Follow-up: Substrate-First Architecture

Non-interrupting cleanup and completion items after the initial restructure.

## Cleanup

- [x] Update all skill SKILL.md files to reference ENGAGEMENT-REFERENCE.md instead of LIGHTWEIGHT-REFERENCE.md
- [x] Remove LIGHTWEIGHT-REFERENCE.md after all references are updated
- [x] Update CONCEPTS-REFERENCE.md to reflect ENGAGEMENT-REFERENCE.md references
- [x] Update /check-in SKILL.md - simplify against Concerns (read + prioritize, drop 5-layer stack)
- [x] Update /wrapup SKILL.md - resolve concerns by entity instead of flags-in-spec pattern
- [x] Update /reorient SKILL.md - emit flags to Concerns instead of writing PROGRESS-AUDIT.md
- [x] Update /setup SKILL.md - reframe as optional deepening, seeds initial concerns
- [x] Review /migrate and /buildout phase files for Concerns integration
- [x] Update setup/LOCAL-DOCS-REFERENCE.md to reflect CONCERNS.md replacing the four-file pattern

## Process extraction (remaining skills)

- [x] /diagnose - process/debugging.md + adapter
- [x] /spec - process/requirements.md + adapter
- [x] /tdd - process/tdd.md + adapter (supporting docs stay in tdd/ as implementation reference)
- [x] /improve-codebase-architecture - process/architecture-review.md + adapter
- [x] /learn - process/learning.md + adapter
- [x] /grill-me - evaluated: 13-line instruction, not a methodology. No process doc needed.
- [x] /prototype - evaluated: three branches are agent-specific execution. Principle is one sentence, not a document.

## Validation

- [x] Write tool adapters for /diagnose to prove the multi-tool story (Cursor .mdc, OpenCode skill, Codex AGENTS.md)
- [ ] Test CONCERNS.md format in a second project (beyond bv-glomaris)
- [ ] Pressure-test Tier 2 nudge behavior in a real skill session
