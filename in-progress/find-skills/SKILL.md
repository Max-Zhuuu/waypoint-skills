---
name: find-skills
description: "Discover and recommend installable skills from the ecosystem. Use when asking how to do X or extending capabilities."
status: experimental
---

Discover and install skills from the open agent skills ecosystem via Skills CLI (`npx skills`).

## Process

1. **Search** - Identify domain + task. Check [skills.sh](https://skills.sh/) first. Then `npx skills find [query]` with specific keywords. Try alternative terms if first query misses. Categories: [reference/categories.md](reference/categories.md).
2. **Verify + recommend** - Check: install count (prefer 1K+, cautious <100), source reputation (official > unknown), stars (<100 = skepticism). Present: name, purpose, count, source, install command. Format: [reference/examples.md](reference/examples.md). Install: `npx skills add <owner/repo@skill> -g -y`. Nothing found: acknowledge gap, offer direct help, mention `npx skills init`.

## Tone

Skill name, one-line reason, install command.
