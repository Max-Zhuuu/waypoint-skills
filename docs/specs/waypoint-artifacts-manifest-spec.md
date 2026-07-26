# Spec: the artifacts manifest - a compact "what I touched" block every writing skill emits

Status: draft for review.
Companion to the `/review` loop-back spec, the `/ship` seam spec, and the settings spec (waypoint-settings-spec.md).
Sequenced first of the three: it is pure win, it depends on nothing, and it settles no trust question.
Written in plain English on purpose.

## The idea in one paragraph

When you run a Waypoint skill on a real project, you cannot easily tell what documentation just happened.
A spec was written, a glossary term was added, a concern was opened, but to see it you have to go into the codebase and hunt.
Even the person who built the methodology has to reconstruct where things landed, and concerns as a central surface do not make it obvious on their own.
This spec fixes that with the smallest possible thing: every skill that writes anything ends its run with a compact manifest of the directories and files it created or modified, printed in the session, in a fixed shape.
Nothing new is stored, nothing is analyzed, no judgment is made.
It is a receipt.

## Why this is separate, and why it ships first

The settings work is tangled in a trust argument (what is trusted, what a repo may write, how personas resolve).
The manifest is tangled in nothing.
It reads no config, escalates no behavior, and touches no steering position, so it does not wait on section 14 or on any home being built.
It is high value on every single run, so it should land before the debates it is not part of.

## What it is

A trailing block, emitted by any skill that creates or modifies files, listing exactly what changed and nothing else.

```
Waypoint · /spec
  created   docs/specs/auth.md
  modified  GLOSSARY.md          (+2 terms)
  concern   1 question open
```

Rules that keep it a receipt and not a feature:

- **Deterministic.** It is the set of paths the skill actually wrote this run, not a guess and not a summary of intent. If a skill wrote nothing, it prints "no files changed" rather than inventing activity.
- **Compact.** One line per path, grouped by verb (`created`, `modified`, and where useful `concern` for the concern count). No prose, no rationale, no diff.
- **Session-only.** It is printed to the conversation. It is not a tracked file, so it cannot drift from reality the way a stored report would. The files themselves remain the record; the manifest only points at them.
- **Uniform.** Every writing skill emits the same shape, so the reader learns it once. This is why it belongs in the shared engagement reference, not in each skill body.

## Where it lives in the methodology

It is a standard emission, described once in `internals/ENGAGEMENT-REFERENCE.md` next to the existing `concerns` emission, and referenced (not restated) by each skill.
A skill already declares what it `Emits` and `Writes` in its frontmatter.
The manifest is the human-visible echo of `Writes`: the frontmatter says what a skill is allowed to write, the manifest says what it did write this run.
That pairing is the whole design: the manifest is `Writes`, surfaced.

## Relationship to the workflow map you asked about

You wanted, eventually, a mermaid picture of how everything in the flow connects.
The manifest is the honest first version of that, and it fixes the ordering so the picture can never become a control surface.
The manifest is the source of truth: it is what actually happened, per run.
A map, later, is only a read over accumulated manifests, a lens for a human.
Build the receipt now; the diagram is a downstream view that never feeds back into behavior.
If a later spec draws the map, it draws it from these manifests and from the file markers the settings/workflow-state work defines, never the reverse.

## Non-goals

- It does not decide whether a write was correct, wise, or in the right place. That routing (does this belong in architecture, conventions, scope) is the settings spec's job, and it happens before the write, not in the receipt.
- It does not persist. There is no `MANIFEST.md`. A tracked manifest would mirror the files and drift; the point is a live, throwaway receipt.
- It does not read or write any trusted config, so it introduces no crossing and needs no section 14 change.
- It does not replace concerns. The concern count is one line in the receipt; `CONCERNS.md` remains the concern record.

## Implementation Slices

Decomposed for build.
Small: two slices, and the first is where all the definition lives.

### Slice A0 - the manifest emission, defined once
**Depends on:** none
**Autonomy:** hitl
**Files:** internals/ENGAGEMENT-REFERENCE.md (a new emission subsection next to `concerns`)
**Done when:** the reference defines the manifest's fixed shape (grouped by verb, one line per path, the "no files changed" case), states that it is session-only and never a tracked file, and ties it to each skill's frontmatter `Writes` declaration as the run-time echo of it.
**Notes:** this is a documentation-of-behavior slice; it changes no steering position and adds no crossing.

### Slice A1 - skills emit it
**Depends on:** A0
**Autonomy:** hitl
**Files:** every skill that writes files (spec, breakdown, wrapup, setup, ship, review, learn, and any other `Writes: ...` skill), one Exit line each
**Done when:** each writing skill ends its run by emitting the manifest for exactly the paths it wrote this run; a skill that wrote nothing prints the empty-manifest line; the emission is byte-uniform across skills because each cites the reference rather than restating the format.
**Done when (line budget):** the per-skill addition is one Exit reference line, so no skill body crosses its line gate on account of this.
**Notes:** `Writes: none` skills (a pure `/review` that only emits concerns) still print the empty manifest plus their concern count, so the receipt is present on every run and its absence never has to be interpreted.

## Open for your review

1. **Grouping granularity.**
   Group only by verb (`created` / `modified`), or also fold in the concern delta and any doc-cascade touches (a `/wrapup` that cascades into three docs) as their own lines?
   Lean: verb groups plus a single concern-count line, and cascaded docs listed as ordinary `modified` lines, so a `/wrapup` receipt shows every doc it touched without a special category.
2. **Writes that do not reach the repo.**
   Should the manifest mark a write that stays off the repo - into the user-global config (`~/.claude/`, where the settings spec puts switches, personas, and reviewed-state) or into any gitignored area - differently from a tracked write, so the reader knows what will and will not reach the commit?
   Lean: yes, a small `(local)` tag meaning "did not reach the repo," because that boundary is exactly what is otherwise invisible, and it is the manifest's answer to the settings spec giving up in-repo co-location for visibility (Path A) - the manifest is where a user-global write becomes visible.
