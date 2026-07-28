# Debugging Methodology

A discipline for hard bugs.
Works at any scale - from a flaky unit test to a production incident - and with any toolchain.
Skip phases only when explicitly justified.

## Who this is for

Anyone debugging a problem that resists a quick fix.
If you already know the cause and just need to write the patch, this document is overhead - go fix it.
If you have been staring at the code for 20 minutes and are not closer to the answer, start at Phase 1.

## Phase 1 - Build a feedback loop

**This is the skill.** Everything else is mechanical.

If you have a fast, deterministic, pass/fail signal for the bug, you will find the cause.
Bisection, hypothesis-testing, and instrumentation all just consume that signal.
If you do not have one, no amount of reading code will save you.

Spend disproportionate effort here.

### Strategies - roughly ordered by cost

Try them in this order. Stop when you have a loop that works.

1. **Failing test** at whatever seam reaches the bug - unit, integration, e2e.
2. **Curl / HTTP script** against a running dev server.
3. **CLI invocation** with a fixture input, diffing stdout against a known-good snapshot.
4. **Headless browser script** (Playwright, Puppeteer, Selenium, Cypress) - drives the UI, asserts on DOM/console/network.
5. **Replay a captured trace.** Save a real network request, payload, or event log to disk; replay it through the code path in isolation.
6. **Throwaway harness.** Spin up a minimal subset of the system (one service, mocked deps) that exercises the bug code path with a single function call.
7. **Property / fuzz loop.** If the bug is "sometimes wrong output," run 1000 random inputs and look for the failure mode.
8. **Bisection harness.** If the bug appeared between two known states (commit, dataset, version), automate "boot at state X, check, repeat" so you can `git bisect run` it.
9. **Differential loop.** Run the same input through old-version vs new-version (or two configs) and diff outputs.
10. **Human-in-the-loop script.** Last resort. If a human must click or observe, write a script that prompts them through the steps and captures their observations in a structured format. The loop is still structured even if a human is in it.

> **Why this ordering matters.** Strategy 1 runs in milliseconds, is fully automated, and produces a permanent regression test as a side effect. Strategy 10 takes minutes per iteration and depends on a human being available. Every step down the list costs more per iteration. Use the cheapest loop that reaches the bug.

### Iterate on the loop itself

Once you have a loop, treat it as a product:

- **Faster?** Cache setup, skip unrelated init, narrow the test scope.
- **Sharper?** Assert on the specific symptom, not "did not crash."
- **More deterministic?** Pin time, seed RNG, isolate filesystem, freeze network.

A 30-second flaky loop is barely better than no loop. A 2-second deterministic loop is a debugging superpower.

### Non-deterministic bugs

The goal is not a clean repro but a **higher reproduction rate.**
Loop the trigger 100 times, parallelize, add stress, narrow timing windows, inject sleeps.
A 50%-flake bug is debuggable; 1% is not - keep raising the rate until it is debuggable.

### When you cannot build a loop

Stop and say so explicitly. List what you tried. Then seek one of:

- Access to whatever environment reproduces the bug
- A captured artifact (HAR file, log dump, core dump, screen recording with timestamps)
- Permission to add temporary production instrumentation

Do **not** proceed to hypothesize without a loop.

---

## Phase 2 - Reproduce

Run the loop. Watch the bug appear. Confirm three things:

- [ ] The loop produces the failure mode the **reporter** described - not a different failure that happens to be nearby. Wrong bug means wrong fix.
- [ ] The failure is reproducible across multiple runs (or, for non-deterministic bugs, reproducible at a high enough rate to debug against).
- [ ] You have captured the exact symptom (error message, wrong output, timing) so later phases can verify the fix actually addresses it.

Do not proceed until you reproduce the bug.

---

## Phase 3 - Hypothesize

Generate **3-5 ranked hypotheses** before testing any of them.
Single-hypothesis generation anchors on the first plausible idea.

Each hypothesis must be **falsifiable**: state the prediction it makes.

> Format: "If [X] is the cause, then [changing Y] will make the bug disappear / [changing Z] will make it worse."

If you cannot state the prediction, the hypothesis is a vibe - discard or sharpen it.

**Share the ranked list before testing.**
Other people on the team often have domain knowledge that re-ranks instantly ("we just deployed a change to #3"), or know hypotheses they have already ruled out.
Cheap checkpoint, big time saver.

