param(
  [string]$ManifestPath = "documentation/planning/working/prototypes/photo-curation/manifest.json",
  [string]$CurationPath = ".photo-curation/curation.json"
)

$ErrorActionPreference = "Stop"

function Resolve-ProjectPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return [System.IO.Path]::GetFullPath($Path)
  }
  return [System.IO.Path]::GetFullPath((Join-Path (Get-Location).Path $Path))
}

function ConvertTo-Hashtable {
  param($InputObject)
  if ($null -eq $InputObject) { return $null }
  if ($InputObject -is [System.Collections.IDictionary]) {
    $hash = @{}
    foreach ($key in $InputObject.Keys) {
      $hash[$key] = ConvertTo-Hashtable $InputObject[$key]
    }
    return $hash
  }
  if ($InputObject -is [System.Management.Automation.PSCustomObject]) {
    $hash = @{}
    foreach ($property in $InputObject.PSObject.Properties) {
      $hash[$property.Name] = ConvertTo-Hashtable $property.Value
    }
    return $hash
  }
  if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
    $list = @()
    foreach ($item in $InputObject) {
      $list += ,(ConvertTo-Hashtable $item)
    }
    return $list
  }
  return $InputObject
}

function New-DefaultEntry {
  param([string]$State)
  return @{
    state = $State
    title = ""
    caption = ""
    focalPoint = @{ x = 50; y = 50 }
  }
}

$manifest = Get-Content -LiteralPath (Resolve-ProjectPath $ManifestPath) -Raw | ConvertFrom-Json
$curationResolved = Resolve-ProjectPath $CurationPath
if (Test-Path -LiteralPath $curationResolved) {
  $curation = ConvertTo-Hashtable (Get-Content -LiteralPath $curationResolved -Raw | ConvertFrom-Json)
}
else {
  $curation = @{ version = 1; albums = @{}; photos = @{} }
}
if (-not $curation.ContainsKey("version")) { $curation["version"] = 1 }
if (-not $curation.ContainsKey("albums") -or $null -eq $curation["albums"]) { $curation["albums"] = @{} }
if (-not $curation.ContainsKey("photos") -or $null -eq $curation["photos"]) { $curation["photos"] = @{} }

# Visual curation from the 2026-06-21 prototype pass.
$includeIndexes = @(
  228,229,232,234,235,237,241,243,245,
  248,249,252,256,258,260,262,272,273,276,278,
  281,283,287,290,293,296,304,308,310,312,313,
  316,321,325,326,330,334,341,342,344,348,
  353,357,361,368,370,383,
  386,393,396,399,404,408,410,411,414,419,420,
  421,424,425,427,432,434,435,439,443,445,449,453,
  460,461,463,468,470,471,473,476,478,479,480,483,489,
  491,493,500,503,505,509,511,514,517,520,525,
  526,528,529,531,535,537,540,544,545,549,550,555,557,560,
  564,567,572,575,576,577,579,580,581,583,586,589,592,594,
  596,598,600,601,602,607,608,615,618,621,623,627,628,629,
  631,633,635,638,642,647,653,655,656,658,660,664,668,669,
  681,688,689,692,694,699,704,708,710,713,718,721,725,726,729,735,
  739,741,746,749,755,756,758,760,762,764,766,767,769,771,775,779,783,785,786
)

$heroIndexes = @(283,341,419,439,491,517,572,592,699,704,725,785)
$highlightIndexes = @(
  249,258,281,313,330,334,342,353,383,404,411,421,425,453,
  460,468,473,489,503,514,528,545,581,598,601,608,621,629,
  638,653,681,692,713,749,775,783,786
)

$includeSet = @{}
$heroSet = @{}
$highlightSet = @{}
foreach ($index in $includeIndexes) { $includeSet[[int]$index] = $true }
foreach ($index in $heroIndexes) { $heroSet[[int]$index] = $true }
foreach ($index in $highlightIndexes) { $highlightSet[[int]$index] = $true }

if (-not $curation["albums"].ContainsKey("wedding-archive")) {
  $curation["albums"]["wedding-archive"] = @{ displayName = "Wedding Archive"; coverId = "" }
}

foreach ($item in $manifest) {
  $path = $item.relativePath
  if (-not $curation["photos"].ContainsKey($path) -or $null -eq $curation["photos"][$path]) {
    $curation["photos"][$path] = New-DefaultEntry -State "exclude"
  }
  $entry = $curation["photos"][$path]
  if (-not $entry.ContainsKey("title")) { $entry["title"] = "" }
  if (-not $entry.ContainsKey("caption")) { $entry["caption"] = "" }
  if (-not $entry.ContainsKey("focalPoint") -or $null -eq $entry["focalPoint"]) {
    $entry["focalPoint"] = @{ x = 50; y = 50 }
  }
  $state = "exclude"
  if ($includeSet.ContainsKey([int]$item.index)) { $state = "include" }
  if ($highlightSet.ContainsKey([int]$item.index)) { $state = "highlight" }
  if ($heroSet.ContainsKey([int]$item.index)) { $state = "hero" }
  $entry["state"] = $state
}

$backupPath = Join-Path (Split-Path -Parent $curationResolved) ("curation.before-auto-selection-{0}.json" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
if (Test-Path -LiteralPath $curationResolved) {
  Copy-Item -LiteralPath $curationResolved -Destination $backupPath
}

$curation | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $curationResolved -Encoding UTF8

$summary = $manifest | ForEach-Object {
  $state = $curation["photos"][$_.relativePath]["state"]
  [pscustomobject]@{ state = $state }
} | Group-Object state | Sort-Object Name | Select-Object Name,Count

$summary | Format-Table -AutoSize
Write-Host "Backup: $backupPath"
