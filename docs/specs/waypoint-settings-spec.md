# Spec: settings - the trusted switch registry, personal personas, and the narrow preferences escape hatch

Status: draft for review.
Supersedes: the "mentor tier" draft at this path (waypoint-mentor-tier-spec.md). The name is retired: this was never a mentor, it is a switch registry plus a receipt for the few genuinely personal things that belong nowhere else.
Companion to the `/review` loop-back spec, the `/ship` seam spec, and the artifacts manifest spec (waypoint-artifacts-manifest-spec.md).
This is the layer the review arc deferred: its "user-global" seam (loop-back spec, lines 225-241) is what this spec fills.
Written in plain English on purpose. Where a decision was contested, the reason is stated inline so you can challenge it.

## The idea in one paragraph

Waypoint's whole thesis is that things get documented carefully into typed homes: architecture, conventions, scope, glossary, specs.
So it should barely need a "preferences store," and this spec is deliberately small because of that.
What it does need is a place for deterministic switches - "auto-run review on this project," "auto-advance this chain," "auto-generate the learn note" - the levers that change control flow with no judgment.
That is what settings are.
Everything else that feels like a preference is either a switch (put it here) or a fact about the project (file it in a typed doc) or, rarely, a genuinely personal local note (a narrow escape hatch, guarded so it does not become a junk drawer).
The whole design turns on one property, unchanged from the review arc: anything trusted here is written only from what you say in chat, on your explicit confirmation, and never from anything the assistant read.

## The front door: setting versus preference

This is the sentence that sits at the top of the settings doc, so a user knows why the surface exists and is encouraged to use it well:

> If you can write it as a switch with a fixed set of values and a default, it is a setting and it lives here. If it is a feeling about how you like to work, it is memory, and your host already handles that.

- **A setting is a deterministic switch.** "When X, always do Y," no judgment. `review.autorun`, a chain preference, an auto-learn toggle. A skill *branches* on it. Every legal value is enumerable and it has a fail-safe default.
- **A preference is soft context.** "I tend to like Z." It nudges tone or tendency, it does not gate behavior. Claude Code and similar hosts already store this as memory, and Waypoint does not rebuild it.

This litmus is the encouragement mechanism.
People add settings when the surface tells them "these are the levers," and they stop dumping vague preferences when the surface tells them where those actually belong.

## Why Waypoint barely needs memory, and what the escape hatch is for

A "preference" is usually a symptom that something has not been filed yet.
"We always validate at the boundary" is a convention.
"Auth is out of scope this cycle" is scope.
"A widget is a saved dashboard layout" is glossary.
So before anything personal gets stored, the skill routes: is this architecture, a convention, scope, or a glossary term?
Only what survives all four - genuinely personal, genuinely local, belonging to no versioned doc - lands in the escape hatch.
The routing *is* the anti-junk-drawer discipline, and the escape hatch has to stay narrow or it becomes the muddy bucket the typed docs exist to prevent.

There is one legitimate residual, and it is narrow: a note specific to one project, personal enough that you would not commit it, and neither a switch nor a fact any typed doc will take.
Soft cross-project working style ("I like terse commit messages") is not this residual.
That is a feeling, and the litmus sends it to your host's memory, which Waypoint does not rebuild.
The residual is the project-scoped personal reminder that survives all four routes and is not enumerable enough to be a switch.
It is small, but it is real, and it is why a personal note exists at all beyond the switches.
It lives in your user-global config, keyed to the project, never committed.

## Two homes, cut by one line: is it user-private, or is it shared