---

## Phase 4 - Instrument

Each probe must map to a specific prediction from Phase 3.
**Change one variable at a time.**

### Tool preference

1. **Debugger / REPL inspection** if the environment supports it. One breakpoint beats ten log lines.
2. **Targeted logs** at the boundaries that distinguish hypotheses.
3. Never "log everything and grep."

### Tagging

Tag every debug log with a unique prefix, e.g. `[DEBUG-a4f2]`.
Cleanup at the end becomes a single grep.
Untagged logs survive; tagged logs die.

### Production bugs in observable systems

For systems with observability instrumentation (see [process/observability.md](observability.md)), the telemetry data IS the instrumentation.
Phase 4 becomes "slice and dice existing events" rather than "add temporary probes."
The Core Analysis Loop in process/observability.md Phase 4 is this phase specialized for high-cardinality production data.

### Performance bugs

For performance regressions, logs are usually the wrong tool.
Instead: establish a baseline measurement (timing harness, profiler, query plan), then bisect.
Measure first, fix second.

---

## Phase 5 - Fix and regression test

Write the regression test **before the fix** - but only if there is a **correct seam** for it.

A correct seam is one where the test exercises the real bug pattern as it occurs at the call site.
If the only available seam is too shallow (single-caller test when the bug needs multiple callers), a regression test there gives false confidence.

**If no correct seam exists, that itself is the finding.**
Note it. The architecture is preventing the bug from being locked down.
Flag this for future improvement.

If a correct seam exists:

1. Turn the minimized repro into a failing test at that seam.
2. Watch it fail.
3. Apply the fix.
4. Watch it pass.
5. Re-run the Phase 1 feedback loop against the original scenario.

---

## Phase 6 - Cleanup

Required before declaring done:

- [ ] Original repro no longer reproduces (re-run the Phase 1 loop)
- [ ] Regression test passes (or absence of seam is documented)
- [ ] All `[DEBUG-...]` instrumentation removed (grep the prefix)
- [ ] Throwaway prototypes deleted
- [ ] The hypothesis that turned out correct is stated in the commit message or PR description

**Then ask: what would have prevented this bug?**
If the answer involves architectural change (no good test seam, tangled callers, hidden coupling), note it as a follow-up.
Make this recommendation after the fix is in, not before - you have more information now.

---

## Phase 7 - Learn from the root cause (optional)

The root cause is confirmed and the fix is in.
This is the highest-leverage learning moment.

### What to capture

- **Domain terms** that were central to the bug. Add them to whatever glossary or context document the project maintains.
- **Framework / language concepts** (e.g., Vue reactivity caveats, CSS specificity, event loop timing). One sentence on the mental model, one sentence on the gotcha that caused this bug.
- **Further reading.** 2-3 curated links on the root cause mechanism. Prefer official documentation and primary sources over tutorial sites.

### Teaching the fix

If working with a team or mentoring someone:

- Explain **why** this was the cause, not just what changed.
- Ask: "what happens if [related scenario]?" to test whether the conceptual model transferred.
- Skip this when the root cause is trivial or the audience clearly already understands it.

---

## Adapting to your context

This methodology is deliberately tool-agnostic. Here is how it maps to different working styles:

### Solo developer, no AI

Follow the phases in order. Write the checklist items on paper or in a scratch file.
The feedback loop strategies in Phase 1 are the most valuable part - invest time there.

### Developer with AI assistant

Hand Phase 1 to the assistant: "build me a feedback loop for this bug."
Hand Phase 3 to the assistant: "generate 5 ranked hypotheses for why this test fails."
Keep Phase 4 (instrumentation) and Phase 5 (fix) in your hands - the assistant can propose, but you verify.

### Team debugging session

Phase 3 is the natural synchronization point.
One person builds the loop (Phase 1-2), shares the ranked hypotheses with the team, and the team re-ranks based on collective knowledge.
Split instrumentation (Phase 4) across people if the hypotheses touch different subsystems.

### AI agent (automated)

The agent follows all phases sequentially.
Phase 3 hypotheses should be shown to the user before testing begins - the user often has domain knowledge that saves significant time.
Phase 7 is where the agent teaches the user what it learned.
