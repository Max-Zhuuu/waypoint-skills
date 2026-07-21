# Testing

Test expectations for {{project-name}}.
Philosophy: {{integration-first|tdd|structural-enforcement}}.

## By complexity tier

| Tier | What to test | Example |
|------|-------------|---------|
| Smoke | Does it render without crashing? | Mount component, assert no error |
| Structural | Do conventions hold across the codebase? | Lint rules, naming checks |
| Integration | Does a multi-step user flow work? | Login -> navigate -> submit form |
| Unit | Complex logic with edge cases | Calculation functions, state machines |

## Patterns

{{test-patterns-from-grill}}

## What NOT to test

- Framework internals (Vue reactivity, router navigation guards work)
- Trivial getters/setters
- Third-party library behavior
