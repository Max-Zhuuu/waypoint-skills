# Phase 4 - Iterate & Ship

**Goal:** go from working MVP to shipped product, incorporating feedback.

## Checkpoints

### CP1: Pre-build for new Must features
- **Trigger:** before building any new Must feature added during re-prioritization
- **References:** implementation verb's declared inputs (frontmatter contract)
- **Action:** verify all required inputs exist. If new Must item surfaced from feedback: invoke /spec first.
- **Pass:** all verb inputs satisfied.

### CP2: Design consolidation (conditional)
- **Trigger:** after a feedback round produces 3+ design-related observations
- **References:** FEEDBACK.md (design-tagged entries), docs/design/references/ (if exists), CONTEXT.md
- **Action:** cluster design feedback by pattern. Synthesize: are individual complaints symptoms of a single design problem? If pattern-level problem detected: invoke research protocol (reference collection, pattern extraction, domain validation) before prototyping a fix. Classify impact (Tier 1/2/3) if cross-boundary work needed. Fold consolidated items back into re-prioritization.
- **Pass:** design feedback clustered, pattern-level problems identified, research complete for any that need it, all items folded into MoSCoW.

### Post-build (per feature)
- **Trigger:** when implementation verb reports complete
- **References:** CONCERNS.md (entity concerns), SCOPE.md, CONVENTIONS.md
- **Action:** verb suggests /wrapup. If invoked: resolves concerns, cascades, updates SCOPE.md.
- **Pass:** /wrapup resolved concerns (or concerns persist for next session).

## Process

### Feedback round

Before building more features, get the MVP in front of someone:
- Show it to a potential user, not a fellow developer
- Watch them use it - where do they hesitate, what do they misunderstand?
- Ask: "What's missing?" and "What's confusing?" - not "Do you like it?"

Document feedback in `FEEDBACK.md`:

```markdown
## {date} - {who}

### Level: macro | meso | micro
### What worked
- {observation}

### What confused them
- {observation} -> {possible fix}

### What they asked for
- {request} -> MoSCoW: {must/should/could/won't}
```

### Re-prioritize

After feedback, revisit the MoSCoW list:
- Did any Should items become Must?
- Did any Must items turn out to not matter?
- Did new features surface that weren't on the list?

Update SCOPE.md. Run `/spec` for new Must items.

### Build Should features

Same process as Phase 3: spec first, invoke implementation verb, /wrapup, mark complete.
After each feature: is this ready to ship, or does it need more?

Demos catch issues that automated tests miss. Capture what users find: bugs become regression tests, confusion becomes UX fixes, missing features feed back into MoSCoW.

### Design system (when "design-system" archetype is selected)

After Phase 3 gate, run the 6b-i process from `project/migrate/06b-design-pass.md` (shared). Invoke user's design methodology skill via AskUserQuestion.

Design refinement during Phase 4 is feedback-driven, not sweep-driven. Feedback tells you which level the problem is at.

### Ship checklist

Re-confirm the ship tier set during /buildout setup via AskUserQuestion:

**"You set this as '{tier}' tier. Still right?"**
- **Yes, {current tier}**
- **Change to {other tiers}**

Then apply the checklist for the confirmed tier:

**For hobby/side projects:**
- [ ] Deployed somewhere accessible
- [ ] README explains what it does and how to run it
- [ ] No obvious crashes on the happy path

**For projects with users:**
- [ ] Deployment pipeline works
- [ ] Error handling covers common failure modes
- [ ] Data persistence is reliable
- [ ] Someone other than you has used it successfully

**For projects that may grow:**
- [ ] Monitoring/logging in place
- [ ] Performance acceptable under expected load
- [ ] Security basics covered (auth, input validation, HTTPS)
- [ ] SCOPE.md updated: what's v2?

## After shipping

Run `/reorient` to take stock:
- What did you learn?
- What would you do differently?
- Is this worth continuing, or has the experiment answered its question?

Not every project needs a v2.

## Gate

- [ ] All Must and prioritized Should features built
- [ ] At least one feedback round completed with a non-builder
- [ ] Design consolidation checkpoint passed (if 3+ design observations)
- [ ] Ship checklist appropriate to project scale completed
