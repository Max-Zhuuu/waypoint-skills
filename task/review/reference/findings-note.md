# The findings note and the four routes

## The note is throwaway

Write findings to `docs/_local/reviews/{entity-or-timestamp}.md` - gitignored working state, lazy-created (see setup's local-docs reference).
It is cheap and not committed: it exists to drive the routing step this session, not to become a record.
The common case stays light. A fuller sectioned report (like `/improve-codebase-architecture` writes) is available on request or by preference, but is not the default.

## Note format

```markdown
# Review: {entity} ({lens} lens) - intent: checked here | deferred to pipeline

## F-1 {one-line finding}  [category: {fixed category}]  {file}:{line}
{why it matters, one or two lines - stays in this throwaway note, never copied into CONCERNS.md}

## F-2 ...
```

Each finding carries a fixed-vocabulary category and a `{file}:{line}` coordinate - the same structural handle a concern would later store.

## Four routes per finding

For each finding, the human picks exactly one route. Nothing becomes permanent until a route is picked.

1. **Spec** - the finding is really a requirements gap; hand it to `/spec` to grill and write a spec.
2. **Breakdown** - it is a chunk of work; hand it to `/breakdown` to slice.
3. **Apply now** - fix it in this session as an ordinary change (goes through build + review like any diff).
4. **Note as concern** - record it in CONCERNS.md for later.

## The concern route is gated and structural

Route 4 is the only path from a finding into CONCERNS.md, and it is a human pick, never automatic - at every tier, including Tier 3 (ENGAGEMENT-REFERENCE.md section 14.2, crossing 1).
Every field of the concern is a structural pointer: the `{file}:{line}` coordinate, the fixed category, and the section-4 `type`.
The section-4 header's mandatory `{one-line description}` is generated from that handle (for example `{category} finding at {file}:{line}`), never lifted from the finding's wording, and the free-text context field is omitted.
All of the finding's prose - both its one-line summary (`## F-N ...`) and its why-it-matters lines - stays in the throwaway note; none of it is copied or paraphrased into the concern body, because CONCERNS.md is injected as trusted context every turn.
