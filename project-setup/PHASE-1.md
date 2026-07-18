# Phase 1 - Architecture & Standards

Read by `/project-setup` when Phase 1 work is needed.

## Architecture decisions

Invoke `/grill-with-docs` for each decision that meets the ADR threshold (hard to reverse, surprising without context, real trade-off). For obvious stack choices that don't warrant an ADR, document them in ARCHITECTURE.md directly.

Decisions to make (adapt to the project):

1. **Component architecture** - layout patterns, view composition, shared vs local components
2. **State management** - store vs composable/hook vs component-local vs URL state
3. **Data fetching** - where fetch calls live, caching, loading/error/empty states
4. **Routing** - URL structure, navigation model, deep links
5. **Styling** - tokens/variables, component styling approach, responsive strategy
6. **Testing** - layers, minimum bar, structural enforcement
7. **Error handling** - user-facing errors, logging, recovery
8. **Mock data strategy** - structure, location, replacement path to real API

## Naming conventions

Generate a `CONVENTIONS.md` at the repo root. Seed it with framework-level defaults the project inherits (e.g., PascalCase components, `use` prefix for composables, camelCase functions). For migrations, note which legacy naming patterns to mirror and which to deliberately break from.

Keep it short - one line per convention. This file grows during Phase 3 (vertical slice or MVP build) when real patterns emerge from actual code. Example:

```markdown
# Naming Conventions

## Functions
- API calls: `fetchX` (not `getX`, `loadX`, `retrieveX`)
- Event handlers: `onX` in templates, `handleX` in script
- Boolean returns: `isX`, `hasX`, `canX`

## Components
- Route views: `XPage` (not `XView`, `XScreen`)
- Composables: `useX` (returns reactive state), `createX` (returns plain object)

## Types
- Interfaces: no `I` prefix
- Enums: PascalCase singular (`Status`, not `Statuses`)
```

Add one line to the generated CLAUDE.md: `When writing new code or reviewing naming patterns, read CONVENTIONS.md.`

## UI pattern library

Enumerate the recurring UI patterns the project will use. Each pattern gets:
- A name (list view, detail card, form layout, tabbed container, etc.)
- A brief contract (what props/data it expects, what it renders)
- Which architecture decisions it depends on

These patterns are validated in Phase 3 (vertical slice) if running `/migrate`.

## Testing template

Generate a `TESTING.md` at the repo root. Seed with test expectations by complexity tier. One example per pattern type:

- **Smoke test** - does it render without crashing?
- **Structural enforcement** - do conventions hold across the codebase?
- **Characterization / golden master** (migration) - does the new system match the old?
- **Integration workflow** - does a multi-step user flow work end-to-end?

Keep it short. This file is refined during Phase 3 (vertical slice or MVP build) when real test patterns emerge from actual code.

Add one line to the generated CLAUDE.md: `When writing tests, read TESTING.md for patterns and expectations.`

## Documentation structure

Create this tree (adapt to the project). The `docs/local/` structure scales with the project intake profile:

```
docs/
  SCOPE.md
  DEPENDENCIES.md
  ARCHITECTURE.md
  adr/                        # ADRs via /grill-with-docs
  design/                     # Design system docs (created during 6b-i)
  reference/
    features/
      _TEMPLATE.md            # Feature spec template
    logic/
      _TEMPLATE.md            # Logic doc template
  specs/                      # Feature specs via /spec
  improvements/               # UX improvement ideas (capture, don't implement)
  local/                      # Gitignored - scale by intake profile
    ACTIVE-WORK.md            # [all] Concurrent agent tracker
    QUESTIONS.md              # [all] Unresolved issues needing human input
    ASSUMPTIONS.md            # [product, feature] Working assumptions
    PROGRESS-AUDIT.md         # [product, feature] /reorient output
    learning/                 # [product] /learn output
    handoffs/                 # [product, feature] Cross-team requests
      api-contracts/          # Tier 2: endpoint requests, data contracts
      schema-changes/         # Tier 3: DB migrations, business rule changes
    design-journal.md         # [product w/ full design] Tagged experiment history
```

Scale by intake profile:
- **Product**: full structure above
- **Feature**: drop learning/, keep rest
- **Deliverable**: QUESTIONS.md and ACTIVE-WORK.md only

## Spec templates

Generate two templates grilled to the project's needs.

**docs/reference/features/_TEMPLATE.md** - adapt sections based on stack:
- Overview (one paragraph: what this screen does)
- Fields & Controls (table: field, type, source, editable, default)
- Interaction Behaviors (table: control, behavior, notes - e.g., sortable, resizable, filterable)
- Conditional Visibility (what shows/hides based on state)
- Toolbar/Navigation Actions (buttons, links, what they do)
- Navigation (how user gets here, where they can go)
- Validation Rules
- Change Log

**docs/reference/logic/_TEMPLATE.md**:
- Data Model (fields, types, nullability)
- Relationships (to other entities)
- Status Lifecycle (state machine if applicable)
- Business Rules
- Calculated Fields
- Edge Cases
- Known Bugs / Quirks
- Change Log

## CLAUDE.md generation

Generate the project's CLAUDE.md with these sections (each concise):

### Repository Overview
One paragraph: what this project is.

### Development
Commands to install, run, build, test.

### Project Structure
Directory tree with one-line descriptions.

### Branch Workflow
Document the tier structure. Example:
- `main` - production, protected
- `preview` - staging/QA
- `beta` - integration testing
- Feature branches off `beta`, merged back via PR

### Design Exploration Policy
Isolated design experimentation is allowed on separate branches (worktree or design branch) that do not tie into production components. Guardrails:
- Time-boxed: set a limit before starting, stop when it hits
- Critically questioned: is this for user benefit and grounded in domain truth, or just modern UX cloning that doesn't respect the domain?
- Captured: if the experiment validates, write it up in `docs/improvements/` before integrating
- Periodically merge parent branch to keep docs and domain knowledge current on the design branch

### Design Archival
Before each new design direction, tag the current state:
```
git tag design/{nn}-{slug}
```
After tagging, add a journal entry in `docs/local/design-journal.md`:
```
## {date} - {what you explored}
### design/{nn}-{slug}
{One sentence: what this variant does differently}
{One sentence: why it was chosen or rejected}
Screenshot: {path or inline}
```
Tags are diff-able (`git diff design/01..design/02`), restorable (`git checkout design/01`), and survive indefinitely. The journal tracks reasoning; tags preserve the running code.

### Agent Coordination
- Task brief template: What, Files claimed, Inputs, Output, Model (Sonnet for mechanical / Opus for judgment), Constraints
- When to use workflows vs parallel agents vs inline subagents
- Concurrent agent protocol (ACTIVE-WORK tracker, file claiming, stale entry policy)

### Change Protocol
1. When a dependency changes: update spec first, then code. Never code without updating spec.
2. When scope changes: update SCOPE.md, update inventory, ADR if significant.
3. When updating a spec: add entry to the Change Log section at bottom (date + one-liner).

### Enforcement
Identify which rules need hooks (deterministic enforcement) vs CLAUDE.md (advisory):
- Hooks: branch protection, test-before-push, forbidden file patterns
- Advisory: template compliance, brief format, documentation currency

Generate project-specific hooks where identified.
