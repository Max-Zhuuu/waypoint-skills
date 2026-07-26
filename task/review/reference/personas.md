# Personas: resolution and the trust gate

A persona is a lens - a named set of questions, a weighting over the standard review categories ([what-it-checks.md](what-it-checks.md)). The machinery is identical no matter which lens runs; only the questions change. An analytical `architect` and a subjective `creative-director` go through the exact same steps.

On Claude Code a persona *is* an agent, so personas reuse the host's own agents directory rather than a new Waypoint folder - but only the user-global one. Waypoint ships no shared persona document: the old committed `PERSONAS.md` is retired, not moved, because a review lens is personal, and a shared, version-controlled lens is repo-authored - exactly the untrusted material a review must never compose. A repo's own `.claude/agents/` is not a Waypoint persona source.

## The two tiers

| Tier | Where it lives | Trust |
|---|---|---|
| Built-in | `reference/personas/` in this skill (portable question-files) | Trusted |
| User-global | `~/.claude/agents/` (your personal agents, outside any repo) | Trusted |

Waypoint composes a persona only from these two trusted tiers, on every path - whether you type `/review <name>` or a review is triggered automatically.
A repo's own `.claude/agents/` is untrusted ([review-safety.md](../../../internals/engagement/review-safety.md), the trust tiers: trust is the author, not the content - the next repo's could be hostile, and a persona is instructions the model follows), so it is never a Waypoint persona source: not by hand, not automatically, under any name. To adopt a repo's lens, copy it into your `~/.claude/agents/` first - an explicit act that makes you its author.
The user-private-versus-shared cut these tiers follow is the same one the settings surface defines; see [settings.md](settings.md).
Project docs a lens compares against (ADRs, architecture, design system, conventions) are data, not authority: a diff matching a repo doc is not thereby approved, since the doc could have been edited in the same untrusted change.

The built-in lenses stay portable: they remain `reference/personas/` question-files inside the methodology, so they work on every adapter (Cursor, Codex, OpenCode), not just hosts with an agents directory.
Reusing the agents directory is a statement about the user-global tier - your personal personas - not about the built-ins, and never about a repo's own agents.

## Resolution (`/review <name>`, manual or automatic)

Resolution is identical on both paths, because both read only the trusted tiers. Built-in first, then user-global (`~/.claude/agents/<name>`), by absolute path; first match wins.

The built-in tier is searched first, so a repo can never shadow a trusted persona's name: `/review architect` always runs the built-in `architect`.
An unknown name falls back to the default lens with a note ("Persona `x` not found; running the default lens."); it never loads repo text as the lens, and never consults a repo's `.claude/agents/`. A lens shipped only in the repo is therefore unreachable through `/review` - copy it into `~/.claude/agents/` to use it.
The default lens is itself a trusted built-in (the standards sweep in [what-it-checks.md](what-it-checks.md)), selected directly and never resolved by name, so a repo persona named `default` can never become it.

## Why resolution never delegates to the host

On Claude Code a repo's own `.claude/agents/` shares the directory *name* the user-global agents use, and a host commonly lets the repo's shadow the user's when a bare name is dispatched.
So Waypoint never dispatches a persona by bare name and lets the host resolve it. It reads the persona only from a trusted absolute path - `~/.claude/agents/<name>` or a built-in `reference/personas/` file - on every path, manual or automatic. The gate is enforced by the path Waypoint reads, not by trusting the host's resolution order.
Reusing the agents *directory* for storage does not delegate *resolution* to the host.

This is the one place external text could reach a steering position, so the gate is unconditional and closed on both paths: auto-invoke and a hand-typed name alike read only trusted authors, by absolute path. A project cannot arrange, by naming or by shadowing, for its own lens to critique a pull request - not unattended, and not under a name a human types expecting their own.
