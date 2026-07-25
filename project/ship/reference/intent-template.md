# Intent block and PR body

`/ship` reads this when authoring the PR. The PR body is the durable, authoritative record the target's reviewer grades against; everything else `/ship` prints is an ephemeral echo.

## The spec-derived rule

Every sentence of `## Intent` traces to the spec, an ADR, or a resolved concern `decision:` line.
None is derived from reading the diff.
This is deliberate: if Intent described the diff, the reviewer would grade the diff against a description of itself, which passes by construction.
The block is labelled `spec-derived` in the PR body so the reviewer knows to check spec-versus-diff, not intent-versus-diff.

If a fact needed for Intent is not in the spec, an ADR, or a decision line, that is a gap: state it as "unstated in spec" rather than inventing it from the code.

## PR body structure

```markdown
## Intent
<!-- spec-derived: what changed and why. Sources: spec + ADRs + resolved decisions. Never the diff. -->
{2-5 sentences: the behavior this change delivers and the reason it exists.}

## Concern decisions
- C-041 [resolved] {one-line decision}. (see CONCERNS.md)
- C-047 [resolved] {one-line decision}. (see CONCERNS.md)
<!-- references CONCERNS.md by id; does not copy concern bodies -->

## Routing
- autonomy: afk | hitl - {why, in one line: which key decided it}
- engagement: on-demand | connected | autonomous
- adapter: {from DEPLOY.md}
- target tier: {staging | production | ...}
- load-bearing paths touched: {list, or "none"}

## Slices
- Slice 1 {name} - afk | hitl - traces to AC {n}
- Slice 2 {name} - afk | hitl - traces to AC {n}
```

## Concern decisions section

Reference each resolved concern by its `C-NNN` id and a one-line restatement of its `decision:`.
Do not paste concern bodies into the PR: the id plus the decision line is the pointer, and CONCERNS.md remains the record.

## Local adapter

With `adapter: local` there is no PR surface.
Present the Intent block inline and write it as the commit-message body (or a `.github/PULL_REQUEST_TEMPLATE` body) so it has exactly one home that the eventual PR inherits, rather than a throwaway echo that must be re-authored later.
