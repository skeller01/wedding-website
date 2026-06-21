# Sprint Plan: Variant C Publishable Site Hardening

## Source Inputs
- User request:
  - Create a sprint plan from `documentation/planning/working/refactor-plan.md`.
  - Make the website publishable and bug-resistant.
  - Defer all new pages to the Variant C design concept.
  - Main goal is a deployable site without bugs.
- Refactor plan:
  - `documentation/planning/working/refactor-plan.md`
  - Top recommendation: Variant C page shell and visual contract.
- Prototype source:
  - `documentation/planning/working/prototypes/archive_visual_refresh_variants.html`
  - Accepted design direction: Variant C photo-first journal layout.
  - `documentation/planning/working/prototype-lab/2026-06-20-variant-c-sitewide-pages.md`
  - `documentation/planning/working/prototypes/variant_c_sitewide_pages.html`
  - Sitewide prototype decision: use Variant C as a visual contract with two patterns, a landing journal for Home and interior journal pages for Story, Gallery, Info, Hotels, and Syracuse.
- Durable docs:
  - `documentation/planning/prd.md`
  - `documentation/requirements/requirements.md`
  - `documentation/requirements/current-state-design.md`
  - `documentation/planning/deployment-footprint.md`
- Prior sprint evidence:
  - `documentation/planning/sprints/2026-06-20-archive-visual-refresh.md`
  - `documentation/planning/sprints/2026-06-20-generated-gallery-lightbox.md`
  - `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`
- Current code surfaces:
  - Root pages: `index.html`, `about.html`, `gallery.html`, `contact.html`, `hotels.html`, `syracuse.html`
  - Styling: `css/style.css`
  - Public JS: `js/archive-home.js`, `js/gallery.js`, `js/gallery-data.js`
  - Gallery metadata/assets: `data/gallery-data.json`, `images/gallery/generated/`
  - Existing scan: `documentation/planning/working/prototypes/static_site_scan.ps1`

## Sprint Goal
Make the existing static wedding archive publishable with the accepted Variant C journal look across all current public pages, while keeping the site static, route-stable, and safe to deploy through GitHub Pages/GoDaddy forwarding.

This sprint is not a new-page sprint. Any new future page concept is deferred and must use the Variant C page-shell design contract when it is eventually planned.

## Branch / PR Intent
- Suggested branch: `feature/variant-c-publishable-site-hardening`
- Draft PR title: `Harden Variant C wedding archive for publication`
- Draft PR summary: Apply the accepted Variant C visual contract across existing public pages, remove prototype/old-event-site drift that makes the site look broken, preserve static gallery behavior, and add publish-blocking checks for static references, no-backend scope, gallery data, navigation, and manual visual review.

## Scope Decision
This slice is chosen because the current site has working static infrastructure and generated gallery behavior, but the visible product is not yet coherent enough to publish confidently. The refactor plan found that the home page, gallery, and supporting pages are split between the new Variant C journal design and older Bootstrap/event-logistics styling.

