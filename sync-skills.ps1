# Sync waypoint skills to ~/.claude/skills/ (flattened)
#
# The repo organizes skills under task/ and project/ for readability.
# Claude Code discovers skills one level deep in ~/.claude/skills/.
# This script bridges the gap: find every SKILL.md, copy its directory
# to ~/.claude/skills/{name}/.
#
# Usage: .\sync-skills.ps1 [-RepoPath <path>] [-DryRun]

param(
    [string]$RepoPath = $PSScriptRoot,
    [switch]$DryRun
)

$target = Join-Path $env:USERPROFILE ".claude\skills"

if (-not (Test-Path $target)) {
    if ($DryRun) { Write-Host "Would create: $target" }
    else { New-Item -ItemType Directory -Path $target -Force | Out-Null }
}

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

Write-Host "`n$copied skills $(if ($DryRun) {'would be '})synced, $skipped skipped."
