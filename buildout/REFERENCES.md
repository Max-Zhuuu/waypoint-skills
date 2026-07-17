# Buildout References

Loaded on demand by `/buildout` phase files. Named patterns and testing techniques the agent should cite when making recommendations. Each one addresses a specific failure mode in greenfield product development.

## Product Strategy

### Shape Up (Basecamp)
Fixed time, variable scope. Set an *appetite* ("we'll spend 2 weeks on this, max") instead of an *estimate* ("this will take 2 weeks"). The appetite constrains scope - if the feature can't fit in the appetite, cut scope, don't extend the timeline. Progress is tracked on a hill chart: uphill = figuring out the approach, downhill = executing it. Most stalls happen because the team is still going uphill but thinks they're building.
**When to cite:** Phase 2 MoSCoW, Phase 3 scope decisions. When the user wants to add "one more feature" to the MVP, respond with appetite: "Is this worth another week, or should we ship what we have?"

### Build-Measure-Learn (Lean Startup / Ries)
The learning loop: build the smallest thing that tests your riskiest assumption, measure whether the assumption holds, learn and adjust. Most teams build too much before measuring. The insight isn't "move fast" - it's "learn fast." A landing page that gets no signups teaches you more than a polished app that gets no signups, and it costs 100x less.
**When to cite:** Phase 2 discovery, when validating assumptions. Push back on building production code to test an assumption that a conversation or prototype could test.

### Jobs to Be Done (Christensen / Moesta)
People don't buy products - they hire them to do a job. "I need a quarter-inch hole" not "I need a quarter-inch drill." The job has a context (when/where), a motivation (what progress are they trying to make), and constraints (what's stopping them). Features that serve the job get used; features that serve the product's vision don't.
**When to cite:** Phase 2 persona and feature prioritization. When the user proposes a feature, ask: "What job does the user hire this feature to do?" If the answer is vague, the feature isn't ready.

### Kano Model
Features fall into three categories: **must-be** (expected - users don't notice them but rage when they're missing, e.g. a working back button), **one-dimensional** (more is better - users consciously evaluate these, e.g. search speed), **attractive** (delighters - users don't expect them but love them, e.g. keyboard shortcuts). Prioritize must-be first (their absence kills adoption), then one-dimensional (they drive preference), then attractive (they drive loyalty). Most MVPs over-invest in attractive features and under-invest in must-be.
**When to cite:** Phase 2 MoSCoW sorting. A feature that feels "boring" but is must-be ranks above a feature that feels "exciting" but is attractive.

## Architecture Patterns

### Start with a Monolith (Fowler, Newman)
Don't start with microservices, micro-frontends, or distributed architecture. Start with a monolith. You don't yet know where the boundaries are - premature decomposition creates distributed coupling, which is worse than monolithic coupling because it's harder to refactor. Extract services only when you feel specific pain: a module that deploys on a different cadence, a component that needs independent scaling, a team boundary that maps to a code boundary.
**When to cite:** Phase 3 architecture checkpoint. When the user proposes splitting into services or packages before the first feature works end-to-end.

### Vertical Slice Architecture (Cogan)
Organize code by feature, not by layer. Instead of `controllers/`, `services/`, `repositories/` folders where a single feature's code is scattered across the tree, put everything for one feature in one place. Each feature is a vertical slice through all layers. Makes it easy to add, modify, or delete a feature without touching unrelated code. Doesn't require microservices - works fine in a monolith.
**When to cite:** Phase 3, when deciding project structure. Especially for projects with many independent features that different agents might build in parallel.

### Make the Change Easy, Then Make the Easy Change (Beck)
When a change is hard, don't force it. First, refactor until the change is easy (this might be the bulk of the work). Then make the now-easy change. Applied to greenfield: if adding a feature requires changing 8 files, the architecture is fighting you. Fix the architecture, then add the feature.
**When to cite:** Phase 3 architecture checkpoint, when a pattern feels forced.

## Testing Techniques

### Testing Trophy (Kent C. Dodds)
Inversion of the testing pyramid for frontend-heavy applications. Most value comes from **integration tests** (test user workflows through multiple components), not unit tests (test isolated functions). The trophy shape: a few E2E tests at the top, a thick band of integration tests in the middle, some unit tests for complex logic, and static analysis (TypeScript, ESLint) at the base catching the rest. Write the test the way the user uses the feature.
**When to cite:** Phase 3 MVP build. For greenfield, integration tests give the most confidence per test written. Don't unit-test a component that only integration tests would meaningfully exercise.

### Smoke Tests
The smallest set of tests that prove the app isn't fundamentally broken. Hit the main entry points, verify they render without crashing, confirm the critical path works end-to-end. Not comprehensive - just a "did we break the building" check. Takes 30 seconds to run, catches 80% of "I shipped a white screen" disasters.
**When to cite:** Phase 4 ship checklist. The first thing to automate in CI. If you only have time for one test, make it a smoke test of the happy path.

### Hypothesis-Driven Testing
Before writing a test, state the hypothesis: "If the user does X, then Y should happen because Z." Tests that don't defend a hypothesis tend to test implementation details (how the code works) rather than behavior (what the user experiences). Implementation tests break on refactors; behavior tests break on bugs.
**When to cite:** Phase 3-4, when deciding what to test. Especially useful for hobby projects where testing time is scarce - test the behaviors that would hurt most if broken.

### Exploratory Testing (Bach, Bolton)
Structured improvisation: use the product with intent to break it, but without a script. Vary inputs, interrupt workflows, use the back button, resize the window, paste unexpected data. Discoveries feed back into the spec (as edge cases) or the test suite (as regression tests). Finds the bugs that scripted tests miss because the script was written by the same person who wrote the code.
**When to cite:** Phase 4 feedback round. When the user demos to someone, that person is doing exploratory testing whether they know it or not. Capture what they find.

## Testing Playbook by Phase

| Phase | Primary technique | Why this one |
|-------|------------------|--------------|
| 2 - Discovery | No code tests | Validate assumptions with conversations, prototypes, landing pages. Code is the most expensive test. |
| 3 - MVP build | Integration tests (testing trophy) | Test user workflows, not units. One integration test covering "user creates X, sees it in list, edits it" catches more bugs than 10 unit tests of individual components. |
| 4 - Iterate & ship | Smoke tests + exploratory | Smoke tests in CI prevent shipping broken builds. Exploratory testing during feedback rounds catches what automation misses. |

## Process References

### Appetite vs Estimates (Shape Up)
An estimate says "this is how long it will take." An appetite says "this is how long we're willing to spend." Estimates are predictions (usually wrong). Appetites are decisions (always right, because you chose them). When the work exceeds the appetite, cut scope - don't extend the timeline. This forces prioritization: what's the simplest version that still solves the problem?
**When to cite:** Any scope discussion. When the user says "this will take a week," reframe: "Are you willing to spend a week on this? What's the 2-day version?"

### "If you're not embarrassed by your first release, you shipped too late" (Reid Hoffman)
The MVP is supposed to be incomplete. If it has every feature you want, you spent too long building before learning. The goal is to learn what users actually need, which you can only discover by putting something in their hands. Every day spent polishing before shipping is a day spent guessing instead of knowing.
**When to cite:** Phase 3 "when to stop," Phase 4 ship checklist. When the user resists shipping because "it needs one more thing."
