# Observability

A discipline for making systems debuggable in production.
Works at any scale - a single service, a distributed system, a full platform - and with any toolchain.

## Who this is for

Anyone building something that will run in production and needs to be understood when it misbehaves.
If your system never leaves your laptop, this document is overhead.
If you have shipped code and cannot answer "why is this slow for user X in region Y?" without deploying new instrumentation, start here.

## The core principle

Observability is the ability to ask novel questions of a running system without shipping new code.
Monitoring answers questions you predicted ("is latency above 500ms?").
Observability answers questions you could not predict ("why are requests from build abc123 in region eu-west 3x slower than the same build in us-east, only for users with carts over 50 items?").

The difference is not the tooling - it is the data model.
If your telemetry has enough context (high cardinality, high dimensionality) to support arbitrary slicing, you have observability.
If it only supports pre-aggregated dashboards, you have monitoring.
Both are useful; they solve different problems.

## Phase 1 - Define what matters

Before instrumenting anything, establish what "healthy" means from the user's perspective.

For greenfield services with no traffic yet, start with generic SLIs (latency p99, error rate, availability).
Refine thresholds after traffic establishes a baseline - the point is defining what healthy WILL mean, not calibrating precise targets before you have data.

### Service Level Indicators (SLIs)

Pick 3-5 indicators that reflect user experience, not infrastructure state.

Good SLIs:
- Fraction of requests completing successfully in under 200ms (latency + availability combined)
- Fraction of checkout flows that complete without retry
- Fraction of search results returned within 100ms

Bad SLIs:
- CPU utilization (infrastructure, not user experience)
- Number of errors per minute (absolute count, not ratio - meaningless without traffic context)
- Database connection pool usage (cause, not symptom)

Each SLI is a ratio: good events divided by total events, yielding a percentage between 0 and 100.

### Service Level Objectives (SLOs)

Set a target for each SLI. The target is deliberately below 100%.

```
SLI: successful requests / total requests
SLO: 99.9% over a 4-week rolling window
Error budget: 0.1% = ~43 minutes of total outage per month
```

Start conservative (match current performance, rounded down).
Tighten only when evidence shows users need more.
Get agreement from three parties: product (is this good enough?), engineering (can we sustain this?), operations (will this page us fairly?).

### Error budgets

The error budget is what SLOs buy you: a concrete quantity of acceptable failure.
When budget remains, ship features. When budget is exhausted, prioritize reliability.
This is not philosophy - it is a decision rule that resolves the velocity-vs-stability tension.

## Phase 2 - Instrument during development

Instrumentation ships with the code, not after.
The question "how will I know this is broken in production?" has the same status as "how will I test this?" - unanswered means not done.

### The wide structured event

The fundamental unit of observability data is a structured event: one record per unit of work (request, job, transaction) carrying every relevant attribute as key-value pairs.

```
{
  "duration_ms": 142,
  "http.status": 200,
  "user_id": "u-8a2f",
  "build_id": "abc123",
  "feature_flags": ["new-checkout", "dark-mode"],
  "region": "eu-west-1",
  "cart_item_count": 53,
  "db_query_count": 7,
  "cache_hit": false
}
```

Properties of a good event:
- **Wide.** 50-200+ attributes. Every dimension that might explain variance.
- **Unaggregated.** One event per request, not one metric per minute.
- **High-cardinality.** User IDs, request IDs, build SHAs - the fields that let you isolate one needle in a haystack.
- **Bounded cardinality.** High-cardinality does not mean unbounded. Free-text fields, request body hashes, and user-generated content create cardinality explosions that break backend indexing. Emit structured values with known domains; if you must include unbounded data, mark it as non-indexed context.

Do not pre-aggregate at write time. Aggregation destroys the ability to ask questions you did not predict.

### Instrumentation order

Start broad, then deepen:

