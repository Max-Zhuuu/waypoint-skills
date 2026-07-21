# Structured Learning

A discipline for learning through real decisions.
Surfaces meaningfully different approaches so you understand why one solution beats another, not just which one to pick.

## Who this is for

Anyone working on a task where more than one approach is reasonable and the trade-offs are not obvious.
If the task is trivial (typo, import reorder, rename), this document is overhead - just do it.
If you are about to pick an approach and cannot articulate why it wins, start here.

## Phase 1 - Scope the task

Before exploring options:

1. Read the code in question and its surrounding context.
2. Identify what needs to happen and the constraints that matter (performance, consistency with existing patterns, API shape, user experience).
3. Check the project's domain glossary for relevant terms.
4. If the intent is unclear, get clarification before proceeding.

## Phase 2 - Present options

Surface exactly 3 meaningfully different approaches.
If only 2 genuinely different approaches exist, present 2. Never invent a filler option.

Each option must differ in its most significant dimension - not syntactic sugar or naming variations, but one of:

- **Algorithm or strategy**: a fundamentally different way to solve the problem (iterative vs recursive, pull vs push, eager vs lazy, event-driven vs polling).
- **Architecture or pattern**: a different structural approach (component split, state management, data flow direction, error handling pattern).
- **Implementation or API**: a different tool, property, or built-in to achieve the effect.

Choose the dimension that teaches the most for the specific task.
The goal is insight, not completeness.

### What makes a good option

Each option needs:
- A short name for the approach.
- One sentence on what it does and one on when it wins.
- A concrete example (code snippet, diagram, or description) showing what it looks like in practice.

### What makes a good recommendation

Mark the recommended option and state why. Prefer the option that is:
1. Most idiomatic for the project's existing patterns.
2. Most maintainable (fewer moving parts).
3. Most robust (handles edge cases not yet mentioned).

A recommendation without reasoning is an opinion.
An opinion without reasoning is a guess.

## Phase 3 - Bridge terminology

In the same response as the options, include a terminology bridge.
List every domain term and technical term that appeared in the options, connecting them:

- **Technical terms**: include what the concept controls, what context it requires, and one common gotcha.
- **Domain terms**: connect to the project's domain language. If a term is already in the glossary, reference it. If not, define it here.
- **Pattern terms**: one sentence on the mental model, one on when to pick it.

Skip terms that any competent practitioner would know.
Explain terms that are specific to a framework, a specification, or the project's domain.

### Further reading

After the terminology bridge, include 2-3 curated links to the most relevant resource for the central concept.

Rules:
- Never more than 3 links. Fewer is better.
- If nothing adds value beyond the terminology explanation, skip this section.
- Only link trusted sources: official specs, platform references, framework docs, known authors in the field. Never link generic tutorial farms, SEO content, or AI-generated aggregators.
- For domain concepts, point to the project's own reference docs if they exist.

## Phase 4 - Apply and update

After a decision is made:

1. Apply the chosen approach.
2. If any project-specific domain terms were explained that are not in the project glossary, add them.
3. Do not add general programming terms to the glossary - only terms specific to the project's domain.

## Phase 5 - Reinforce (opt-in)

After the task is complete, offer reinforcement. The learner can accept or skip.

### Quiz

2-3 quick conceptual questions that test the mental model, not syntax memorization.

- Questions reference the specific concepts from the current task.
- Each question gets 3 choices. Wrong answers should be plausible misconceptions, not obviously absurd.
- After each answer, one sentence connecting back to the code just touched.
- If all correct, acknowledge briefly and move on. If one is missed, explain the gap.

### Practice

Small concrete exercises using real code from the project:

1. **Reference tour**: find 2-3 places in the codebase where the concept is already used. Point to file and line, show a snippet, annotate with one sentence.
2. **Exercises** (2-3, increasing difficulty): apply the pattern in a new context, extend it with a twist, probe a boundary condition.
3. **Check yourself**: key decisions per exercise, common pitfalls.

### Learning notes

After substantial learning output (3+ terms bridged, quiz completed, or exercises generated), save a condensed record:

- Context: what task triggered this, what file.
- Decision: which option was chosen and why.
- Key concepts: term and one-line definition.
- Resources: links used.
- Quiz results and practice pointers if applicable.

These are personal artifacts, not project documentation. Keep them under 40 lines.

## Adapting to your context

### Solo developer

Run this as a written exercise when facing a non-obvious decision.
The act of articulating 2-3 options and picking one with reasoning builds intuition faster than going with your first instinct.
Skip Phase 5 reinforcement unless the concept is genuinely new to you.

### Team session

Phase 2 becomes a team discussion: each person advocates for a different approach.
The terminology bridge (Phase 3) is valuable for teams with mixed experience levels - it levels up everyone's vocabulary.
Phase 5 exercises can become onboarding material.

### With an AI assistant

Have the AI generate options and the terminology bridge.
Challenge the AI on whether options are truly different (it will drift toward syntactic variations).
Own the final decision - the AI's recommendation reflects general best practices, not your project's specific constraints.

### AI agent

The agent runs all phases, presenting options with code previews for the user to choose.
The agent pauses for the user's decision before applying.
After applying, the agent offers reinforcement (quiz, practice) which the user can skip.
The agent saves learning notes when the output warrants it.
