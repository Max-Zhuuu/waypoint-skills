---
name: learn
description: "Learn through any code task with meaningfully different options, trade-off explanations, and terminology bridges."
status: stable
---

Follow the structured learning methodology in [process/learning.md](../../process/learning.md).
Execute each phase using the tools available in this environment.

## Execution notes

### Phase 1 - Scope

Read code context. Grep GLOSSARY.md for domain terms relevant to this area.
If the task is trivial, say so and just do it - do not force options on a non-decision.

### Phase 2 - Present options

Use `AskUserQuestion` with `preview` on each option showing the actual code diff.
Mark the recommended option "(Recommended)" and list it first.

### Phase 3 - Bridge terminology

Include the Terms in play block and Further reading in the same response as the options.
For source trust tiers, see [references.md](reference/references.md#source-trust-tiers).

### Phase 5 - Reinforce

Offer via `AskUserQuestion` with `multiSelect: true`: Quiz, Practice, or skip.
For quiz and practice protocols, see [learn-reference.md](reference/learn-reference.md).

Skip when: the edit was trivial, the user is clearly in a hurry, or the concepts are ones they have demonstrated mastery of this session.

### Phase 6 - Learning notes

Save to `docs/_local/learning/`. Create the directory if needed.
For format and rules, see [learn-reference.md](reference/learn-reference.md#learning-notes).

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: question)
Writes: docs/_local/learning/ (creates, gitignored)
## Exit

When the learning session ends, suggest next steps based on what was learned:
- If the topic relates to a feature -> "/create to apply what you learned, or /spec to scope it?"
- If the topic revealed a gap in project docs -> "/wrapup updates GLOSSARY.md, conventions, and specs with what you learned."
- If the user is exploring broadly -> "Learning captured. Pick another topic, or back to building?"
- On exit, emit the artifacts manifest for the paths this run wrote, per [ENGAGEMENT-REFERENCE.md section 15](../../internals/ENGAGEMENT-REFERENCE.md); a run that wrote nothing prints the empty manifest.
- On exit, after the manifest, run the chain dispatcher for the next hop, per [ENGAGEMENT-REFERENCE.md section 16](../../internals/ENGAGEMENT-REFERENCE.md); a gate (or no clean edge) stops and hands back.

## Tone

Keep it brisk. This is a 60-second decision point, not a lecture.
The user is mid-flow; get them back to building quickly.
