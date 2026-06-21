param(
  [Parameter(Position = 0)]
  [ValidateSet("init", "generate", "serve")]
  [string]$Command = "generate",

  [string]$SourceDir = "images/wedding_source",
  [string]$CurationPath = ".photo-curation/curation.json",
  [string]$OutputDir = "images/gallery/generated",
  [string]$PublicDataPath = "data/gallery-data.json",
  [string]$PublicDataScriptPath = "js/gallery-data.js",
  [string]$ReportPath = "",
  [int]$Port = 8787,
  [switch]$UseExistingAsPlaceholders
)

$ErrorActionPreference = "Stop"
$script:ProjectRoot = (Get-Location).Path
$script:ImageExtensions = @(".jpg", ".jpeg", ".png")

function Resolve-ProjectPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return [System.IO.Path]::GetFullPath($Path)
  }
  return [System.IO.Path]::GetFullPath((Join-Path $script:ProjectRoot $Path))
}

function ConvertTo-Hashtable {
  param($InputObject)
  if ($null -eq $InputObject) {
    return $null
  }
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

function Read-JsonHashtable {
  param([string]$Path)
  $resolved = Resolve-ProjectPath $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    return @{ version = 1; albums = @{}; photos = @{} }
  }
  $raw = Get-Content -LiteralPath $resolved -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) {
    return @{ version = 1; albums = @{}; photos = @{} }
  }
  $data = ConvertTo-Hashtable ($raw | ConvertFrom-Json)
  if (-not $data.ContainsKey("version")) { $data["version"] = 1 }
  if (-not $data.ContainsKey("albums") -or $null -eq $data["albums"]) { $data["albums"] = @{} }
  if (-not $data.ContainsKey("photos") -or $null -eq $data["photos"]) { $data["photos"] = @{} }
  return $data
}

function Write-JsonFile {
  param($Data, [string]$Path)
  $resolved = Resolve-ProjectPath $Path
  $parent = Split-Path -Parent $resolved
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent | Out-Null
  }
  $Data | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $resolved -Encoding UTF8
}

function Get-SafeSlug {
  param([string]$Value, [string]$Fallback = "item")
  $slug = $Value.ToLowerInvariant()
  $slug = $slug -replace "\\", "-"
  $slug = $slug -replace "/", "-"
  $slug = $slug -replace "\.[^.]+$", ""
  $slug = $slug -replace "[^a-z0-9]+", "-"
  $slug = $slug.Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return $Fallback
  }
  return $slug
}

function Get-ShaFragment {
  param([string]$Value)
  $sha = [System.Security.Cryptography.SHA1]::Create()
  try {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
    $hash = $sha.ComputeHash($bytes)
    return ([System.BitConverter]::ToString($hash) -replace "-", "").Substring(0, 8).ToLowerInvariant()
  }
  finally {
    $sha.Dispose()
  }
}

