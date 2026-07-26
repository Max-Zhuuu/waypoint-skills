# The Autonomy Axis

Authoritative reference for the `autonomy` axis, cited by `/ship`, `breakdown`, and `check-in`. Part of the engagement protocol ([README.md](README.md)); it is not read from any repo under review.

The engagement tiers ([README.md](README.md)) answer "may I act unattended right now" - a permission.
The autonomy axis answers a different question: "could this change ship unattended at all" - a capability.
The two are different modal categories and must never be collapsed into one number; the composition table below composes them.

This file is the single authoritative definition of the axis.
Every consumer - `/ship`, `breakdown`, `check-in`, and any Tier 3 tracker label - renders or cites the value defined here; none re-derives it.

## One axis, three renderings

Canonical field: `autonomy`.
Values: `afk` (no human needed) and `hitl` (a human must look).
Computed once, rendered three ways, never re-decided per consumer:

| Consumer | Rendering of `afk` | Rendering of `hitl` |
|---|---|---|
| `breakdown` slice tag | `afk` | `hitl` |
| Tracker label (Tier 3 issues, Pocock `triage`) | `ready-for-agent` | `ready-for-human` |
| PR routing hint (`/ship`) | auto-eligible | escalate |

## Waypoint proposes, the target disposes

Waypoint never holds merge authority.
`afk` is necessary, not sufficient, for an unattended merge.
It means only "Waypoint proposes the auto lane and opens the PR."
Sufficiency is held by the delivery target's own enforcement - server-side rulesets, blocking CI, an autonomous reviewer - evaluated on the final diff at merge time, not on Waypoint's snapshot.
A concern raised, or a load-bearing file introduced, after the axis is computed is therefore caught by the authority at merge, never missed by a stale local value.

## The afk gate (deterministic, fail-safe)

A change is `afk` if and only if ALL of the following hold:

- **key 1a** (per-change): every shipped slice is tagged `afk`. An untagged slice counts as `hitl`.
- **key 1b** (per-change): `wrapup`'s gate evaluation reported no open blocking concern for the change. The value is consumed from that output; "blocking" is not re-derived from raw CONCERNS.md. If `wrapup` has not reported a verdict for the change, key 1b counts as failed (`hitl`), mirroring the untagged-slice default in key 1a.
- **key 2** (repo-authored): no file in the diff matches a `load-bearing` glob in DEPLOY.md.

Any single failure yields `hitl`.
The `load-bearing` list can only ever force `hitl` earlier; it can never grant `afk`.
It is a fail-safe shift-left hint, not an auto-approve mechanism.

## Glob evaluation rules

- Dialect: gitignore-style globbing (`git check-ignore` semantics), so `**` and directory matches are well-defined.
- Renames and moves: match against the union of pre- and post-change paths, so moving `auth/login.ts` to `services/login.ts` still trips `auth/**`.
- Deletions: a deleted path is still a diff path and is matched, so removing a guard test does not shrink a change out of the gate.
- Match-only: the `load-bearing` list can only add paths to the gate, never remove them. Negation patterns (`!`) are therefore ignored, and matching is case-insensitive. This preserves the "can only force `hitl`, never grant `afk`" invariant at the dialect level.

## Composition with engagement

`autonomy` is a capability (could this ship unattended); engagement is a permission (may I act unattended right now).
They are ANDed through this table, never through a numeric minimum:

| | on-demand | connected | autonomous |
|---|---|---|---|
| **afk** | prepare + present link, wait for go | open PR, label auto-eligible, human merges | open PR, label auto-eligible, target may merge per its enforcement |
| **hitl** | prepare + present link, wait for go | open PR, label ready-for-human, human merges | open PR, label ready-for-human, escalate (never auto-merge) |

Open-vs-hold is set by engagement; the merge lane is set by autonomy.
Unattended merge requires `afk` AND autonomous engagement AND the target's enforcement passing - a conservative triple-AND, expressed as a table so cells like (hitl, autonomous) are explicit rather than hidden inside a false minimum.

## Single-source discipline

The value is authored in exactly one place per input and read everywhere else:

- `breakdown` authors the per-slice tag (the rendering in the three-renderings table above).
- `wrapup` authors the blocking-concern verdict (key 1b).
- `/ship` composes the gate (the afk gate above) from those authored inputs plus the DEPLOY.md globs, and renders the routing hint. It does not recompute a slice's tag or re-derive "blocking."
- `check-in` and tracker labels render the same value; they never disagree with it.

No skill may recompute the axis from raw state.
A consumer that has an authoritative rendering cites the authoring skill's output and does not re-run the derivation.
A consumer that lacks one treats the value as `hitl`; it never computes its own.
