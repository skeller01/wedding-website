# Product Requirements Document

## Ordered Refresh - 2026-06-20

### Source Inputs
- Current user request to rerun systems documentation in logical order before PRD.
- Ordered systems refresh: `documentation/requirements/current-state-design.md`.
- Ordered behavioral refresh: `documentation/requirements/use-case-requirements.md`.
- Ordered requirements refresh: `documentation/requirements/requirements.md`.
- Ordered deployment refresh: `documentation/planning/deployment-footprint.md`.
- Repository files and static scan evidence.

### Document Mode
Existing repository analysis and current product refresh for a static public wedding archive / memory site.

### Conflict Notes
No new material conflict blocks the PRD. Older documentation still contains AWS/PHP/contact-form-era analysis, but the current code and refreshed systems docs establish the active product truth: static GitHub Pages site, no backend, no visitor data collection, and AWS as fallback only.

### Decision Resolution Notes
- Current hosting decision: GitHub Pages is the active recommended production path; AWS static hosting is fallback.
- Current data/privacy decision: no RSVP, address, message, email form, PHP endpoint, or database is in scope.
- Current maintenance decision: stale external links, dead legacy assets, and future static gallery planning are the next practical risks/opportunities.
- No grilling question was needed because the available source evidence supports these defaults.

### Problem Statement
The owner has an existing wedding website that should become a shareable historical archive of the wedding for the couple, family, and friends, while remaining inexpensive to maintain.

### Product Goal
Provide a simple, low-cost, public static wedding archive where visitors can read the wedding story, event memories, and historical travel/local context, and where the couple can later add a simple static photo gallery without introducing backend complexity.

### Users and Stakeholders
| Actor / Stakeholder | Need | Evidence |
|---|---|---|
| Visitor / Guest | Read wedding memories, story, event context, and historical travel/local content. | Static pages and use cases |
| Couple / Family | Share a polished wedding memory site and potentially browse photos later. | User update |
| Site Maintainer | Update static content safely and publish through GitHub. | Requirements/deployment docs |
| Domain Owner | Have a GoDaddy-forwarded public domain reach the hosted site. | User update: redirect is working |
| Future Maintainer | Understand that form/backend behavior is out of scope unless deliberately reintroduced. | Requirements/FMEA |

### Solution Summary
Keep the site as plain static HTML/CSS/JS/images on GitHub Pages, preserve the existing pages as a wedding archive, make outbound links non-misleading historical context, and clean up unused legacy interaction assets. Treat a simple static gallery as likely future scope; treat uploads, tagging, private sharing, backend albums, forms, analytics, a build system, or AWS migration as separate future product decisions.

### Scope
#### In Scope
- Public static pages: Home, About, Info, Hotels, Local Entertainment/Syracuse.
- Internal navigation and mobile-readable layout.
- Local asset integrity and static scan verification.
- Clear no-collection information page.
- GitHub Pages publication and working GoDaddy forwarding/redirect.
- External hotel/activity link freshness review.
- Future simple static photo gallery planning.
- Cleanup of unused countdown/validation-era assets if approved as implementation work.

#### Out of Scope
- RSVP, address, message, or email form collection.
- PHP, serverless form endpoints, databases, authentication, admin UI, or uploads.
- Dynamic albums, photo uploads, tagging, comments, private sharing, or backend photo management.
- AWS migration unless GitHub Pages becomes unsuitable.
- Full redesign or static site generator migration.

### Recommended MVP / Release Slice
The MVP is already largely implemented: a static GitHub Pages wedding archive with no backend. The next release slice should be an archive-polish/cleanup pass:

1. Record the working GoDaddy-forwarded domain and target URL.
2. Audit hotel/activity/venue links and make them historical, current, or plain-text context rather than misleading recommendations.
3. Remove or explicitly archive unused countdown and validation assets.
4. Sketch the first simple static gallery slice.
5. Keep static scan and five-page smoke checks as the release gate.

### User Stories
1. As a visitor, I want to open the wedding archive so that I can revisit the wedding story and memories.
2. As a visitor, I want to browse hotel and Syracuse pages as historical context so that I understand the wedding weekend setting without being sent to misleading links.
3. As a visitor, I want the Info page to be clear so that I do not try to submit an RSVP, address, or message through a nonexistent form.
4. As the site maintainer, I want to publish static files from GitHub so that updates stay low-cost and simple.
5. As the domain owner, I want the working GoDaddy-forwarded URL to reach the hosted site so that visitors can use the public domain.
6. As a future maintainer, I want obsolete interaction assets removed or archived so that I do not mistake them for current behavior.
7. As the couple, we want a future static photo gallery so that we can share wedding pictures without adding accounts, uploads, or backend services.

