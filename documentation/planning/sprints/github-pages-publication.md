# Sprint Plan: GitHub Pages Publication

## Source Inputs
- Newest user decisions:
  - The site is mostly static public wedding information.
  - Future photo browsing/gallery may matter later.
  - RSVP, email forms, and backend behavior are no longer needed.
  - Cheapest possible hosting is the priority.
  - GitHub Pages is acceptable if it fits.
- Prototype verdict: `documentation/planning/working/prototype-lab.md`
- Prototype script: `documentation/planning/working/prototypes/hosting_options_compare.ps1`
- Static scan script: `documentation/planning/working/prototypes/static_site_scan.ps1`
- Existing docs: `documentation/planning/prd.md`, `documentation/planning/deployment-footprint.md`, `documentation/requirements/requirements.md`, `documentation/requirements/use-case-requirements.md`, `documentation/requirements/current-state-design.md`
- Existing sprint fallback: `documentation/planning/sprints/aws-static-hosting-readiness.md`
- Official references checked:
  - GitHub Pages static hosting, custom domain, private/public repository availability, and limits.
  - Google Hosted Libraries HTTPS recommendation.
  - Bootstrap 3 CDN guidance.
  - AWS Amplify pricing for fallback comparison.

## Sprint Goal
Publish the wedding website as a free or lowest-cost static site using GitHub Pages, while removing obsolete backend/form behavior and fixing known static-hosting risks.

## Branch / PR Intent
- Suggested branch: `development`
- Draft PR title: `Publish wedding website with GitHub Pages`
- Draft PR summary: Prepare the static wedding site for GitHub Pages by removing PHP/form dependencies, fixing case-sensitive assets and HTTPS CDN references, documenting the GitHub Pages deployment path, and verifying the published site.

## Scope Decision
The prototype selected GitHub Pages + cleaned HTTPS CDNs as the strongest option for the current goal. It scored highest because it is free for public repositories on GitHub Free, fits the current plain HTML/CSS/JS repository, supports custom domains, and avoids AWS billing/operations.

AWS Amplify is now a fallback, not the primary path. Jekyll is deferred until a gallery or layout reuse problem is real. FastHTML is rejected for now because the project no longer has backend requirements.