The sprint is PR-sized if it limits work to existing public pages and release checks:
- use Variant C as the design constraint,
- remove or reframe visible drift that makes pages look broken,
- preserve existing routes and static hosting,
- do not introduce a generator, backend, new pages, or real-photo curation.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-001 Serve Home Entry | Planned | Home must be publishable and visually stable. | `index.html` loads as the archive entry. | Stabilize Variant C home |
| REQ-002 Present Wedding Archive Summary | Planned | Copy must feel like a shareable archive, not a prototype readout. | Source scan confirms no prototype wording; manual read-through. | Stabilize Variant C home |
| REQ-003 Provide Internal Navigation | Planned | Existing routes and chapter/nav links must keep working. | Static scan and nav smoke checklist. | Apply sitewide journal shell |
| REQ-004 Keep Local Asset References Valid | Planned | Publication must not ship broken images/CSS/JS. | Static scan: 0 missing/case-mismatched refs. | Add release check gate |
| REQ-005 Support Mobile Navigation | Planned | Variant C must not break phone navigation/layout. | Manual mobile-width review or browser screenshot if tool works. | Apply responsive journal shell |
| REQ-006 Preserve Readable Core Content | Planned | Text and images must not look stretched, cropped badly, or unreadable. | Manual visual review of all pages; focal/crop check for home/gallery. | Stabilize Variant C home |
| REQ-012 Avoid Static PHP Dependency | Planned | Deployment must stay static/no backend. | Static scan and source search for PHP/form/server refs. | Add release check gate |
| REQ-013 Avoid Placeholder Contact Destinations | Planned | Publishable site must not invite dead contact/RSVP/address collection. | Source search and manual read-through. | Clean publish-blocking copy |
| REQ-014 Publish Through GitHub Source | Planned | Site must remain deployable through existing GitHub Pages flow. | No build/runtime dependency added; PR checklist. | Add release check gate |
| REQ-016 Verify Public Release | Planned | Main sprint goal is deploy without bugs. | Check sequence completed; implementation evidence filled. | Add release check gate |
| REQ-017 Support Public Domain Forwarding | Planned | GoDaddy forwarding is working and must be rechecked after publish. | Manual post-publish check note. | Close sprint evidence |
| REQ-018 Support Static Maintenance | Planned | Future edits should use the Variant C design contract. | Sprint/docs note and no build system added. | Apply sitewide journal shell |
| REQ-021 Support Static Photo Gallery | Planned | Gallery must remain usable and visually aligned. | Gallery page smoke and static asset check. | Align gallery with Variant C |
| REQ-031 Support Generated Album Lightbox | Planned | Visual changes must not break gallery/lightbox behavior. | Manual lightbox smoke; source check. | Align gallery with Variant C |
| REQ-032 Support Session-Stable Archive Hero | Planned / Clarify | Current random hero behavior may fight exact Variant C publishability. | Decision recorded; fallback/session behavior checked. | Stabilize Variant C home |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Archive | Strengthen | Home page becomes a stable Variant C archive entry. |
| UC-002 Browse Historical Travel and Local Context | Strengthen | Travel pages should look like part of the same archive and avoid publish-blocking visual drift. |
| UC-003 Read Information Page | Strengthen | Info page remains no-collection/static and adopts the same journal shell. |
| UC-004 Publish Static Website | Strengthen | Adds explicit release gates and post-publish checks. |
| UC-005 Maintain Archive Content | Strengthen | Establishes Variant C as the design contract for future existing-page edits and deferred new pages. |
| UC-006 View Static Photo Gallery | Strengthen | Gallery gets aligned enough to publish without changing static/no-backend scope. |
| UC-010 Browse Generated Album Gallery | Preserve / Strengthen | Generated album/lightbox behavior must survive visual changes. |
| UC-011 View Session-Stable Archive Hero | Clarify | Hero behavior should be made publish-safe before deployment. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| Variant C is the accepted direction. | Absorb | Use Variant C as the page-shell design constraint across current public pages. |
| Variant C uses one large photo, restrained editorial copy, and three chapter links. | Absorb with adaptation | Home should follow this closely; interior pages should use compatible journal sections without pretending every page is a landing page. |
| Sitewide Variant C prototype shows two compatible page patterns. | Absorb | Implement Home as the full landing journal and existing subpages as interior journal pages, using `variant_c_sitewide_pages.html` as visual working evidence rather than production code. |
| Sitewide prototype maps Variant C to all current public routes. | Absorb | Cover `index.html`, `about.html`, `gallery.html`, `contact.html`, `hotels.html`, and `syracuse.html`; do not add new pages. |
| The site should feel like a wedding archive/photo album. | Absorb | Replace prototype-sounding and old logistics-first presentation with archive-ready copy/structure. |
| Gallery looks poor and should feel connected to the archive. | Absorb narrowly | Align gallery intro/cards/lightbox affordances enough for publication; defer deep gallery redesign if it expands. |
| The current site should remain static/no-backend. | Absorb | No new backend, form handling, upload flow, account system, or build pipeline. |
| Browser automation is unavailable in the current environment. | Absorb as release risk | Manual desktop/mobile review is a publish blocker unless browser tooling becomes available. |

