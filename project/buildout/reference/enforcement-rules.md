# Enforcement Rules

Full rule set that /buildout hands to /check-in as inputs. /check-in decides how to act on them - this list only defines what to watch for.

## Core (always active)

1. **Code without specs** - features built without a spec.
2. **No phase leapfrogging** - unless /check-in recognizes a regression.
3. **Stale critical concerns** - flags or questions in CONCERNS.md older than 1 week.

## Archetype: product (extra rules)

4. **Unvalidated assumptions** - building on assumptions that haven't been tested.
5. **Scope creep** - features not in SCOPE.md showing up in code.

## Archetype: design-system (extra rules)

6. **Premature design** - design implementation in production code before the functional gate.
