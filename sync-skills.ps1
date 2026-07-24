# Sync waypoint skills to ~/.claude/skills/ (flattened)
# Also syncs shared infrastructure: internals/, templates/, process/, and root files.
#
# The repo organizes skills under task/ and project/ for readability.
# Claude Code discovers skills one level deep in ~/.claude/skills/.
# This script bridges the gap: find every SKILL.md, copy its directory
# to ~/.claude/skills/{name}/, then sync shared directories.
#
# Usage: .\sync-skills.ps1 [-RepoPath <path>] [-DryRun]

param(
    [string]$RepoPath = $PSScriptRoot,
    [switch]$DryRun
)

$claudeRoot = Join-Path $env:USERPROFILE ".claude"
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

$sharedDirs = @("internals", "templates", "process")
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

Write-Host "`n$copied skills, $sharedCount shared dirs, $rootCount root files $(if ($DryRun) {'would be '})synced. $skipped skipped."
