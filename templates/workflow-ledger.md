# Workflow Ledger: {{workflow-name}}

Committed home: `docs/workflows/{{workflow-name}}/ledger.md`.
One row per component. Correctness is never assumed: a component counts as Passed only with rank-1-5 evidence from a named oracle.
See [the verifiable-workflows methodology](../process/verifiable-workflows.md) for the evidence hierarchy and the metric definitions.

## Metric

The metric is computed from the rows below and is authoritative here; no other surface recomputes it.

| Measure | Value |
|---------|-------|
| Target pass-rate (SLO) | {{target-pass-rate}} (e.g. >= 95%) |
| Error budget | {{error-budget}} (the tracked set of known-incomplete components, each with a reason) |
| Current pass-rate | {{passing}} / {{required}} = {{current-pass-rate}} |
| Criterion completeness (precision) | {{correct-of-produced}} |
| Criterion completeness (recall) | {{correct-of-required}} |
| Criterion completeness (F1) | {{f1}} |
| Process-health | {{control-status}} (in-control / special-cause spike halting the batch) |

## Components

Status is one of built / partial / failed / not-started.
Criteria is k/n with the unmet criteria named.
Evidence class is the oracle rank (1-5 to Pass) plus the named oracle; rank 6-7 alone never Passes.

| Component | Spec ref | Lane / agent | Status | Criteria (k/n, unmet named) | Evidence (rank + oracle) | Discrepancies | Roadblocks |
|-----------|----------|--------------|--------|------------------------------|--------------------------|---------------|------------|
| {{component-id}} | {{spec-ref}} | {{lane}} | {{status}} | {{k}}/{{n}} ({{unmet}}) | rank {{rank}}: {{oracle}} | {{concerns-md-pointer}} | {{roadblock-or-none}} |

## Error budget log

Each known-incomplete component spent against the error budget, with its reason.

| Component | Why it is not Passed | Decision / owner |
|-----------|----------------------|------------------|
| {{component-id}} | {{reason}} | {{decision}} |

## Change Log

| Date | Change |
|------|--------|
| {{date}} | Created |
