# Product Requirements Document

## Ordered Refresh - 2026-06-20

### Source Inputs
- Current user request to rerun systems documentation in logical order before PRD.
- Ordered systems refresh: `documentation/requirements/current-state-design.md`.
- Ordered behavioral refresh: `documentation/requirements/use-case-requirements.md`.
- Ordered requirements refresh: `documentation/requirements/requirements.md`.
- Ordered deployment refresh: `documentation/planning/deployment-footprint.md`.
- Repository files and static scan evidence.
- Sprint plans: `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`, `2026-06-20-generated-gallery-lightbox.md`, and `2026-06-20-archive-visual-refresh.md`.
- Prototype and grilling decisions captured under `documentation/planning/working/prototype-lab/`.

### Document Mode
Existing repository analysis and current product refresh for a static public wedding archive / memory site.

### Conflict Notes
No new material conflict blocks the PRD. Older documentation still contains AWS/PHP/contact-form-era analysis, but the current code and refreshed systems docs establish the active product truth: static GitHub Pages site, no backend, no visitor data collection, and AWS as fallback only.

### Decision Resolution Notes
- Current hosting decision: GitHub Pages is the active recommended production path; AWS static hosting is fallback.
- Current data/privacy decision: no RSVP, address, message, email form, PHP endpoint, or database is in scope.
- Current maintenance decision: stale external links and remaining dead legacy assets remain cleanup opportunities.
- Current photo direction: originals stay local/ignored; a local review/generation pipeline now creates committed public web assets and metadata for a generated static gallery.
- Current visual direction: the public site now has a wedding archive/photo album landing feel, with a session-stable hero photo selected from generated hero metadata or fallback.
- Current page-set decision: the temporary Info/contact page has been removed for now; the site keeps the no-collection posture by omitting visitor-submission paths rather than showing a standalone policy page.
- No grilling question was needed because the available source evidence supports these defaults.

### Problem Statement
The owner has an existing wedding website that should become a shareable historical archive of the wedding for the couple, family, and friends, while remaining inexpensive to maintain.

### Product Goal
Provide a simple, low-cost, public static wedding archive where visitors can read the wedding story, event memories, historical travel/local context, and a scalable static photo gallery without introducing backend complexity.

### Users and Stakeholders
| Actor / Stakeholder | Need | Evidence |
|---|---|---|
| Visitor / Guest | Read wedding memories, story, event context, and historical travel/local content. | Static pages and use cases |
| Couple / Family | Share a polished wedding memory site and browse wedding photos. | User update/prototype absorption |
| Photo Curator | Review local source photos, choose publish/exclude/hero decisions, and prepare album metadata. | Sprint research |
| Site Maintainer | Update static content safely and publish through GitHub. | Requirements/deployment docs |
| Domain Owner | Have a GoDaddy-forwarded public domain reach the hosted site. | User update: redirect is working |
| Future Maintainer | Understand that form/backend behavior is out of scope unless deliberately reintroduced. | Requirements/FMEA |

### Solution Summary
Keep the site as plain static HTML/CSS/JS/images on GitHub Pages, preserve the existing pages as a wedding archive, make outbound links non-misleading historical context, and use a generated static album/lightbox experience. Use a local-only review/generation workflow for original photos, commit only public web-sized outputs and metadata, and present the home page as a wedding archive/photo album landing experience. Treat uploads, tagging, private sharing, backend albums, forms, analytics, a broad build-system migration, or AWS migration as separate future product decisions.

### Scope
#### In Scope
- Public static pages: Home, Story/About, Gallery, Hotels, Local Entertainment/Syracuse.
- Internal navigation and mobile-readable layout.
- Local asset integrity and static scan verification.
- No public visitor-submission path for RSVPs, addresses, messages, uploads, comments, accounts, or contact.
- GitHub Pages publication and working GoDaddy forwarding/redirect.
- External hotel/activity link freshness review.
- Initial simple static photo gallery.
- Local photo review/generation pipeline for ignored original photos.
- Generated public gallery metadata, optimized web images, album sections, and static lightbox behavior.
- Archive visual refresh with a session-stable hero selected from explicit hero photos and a fallback hero.
- Cleanup of remaining unused countdown/validation-era assets if approved as implementation work.

