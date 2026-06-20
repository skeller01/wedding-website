# Sprint Plan: AWS Static Hosting Readiness

## Coherence Status - 2026-06-20

Fallback/historical sprint record. Do not use this file as the current execution plan. GitHub Pages is the current hosting direction; AWS static hosting is fallback only if GitHub Pages becomes unsuitable or the user explicitly chooses AWS.

## Status Update
Superseded as the primary plan by the current durable docs and the GitHub Pages publication sprint history.

This plan remains useful as a fallback if GitHub Pages is blocked by repository visibility, account plan, custom-domain constraints, or a later decision to use AWS. The current recommendation is GitHub Pages first because the project goal shifted to cheapest possible static hosting with no RSVP, email form, or backend.

## Source Inputs
- User goal: host the website cheaply on AWS and forward a GoDaddy URL to it.
- `documentation/planning/prd.md`
- `documentation/planning/deployment-footprint.md`
- `documentation/requirements/requirements.md`
- `documentation/requirements/use-case-requirements.md`
- `documentation/requirements/current-state-design.md`
- `documentation/planning/working/prototype-lab.md`
- Prototype scan scripts under `documentation/planning/working/prototypes/`
- Repository files: root HTML pages, `js/contact_me.js`, `bin/contact_me.php`, `images/kayak.JPG`

## Sprint Goal
Make the existing wedding website ready for low-cost static AWS hosting by removing the known static-deploy blockers, preserving a usable contact path, and preparing the site for Amplify preview deployment.

## Branch / PR Intent
- Suggested branch: `development`
- Draft PR title: `Prepare wedding website for static AWS hosting`
- Draft PR summary: Fix static asset and HTTPS script issues, make the contact path static-hosting compatible, and verify the site is ready for AWS Amplify plus GoDaddy forwarding.

## Scope Decision
This slice was chosen because it is the smallest vertical path from current repository state to hosted public preview. It avoids backend work, redesign, DNS migration, and large refactors while directly addressing the high-risk FMEA items.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-004 Resolve Local Assets | Planned | Static hosts can break on case mismatch. | Static scan reports no missing references. | Fix static asset and HTTPS references |
| REQ-006 Use HTTPS Script Resources | Planned | HTTPS hosting should not load required scripts over HTTP. | Search and browser smoke check show HTTPS jQuery. | Fix static asset and HTTPS references |
| REQ-011 Present Contact Channel | Planned | Visitors need a usable contact path. | Contact page shows usable contact destination. | Make contact path static compatible |
| REQ-012 Avoid Static PHP Dependency | Planned | Amplify/static hosting will not execute PHP. | Static scan reports no required PHP runtime reference. | Make contact path static compatible |
| REQ-013 Provide Contact Fallback | Planned | Contact behavior must be clear if no backend exists. | Contact submit or visible contact path works without PHP. | Make contact path static compatible |
| REQ-014 Avoid Placeholder Contact Destinations | Planned | `me@example.com` must not be visitor-facing. | Search finds no placeholder email in visitor-facing JS/HTML. | Make contact path static compatible |
| REQ-017 Deploy From GitHub | Stretch | Actual AWS connection may be done manually. | Amplify app connected to repo, if user wants implementation to continue. | Deploy preview to AWS Amplify |
| REQ-018 Provide HTTPS Hosted URL | Stretch | Requires AWS console/action. | Amplify URL loads site. | Deploy preview to AWS Amplify |
| REQ-020 Verify Before Public Release | Planned | Needed for confidence before GoDaddy forwarding. | Static scan and manual checklist completed. | Verify static hosting readiness |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Information | Fixes asset and HTTPS script loading risks. | No content redesign required. |
| UC-002 Browse Travel and Local Information | Fixes Syracuse image case mismatch. | External link freshness is deferred. |
| UC-003 Provide Contact Information | Converts or clarifies contact path for static hosting. | Exact contact email should be confirmed if not using observed `rani@steveandsonia.com`. |
| UC-005 Deploy Static Website | Prepares repo for Amplify preview and GoDaddy forwarding. | AWS setup can be same sprint if credentials/session are available. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| `syracuse.html` references `images/kayak.jpg`, but file is `images/kayak.JPG`. | Absorb | Fix path or rename file. |
| `js/contact_me.js` posts to `./bin/contact_me.php`. | Absorb | Remove PHP dependency from public contact flow. |
| `bin/contact_me.php` requires PHP and mail configuration. | Defer backend | Do not build PHP hosting for MVP. |
| HTTP jQuery reference appears on all pages. | Absorb | Change to HTTPS. |
| Python/Node unavailable for prototype execution. | Documentation-only | Keep PowerShell scan for now. |

