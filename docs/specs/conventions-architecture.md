# Conventions Architecture

**Status:** Draft - grilling not started
**Created:** 2026-07-20
**Updated:** 2026-07-20
**Origin:** Discovered during issue-tracker-integration grilling (Q4/D8)

## Problem

CONVENTIONS.md is a single file that covers naming patterns.
As the MZ skill family grows, project conventions expand beyond naming: decomposition preferences, testing philosophy, review standards, documentation structure.
A single file becomes overloaded for large projects.

The current shared reference file pattern (CONTEXT.md, CONVENTIONS.md, SCOPE.md, TESTING.md) treats each as a standalone document.
Some of these are really convention subtypes that could live under a unified conventions structure.

## Context

- Lightweight-entry-points spec (D6) defines a degradation table per missing artifact
- /project-setup Phase 1 scaffolds these files during initial setup
- CLAUDE.md references them early so agents pick them up
- Small projects may not need the folder structure - single files are fine

## Open Questions

### Q1: Folder vs flat
Should conventions be a folder (`conventions/` or `docs/conventions/`) with subtype files, or stay as separate root-level files?
If folder: what's the migration path for existing projects with a flat CONVENTIONS.md?

### Q2: Which files merge into conventions
Candidates for consolidation under a conventions umbrella:
- CONVENTIONS.md (naming patterns) -> conventions/naming.md
- TESTING.md (test expectations) -> conventions/testing.md
- New: conventions/decomposition.md (work breakdown preferences)
- New: conventions/review.md (code review standards)
CONTEXT.md, SCOPE.md, ARCHITECTURE.md probably stay separate - they're not conventions.

### Q3: Small project vs large project threshold
When does a project need the folder structure vs. a single CONVENTIONS.md?
Options: always folder, always flat with sections, auto-detect by project size, user choice during /project-setup.

### Q4: Impact on LIGHTWEIGHT.md degradation table
The lightweight-entry-points D6 degradation table checks for specific files.
A conventions folder changes what "CONVENTIONS.md is missing" means.
How does detection logic adapt?

### Q5: Impact on CLAUDE.md references
CLAUDE.md currently points to specific files.
A conventions folder changes the reference pattern.
Should CLAUDE.md reference the folder, or individual files within it?