#### Out of Scope
- RSVP, address, message, or email form collection.
- PHP, serverless form endpoints, databases, authentication, admin UI, or uploads.
- Public original-photo downloads, photo uploads, comments, accounts, private sharing, or backend photo management.
- AWS migration unless GitHub Pages becomes unsuitable.
- Full static site generator migration.

### Recommended MVP / Release Slice
The MVP is implemented as a static GitHub Pages wedding archive with no backend, generated placeholder gallery assets, and a refreshed archive landing. The just-completed sprint sequence was:

1. Local Photo Curation Pipeline: create ignored original-photo conventions, a local browser review app, private curation JSON, optimized JPEG generation, public metadata, and a generation report.
2. Generated Gallery and Lightbox: replace/refine the hand-built gallery with generated album sections, counts, thumbnails, large images, keyboard lightbox behavior, and stable photo hash links.
3. Archive Visual Refresh: update the public front end toward a photo-first wedding archive/photo album with session-stable hero behavior and chapter navigation.

The next practical cleanup items remain valid supporting work: record the GoDaddy domain/target, audit stale outbound links, remove or explicitly archive dead legacy interaction assets, and replace placeholder-generated photos with the real wedding source folder when available.

### User Stories
1. As a visitor, I want to open the wedding archive so that I can revisit the wedding story and memories.
2. As a visitor, I want to browse hotel and Syracuse pages as historical context so that I understand the wedding weekend setting without being sent to misleading links.
3. As a visitor, I do not need a standalone Info page while the archive has no RSVP, address, message, upload, account, or contact-submission path.
4. As the site maintainer, I want to publish static files from GitHub so that updates stay low-cost and simple.
5. As the domain owner, I want the working GoDaddy-forwarded URL to reach the hosted site so that visitors can use the public domain.
6. As a future maintainer, I want obsolete interaction assets removed or archived so that I do not mistake them for current behavior.
7. As the couple, we want a static photo gallery so that we can share wedding pictures without adding accounts, uploads, or backend services.
8. As a photo curator, I want to review the original photos locally so that private originals and raw decisions do not become public web assets.
9. As a site maintainer, I want generated thumbnails, large images, hero images, and public metadata so that hundreds of photos can be published without hand-authoring gallery HTML.
10. As a visitor, I want album sections and a lightbox so that browsing the gallery feels natural on desktop and mobile.
11. As a visitor, I want the home page to feel like a finished wedding archive/photo album so that the site makes a strong first impression.

### Functional Expectations
- The site serves `index.html` as the public entry point.
- Visitors can navigate among Home, Story/About, Gallery, Hotels, and Local Entertainment.
- Hotels and Syracuse pages display historical wedding-weekend context even if external links are unavailable.
- Public pages do not expose address, RSVP, message, upload, account, comment, or contact-submission paths.
- Local assets resolve with deploy-safe paths.
- GitHub Pages hosted URL and GoDaddy-forwarded URL are available.
- Photo tooling keeps original photos and raw curation state local/private.
- Gallery generation publishes only optimized static assets and public-safe metadata.
- Generated gallery preserves source folders as album sections, shows counts, supports all non-excluded photos, and provides a vanilla-JS lightbox with hash deep links.
- Archive landing uses explicit hero photos, stable-per-session selection, fallback behavior, focal-point metadata, and hero text independent from captions.

### Baseline Approach
Use GitHub Pages for current production static hosting, working GoDaddy forwarding for the public domain, and plain static public assets. Keep AWS static hosting as a fallback, not current work. Keep the no-backend boundary: the photo workflow should run locally, generated public assets/data should be committed, and the public gallery should remain static HTML/CSS/vanilla JS rather than an upload-backed application.

### Non-Functional Expectations
| Area | Expectation | Evidence / Status |
|---|---|---|
| Cost | Free or effectively free static hosting. | Deployment footprint |
| Privacy | No visitor-submitted data collection. | Source scan and requirements |
| Reliability | Core content remains readable without third-party sites. | Requirements |
| Security | No server runtime, secrets, or backend attack surface. | Static scan and deployment footprint |
| Maintainability | Static edits remain simple; dead assets should not obscure current behavior. | Class/FMEA/refactor notes |
| Performance | Public gallery should use optimized thumbnails/large/hero images rather than browser-scaling originals. | Sprint research |
| Privacy | Source originals and raw curation state should not be public committed artifacts. | Requirements |
| Verification | Static scan plus browser/domain/link smoke checks. | Requirements/deployment |

