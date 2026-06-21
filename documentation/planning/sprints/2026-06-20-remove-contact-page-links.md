# Sprint Plan: Remove Contact Page Links

## Source Inputs
- User request:
  - Plan a sprint to remove `contact.html` and any links coming back to it for now.
- Current code evidence:
  - `contact.html` exists as the current Info / Wedding Weekend Notes page.
  - `index.html`, `about.html`, `gallery.html`, `hotels.html`, and `syracuse.html` link to `contact.html` from the shared navigation.
  - `index.html` also links to `contact.html` from the home hero button labeled `Weekend Notes`.
- Current requirements:
  - `documentation/requirements/requirements.md`
  - `documentation/requirements/use-case-requirements.md`
  - `documentation/requirements/current-state-design.md`
- Current planning docs:
  - `documentation/planning/prd.md`
  - `documentation/planning/deployment-footprint.md`
  - `documentation/planning/sprints/2026-06-20-variant-c-publishable-site-hardening.md`
- Current prototype/design evidence:
  - Variant C remains the accepted visual direction, but the Info page is no longer desired in the public page set for this slice.

## Sprint Goal
Remove the public `contact.html` / Info page from the static website for now, including all visitor-facing links to it, while preserving a coherent Variant C archive experience across the remaining pages.

## Branch / PR Intent
- Suggested branch: `feature/remove-contact-page-links`
- Draft PR title: `Remove temporary Info page from public archive`
- Draft PR summary: Remove the current `contact.html` page and all navigation or hero links pointing to it, then update durable docs so the active site model reflects the smaller public page set.

## Scope Decision
This is a small cleanup sprint because the current Info page is not carrying enough user value for the archive and risks making the site feel administrative. The implementation should be limited to removing the page and references, then refreshing documentation claims that currently say the Info page is active.

This sprint intentionally does not replace `contact.html` with a new page, redirect, form, RSVP flow, privacy policy page, or generated route. If the archive later needs a warmer "Weekend" or "Details" page, that should be planned separately.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-003 Provide Internal Navigation | Planned | Navigation must remain complete after removing Info. | Source scan confirms no `contact.html` links remain in production pages. | Remove public Info links |
| REQ-004 Resolve Local Assets | Planned | Deleting a page must not create broken local references. | Static scan: 0 missing/case-mismatched refs. | Remove public Info links |
| REQ-010 Present Information Page | Planned to supersede/deactivate for now | This requirement conflicts with the newest user direction. | Requirements/design/PRD docs updated to say Info page is removed/deferred. | Update docs for smaller page set |
| REQ-011 State No Collection Policy | Planned to reframe | With no contact/RSVP entry point, the no-collection page copy is no longer needed as a standalone page. | Docs preserve `CONTACT_COLLECTION_ENABLED=false` and no form/backend checks. | Update docs for smaller page set |
| REQ-012 Avoid Static PHP Dependency | Planned | Removal must not reintroduce any backend/contact behavior. | Static scan and source scan for PHP/form/runtime refs. | Verify static-only release |
| REQ-013 Avoid Placeholder Contact Destinations | Planned | Removing the page should eliminate the last contact destination entirely. | Source scan confirms no public `contact.html`, contact form, or placeholder contact destination. | Remove public Info links |
| REQ-016 Verify Public Release | Planned | Smaller public site still needs release checks. | Static scan, production source scan, and manual navigation smoke. | Verify static-only release |
| REQ-018 Support Static Maintenance | Planned | The change should remain plain static HTML/CSS cleanup. | No build/backend/config introduced. | Remove public Info links |
| REQ-019 Update Docs On Behavior Change | Planned | Removing an active page changes durable product truth. | Requirements, current-state design, PRD/deployment notes updated narrowly. | Update docs for smaller page set |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Archive | Strengthen | Home should send visitors to Story, Gallery, and Syracuse/travel context only. |
| UC-002 Browse Historical Travel and Local Context | Preserve | Hotels and Syracuse remain active public pages. |
| UC-003 Read Information Page | Deactivate / Defer | This flow is intentionally removed from the public site for now. |
| UC-004 Publish Static Website | Preserve | Static hosting stays unchanged; page count shrinks. |
| UC-005 Maintain Archive Content | Strengthen | Docs should match the current smaller public page set. |
| UC-006 / UC-010 View Static Photo Gallery | Preserve | Gallery behavior should not change. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| Variant C works across existing pages when treated as a landing page plus interior journal pages. | Preserve | Remaining pages keep the Variant C shell. |
| Info page was included in the sitewide prototype as an existing route. | Supersede for now | User has now decided the route is not needed. |
| The site should not revive active contact, RSVP, upload, account, or backend behavior. | Absorb | Removal should make this simpler, not add replacement workflows. |
| Manual browser review remains useful because automation has been unreliable. | Absorb | Navigation and missing-page behavior need a quick human browser pass before publish. |

