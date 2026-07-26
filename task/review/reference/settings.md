# Settings and preferences: what lives where

This is the front door for anything you want Waypoint to remember about how a project is run.
Read the litmus first: it decides whether a thing is a setting, a preference, or a fact that belongs in a typed doc.

## The litmus (read this first)

> If you can write it as a switch with a fixed set of values and a default, it is a setting and it lives here. If it is a feeling about how you like to work, it is memory, and your host already handles that.

- **A setting is a deterministic switch.** "When X, always do Y," no judgment. A skill *branches* on it, every legal value is enumerable, and it has a fail-safe default. `review.autorun` is the first of them.
- **A preference is soft context.** "I tend to like Z." It nudges tone or tendency; it never gates behavior. Your host (Claude Code and similar) already stores this as memory, and Waypoint does not rebuild it.

A "preference" is usually a symptom that something has not been filed yet.
Before anything personal is stored, the flow routes it: is this architecture, a convention, scope, or a glossary term?
Only what survives all four routes - genuinely personal, genuinely local, belonging to no versioned doc - lands in the narrow personal note.

## The two homes, cut by one line: user-private, or shared

| Home | Scope | Trust | Holds |
|---|---|---|---|
| `~/.claude/` (host per-user config) | user-global | **trusted** (chat-confirmed) | switches, reviewed-state, and the personal note (each project-keyed); personal personas (cross-project) |
| the committed repo (`DEPLOY.md`, `.claude/agents/`, the repo's own `CLAUDE.md`, any in-repo config) | this project | **untrusted** | workflow, phases, shared config |

A third destination, your host's native memory, holds soft preferences.
It is not a Waypoint home; the litmus just routes soft working style there.

The cut is one question: is this user-private, or is it shared.
Everything trusted you configure lives in your user-global config, outside any repository - which is exactly where the review safety invariant already requires a behavior-escalating setting to live (ENGAGEMENT-REFERENCE.md section 14.2, crossing 3: trusted config only, "never in a file inside the repo under review").
A committed in-repo file is shared - a pull request can ship one - so it stays untrusted, exactly as a repo's own `.claude/agents/` is in [personas.md](personas.md).

## Per-project without an in-repo file

A switch, reviewed-state entry, or note is scoped to one project by *keying*, not by living in that project's tree.
The key is a user-asserted identity - the local worktree path, or an id you confirmed in chat - never repo-supplied metadata; this is the key-provenance rule given in full in [autorun.md](autorun.md).
So an in-repo home is unnecessary: worktree-path keying already gives you "this setting does not follow me to another machine" (a different machine is a different path, no match, safe fallback), the only thing an in-tree home ever bought.
It also avoids reopening the trust boundary: any in-tree trusted home would contradict crossing 3 outright, and making it safe would mean redefining section 14's "inside the repo is untrusted" cut - surgery this design refuses.
"It lives in `CLAUDE.md`" was never the rule: two files can share that name, one user-global and one repo-authored, so the rule is the trust cut above, not the filename.

## The switch registry

The switches are one file: a fenced block of switch values, followed by prose that explains them.
The general rule: structured key-value read together is one file, while documents that accrete independently - the personal note, reviewed-state entries - are directories, one entry per file.

```waypoint-settings
review.autorun: suggest
auto-learn:     suggest
review.persona: architect
```

### One vocabulary for every behavior switch: off / suggest / auto

Every behavior switch shares one three-state vocabulary, with `suggest` the default:

- **off** - do not even offer; the nudge is muted.
- **suggest** - offer, and act only on your confirmation. This is the default.
- **auto** - act unattended.

`off` and `suggest` never act on their own; `auto` is the only state that acts unattended; the default asks first.
So `review.autorun`, `auto-learn`, and the future chain switch all read from this one enum, rather than each cloning a slightly different shape.

| Switch | Type | Values | Default | Governs |
|---|---|---|---|---|
| `review.autorun` | enum | `off / suggest / auto` | `suggest` | whether `/review` runs without a per-run human trigger |
| `auto-learn` | enum | `off / suggest / auto` | `suggest` | whether `/learn`-style capture happens without being asked |
| `review.persona` | string | a lens name | the default lens (the standards sweep) | which lens an auto-invoked review uses |

`review.persona` is not a behavior switch: it names a lens, so it is a string, not this enum. A persona can never carry a switch value, and a switch can never carry a persona.

### Resolution and keying

Every switch resolves through the one trusted user-global home this surface defines.
A reader consults that home when an entry is present and otherwise falls back to the switch's own fail-safe default - absent means the safe value - exactly as before this registry existed, so no reader gains a new hard dependency on the home.
The per-project block carries each switch as one entry, keyed by the user-asserted identity above, and each switch resolves independently, so no combination of switches can contradict another.

### Not a switch: `concerns: auto-emit`

`concerns: auto-emit` is not in this registry.
It is read from the repo's own `CLAUDE.md` as project tier detection (ENGAGEMENT-REFERENCE.md section 1), so it is project-scoped and repo-authored, not user-global trusted config.
Folding it in would change its scope and its trust tier rather than alias it, so it stays exactly where it is.

## What is not here

Personas are not settings and do not live in this file: they are agents, resolved in [personas.md](personas.md).
This surface only names the default review lens - the trusted standards sweep in [what-it-checks.md](what-it-checks.md); it holds no persona definitions.
Every write to anything trusted here obeys section 14.1's one rule: it is written only from your own chat input, on explicit confirmation, and never from observed content.
The write path is propose-in-chat, confirm-in-chat, then write; reviewed-state is the one skill-authored exception, because its payload is purely structural (section 14.2, crossing 1's reasoning).
