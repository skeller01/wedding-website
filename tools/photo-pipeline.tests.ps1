$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("wedding-photo-pipeline-" + [System.Guid]::NewGuid().ToString("N"))

function New-TestImage {
  param([string]$Path, [int]$Width, [int]$Height)
  Add-Type -AssemblyName System.Drawing
  $parent = Split-Path -Parent $Path
  New-Item -ItemType Directory -Path $parent -Force | Out-Null
  $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
  try {
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
      $graphics.Clear([System.Drawing.Color]::FromArgb(220, 205, 180))
    }
    finally {
      $graphics.Dispose()
    }
    $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)
  }
  finally {
    $bitmap.Dispose()
  }
}

function Assert-True {
  param([bool]$Condition, [string]$Message)
  if (-not $Condition) {
    throw $Message
  }
}

try {
  $source = Join-Path $tmp "source"
  New-TestImage -Path (Join-Path $source "ceremony\same-name.jpg") -Width 2200 -Height 1400
  New-TestImage -Path (Join-Path $source "reception\same-name.jpg") -Width 1800 -Height 1200
  $curationPath = Join-Path $tmp "private\curation.json"
  $curation = @{
    version = 1
    albums = @{}
    photos = @{
      "ceremony/same-name.jpg" = @{
        state = "hero"
        title = "Ceremony Hero"
        caption = ""
        focalPoint = @{ x = 50; y = 50 }
      }
      "reception/same-name.jpg" = @{
        state = "include"
        title = "Reception Include"
        caption = ""
        focalPoint = @{ x = 50; y = 50 }
      }
    }
  }
  New-Item -ItemType Directory -Path (Split-Path -Parent $curationPath) -Force | Out-Null
  $curation | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $curationPath -Encoding UTF8

  Push-Location $root
  try {
    & .\tools\photo-pipeline.ps1 generate `
      -SourceDir $source `
      -CurationPath $curationPath `
      -OutputDir (Join-Path $tmp "public\images") `
      -PublicDataPath (Join-Path $tmp "public\data\gallery-data.json") `
      -PublicDataScriptPath (Join-Path $tmp "public\js\gallery-data.js") `
      -ReportPath (Join-Path $tmp "public\images\generation-report.json")
  }
  finally {
    Pop-Location
  }

  $dataPath = Join-Path $tmp "public\data\gallery-data.json"
  $reportPath = Join-Path $tmp "public\images\generation-report.json"
  Assert-True (Test-Path -LiteralPath $dataPath) "Expected public gallery metadata."
  Assert-True (Test-Path -LiteralPath $reportPath) "Expected generation report."

  $data = Get-Content -LiteralPath $dataPath -Raw | ConvertFrom-Json
  $report = Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json
  Assert-True ($data.photos.Count -eq 2) "Expected two public photos."
  Assert-True (($data.photos | Select-Object -ExpandProperty id -Unique).Count -eq 2) "Expected unique photo IDs."
  Assert-True ($data.albums.Count -eq 2) "Expected folder-preserving albums."
  Assert-True ($data.heroPhotos.Count -eq 1) "Expected one hero photo."
  Assert-True ($report.publishedCount -eq 2) "Expected report published count."

  foreach ($photo in $data.photos) {
    foreach ($kind in @("thumb", "large")) {
      $path = Join-Path $root $photo.$kind
      if (-not (Test-Path -LiteralPath $path)) {
        $path = $photo.$kind
      }
      Assert-True (Test-Path -LiteralPath $path) "Expected generated $kind file for $($photo.id)."
    }
    $heroPath = $photo.hero
    if ($photo.isHero) {
      $path = Join-Path $root $heroPath
      if (-not (Test-Path -LiteralPath $path)) {
        $path = $heroPath
      }
      Assert-True (Test-Path -LiteralPath $path) "Expected generated hero file for $($photo.id)."
    }
    else {
      Assert-True ($photo.hero -eq $photo.large) "Expected non-hero photo to reuse large path for hero metadata."
    }
  }

  Write-Host "photo-pipeline tests passed"
}
finally {
  if (Test-Path -LiteralPath $tmp) {
    Remove-Item -LiteralPath $tmp -Recurse -Force
  }
}
