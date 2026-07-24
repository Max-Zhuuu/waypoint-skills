# Restructuring Reference

Read by /setup when the user explicitly asks to restructure, or docs exist but don't follow the three-tier layout.
Read the current Documentation Map from CLAUDE.md, classify each file by tier, and propose moves.

## File classification rules

Classify every doc file by asking: "Does this describe what the system IS, or what we're DOING to it?"

**program/** - what the system IS (changes rarely):
- Architecture, stack decisions, data flow diagrams
- Test policy and expectations
- Naming conventions, UX conventions, design tokens
- ADRs (architecture decision records)
- Feature docs for the TARGET system being built
- Design system docs (DESIGN.md)

**program-legacy-{source}/** - source system reference (migration projects):
- Feature specs FROM the source system (WPF screens, Rails views, etc.)
- Logic docs, business rules extracted from source
- Plugin inventories, entity catalogs from the source system
- Templates for documenting the source system

**implementation/** - what we're DOING (changes often):
- Scope (in/out/uncertain)
- Concerns (questions, assumptions, issues, milestones)
- Feature specs for work IN PROGRESS (specs/)
- Migration trackers, progress trackers (PAGES.md, FE-UPDATES.md)
- Handoffs, cross-team contracts
- Improvement proposals (deferred ideas)
- Backend integration notes, endpoint specs
- Archive of superseded docs

**local/** - working state (gitignored):
- Session notes, investigations, scratch
- Learning exercises

## Content merge rules

Not every file is a simple move. When restructuring, check for:
- **Merge candidates**: small files (<60 lines) whose content is a natural section of a larger doc. Example: DEPENDENCIES.md becomes `## External Dependencies` in ARCHITECTURE.md.
- **Split candidates**: files covering multiple concerns. Example: CONVENTIONS.md splits into conventions/NAMING.md + conventions/UX.md.
- **Distribute candidates**: directories where files belong in different tiers. Example: design/ may have system-level design rules (program/DESIGN.md), API design docs (program/), and exploration files (implementation/improvements/ui/).
- **Delete candidates**: files replaced by the Documentation Map or by other structural changes. Example: docs/README.md that just lists what's in docs/.

## Restructure flow

```
Current layout doesn't match the program/implementation/local structure.

Classification:
  program/:      ARCHITECTURE.md, TESTING.md, adr/, NAMING.md
  legacy-wpf/:   wpf-reference/*, inventory-plugins.md
  implementation/: SCOPE.md, PAGES.md, specs/, improvements/
  merge:         DEPENDENCIES.md -> ARCHITECTURE.md section
  split:         CONVENTIONS.md -> conventions/NAMING.md + UX.md
  delete:        docs/README.md (Documentation Map replaces it)

Proposed moves:
  git mv docs/wpf-reference/ docs/program-legacy-wpf/
  git mv TESTING.md docs/program/TESTING.md
  ...
{N} moves total. Execute, or adjust?
```

Use `git mv` for all moves to preserve history. Create directories first, move in dependency order. After moves, rewrite the Documentation Map in CLAUDE.md to match new paths.
