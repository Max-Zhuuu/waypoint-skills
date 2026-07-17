# Phase 2 - Discovery & Validation

**Goal:** confirm you're building something worth building before writing production code.

## Who is this for?

Define a specific persona, not "users." One paragraph covering:
- Role or situation (hobbyist sailor, fleet accountant, solo founder)
- Current pain (what they do today that's painful or impossible)
- What they'd pay attention to (not money necessarily - time, switching cost, learning curve)

If you can't describe one real person who wants this, the idea isn't ready.

## What's the riskiest assumption?

Every product idea rests on assumptions. Rank them by risk (if wrong, the product fails):

| Assumption | Risk | How to test | Cost to test |
|-----------|------|-------------|--------------|
| People manually track X | High | Ask 3 people | 1 hour |
| They'd switch from Y | Medium | Landing page | 1 day |
| The data is available via API | Low | Test call | 30 min |

Test the highest-risk assumption first. The cheapest tests:
1. **Conversation** - talk to someone who has the problem (free)
2. **Prototype** - clickable mockup or HTML sketch (hours, invoke `/prototype`)
3. **Landing page** - describe the product, measure interest (1 day)
4. **Vertical spike** - build one thin feature end-to-end (days)

Code is the most expensive test. Use it last.

## Competitive scan

Brief, not exhaustive. Answer three questions:
1. What exists today that partially solves this? (direct competitors, workarounds, spreadsheets)
2. Why is it insufficient? (missing feature, wrong audience, too expensive, too complex)
3. What's your unfair advantage? (domain knowledge, existing user base, technical capability, willingness to serve a niche)

If there's nothing in the space at all, that's a signal worth examining - maybe nobody wants it.

## Feature brainstorm -> MoSCoW

List every feature idea, then sort into:
- **Must** - without this, the product doesn't solve the core problem
- **Should** - significantly improves the product, do it soon after MVP
- **Could** - nice to have, do if time allows
- **Won't (v1)** - explicitly deferred, may revisit later

Move items from Must to Should aggressively. A 3-feature MVP ships; a 12-feature MVP doesn't.

Add Must and Should items to SCOPE.md (In / Out).
Run `/spec` for each Must item.

## Gate

- [ ] Persona defined (specific, not generic)
- [ ] Riskiest assumption identified and tested (or test plan documented)
- [ ] At least one competitor/alternative analyzed
- [ ] MoSCoW completed, Must items have specs via `/spec`
- [ ] SCOPE.md updated with feature decisions
