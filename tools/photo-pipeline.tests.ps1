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

  Push-Location $root
  try {
    & .\tools\photo-pipeline.ps1 generate `
      -SourceDir $source `
      -CurationPath (Join-Path $tmp "private\curation.json") `
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
  Assert-True ($report.publishedCount -eq 2) "Expected report published count."

  foreach ($photo in $data.photos) {
    foreach ($kind in @("thumb", "large", "hero")) {
      $path = Join-Path $root $photo.$kind
      if (-not (Test-Path -LiteralPath $path)) {
        $path = $photo.$kind
      }
      Assert-True (Test-Path -LiteralPath $path) "Expected generated $kind file for $($photo.id)."
    }
  }

  Write-Host "photo-pipeline tests passed"
}
finally {
  if (Test-Path -LiteralPath $tmp) {
    Remove-Item -LiteralPath $tmp -Recurse -Force
  }
}
