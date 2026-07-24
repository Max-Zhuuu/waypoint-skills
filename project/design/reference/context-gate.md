# Context Gate

This skill requires project context. Before proceeding, check for:

1. `SCOPE.md` - what the product is, its boundaries
2. `GLOSSARY.md` - domain glossary
3. `conventions/NAMING.md` - naming patterns
4. Business logic docs (resolve via Documentation Map: features/, legacy reference/)
5. Existing styles (`styles/tokens.css` or equivalent)
6. Existing `docs/program/DESIGN.md` (if present)
7. Legacy/reference system source (if migrating)

Design output: `docs/program/DESIGN.md` - visual conventions, tokens, spacing, density.
This file is optional. /design creates it when the project warrants a design system doc.

If SCOPE.md is missing and no equivalent context exists, hard-stop:
"I need to understand what this product does before I can design for it. Answer these questions or run /setup first."

Then ask:
1. What does this product do in one sentence?
2. Who uses it and how often? (Daily tool vs. occasional visit)
3. What's the information density? (Dashboard-dense, form-heavy, content-light)
4. Is there a system being replaced? What does it look like?
5. What's the team size consuming these design decisions?

If the user provides enough inline context without SCOPE.md, proceed. The gate is on understanding, not on file existence.
