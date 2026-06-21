param(
  [string]$SourceDir = "images/wedding_source",
  [string]$OutputDir = "documentation/planning/working/prototypes/photo-curation",
  [int]$Columns = 7,
  [int]$Rows = 5,
  [int]$ThumbWidth = 220,
  [int]$ThumbHeight = 165
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Resolve-ProjectPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return [System.IO.Path]::GetFullPath($Path)
  }
  return [System.IO.Path]::GetFullPath((Join-Path (Get-Location).Path $Path))
}

function Get-ShortLabel {
  param([int]$Index, [string]$Name)
  if ($Name -match "HIGHLIGHTS-(\d+)") {
    return ("{0:D3} H-{1}" -f $Index, $Matches[1])
  }
  if ($Name -match "-(\d+)\.[^.]+$") {
    return ("{0:D3} F-{1}" -f $Index, $Matches[1])
  }
  if ($Name -match "^(\d{8}_\d{6})") {
    return ("{0:D3} P-{1}" -f $Index, $Matches[1])
  }
  return ("{0:D3} {1}" -f $Index, ([System.IO.Path]::GetFileNameWithoutExtension($Name)))
}

function Get-ImageMetrics {
  param([string]$Path)
  $image = [System.Drawing.Image]::FromFile($Path)
  try {
    $sampleWidth = 64
    $sampleHeight = [Math]::Max(1, [int][Math]::Round($image.Height * ($sampleWidth / $image.Width)))
    $bitmap = New-Object System.Drawing.Bitmap $sampleWidth, $sampleHeight
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.DrawImage($image, 0, 0, $sampleWidth, $sampleHeight)
      }
      finally {
        $graphics.Dispose()
      }

      $brightnessTotal = 0.0
      $saturationTotal = 0.0
      for ($y = 0; $y -lt $sampleHeight; $y++) {
        for ($x = 0; $x -lt $sampleWidth; $x++) {
          $pixel = $bitmap.GetPixel($x, $y)
          $max = [Math]::Max($pixel.R, [Math]::Max($pixel.G, $pixel.B))
          $min = [Math]::Min($pixel.R, [Math]::Min($pixel.G, $pixel.B))
          $brightnessTotal += (($pixel.R + $pixel.G + $pixel.B) / 3.0)
          $saturationTotal += ($max - $min)
        }
      }

      $edgeTotal = 0.0
      for ($y = 1; $y -lt ($sampleHeight - 1); $y++) {
        for ($x = 1; $x -lt ($sampleWidth - 1); $x++) {
          $center = $bitmap.GetPixel($x, $y)
          $right = $bitmap.GetPixel(($x + 1), $y)
          $down = $bitmap.GetPixel($x, ($y + 1))
          $centerLum = (($center.R + $center.G + $center.B) / 3.0)
          $rightLum = (($right.R + $right.G + $right.B) / 3.0)
          $downLum = (($down.R + $down.G + $down.B) / 3.0)
          $edgeTotal += [Math]::Abs($centerLum - $rightLum) + [Math]::Abs($centerLum - $downLum)
        }
      }

      $pixelCount = [Math]::Max(1, $sampleWidth * $sampleHeight)
      return @{
        width = $image.Width
        height = $image.Height
        brightness = [Math]::Round($brightnessTotal / $pixelCount, 2)
        saturation = [Math]::Round($saturationTotal / $pixelCount, 2)
        edge = [Math]::Round($edgeTotal / $pixelCount, 2)
      }
    }
    finally {
      $bitmap.Dispose()
    }
  }
  finally {
    $image.Dispose()
  }
}

$sourceRoot = Resolve-ProjectPath $SourceDir
$outputRoot = Resolve-ProjectPath $OutputDir
if (-not (Test-Path -LiteralPath $outputRoot)) {
  New-Item -ItemType Directory -Path $outputRoot | Out-Null
}

