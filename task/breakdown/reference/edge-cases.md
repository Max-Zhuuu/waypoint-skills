## Edge cases

**Spec changes after /breakdown:** if the spec has been modified since the last breakdown (compare the spec's Change Log dates against the slice section timestamp), warn:
"Spec was updated since breakdown. Re-decompose, or keep current slices?"

**Slice too big:** if a slice's file list exceeds 5 files, offer to sub-decompose.

**Circular dependencies:** if the dependency graph has cycles, flag: "Slices {A} and {B} depend on each other. One must go first - which?"

**No acceptance criteria in spec:** if the spec lacks acceptance criteria, the coverage check can't run. Suggest: "Spec has no acceptance criteria. /spec to add them, or skip coverage check?"
