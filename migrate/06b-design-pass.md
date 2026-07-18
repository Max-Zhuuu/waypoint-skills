# Phase 6b - Design Pass

**Goal:** formalize the design system and implement UX improvements. Two sequential sub-phases.

Only begin after Phase 6a gate is met. This is the reward for disciplined parity work.

Design exploration during build phases (3-5) is encouraged but unmanaged - ideas captured in docs/improvements/, experiments on design branches, nothing merges until this phase.

## Sub-phases

### 6b-i: Design System (shared - both migrate and buildout)

Formalize the token system, close gaps, establish density variants.

### 6b-ii: UX Improvements (migration-only)

Structured top-down refinement of the complete product surface: macro -> meso -> micro.

---

## 6b-i: Design System

### Checkpoints

#### CP1: Component taxonomy audit
- **Trigger:** before any token work begins
- **References:** all feature specs, built components, existing tokens.css
- **Action:** produce docs/design/COMPONENT-TAXONOMY.md. Categorize every distinct component type (not instance) with: category, types, count, token surface (which token categories each type consumes).
- **Pass:** taxonomy covers all component types in the product. Every type has its token surface mapped.

#### Post-token (per token category)
- **Trigger:** after formalizing tokens for a component category
- **Action:** run doc sync. Update DESIGN-SYSTEM.md with new token definitions. Verify zero hardcoded values remain in components of this category.
- **Pass:** all components in the category consume only semantic tokens.

### Process

#### Step 1: Audit

Read COMPONENT-TAXONOMY.md. For each component type, list which tokens it currently consumes. Identify:
- **Overloaded tokens** - one token serving two semantically different purposes
- **Hardcoded values** - components using raw values instead of tokens
- **Missing tokens** - semantic gaps where a token should exist but doesn't

Output: `docs/design/TOKEN-AUDIT.md`

#### Step 2: Semantic layering

Define the token architecture:
- **Global tokens** - raw palette values, type scale steps, spacing scale. Named by value (`--blue-600`, `--space-3`).
- **Semantic tokens** - alias globals by purpose (`--color-primary: var(--blue-600)`). Components consume these.
- **Component tokens** (optional) - per-component overrides when semantic doesn't fit (`--ribbon-height: 48px`).

#### Step 3: Density variants

Define compact/comfortable/spacious modes by swapping spacing and sizing semantic tokens. Color and typography stay constant across density modes. Each mode: token overrides on `[data-density="comfortable"]`.

#### Step 4: Prototype and compare

Use DesignPanel to toggle between density modes and token variants on real screens. Tag each variant (`design/{nn}-density-compact`, etc.). The winner is the one that performs best on the densest screen in the product.

### Documentation

- Absorb `docs/design/LAYOUT-AND-STYLING.md` into `docs/design/DESIGN-SYSTEM.md` during this sub-phase. Parity norms either become token definitions or get deprecated.
- DESIGN-SYSTEM.md covers: token architecture, density modes, palette intent, typography rationale, how to add a new token correctly.

### Gate (6b-i)

- [ ] Every component in taxonomy consumes only semantic tokens (zero hardcoded values)
- [ ] Density toggle works across all screens without layout breakage
- [ ] TOKEN-AUDIT.md gaps all resolved or deferred with rationale
- [ ] DESIGN-SYSTEM.md written and covers token architecture
- [ ] LAYOUT-AND-STYLING.md absorbed
- [ ] At least one density feedback round with a non-builder

---

## 6b-ii: UX Improvements (migration-only)

### Checkpoints

#### CP1: Design research (per component-level or page-level improvement)
- **Trigger:** before `/prototype` is invoked for any component-level or page-level improvement. Token-level changes exempt.
- **References:** docs/improvements/{entity}.md, CONTEXT.md, comparable enterprise apps
- **Action:** three-step research protocol:
  1. **Reference collection** - 3-5 functional analyses from comparable apps. Store in docs/design/references/{slug}.md. Not screenshots - functional analysis: app, screen, interaction pattern, what works (and why), what doesn't (and why).
  2. **Pattern extraction** - common patterns (table stakes) vs outliers (differentiation opportunities).
  3. **Domain validation** - check patterns against CONTEXT.md and domain model. A generic SaaS pattern might violate maritime domain conventions.
- **Pass:** reference doc exists with 3+ entries, patterns extracted, domain-validated.

#### Impact classification (per improvement)
- **Trigger:** during research step 3 (domain validation) when a backend dependency is discovered
- **Action:** classify the improvement:
  - **Tier 1 (frontend-only):** no API/DB changes. Proceed.
  - **Tier 2 (API-shape change):** write design brief + data contract in docs/local/handoffs/api-contracts/. Build against mock. Don't block.
  - **Tier 3 (schema/logic change):** invoke /grill-with-docs for ADR. Write handoff in docs/local/handoffs/schema-changes/. Pause this improvement until ADR resolved.
- **Pass:** tier classified, handoffs written if needed, work unblocked or paused with rationale.

### Improvement promotion

Improvements from docs/improvements/ promote into 6b-ii at three tiers:

| Tier | Spec needed? | Research depth | Prototype tool |
|------|-------------|----------------|----------------|
| Token-level (color, spacing, typography) | No | Lightweight (2-3 reference app screenshots) | Direct implementation |
| Component-level (new control, enhanced behavior) | /prototype first, brief spec if validates | Moderate (2-3 apps, functional analysis) | /prototype |
| Page-level (new layout, navigation, workflow) | /spec required | Deep (competitive feature matrix, user flow mapping) | /prototype |

Aesthetic and functional enhancements at the same tier run concurrently on the same design branch.

### Interaction refinement levels

Work top-down. Macro invalidates meso; meso invalidates micro.

**Macro (page flow):** navigation patterns, drill-down sequences, breadcrumb behavior, tab vs inline vs modal. Research checkpoint fires. Feedback via multi-step workflow observation with non-builder.

**Meso (component behavior):** table sorting/filtering/selection, card expand/collapse, form validation timing, inline editing lifecycle. Research checkpoint fires. Feedback via focused task-completion testing.

**Micro (feedback and polish):** hover states, focus rings, transition timing, loading indicators, toast messages, empty states. No research checkpoint. Self-validated against reference docs.

### Branch model

One branch per scope tier: `design/tokens` (6b-i), `design/components`, `design/pages`. Tokens merges first. Components and pages consume it. Tags (`design/{nn}-{slug}`) for archival within each branch. Fallback to single long-lived design branch if the separation creates integration pain.

### Feedback

All feedback flows into FEEDBACK.md with level tags:

```markdown
## {date} - {who} - {test name}

### Level: macro | meso | micro | 6b-i
### What worked
- {observation}

### What confused them
- {observation} -> {actionable annotation, e.g., {token gap: --color-input-readonly}}

### What they asked for
- {request} -> {classification}
```

### Gate (6b-ii)

- [ ] All promoted improvements built or deferred with rationale
- [ ] Macro: at least one navigation feedback round with non-builder
- [ ] Meso: at least one interaction feedback round with non-builder
- [ ] Micro: self-review against reference docs complete
- [ ] No functional regressions (re-run 6a spot checks on modified screens)
- [ ] Feature specs updated for all changed screens (doc sync)
- [ ] Design journal entries for all tried-and-rejected experiments
- [ ] docs/improvements/ fully triaged (every item built, deferred, or killed)
