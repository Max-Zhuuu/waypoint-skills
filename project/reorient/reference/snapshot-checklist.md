### What to read

1. **CONCERNS.md.** Count by type and status. Note anything open > 2 weeks.
   If no CONCERNS.md exists, note that - it is a finding for Phase 3.
2. **Tracking docs.** Inventory, migration status, PAGES, roadmap. Count items by status.
   If no formal tracker exists, note that too.
3. **Recent git history.** `git log --oneline -30`.
   Categorize each commit into an axis: architecture, wiring/integration, design/UI, bugfix, docs, tests, chore.
   Identify which axes got attention and which did not.
4. **Test health.** Run the test suite (or check the most recent run).
