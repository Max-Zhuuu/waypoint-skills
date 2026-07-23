# Learn Reference

Shared reinforcement protocols for /learn and /diagnose.
Read by skills that offer quiz, practice, or learning note capture.

## Quiz protocol

Present 2-3 quick multiple-choice questions inline (one at a time).

Questions test the **conceptual model**, not syntax memorization:
- "What happens if you apply `gap` to a `display: block` element?" (tests: understanding that gap requires flex/grid context)
- "You set `clamp(1rem, 4vw, 2rem)` on font-size. At a 300px viewport, which value wins?" (tests: understanding the clamp evaluation)
- "A fixture has status 'Voyage Commenced'. Can you still edit its cargo records?" (tests: domain lifecycle understanding)

Rules:
- Questions must reference the specific concepts from the current task - not generic trivia.
- Each question gets 3 choices. Wrong answers should be plausible misconceptions, not obviously absurd.
- After the user answers, give a one-sentence explanation connecting back to the code or bug they just touched.
- If the user gets all questions right, acknowledge it briefly and move on.
- If they miss one, explain the gap and link to the relevant Further Reading resource.
- Never quiz on more than 3 questions. Quick check, not an exam.

## Practice exercises

Generate a single exercise file at `docs/_local/learning/exercises/{date}-{slug}.md`.
Create the directory if it does not exist.

### 1. Reference tour

Find 2-3 places in the actual repo where the concept is already used.
For each:
- `file:line` pointer the user can cmd-click open
- 3-5 line snippet showing the key pattern
- One-sentence annotation

Pick snippets from different files to show how the pattern recurs.

### 2. Exercises

2-3 small concrete tasks, increasing in difficulty:
- **Exercise 1** (apply): reproduce the pattern in a new context.
- **Exercise 2** (extend): add a twist that forces a design choice.
- **Exercise 3** (optional, edge case): probe the boundary.

Rules:
- Each exercise must be specific enough to code against without clarification.
- Reference real repo files where the user can see the pattern.
- Build on the chosen approach, not rejected alternatives.
- Keep the total exercise file under 60 lines.

### 3. Check yourself

Per exercise, a 2-3 line solution approach (key decisions, not full code).
If the concept has a common pitfall, call it out.

### File format

```markdown
# Practice: {Topic}

## Reference tour

### {Pattern name} - `src/path/file.ts:42`
{3-5 line snippet}
{One-sentence annotation.}

## Exercises

### 1. {Verb} - {what to build}
{2-3 sentence instruction. Reference file:line.}

### 2. {Verb} - {what to extend}
{2-3 sentence instruction. State the design choice.}

### 3. (Stretch) {Verb} - {edge case}
{2-3 sentence instruction.}

## Check yourself

**1.** {Key decisions.}
**2.** {Key decisions + why this choice wins.}
**3.** {Key decisions + common pitfall.}
```

## Learning notes

Save a condensed record to `docs/_local/learning/` after substantial output.

### When to save

Save when Terms in play has 3+ entries OR the user completed the quiz OR practice exercises were generated.
Skip when the task was trivial or the terms block was thin.

### File naming

`{date}-{slug}.md` - 2-3 word kebab-case topic.

### File structure

```markdown
# {Topic} - {date}

## Context
{One sentence: what task triggered this, what file}

## Decision
{Which option was chosen and why}

## Key concepts
{Terms in play block, condensed - term: one-line definition}

## Resources
{Further reading links}

## Quiz results
{If taken: questions, answers, gaps. Omit if no quiz.}

## Practice
{If generated: link to exercise file. Omit if no practice.}
```

### Rules

- Create `docs/_local/learning/` if it does not exist.
- Do not duplicate: same topic + same day = append, not new file.
- Keep each file under 40 lines.
- These are gitignored personal artifacts, not project documentation.
