---
name: how-to-start
description: "Route to the right skill based on project state and user intent. Use when the goal is vague."
status: stable
metadata:
  hermes:
    tags: [routing, discovery, onboarding]
    category: task
  status: stable
---

Context-aware front door to the skill family.
User arrives with something vague. You read project state, classify intent, recommend 1-2 skills, invoke the chosen one.

**Speed constraint:** under 10 seconds to recommendation. This is a skim, not an analysis.

## Step 1: Quick scan

Check for these files. Presence/absence only - don't read contents beyond frontmatter or first heading.
Read [reference/quick-scan.md](reference/quick-scan.md) for the checklist.

## Step 2: Classify intent

Map the user's input to one of these clusters. If ambiguous, pick the most likely and name the alternative.
Read [reference/intent-classification.md](reference/intent-classification.md) for the checklist.

Read [reference/routing-edge-cases.md](reference/routing-edge-cases.md) before proceeding for how to handle no input, conflicting signals, literal skill names, multi-intent input, and file-path input.

## Step 3: Add opinion

Before recommending, check for relevant context that changes the recommendation.
Read [reference/opinion-checks.md](reference/opinion-checks.md) before proceeding.

## Step 4: Recommend and hand off

Present the recommendation:

```
Read: {one-line project state summary}
Recommend: /{skill} - {one-line reason}
{opinion sentence if applicable}
Alternative: /{other-skill} if {condition}

Proceed with /{skill}?
```

**Urgency detection:** if the input reads urgent - imperative tone, profanity, concrete failure described,
"just", "now", "quickly" - skip the recommendation block entirely. Invoke the classified skill immediately.
After the invoked skill completes, append learning points:
- What skill was used and why it fit
- What project context existed (or didn't) that would have changed the approach
- If /setup would have helped, mention it as "for next time" not "you should have"

This is the "teach on the way out" pattern: don't gate action behind learning, but don't waste the moment either.

**Normal pace:** if the input is exploratory - question phrasing, "how should I", "what's the best way" -
present the full recommendation block and wait for confirmation.

If the user agrees (or says nothing contradictory), invoke the skill with their original input.
If the user redirects ("no, I want X"), adjust without arguing.

## Rules

- Don't read file contents beyond what Step 1 specifies. Speed over depth.
- Don't write any files. No state, no logs, no concerns.
- Don't grill. If the user needs grilling, hand off to a skill that grills.
- Don't second-guess. Recommend once, adjust if redirected, move on.
- One clarifying question max. If you can't classify after that, default to /check-in (project exists) or /setup (no project).
- Pass the user's original input to the invoked skill. Don't rephrase or summarize it.
- Never invoke yourself. If you can't classify, fall back to /check-in or /setup, never /how-to-start.

## Tone

Brief. Recommend one skill with one reason, then stop.

## Exit

- Routes to the recommended skill. The routing is the exit.
- On exit, run the shared exit sequence (manifest, then the chain dispatcher): see [the exit sequence](../../internals/engagement/README.md#13-exit-sequence).

## Engagement
See [the engagement protocol](../../internals/engagement/README.md) for the full protocol.
Emits: nothing (read-only routing skill)
Writes: none
Override: full opt-out - no tier detection, no concern emission, no nudging
