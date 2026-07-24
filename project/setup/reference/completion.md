# Completion Templates

Read by /setup after Phase 1 gate passes.
Read SCOPE.md and the Phase 0 conversation to determine which template to use.

## If a source system was identified

SCOPE.md repositories section mentions an existing system, or scope describes replacing/migrating from something.

```
Setup complete. You described migrating from {system name}.
  -> /migrate - sets up parity tracking, spec extraction from the source,
     and a phased plan to replace it layer by layer

Other options:
  -> /create  - add specific features without the full migration workflow
  -> /buildout - structure a new product with prioritized features and
     an MVP-first build cycle

Next session: run /check-in to orient and pick up where you left off.
```

## If no source system was identified

```
Setup complete. Ready to start building.
  -> /buildout - structures the work into prioritized features, builds
     an MVP first, then iterates with user feedback
  -> /create  - add a feature or small batch of features with light
     structure (spec, build, wrapup - no phases or inventory)

If you're replacing an existing system, /migrate sets up parity tracking
and phased replacement instead.

Next session: run /check-in to orient and pick up where you left off.
```
