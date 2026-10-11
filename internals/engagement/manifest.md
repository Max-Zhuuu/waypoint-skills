# The Artifacts Manifest Emission

Authoritative reference for the artifacts manifest, cited from the Exit of every writing skill. Part of the engagement protocol ([README.md](README.md)).

Concern emission ([README.md](README.md), section 4) is one of two run emissions a skill can make.
The other is the artifacts manifest: a compact receipt of what the run wrote, printed at the end of any skill that creates or modifies files.
It is the run-time echo of the skill's `Writes` frontmatter declaration ([README.md](README.md), section 12): the frontmatter says what a skill is allowed to write, and the manifest says what it actually wrote this run.

## Format

A trailing block, one line per path, grouped by verb, and nothing else:

```
Waypoint · /spec
  created   _docs/specs/auth.md
  modified  GLOSSARY.md          (+2 terms)
  concern   1 question open
```

- Grouped by verb: `created` and `modified` carry file paths; a single `concern` line carries the count the run opened or resolved, never one line per concern.
- One line per path. No prose, no rationale, no diff.
- A write that does not reach the repo - into the user-global trusted config (`~/.claude/`) or any gitignored area - carries a trailing `(local)` tag, so the reader can tell what will and will not reach the commit.
- The header is `Waypoint · /<skill-name>`.

## The empty case

A skill that wrote no files prints the empty manifest rather than inventing activity:

```
Waypoint · /review
  no files changed
  concern   2 issues open
```

The manifest is present on every run of a writing-capable skill, so its absence never has to be interpreted.
A `Writes: none` skill still prints the header, the `no files changed` line, and its concern count when it has one.

## What it is, and what it is not

- Deterministic. It is the exact set of paths the skill wrote this run, read back after the fact, never a guess and never a summary of intent.
- Session-only. It is printed to the conversation and is never a tracked file. There is no `MANIFEST.md`. A stored manifest would mirror the files and drift; the files themselves remain the record, and the manifest only points at them.
- No judgment. It does not decide whether a write was correct, wise, or in the right place; that routing happens before the write, not in the receipt.
- No new crossing. It reads no trusted config and escalates no behavior, so it introduces no [review-safety.md](review-safety.md) crossing and touches no steering position.

## Where it is declared

This file is the single definition of the manifest's shape.
Each writing skill emits the manifest by citing this file from its Exit rather than restating the format, so the block is byte-uniform across skills.