## Vertical Slice
A visitor opens the archive and sees navigation for Home, Story, Gallery, and Travel only. There is no Info nav item, no home button pointing to `contact.html`, and no public `contact.html` page in the repository. The site still passes static deploy checks and the durable docs no longer claim an active Info page.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Remove the public Info/contact route and all visitor links to it while keeping remaining navigation coherent. | REQ-003, REQ-004, REQ-013, REQ-018 | Source scan for `contact.html`; static scan. |
| 2 | Update durable docs to reflect the smaller public page set and deactivate the Info-page flow for now. | REQ-010, REQ-011, REQ-019 | Source scan docs for active Info/contact claims; manual doc review. |
| 3 | Verify the static release surface after route removal. | REQ-004, REQ-012, REQ-016 | Static scan; no PHP/form/backend scan; manual nav smoke. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Public HTML links | No production page links to removed `contact.html`. | Source smoke | `rg -n -g "*.html" "contact\\.html|>Info<|Wedding Weekend Notes|No Collection" .` with only historical/prototype/doc hits reviewed. |
| Static references | Removing `contact.html` does not create broken links/assets. | Automated smoke | `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1` |
| No backend/contact drift | No form, PHP, RSVP, upload, account, or placeholder contact destination appears. | Source smoke | `rg -n "<form|\\.php|action=|RSVP|rsvp|upload|account|contact\\.html" index.html about.html gallery.html hotels.html syracuse.html js css` |
| Navigation | Remaining nav links work and feel coherent. | Manual smoke | Open Home, Story, Gallery, Hotels, Syracuse; check desktop and mobile collapsed nav. |
| Gallery | Gallery behavior remains untouched. | Manual/source smoke | Open Gallery and check album render/lightbox if browser available. |
| Documentation | Durable docs no longer claim the Info page is an active route. | Inspection | Review requirements/current-state/PRD/deployment references after implementation. |

## Check Sequence
Focused checks during implementation:
1. Scan current production links to `contact.html` before editing.
2. Remove `contact.html`.
3. Remove the Info nav item from all remaining public pages.
4. Replace the home `Weekend Notes` CTA with a useful remaining destination, likely `about.html` or `syracuse.html`.
5. Run the static site scan.
6. Run production source scans for `contact.html`, Info page labels, forms, PHP, and RSVP/contact drift.
7. Update durable docs only where they make active claims about `contact.html`, Info, or UC-003.
8. Re-run static/source checks.