$extensions = @(".jpg", ".jpeg", ".png")
$files = Get-ChildItem -LiteralPath $sourceRoot -File -Recurse |
  Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() } |
  Sort-Object Name

$manifest = @()
$index = 0
foreach ($file in $files) {
  $index += 1
  $metrics = Get-ImageMetrics -Path $file.FullName
  $kind = if ($file.Name -match "HIGHLIGHTS") { "highlight-export" } elseif ($file.Name -match "^20\d{6}_") { "phone-date" } else { "full-export" }
  $manifest += [pscustomobject]@{
    index = $index
    label = Get-ShortLabel -Index $index -Name $file.Name
    fileName = $file.Name
    relativePath = $file.Name
    kind = $kind
    width = $metrics.width
    height = $metrics.height
    brightness = $metrics.brightness
    saturation = $metrics.saturation
    edge = $metrics.edge
    sizeMB = [Math]::Round($file.Length / 1MB, 3)
  }
}

$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $outputRoot "manifest.json") -Encoding UTF8
$manifest | Export-Csv -LiteralPath (Join-Path $outputRoot "manifest.csv") -NoTypeInformation -Encoding UTF8

$perSheet = $Columns * $Rows
$sheetWidth = ($Columns * $ThumbWidth)
$labelHeight = 26
$sheetHeight = ($Rows * ($ThumbHeight + $labelHeight))
$font = New-Object System.Drawing.Font "Arial", 10
$labelBrush = [System.Drawing.Brushes]::Black
$backgroundBrush = [System.Drawing.Brushes]::White
$borderPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(210, 210, 210)), 1

for ($sheetIndex = 0; $sheetIndex -lt [Math]::Ceiling($files.Count / $perSheet); $sheetIndex++) {
  $bitmap = New-Object System.Drawing.Bitmap $sheetWidth, $sheetHeight
  try {
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
      $graphics.Clear([System.Drawing.Color]::White)
      $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
      for ($slot = 0; $slot -lt $perSheet; $slot++) {
        $global = ($sheetIndex * $perSheet) + $slot
        if ($global -ge $files.Count) { break }
        $file = $files[$global]
        $entry = $manifest[$global]
        $col = $slot % $Columns
        $row = [Math]::Floor($slot / $Columns)
        $x = $col * $ThumbWidth
        $y = $row * ($ThumbHeight + $labelHeight)

        $image = [System.Drawing.Image]::FromFile($file.FullName)
        try {
          $scale = [Math]::Min($ThumbWidth / $image.Width, $ThumbHeight / $image.Height)
          $drawWidth = [Math]::Max(1, [int][Math]::Round($image.Width * $scale))
          $drawHeight = [Math]::Max(1, [int][Math]::Round($image.Height * $scale))
          $drawX = $x + [int](($ThumbWidth - $drawWidth) / 2)
          $drawY = $y + [int](($ThumbHeight - $drawHeight) / 2)
          $graphics.FillRectangle($backgroundBrush, $x, $y, $ThumbWidth, $ThumbHeight)
          $graphics.DrawImage($image, $drawX, $drawY, $drawWidth, $drawHeight)
        }
        finally {
          $image.Dispose()
        }
        $graphics.DrawRectangle($borderPen, $x, $y, ($ThumbWidth - 1), ($ThumbHeight - 1))
        $graphics.DrawString($entry.label, $font, $labelBrush, ($x + 4), ($y + $ThumbHeight + 4))
      }
    }
    finally {
      $graphics.Dispose()
    }
    $sheetPath = Join-Path $outputRoot ("sheet-{0:D2}.jpg" -f ($sheetIndex + 1))
    $bitmap.Save($sheetPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
  }
  finally {
    $bitmap.Dispose()
  }
}

$font.Dispose()
$borderPen.Dispose()
Write-Host "Wrote $($files.Count) manifest rows and $([Math]::Ceiling($files.Count / $perSheet)) contact sheet(s) to $OutputDir."
