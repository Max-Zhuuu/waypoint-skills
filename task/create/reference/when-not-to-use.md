## When NOT to use - recommend alternatives

- **No project docs exist:** recommend /setup first
- **Replacing an existing system layer by layer:** recommend /migrate (parity tracking, inventory, phased cutover)
- **Building a new product from scratch with unknown scope:** recommend /buildout (MoSCoW prioritization, MVP-first, feedback rounds)
- **Scope is large (5+ features needing architecture decisions):** recommend /buildout - /create doesn't have gates to catch architectural drift at that scale

Print the recommendation with a plain-language explanation of why, not just the skill name.