### Functional Expectations
- The site serves `index.html` as the public entry point.
- Visitors can navigate among Home, About, Info, Hotels, and Local Entertainment.
- Hotels and Syracuse pages display historical wedding-weekend context even if external links are unavailable.
- Info page states that the site does not collect addresses, RSVPs, or messages.
- Local assets resolve with deploy-safe paths.
- GitHub Pages hosted URL and GoDaddy-forwarded URL are available.

### Baseline Approach
Use GitHub Pages for current production static hosting, working GoDaddy forwarding for the public domain, and plain file edits for maintenance. Keep AWS static hosting as a fallback, not current work. Keep the no-backend boundary; a future static gallery should use checked-in images/pages before considering any dynamic photo feature.

### Non-Functional Expectations
| Area | Expectation | Evidence / Status |
|---|---|---|
| Cost | Free or effectively free static hosting. | Deployment footprint |
| Privacy | No visitor-submitted data collection. | Info page and requirements |
| Reliability | Core content remains readable without third-party sites. | Requirements |
| Security | No server runtime, secrets, or backend attack surface. | Static scan and deployment footprint |
| Maintainability | Static edits remain simple; dead assets should not obscure current behavior. | Class/FMEA/refactor notes |
| Verification | Static scan plus browser/domain/link smoke checks. | Requirements/deployment |

### Candidate Requirements
- Serve the home page as the default entry point.
- Present public wedding, story, lodging, local, and info content.
- Preserve travel/local pages as historical archive context.
- Provide internal navigation on desktop and mobile.
- Keep local asset references deploy-safe and case-correct.
- Avoid PHP/server runtime dependency.
- Clearly state no collection of visitor messages, RSVPs, or addresses.
- Provide current enough outbound venue/hotel/activity links.
- Publish through GitHub Pages and verify GoDaddy forwarding.
- Remove or archive unused legacy interaction assets.
- Support a future simple static photo gallery without requiring uploads or backend services.

### Implementation Decisions
- Keep the current plain static architecture.
- Do not add a build step for the current maintenance slice.
- Do not reintroduce form/backend behavior.
- Treat `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, and extracted validation vendor files as cleanup candidates after reference checks.
- Treat external link updates as archive-polish/content reliability work, not architecture work.
- Treat the future gallery as static HTML/image content unless a later decision changes scope.

### Test Seams
- Static scan: local references, PHP/runtime references, missing assets.
- Five-page browser smoke: Home, About, Info, Hotels, Syracuse.
- Mobile nav smoke: collapsed navigation and Travel dropdown.
- Public URL smoke: GitHub Pages URL.
- Domain smoke: working GoDaddy-forwarded URL.
- Link audit: outbound venue/hotel/activity links.
- Gallery smoke, when added: static gallery page loads thumbnails/full images without backend calls.

### Testing Decisions
- Run the existing static scan before and after cleanup.
- Inspect `contact.html` to confirm no form and no-collection copy remain.
- Search for obsolete contact/PHP/form placeholders after cleanup.
- Verify all five pages after publishing.
- Record external-link keep/update/remove/plain-text decisions.

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
| Gallery scope creep | Photo uploads/albums/private sharing could introduce backend/privacy complexity. | Keep first gallery static and checked into the repo. |

### Success Metrics
| Metric | Target or Placeholder | Measurement Method | Source / Status |
|---|---|---|---|
| Static scan missing refs | 0 | Run scan | Current pass |
| Static scan runtime refs/PHP files | 0 | Run scan | Current pass |
| Five-page smoke | 5/5 pages load expected content | Browser check | Needed per release |
| Mobile navigation | Primary nav and Travel menu usable | Phone or responsive browser check | Needed after JS cleanup |
| GoDaddy forwarding | Public domain reaches hosted site | Browser check | Working per user update |
| Stale known links | 0 known misleading high-value links before sharing the archive broadly | Link audit | Pending |
| Static gallery first slice | Gallery page loads selected photos without backend calls | Browser/static scan | Future scope |

### Assumptions
- GitHub Pages remains available and acceptable for this repository.
- GoDaddy forwarding is working and remains the domain approach for now.
- The site is an archival wedding memory site, not an active event-management or guest-logistics tool.
- Link polish matters more than preserving exact old outbound destinations as clickable recommendations.
- A future gallery should be static unless the couple explicitly chooses a dynamic/private photo feature later.

### Gaps and Questions
- What exact GoDaddy domain and target URL should be recorded?
- Which stale external links should be replaced, removed, or converted to historical plain text?
- Should unused countdown and validation assets be removed in the next implementation pass?
- Should `contact.html` eventually be renamed or redirected to match the visible Info label?
- Which photos should seed the first static gallery, and should the gallery be a new page or integrated into the home/story flow?

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

### Cleanup / PR Hygiene
- Keep durable refreshed docs in `documentation/planning/` and `documentation/requirements/`.
- Treat old AWS/PHP/contact-form archive material as historical unless explicitly promoted again.
- Do not delete working prototype notes automatically; decide later whether the static scan should be promoted into a maintained release script.

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Product Requirements Document; use the archive only for historical context.
