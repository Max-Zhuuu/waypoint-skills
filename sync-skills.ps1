# Sync waypoint skills to ~/.claude/skills/ via directory junctions (zero-copy).
# Also syncs shared infrastructure: internals/, templates/, process/, schemas/, tests/.
#
# The repo organizes skills under task/ and project/ for readability.
# Claude Code discovers skills one level deep in ~/.claude/skills/.
# This script bridges the gap: create a junction from ~/.claude/skills/{name}/
# pointing to repo/{category}/{name}/. Edits in either location hit the same files.
# git status in the repo reflects changes immediately - no reverse sync needed.
#
# Non-waypoint skills (directories without a matching repo source) are left untouched.
#
# v5: Junctions replace copies. Single source of truth.
#     Agents still sync file-by-file (junctions are directory-only on Windows).
#     Root files still copy (junction is directory-only).
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

function Ensure-Dir($path) {
    if (-not (Test-Path $path)) {
        if ($DryRun) { Write-Host "  Would create: $path" }
        else { New-Item -ItemType Directory -Path $path -Force | Out-Null }
    }
}

function Make-Junction($link, $target) {
    # If link exists: check if it's already the right junction
    if (Test-Path $link) {
        $item = Get-Item $link -Force
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            $existing = $item.Target
            if ($existing -eq $target -or $existing -eq (Resolve-Path $target).Path) {
                return "unchanged"
            }
        }
        # Wrong target or not a junction - remove
        if ($DryRun) { Write-Host "  Would remove: $link" }
        else { Remove-Item $link -Recurse -Force -Confirm:$false }
    }

    if ($DryRun) {
        Write-Host "  Would junction: $link -> $target"
        return "created"
    }

    New-Item -ItemType Junction -Path $link -Target $target | Out-Null
    return "created"
}

# --- Skills (junctioned from category dirs) ---

$skillDirs = @("task", "project", "in-progress", "third-party")
$linked = 0
$unchanged = 0
$skipped = 0

foreach ($root in $syncRoots) {
    $skillsDir = Join-Path $root "skills"
    Ensure-Dir $skillsDir

    foreach ($dir in $skillDirs) {
        $parent = Join-Path $RepoPath $dir
        if (-not (Test-Path $parent)) { continue }

        Get-ChildItem $parent -Directory | ForEach-Object {
            $skillFile = Join-Path $_.FullName "SKILL.md"
            if (-not (Test-Path $skillFile)) {
                $skipped++
                return
            }

            $dest = Join-Path $skillsDir $_.Name
            $result = Make-Junction $dest $_.FullName

            if ($result -eq "created") {
                Write-Host "  Linked: $dir/$($_.Name)" -ForegroundColor Green
                $linked++
            } else {
                $unchanged++
            }
        }
    }
}

# --- Shared infrastructure (junctioned peer directories) ---

$sharedDirs = @("internals", "templates", "process", "schemas", "tests", "scripts")
$sharedCount = 0

foreach ($root in $syncRoots) {
    foreach ($dir in $sharedDirs) {
        $src = Join-Path $RepoPath $dir
        if (-not (Test-Path $src)) { continue }

        $dest = Join-Path $root $dir
        $result = Make-Junction $dest $src

        if ($result -eq "created") {
            Write-Host "  Linked shared: $dir/ -> $root" -ForegroundColor Cyan
            $sharedCount++
        }
    }
}

# --- Agents (file-by-file copy, preserves non-waypoint agents) ---

$agentSrc = Join-Path $RepoPath "agents"
$agentCount = 0

if (Test-Path $agentSrc) {
    foreach ($root in $syncRoots) {
        $agentDest = Join-Path $root "agents"
        Ensure-Dir $agentDest

        Get-ChildItem $agentSrc -File | ForEach-Object {
            $dest = Join-Path $agentDest $_.Name

            if ($DryRun) {
                Write-Host "  Would sync agent: $($_.Name)"
            } else {
                Copy-Item $_.FullName $dest -Force
            }
            $agentCount++
        }
    }
}

# --- Root files (file copy, junction is directory-only) ---

$rootFiles = @("CONCERNS-FORMAT.md", "README.md")
$rootCount = 0

foreach ($root in $syncRoots) {
    $skillsDir = Join-Path $root "skills"
    foreach ($file in $rootFiles) {
        $src = Join-Path $RepoPath $file
        if (-not (Test-Path $src)) { continue }

        $dest = Join-Path $skillsDir $file

        if ($DryRun) {
            Write-Host "  Would sync root: $file"
        } else {
            Copy-Item $src $dest -Force
        }
        $rootCount++
    }
}

# --- Summary ---

$sessionCount = $syncRoots.Count
Write-Host "`n$linked junctions created, $unchanged unchanged, $sharedCount shared dirs linked, $agentCount agents synced, $rootCount root files copied across $sessionCount target(s). $skipped skills skipped (no SKILL.md)."
if ($unchanged -gt 0) {
    Write-Host "($unchanged junctions already pointed to the correct target)" -ForegroundColor DarkGray
}
