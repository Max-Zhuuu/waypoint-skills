# The auto-run setting

By default `/review` is suggested, not forced (wrapup nudges it, you can always run it by hand). This matches every other Waypoint skill: the default leaves you in control.
A project can opt into running review automatically. That is the one optional setting this slice adds, and it is deliberately constrained.

## Where it lives, and why

The setting is `review.autorun` (values `suggest` | `auto`; absent means `suggest`).
It is a behavior-escalating setting - it changes what review does unattended - so per ENGAGEMENT-REFERENCE.md section 14.2, crossing 3, it lives in **trusted config only**: a skill-family built-in default, or the user's personal global config (the deferred mentor tier), keyed by project.
It is never read from a file inside the repo under review - not `PERSONAS.md`, not `DEPLOY.md`, not the repo's `CLAUDE.md`, not any in-repo settings file.
The per-project key that matches a config entry to a repo is a user-asserted identity - the local worktree path, or an identifier the user confirmed in their own chat input - never repo-supplied metadata (a remote URL, the repo or folder name, or any in-repo value). A fresh clone that renames itself to match a trusted project's key does not inherit that project's `autorun`.

The reason is the whole point of the setting's design: a repository must not be able to flip its own review into a lower-scrutiny mode. "Auto-run review" on a hostile pull request, if the repo could set it, would let the repo grant itself less human attention exactly when it most needs more. So the escalation is the user's to make, in their own config, about a project - not the project's to make about itself.

## Fail-safe default

Because the trusted user-global tier is deferred, no project reads as `auto` today: with no trusted `review.autorun: auto` entry, every project falls back to `suggest`. Absent confirmation is treated as not confirmed - the same fail-safe the afk gate (13.3) and the downstream view use.

## What auto-run may do

When a project is set to `auto` in trusted config, a review may run without a per-run human trigger. Even then:

- It composes trusted-tier personas only, never the repo's `PERSONAS.md` (see [personas.md](personas.md), the trust gate).
- It still emits no concern automatically: recording a finding remains a human pick with structural refs only (section 14.2, crossing 1). Auto-run changes when review *runs*, never whether its findings cross into trusted context on their own.
- It does not auto-apply fixes: a formatter or linter autofix is still a gated diff (crossing 4) presented for review, not staged unattended.
- If it hits something needing a human decision, it stops and waits (section 14.4).
