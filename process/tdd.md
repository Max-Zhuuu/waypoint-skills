# Test-Driven Development

A discipline for building software where tests come first and drive the design.
Works at any scale - a single function, a service, a full feature - and with any language or framework.

## Who this is for

Anyone building something where correctness matters and the design is not yet settled.
If you are fixing a one-line typo, this document is overhead.
If you are building a feature and don't know where to start, start here.

## The core principle

Tests verify behavior through public interfaces, not implementation details.
Code can change entirely; tests should not.

A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists.
A bad test is coupled to structure: it breaks when you refactor, even though behavior has not changed.

## The anti-pattern: horizontal slices

Do not write all tests first, then all implementation.
This is the most common TDD failure mode and it produces bad tests:

- Tests written in bulk test imagined behavior, not actual behavior.
- You commit to test structure before understanding the implementation.
- Tests become insensitive to real changes - they pass when behavior breaks, fail when behavior is fine.

The correct approach is vertical slices: one test, one implementation, repeat.
Each test responds to what you learned from the previous cycle.

```
Wrong (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

Right (vertical):
  RED->GREEN: test1->impl1
  RED->GREEN: test2->impl2
  RED->GREEN: test3->impl3
```

## Phase 1 - Plan

Before writing any code, establish:

1. **What is the public interface?**
   The interface is what callers see. Methods, parameters, return types.
   Design the interface for the consumer, not the implementation.

2. **Which behaviors matter?**
   You cannot test everything. Identify the critical paths and complex logic.
   A behavior is something the caller or user can observe.
   "Saves to database" is not a behavior. "Created user is retrievable" is.

3. **What is the testing boundary?**
   Decide where your tests stop and external systems begin.
   Everything inside the boundary is real code, not mocks.
   Everything outside is a mock or test double.

4. **How will you know this works in production?**
   What signals will tell you it is broken, and are they already instrumented?
   If the project defines SLIs (check ARCHITECTURE.md or SLOs.md), verify instrumentation covers this change per [process/observability.md](observability.md) Phase 2.
   If no SLIs exist, ask the question and move on.

### Interface design for testability

Three principles make testing natural:

- **Accept dependencies, don't create them.**
  Pass external dependencies in. Code that constructs its own collaborators internally is hard to test.

- **Return results, don't produce side effects.**
  A function that returns a value is easier to test than one that mutates state elsewhere.

- **Minimize surface area.**
  Fewer methods means fewer tests needed. Fewer parameters means simpler test setup.
  A small interface with deep implementation is better than a large interface with thin pass-through logic.

## Phase 2 - Tracer bullet

Write one test that confirms one thing about the system.

```
RED:   Write test for the first behavior. It fails.
GREEN: Write the minimal code to make it pass. It passes.
```

This is your tracer bullet.
It proves the path works end to end: test infrastructure, build pipeline, interface shape.
If this test is hard to write, you have an interface design problem, not a test problem.

## Phase 3 - Incremental loop

For each remaining behavior:

```
RED:   Write the next test. It fails.
GREEN: Write the minimal code to pass. It passes.
```

Rules:
- One test at a time.
- Only enough code to pass the current test.
- Do not anticipate future tests.
- Keep tests focused on observable behavior.

### What to test through the interface

Verify behavior by using the same interface a real caller would use.
If you create a user, verify by retrieving the user - not by querying the database directly.
If you process a payment, verify by checking the order status - not by asserting the payment service was called with specific arguments.

The test should not know about internals.
If renaming a private function breaks a test, that test was testing implementation, not behavior.

### When to mock

Mock at system boundaries only:
- External APIs (payment providers, email services, third-party integrations)
- Infrastructure you don't own (databases are borderline - prefer a test database when practical)
- Non-deterministic inputs (time, randomness)

Do not mock your own code.
Do not mock internal collaborators.
If you control it, use the real thing.

## Phase 4 - Refactor

After all tests pass, look for:

- **Duplication.** Extract common logic. Tests on the public interface survive this.
- **Shallow modules.** Large interface, thin implementation. Combine or deepen.
- **Feature envy.** Logic that reaches into another module's data. Move it closer to the data.
- **Primitive obsession.** Strings and numbers doing the work of value objects.
- **Problems in existing code** that the new code reveals.

Never refactor while red. Get to green first, then reshape.
Run tests after each refactor step. A refactor that breaks tests was not a refactor - it changed behavior.

## Phase 5 - Verify the cycle

After each red-green-refactor cycle, check:

- Does the test describe behavior, not implementation?
- Does the test use the public interface only?
- Would the test survive an internal refactor?
- Is the code minimal for this test?
- Were any speculative features added? Remove them.

## Adapting to your context

### Solo developer

The planning phase is a written exercise: list behaviors, design the interface on paper or in a scratch file.
The discipline of writing the test first still matters solo - it forces you to think about what "done" means before you start.

### Team session

Use Phase 1 as a pairing exercise.
One person writes the test, the other writes the implementation.
Switch roles each cycle.
The test-writer focuses on behavior; the implementer focuses on minimal code.

### With an AI assistant

Have the AI generate test cases from your Phase 1 behavior list.
Challenge the AI on whether each test is truly behavioral (not implementation-coupled).
Use the AI to spot missing edge cases, but own the interface design - the AI will over-engineer it if you let it.

### AI agent

The agent runs the full cycle, presenting the behavior list and interface design for approval before writing code.
Each red-green cycle runs without interruption.
The agent pauses for review after the refactor phase.
When project conventions exist (test file naming, assertion style, test database setup), the agent follows them.
