Check for these files. Presence/absence only - don't read contents beyond frontmatter or first heading.

| Check | What it tells you |
|-------|-------------------|
| CLAUDE.md `## Active Workflow` | Mid-project. Which workflow, which phase. |
| CONCERNS.md | Tracking is active. Grep for items matching the user's topic. |
| SCOPE.md frontmatter | Project exists with defined boundaries. |
| GLOSSARY.md first heading | Domain glossary exists. |
| CLAUDE.md ## Conventions | Coding standards exist. |
| CLAUDE.md ## Testing | Test strategy exists. |
| {DOCS}/specs/ | Feature specs exist. Check if one matches the user's topic. |
| docs/adr/ | Architecture decisions on record. |

Summarize as a one-line project read:
- "No project setup" (none of the above exist)
- "Project setup, no active workflow" (docs exist, no Active Workflow)
- "Mid-workflow: Phase 5 of /migrate" (Active Workflow found)
- "Mature project with concerns tracking" (CONCERNS.md + multiple docs)
