# Prototype Lab

## Coherence Status - 2026-06-20

Working evidence, not current source of truth. The AWS static-hosting prototype below is historical. The later hosting comparison remains useful evidence for why GitHub Pages became the current path and AWS became fallback. Current durable docs supersede this working file.

## Prototype Record: Can the current site deploy cleanly as static AWS-hosted content?

### Decision
Proceed with a static-hosting-first plan, but patch the known static deploy blockers before public release:
- Fix the case-sensitive `images/kayak.jpg` reference.
- Remove or replace the PHP-dependent contact form submission path.
- Upgrade the HTTP jQuery CDN reference to HTTPS.

### Question Tested
Can the current repository be treated as a static website for cheap AWS hosting, and what specific issues would break or degrade static deployment?

### Possible Outcomes Considered
- If all local references resolved and no server runtime was detected, deploy as-is.
- If only small static reference issues were found, patch them before deploy.
- If server runtime was required for core behavior, either add backend hosting or change the feature scope.

### Method
Logic/static-analysis prototype.

Created throwaway scan scripts under:
- `documentation/planning/working/prototypes/static_site_scan.py`
- `documentation/planning/working/prototypes/static_site_scan.ps1`

Python and Node were not available in the shell, so the PowerShell version was used for execution.

### Result
The PowerShell scan reported:
- HTML pages: 5
- Local references resolved: 75
- Missing or case-mismatched references: 1
- Server-side runtime references: 1
- PHP files present: 1
- External references: 15

Findings:
- `syracuse.html` references `images/kayak.jpg`, but the repository contains `images/kayak.JPG`.
- `js/contact_me.js` references `./bin/contact_me.php`.
- `bin/contact_me.php` exists and requires PHP execution plus mail configuration.
- External references include HTTP jQuery and several third-party venue/hotel/activity links.

### Interpretation
The website is mostly static and is a good fit for AWS static hosting. The contact form is the main architecture mismatch because it relies on PHP. The image case mismatch is a likely static-hosting bug on case-sensitive environments. The HTTP jQuery reference is a likely HTTPS/mixed-content quality issue.

### What Gets Absorbed
- Deployment footprint should recommend static AWS hosting, preferably Amplify Hosting for low setup and HTTPS.
- Requirements should include case-correct local assets, no PHP runtime dependency for static deployment, and HTTPS-safe script references.
- FMEA should prioritize contact form failure on static hosting.
- Next implementation patch should fix the three deployment blockers above.

### What Gets Deleted
The prototype scripts are disposable. Keep temporarily while cleanup work is active; later either delete them or promote the PowerShell scan into a maintained verification script.

### Downstream Document Impacts
Updated or created:
- `documentation/requirements/current-state-design.md`
- `documentation/requirements/use-case-requirements.md`
- `documentation/requirements/requirements.md`
- `documentation/planning/deployment-footprint.md`
- `documentation/planning/prd.md`

### Open Questions
- Should the contact form become a direct `mailto:` flow for MVP, or should it remain visually present with serverless backend deferred?
- What exact public contact email should be used?
- Should stale third-party links be refreshed before the first public release?

## Prototype Record: Which hosting and asset strategy best fits the cheapest static wedding site goal?

### Decision
Use GitHub Pages with cleaned HTTPS CDNs for the first publish.

Defer Jekyll until the site needs reusable layouts, a gallery collection, or easier content authoring. Defer vendored local CSS/JS until archival independence matters more than setup simplicity. Reject FastHTML for now because the site no longer needs RSVP, email forms, server-side state, or an app runtime.

### Question Tested
For this mostly-static wedding website with no RSVP, email form, or backend, which hosting and asset strategy gives the lowest cost and least deployment risk?

### Possible Outcomes Considered
- If GitHub Pages clearly won, revise the sprint plan away from AWS-first hosting.
- If AWS Amplify was close or cheaper in practice, keep the AWS-first plan.
- If Jekyll materially improved the first release, plan a static-site-generator conversion.
- If FastHTML solved a concrete requirement, consider a backend app path.

### Method
Logic/scoring prototype using weighted criteria:
- Monthly cost
- Setup simplicity
- Fit with the current plain HTML/CSS/JS repository
- Custom domain or forwarding support
- Future static gallery support
- Operational risk

Prototype script:
- `documentation/planning/working/prototypes/hosting_options_compare.ps1`

The script inspected the repository size and compared six options:
- GitHub Pages + cleaned HTTPS CDNs
- GitHub Pages + vendored local CSS/JS
- GitHub Pages + Jekyll
- AWS Amplify Hosting
- S3 + CloudFront
- FastHTML hosted app

### Result
The PowerShell prototype reported a repository size of 6.41 MB and produced this ranking:

| Option | Weighted Score | Percent | Prototype Recommendation |
|---|---:|---:|---|
| GitHub Pages + cleaned HTTPS CDNs | 108 | 98.2% | Primary |
| GitHub Pages + vendored local CSS/JS | 100 | 90.9% | Later if archival independence matters |
| GitHub Pages + Jekyll | 90 | 81.8% | Defer |
| AWS Amplify Hosting | 79 | 71.8% | Fallback |
| S3 + CloudFront | 67 | 60.9% | Reject for now |
| FastHTML hosted app | 34 | 30.9% | Reject for now |

External reference checks:
- GitHub Pages supports static HTML/CSS/JS hosting directly from a repository and supports custom domains.
- GitHub Pages is available for public repositories on GitHub Free; private-repo Pages requires paid GitHub plans.
- GitHub Pages published sites have a 1 GB size limit and a soft 100 GB/month bandwidth limit, far above this repository's current size and likely traffic.
- AWS Amplify is viable but introduces an AWS billing surface and pay-as-you-go hosting after free-tier allowances.

### Interpretation
The cheapest credible plan is no longer AWS-first. GitHub Pages is the best first deployment target because the product is now static-only, the repository already lives on GitHub, and the expected traffic/asset size fits GitHub Pages limits comfortably.

CDNs are acceptable for the first release if the site uses HTTPS URLs. Vendoring Bootstrap/jQuery locally is a reasonable later archival-hardening step, but not needed to publish cheaply. Jekyll is useful later if a photo gallery or repeated layout maintenance becomes painful.

### What Gets Absorbed
- Revise the next sprint plan to target GitHub Pages publication rather than AWS Amplify.
- Keep CDN cleanup in scope: replace HTTP jQuery and remove obsolete PHP/contact scripts.
- Keep static scan verification in scope.
- Treat AWS Amplify as fallback only if GitHub Pages private-repo/publication constraints block the path.
- Treat Jekyll as a deferred enhancement for a future gallery/layout sprint.

### What Gets Deleted
The scoring script is disposable. Preserve temporarily while the final plan is being reviewed; later remove it or keep it as a planning artifact only.

### Downstream Document Impacts
Recommended updates:
- Create a new sprint plan for GitHub Pages publication.
- Update `documentation/planning/deployment-footprint.md` after the user confirms GitHub Pages as the final hosting target.
- Update `documentation/planning/prd.md` to replace AWS-first assumptions with GitHub Pages-first assumptions.
- Keep canonical requirements mostly stable, but revise hosting-specific wording in a future requirements cleanup if desired.

### Open Questions
- Is the repository allowed to become public if GitHub Free is the active plan?
- Should we configure a custom domain directly in GitHub Pages DNS, or keep GoDaddy forwarding to the `github.io` URL?
- Should the contact page become a simple no-form page, or should the contact page be removed entirely?
- Should the first release preserve historical wedding content exactly, or lightly refresh stale travel/contact details?