## Vertical Slice
A visitor can open the site from a static host, navigate all pages, see all local images, use Bootstrap interactions under HTTPS, and find or use a contact path that does not depend on server-side PHP.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Fix deploy-blocking static references. | REQ-004, REQ-006 | Static scan; search for `http://ajax`; inspect `syracuse.html`. |
| 2 | Make contact path static compatible. | REQ-011, REQ-012, REQ-013, REQ-014 | Static scan; search for `contact_me.php` and `me@example`; browser/contact smoke check. |
| 3 | Verify hosting readiness and update evidence. | REQ-020 | Run scan; update sprint implementation evidence; optional Amplify preview verification. |
| 4 | Deploy preview to AWS Amplify. | REQ-017, REQ-018 | Amplify URL opens site; manual page smoke test. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Static scan | Local references resolve and no PHP runtime dependency remains. | Automated/scripted | `powershell -ExecutionPolicy Bypass -File .\documentation\planning\working\prototypes\static_site_scan.ps1` |
| Source search | No known placeholders or HTTP scripts remain. | Inspection | `rg -n "http://ajax|me@example|contact_me.php|kayak\\.jpg"` |
| Browser smoke | Pages load and nav works. | Manual/demo | Open each root HTML page locally or on Amplify URL. |
| Contact behavior | Contact path works without PHP. | Manual/demo | Submit/click contact path and confirm visitor-visible behavior. |
| Hosted preview | AWS URL serves the site. | Manual/demo | Open Amplify URL after deploy. |

## Check Sequence
Focused checks during implementation:
1. Run static scan before edits to confirm baseline.
2. Fix image and HTTPS script references.
3. Run static scan and source search.
4. Patch contact behavior.
5. Run static scan and source search again.

Final checks before handoff:
1. Static scan reports zero missing local references.
2. Static scan reports zero required PHP runtime references for the public flow.
3. Search finds no `http://ajax` or `me@example`.
4. Manual page/contact smoke check completed.
5. If AWS setup is included, Amplify URL loads all pages.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/aws-static-hosting-readiness.md` | Update Implementation Evidence after execution. | Sprint closure. |
| `documentation/planning/working/prototype-lab.md` | Append or update if scan method changes. | Prototype evidence drift. |
| `documentation/requirements/current-state-design.md` | Refresh FMEA/current-state notes after fixes if durable truth changes. | Known risks may become resolved. |
| `documentation/requirements/requirements.md` | Keep final IDs; update evidence/status only if requested. | Requirements remain valid. |
| `documentation/planning/deployment-footprint.md` | Update after actual Amplify URL exists. | Deployment state changes from proposed to observed. |

## Out of Scope
- Full visual redesign.
- Static site generator/template refactor.
- Serverless contact backend.
- Route 53 DNS migration.
- Analytics, monitoring, or custom error pages.
- Broad external link freshness cleanup unless a link blocks the hosted experience.

## Risks and Dependencies
- Contact email must be confirmed if the observed address is not the intended public address.
- AWS Amplify setup requires authenticated AWS access outside repository-only changes.
- GoDaddy forwarding requires account access and should happen only after hosted URL verification.
- Removing PHP dependency changes contact behavior, so copy should be clear.

## Definition of Done
- All selected planned requirements have implementation evidence.
- Static scan passes with no missing/case-mismatched local references.
- Public contact path no longer requires PHP execution.
- Visitor-facing placeholder contact destinations are removed.
- Required scripts use HTTPS.
- Manual smoke check covers all five public pages.
- Optional stretch: Amplify preview URL is live and verified.

## PR Checklist
- [ ] Changes are on `development`, not directly on `main`.
- [ ] Static scan passes.
- [ ] Search checks pass for known blockers.
- [ ] Contact page behavior is clear without PHP.
- [ ] Five public pages have been smoke-tested.
- [ ] Documentation evidence is updated.
- [ ] AWS preview URL is recorded if deployed.
- [ ] GoDaddy forwarding is deferred until preview is approved.

## Implementation Evidence
To be completed by `implement-change` after execution.

| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-004 | Planned |  |  |  |  |
| REQ-006 | Planned |  |  |  |  |
| REQ-011 | Planned |  |  |  |  |
| REQ-012 | Planned |  |  |  |  |
| REQ-013 | Planned |  |  |  |  |
| REQ-014 | Planned |  |  |  |  |
| REQ-020 | Planned |  |  |  |  |
| REQ-017 | Stretch |  |  |  |  |
| REQ-018 | Stretch |  |  |  |  |

## Implementation Handoff
Use this sprint file for the first implementation pass. Start with commit 1, because the image path and HTTPS script changes are unambiguous and prove the static scan seam. Do not introduce a build system, backend, DNS migration, or redesign in this sprint. After implementation, update the Implementation Evidence table, checklist status, cleanup notes for prototype scripts, and any deployment URL evidence if Amplify setup is completed.
