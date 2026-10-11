# Doc root `{DOCS}`

Every skill that reads or writes project docs resolves `{DOCS}` once per run, then uses it in place of a hard-coded `docs/`.
`scripts/resolve-doc-root.sh` implements this rule (installed at `~/.claude/scripts/`), and `tests/test-doc-root.sh` checks both.

## Project root

The project root is the git top level when the session is inside a repo.
Outside git, it is the nearest ancestor that holds a `CLAUDE.md` or a `_docs/` folder, else the current directory.
So a repo inside a multi-repo workspace uses its own root: the workspace's `CLAUDE.md` and `_docs/` don't apply to it.

## Resolution

1. **Declared.** The project root's `CLAUDE.md` has a `## Docs` section with a line `` Doc root: `path/` ``.
2. **Workspace convention.** Else `_docs/`, if it exists at the project root.
3. **Default.** Else `docs/`.

A declaration wins over an existing `_docs/`.
A `## Docs` section without a `Doc root:` line is not a declaration.

## Paths under the root

| Concept | Path |
|---|---|
| Specs | `{DOCS}/specs/` |
| Design docs (`/design`) | `{DOCS}/design/` |

When the `CLAUDE.md` Documentation Map names a path for the concept (for example `implementation/specs/`), the map wins; resolve it under `{DOCS}`.
Repo-owned docs such as ADRs and glossaries stay where the repo's `CLAUDE.md` puts them.

## Examples

| Started in | `{DOCS}` | Why |
|---|---|---|
| A workspace root whose `CLAUDE.md` says `` Doc root: `_docs/` `` | `_docs/` | Declared |
| A workspace root with `_docs/` and no declaration | `_docs/` | Workspace convention |
| A repo inside that workspace | `docs/` | Its own root, no declaration, no `_docs/` |
| A fresh repo | `docs/` | Default |

When writing, create the folder if it is missing, and report the resolved path in the artifacts manifest ([manifest.md](manifest.md)).
