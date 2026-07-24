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
