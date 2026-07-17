# Phase 4 - Iterate & Ship

**Goal:** go from working MVP to shipped product, incorporating feedback.

## Feedback round

Before building more features, get the MVP in front of someone:
- Show it to a potential user, not a fellow developer
- Watch them use it - where do they hesitate, what do they misunderstand?
- Ask: "What's missing?" and "What's confusing?" - not "Do you like it?"

Document feedback in `docs/local/FEEDBACK.md`:

```markdown
## {date} - {who}

### What worked
- {observation}

### What confused them
- {observation} -> {possible fix}

### What they asked for
- {request} -> MoSCoW: {must/should/could/won't}
```

## Re-prioritize

After feedback, revisit the MoSCoW list:
- Did any Should items become Must? (users can't work without it)
- Did any Must items turn out to not matter? (move to Could or Won't)
- Did new features surface that weren't on the list?

Update SCOPE.md. Run `/spec` for new Must items.

## Build Should features

Same process as Phase 3: spec first, build, test, mark complete.
After each feature: is this ready to ship, or does it need more?

## Ship checklist

Lightweight - this isn't enterprise cutover. Scale to the project:

**For hobby/side projects:**
- [ ] Deployed somewhere accessible (Vercel, Netlify, VPS, local network)
- [ ] README explains what it does and how to run it
- [ ] No obvious crashes on the happy path

**For projects with users:**
- [ ] Deployment pipeline works (push to deploy or similar)
- [ ] Error handling covers the common failure modes
- [ ] Data persistence is reliable (backups if applicable)
- [ ] Someone other than you has used it successfully

**For projects that may grow:**
- [ ] Monitoring/logging in place (even basic)
- [ ] Performance acceptable under expected load
- [ ] Security basics covered (auth, input validation, HTTPS)
- [ ] SCOPE.md updated: what's v2?

## After shipping

Run `/reorient` to take stock:
- What did you learn?
- What would you do differently?
- Is this worth continuing, or has the experiment answered its question?

Not every project needs a v2.
Knowing when to stop is as valuable as knowing how to build.
