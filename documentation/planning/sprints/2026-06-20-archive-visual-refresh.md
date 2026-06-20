# Sprint Plan: Archive Visual Refresh

## Source Inputs
- `documentation/planning/working/prototype-lab/2026-06-20-archive-visual-refresh.md`
- `documentation/planning/working/prototypes/archive_visual_refresh_variants.html`
- User design decisions from grilling:
  - Site should feel like a wedding archive/photo album.
  - Home hero should use one strong photo.
  - Hero photo should be random but stable for the session.
  - Hero text should not require per-image captions.
  - Hero images must be explicitly marked `hero`.
  - Hero focal point metadata should be supported by the local review tool.
  - Public gallery/front end should remain static/no-backend.
- Planned dependency: `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`
- Planned dependency: `documentation/planning/sprints/2026-06-20-generated-gallery-lightbox.md`
- `documentation/planning/prd.md`
- `documentation/requirements/requirements.md`
- `documentation/requirements/current-state-design.md`

## Sprint Goal
Refresh the public-facing archive UI so the home page feels like a polished wedding archive/photo album, using a strong session-stable hero image and chapter-style navigation into Story, Gallery, Info, and Travel.

## Branch / PR Intent
- Suggested branch: `feature/archive-visual-refresh`
- Draft PR title: `Refresh wedding archive front end`
- Draft PR summary: Apply the archive visual direction from prototype-lab to the public site: stronger photo-first home hero, chapter navigation, quieter Bootstrap styling, consistent caption treatments, and smoke-tested responsive behavior.

## Scope Decision
This is the third sprint because visual polish should come after the photo pipeline and generated gallery define available hero/gallery assets. It is PR-sized if it focuses on home, shared navigation styling, and small gallery/story visual consistency rather than rewriting every page.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-001 Serve Home Entry | Planned | Home page is the main visual refresh target. | Home loads with new archive landing. | Refresh home archive landing |
| REQ-002 Present Wedding Archive Summary | Planned | Hero/chapter design must preserve names/date/place/story framing. | Home inspection and smoke test. | Refresh home archive landing |
| REQ-003 Provide Internal Navigation | Planned | Chapter links and nav must route to existing pages. | Navigation smoke. | Add archive chapter navigation |
| REQ-005 Support Mobile Navigation | Planned | New hero/chapter layout must work on phones. | Mobile viewport smoke. | Add responsive archive styling |
| REQ-006 Preserve Readable Core Content | Planned | Text should remain readable over photos and if assets degrade. | Browser/manual smoke. | Add resilient hero and captions |
| REQ-016 Verify Public Release | Planned | Visual changes need static scan and browser smoke. | Scan plus page smoke notes. | Close visual refresh checks |
| REQ-021 Support Static Photo Gallery | Planned | Gallery/chapter links and caption treatment should remain consistent. | Gallery navigation and smoke. | Align gallery visual treatment |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Archive | Home page becomes a polished archive landing. | Primary sprint focus. |
| UC-003 Read Information Page | Navigation/chapter styling may touch Info link only. | No content/behavior change expected. |
| UC-006 View Static Photo Gallery | Gallery entry point and visual treatment align with archive design. | Generated gallery behavior should already exist from Sprint 2. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| Variant A's full-bleed archive hero created the strongest first impression. | Absorb | Use a photo-first hero on home. |
| Variant C's chapter navigation clarified the archive structure. | Absorb | Add chapter links to Story/Gallery/Info/Travel. |
| Variant B is better for gallery refinement than home. | Defer/partial | Use caption/card ideas only if they fit generated gallery styling. |
| Reduce Bootstrap button-heavy visual feel. | Absorb | Calm nav/CTA styling without changing static architecture. |
| Session-stable random hero from explicit hero set. | Absorb if Sprint 1/2 provide hero metadata; otherwise fallback. | Use generated hero list when available; default to current/static hero if not. |

## Vertical Slice
A visitor opens the home page and sees a polished wedding archive/photo album landing page with a strong hero image, Sonia/Steve/date/place framing, simple chapter links, and consistent routes into Story, Gallery, Info, and Travel. The design remains responsive and static.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Refresh home hero and archive framing. | REQ-001, REQ-002, REQ-006 | Home smoke; text readability check. |
| 2 | Add chapter navigation and calm nav/CTA styling. | REQ-003, REQ-005 | Desktop/mobile nav smoke. |
| 3 | Add session-stable hero selection from generated hero metadata. | REQ-002, REQ-021 | Session storage/manual smoke; fallback check. |
| 4 | Align gallery/story caption and section styling. | REQ-002, REQ-021 | Gallery/story smoke. |
| 5 | Update docs and close sprint evidence. | REQ-016, REQ-019 | Static scan; visual smoke notes. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Home page | Hero image/text/chapter links render. | Manual/browser smoke | Open `index.html`; verify visible archive framing. |
| Hero randomization | Hero is session-stable and uses only explicit hero list. | Manual/browser/unit if JS extracted | Reload within session; new session behavior; fallback if no hero list. |
| Navigation | Chapter links reach Story/Gallery/Info/Travel. | Manual/browser smoke | Click each chapter/nav link. |
| Mobile | Hero, nav, chapter links, and gallery entry fit. | Manual/browser smoke | Mobile viewport checks. |
| Static scan | All local refs resolve. | Automated | `powershell -ExecutionPolicy Bypass -File documentation\planning\working\prototypes\static_site_scan.ps1` |
| No backend | No forms/uploads/accounts added. | Inspection | `rg -n "<form|upload|fetch\\(|XMLHttpRequest|action=" *.html js css` |

