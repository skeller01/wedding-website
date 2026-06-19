# Throwaway hosting and asset strategy comparison for the wedding website.
# Scores options against the current goal: cheapest static public site, no backend.

$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..\..\..\..")
$RepoBytes = (Get-ChildItem -LiteralPath $Root -Recurse -File | Measure-Object -Property Length -Sum).Sum
$RepoMb = [math]::Round($RepoBytes / 1MB, 2)

$criteria = @(
    @{ Name = "MonthlyCost"; Weight = 5; Meaning = "Lower expected monthly cost is better" }
    @{ Name = "SetupSimplicity"; Weight = 4; Meaning = "Fewer services/accounts/build steps is better" }
    @{ Name = "RepoFit"; Weight = 4; Meaning = "Fits current plain HTML/CSS/JS repo" }
    @{ Name = "CustomDomain"; Weight = 3; Meaning = "Supports custom domain or simple forwarding" }
    @{ Name = "FutureGallery"; Weight = 2; Meaning = "Can support a future static photo gallery" }
    @{ Name = "OperationalRisk"; Weight = 4; Meaning = "Less billing/runtime/vendor complexity is better" }
)

$options = @(
    [pscustomobject]@{
        Option = "GitHub Pages + cleaned HTTPS CDNs"
        MonthlyCost = 5
        SetupSimplicity = 5
        RepoFit = 5
        CustomDomain = 5
        FutureGallery = 4
        OperationalRisk = 5
        Notes = "Free for public repos on GitHub Free; static HTML/CSS/JS from repo; custom domains supported; clean HTTP CDN links first."
        Recommendation = "Primary"
    },
    [pscustomobject]@{
        Option = "GitHub Pages + vendored local CSS/JS"
        MonthlyCost = 5
        SetupSimplicity = 4
        RepoFit = 4
        CustomDomain = 5
        FutureGallery = 4
        OperationalRisk = 5
        Notes = "Still free and more archival, but adds local third-party asset ownership and license/update hygiene."
        Recommendation = "Later if archival independence matters"
    },
    [pscustomobject]@{
        Option = "GitHub Pages + Jekyll"
        MonthlyCost = 5
        SetupSimplicity = 3
        RepoFit = 3
        CustomDomain = 5
        FutureGallery = 5
        OperationalRisk = 4
        Notes = "Useful for layouts and galleries, but unnecessary for first publish; adds build/template concepts."
        Recommendation = "Defer"
    },
    [pscustomobject]@{
        Option = "AWS Amplify Hosting"
        MonthlyCost = 3
        SetupSimplicity = 3
        RepoFit = 5
        CustomDomain = 4
        FutureGallery = 4
        OperationalRisk = 3
        Notes = "Good static hosting and HTTPS; has AWS billing/free-tier considerations; no longer cheapest if GitHub Pages is acceptable."
        Recommendation = "Fallback"
    },
    [pscustomobject]@{
        Option = "S3 + CloudFront"
        MonthlyCost = 3
        SetupSimplicity = 2
        RepoFit = 4
        CustomDomain = 4
        FutureGallery = 4
        OperationalRisk = 2
        Notes = "Powerful and cheap at low traffic, but more moving parts than needed for a tiny wedding site."
        Recommendation = "Reject for now"
    },
    [pscustomobject]@{
        Option = "FastHTML hosted app"
        MonthlyCost = 1
        SetupSimplicity = 1
        RepoFit = 1
        CustomDomain = 3
        FutureGallery = 4
        OperationalRisk = 1
        Notes = "Requires an app runtime for a site that no longer needs forms/backend; useful only if future interactive app features return."
        Recommendation = "Reject for now"
    }
)

function Get-WeightedScore {
    param([object]$Option)
    $score = 0
    foreach ($criterion in $criteria) {
        $score += $Option.($criterion.Name) * $criterion.Weight
    }
    return $score
}

$rankedUnsorted = foreach ($option in $options) {
    $score = Get-WeightedScore $option
    $weightSum = 0
    foreach ($criterion in $criteria) {
        $weightSum += $criterion.Weight
    }
    $maxScore = $weightSum * 5
    [pscustomobject]@{
        Option = $option.Option
        WeightedScore = $score
        Percent = [math]::Round(($score / $maxScore) * 100, 1)
        MonthlyCost = $option.MonthlyCost
        SetupSimplicity = $option.SetupSimplicity
        RepoFit = $option.RepoFit
        CustomDomain = $option.CustomDomain
        FutureGallery = $option.FutureGallery
        OperationalRisk = $option.OperationalRisk
        Recommendation = $option.Recommendation
        Notes = $option.Notes
    }
}

$ranked = $rankedUnsorted | Sort-Object -Property WeightedScore -Descending

Write-Output "Hosting options comparison"
Write-Output "=========================="
Write-Output "Repo size inspected: $RepoMb MB"
Write-Output "Goal: cheapest mostly-static public wedding site; no RSVP, email form, or backend."
Write-Output ""
Write-Output "Scoring: 1 = weak, 5 = strong. Higher weighted score wins."
Write-Output ""

$ranked | Format-Table Option, WeightedScore, Percent, Recommendation -AutoSize

Write-Output ""
Write-Output "Detailed notes:"
foreach ($row in $ranked) {
    Write-Output "- $($row.Option): $($row.Percent)% - $($row.Recommendation). $($row.Notes)"
}

Write-Output ""
Write-Output "Decision suggested by prototype:"
Write-Output "Use GitHub Pages with cleaned HTTPS CDNs for the first publish. Defer Jekyll until gallery/layout reuse is worth the build step. Reject FastHTML for now because the product no longer needs a backend."
