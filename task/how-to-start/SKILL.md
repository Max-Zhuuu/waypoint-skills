---
name: how-to-start
description: "Context-aware skill router. Reads project state, classifies intent, recommends the right skill with a one-line reason. Use when the user has a vague goal and doesn't know which skill fits."
status: stable
metadata:
  hermes:
    tags: [routing, discovery, onboarding]
    category: task
  status: stable
---

# /how-to-start

Context-aware front door to the skill family.
User arrives with something vague. You read project state, classify intent, recommend 1-2 skills, invoke the chosen one.

**Speed constraint:** under 10 seconds to recommendation. This is a skim, not an analysis.

## Step 1: Quick scan

Check for these files. Presence/absence only - don't read contents beyond frontmatter or first heading.

| Check | What it tells you |
|-------|-------------------|
| CLAUDE.md `## Active Workflow` | Mid-project. Which workflow, which phase. |
| CONCERNS.md | Tracking is active. Grep for items matching the user's topic. |
| SCOPE.md frontmatter | Project exists with defined boundaries. |
| GLOSSARY.md first heading | Domain glossary exists. |
| CONVENTIONS.md | Coding standards exist. |
| TESTING.md | Test strategy exists. |
| docs/specs/ | Feature specs exist. Check if one matches the user's topic. |
| docs/adr/ | Architecture decisions on record. |

Summarize as a one-line project read:
- "No project setup" (none of the above exist)
- "Project setup, no active workflow" (docs exist, no Active Workflow)
- "Mid-workflow: Phase 5 of /migrate" (Active Workflow found)
- "Mature project with concerns tracking" (CONCERNS.md + multiple docs)

## Step 2: Classify intent

Map the user's input to one of these clusters. If ambiguous, pick the most likely and name the alternative.

| Signal in user input | Primary | Alternative | Gate condition |
|---------------------|---------|-------------|----------------|
| broken, wrong, failing, error, bug, flaky, regression | /diagnose | /reorient (if systemic, multi-area) | - |
| build, add, implement, create, feature, wire up | /create | /spec (if underspecified) | If no spec exists for the topic, mention it |
| replace, migrate, port, legacy, old system | /port | /migrate (if no Active Workflow) | Needs Active Workflow + feature spec |
| what next, what should I, pick up, continue, resume | /check-in | /reorient (if disoriented) | - |
| stress-test, review, challenge, grill, is this right | /grill-me | /grill-with-docs (if project docs exist) | - |
| understand, learn, explain, how does, teach me | /learn | /improve-arch (if about structure) | - |
| start, new project, kick off, set up, initialize | /setup | /buildout or /migrate (after setup) | - |
| design system, tokens, colors, typography, visual identity, look and feel | /design | /prototype (if exploring one component) | Needs project context |
| prototype, mock up, try, quick test, experiment | /prototype | - | - |
| find skill, what skills, how to use waypoint | /find-skills | - | - |
| spec, requirements, scope, what should it do | /spec | - | - |
| break down, decompose, slices, implementation plan, build order | /breakdown | - | Needs spec |
| test, tdd, red-green, test-first, coverage | /tdd | - | Needs spec or clear scope |
| done, wrap up, finished, ship it, close out | /wrapup | - | - |

**No input:** if the user types just `/how-to-start` with nothing after it, run Step 1 (quick scan) and respond
based on project state:
- Active Workflow exists -> "You're mid-workflow. /check-in to resume? Or: /diagnose for bugs, /spec for features, /design for visual system, /learn to understand something. /find-skills to browse everything."
- CONCERNS.md has open items -> "You have {n} open concerns. /check-in to triage, or tell me what you're working on. Also: /diagnose, /spec, /design, /learn. /find-skills to browse everything."
- Project docs exist but no workflow -> "Project is set up. What are you trying to do? /diagnose for bugs, /spec for features, /tdd to build test-first, /design for visual system, /learn to understand something. /find-skills to browse everything."
- Nothing exists -> "No project context yet. What are you working on? /setup to establish scope, or jump straight in: /diagnose for bugs, /spec for features, /learn to understand something. /find-skills to browse everything."

One question, then classify whatever they say.

**Priority rule:** when signals conflict, action verbs beat framing verbs.
"understand why X is broken" = /diagnose (broken wins). "learn about how auth works" = /learn (no failure).
The distinguisher: is there a concrete failure or just curiosity?

**Literal skill name:** if the input is just a skill name ("how-to tdd", "how-to diagnose"),
skip Steps 1-3 and invoke the skill directly. The router adds nothing when the user already knows.

**Multi-intent:** if the input contains two tasks ("fix the auth bug and add the news feed"),
pick the first or most urgent, recommend it, and acknowledge the second as a follow-up.
Don't try to sequence a plan - that's /check-in's job.

**File path as input:** if the input is or contains a file path ("how-to src/components/NewsFeedWidget.vue"),
check if the file exists. If it does, infer intent from the file type and any surrounding words:
- Source file + no verb -> "What do you want to do with this file? Build on it, fix something, or understand it?"
- Source file + action verb -> classify normally using the verb
- Spec file (docs/specs/*.md) -> "You have a spec. /tdd to build it?"
- Feature doc (docs/wpf-reference/features/*.md) -> "Migration target. /port to build it?"

If the input doesn't match any cluster, ask one clarifying question. Not a grill - one question.

## Step 3: Add opinion

Before recommending, check for relevant context that changes the recommendation:

- **Matching spec exists** -> "You have docs/specs/{topic}.md. /tdd to build it, or /spec to revise scope?"
- **Open concerns on this topic** -> "C-{id} is related: '{description}'. Resolve first or build around it?"
- **No project docs + recommended skill is project-layer** (check-in, wrapup, reorient, buildout, migrate) -> "No project setup detected. /setup first?"
- **No project docs + recommended skill is task-layer** -> skip this opinion. Task skills work standalone. Don't suggest setup when someone just wants to fix a bug.
- **Active Workflow exists** -> "You're in Phase {n} of /{workflow}. /check-in to resume?"
- **Topic matches a concern type:question** -> "There's an open question about this (C-{id}). Worth resolving before building."

State the opinion in one sentence. Don't lecture.

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

## Engagement

No tier detection. This skill works identically regardless of project maturity.
If CONCERNS.md exists, grep it for topic relevance. Otherwise ignore engagement tiers.
See [ENGAGEMENT-REFERENCE.md](../../internals/ENGAGEMENT-REFERENCE.md) for the full protocol (this skill opts out).

- **Emits:** nothing (read-only routing skill)
- **Scaffolding writes:** none
- **Override:** full opt-out - no tier detection, no concern emission, no nudging