Final checks before handoff:
1. `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1`
2. `rg -n -g "*.html" "contact\\.html|>Info<|Wedding Weekend Notes|No Collection" .`
3. `rg -n "<form|\\.php|action=|RSVP|rsvp|upload|account|contact\\.html" index.html about.html gallery.html hotels.html syracuse.html js css`
4. Manual desktop/mobile navigation smoke before publish.
5. `git diff --check`

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/2026-06-20-remove-contact-page-links.md` | Fill implementation evidence after execution. | This sprint is the execution contract. |
| `documentation/planning/sprints/README.md` | Add this sprint to the index. | Chronological sprint tracking. |
| `documentation/requirements/requirements.md` | Update narrowly after implementation. | REQ-010/REQ-011 and related status/constants currently claim an active Info page. |
| `documentation/requirements/use-case-requirements.md` | Update narrowly after implementation. | UC-003 should become deferred/removed from active visitor flow. |
| `documentation/requirements/current-state-design.md` | Update narrowly after implementation. | Root page list, context/use case tables, and diagrams currently include `contact.html` / Info. |
| `documentation/planning/prd.md` | Update narrowly after implementation. | PRD currently lists Info as a public page and user story. |
| `documentation/planning/deployment-footprint.md` | Update narrowly after implementation. | Deployment page inventory and smoke-check count currently include Info. |
| Prototype files | Leave unchanged. | Prototype history can still show prior options; do not churn throwaway artifacts. |

## Out of Scope
- Adding a new Weekend, Details, Privacy, RSVP, contact, or redirect page.
- Adding a backend, form handler, PHP, serverless route, account system, upload flow, or analytics.
- Renaming `hotels.html`, `syracuse.html`, `about.html`, or `gallery.html`.
- Reworking gallery data, lightbox behavior, image generation, or photo curation.
- Full external-link audit.
- Publishing, merging, or changing GitHub Pages/GoDaddy settings.

## Risks and Dependencies
- Deleting `contact.html` means any old external bookmark to that page will 404. That is acceptable for this sprint only if the goal is truly removal rather than redirect.
- Current durable docs still describe an Info page. Implementation must update those docs or the documentation will become inconsistent again.
- The no-collection message will no longer have a dedicated page. The active privacy posture remains no collection, no backend, and no visitor submission paths.
- Browser automation may remain unavailable; manual nav review is still needed before broad publish.
- Static scan behavior may need to tolerate one fewer HTML page after deletion.

## Definition of Done
- `contact.html` is removed from the public site.
- No remaining production page links to `contact.html`.
- No visible Info nav item remains.
- Home no longer routes visitors to `contact.html`.
- Remaining navigation is coherent and keeps Variant C styling.
- Static scan passes with 0 missing local refs, 0 server runtime refs, and 0 PHP files.
- Source scans confirm no form/PHP/RSVP/contact destination drift.
- Durable docs are updated to show Info/contact removed or deferred for now.
- Sprint implementation evidence is completed after implementation.

## PR Checklist
- [x] `contact.html` removed.
- [x] Home hero/button links updated away from `contact.html`.
- [x] Shared nav links updated on all remaining production pages.
- [x] No production `contact.html` references remain.
- [x] No Info page labels remain in production navigation.
- [x] Static scan passes.
- [x] No form/PHP/backend/contact destination behavior introduced.
- [x] Requirements/use cases/current-state docs updated for removed Info route.
- [x] PRD/deployment footprint updated where active page inventory changed.
- [ ] Desktop navigation smoke completed. Not completed in-session; needs a browser pass before publish.
- [ ] Mobile navigation smoke completed. Not completed in-session; needs a browser pass before publish.
- [x] Sprint evidence filled in by `implement-change`.

## Implementation Evidence
| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-003 | Implemented | Removed the Info nav item from `index.html`, `about.html`, `gallery.html`, `hotels.html`, and `syracuse.html`; home secondary CTA now points to `about.html`. | Production source scan for `contact.html`, `>Info<`, `Wedding Weekend Notes`, and `No Collection`: 0 hits. | Pending | Remaining nav is Home, Story, Gallery, and Travel. |
| REQ-004 | Implemented | Deleted `contact.html` and preserved deploy-safe links/assets on remaining pages. | Static scan: 5 HTML pages, 52 local refs resolved, 0 missing/case-mismatched refs, 0 runtime refs, 0 PHP files. Gallery asset check: 10 photos, 1 album, 0 missing assets. | Pending | External refs unchanged. |
| REQ-010 | Deferred | Public Info/contact page removed for now; durable docs updated to mark the flow deferred rather than active. | Source scan confirms no production `contact.html` references. | Pending | Future Weekend/Details page requires a separate sprint. |
| REQ-011 | Implemented | No visitor submission or collection path is exposed in active public pages. | Source scan for forms/PHP/RSVP/contact destination: 0 hits. `upload/account` terms appear only in gallery no-backend copy. | Pending | No standalone no-collection page remains by design. |
| REQ-012 | Implemented | No PHP/server runtime dependency was introduced. | Static scan: 0 server-side runtime references, 0 PHP files. | Pending | Static-only deployment preserved. |
| REQ-013 | Implemented | Removed the last placeholder contact destination and public contact route. | Production source scan for `contact.html`: 0 hits. | Pending | Deleted route means external bookmarks to `contact.html` will 404 unless a future redirect/page is planned. |
| REQ-016 | Partial | Static release checks completed for the smaller page set. | Static scan passed; source scans passed; `git diff --check` reported line-ending warnings only. | Pending | Desktop/mobile browser navigation smoke still required before publish. |
| REQ-018 | Implemented | Change is plain static HTML/docs cleanup; no build/backend/config added. | Source inspection and static scan. | Pending | Variant C page shell preserved. |
| REQ-019 | Implemented | Updated `requirements.md`, `use-case-requirements.md`, `current-state-design.md`, `prd.md`, and `deployment-footprint.md` for the removed Info route. | Documentation scan now shows Info/contact only as removed/deferred or sprint/prototype history. | Pending | Prototype files intentionally unchanged. |

## Implementation Closure
Checks run during implementation:

- `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1`
  - Result: 5 HTML pages, 52 local references resolved, 0 missing or case-mismatched references, 0 server-side runtime references, 0 PHP files, 11 external references.
- Production removed-route scan:
  - `rg -n "contact\.html|>Info<|Wedding Weekend Notes|No Collection" index.html about.html gallery.html hotels.html syracuse.html`
  - Result: 0 hits.
- Production form/backend/contact scan:
  - `rg -n "<form|\.php|action=|RSVP|rsvp|contact\.html" index.html about.html gallery.html hotels.html syracuse.html js/archive-home.js js/gallery.js js/gallery-data.js css/style.css`
  - Result: 0 hits.
- Production upload/account term review:
  - Result: one intentional no-backend copy hit in `gallery.html`: "without visitor uploads, accounts, comments, or a backend album service."
- Gallery metadata/assets check:
  - Result: 10 photos, 1 album, 0 missing generated assets.
- `git diff --check`
  - Result: no whitespace errors; Git reported line-ending normalization warnings only.

## Cleanup / Deferred
- Manual desktop navigation smoke is still required before publish.
- Manual mobile navigation smoke is still required before publish.
- GitHub Pages and GoDaddy forwarding should be rechecked after commit/push/publish.
- External bookmarks to `contact.html` will now 404 by design unless a future sprint adds a replacement page or redirect.
- Prototype files still mention Info/contact as historical design evidence and were intentionally left unchanged.

## Implementation Handoff
Use this sprint file as the implementation contract for `implement-change`.

Start with Commit 1: remove `contact.html` and all production links to it. The first proof seam is a production source scan showing no `contact.html` references in remaining public pages, followed by the static site scan showing 0 missing local references.

Do not add a replacement page or redirect in this sprint. After implementation, close this sprint plan with actual evidence, checklist status, cleanup notes, and `Commit / PR` values.
