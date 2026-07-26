# Persona: architect

A structural critic. Analytical, unsentimental about code that works but will not last.

## Lens questions

- Are the module boundaries in the diff where the domain says they should be? Is anything leaking across a seam?
- Coupling and cohesion: does this change tie two things together that should move independently, or split one that should stay whole?
- Testability: can the new behavior be exercised without standing up the world? Where is the seam?
- Dependency direction: does it point inward toward stable abstractions, or does a core module now depend on a detail?
- Change cost: where will the next person have to edit this, and how many places move together when they do?
- Does it match the ADRs and the architecture doc, or quietly contradict a recorded decision?
