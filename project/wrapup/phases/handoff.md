# Handoff Mode

Write a continuity document so a fresh agent can pick up where this session left off. Then output a boot prompt the user pastes into the next session.

Runs after wrapup's concern resolution (steps 1-6) so the handoff reflects resolved state, not stale concerns.

## Pick a target

- **Session** (default) - agent-to-agent continuity. Saved to `docs/_local/handoffs/{date}-{slug}.md`. Gitignored, ephemeral. Use this unless the content is clearly a cross-team contract.
- **Team** - cross-team contract or blocked-work spec. Saved to `docs/implementation/handoffs/{slug}.md`. Committed, durable.

Infer from context. If ambiguous, ask.

## Write the document

1. **Status** - one line: current state of the work
2. **Done** - completed actions with file paths
3. **Unfinished** - what remains, with enough context to resume cold
4. **Decisions** - non-obvious choices made this session and why
5. **Open questions** - unresolved items; link to CONCERNS.md entries if they exist
6. **References** - paths to specs, ADRs, concerns, commits. Do not duplicate their content.
7. **Suggested skills** - which waypoint skills the next session should invoke and why

If the user described a focus for the next session, tailor sections 3-7 to that focus.
Redact secrets (API keys, passwords, PII).

## Boot prompt

After saving, output a boot prompt as a fenced code block. Four sentences max:

1. What the work is (noun phrase)
2. Where the handoff lives (path)
3. Which skill to invoke and with what focus (e.g., `/check-in` to orient, `/tdd FeatureX` to resume building)
4. What to watch out for (one constraint or gotcha)