1. **Auto-instrumentation first.** HTTP handlers, database clients, external calls. Framework-level coverage with zero code changes. If your stack has no auto-instrumentation layer (bare Go binaries, custom protocols, embedded systems), skip to step 3 and build outward.
2. **Context propagation.** Trace IDs and span context flow across every service boundary. This is infrastructure, not optional.
3. **Business-logic spans.** Manual spans for the operations that matter to users: "process checkout," "generate report," "match vessel to fixture."
4. **Rich attributes.** Attach user ID, feature flags, tenant, build version, request parameters - anything that might explain variance later.

The goal is not coverage for its own sake.
The goal is: when something goes wrong, can you slice and dice to isolate the cause without deploying new code?

### Operational dimensions starter list

Beyond application-level attributes (user ID, feature flags), include infrastructure and resilience dimensions that explain system-level variance:

- Request rate and throughput (requests/sec by endpoint)
- Success/failure ratio by dependency
- Dependency latency (database, cache, external API - per-call, not aggregated)
- Timeout and retry counts
- Queue depth and consumer lag
- Circuit-breaker state transitions
- Resource saturation signals (connection pool usage, thread pool, file descriptors)
- Build version and deployment ID

These are the dimensions that separate "the code is wrong" from "the environment is degraded."
Include them from day one - they cost almost nothing to emit but are impossible to reconstruct after the fact.

### Sampling as a design constraint

At scale, you cannot store every event. Sampling is methodology, not compromise.

- Keep 100% of errors and slow requests (tail-based sampling).
- Sample normal requests at a rate that preserves statistical validity.
- Never sample at the instrumentation layer - sample at the collection layer. Instrumentation must always emit; the decision to keep or drop happens downstream.

### Cost as a design constraint

Wide events, unaggregated, at scale, cost real money.
This is not a reason to emit less - it is a reason to be deliberate about what you store vs what you sample.

The cost hierarchy:
1. **Emit everything** - instrumentation is free or near-free (CPU and memory, not storage).
2. **Sample at collection** - tail-based sampling keeps all interesting events, drops routine ones.
3. **Retention tiering** - keep raw events for 7-30 days, aggregated summaries longer.
4. **Query cost** - wide events queried rarely are cheap. Narrow events queried constantly cost more in aggregate.

If cost is forcing you to reduce event width or cardinality, you are solving the wrong problem.
Solve retention and sampling first. Width is the last thing to sacrifice - it is the thing that makes the data useful.

## Phase 3 - Alert on SLO burn rate

Alerts fire when the error budget is being consumed too fast - not when individual metrics cross arbitrary thresholds.

Burn-rate alerting requires baseline data.
If your service is new, start with simple threshold alerts on SLIs (error rate > 5%, p99 latency > 1s) and upgrade to burn-rate when you have 2-4 weeks of traffic history to calibrate against.
The threshold alerts are training wheels, not the destination.

### Symptom-based alerting

Alert on what users experience, not on causes you predicted.

Good alert: "Error budget burning at 10x normal rate - will exhaust in 4 hours at current pace."
Bad alert: "CPU above 80% on host-17." (May not affect users. May page at 3am for nothing.)

### The burn-rate model

A 1x burn rate means the budget lasts exactly the SLO window (e.g., 30 days).
Alert at 14x (budget exhausts in ~2 days) for slow-burn pages.
Alert at 36x (budget exhausts in ~20 hours) for fast-burn pages.
These numbers are tunable; the principle is: alert on the rate of budget consumption, not on instantaneous values.

### Three tiers of notification

1. **Page** - immediate human attention. Only for confirmed user impact that is urgent, actionable, and requires intelligence.
2. **Ticket** - subcritical. Route to the backlog. "Latency p99 drifting up over 3 days" is a ticket, not a page.
3. **Dashboard** - informational. No notification. Engineers look when investigating.

If you are ignoring an alert, delete it. An ignored alert trains the team to ignore all alerts.

## Phase 4 - Debug with the Core Analysis Loop

