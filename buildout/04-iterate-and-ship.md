# Phase 4 - Iterate & Ship

**Goal:** go from working MVP to shipped product, incorporating feedback.

## Checkpoints

### CP1: Pre-build for new Must features
- **Trigger:** before building any new Must feature added during re-prioritization
- **References:** feature spec (from /spec), CONVENTIONS.md
- **Action:** verify spec exists. If new Must item surfaced from feedback: invoke /spec first. Verify naming conventions followed.
- **Pass:** spec exists, conventions checked.

### CP2: Design consolidation (conditional)
- **Trigger:** after a feedback round produces 3+ design-related observations
- **References:** FEEDBACK.md (design-tagged entries), docs/design/references/ (if exists), CONTEXT.md
- **Action:** cluster design feedback by pattern. Synthesize: are individual complaints symptoms of a single design problem? If pattern-level problem detected: invoke research protocol (reference collection, pattern extraction, domain validation) before prototyping a fix. Classify impact (Tier 1/2/3) if cross-boundary work needed. Fold consolidated items back into re-prioritization.
- **Pass:** design feedback clustered, pattern-level problems identified, research complete for any that need it, all items folded into MoSCoW.

### Post-build (per feature)
- **Trigger:** when /tdd reports a feature complete
- **Action:** spawn review agent. Run doc sync. Update SCOPE.md.
- **Pass:** review passed, spec matches build, shared docs current.

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

Same process as Phase 3: spec first (`/tdd`), test, mark complete.
After each feature: is this ready to ship, or does it need more?

Exploratory testing during demos catches bugs scripted tests miss. Capture what they find: bugs become regression tests, confusion becomes UX fixes, missing features feed back into MoSCoW.

### Design system (when design profile is full or lightweight)

After Phase 3 gate, if the intake profile includes design work: run the 6b-i process from `migrate/06b-design-pass.md` (shared). Component taxonomy -> token audit -> semantic layering -> density variants -> prototype and compare.

Design refinement during Phase 4 is feedback-driven, not sweep-driven. No macro->meso->micro ordering - feedback tells you which level the problem is at.

### Ship checklist

Scale to the project:

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
