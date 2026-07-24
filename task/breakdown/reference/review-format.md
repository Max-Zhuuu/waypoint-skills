Show the decomposition:

```
Spec: {spec name}
{N} slices, estimated {M} TDD cycles

Build order:
  1. {slice 1 name} (no dependencies)
  2. {slice 2 name} (depends on: 1)
  3. {slice 3 name} (depends on: 1)  <- can run in parallel with 2
  ...

Coverage: {N}/{M} acceptance criteria mapped.
{any gaps or scope creep flagged}

Write slices to spec, or adjust?
```