| Home | Scope | Trust | Holds |
|---|---|---|---|
| `~/.claude/` (host per-user config) | user-global | **trusted** (chat-confirmed) | switches, reviewed-state, and the personal note (each project-keyed); personal personas (cross-project) |
| committed repo (`DEPLOY.md`, `.claude/agents/`, the repo's own `CLAUDE.md`, any in-repo config) | this project | **untrusted** | workflow, phases, shared config |

A third destination, your host's native memory, holds soft preferences.
It is not a Waypoint home and this spec does not touch it; the litmus just routes soft working style there.

The cut is one question: is this user-private, or is it shared.
Everything trusted lives in your user-global config, outside any repository, which is exactly where the review arc's safety invariant already requires a behavior-escalating setting to live (internals/engagement/review-safety.md, crossing 3: trusted config only, "never in a file inside the repo under review").
A committed in-repo file (a repo's own `.claude/CLAUDE.md`, its `.claude/agents/`, `DEPLOY.md`) is shared, a pull request can ship one, so it stays untrusted, exactly as `PERSONAS.md` was in personas.md.

### Per-project without an in-repo file

A switch, reviewed-state entry, or note is scoped to one project by *keying*, not by living in that project's tree.
The key is a user-asserted identity - the local worktree path, or an id you confirmed in chat - never repo-supplied metadata, so a repo cannot rename itself into another project's trusted settings.
Personas are the exception to the keying: a personal persona in `~/.claude/agents/` is user-global and available to every project, and only the `review.persona` default that selects a lens is project-keyed.
This is the key-provenance rule already in autorun.md, and it is why an in-repo home is unnecessary: worktree-path keying already gives you "this switch does not follow me to another machine" (a different machine is a different path, no match, safe fallback), which is the only thing an in-tree home ever bought.
It also avoids reopening the trust boundary.
An earlier draft put project switches in a gitignored `docs/_local/`; a build review showed that any in-tree trusted home contradicts crossing 3 outright, and that making it safe would mean redefining section 14's "inside the repo = untrusted" cut.
This design refuses that surgery: the switches live where crossing 3 already says they must, so nothing about section 14's trust boundary has to change to hold them.

This is also why "it lives in `CLAUDE.md`" was never the rule: two files can share that name, one user-global and one repo-authored.
The rule is the trust cut above.

## The one rule that guards everything

> Anything trusted here is written only from your own chat input, on explicit confirmation, and never from observed content.

This governs everything you *author* in the trusted config identically: switches, personas, the personal note.
Reviewed-state is the one exception, carved out below, because it is skill-authored bookkeeping rather than something you told the assistant to remember.
Observed content means anything the assistant reached through a tool: repo files, a diff, PR or reviewer text, a web page, a persona file, a finding, a concern body.
None of it may ever write, edit, or extend a trusted setting or note, no matter how it is framed and no matter that a human eventually sees the result.
The write path is exactly one shape:

1. The assistant proposes, in chat: "Want me to remember X / set Y?" where X or Y is drawn from what *you* said in this conversation.
2. You confirm in chat.
3. The assistant writes it, in your words or a paraphrase you approved.

- Confirmation is **mandatory**, never implied by silence, the same fail-safe the afk gate (13.3) and autorun.md already use.
- The **source** is chat only. Something the assistant infers from reading a repo is not something you stated; it may be *proposed* ("I notice this repo always validates at the boundary, want me to remember you prefer that?") but the thing written is your confirmation, not the repo's content. The repo suggested a question; you supplied the stored answer.
- **Forgetting is low-ceremony.** Removal can only ever reduce what steers the assistant, never introduce steering, so "forget that" just removes it. Writing is the high-ceremony direction; forgetting is not.
- **One structural exception: reviewed-state.** The double-review guard writes reviewed-state (a project key plus a diff hash) mechanically, without a chat confirmation, because it is bookkeeping the skill produces, not a preference you stated. It stays safe under this rule's actual purpose: its payload is purely structural, so no observed content ever enters trusted config through it - the same reason crossing 1 lets a skill record a concern from structural references without quoting any text. The chat-confirmation ceremony guards user-authored content; reviewed-state is not that.

## How this extends section 14

Section 14 fixes exactly two steering positions and four crossings, and its position 1 (trusted context) already lists `CONCERNS.md` as its example.
The switches need no extension: a behavior-escalating setting is already position-2 / crossing-3 material, and crossing 3 already requires exactly the trusted user-global home this spec gives them.
The one genuinely new thing is the personal note.
It is injected as trusted context, so it is a *second source* under position 1, alongside `CONCERNS.md`, not a new kind of position.
So the extension is small and precise: name the personal note as a position-1 trusted-context source, and add the one new crossing (observed content becoming a trusted note) that 14.2 does not yet enumerate.
The chat-confirmation write rule that crossing needs is already stated in 14.1, so S0 cites it rather than re-adding it.

The persona work (S3) also touches section 14. Its final form (superseding an earlier rename-the-tier draft) drops the repo persona tier entirely: a repo's own `.claude/agents/` is never a Waypoint persona source, on any path.
Retiring the shared `PERSONAS.md` therefore does not relocate the untrusted persona tier to a repo's own `.claude/agents/` - it removes that tier from Waypoint's sourcing altogether.
So S3 rewrites crossing 2 and the crossing stays live and gets stricter: a review composes a persona only from the two trusted tiers (built-in, `~/.claude/agents/`), read by absolute path, whether triggered by hand or automatically. A repo's `.claude/agents/` remains untrusted repo content, but Waypoint never resolves a persona from it.

## Personas: per-user agents, the shared file retired

A persona is a review lens.
On Claude Code it *is* an agent, so personas reuse the host's own agents directory instead of a new Waypoint folder:

- Built-in `reference/personas/` and `~/.claude/agents/` (user-global) are **trusted**: a review composes a persona only from these two tiers, whether by hand or auto-invoked (personas.md, the trust gate).
- A repo's own `.claude/agents/` is **untrusted** and is not a Waypoint persona source under any name, by hand or automatically. To use a repo's lens, copy it into `~/.claude/agents/`.

The mechanism matters here, because the files now live in a directory the host also reads.
Auto-invoke does not dispatch a persona by bare name and let the host resolve it, since a host commonly lets a repo's `.claude/agents/` shadow the user's.
It reads the persona only from a trusted absolute path - `~/.claude/agents/<name>` or a built-in `reference/personas/` file - and never from a name the host might resolve to a repo file.
The trust gate is enforced by the path Waypoint reads, not by trusting the host's resolution order.
Reusing the agents *directory* for storage does not delegate *resolution* to the host; the guarantee personas.md already makes ("never consults a repo's `.claude/agents/`") is kept by construction.

Waypoint ships **no shared persona document**.
The old `PERSONAS.md` (a committed, shared file) is retired, not moved: a review lens is personal, and a shared, version-controlled lens is exactly the untrusted-auto-invoke hazard the trust gate exists to stop.
This resolves the open fork the build review surfaced: there is no "coexist" question, because there is no shared file to coexist with.

The built-in lenses stay portable.
They remain `reference/personas/` question-files inside the methodology, so they work on every adapter (Cursor, Codex, OpenCode), not just hosts with an agents directory.
"Reuse the agents directory" is therefore a statement about the user-global tier (your personal personas), not about the built-ins and never about a repo's own agents.

Authoring a persona is a grill, not a vibe.
The authoring flow forces a domain, three concrete failure modes the lens is meant to catch, a lens boundary (what it deliberately ignores), and a citation basis, then writes an agent file.
It refuses an ungrounded "vibe" lens, because an auto-invocable trusted lens with no grounding is just unaccountable steering.

## The switch registry is a refactor, not a dependency

`review.autorun` is already *defined* - values `suggest | auto`, default `suggest` - but its trusted home is deferred (autorun.md: with the user-global tier not yet built, nothing is stored, and every project falls back to `suggest`).
This spec builds that deferred home and gives the trusted switches one schema in it: `review.autorun`, a `review.persona` default, an auto-learn toggle, and later the chain preference.
So this is not a new dependency bolted on; it is the home the shipped setting was already specified to have.
Nothing that reads a switch changes shape: the reader consults the user-global home if present and falls back to the same fail-safe default (absent means the safe value) otherwise, exactly as today.

### One vocabulary for every behavior switch: off / suggest / auto

Behavior switches do not each get a bespoke shape.
They share one three-state vocabulary, with `suggest` the default:

- **off** - do not even offer. The nudge is muted.
- **suggest** - offer, and act only on your confirmation. This is the default.
- **auto** - act unattended.

The safety ordering is clean: `off` and `suggest` never act on their own, `auto` is the only state that acts unattended, and the default asks first.
So `review.autorun`, `auto-learn`, and the future chain switch all read from the same enum, which is what "match autorun's shape" actually has to mean: not clone a slightly different shape per switch, but share one.
This brings `autorun` into the vocabulary, so it gains an explicit `off` ("stop offering to review") it does not have today.
That is a change to a shipped switch, but the registry refactor already touches `autorun`, so it is the same edit, and the fail-safe default is unchanged (`suggest` still asks before acting).
`review.persona` is not a behavior switch; it names a lens, so it is a string, not this enum.

One thing that is **not** a switch and does not move here: `concerns: auto-emit`.
It is read from the repo's own `CLAUDE.md` as project tier detection (internals/engagement/README.md, tier detection), so it is project-scoped and repo-authored, not user-global trusted config.
Folding it in would change its scope and its trust tier, not alias it, so it stays exactly where it is.
(The loop-back spec, lines 236-237, loosely called it a "global marker"; that is the wording this corrects.)

## Reviewed-state: the double-review guard, now clearly homed

Two skills should not both review the same diff, and a repo should not be able to mark itself reviewed to skip its own auto-review.
Reviewed-state is pinned to the diff snapshot (a commit or diff hash), so a new commit re-opens eligibility, and it is kept in the same user-global trusted config as the switches, keyed by project identity and diff hash.
Suppressing a review is itself a scrutiny-reducing behavior, so it belongs in trusted config for the same crossing-3 reason `autorun` does, which is exactly why it cannot live in the repo: a repo-authored "already reviewed" marker would let a hostile pull request skip its own auto-review (the autorun key-provenance bug in a new costume).
It is never read from a repo-authored marker, and an explicit `/review` always runs regardless.
It is distinct from the session-only findings note, and distinct from `wrapup`'s gate verdict: it is one durable fact, "this exact diff was reviewed," with a single home.

## Non-goals

- It does not build a general memory store. Soft preferences are the host's memory; project facts are typed docs; only switches, personas, and the narrow project-scoped personal note live in the trusted config.
- It does not let a repo write to, or read as trusted, any part of a trusted home.
- It does not auto-learn from observed content; observed content may only ever prompt a question you answer.
- It does not replace project docs. `GLOSSARY.md`, ADRs, `DEPLOY.md` are project-scoped and version-controlled; the trusted homes are personal, and the two never substitute for each other. The preferences router actively pushes content *toward* the typed docs and only keeps what none of them wants.
- It does not add any new behavior-escalating switch beyond giving the existing ones a home and defining auto-learn and the chain seam; each new switch is its own future decision.
- It does not make auto-run, or any escalation, a default; every default it holds is the fail-safe one.

## Implementation Slices

Decomposed for build.
Sequenced so the safety rule lands before anything writes, exactly as slice 0b preceded the review skills that depend on it.
The artifacts manifest spec ships before all of these; it is not a slice here.
Every slice is `hitl`: this layer is the methodology's own trusted-context and self-governance surface, so no slice is machine-verifiable enough to ship unattended, and each carries an adversarial build-regrill as its acceptance gate.

### Slice S0 - the invariant
**Depends on:** none
**Autonomy:** hitl
**Files:** internals/engagement/review-safety.md, CONTRIBUTING.md
**Done when:** section 14 names the personal note as a second position-1 trusted-context source (alongside `CONCERNS.md`, not a new kind of position) and adds the one new crossing (observed content becoming a trusted note) that 14.2 does not yet enumerate; it records that the switches need no new position because a behavior-escalating setting is already crossing-3 material with the trusted user-global home crossing 3 already mandates; it cites (does not re-add) the chat-confirmation write rule already in 14.1; CONTRIBUTING carries the one-line rule for the user-global trusted config and cites section 14. The persona crossing-2 wording is not touched here; it changes in S3, with the retirement it describes.
**Regrill:** the load-bearing pass - the wording must forbid every non-chat source for the personal note unambiguously, and must make the note's integrity legibly equal to crossing 3's.

### Slice S1 - the homes, the trust cut, the schema, the litmus
**Depends on:** S0
**Autonomy:** hitl
**Files:** task/review/reference/settings.md (new); personas.md and autorun.md (point at it)
**Done when:** the doc states the setting-versus-preference litmus as its front door; specifies the one trusted home (`~/.claude/` user-global, keyed per project by user-asserted identity) and the untrusted committed-repo tier, and names host memory as the non-Waypoint destination for soft preferences; states that per-project scope comes from keying, not from an in-repo file, reusing (not restating) autorun.md's key-provenance rule and explaining why no in-repo home is introduced (it would contradict crossing 3); and defines the schema as one file with a fenced switch block plus prose (structured key-value read together is one file; documents that accrete independently are directories). personas.md and autorun.md cite it instead of restating it.
**Notes:** personas do not live in this file; they are agents (S3). This file only names the default lens.

### Slice S2 - the switch registry (refactor)
**Depends on:** S1
**Autonomy:** hitl
**Files:** settings.md; autorun.md
**Done when:** the behavior switches (`review.autorun`, `auto-learn`, and later the chain switch) all read from one `off/suggest/auto` enum defaulting to `suggest`, so `autorun` gains an explicit `off` while its live behavior for `suggest` and `auto` stays byte-identical to today; `review.persona` stays a string (a lens name, not the enum); all resolve through the user-global home this spec builds (realizing autorun.md's already-deferred home, not aliasing an existing entry); the per-project block carries each switch as one entry keyed by user-asserted identity, resolved independently so no combination contradicts; no reader gains a new hard dependency.
**Out of scope:** `concerns: auto-emit` does not move here (project tier-detection marker, internals/engagement/README.md tier detection, repo-authored and project-scoped).
**Regrill:** adding `off` to autorun does not change its `suggest`/`auto` behavior or its fail-safe default; no reader hard-depends on the new home; a persona can never carry a switch; and the project tier marker is untouched.

### Slice S3 - personas as per-user agents, and the authoring grill
**Depends on:** S1
**Autonomy:** hitl
**Files:** personas.md (resolution rewritten onto the agents directory, shared `PERSONAS.md` retired); what-it-checks.md (a persona is a weighting over the standard categories); CONTRIBUTING.md (the "Authoring a persona" section, lines 239-249, rewritten to the agents model with no shared persona file); internals/engagement/review-safety.md (crossing 2: rewritten to trusted-only sourcing on every path - the repo tier is dropped, not relocated); task/review/reference/persona-grill.md (new); task/review/SKILL.md (offer "create a lens", one line)
**Done when:** `/review <name>` runs the matching agent; the trusted tiers are the built-in `reference/personas/` question-files plus `~/.claude/agents/`, and Waypoint sources a persona only from these two, on every path; a repo's `.claude/agents/` is never a Waypoint persona source under any name, by hand or automatically, enforced by resolution reading the persona from a trusted absolute path (`~/.claude/agents/<name>` or a built-in) rather than dispatching a bare name through host resolution; crossing 2 is rewritten (superseding the earlier rename-to-repo draft) so the repo tier is dropped rather than relocated, and the crossing stays live and stricter (trusted-only on both paths); there is no shared `PERSONAS.md` anywhere and personas.md, CONTRIBUTING.md, and section 14 all reflect its retirement; an unknown name falls back to the default lens with a note; the authoring grill forces domain, three failure modes, lens boundary, and citation basis, writes an agent file to `~/.claude/agents/`, and refuses an ungrounded vibe lens.
**Regrill:** a repo persona is never a Waypoint review lens - not auto-invoked and not hand-resolved through `/review` - guaranteed by the trusted absolute path Waypoint reads, not by the host's resolution order; section 14 is not edited ahead of the retirement it describes.
**Notes:** the built-in `reference/personas/` folder stays portable question-files, unaffected by the agents-directory reuse, so built-ins work on adapters with no agents directory.

### Slice S4 - reviewed-state, the double-review guard
**Depends on:** S1
**Autonomy:** hitl
**Files:** task/review/reference/reviewed-state.md (new); task/review/SKILL.md; project/wrapup/SKILL.md (Exit); project/ship/SKILL.md (reads it as a non-blocking suggestion only, honoring ship's "does not review" boundary)
**Done when:** reviewed-state is pinned to the diff snapshot (a commit or diff hash), kept in the user-global trusted config keyed by (project identity, diff hash) - the same home and key-provenance as the switches, and for the same crossing-3 reason (suppressing a review reduces scrutiny) - distinct from the session-only findings note and from wrapup's gate verdict, and never read from a repo-authored marker; wrapup and the pre-ship moment defer to a suggestion when the current diff is already reviewed and re-open eligibility when it changes; an explicit `/review` always runs.
**Regrill:** a repo cannot pre-mark itself reviewed to skip its own auto-review.

### Slice S5 - the preferences router and the narrow escape hatch
**Depends on:** S0, S1
**Autonomy:** hitl
**Files:** settings.md; the skill that handles "remember this" (task/review/SKILL.md or a dedicated flow)
**Done when:** on "remember X," the flow first routes to a typed home (architecture, convention, scope, glossary), then to host memory if it is soft working style, and only what none of those wants is written to the narrow personal note in the user-global config, keyed to the project; every write goes through propose-in-chat, confirm-in-chat, then write; observed content may prompt the question but only your confirmed answer is stored; the forget path is low-ceremony.
**Regrill:** the strongest pass - an inferred-from-repo preference cannot be written without a fresh chat confirmation, and the router genuinely prefers a typed doc over the escape hatch (the hatch is the last resort, not the first).

### The seam this layer leaves
The chain / pipeline preference - how far a confident user lets `spec -> breakdown -> ... -> ship` auto-advance - is its own spec.
It plugs into S1's switch registry as one more switch, exactly as `autorun` does, and by construction it never removes a safety stop-point: a chain compresses navigation, never judgment.
It halts at every existing hard gate (a `hitl` change, a failed build, an open blocking concern), and it treats an unreviewed diff as a stop-to-suggest, consistent with review being suggested and never forced.
This layer only leaves the labeled seam.

## Decisions resolved (for the record)

Grilled inline and settled, recorded so the spec is a contract, not a re-litigation.

1. **Home and trust boundary.**
   All trusted content - switches, reviewed-state, the narrow personal note - lives in the user-global config (`~/.claude/`), keyed per project by user-asserted identity, exactly the pattern autorun.md already defines.
   An earlier draft used an in-repo gitignored `docs/_local/` for visibility; a build review showed that contradicts section 14 crossing 3 ("never in a file inside the repo under review"), and that making an in-tree trusted home safe would require redefining section 14's trust cut - surgery this design refuses.
   Worktree-path keying already delivers the only thing the in-tree home bought ("does not follow me to another machine"), and visibility comes from the artifacts manifest's `(local)` tag, not from co-location.
2. **One file for the switches.**
   One `settings.md` with a fenced switch block plus prose, following the general rule: structured key-value read together is one file; documents that accrete independently (the personal note, reviewed-state entries) are directories.
3. **One vocabulary for behavior switches.**
   `off / suggest / auto`, default `suggest`, shared by `autorun`, `auto-learn`, and the future chain switch, rather than a bespoke shape each.
   This brings `autorun` into the vocabulary (it gains `off`); its `suggest`/`auto` behavior and fail-safe default are unchanged.
4. **The registry ships now, not later.**
   Justified by stated demand (auto-learn and chaining are named wants), not speculation.
   It realizes the user-global home autorun.md already specifies as deferred, so the switches simply gain the home they were always meant to have; no new trust boundary is introduced, so "ship now" outruns nothing.

## Open for your review

None blocking. The remaining choices (auto-learn's home as per-project vs a global default; whether the chain switch is per-project or global) belong to the chain spec and the auto-learn wiring, not to the trust layer this spec settles.
