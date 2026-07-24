---
name: learn
description: Learning-oriented approach to any code task - new features, refactors, fixes, design patterns, architecture choices. Presents meaningfully different options with trade-off explanations and a terminology bridge. Use when you want to understand why one solution beats another.
status: stable
---

Does NOT build production code. Teaches through exploration of options and trade-offs.

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
For source trust tiers, see [REFERENCES.md](REFERENCES.md#source-trust-tiers).

### Phase 5 - Reinforce

Offer via `AskUserQuestion` with `multiSelect: true`: Quiz, Practice, or skip.
For quiz and practice protocols, see [LEARN-REFERENCE.md](LEARN-REFERENCE.md).

Skip when: the edit was trivial, the user is clearly in a hurry, or the concepts are ones they have demonstrated mastery of this session.

### Phase 6 - Learning notes

Save to `docs/_local/learning/`. Create the directory if needed.
For format and rules, see [LEARN-REFERENCE.md](LEARN-REFERENCE.md#learning-notes).

## Engagement
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol.
Emits: concerns (type: question)
Writes: none
## Exit

When the learning session ends, suggest next steps based on what was learned:
- If the topic relates to a feature -> "/create to apply what you learned, or /spec to scope it?"
- If the topic revealed a gap in project docs -> "/wrapup updates GLOSSARY.md, conventions, and specs with what you learned."
- If the user is exploring broadly -> "Learning captured. Pick another topic, or back to building?"

## Tone

Keep it brisk. This is a 60-second decision point, not a lecture.
The user is mid-flow; get them back to building quickly.