### Candidate Requirements
- Serve the home page as the default entry point.
- Present public wedding, story, lodging, local, and info content.
- Preserve travel/local pages as historical archive context.
- Provide internal navigation on desktop and mobile.
- Keep local asset references deploy-safe and case-correct.
- Avoid PHP/server runtime dependency.
- Preserve no collection of visitor messages, RSVPs, addresses, uploads, comments, accounts, or contact submissions.
- Provide current enough outbound venue/hotel/activity links.
- Publish through GitHub Pages and verify GoDaddy forwarding.
- Remove or archive remaining unused legacy interaction assets.
- Support a simple static photo gallery without requiring uploads or backend services.
- Provide a local browser workflow for reviewing ignored source photos.
- Record private photo curation state for review status, hero eligibility, album naming, covers, and focal points.
- Generate optimized thumbnail, large, and hero JPEG derivatives.
- Generate public-safe gallery metadata and a generation report.
- Present generated album sections, all non-excluded photos, album/photo counts, and static lightbox navigation.
- Support stable photo deep links.
- Present a session-stable archive hero from explicit hero photos with fallback behavior.

### Implementation Decisions
- Keep the current plain static architecture.
- Do not add a build step for the current maintenance slice.
- Do not reintroduce form/backend behavior.
- Treat `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, `css/jquery.countdown.js`, and extracted validation vendor files as cleanup candidates after reference checks.
- Treat external link updates as archive-polish/content reliability work, not architecture work.
- Treat the current gallery as static HTML/image content until the generated-gallery sprint replaces/refines it.
- Keep original wedding photos under an ignored local source folder and commit only generated public web assets.
- Prefer a local Python/Pillow review/generation tool for the photo pipeline, with public `gallery-data.json` and ignored private curation state.
- Preserve source folders as public album sections by default, with display-name overrides.
- Use vanilla JavaScript for the public lightbox and hero session behavior.

### Test Seams
- Static scan: local references, PHP/runtime references, missing assets.
- Five-page browser smoke: Home, Story/About, Gallery, Hotels, Syracuse.
- Mobile nav smoke: collapsed navigation and Travel dropdown.
- Public URL smoke: GitHub Pages URL.
- Domain smoke: working GoDaddy-forwarded URL.
- Link audit: outbound venue/hotel/activity links.
- Gallery smoke: static gallery page loads selected images without backend calls.
- Local photo pipeline tests: fixture image review state, generated image widths, metadata schema, report counts, ignored originals/private state.
- Generated gallery browser smoke: album sections, counts, thumbnails, lightbox next/previous/close, keyboard navigation, hash deep links, no backend/upload/original download paths.
- Archive visual smoke: session-stable hero, fallback hero, focal-point/readability, chapter navigation, desktop/mobile layout.

### Testing Decisions
- Run the existing static scan before and after cleanup.
- Search for obsolete contact/PHP/form placeholders after cleanup.
- Verify no production page links to removed `contact.html`.
- Verify all five pages after publishing.
- Record external-link keep/update/remove/plain-text decisions.
- For the photo pipeline sprint, use fixture photos first and verify generated `thumb`, `large`, and `hero` outputs before trying the real archive.
- For the generated gallery sprint, verify public behavior from generated metadata rather than hand-authored image cards.
- For the visual refresh sprint, use browser screenshots or manual viewport checks before accepting the UI.

### Release and Rollout
Current release path:
1. Make content/cleanup changes on `development`.
2. Run static scan and source searches.
3. Smoke test changed pages and mobile navigation.
4. Promote to `main` for GitHub Pages publication.
5. Verify GitHub Pages URL.
6. Verify or re-check GoDaddy forwarding after public changes.

Rollback: revert or correct the production branch and let GitHub Pages republish; pause or update GoDaddy forwarding if the public domain points to a bad target.

### Risks and Tradeoffs
| Risk / Tradeoff | Impact | Mitigation |
|---|---|---|
| Stale external links | Visitors may receive misleading historical travel/local context. | Audit and replace, remove, or convert known stale links to plain text notes. |
| GoDaddy forwarding regression | Public domain may fail for visitors after future changes. | Record current working setup and re-check after publishing. |
| Dead legacy assets remain | Maintainers may misunderstand current behavior. | Remove/archive after reference checks. |
| GitHub Pages dependency | Static hosting depends on GitHub account/repo settings. | Keep AWS static hosting as fallback. |
| No backend/forms | Cannot collect RSVPs/messages through the site. | This matches current scope; require new PRD if needed later. |
| Photo repository scale | Hundreds of originals could bloat the repo or slow the public site. | Ignore originals; generate optimized public assets. |
| Gallery scope creep | Photo uploads, accounts, original downloads, or private sharing could introduce backend/privacy complexity. | Keep public gallery static and generated from local tooling. |
| Hero image variability | Random hero photos could make the landing feel jumpy or unreadable. | Select only explicit hero photos, keep the choice stable for a session, and support focal points/fallback. |

### Success Metrics
| Metric | Target or Placeholder | Measurement Method | Source / Status |
|---|---|---|---|
| Static scan missing refs | 0 | Run scan | Current pass |
| Static scan runtime refs/PHP files | 0 | Run scan | Current pass |
| Five-page smoke | 5/5 pages load expected content | Browser check | Needed per release |
| Mobile navigation | Primary nav and Travel menu usable | Phone or responsive browser check | Needed after JS cleanup |
| GoDaddy forwarding | Public domain reaches hosted site | Browser check | Working per user update |
| Stale known links | 0 known misleading high-value links before sharing the archive broadly | Link audit | Pending |
| Static gallery first slice | Gallery page loads selected photos without backend calls | Static scan/browser smoke | Implemented initial slice |
| Photo pipeline fixture generation | Fixture photos produce expected public assets, metadata, and report | Automated/integration | Implemented/check passed |
| Generated gallery usability | Album counts, thumbnails, lightbox, keyboard navigation, and deep links pass smoke checks | Browser smoke | Implemented; browser automation unavailable |
| Archive hero stability | Hero stays stable during a browser session and falls back safely | Browser smoke | Implemented; browser automation unavailable |

### Assumptions
- GitHub Pages remains available and acceptable for this repository.
- GoDaddy forwarding is working and remains the domain approach for now.
- The site is an archival wedding memory site, not an active event-management or guest-logistics tool.
- Link polish matters more than preserving exact old outbound destinations as clickable recommendations.
- The gallery should remain static; local tooling may generate public assets, but public visitors should not upload, manage accounts, or access originals.
- The first photo pipeline should preserve folders as albums and publish all non-excluded photos.

### Gaps and Questions
- What exact GoDaddy domain and target URL should be recorded?
- Which stale external links should be replaced, removed, or converted to historical plain text?
- Should remaining unused countdown and validation assets be removed in the next implementation pass?
- Should a warmer Weekend/Details page be added in a future sprint?
- The real wedding photo repository has not been added yet.
- Which album display names, covers, hero photos, and exclusions should be chosen after local review?
- Which captions, if any, should be added after the first gallery generation?

### Follow-On Artifacts
- Context diagram and matrix: refreshed.
- Use case diagram: refreshed.
- Use case behavioral matrix: refreshed.
- Requirements: refreshed.
- Deployment footprint: refreshed.
- Class diagram: refreshed.
- Sequence diagram: refreshed.
- FFBD: refreshed.
- IDEF0: refreshed.
- FMEA: refreshed.
- Deployment footprint: should be lightly refreshed after generated asset paths/sizes are finalized, because public asset volume affects GitHub Pages repository footprint.

### Cleanup / PR Hygiene
- Keep durable refreshed docs in `documentation/planning/` and `documentation/requirements/`.
- Treat old AWS/PHP/contact-form archive material as historical unless explicitly promoted again.
- Do not delete working prototype notes automatically; decide later whether the static scan should be promoted into a maintained release script.

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Product Requirements Document; use the archive only for historical context.