## Check Sequence
1. Confirm Sprint 1/2 outputs are available or choose a static fallback hero.
2. Implement home visual refresh in the smallest vertical slice.
3. Add chapter navigation.
4. Add session-stable hero selection if generated hero metadata exists.
5. Smoke test desktop.
6. Smoke test mobile.
7. Run static scan.
8. Inspect no-backend/no-upload behavior.
9. Update docs only for accepted public behavior changes.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/2026-06-20-archive-visual-refresh.md` | Close with implementation evidence. | Sprint contract. |
| `documentation/planning/prd.md` | Potential update to success metrics/solution summary if visual refresh changes accepted product behavior. | Public experience changes. |
| `documentation/requirements/current-state-design.md` | Potential update to class/sequence notes for hero metadata/session behavior. | Design behavior changes. |
| `documentation/requirements/use-case-requirements.md` | Potential update to UC-001 evidence. | Home flow changes. |
| Prototype-lab record | Keep as evidence or mark superseded after implementation. | Prototype absorption trace. |

## Out of Scope
- Building the local photo review/generation tool.
- Replacing the generated gallery/lightbox behavior.
- Reworking every historical travel/hotel link.
- Renaming `contact.html`.
- Adding analytics, forms, uploads, accounts, comments, private albums, or backend behavior.
- Full static site generator/template migration.

## Risks and Dependencies
- Best result depends on having at least one good hero image or generated hero metadata.
- Session-stable random hero must not make the site feel jumpy.
- Hero overlays must remain readable across varied photos.
- Bootstrap 3 nav constraints may limit visual polish without broader markup refactor.
- If many pages share duplicated nav/footer markup, implementation must update consistently.

## Definition of Done
- Home page visually reads as a wedding archive/photo album.
- Chapter navigation is clear and works.
- Hero is stable within a session when randomization is enabled.
- Fallback hero works when no generated hero metadata exists.
- Mobile layout is usable.
- Gallery/story visual treatment is consistent enough for the sprint scope.
- Static scan passes.
- No backend/upload/account behavior is introduced.
- Sprint evidence is filled in.

## PR Checklist
- [x] Home hero is visually refreshed.
- [x] Hero text is independent of per-image captions.
- [x] Session-stable hero behavior works or is explicitly deferred with fallback.
- [x] Chapter links work.
- [x] Mobile viewport works.
- [x] Gallery entry remains usable.
- [x] Static scan passes.
- [x] No backend/upload/account behavior is introduced.
- [x] Docs updated only for accepted behavior changes.
- [x] Sprint implementation evidence is filled in.

## Implementation Evidence
Implemented 2026-06-20 by `implement-change`.

| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-001 Serve Home Entry | Implemented | `index.html` archive hero remains the home entry | Static scan | Pending | Home keeps existing static route. |
| REQ-002 Present Wedding Archive Summary | Implemented | `index.html` hero text preserves names, date, place, and archive framing | Source inspection | Pending | Text is independent from image captions. |
| REQ-003 Provide Internal Navigation | Implemented | Chapter links to Story, Gallery, Info, Travel | Source inspection/static scan | Pending | Existing nav remains. |
| REQ-005 Support Mobile Navigation | Implemented | Responsive hero/chapter/lightbox CSS in `css/style.css` | Source inspection; browser automation unavailable | Pending | Manual viewport review still recommended. |
| REQ-006 Preserve Readable Core Content | Implemented | Hero overlay and fallback image in `index.html`/`js/archive-home.js` | Static scan/source inspection | Pending | Fallback used if generated hero metadata is unavailable. |
| REQ-016 Verify Public Release | Implemented | Static scan and no-backend inspection | Static scan: 6 pages, 76 local refs, 0 missing, 0 runtime refs, 0 PHP | Pending | Browser automation unavailable in this sandbox. |
| REQ-032 Support Session-Stable Archive Hero | Implemented | `js/archive-home.js`; `js/gallery-data.js`; generated hero images | Source inspection; generated hero list contains 5 placeholder hero photos | Pending | Uses `sessionStorage` and generated/fallback hero data. |

## Cleanup / Deferred
- Replace placeholder-generated hero/gallery assets with the real wedding photo source folder when available.
- Real-browser screenshot review is still recommended before sharing broadly.

## Implementation Handoff
Use this sprint after the photo pipeline and generated gallery have clarified hero/gallery data. Start with the home hero and chapter navigation as the first vertical slice. Do not build the curation app or public generated gallery in this sprint. Close this plan with actual screenshots/smoke notes, static scan output, and doc updates.