When an SLO breach or anomaly fires, debug from telemetry data:

```
1. Start with what you know (the breach, the anomaly, the symptom)
2. Hypothesize: which dimension could explain the difference?
3. Break down: slice data by that dimension
4. Assess: does it separate healthy from unhealthy?
5. If not root cause: take what you learned, repeat from step 2
```

This is hypothesis-driven debugging applied to production data.
When you know nothing about the system, brute-force iteration across available dimensions will find the explanatory variable.

In practice, experienced operators develop heuristics for dimension priority:
- Recent deploys (build version, deployment ID) - the most common explanatory variable
- Known-hot dimensions (region, customer tier, feature flag) - the ones that have explained past incidents
- Changes in traffic shape (new client, spike in a specific endpoint)

The brute-force fallback exists for when heuristics fail or when the operator is unfamiliar with the system.

The loop is fast when events are wide (many dimensions to slice by) and high-cardinality (can isolate individual users, requests, builds).
It is slow or impossible when events are narrow or pre-aggregated - you run out of dimensions to test.

### Relationship to debugging methodology

This loop is Phase 3 (hypothesize) and Phase 4 (instrument) of the general debugging methodology, specialized for production systems where the "instrumentation" already exists in telemetry data.
If the Core Analysis Loop cannot find the cause - because the telemetry lacks the necessary dimensions - that is a gap in Phase 2 instrumentation.
Close it: add the missing attribute, deploy, and the next incident is faster.

## Phase 5 - Close the feedback loop

Each incident reveals where the system failed you - not just in instrumentation.
This is the iterative engine:

1. Incident occurs. Debug using Phase 4.
2. Measure time-to-root-cause. Was it fast (minutes) or slow (hours)?
3. Identify the bottleneck. It is one of:
   - **Missing dimension** (Phase 2 gap) - add the instrumentation. Ship it with the fix.
   - **Wrong SLO** (Phase 1 gap) - the objective did not reflect actual user pain. Recalibrate.
   - **Alert miscalibration** (Phase 3 gap) - fired too late, too early, or not at all. Adjust burn-rate thresholds.
   - **Sampling gap** (Phase 2 gap) - the relevant events were dropped. Adjust tail-sampling rules.
4. Ship the improvement alongside the incident fix - never as a separate follow-up that gets deprioritized.
5. Next similar incident is faster.

This is not a one-time setup. Observability is a practice that improves with every incident.
The feedback loop feeds back into ALL prior phases, not just instrumentation.

### What to check periodically

- Are SLOs still reflecting user experience? (Compare with support tickets, user complaints.)
- Are alerts actionable? (Track alert-to-action ratio. Delete alerts with low action rates.)
- Is instrumentation keeping pace with code changes? (New services, new features - do they emit events?)
- Is sampling preserving debugging ability? (Can you still isolate individual user journeys?)

## Adapting to your context

### Solo developer

Phase 1 is simple: one or two SLIs (availability, latency).
Phase 2 is lightweight: structured logging with request context.
Phase 4 is grepping your logs with better structure.
The discipline still pays off - when your side project is down at 2am, can you tell why from your phone?

### Team with existing monitoring

Start with Phase 1 - define SLOs from existing metrics.
Add Phase 2 incrementally: enrich existing logs with high-cardinality context.
Move alerts from threshold-based to burn-rate (Phase 3) one at a time.
You do not need to replace existing tools. You need to add context to existing signals.

### With an AI assistant

Hand Phase 1 to the assistant: "Given this service's API, propose 3-5 SLIs."
Hand Phase 2 enrichment to the assistant: "What attributes should this span carry to support debugging?"
Keep Phase 3 alert tuning in human hands - the cost of a wrong alert is human sleep.

### AI agent

The agent instruments code during development (Phase 2) as naturally as writing tests.
The agent proposes SLIs during feature planning.
The agent does not configure alerts or SLOs without human approval - these are operational contracts with on-call consequences.
