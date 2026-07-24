---
name: find-skills
description: "Discover and recommend installable skills from the ecosystem. Use when asking how to do X or extending capabilities."
status: experimental
---

Help users discover and install skills from the open agent skills ecosystem via the Skills CLI (`npx skills`).

## Triggers

Use when the user asks how to do X (where a skill likely exists), asks to find/search for skills, wants to extend capabilities, or mentions needing help with a specific domain.

## Process

### 1. Understand the need

Identify the domain (e.g., React, testing, deployment), the specific task, and whether it's common enough that a skill likely exists.

### 2. Search

Check the [skills.sh leaderboard](https://skills.sh/) first for well-known skills. If not covered, run:

```bash
npx skills find [query]
```

Use specific keywords: "react testing" over just "testing". Try alternative terms if the first query misses.

### 3. Verify quality

Do not recommend based solely on search results. Check:
- **Install count** - prefer 1K+, cautious under 100
- **Source reputation** - official sources (`vercel-labs`, `anthropics`, `microsoft`) over unknown authors
- **GitHub stars** - repos with <100 stars deserve skepticism

### 4. Present and install

Present: skill name, what it does, install count, source, install command.
See [reference/examples.md](reference/examples.md) for response format.

To install for the user:

```bash
npx skills add <owner/repo@skill> -g -y
```

### When no skills found

Acknowledge the gap, offer to help directly with general capabilities, mention `npx skills init` for creating custom skills.

## Categories

See [reference/categories.md](reference/categories.md) for common search categories and keyword suggestions.

## Tone

Concise. Skill name, one-line reason, install command.

## Exit

Discovery complete. User installs selected skills or moves on.
