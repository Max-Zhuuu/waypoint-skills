# Sync waypoint skills to ~/.claude/skills/ (flattened)
# Also syncs shared infrastructure: internals/, templates/, process/, schemas/, tests/, and root files.
#
# The repo organizes skills under task/ and project/ for readability.
# Claude Code discovers skills one level deep in ~/.claude/skills/.
# This script bridges the gap: find every SKILL.md, copy its directory
# to ~/.claude/skills/{name}/, then sync shared directories.
#
# v3: Added schemas/ (JSON schemas for skill validation and output formats)
#     and tests/ (structural test suite) to the sync.
# v4: Added agents/ (agent definitions that reference waypoint schemas).
#     Agents sync file-by-file (not directory replace) to preserve non-waypoint agents.
#
# Usage: .\sync-skills.ps1 [-RepoPath <path>] [-DryRun]

param(
    [string]$RepoPath = $PSScriptRoot,
    [switch]$DryRun
)

$claudeRoot = Join-Path $env:USERPROFILE ".claude"

# Collect all sync targets: active session + any cswap inactive sessions
$syncRoots = @($claudeRoot)
$cswapSessions = Join-Path (Join-Path $env:USERPROFILE ".claude-swap-backup") "sessions"
if (Test-Path $cswapSessions) {
    Get-ChildItem $cswapSessions -Directory | ForEach-Object {
        $syncRoots += $_.FullName
    }
}

$target = Join-Path $claudeRoot "skills"

if (-not (Test-Path $target)) {
    if ($DryRun) { Write-Host "Would create: $target" }
    else { New-Item -ItemType Directory -Path $target -Force | Out-Null }
}

# --- Skills (flattened from category dirs) ---

$skillDirs = @("task", "project", "in-progress", "third-party")
$copied = 0
$skipped = 0

foreach ($dir in $skillDirs) {
    $parent = Join-Path $RepoPath $dir
    if (-not (Test-Path $parent)) { continue }

    Get-ChildItem $parent -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName "SKILL.md"
        if (-not (Test-Path $skillFile)) {
            Write-Host "  Skip: $dir/$($_.Name) (no SKILL.md)" -ForegroundColor DarkGray
            $skipped++
            return
        }

        $dest = Join-Path $target $_.Name

        if ($DryRun) {
            Write-Host "  Would copy: $dir/$($_.Name) -> $($_.Name)"
        } else {
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -Confirm:$false }
            Copy-Item $_.FullName $dest -Recurse -Force
            Write-Host "  Synced: $dir/$($_.Name)" -ForegroundColor Green
        }
        $copied++
    }
}

# --- Shared infrastructure (peer directories) ---

$sharedDirs = @("internals", "templates", "process", "schemas", "tests")
$sharedCount = 0

foreach ($dir in $sharedDirs) {
    $src = Join-Path $RepoPath $dir
    if (-not (Test-Path $src)) { continue }

    $dest = Join-Path $claudeRoot $dir

    if ($DryRun) {
        Write-Host "  Would sync shared: $dir/"
    } else {
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -Confirm:$false }
        Copy-Item $src $dest -Recurse -Force
        Write-Host "  Synced shared: $dir/" -ForegroundColor Cyan
    }
    $sharedCount++
}

# --- Agents (file-by-file, preserves non-waypoint agents) ---

$agentSrc = Join-Path $RepoPath "agents"
$agentDest = Join-Path $claudeRoot "agents"
$agentCount = 0

if (Test-Path $agentSrc) {
    if (-not (Test-Path $agentDest)) {
        if ($DryRun) { Write-Host "  Would create: agents/" }
        else { New-Item -ItemType Directory -Path $agentDest -Force | Out-Null }
    }

    Get-ChildItem $agentSrc -File | ForEach-Object {
        $dest = Join-Path $agentDest $_.Name

        if ($DryRun) {
            Write-Host "  Would sync agent: $($_.Name)"
        } else {
            Copy-Item $_.FullName $dest -Force
            Write-Host "  Synced agent: $($_.Name)" -ForegroundColor Yellow
        }
        $agentCount++
    }
}

# --- Root files ---

$rootFiles = @("CONCERNS-FORMAT.md", "README.md")
$rootCount = 0

foreach ($file in $rootFiles) {
    $src = Join-Path $RepoPath $file
    if (-not (Test-Path $src)) { continue }

    $dest = Join-Path (Join-Path $claudeRoot "skills") $file

    if ($DryRun) {
        Write-Host "  Would sync root: $file"
    } else {
        Copy-Item $src $dest -Force
        Write-Host "  Synced root: $file" -ForegroundColor Cyan
    }
    $rootCount++
}

# --- Replicate to cswap inactive sessions ---

$cswapCount = 0
foreach ($root in $syncRoots) {
    if ($root -eq $claudeRoot) { continue }
    $sessionSkills = Join-Path $root "skills"
    if (-not (Test-Path $sessionSkills)) {
        if (-not $DryRun) { New-Item -ItemType Directory -Path $sessionSkills -Force | Out-Null }
    }

    # Skills
    Get-ChildItem (Join-Path $claudeRoot "skills") -Directory | ForEach-Object {
        $dest = Join-Path $sessionSkills $_.Name
        if (-not $DryRun) {
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -Confirm:$false }
            Copy-Item $_.FullName $dest -Recurse -Force
        }
    }
    # Root files in skills/
    foreach ($file in $rootFiles) {
        $src = Join-Path (Join-Path $claudeRoot "skills") $file
        if (Test-Path $src) {
            if (-not $DryRun) { Copy-Item $src (Join-Path $sessionSkills $file) -Force }
        }
    }
    # Agents
    if (Test-Path $agentDest) {
        $sessionAgents = Join-Path $root "agents"
        if (-not (Test-Path $sessionAgents)) {
            if (-not $DryRun) { New-Item -ItemType Directory -Path $sessionAgents -Force | Out-Null }
        }
        Get-ChildItem $agentDest -File | ForEach-Object {
            if (-not $DryRun) { Copy-Item $_.FullName (Join-Path $sessionAgents $_.Name) -Force }
        }
    }
    # Shared dirs
    foreach ($dir in $sharedDirs) {
        $src = Join-Path $claudeRoot $dir
        if (-not (Test-Path $src)) { continue }
        $dest = Join-Path $root $dir
        if (-not $DryRun) {
            if (Test-Path $dest) { Remove-Item $dest -Recurse -Force -Confirm:$false }
            Copy-Item $src $dest -Recurse -Force
        }
    }

    $sessionName = Split-Path $root -Leaf
    if ($DryRun) { Write-Host "  Would replicate to cswap session: $sessionName" }
    else { Write-Host "  Replicated to cswap session: $sessionName" -ForegroundColor Magenta }
    $cswapCount++
}

Write-Host "`n$copied skills, $agentCount agents, $sharedCount shared dirs, $rootCount root files $(if ($DryRun) {'would be '})synced. $skipped skipped. $cswapCount cswap session(s) replicated."
