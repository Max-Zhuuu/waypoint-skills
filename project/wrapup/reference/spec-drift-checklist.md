# Spec Drift Checklist

Re-read the entity's documentation and compare against what was built.
This catches discrepancies the implementation verb didn't flag - a documentation safety net, not a code review.

**Feature spec** - check these sections against the built component:
- Fields & Controls: is every declared field present? Any undeclared fields added?
- Interaction Behaviors: do sortable/filterable/resizable declarations match?
- Conditional Visibility: do show/hide rules match?
- Navigation: do declared routes and links exist?

**Logic doc** - check these sections against the built code:
- Data Model: do field names, types, and nullability match?
- Relationships: are declared entity references present?
- Status Lifecycle: do transitions match?
- Business Rules: are declared rules enforced?

Any mismatch becomes a new concern in CONCERNS.md (type: issue, source: /wrapup).

If no feature spec or logic doc exists: "No {doc type} found. Drift check skipped." Continue.
Do not block - this preserves /wrapup's lightweight contract for task-layer usage.