function Get-RelativePath {
  param([string]$BasePath, [string]$Path)
  $baseUri = New-Object System.Uri(($BasePath.TrimEnd("\", "/") + [System.IO.Path]::DirectorySeparatorChar))
  $pathUri = New-Object System.Uri($Path)
  return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($pathUri).ToString()).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

function Convert-ToPublicPath {
  param([string]$Path)
  return $Path.Replace("\", "/")
}

function Get-PhotoFiles {
  param([string]$Root, [switch]$UseExistingAsPlaceholders)
  $resolved = Resolve-ProjectPath $Root
  if ($UseExistingAsPlaceholders) {
    $imagesRoot = Resolve-ProjectPath "images"
    if (-not (Test-Path -LiteralPath $imagesRoot)) {
      return @()
    }
    return Get-ChildItem -LiteralPath $imagesRoot -File -Recurse |
      Where-Object {
        $script:ImageExtensions -contains $_.Extension.ToLowerInvariant() -and
        $_.FullName -notmatch "\\gallery\\generated\\"
      } |
      Sort-Object FullName
  }
  if (-not (Test-Path -LiteralPath $resolved)) {
    return @()
  }
  return Get-ChildItem -LiteralPath $resolved -File -Recurse |
    Where-Object { $script:ImageExtensions -contains $_.Extension.ToLowerInvariant() } |
    Sort-Object FullName
}

function New-DefaultCurationEntry {
  param([string]$State = "unreviewed")
  return @{
    state = $State
    title = ""
    caption = ""
    focalPoint = @{ x = 50; y = 50 }
  }
}

function Get-CurationEntry {
  param($Curation, [string]$RelativePath, [string]$DefaultState = "unreviewed")
  if (-not $Curation["photos"].ContainsKey($RelativePath)) {
    $Curation["photos"][$RelativePath] = New-DefaultCurationEntry -State $DefaultState
  }
  $entry = $Curation["photos"][$RelativePath]
  if (-not $entry.ContainsKey("state")) { $entry["state"] = $DefaultState }
  if (-not $entry.ContainsKey("title")) { $entry["title"] = "" }
  if (-not $entry.ContainsKey("caption")) { $entry["caption"] = "" }
  if (-not $entry.ContainsKey("focalPoint") -or $null -eq $entry["focalPoint"]) {
    $entry["focalPoint"] = @{ x = 50; y = 50 }
  }
  if (-not $entry["focalPoint"].ContainsKey("x")) { $entry["focalPoint"]["x"] = 50 }
  if (-not $entry["focalPoint"].ContainsKey("y")) { $entry["focalPoint"]["y"] = 50 }
  return $entry
}

function Get-AlbumInfo {
  param($Curation, [string]$AlbumId, [string]$FolderName)
  if (-not $Curation["albums"].ContainsKey($AlbumId)) {
    $Curation["albums"][$AlbumId] = @{
      displayName = (Get-Culture).TextInfo.ToTitleCase(($FolderName -replace "[-_]+", " "))
      coverId = ""
    }
  }
  $album = $Curation["albums"][$AlbumId]
  if (-not $album.ContainsKey("displayName") -or [string]::IsNullOrWhiteSpace($album["displayName"])) {
    $album["displayName"] = (Get-Culture).TextInfo.ToTitleCase(($FolderName -replace "[-_]+", " "))
  }
  if (-not $album.ContainsKey("coverId")) { $album["coverId"] = "" }
  return $album
}

function Save-ResizedJpeg {
  param(
    [string]$SourcePath,
    [string]$TargetPath,
    [int]$MaxWidth,
    [int]$Quality = 84
  )
  Add-Type -AssemblyName System.Drawing
  $parent = Split-Path -Parent $TargetPath
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent | Out-Null
  }
  $image = [System.Drawing.Image]::FromFile($SourcePath)
  try {
    $width = [Math]::Min($MaxWidth, $image.Width)
    $height = [Math]::Max(1, [int][Math]::Round($image.Height * ($width / $image.Width)))
    $bitmap = New-Object System.Drawing.Bitmap $width, $height
    try {
      $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
      try {
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.DrawImage($image, 0, 0, $width, $height)
      }
      finally {
        $graphics.Dispose()
      }
      $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" } | Select-Object -First 1
      $encoder = [System.Drawing.Imaging.Encoder]::Quality
      $parameters = New-Object System.Drawing.Imaging.EncoderParameters 1
      $parameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter $encoder, ([int64]$Quality)
      $bitmap.Save($TargetPath, $codec, $parameters)
      $parameters.Dispose()
    }
    finally {
      $bitmap.Dispose()
    }
  }
  finally {
    $image.Dispose()
  }
}

function Get-Inventory {
  param([string]$SourceRoot, [switch]$UseExistingAsPlaceholders)
  $sourceRootResolved = Resolve-ProjectPath $SourceRoot
  $files = Get-PhotoFiles -Root $SourceRoot -UseExistingAsPlaceholders:$UseExistingAsPlaceholders
  $items = @()
  foreach ($file in $files) {
    if ($UseExistingAsPlaceholders) {
      $relative = $file.Name
      $albumFolder = "wedding-archive"
      $albumId = "wedding-archive"
    }
    else {
      $relative = Get-RelativePath -BasePath $sourceRootResolved -Path $file.FullName
      $folder = Split-Path -Parent $relative
      if ([string]::IsNullOrWhiteSpace($folder)) {
        $albumFolder = "wedding-archive"
      }
      else {
        $albumFolder = Convert-ToPublicPath $folder
      }
      $albumId = Get-SafeSlug -Value $albumFolder -Fallback "wedding-archive"
    }
    $items += [pscustomobject]@{
      fullPath = $file.FullName
      relativePath = Convert-ToPublicPath $relative
      albumFolder = $albumFolder
      albumId = $albumId
    }
  }
  return $items
}

function Invoke-Generate {
  $curation = Read-JsonHashtable $CurationPath
  $items = Get-Inventory -SourceRoot $SourceDir -UseExistingAsPlaceholders:$UseExistingAsPlaceholders
  $outputResolved = Resolve-ProjectPath $OutputDir
  if (Test-Path -LiteralPath $outputResolved) {
    Remove-Item -LiteralPath $outputResolved -Recurse -Force
  }
  New-Item -ItemType Directory -Path $outputResolved | Out-Null

  $seenIds = @{}
  $albums = @{}
  $photos = @()
  $warnings = @()
  $placeholderHeroCount = 0
  $placeholderPublishNames = @(
    "sonia_steve_resized.jpg",
    "sonia_steve.jpg",
    "sonia_steve2.jpg",
    "IMG_07791.jpg",
    "IMG_07791 (1).jpg",
    "IMG_43151.jpg",
    "IMG_43821.jpg",
    "IMG_56321.jpg",
    "golden_rose.jpg",
    "rose_border.jpg"
  )
  $placeholderHeroNames = @(
    "sonia_steve_resized.jpg",
    "sonia_steve.jpg",
    "sonia_steve2.jpg",
    "IMG_07791.jpg",
    "IMG_07791 (1).jpg"
  )
  $placeholderTitles = @{
    "sonia_steve_resized.jpg" = "Sonia and Steve"
    "sonia_steve.jpg" = "Together"
    "sonia_steve2.jpg" = "Wedding Memory"
    "IMG_07791.jpg" = "Portrait"
    "IMG_07791 (1).jpg" = "Portrait"
    "IMG_43151.jpg" = "Wedding Day"
    "IMG_43821.jpg" = "Celebration"
    "IMG_56321.jpg" = "Weekend"
    "golden_rose.jpg" = "Golden Rose"
    "rose_border.jpg" = "Floral Detail"
  }
  $placeholderCaptions = @{
    "sonia_steve_resized.jpg" = "A favorite opening image for the archive."
    "sonia_steve.jpg" = "A quiet moment from the wedding collection."
    "sonia_steve2.jpg" = "One of the small memories worth keeping close."
    "IMG_07791.jpg" = "A portrait placeholder until the full photo set arrives."
    "IMG_07791 (1).jpg" = "A second portrait placeholder from the existing archive."
    "IMG_43151.jpg" = "A wedding day placeholder for the future gallery."
    "IMG_43821.jpg" = "A celebration image from the current checked-in set."
    "IMG_56321.jpg" = "A weekend memory from the current checked-in set."
    "golden_rose.jpg" = "A detail image to support the album tone."
    "rose_border.jpg" = "A floral detail from the existing site assets."
  }

  foreach ($item in $items) {
    $defaultState = "unreviewed"
    $sourceName = Split-Path -Leaf $item.fullPath
    if ($UseExistingAsPlaceholders -and -not ($placeholderPublishNames -contains $sourceName)) {
      continue
    }
    if ($UseExistingAsPlaceholders -and $placeholderHeroNames -contains $sourceName -and $placeholderHeroCount -lt 4) {
      $defaultState = "hero"
      $placeholderHeroCount += 1
    }
    elseif ($UseExistingAsPlaceholders) {
      $defaultState = "include"
    }
    $entry = Get-CurationEntry -Curation $curation -RelativePath $item.relativePath -DefaultState $defaultState
    if ($UseExistingAsPlaceholders) {
      if ($placeholderHeroNames -contains $sourceName) {
        $entry["state"] = "hero"
      }
      elseif ($entry["state"] -eq "hero") {
        $entry["state"] = "include"
      }
    }
    if ($entry["state"] -eq "exclude") {
      continue
    }

    $baseId = Get-SafeSlug -Value $item.relativePath -Fallback "photo"
    $id = $baseId
    if ($seenIds.ContainsKey($id)) {
      $id = "$baseId-$(Get-ShaFragment $item.relativePath)"
      $warnings += "Photo ID collision resolved for $($item.relativePath)."
    }
    $seenIds[$id] = $true

    $albumInfo = Get-AlbumInfo -Curation $curation -AlbumId $item.albumId -FolderName $item.albumFolder
    if (-not $albums.ContainsKey($item.albumId)) {
      $albums[$item.albumId] = @{
        id = $item.albumId
        name = $albumInfo["displayName"]
        sourceFolder = $item.albumFolder
        coverId = ""
        count = 0
      }
    }

    $title = $entry["title"]
    if ([string]::IsNullOrWhiteSpace($title)) {
      if ($UseExistingAsPlaceholders -and $placeholderTitles.ContainsKey($sourceName)) {
        $title = $placeholderTitles[$sourceName]
      }
      else {
        $title = (Get-Culture).TextInfo.ToTitleCase(([System.IO.Path]::GetFileNameWithoutExtension($item.relativePath) -replace "[-_]+", " "))
      }
    }
    $caption = $entry["caption"]
    if ([string]::IsNullOrWhiteSpace($caption) -and $UseExistingAsPlaceholders -and $placeholderCaptions.ContainsKey($sourceName)) {
      $caption = $placeholderCaptions[$sourceName]
    }
    $isHero = $entry["state"] -eq "hero"
    $thumbFs = Join-Path $outputResolved (Join-Path $item.albumId (Join-Path "thumb" "$id.jpg"))
    $largeFs = Join-Path $outputResolved (Join-Path $item.albumId (Join-Path "large" "$id.jpg"))
    $heroFs = Join-Path $outputResolved (Join-Path $item.albumId (Join-Path "hero" "$id.jpg"))
    $thumbPublic = Convert-ToPublicPath (Join-Path $OutputDir (Join-Path $item.albumId (Join-Path "thumb" "$id.jpg")))
    $largePublic = Convert-ToPublicPath (Join-Path $OutputDir (Join-Path $item.albumId (Join-Path "large" "$id.jpg")))
    $heroPublic = $(if ($isHero) { Convert-ToPublicPath (Join-Path $OutputDir (Join-Path $item.albumId (Join-Path "hero" "$id.jpg"))) } else { $largePublic })
    Save-ResizedJpeg -SourcePath $item.fullPath -TargetPath $thumbFs -MaxWidth 480
    Save-ResizedJpeg -SourcePath $item.fullPath -TargetPath $largeFs -MaxWidth 1800
    if ($isHero) {
      Save-ResizedJpeg -SourcePath $item.fullPath -TargetPath $heroFs -MaxWidth 2400
    }
    $photo = @{
      id = $id
      albumId = $item.albumId
      sourcePath = $item.relativePath
      title = $title
      caption = $caption
      state = $entry["state"]
      isHero = $isHero
      focalPoint = $entry["focalPoint"]
      thumb = $thumbPublic
      large = $largePublic
      hero = $heroPublic
      alt = $title
    }
    $photos += $photo
    $albums[$item.albumId]["count"] += 1
    if ([string]::IsNullOrWhiteSpace($albums[$item.albumId]["coverId"]) -or $isHero) {
      $albums[$item.albumId]["coverId"] = $id
    }
  }

  $albumList = @($albums.Values | Sort-Object sourceFolder)
  $heroPhotos = @($photos | Where-Object { $_.isHero })
  $publicData = @{
    version = 1
    generatedAt = (Get-Date).ToString("o")
    sourceMode = $(if ($UseExistingAsPlaceholders) { "existing-images-placeholder" } else { "wedding-source" })
    albums = $albumList
    photos = @($photos | Sort-Object albumId, sourcePath)
    heroPhotos = @($heroPhotos | Sort-Object albumId, sourcePath)
  }

  Write-JsonFile -Data $publicData -Path $PublicDataPath
  $scriptPath = Resolve-ProjectPath $PublicDataScriptPath
  $scriptParent = Split-Path -Parent $scriptPath
  if ($scriptParent -and -not (Test-Path -LiteralPath $scriptParent)) {
    New-Item -ItemType Directory -Path $scriptParent | Out-Null
  }
  $json = $publicData | ConvertTo-Json -Depth 20
  "window.WEDDING_GALLERY_DATA = $json;" | Set-Content -LiteralPath $scriptPath -Encoding UTF8

  if ([string]::IsNullOrWhiteSpace($ReportPath)) {
    $ReportPath = Convert-ToPublicPath (Join-Path $OutputDir "generation-report.json")
  }
  $report = @{
    generatedAt = $publicData.generatedAt
    sourceCount = $items.Count
    publishedCount = $photos.Count
    excludedCount = $items.Count - $photos.Count
    albumCount = $albumList.Count
    heroCount = $heroPhotos.Count
    warnings = $warnings
    outputDir = Convert-ToPublicPath $OutputDir
    publicDataPath = Convert-ToPublicPath $PublicDataPath
    publicDataScriptPath = Convert-ToPublicPath $PublicDataScriptPath
  }
  Write-JsonFile -Data $report -Path $ReportPath
  Write-JsonFile -Data $curation -Path $CurationPath
  Write-Host "Generated $($photos.Count) public photos across $($albumList.Count) album(s)."
  Write-Host "Metadata: $PublicDataPath"
  Write-Host "Report: $ReportPath"
}

function Initialize-Pipeline {
  $source = Resolve-ProjectPath $SourceDir
  if (-not (Test-Path -LiteralPath $source)) {
    New-Item -ItemType Directory -Path $source | Out-Null
  }
  $curation = Read-JsonHashtable $CurationPath
  Write-JsonFile -Data $curation -Path $CurationPath
  Write-Host "Ready for source photos in $SourceDir"
  Write-Host "Private curation state: $CurationPath"
}

function Send-Response {
  param($Context, [string]$Body, [string]$ContentType = "text/plain", [int]$Status = 200)
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
  $Context.Response.StatusCode = $Status
  $Context.Response.ContentType = $ContentType
  $Context.Response.ContentEncoding = [System.Text.Encoding]::UTF8
  $Context.Response.ContentLength64 = $bytes.Length
  $Context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $Context.Response.Close()
}

function Send-Json {
  param($Context, $Data)
  Send-Response -Context $Context -Body ($Data | ConvertTo-Json -Depth 20) -ContentType "application/json"
}

function Get-ReviewHtml {
  return @'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Wedding Photo Review</title>
  <style>
    body { margin: 0; font: 16px/1.5 Arial, sans-serif; background: #f7f5f1; color: #222; }
    header { position: sticky; top: 0; z-index: 2; background: #fff; border-bottom: 1px solid #ddd; padding: 12px 18px; display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
    h1 { font-size: 20px; margin: 0 16px 0 0; }
    button, select, input { font: inherit; }
    button { border: 1px solid #aaa; background: #fff; padding: 7px 10px; cursor: pointer; }
    button.active { background: #222; color: #fff; border-color: #222; }
    main { padding: 18px; }
    .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(190px, 1fr)); gap: 14px; }
    .card { background: #fff; border: 1px solid #ddd; }
    .card.selected { outline: 3px solid #536d5d; }
    .card img { display: block; width: 100%; aspect-ratio: 4 / 3; object-fit: cover; background: #eee; }
    .meta { padding: 10px; }
    .meta h2 { font-size: 15px; margin: 0 0 8px; overflow-wrap: anywhere; }
    .actions { display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px; }
    .fields { display: grid; gap: 6px; margin-top: 8px; }
    .fields input { width: 100%; }
    .hint { color: #666; font-size: 13px; }
  </style>
</head>
<body>
  <header>
    <h1>Wedding Photo Review</h1>
    <select id="filter">
      <option value="all">All</option>
      <option value="unreviewed">Unreviewed</option>
      <option value="include">Include</option>
      <option value="highlight">Highlight</option>
      <option value="hero">Hero</option>
      <option value="exclude">Exclude</option>
    </select>
    <button data-folder-state="include">Folder include</button>
    <button data-folder-state="exclude">Folder exclude</button>
    <span id="status" class="hint"></span>
    <span class="hint">Shortcuts: u unreviewed, i include, l highlight, h hero, e exclude</span>
  </header>
  <main><div id="grid" class="grid"></div></main>
  <script>
    let photos = [];
    let selectedIndex = 0;
    const grid = document.getElementById('grid');
    const filter = document.getElementById('filter');
    const status = document.getElementById('status');
    const states = ['unreviewed', 'include', 'highlight', 'hero', 'exclude'];
    function visiblePhotos() {
      return photos.filter(p => filter.value === 'all' || p.state === filter.value);
    }
    function render() {
      const visible = visiblePhotos();
      status.textContent = `${visible.length} visible / ${photos.length} total`;
      grid.innerHTML = visible.map((p, index) => `
        <article class="card ${index === selectedIndex ? 'selected' : ''}" data-path="${p.relativePath}">
          <img src="/source?path=${encodeURIComponent(p.relativePath)}" alt="">
          <div class="meta">
            <h2>${p.relativePath}</h2>
            <div class="actions">${states.map(s => `<button class="${p.state === s ? 'active' : ''}" data-state="${s}">${s}</button>`).join('')}</div>
            <div class="fields">
              <input data-field="title" placeholder="Title" value="${p.title || ''}">
              <input data-field="caption" placeholder="Caption" value="${p.caption || ''}">
              <input data-field="focalX" type="number" min="0" max="100" value="${p.focalPoint?.x ?? 50}">
              <input data-field="focalY" type="number" min="0" max="100" value="${p.focalPoint?.y ?? 50}">
            </div>
          </div>
        </article>`).join('');
    }
    async function load() {
      const res = await fetch('/api/photos');
      photos = await res.json();
      render();
    }
    async function patchPhoto(path, patch) {
      await fetch('/api/curation', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ path, patch }) });
      const photo = photos.find(p => p.relativePath === path);
      Object.assign(photo, patch);
      if (patch.focalPoint) photo.focalPoint = patch.focalPoint;
      render();
    }
    grid.addEventListener('click', event => {
      const card = event.target.closest('.card');
      if (!card) return;
      selectedIndex = Array.from(grid.children).indexOf(card);
      const button = event.target.closest('button[data-state]');
      if (button) patchPhoto(card.dataset.path, { state: button.dataset.state });
      render();
    });
    grid.addEventListener('change', event => {
      const card = event.target.closest('.card');
      const field = event.target.dataset.field;
      if (!card || !field) return;
      if (field === 'focalX' || field === 'focalY') {
        const current = photos.find(p => p.relativePath === card.dataset.path).focalPoint || { x: 50, y: 50 };
        const next = { x: Number(field === 'focalX' ? event.target.value : current.x), y: Number(field === 'focalY' ? event.target.value : current.y) };
        patchPhoto(card.dataset.path, { focalPoint: next });
      } else {
        patchPhoto(card.dataset.path, { [field]: event.target.value });
      }
    });
    filter.addEventListener('change', () => { selectedIndex = 0; render(); });
    document.querySelectorAll('[data-folder-state]').forEach(button => button.addEventListener('click', async () => {
      const visible = visiblePhotos();
      if (!visible.length) return;
      const folder = visible[selectedIndex]?.albumFolder || visible[0].albumFolder;
      await fetch('/api/folder', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ folder, state: button.dataset.folderState }) });
      await load();
    }));
    document.addEventListener('keydown', event => {
      const map = { u: 'unreviewed', i: 'include', l: 'highlight', h: 'hero', e: 'exclude' };
      if (event.key === 'ArrowRight') { selectedIndex = Math.min(selectedIndex + 1, visiblePhotos().length - 1); render(); }
      if (event.key === 'ArrowLeft') { selectedIndex = Math.max(selectedIndex - 1, 0); render(); }
      if (map[event.key]) {
        const photo = visiblePhotos()[selectedIndex];
        if (photo) patchPhoto(photo.relativePath, { state: map[event.key] });
      }
    });
    load();
  </script>
</body>
</html>
'@
}

function Write-TcpBytes {
  param(
    [System.IO.Stream]$Stream,
    [byte[]]$Bytes,
    [string]$ContentType = "text/plain",
    [int]$StatusCode = 200,
    [string]$StatusText = "OK"
  )
  $headers = "HTTP/1.1 $StatusCode $StatusText`r`nContent-Type: $ContentType; charset=utf-8`r`nContent-Length: $($Bytes.Length)`r`nConnection: close`r`n`r`n"
  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headers)
  $Stream.Write($headerBytes, 0, $headerBytes.Length)
  $Stream.Write($Bytes, 0, $Bytes.Length)
}

function Write-TcpResponse {
  param(
    [System.IO.Stream]$Stream,
    [string]$Body,
    [string]$ContentType = "text/plain",
    [int]$StatusCode = 200,
    [string]$StatusText = "OK"
  )
  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
  Write-TcpBytes -Stream $Stream -Bytes $bytes -ContentType $ContentType -StatusCode $StatusCode -StatusText $StatusText
}

function Write-TcpJson {
  param([System.IO.Stream]$Stream, $Data)
  $json = ConvertTo-Json -InputObject $Data -Depth 20
  if ([string]::IsNullOrWhiteSpace($json)) {
    $json = "[]"
  }
  Write-TcpResponse -Stream $Stream -Body $json -ContentType "application/json"
}

function Get-QueryValue {
  param([string]$Query, [string]$Name)
  $trimmed = $Query.TrimStart("?")
  foreach ($part in ($trimmed -split "&")) {
    if ([string]::IsNullOrWhiteSpace($part)) { continue }
    $pair = $part -split "=", 2
    if ([System.Uri]::UnescapeDataString($pair[0]) -eq $Name) {
      if ($pair.Count -gt 1) {
        return [System.Uri]::UnescapeDataString($pair[1].Replace("+", " "))
      }
      return ""
    }
  }
  return ""
}

function Invoke-Serve {
  Initialize-Pipeline
  $listener = New-Object System.Net.Sockets.TcpListener ([System.Net.IPAddress]::Loopback), $Port
  $listener.Start()
  Write-Host "Photo review app: http://localhost:$Port/"
  Write-Host "Press Ctrl+C to stop."

  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
      $stream = $client.GetStream()
      $buffer = New-Object byte[] 1048576
      $read = $stream.Read($buffer, 0, $buffer.Length)
      if ($read -le 0) { continue }
      $requestText = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $read)
      $headerEnd = $requestText.IndexOf("`r`n`r`n")
      if ($headerEnd -lt 0) { $headerEnd = $requestText.IndexOf("`n`n") }
      $head = if ($headerEnd -ge 0) { $requestText.Substring(0, $headerEnd) } else { $requestText }
      $body = if ($headerEnd -ge 0) { $requestText.Substring($headerEnd + 4) } else { "" }
      $requestLine = ($head -split "`r?`n")[0]
      $parts = $requestLine -split " "
      $method = $parts[0]
      $targetText = $parts[1]
      $uri = New-Object System.Uri ("http://localhost:$Port$targetText")
      $path = $uri.AbsolutePath

      if ($path -eq "/") {
        Write-TcpResponse -Stream $stream -Body (Get-ReviewHtml) -ContentType "text/html"
      }
      elseif ($path -eq "/api/photos") {
        $curation = Read-JsonHashtable $CurationPath
        $items = Get-Inventory -SourceRoot $SourceDir
        $photos = @()
        foreach ($item in $items) {
          $entry = Get-CurationEntry -Curation $curation -RelativePath $item.relativePath
          $photos += @{
            relativePath = $item.relativePath
            albumFolder = $item.albumFolder
            albumId = $item.albumId
            state = $entry["state"]
            title = $entry["title"]
            caption = $entry["caption"]
            focalPoint = $entry["focalPoint"]
          }
        }
        Write-TcpJson -Stream $stream -Data $photos
      }
      elseif ($path -eq "/api/curation" -and $method -eq "POST") {
        $payload = ConvertTo-Hashtable ($body | ConvertFrom-Json)
        $curation = Read-JsonHashtable $CurationPath
        $entry = Get-CurationEntry -Curation $curation -RelativePath $payload["path"]
        foreach ($key in $payload["patch"].Keys) {
          $entry[$key] = $payload["patch"][$key]
        }
        Write-JsonFile -Data $curation -Path $CurationPath
        Write-TcpJson -Stream $stream -Data @{ ok = $true }
      }
      elseif ($path -eq "/api/folder" -and $method -eq "POST") {
        $payload = ConvertTo-Hashtable ($body | ConvertFrom-Json)
        $curation = Read-JsonHashtable $CurationPath
        $items = Get-Inventory -SourceRoot $SourceDir | Where-Object { $_.albumFolder -eq $payload["folder"] }
        foreach ($item in $items) {
          $entry = Get-CurationEntry -Curation $curation -RelativePath $item.relativePath
          $entry["state"] = $payload["state"]
        }
        Write-JsonFile -Data $curation -Path $CurationPath
        Write-TcpJson -Stream $stream -Data @{ ok = $true; updated = $items.Count }
      }
      elseif ($path -eq "/source") {
        $relative = Get-QueryValue -Query $uri.Query -Name "path"
        $sourceRoot = Resolve-ProjectPath $SourceDir
        $target = [System.IO.Path]::GetFullPath((Join-Path $sourceRoot $relative))
        if (-not $target.StartsWith($sourceRoot, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $target)) {
          Write-TcpResponse -Stream $stream -Body "Not found" -StatusCode 404 -StatusText "Not Found"
        }
        else {
          $bytes = [System.IO.File]::ReadAllBytes($target)
          Write-TcpBytes -Stream $stream -Bytes $bytes -ContentType "image/jpeg"
        }
      }
      else {
        Write-TcpResponse -Stream $stream -Body "Not found" -StatusCode 404 -StatusText "Not Found"
      }
    }
    catch {
      if ($stream) {
        Write-TcpResponse -Stream $stream -Body $_.Exception.Message -StatusCode 500 -StatusText "Internal Server Error"
      }
    }
    finally {
      $client.Close()
    }
  }
}

switch ($Command) {
  "init" { Initialize-Pipeline }
  "generate" { Invoke-Generate }
  "serve" { Invoke-Serve }
}
