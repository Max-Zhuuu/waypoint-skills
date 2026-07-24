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