## Open Questions Resolved By Prototype
| Open Question | Prototype / Planning Answer | Remaining Decision |
|---|---|---|
| AWS or GitHub Pages? | GitHub Pages first; AWS fallback. | Confirm repo visibility/account support when enabling Pages. |
| CDN or local vendored assets? | Clean HTTPS CDNs for first publish. | Vendor later only if archival independence matters. |
| Jekyll now or later? | Later. Plain HTML is enough for first publish. | Revisit when photo gallery/layout reuse is needed. |
| FastHTML rewrite? | Reject for now. No backend need remains. | Revisit only if interactive app features return. |
| PHP contact form? | Remove/disable. No forms or email collection needed. | Decide whether contact page remains as informational page. |

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-001 Serve Home Entry | Planned | GitHub Pages must serve the site entry. | Published Pages URL opens home page. | Configure GitHub Pages publication |
| REQ-003 Provide Internal Navigation | Planned | Static navigation is the primary user flow. | Manual page smoke test. | Verify published navigation |
| REQ-004 Resolve Local Assets | Planned | Current scan finds `kayak.jpg`/`kayak.JPG` mismatch. | Static scan reports zero missing local references. | Fix static hosting blockers |
| REQ-005 Support Mobile Navigation | Planned | Bootstrap nav depends on working JS/CDN. | Manual mobile-width smoke check. | Verify published navigation |
| REQ-006 Use HTTPS Script Resources | Planned | GitHub Pages serves HTTPS; HTTP jQuery is risky. | Search finds no `http://ajax`; hosted page loads JS. | Fix static hosting blockers |
| REQ-011 Present Contact Channel | Changed | Old contact form is no longer required; contact page should not imply submission. | Contact page is static/informational or removed from nav. | Remove obsolete form behavior |
| REQ-012 Avoid Static PHP Dependency | Planned | GitHub Pages cannot execute PHP. | Static scan reports no required PHP runtime references. | Remove obsolete form behavior |
| REQ-013 Provide Contact Fallback | Changed | No form fallback needed if form is removed; clear contact/status copy may remain. | Contact page has no broken submission path. | Remove obsolete form behavior |
| REQ-014 Avoid Placeholder Contact Destinations | Planned | `me@example.com` must disappear. | Search finds no visitor-facing placeholder contact. | Remove obsolete form behavior |
| REQ-018 Provide HTTPS Hosted URL | Planned | GitHub Pages provides HTTPS hosted URL. | `github.io` or custom-domain URL opens site. | Configure GitHub Pages publication |
| REQ-019 Support GoDaddy Forwarding | Stretch | Cheapest first path can use `github.io`; custom domain/forwarding can follow. | GoDaddy forwarding or GitHub custom domain verified. | Configure domain path |
| REQ-020 Verify Before Public Release | Planned | Static checks and smoke tests prevent avoidable broken publish. | Scan and manual checklist completed. | Verify published site |
| REQ-021 Support Pre-Release Branch | Deferred | GitHub Pages normally publishes from a selected branch/folder or Actions; first publish can be simple. | N/A | N/A |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Information | Publish static pages publicly. | Core flow. |
| UC-002 Browse Travel and Local Information | Fix image case mismatch and verify pages. | External link freshness may be a polish pass. |
| UC-003 Provide Contact Information | Remove obsolete form submission. | User confirmed no RSVP/email/forms. |
| UC-005 Deploy Static Website | Retarget from AWS Amplify to GitHub Pages. | AWS fallback remains documented. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| GitHub Pages + cleaned HTTPS CDNs scored 98.2%. | Absorb | Primary deployment target. |
| GitHub Pages + vendored assets scored 90.9%. | Defer | Optional archival-hardening later. |
| Jekyll scored 81.8%. | Defer | Future gallery/layout sprint, not first publish. |
| AWS Amplify scored 71.8%. | Fallback | Keep only if GitHub Pages is blocked. |
| FastHTML scored 30.9%. | Reject for now | No app runtime in this sprint. |
| Static scan found image case mismatch. | Absorb | Fix before publish. |
| Static scan found PHP runtime dependency. | Absorb | Remove form/PHP dependency. |
| Static scan found HTTP jQuery. | Absorb | Use HTTPS CDN URL. |

## Vertical Slice
A visitor can open the GitHub Pages URL, view the wedding site, navigate all five pages, load images and Bootstrap behavior over HTTPS, and encounter no broken PHP/contact submission path. The owner has a clear next step for GoDaddy forwarding or direct GitHub Pages custom-domain setup.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Fix static hosting blockers. | REQ-004, REQ-006 | Static scan; `rg -n "http://ajax|kayak\\.jpg"` |
| 2 | Remove obsolete form/PHP behavior. | REQ-011, REQ-012, REQ-013, REQ-014 | Static scan; `rg -n "contact_me\\.php|me@example|<form|sentMessage"` |
| 3 | Update planning docs to GitHub Pages-first. | REQ-018, REQ-020 | Inspect PRD/deployment footprint for AWS-first drift. |
| 4 | Configure GitHub Pages publication. | REQ-001, REQ-018, REQ-020 | GitHub Pages URL opens home page. |
| 5 | Verify published site and record evidence. | REQ-003, REQ-005, REQ-020 | Five-page smoke test; mobile nav check; sprint evidence table. |
| 6 | Configure domain path. | REQ-019 | GoDaddy forwarding or GitHub custom domain opens site. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Static scan | Local refs resolve and no PHP runtime dependency remains. | Scripted | `powershell -ExecutionPolicy Bypass -File .\documentation\planning\working\prototypes\static_site_scan.ps1` |
| Hosting decision prototype | Hosting plan remains evidence-based. | Scripted | `powershell -ExecutionPolicy Bypass -File .\documentation\planning\working\prototypes\hosting_options_compare.ps1` |
| Source search | Known blockers are removed. | Inspection | `rg -n "http://ajax|contact_me\\.php|me@example|kayak\\.jpg"` |
| GitHub Pages hosted URL | Home page and internal pages load publicly. | Manual smoke | Open Pages URL and navigate all public pages. |
| Mobile navigation | Navbar/dropdown works at mobile width. | Manual smoke | Browser narrow viewport check. |
| Domain path | GoDaddy forwarding or custom domain reaches site. | Manual smoke | Open configured public URL. |

