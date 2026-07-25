# Deployment

How a change reaches production for {{project-name}}.
`ARCHITECTURE.md` says how the system is built; this file says how a change ships.
It is the local, human-readable analog of a delivery pipeline's server-side config.

`/ship` and `breakdown` read the fenced block below deterministically; the prose around it is for humans.
Structured exactly where skill behavior depends on it, prose everywhere else.

## Machine block

```yaml
# --- waypoint:deploy ---
adapter: github-pipeline | github-plain | local | other
targets:
  - tier: staging
    destination: "how a change reaches staging"   # routing string; /ship does not execute deploys
    promote: auto
  - tier: production
    destination: "how a change reaches production"
    promote: manual                                # manual promotions surface via check-in
load-bearing:                                        # touch any of these -> forced hitl
  - ".github/workflows/**"
  - "**/migrations/**"
  - "**/auth/**"
  - "**/secrets/**"
  - "**/package.json"                              # and other dependency manifests
  - DEPLOY.md                                       # the rules that govern autonomy guard themselves
# --- end ---
```

## Promotion and rollback

{{describe how staging promotes to production, who approves it, and how a bad deploy is rolled back.}}

## Design rules

- **Reference, do not mirror.**
  For `github-pipeline`, the pipeline's own never-auto-approve list is the authority.
  This `load-bearing` list is an advisory shift-left hint that can only force `hitl` earlier, never disagree with the server by granting `afk`.
  Where the server list is machine-readable, point at it here rather than re-enumerate it.

- **The default list is product-oriented** (auth, migrations, workflows, deploy config, secrets, dependency manifests).
  Add the methodology-self-governance globs (`**/SKILL.md`, `CLAUDE.md`, `AGENTS.md`, agent instructions) only when the deploy target is itself a Waypoint-governed methodology repo, since a product repo has no such files.

- **This file guards itself.**
  `DEPLOY.md` is on its own `load-bearing` list, so a change to the autonomy rules can never be an `afk` change.

- **The adapter names the mechanism only.**
  The Intent block, the afk gate, and the escalate rule are adapter-independent.
  Switching adapters changes how a change ships, never what counts as shippable.

The glob dialect (gitignore-style, rename/deletion handling, match-only) is pinned in `internals/ENGAGEMENT-REFERENCE.md` section 13.4.