## Vertical Slice
A visitor opens the site through GitHub Pages or the GoDaddy-forwarded domain and sees a coherent Variant C-style wedding archive. Existing pages load without broken assets, prototype wording, dead collection flows, or obvious visual mismatch. The gallery remains static and usable. The maintainer has a concrete release checklist that blocks publishing if static references, no-backend scope, nav, gallery, or manual visual review fail.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Stabilize the Variant C home page for publication: archive-ready copy, non-stretched perceived hero presentation, clear chapter links, and a recorded hero behavior decision. | REQ-001, REQ-002, REQ-006, REQ-032 | Source scan for prototype text; home visual/manual review; fallback/session check. |
| 2 | Apply the Variant C journal shell to existing public pages without adding new pages or a build step. | REQ-003, REQ-005, REQ-018 | Static scan; source scan for required page-shell markers; manual desktop/mobile review. |
| 3 | Align gallery presentation with the journal shell while preserving generated static album/lightbox behavior. | REQ-021, REQ-031 | Gallery data/assets check; manual lightbox smoke; no-backend source scan. |
| 4 | Reframe or remove publish-blocking legacy/event-logistics drift and dead collection language. | REQ-002, REQ-013, REQ-018 | Source search for prototype/contact/form/address/RSVP wording; manual read-through. |
| 5 | Add or formalize release checks and close documentation evidence for a publishable static site. | REQ-004, REQ-012, REQ-014, REQ-016, REQ-017 | Static scan; no PHP/runtime refs; final PR checklist; post-publish GitHub Pages/GoDaddy checklist. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Static references | All root HTML local refs resolve and no PHP/server runtime refs exist. | Automated smoke | `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1` |
| Public routes | Existing pages remain at current filenames and links. | Inspection / smoke | Source scan for `index.html`, `about.html`, `gallery.html`, `contact.html`, `hotels.html`, `syracuse.html`; click/manual nav checklist. |
| Variant C home | Home looks like the accepted photo-first journal, not the earlier hybrid/prototype copy. | Manual visual / screenshot if available | Desktop and mobile review of `index.html`; verify no "This option makes..." wording. |
| Interior journal shell | Existing pages use Variant C-compatible visual sections. | Manual visual / inspection | Review `about.html`, `contact.html`, `hotels.html`, `syracuse.html` for coherent page shell and no broken layout. |
| Prototype absorption | Production pages follow the accepted two-pattern direction without copying throwaway code blindly. | Inspection / manual comparison | Compare implementation against `documentation/planning/working/prototypes/variant_c_sitewide_pages.html` and record any deliberate deviations. |
| Gallery | Generated album grid renders and lightbox open/next/previous/close still works. | Manual smoke / source inspection | Open `gallery.html`; test first photo, next, previous, close, keyboard if possible. |
| No backend/no collection | No form, upload, account, RSVP, address collection, PHP, or runtime backend is introduced. | Source scan | `rg -n "<form|upload|account|RSVP|rsvp|address collection|action=|\\.php|fetch\\(|XMLHttpRequest" *.html js css` with expected known static-gallery exceptions reviewed. |
| Gallery metadata contract | Gallery JS and JSON exist, parse, and reference generated public assets. | Script/source check | PowerShell JSON parse of `data/gallery-data.json`; source check `window.WEDDING_GALLERY_DATA`; sample asset existence check. |
| Mobile nav/layout | Navbar/dropdown and journal sections are usable at phone width. | Manual visual | Browser/device review required before publish; if automation works, capture screenshots. |
| External resources | CDN/external links are not blockers for static deployment. | Inspection | Static scan reports external refs; stale link audit is deferred unless a link visibly breaks core navigation. |
| Post-publish access | GitHub Pages and GoDaddy forwarding reach the updated site. | Manual smoke | After merge/publish, open hosted URL and forwarded domain; record result in implementation evidence. |

