# Wave 1 - Soul

Find the product's design identity. This wave is explosive - breadth over depth.

## Step 1: Product verb

Every product has a primary verb. Identify it.

- **Monitor/decide/act** - operational tools, dashboards, control systems
- **Browse/discover/consume** - content platforms, marketplaces, feeds
- **Create/edit/publish** - authoring tools, editors, design tools
- **Communicate/collaborate/share** - messaging, project management
- **Configure/manage/maintain** - admin panels, settings, infrastructure

The verb shapes everything: density, hierarchy, color semantics, motion philosophy.
A monitoring tool needs glanceable density and semantic status colors.
A creation tool needs generous canvas space and unobtrusive chrome.

State the verb. Ask the user to confirm or adjust.

## Step 2: Competitive audit

Identify 3-5 tools in the same task class. Not aesthetic inspiration - functional peers.

For a shipping VMS: Bloomberg terminal, Flexport dashboard, Maersk operations, MarineTraffic, IMOS.
For a project management tool: Linear, Jira, Asana, Shortcut.
For a content platform: Medium, Substack, Ghost.

For each reference:
- What density model do they use?
- How do they handle the primary verb?
- What's their emotional range?
- What's distinctive vs. generic about their visual language?

Document findings in `docs/design/RESEARCH.md`. Include screenshots or URLs where possible.
When something "doesn't feel right" later in the process, return here and investigate.
Flag findings explicitly: "Bloomberg uses monospace for all numerical data - this prevents column misalignment when values change. Worth adopting? Reference: Bloomberg Terminal position blotter."

See [REFERENCES.md](../reference/references.md) for the competitive audit structure and reference category table.

## Step 3: Emotional range mapping

Most products have 3-5 emotional states the user moves through. Map them:

| State | When it happens | Visual character |
|-------|----------------|-----------------|
| Calm monitoring | Default state, scanning data | Neutral palette, even hierarchy |
| Focused entry | Filling forms, editing records | Reduced chrome, clear field boundaries |
| Urgent attention | Alerts, overdue items, errors | Semantic color, elevated prominence |
| Confirmation/success | Completed actions, saved states | Brief positive signal, then return to calm |
| Decision point | Choosing between options, approvals | Clear comparison layout, action prominence |

The user's product may have different states. Ask: "Walk me through a typical session. What emotional states does the user move through?"

## Step 4: Density decision

This is a first-class design decision, not a toggle added later.

- **Compact** - 8+ rows visible without scrolling, tight padding, small type. For power users in the app 8 hours/day.
- **Default** - 5-7 rows visible, comfortable padding, standard type. For regular users with moderate data.
- **Comfortable** - 3-5 rows visible, generous padding, large type. For occasional users or consumer products.

One density is primary. Others are optional future modes.
If replacing a desktop application: compact is almost always correct. Desktop users will revolt at airy web spacing.

## Step 5: Parallel directions

Produce 3 distinct design directions. Each direction includes:
- Type pairing (display + body, with rationale)
- Color direction (roles and mood, not final hex values)
- Density expression (how the chosen density model manifests)
- One distinctive element (what makes this direction recognizable)
- Reference touchstone ("think X meets Y" with concrete examples the user can look at)

Present all three side by side. Ask the user to react:
- Which direction resonates most?
- Any elements from the others worth carrying over?
- What's missing from all three?

Synthesize feedback into a single direction. This becomes the brief.

**Prototype trigger:** after presenting the three directions, eagerly invoke `/prototype` for the one the user leans toward.
Don't wait for final confirmation - seeing it rendered changes the conversation.
Pass the direction description and competitive research as context.

Prototypes should be isolated HTML files with mocked data and logic - easily modified alongside the design without touching the real codebase.
Place key components on the prototype to test how system elements (tables, forms, status indicators) feel within the direction.

## Step 6: The indulgence gate

Before finalizing any direction, ask explicitly:
"Is this solving a real UX problem for your users, or is it aesthetic indulgence?"

This is not judgment. It's a forcing function for honest design decisions.
Aesthetic choices are valid when they serve brand differentiation or user satisfaction.
But they must be named as such, not disguised as UX improvements.

## Output

Write `docs/design/DESIGN-BRIEF.md`:
- Product verb
- Emotional range
- Density model
- Chosen direction (type, color, distinctive element)
- Reference touchstones
- What was explicitly rejected and why

Start `docs/design/DESIGN-DECISIONS.md` with wave 1 direction decisions and the Design Language section.
Start `docs/design/RESEARCH.md` with competitive audit findings.

**Exit prototype:** invoke `/prototype` to visualize the finalized direction.
The brief needs visual proof before wave 2 can begin with confidence.
Pass the complete brief and competitive research as context.

**Exit checkpoint:** "Wave 1 complete. Brief written, direction chosen, {N} decisions logged. Prototype validates the direction visually. Ready for wave 2 (Tokens), or revisit anything?"
