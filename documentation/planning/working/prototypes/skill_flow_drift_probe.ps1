param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")).Path
)

$ErrorActionPreference = "Stop"

function Read-Text($Path) {
    if (Test-Path -LiteralPath $Path) {
        return Get-Content -LiteralPath $Path -Raw
    }
    return ""
}

$sprintIndexPath = Join-Path $Root "documentation\planning\sprints\README.md"
$sprintIndex = Read-Text $sprintIndexPath
$sprintRows = @()

foreach ($line in ($sprintIndex -split "`r?`n")) {
    if ($line -match "^\|\s*([^|]+?)\s*\|\s*\[([^\]]+)\]\(([^)]+)\)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|") {
        $order = $matches[1].Trim()
        $name = $matches[2].Trim()
        $file = $matches[3].Trim()
        $status = $matches[5].Trim()
        if ($order -ne "---:" -and $name -ne "Sprint Plan") {
            $sprintRows += [pscustomobject]@{
                Order = $order
                Name = $name
                File = $file
                IndexStatus = $status
            }
        }
    }
}

$statusDrift = foreach ($row in $sprintRows) {
    $path = Join-Path (Join-Path $Root "documentation\planning\sprints") $row.File
    $text = Read-Text $path
    $hasImplementedEvidence = $text -match "Implemented 2026" -or $text -match "\|\s*[^|]+\s*\|\s*Implemented\s*\|"
    if ($row.IndexStatus -eq "Planned" -and $hasImplementedEvidence) {
        [pscustomobject]@{
            Sprint = $row.Name
            IndexStatus = $row.IndexStatus
            Evidence = "Sprint file contains implementation evidence"
        }
    }
}

$prdPath = Join-Path $Root "documentation\planning\prd.md"
$requirementsPath = Join-Path $Root "documentation\requirements\requirements.md"
$photoNotesPath = Join-Path $Root "documentation\planning\working\photo-pipeline-notes.md"

$prd = Read-Text $prdPath
$requirements = Read-Text $requirementsPath
$photoNotes = Read-Text $photoNotesPath

$pipelineConflict = [pscustomobject]@{
    PrdPrefersPythonPillow = [bool]($prd -match "Prefer a local Python/Pillow|preferred current implementation.*Python/Pillow")
    CurrentDocsMentionPowerShellDotNet = [bool](($requirements + "`n" + $photoNotes) -match "PowerShell/.NET")
}

$historyFiles = Get-ChildItem -LiteralPath (Join-Path $Root "documentation") -Recurse -File -Include *.md
$historicalMentions = foreach ($file in $historyFiles) {
    $text = Read-Text $file.FullName
    $contactCount = ([regex]::Matches($text, "contact\.html")).Count
    $sixPageCount = ([regex]::Matches($text, "6 HTML pages|six public pages|six pages")).Count
    if ($contactCount -gt 0 -or $sixPageCount -gt 0) {
        [pscustomobject]@{
            Path = $file.FullName.Substring($Root.Length + 1)
            ContactHtmlMentions = $contactCount
            SixPageMentions = $sixPageCount
        }
    }
}

$legacyFiles = @(
    "js\app.js",
    "js\jquery.countdown.js",
    "js\jqBootstrapValidation.js",
    "css\jquery.countdown.js"
)

$legacyPresent = foreach ($file in $legacyFiles) {
    $path = Join-Path $Root $file
    if (Test-Path -LiteralPath $path) {
        [pscustomobject]@{ Path = $file; Present = $true }
    }
}

Write-Host "Skill Flow Drift Probe"
Write-Host "======================"
Write-Host ""

Write-Host "Sprint index rows marked Planned while implementation evidence exists:"
if ($statusDrift) {
    $statusDrift | Format-Table -AutoSize
} else {
    Write-Host "None"
}

Write-Host ""
Write-Host "Photo pipeline implementation-choice conflict:"
$pipelineConflict | Format-List

Write-Host ""
Write-Host "Historical mention hotspots for contact.html or six-page assumptions:"
if ($historicalMentions) {
    $historicalMentions | Sort-Object ContactHtmlMentions, SixPageMentions -Descending | Select-Object -First 12 | Format-Table -AutoSize
} else {
    Write-Host "None"
}

Write-Host ""
Write-Host "Legacy cleanup candidate files still present:"
if ($legacyPresent) {
    $legacyPresent | Format-Table -AutoSize
} else {
    Write-Host "None"
}
