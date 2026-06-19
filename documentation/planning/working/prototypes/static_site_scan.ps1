# Throwaway static-site deployment scan for the wedding website.
# Checks local page, script, stylesheet, image, and Ajax references.

$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")
$HtmlFiles = Get-ChildItem -LiteralPath $Root -Filter "*.html" -File
$SourceFiles = @()
$SourceFiles += $HtmlFiles
$SourceFiles += Get-ChildItem -LiteralPath (Join-Path $Root "css") -Filter "*.css" -File -ErrorAction SilentlyContinue
$SourceFiles += Get-ChildItem -LiteralPath (Join-Path $Root "js") -Filter "*.js" -File -ErrorAction SilentlyContinue

function Test-ExternalRef {
    param([string]$Ref)
    return $Ref -match "^(https?:|mailto:|tel:|//)"
}

function Get-CaseSensitiveExists {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return $false
    }

    $full = [System.IO.Path]::GetFullPath($Path)
    $rootPath = [string]$Root
    if (-not $full.StartsWith($rootPath)) {
        return $true
    }

    $relative = $full.Substring($rootPath.Length).TrimStart("\", "/")
    $current = $rootPath

    foreach ($part in $relative.Split([System.IO.Path]::DirectorySeparatorChar, [System.StringSplitOptions]::RemoveEmptyEntries)) {
        $names = Get-ChildItem -LiteralPath $current -Force | ForEach-Object { $_.Name }
        if ($names -cnotcontains $part) {
            return $false
        }
        $current = Join-Path $current $part
    }

    return $true
}

function Get-RelativePath {
    param([string]$Path)
    $rootPath = [string]$Root
    $fullPath = [System.IO.Path]::GetFullPath($Path)
    if ($fullPath.StartsWith($rootPath)) {
        return $fullPath.Substring($rootPath.Length).TrimStart("\", "/")
    }
    return $fullPath
}

$AttrRegex = [regex]'(?:href|src|action)\s*=\s*["'']([^"'']+)["'']'
$CssUrlRegex = [regex]'url\(["'']?([^)"'']+)["'']?\)'
$AjaxUrlRegex = [regex]'url\s*:\s*["'']([^"'']+)["'']'

$Resolved = New-Object System.Collections.Generic.List[object]
$Missing = New-Object System.Collections.Generic.List[object]
$ServerRuntime = New-Object System.Collections.Generic.List[object]
$External = New-Object System.Collections.Generic.HashSet[string]

foreach ($source in $SourceFiles) {
    $text = Get-Content -Raw -LiteralPath $source.FullName
    $refs = New-Object System.Collections.Generic.List[object]

    foreach ($match in $AttrRegex.Matches($text)) {
        [void]$refs.Add([pscustomobject]@{ Kind = "attribute"; Value = $match.Groups[1].Value; Base = $source.DirectoryName })
    }
    foreach ($match in $CssUrlRegex.Matches($text)) {
        [void]$refs.Add([pscustomobject]@{ Kind = "css-url"; Value = $match.Groups[1].Value; Base = $source.DirectoryName })
    }
    foreach ($match in $AjaxUrlRegex.Matches($text)) {
        [void]$refs.Add([pscustomobject]@{ Kind = "ajax-url"; Value = $match.Groups[1].Value; Base = $Root })
    }

    foreach ($refItem in $refs) {
        $ref = $refItem.Value
        $clean = (($ref -split "#", 2)[0] -split "\?", 2)[0].Trim()
        if ([string]::IsNullOrWhiteSpace($clean) -or $clean -eq "#") { continue }
        if (Test-ExternalRef $clean) {
            [void]$External.Add($clean)
            continue
        }

        $target = [System.IO.Path]::GetFullPath((Join-Path $refItem.Base $clean))
        $row = [pscustomobject]@{
            Source = Get-RelativePath $source.FullName
            Reference = $ref
            Target = Get-RelativePath $target
        }

        if ([System.IO.Path]::GetExtension($target).ToLowerInvariant() -eq ".php") {
            [void]$ServerRuntime.Add($row)
        }

        if (Get-CaseSensitiveExists $target) {
            [void]$Resolved.Add($row)
        } else {
            [void]$Missing.Add($row)
        }
    }
}

$PhpFiles = Get-ChildItem -LiteralPath $Root -Recurse -Filter "*.php" -File

Write-Output "Static site scan"
Write-Output "================"
Write-Output "HTML pages: $($HtmlFiles.Count)"
Write-Output "Local references resolved: $($Resolved.Count)"
Write-Output "Missing or case-mismatched references: $($Missing.Count)"
Write-Output "Server-side runtime references: $($ServerRuntime.Count)"
Write-Output "PHP files present: $($PhpFiles.Count)"
Write-Output "External references: $($External.Count)"

if ($Missing.Count -gt 0) {
    Write-Output ""
    Write-Output "Missing or case-mismatched references:"
    foreach ($row in $Missing) {
        Write-Output "- $($row.Source): $($row.Reference) -> $($row.Target)"
    }
}

if ($ServerRuntime.Count -gt 0) {
    Write-Output ""
    Write-Output "Server-side runtime references:"
    foreach ($row in $ServerRuntime) {
        Write-Output "- $($row.Source): $($row.Reference)"
    }
}

if ($PhpFiles.Count -gt 0) {
    Write-Output ""
    Write-Output "PHP files:"
    foreach ($file in $PhpFiles) {
        Write-Output "- $(Get-RelativePath $file.FullName)"
    }
}

if ($External.Count -gt 0) {
    Write-Output ""
    Write-Output "External references:"
    foreach ($ref in ($External | Sort-Object)) {
        Write-Output "- $ref"
    }
}
