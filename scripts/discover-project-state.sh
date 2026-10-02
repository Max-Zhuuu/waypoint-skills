#!/usr/bin/env bash
# Analyze the current repo and write .claude/project-state.json.
# Idempotent, read-only except for .claude/project-state.json.
# Works on Windows Git Bash and POSIX systems.
set -euo pipefail

# -- Helpers --

bool() { [ "$1" = "true" ] && echo "true" || echo "false"; }

file_exists() { [ -f "$1" ] && echo "true" || echo "false"; }

dir_exists() { [ -d "$1" ] && echo "true" || echo "false"; }

# -- Framework detection --

framework="unknown"
if [ -f "package.json" ]; then
  deps=$(cat package.json)
  case "$deps" in
    *'"vue"'*|*'"@vue/"'*)    framework="vue3" ;;
    *'"next"'*)               framework="next" ;;
    *'"react"'*)              framework="react" ;;
    *'"svelte"'*|*'"@sveltejs/"'*) framework="svelte" ;;
    *'"angular"'*|*'"@angular/"'*) framework="angular" ;;
    *'"express"'*)            framework="express" ;;
    *'"fastify"'*)            framework="fastify" ;;
  esac
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
  framework="python"
  if [ -f "pyproject.toml" ]; then
    case "$(cat pyproject.toml)" in
      *django*)   framework="django" ;;
      *flask*)    framework="flask" ;;
      *fastapi*)  framework="fastapi" ;;
    esac
  fi
elif [ -f "go.mod" ]; then
  framework="go"
elif [ -f "Cargo.toml" ]; then
  framework="rust"
fi

# -- Package manager --

pkg_manager="unknown"
if [ -f "pnpm-lock.yaml" ]; then pkg_manager="pnpm"
elif [ -f "yarn.lock" ]; then pkg_manager="yarn"
elif [ -f "bun.lockb" ]; then pkg_manager="bun"
elif [ -f "package-lock.json" ]; then pkg_manager="npm"
elif [ -f "uv.lock" ]; then pkg_manager="uv"
elif [ -f "Pipfile.lock" ]; then pkg_manager="pipenv"
elif [ -f "poetry.lock" ]; then pkg_manager="poetry"
elif [ -f "requirements.txt" ]; then pkg_manager="pip"
fi

# -- Test runner --

test_runner="unknown"
if [ -f "vitest.config.ts" ] || [ -f "vitest.config.js" ]; then test_runner="vitest"
elif [ -f "jest.config.ts" ] || [ -f "jest.config.js" ]; then test_runner="jest"
elif [ -f "pytest.ini" ] || [ -f "conftest.py" ]; then test_runner="pytest"
elif [ -f "pyproject.toml" ] && grep -q "pytest" pyproject.toml 2>/dev/null; then test_runner="pytest"
elif [ -f "package.json" ] && grep -q '"vitest"' package.json 2>/dev/null; then test_runner="vitest"
elif [ -f "package.json" ] && grep -q '"jest"' package.json 2>/dev/null; then test_runner="jest"
fi

# -- Linter --

linter="unknown"
if [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ]; then linter="eslint"
elif [ -f "biome.json" ] || [ -f "biome.jsonc" ]; then linter="biome"
elif [ -f "pyproject.toml" ] && grep -q "ruff" pyproject.toml 2>/dev/null; then linter="ruff"
elif [ -f ".flake8" ] || [ -f "setup.cfg" ] && grep -q "flake8" setup.cfg 2>/dev/null; then linter="flake8"
fi

# -- File count (source files only, skip node_modules/.git/dist) --

