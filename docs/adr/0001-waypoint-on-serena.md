---
status: proposed
---

# Waypoint's deterministic checks as a thin soft-fork of Serena

## Context

Waypoint's methodology lives entirely as prose that a model interprets.
Its strongest principle - verify against source, never fabricate - and its reconciliation machinery (the ledger, spec-drift check, gate evaluation, default-fail verdict) are all instructions, not enforcement.
The model can skip them, infer them from a memory that gets cleared on compaction, or rationalize its way past them.
This is the gap identified in the ledger discussion: verification is inferred, not read from disk.

Serena (github.com/oraios/serena, MIT) is a code-intelligence MCP toolkit built on language servers.
It provides deterministic, symbol-level tools over a real code graph, plus a freeform project-memory store and a declarative prompt layer ("modes" and "contexts").
It is code where Waypoint is prose, and it already owns the symbol graph Waypoint would need to make "verify against source" mechanical.

## Decision

Build the deterministic half of Waypoint as a thin soft-fork of Serena, and keep the judgment half as prompts.

- **Judgment stays prose.** The grill, trade-off presentation, one-question-at-a-time, orient-don't-fix - these map onto Serena's existing `modes/*.yml` (a YAML `prompt` plus a tool allow/deny list). No code. This is the direct analog of a Waypoint SKILL.md adapter.
- **The homes and checks become code.** The ledger, CONCERNS, spec-drift, and gate evaluation become `Tool` subclasses writing to a structured store, with drift computed against the Serena symbol graph via `create_language_server_symbol_retriever()`. Verdicts default to `unverified` until evidence upgrades them, in code the model cannot route around.

The split is Waypoint's own process/adapter boundary, enforced more strictly: prompts propose, code verifies.

## Considered options

- **Keep Waypoint as pure prose (status quo).** Maximum portability (Claude Code, Cursor, Codex, no-AI), zero runtime cost, but verification stays unenforceable. Rejected as the thing we are trying to fix.
- **Hard fork Serena and reimplement Waypoint in Python.** Maximum control, but high maintenance, loses the tool-agnostic prose layer entirely, and over-codes judgment that is better left fuzzy. Rejected as too heavy and partly counterproductive.
- **Encode Waypoint's soft nudges as tools too.** Rejected on direct evidence: Serena already deleted its own `think_about_*` / `summarize_changes` reflection tools (see the registry's `_deleted_tools`). Soft process-nudges as tools did not earn their keep in their design; ours would not either.

## Consequences

- **It is a fork, but a thin one.** Serena's tool discovery is `iter_subclasses(Tool)` filtered by a hardcoded whitelist `tool_packages = ["serena.tools"]`, with no third-party plugin/entry-point mechanism. A new tool module placed under `serena.tools` registers by adding one import line to `serena/tools/__init__.py`. We touch one line of core and otherwise only add files (tool modules + YAML modes), so upstream rebases stay low-conflict. We never fork the agent loop, the MCP server, or the `solidlsp` symbol engine.
- **Portability narrows.** The coded layer binds to Serena's runtime (Python MCP server, a language server per language). The prose layer can still run anywhere; only the enforced checks require Serena.
- **Mode transitions are likely host-driven.** Serena deleted `switch_modes`, so a Waypoint chain probably cannot self-switch modes mid-session; transitions come from the host re-invoking with the next mode, or from a chain tool that returns the next mode as text. To be confirmed before designing the chain.
- **The payoff is mechanical drift.** Spec-drift stops being a model re-read and becomes a computed diff between the ledger's claimed symbols/tests and what `find_symbol` / `find_referencing_symbols` actually return. That closes the "inferred, not verified" gap in code.

## Validation

An MVP spike (one `waypoint-verify` mode plus `waypoint_write_ledger`, `waypoint_check_drift`, `waypoint_evaluate_gate` tools) proves the thesis against a real symbol graph before any wider port.
If the symbol-anchored drift check feels materially more trustworthy than prose-based `/wrapup`, the fork is justified and scoped; if it feels like ceremony, the cost was one spike.

## Where the code lives

The fork and the MVP spike live in [max-zhu-bv/serena](https://github.com/max-zhu-bv/serena) on the `waypoint-verify-spike` branch.
This ADR is the canonical rationale; the fork-side pointer is [serena `docs/adr/0001-waypoint-verification-fork.md`](https://github.com/max-zhu-bv/serena/blob/waypoint-verify-spike/docs/adr/0001-waypoint-verification-fork.md), and the run instructions are in that repo's `WAYPOINT_SPIKE.md`.