## Check Sequence
Focused checks during implementation:
1. Run static scan before changing public pages and record baseline.
2. Review `variant_c_sitewide_pages.html` and the prototype record before patching production pages.
3. Patch home first; source-scan for prototype copy and missing local refs.
4. Patch one interior page pattern, then apply consistently to the remaining existing pages.
5. Patch gallery visual alignment only after the page-shell pattern is stable.
6. Run static scan after each broad HTML/CSS pass.
7. Run source scans for no-backend/no-collection drift.
8. Parse `data/gallery-data.json` and confirm representative `thumb`, `large`, and `hero` paths exist.
9. Manually review desktop and mobile pages before declaring publish-ready.

Final checks before handoff:
1. `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1`
2. `rg -n "This option makes|Archive direction C|prototype|address collection|RSVP|rsvp|<form|\\.php|upload|account" *.html js css documentation/planning/working/refactor-plan.md`
3. Gallery metadata parse / sample asset existence check.
4. Manual page checklist:
   - Home
   - Story
   - Gallery
   - Info
   - Hotels
   - Local Entertainment
   - Nav/dropdown
   - Gallery lightbox
   - Mobile width
5. If a commit/merge/publish is performed later, verify GitHub Pages and GoDaddy forwarding after publication.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/2026-06-20-variant-c-publishable-site-hardening.md` | Fill implementation evidence after execution. | This is the implementation contract. |
| `documentation/planning/sprints/README.md` | Add this sprint to the index. | Chronological sprint tracking. |
| `documentation/planning/working/refactor-plan.md` | Leave as planning evidence unless implementation changes refactor decisions materially. | Do not churn working docs unnecessarily. |
| `documentation/planning/working/prototype-lab/2026-06-20-variant-c-sitewide-pages.md` | Keep as absorbed working evidence. | This prototype records the two-pattern Variant C decision for implementation. |
| `documentation/planning/working/prototypes/variant_c_sitewide_pages.html` | Keep as visual reference during implementation; delete only after acceptance if cleanup is requested. | Throwaway artifact should guide production shape but not be copied blindly. |
| `documentation/planning/prd.md` | Update only if publish behavior or accepted product scope changes. | Planning says avoid broad doc churn. |
| `documentation/requirements/requirements.md` | Do not mutate during planning; update only after implementation if statuses/requirements change. | Requirements policy. |
| `documentation/requirements/current-state-design.md` | Update only after implementation if the public page shell or hero behavior becomes durable architecture. | Current-state design should describe actual state. |
| `documentation/planning/deployment-footprint.md` | Update only if release process/checks or hosting assumptions change. | Static deployment remains current. |
| Prototype files | Keep; do not delete. | Variant C remains design evidence. |

## Out of Scope
- Adding any new public pages.
- Creating a static site generator, Jekyll layout, React app, backend, upload flow, account system, comments, analytics, form handler, or serverless endpoint.
- Real wedding photo repository ingestion or curation.
- Deep refactor of `tools/photo-pipeline.ps1` placeholder manifest logic.
- Full external-link modernization, except for any link/copy that visibly blocks publish confidence.
- Full lightbox rewrite or advanced accessibility overhaul beyond preventing regressions.
- Renaming public routes such as `contact.html`, `hotels.html`, or `syracuse.html`.
- Committing, merging, or publishing automatically unless explicitly requested later.

## Risks and Dependencies
- Visual bugs are the primary risk. Because browser automation is currently unavailable, manual desktop/mobile review is a release blocker.
- The home hero behavior needs a conservative decision. For publishability, prefer a known-good fixed Variant C image until real photo curation is available, unless implementation can prove the session-stable hero list looks good.
- Repeated hand-edited page markup can drift. This sprint should standardize current pages; future drift can be addressed with a static consistency check or generator only after this release is stable.
- Gallery functionality is already implemented, so visual changes must be scoped carefully and smoke-tested.
- Existing external links may be stale. This sprint should not become a broad link-audit sprint, but visibly misleading publish blockers should be corrected or converted to historical text if found.
- GoDaddy forwarding is working per user update but must be rechecked after production publication.
- There are existing modified files in the worktree. `implement-change` must preserve user changes and avoid broad reverts.

## Definition of Done
- Existing pages only; no new pages added.
- Variant C is visibly the site-wide design contract for current public pages.
- Home no longer contains prototype-evaluation wording.
- Home hero does not appear stretched or obviously badly cropped in manual review.
- Gallery remains static and usable.
- Navigation and existing routes work.
- Static scan passes with 0 missing local references, 0 server runtime references, and 0 PHP files.
- No backend, form, upload, account, RSVP/address-collection behavior is introduced.
- Mobile review passes or any remaining mobile defects are fixed before publish.
- Sprint implementation evidence is completed with actual files/check results.
- GitHub Pages/GoDaddy post-publish checks are planned and, if publishing occurs in the same workflow, recorded.

## PR Checklist
- [x] Existing pages only; no new pages or route renames.
- [x] Variant C page-shell pattern applied consistently enough for browser review.
- [x] Home copy is archive-ready, not prototype text.
- [x] Home hero behavior is decided: fixed known-good hero for publication, with random/session mode preserved in `js/archive-home.js`.
- [x] Old logistics/event-site content is removed, reduced, or reframed where it made the page look broken.
- [x] Gallery visual treatment is aligned with the journal shell; lightbox source seam preserved.
- [x] Static scan passes.
- [x] Gallery metadata/assets check passes.
- [x] No PHP/server/form/upload/account/RSVP/address-collection behavior introduced; no-collection terms appear only as policy copy.
- [ ] Desktop manual review completed. Browser automation failed in-session; required before publish.
- [ ] Mobile manual review completed. Browser automation failed in-session; required before publish.
- [x] Sprint evidence filled in.
- [ ] If merged/published, GitHub Pages URL checked.
- [ ] If merged/published, GoDaddy forwarding checked.

## Implementation Evidence
| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-001 | Implemented | `index.html` remains the default static entry and uses the accepted Variant C landing journal shape. | Static scan: 6 HTML pages, 0 missing local refs, 0 runtime refs, 0 PHP files. | Pending | No route rename. |
| REQ-002 | Implemented | `index.html`, `about.html`, `gallery.html`, `contact.html`, `hotels.html`, `syracuse.html` now use archive-ready copy and remove prototype/old logistics-first framing. | Production source scan found no prototype wording; no-collection terms are intentional policy copy. | Pending | Story and travel content are preserved as archive chapters. |
| REQ-003 | Implemented | Shared nav labels and links were normalized across all six public pages. | Static scan resolved local references; source inspection confirmed existing route filenames. | Pending | Browser click-through still needs manual review. |
| REQ-004 | Implemented | Local CSS, JS, image, and gallery references remain deploy-safe. | Static scan: 65 local refs resolved, 0 missing or case-mismatched refs. Gallery asset check: 10 photos, 1 album, 5 hero photos, 0 missing generated assets. | Pending | External refs remain as CDNs and historical links. |
| REQ-005 | Partial | Bootstrap mobile nav retained; Variant C shell CSS includes mobile grid collapse rules. | Browser automation failed with `codex/sandbox-state-meta: missing field sandboxPolicy`. | Pending | Manual mobile review remains required before publish. |
| REQ-006 | Partial | Core content is now in readable journal sections and context cards; images use constrained/object-fit rules instead of old Bootstrap thumbnail drift. | Static/source checks passed; visual browser review unavailable in-session. | Pending | Manual desktop/mobile visual review remains required before publish. |
| REQ-012 | Implemented | No PHP or server runtime dependency was added. | Static scan: 0 server-side runtime references, 0 PHP files. | Pending | Static-only deployment preserved. |
| REQ-013 | Implemented | `contact.html` is a no-collection archive info page; no placeholder contact destination is displayed. | Production source scan found no forms/PHP/prototype copy; RSVP/upload/account terms appear only in no-collection policy copy. | Pending | Historical `contact.html` filename remains for route stability. |
| REQ-014 | Implemented | Changes are plain static HTML/CSS/JS and generated assets already in the repo; no build/runtime dependency added. | Static scan passes. | Pending | GitHub Pages source model preserved. |
| REQ-016 | Partial | Release checks were run and documented. | Static scan passed; production source scan passed with intentional policy-copy hits; gallery metadata/assets check passed; `git diff --check` showed only line-ending warnings. | Pending | Manual visual, hosted URL, and forwarding checks remain before public release. |
| REQ-017 | Deferred | No publish or hosted-domain check was performed in this implementation turn. | Not run. | Pending | User previously reported GoDaddy redirect works; recheck after merge/publish. |
| REQ-018 | Implemented | Variant C is represented in reusable page shell CSS and applied to existing static pages without a generator or backend. | Source inspection and static scan. | Pending | Future pages should use this shell unless a new sprint changes direction. |
| REQ-021 | Implemented | `gallery.html` now uses the journal shell while preserving `js/gallery-data.js` and `js/gallery.js`. | Gallery metadata/assets check passed: 10 photos, 1 album, 0 missing generated assets. | Pending | No upload/account/backend behavior added. |
| REQ-031 | Partial | Gallery album/lightbox IDs and scripts are preserved while presentation changed. | Static scan and metadata/assets check passed; browser lightbox smoke blocked by browser automation failure. | Pending | Manual lightbox open/next/previous/close review remains required. |
| REQ-032 | Partial | `index.html` uses a fixed fallback hero for publication; `js/archive-home.js` still supports random/session-stable hero mode when `data-hero-mode` is not `fixed`, with sessionStorage guarded. | Static/source checks passed; browser visual review blocked. | Pending | Conservative fixed hero is intentional until real photo curation validates rotating hero quality. |

## Implementation Closure
Checks run during implementation:

- `powershell -NoProfile -ExecutionPolicy Bypass -File documentation/planning/working/prototypes/static_site_scan.ps1`
  - Result: 6 HTML pages, 65 local references resolved, 0 missing or case-mismatched references, 0 server-side runtime references, 0 PHP files, 11 external references.
- Production source scan:
  - Result: no prototype-evaluation wording, PHP, or form markup in production surfaces.
  - Intentional hits: no-collection policy copy in `contact.html` and no-upload/no-account copy in `gallery.html`.
- Gallery metadata/assets check:
  - Result: 10 photos, 1 album, 5 hero photos, 0 missing generated assets.
- `git diff --check`
  - Result: no whitespace errors; Git reported line-ending normalization warnings only.
- Browser automation:
  - Attempted local file review of `index.html`.
  - Blocked by environment error: `codex/sandbox-state-meta: missing field sandboxPolicy`.

## Cleanup / Deferred
- Manual desktop visual review is still required before publish.
- Manual mobile visual review is still required before publish.
- Manual gallery lightbox smoke is still required before publish.
- GitHub Pages hosted URL and GoDaddy forwarding checks remain post-merge/post-publish tasks.
- Prototype artifacts remain as accepted design evidence and were not deleted.
- Existing unused legacy helper files remain outside this sprint's scope.

## Implementation Handoff
Use this sprint file as the implementation contract for `implement-change`.

Before editing production pages, review `documentation/planning/working/prototype-lab/2026-06-20-variant-c-sitewide-pages.md` and `documentation/planning/working/prototypes/variant_c_sitewide_pages.html`. Treat them as working evidence: absorb the landing/interior journal patterns, but do not copy throwaway code blindly.

Start with Commit 1: stabilize `index.html` against the accepted Variant C prototype and make a conservative hero decision for publication. The first proof seam is the home page: archive-ready copy, valid local refs, no prototype wording, no visually stretched hero, and no backend/no-collection drift.

Do not add pages, introduce a build system, rename routes, or refactor the photo pipeline in this sprint. Existing public pages, `css/style.css`, and narrowly necessary public JS are the expected implementation surface. After implementation, close this sprint plan with actual evidence, check outputs, manual visual-review notes, cleanup notes, and `Commit / PR` values.
