# Personas: resolution and the trust gate

A persona is a lens - a named set of questions, a weighting over the standard review categories ([what-it-checks.md](what-it-checks.md)). The machinery is identical no matter which lens runs; only the questions change. An analytical `architect` and a subjective `creative-director` go through the exact same steps.

On Claude Code a persona *is* an agent, so personas reuse the host's own agents directory rather than a new Waypoint folder. Waypoint ships no shared persona document: the old committed `PERSONAS.md` is retired, not moved, because a review lens is personal, and a shared, version-controlled lens is exactly the untrusted-auto-invoke hazard the trust gate exists to stop.

## The three tiers

| Tier | Where it lives | Trust |
|---|---|---|
| Built-in | `reference/personas/` in this skill (portable question-files) | Trusted |
| User-global | `~/.claude/agents/` (your personal agents, outside any repo) | Trusted |
| Project | a repo's own `.claude/agents/` in the repo under review | **Untrusted** |

Trust is decided by author, not by content (ENGAGEMENT-REFERENCE.md section 14.1): a well-written project persona is still untrusted, because the next repo's `.claude/agents/` could be hostile and a persona is instructions the model follows.
The user-private-versus-shared cut these tiers follow is the same one the settings surface defines; see [settings.md](settings.md).
Project docs a lens compares against (ADRs, architecture, design system, conventions) are data, not authority: a diff matching a repo doc is not thereby approved, since the doc could have been edited in the same untrusted change.

The built-in lenses stay portable: they remain `reference/personas/` question-files inside the methodology, so they work on every adapter (Cursor, Codex, OpenCode), not just hosts with an agents directory.
Reusing the agents directory is a statement about the two trust-bearing tiers - your user-global personas and a repo's hand-run ones - not about the built-ins.

## Manual resolution (a human typed `/review <name>`)

Search the trusted tiers first, then the project tier; first match wins:

1. Built-in, then 2. user-global (`~/.claude/agents/<name>`), then 3. the repo's `.claude/agents/<name>`.

Trusted tiers are searched before the project tier, so a repo can never shadow a trusted persona's name: `/review architect` always runs the built-in `architect`, even if the repo defines one. A project persona is reachable by hand only under a name that collides with no trusted persona - so give project personas distinct names.
An unknown name falls back to the default lens with a note ("Persona `x` not found; running the default lens."); it never loads repo text as the lens on a miss.
The default lens is itself a trusted built-in (the standards sweep in [what-it-checks.md](what-it-checks.md)), selected directly and never resolved by name, so a repo persona named `default` can never become it.

Running a project persona by hand is allowed - it is an explicit human choice (section 14.3). The gate below governs only the automatic path.

## The trust gate (automatic invocation)

When a review is triggered automatically rather than by a human choosing a persona in that moment (the auto-run setting - see [autorun.md](autorun.md)), it composes trusted-tier personas only.

Because the trusted and project personas now share a directory *name* (`.claude/agents/`) that the host also reads, the gate cannot delegate resolution to the host: a host commonly lets a repo's `.claude/agents/` shadow the user's.
So auto-invoke does not dispatch a persona by bare name. It reads the persona only from a trusted absolute path - `~/.claude/agents/<name>` or a built-in `reference/personas/` file - never from a bare name the host might resolve to a repo file. The gate is enforced by the path Waypoint reads, not by trusting the host's resolution order.
Reusing the agents *directory* for storage does not delegate *resolution* to the host.

Automatic invocation therefore resolves the configured name against the trusted tiers only - built-in, then `~/.claude/agents/` by absolute path - and stops; it never consults the repo's `.claude/agents/`, and a miss routes to the default lens, never onward to a project persona.
The repo's `.claude/agents/` is therefore never eligible for an automatic review, under any name, resolution order, or fallback. If the trusted config names no persona, the automatic review runs the default lens - never a project persona.

This is the one place external text could reach a steering position, so the gate is unconditional: auto-invoke reads only trusted authors, by absolute path. A project cannot arrange, by naming or by shadowing, for its own lens to critique its own pull request unattended.
