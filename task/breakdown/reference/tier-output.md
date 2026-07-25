## Tier-adapted output

| Tier | Output |
|------|--------|
| Tier 1 | Ordered list in session context, passed to /tdd |
| Tier 2 | Written to spec file as `## Implementation Slices` section |
| Tier 3 | Written to spec + GitHub sub-issues via `gh` CLI |

At Tier 1 (no spec file infrastructure), present slices inline and pass to /tdd directly.
At Tier 3, after writing to the spec, create GitHub sub-issues.
Apply the tracker label rendered from the slice's `Autonomy:` tag (`afk` -> `ready-for-agent`, `hitl` -> `ready-for-human`), so a repo using Pocock `triage` finds the labels already agree:

```bash
gh issue create --title "Slice 1: {name}" --body "{details}" --label "ready-for-agent" --project "{project}" --parent "{parent-issue-number}"
```

The label renders the same `autonomy` value `/ship` reads; it is never recomputed here (ENGAGEMENT-REFERENCE.md section 13.1).