file_count=$(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.vue" -o -name "*.svelte" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
  -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/dist/*" -not -path "*/__pycache__/*" -not -path "*/.next/*" 2>/dev/null | wc -l | tr -d ' ')

# -- Git maturity --

git_commits=0
git_age_days=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_commits=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  first_commit=$(git log --reverse --format="%at" 2>/dev/null | head -1)
  if [ -n "$first_commit" ]; then
    now=$(date +%s)
    git_age_days=$(( (now - first_commit) / 86400 ))
  fi
fi

# -- Project docs --

doc_context=$(file_exists "CONTEXT.json")
doc_scope_json=$(file_exists "SCOPE.json")
doc_scope_md=$(file_exists "SCOPE.md")
doc_arch_json=$(file_exists "ARCHITECTURE.json")
doc_arch_md=$(file_exists "ARCHITECTURE.md")
doc_conv_json=$(file_exists "CONVENTIONS.json")
doc_conv_md=$(file_exists "CONVENTIONS.md")
doc_deploy_json=$(file_exists "DEPLOY.json")
doc_deploy_md=$(file_exists "DEPLOY.md")
doc_testing=$(file_exists "TESTING.md")
doc_glossary=$(bool "$([ -f "GLOSSARY.md" ] || [ -f "_GLOSSARY.md" ] && echo true || echo false)")
doc_claude=$(file_exists "CLAUDE.md")
doc_concerns=$(file_exists "CONCERNS.md")

# -- External connectors (scan deps and env files) --

connectors=""
add_connector() {
  if [ -z "$connectors" ]; then connectors="\"$1\""; else connectors="$connectors, \"$1\""; fi
}

scan_target=""
[ -f "package.json" ] && scan_target="$scan_target $(cat package.json)"
[ -f ".env" ] && scan_target="$scan_target $(cat .env 2>/dev/null || true)"
[ -f ".env.example" ] && scan_target="$scan_target $(cat .env.example 2>/dev/null || true)"
[ -f ".env.local" ] && scan_target="$scan_target $(cat .env.local 2>/dev/null || true)"

if [ -n "$scan_target" ]; then
  case "$scan_target" in *azure*|*AZURE*|*Azure*)         add_connector "azure" ;; esac
  case "$scan_target" in *aws*|*AWS*|*amazon*)             add_connector "aws" ;; esac
  case "$scan_target" in *posthog*|*POSTHOG*|*PostHog*)    add_connector "posthog" ;; esac
  case "$scan_target" in *linear*|*LINEAR*)                add_connector "linear" ;; esac
  case "$scan_target" in *stripe*|*STRIPE*)                add_connector "stripe" ;; esac
  case "$scan_target" in *supabase*|*SUPABASE*)            add_connector "supabase" ;; esac
  case "$scan_target" in *firebase*|*FIREBASE*)            add_connector "firebase" ;; esac
  case "$scan_target" in *sentry*|*SENTRY*)                add_connector "sentry" ;; esac
  case "$scan_target" in *openai*|*OPENAI*)                add_connector "openai" ;; esac
  case "$scan_target" in *anthropic*|*ANTHROPIC*|*claude*) add_connector "anthropic" ;; esac
  case "$scan_target" in *vercel*|*VERCEL*)                add_connector "vercel" ;; esac
  case "$scan_target" in *datadog*|*DATADOG*)              add_connector "datadog" ;; esac
fi

# -- CI platform --

ci_platform="unknown"
if [ -d ".github/workflows" ]; then ci_platform="github_actions"
elif [ -f "azure-pipelines.yml" ]; then ci_platform="azure_devops"
elif [ -f ".gitlab-ci.yml" ]; then ci_platform="gitlab_ci"
elif [ -f "Jenkinsfile" ]; then ci_platform="jenkins"
elif [ -f ".circleci/config.yml" ]; then ci_platform="circleci"
fi

# -- Deploy provider --

deploy_provider="unknown"
if [ -f "staticwebapp.config.json" ]; then deploy_provider="azure_swa"
elif [ -f "vercel.json" ]; then deploy_provider="vercel"
elif [ -f "netlify.toml" ]; then deploy_provider="netlify"
elif [ -f "fly.toml" ]; then deploy_provider="fly"
elif [ -f "render.yaml" ]; then deploy_provider="render"
elif [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ]; then deploy_provider="docker"
fi

# -- Build JSON output --

json=$(cat <<ENDJSON
{
  "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "framework": "$framework",
  "package_manager": "$pkg_manager",
  "test_runner": "$test_runner",
  "linter": "$linter",
  "file_count": $file_count,
  "git": {
    "commits": $git_commits,
    "age_days": $git_age_days
  },
  "project_docs": {
    "CONTEXT.json": $doc_context,
    "SCOPE.json": $doc_scope_json,
    "SCOPE.md": $doc_scope_md,
    "ARCHITECTURE.json": $doc_arch_json,
    "ARCHITECTURE.md": $doc_arch_md,
    "CONVENTIONS.json": $doc_conv_json,
    "CONVENTIONS.md": $doc_conv_md,
    "DEPLOY.json": $doc_deploy_json,
    "DEPLOY.md": $doc_deploy_md,
    "TESTING.md": $doc_testing,
    "GLOSSARY.md": $doc_glossary,
    "CLAUDE.md": $doc_claude,
    "CONCERNS.md": $doc_concerns
  },
  "external_connectors": [$connectors],
  "ci_platform": "$ci_platform",
  "deploy_provider": "$deploy_provider"
}
ENDJSON
)

# -- Write output --

mkdir -p .claude
echo "$json" > .claude/project-state.json
echo "$json"