## Check Sequence
Focused checks during implementation:
1. Run current static scan and hosting comparison prototype.
2. Fix `images/kayak.jpg` case mismatch.
3. Change HTTP jQuery to HTTPS.
4. Remove contact form submission/PHP dependency and placeholder email.
5. Re-run static scan and source search.
6. Update PRD/deployment footprint to GitHub Pages-first.
7. Enable GitHub Pages from the chosen branch/folder.
8. Smoke-test the GitHub Pages URL.
9. Configure GoDaddy forwarding or GitHub Pages custom domain.
10. Smoke-test the final public URL.

Final checks before handoff:
1. Static scan reports zero missing/case-mismatched local references.
2. Static scan reports zero public runtime dependency on PHP.
3. Source search finds no `http://ajax`, `me@example`, or active `contact_me.php` reference.
4. GitHub Pages URL works.
5. Five public pages load and navigate.
6. Domain path is verified or explicitly deferred.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/prd.md` | Update AWS-first language to GitHub Pages-first. | Product direction changed to cheapest possible. |
| `documentation/planning/deployment-footprint.md` | Update target footprint to GitHub Pages-first and AWS fallback. | Deployment architecture changed. |
| `documentation/requirements/requirements.md` | Already updated to provider-neutral hosting wording; refresh only if implementation changes requirement truth. | Canonical requirement should remain target-agnostic. |
| `documentation/planning/working/prototype-lab.md` | Keep the hosting comparison record. | Decision evidence. |
| `documentation/planning/sprints/aws-static-hosting-readiness.md` | Mark as superseded or fallback if desired. | Avoid plan confusion. |
| `documentation/planning/sprints/github-pages-publication.md` | Update Implementation Evidence after execution. | Sprint closure. |

## Out of Scope
- FastHTML rewrite.
- AWS Amplify deployment unless GitHub Pages is blocked.
- S3/CloudFront.
- Jekyll conversion.
- Photo gallery implementation.
- Full visual redesign.
- RSVP, address collection, email form, or serverless backend.
- External link freshness sweep beyond obvious broken/deploy-blocking issues.

## Risks and Dependencies
- GitHub Pages from a private repository requires a paid GitHub plan; public repositories work on GitHub Free. If the repo must remain private and the account plan does not support private Pages, fallback to AWS Amplify or make the repo public.
- GitHub Pages has usage limits, but the current 6.41 MB repo and likely traffic are far below the documented published-site and soft bandwidth limits.
- Custom domain setup can be done through GitHub Pages DNS records or GoDaddy forwarding. Direct GitHub custom domain is cleaner; forwarding is simpler if the user wants to avoid DNS details.
- Removing the contact page entirely may require nav/content copy decisions. Simpler default: keep a static contact/info page or remove the form while preserving nav.
- Historical wedding/travel content may be stale; do not rewrite content heavily in this sprint.

## Definition of Done
- GitHub Pages is selected as the first deployment target in planning docs.
- Static blockers are fixed.
- Obsolete PHP/contact form behavior is removed or made inert.
- CDN/script loading is HTTPS-safe.
- GitHub Pages URL serves the site.
- All five public pages pass smoke testing.
- Domain path is either configured and verified or explicitly deferred with next steps.
- Sprint implementation evidence is filled in after execution.

## PR Checklist
- [x] Work is on `development`, not direct-to-`main`.
- [x] Hosting comparison prototype was run and recorded.
- [x] Static scan passes with no missing local references.
- [x] No active PHP contact dependency remains.
- [x] No visitor-facing placeholder email remains.
- [x] Required scripts use HTTPS.
- [ ] GitHub Pages URL loads.
- [ ] Five public pages have been smoke-tested on GitHub Pages.
- [ ] Mobile nav has been smoke-tested on GitHub Pages.
- [x] GoDaddy forwarding/custom domain decision is recorded.
- [x] PRD/deployment docs no longer imply AWS is the primary target.

## Implementation Run Notes
- Static code cleanup was completed on local branch `development`.
- GitHub repository `skeller01/wedding-website` is currently private.
- GitHub Pages is not currently configured; `gh api repos/skeller01/wedding-website/pages` returned `404 Not Found`.
- Publication remains blocked until the repo is made public, the account supports Pages from private repos, or AWS Amplify is chosen as fallback.
- No commit or push was created during this implementation run.

## Implementation Evidence
To be completed by `implement-change` after execution.

| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-001 | Blocked | Publication source not enabled yet because the repo is private and Pages is unconfigured. | `gh api repos/skeller01/wedding-website/pages` returned `404 Not Found`. | Pending | Requires repo visibility/account decision plus commit/push. |
| REQ-003 | Partial | Internal links remain in all five root HTML pages. | Static scan resolved 65 local references with zero missing references. | Pending | Hosted smoke test still pending. |
| REQ-004 | Implemented | `syracuse.html` now references `images/kayak.JPG`. | Static scan reports `Missing or case-mismatched references: 0`. | Pending |  |
| REQ-005 | Partial | Required Bootstrap/jQuery scripts remain present with HTTPS jQuery. | Code search found no `http://ajax`; hosted/mobile smoke test pending. | Pending |  |
| REQ-006 | Implemented | All root pages now load jQuery through `https://ajax.googleapis.com/...`. | Code search found no `http://ajax` outside documentation. | Pending |  |
| REQ-011 | Implemented | `contact.html` is now a static informational page with no collection form. | Code search found no `<form`, `sentMessage`, or `contactForm` outside documentation. | Pending | Contact form no longer needed. |
| REQ-012 | Implemented | Removed `js/contact_me.js` and `bin/contact_me.php`; root pages no longer reference them. | Static scan reports `Server-side runtime references: 0` and `PHP files present: 0`. | Pending |  |
| REQ-013 | Implemented | Contact page states the site is not collecting addresses, RSVPs, or messages. | Manual inspection of `contact.html`; blocker search passed. | Pending | Contact fallback semantics changed because form was removed. |
| REQ-014 | Implemented | Removed visitor-facing placeholder `me@example.com` with the deleted contact script. | Code search found no `me@example` outside documentation. | Pending |  |
| REQ-018 | Blocked | GitHub Pages URL cannot be verified until publication is enabled. | Repo is private; Pages API returned `404 Not Found`. | Pending | GitHub Pages URL pending. |
| REQ-019 | Deferred | User confirmed GoDaddy can forward to the final web link. | Decision recorded; final URL not available yet. | Pending | Domain path waits on GitHub Pages URL. |
| REQ-020 | Partial | Static scan and blocker source search pass locally. | Static scan and `rg` checks passed; hosted checks pending. | Pending |  |

## Implementation Handoff
Use this sprint file as the current final plan. Start with Commit 1: fix the static hosting blockers, because it is low-risk and immediately improves deployability. Do not rewrite the site in FastHTML, add Jekyll, build a backend, or configure AWS unless GitHub Pages is blocked. After implementation, update this sprint's Implementation Evidence table, checklist, and any actual GitHub Pages/domain URLs.
