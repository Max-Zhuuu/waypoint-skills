# Design Skill References

## Vague term resolution table

When the user uses aesthetic language, probe for specificity.
Pin the resolved meaning to a named term in DESIGN-DECISIONS.md's Design Language section.

| User says | Ask | Common resolutions |
|-----------|-----|-------------------|
| "clean" | "Clean as in minimal elements, or clean as in sharp alignment and consistent spacing?" | `minimal` (fewer elements) vs. `precise` (tighter alignment) |
| "modern" | "Modern as in current design trends (rounded, airy), or modern as in not-legacy (any improvement over what exists)?" | `contemporary` (specific trend) vs. `upgraded` (relative improvement) |
| "professional" | "Professional as in conservative/corporate, or professional as in polished/high-craft?" | `corporate` (restrained palette, safe type) vs. `refined` (premium execution, any style) |
| "subtle" | "Subtle as in low-contrast (barely visible), or subtle as in present-but-not-dominant?" | `muted` (reduced contrast) vs. `understated` (secondary hierarchy) |
| "pop" | "Pop as in saturated accent color, or pop as in visual hierarchy emphasis (could be size, weight, position)?" | `vivid` (color saturation) vs. `prominent` (hierarchy emphasis) |
| "minimal" | "Minimal as in fewer UI elements, or minimal as in more whitespace around existing elements?" | `sparse` (fewer elements) vs. `airy` (more breathing room) |
| "bold" | "Bold as in heavy type weight, or bold as in confident/striking overall?" | `heavy` (typographic weight) vs. `assertive` (visual confidence) |
| "warm" | "Warm as in color temperature (yellows, oranges, earth tones), or warm as in approachable/friendly personality?" | `warm-palette` (color direction) vs. `friendly` (personality/tone) |
| "elegant" | "Elegant as in restrained luxury (thin type, generous space), or elegant as in efficient/well-crafted (nothing wasted)?" | `luxe` (refined restraint) vs. `efficient` (purposeful craft) |
| "simple" | "Simple as in fewer features/options shown, or simple as in visually quiet (features present but unobtrusive)?" | `reduced` (fewer visible options) vs. `quiet` (visually restrained) |
| "flat" | "Flat as in no shadows/depth (2D surfaces), or flat as in lacking visual interest (needs more personality)?" | `depthless` (intentional 2D) vs. `bland` (unintentional dullness) |
| "dark" | "Dark as in dark-mode theme, or dark as in moody/serious atmosphere?" | `dark-theme` (technical) vs. `somber` (emotional direction) |
| "light" | "Light as in light-mode theme, or light as in airy/spacious/not heavy?" | `light-theme` (technical) vs. `airy` (spatial quality) |
| "sharp" | "Sharp as in precise edges and corners, or sharp as in high-contrast and crisp?" | `angular` (geometric precision) vs. `crisp` (contrast and clarity) |
| "soft" | "Soft as in rounded corners and gentle curves, or soft as in muted colors and low contrast?" | `rounded` (geometric softness) vs. `muted` (tonal softness) |
| "natural" | "Natural as in organic shapes and earthy palette, or natural as in intuitive/feels obvious to use?" | `organic` (visual direction) vs. `intuitive` (interaction quality) |

This table is a starter set. New resolutions discovered during projects should be logged in the project's `docs/design/TERM-LOG.md` and periodically folded back into this reference.

## Competitive audit structure

When investigating reference tools, document:

```markdown
### {Tool Name}
**Task class:** {what verb does this tool serve}
**URL:** {if public}

**Density:** {compact/default/comfortable, row height estimate, columns visible}
**Typography:** {font families, scale, notable choices}
**Color:** {palette approach, semantic colors, neutral bias}
**Distinctive element:** {what makes this tool visually recognizable}
**What works:** {specific UX wins}
**What doesn't:** {specific UX problems}
**Steal-worthy:** {one concrete idea worth considering}
```

### Reference categories

Match the product's task class to the right reference pool:

| Task class | Reference pool |
|------------|---------------|
| Maritime/shipping operations | Bloomberg Terminal, Flexport, MarineTraffic, IMOS, Veson IMOS, Danaos |
| Financial/trading | Bloomberg, Refinitiv, TradingView, Interactive Brokers |
| Enterprise data management | Salesforce, SAP Fiori, Oracle APEX, ServiceNow |
| Project/task management | Linear, Jira, Asana, Notion, Shortcut |
| Monitoring/observability | Grafana, Datadog, New Relic, PagerDuty |
| Content/publishing | Medium, Ghost, WordPress, Substack |
| Design/creative | Figma, Sketch, Adobe CC, Canva |
| Developer tools | GitHub, GitLab, VS Code, JetBrains |

Don't limit to this table. If the product crosses categories, audit from multiple pools.

## Document templates

### DESIGN-BRIEF.md template

```markdown
# Design Brief

## Product
**Verb:** {monitor/create/browse/...}
**One-line:** {what the product does}
**Users:** {who, how often, how long per session}
**Density:** {compact/default/comfortable} - {rationale}

## Emotional Range

| State | Trigger | Visual character |
|-------|---------|-----------------|
| ... | ... | ... |

## Chosen Direction
**Type:** {display face} + {body face} - {rationale}
**Color:** {palette description, not hex values yet} - {rationale}
**Distinctive element:** {what makes this recognizable}
**Reference touchstones:** {think X meets Y}

## Rejected Directions
### Direction B: {name}
Rejected because: {reason}
Worth revisiting if: {condition}

### Direction C: {name}
Rejected because: {reason}
Worth revisiting if: {condition}
```

### DESIGN-DECISIONS.md template

```markdown
# Design Decisions

## Design Language

Terms pinned during this project. Every token name, component term, and state description draws from this vocabulary.

| Term | Means | Not |
|------|-------|-----|
| `surface-elevated` | Background for raised containers (cards, popovers) | Not `card-background` or `panel-bg` |
| `urgent` | Requires immediate attention (overdue, critical error) | Not `error` or `danger` (those are interaction states) |

## Active Decisions

### DD-001 [settled] {Decision title}
type: {direction/token/pattern/component} | wave: {1/2/3} | decided: {date}
Decision: {what was decided}
Rationale: {why}
Revised: {revision history, if any}

### DD-002 [active] {Decision title}
type: {token} | wave: {2} | started: {date}
Current thinking: {where this stands}
Open question: {what needs resolving}

## Archived Decisions
Moved to `archive/` when superseded. Reference by DD number for history.
```

### TERM-LOG.md template

```markdown
# Design Term Log

New vague-term resolutions discovered during this project.
These expand the skill's built-in reference table over time.

| Date | User said | Resolved to | Named as | Context |
|------|-----------|-------------|----------|---------|
| 2026-07-22 | "make it breathe" | More whitespace between sections, not within components | `section-spacing: loose` | Was ambiguous - component padding was already right, section gaps were too tight |
```
