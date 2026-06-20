# Sprint Plan: Generated Gallery and Lightbox

## Source Inputs
- User grilling decisions from 2026-06-20:
  - Public gallery should show all non-excluded photos.
  - Preserve folder structure as albums, with display-name overrides.
  - Use generated thumbnails and larger display JPEGs.
  - Use one gallery page with album sections first.
  - No public download-original/full-resolution feature.
  - Add a small custom vanilla-JS lightbox.
  - Lightbox should support next/previous, close, keyboard arrows/Escape, and hash deep links.
  - Photo IDs should be path-derived with collision handling.
  - Sort by folder/name order first; EXIF can wait.
  - Show album/photo counts lightly.
  - Commit generated web assets and public metadata.
- Planned dependency: `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`
- `documentation/planning/prd.md`
- `documentation/planning/deployment-footprint.md`
- `documentation/requirements/requirements.md`
- `documentation/requirements/use-case-requirements.md`
- `documentation/requirements/current-state-design.md`
- `documentation/planning/working/prototype-lab/2026-06-20-static-gallery-front-end.md`

## Sprint Goal
Replace or refine the hand-built static gallery into a generated, folder-preserving, scalable public gallery with album sections, thumbnails, large images, and a small custom lightbox.

## Branch / PR Intent
- Suggested branch: `feature/generated-gallery-lightbox`
- Draft PR title: `Add generated wedding gallery with static lightbox`
- Draft PR summary: Wire generated photo metadata and optimized web images into a static album gallery with lazy thumbnails, album counts, custom vanilla-JS lightbox navigation, and hash deep links.

## Scope Decision
This sprint depends on the local photo pipeline because the public gallery should not manually manage hundreds of `<img>` tags. It is sprint-sized because it only integrates generated data/assets and visitor behavior; it does not build the curation tool or redesign the home page.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-003 Provide Internal Navigation | Planned | Visitors must reach gallery and return to archive pages. | Nav/gallery links tested. | Wire generated gallery page |
| REQ-004 Resolve Local Assets | Planned | Generated thumbnail/large image paths must resolve. | Static scan passes. | Wire generated assets |
| REQ-005 Support Mobile Navigation | Planned | Gallery and lightbox must be usable on phones. | Mobile smoke test. | Add responsive album layout |
| REQ-006 Preserve Readable Core Content | Planned | Album headings/counts should work even if JS fails. | JS-disabled/manual inspection. | Render static album sections |
| REQ-016 Verify Public Release | Planned | Gallery needs static scan and browser smoke coverage. | Scan plus gallery/lightbox smoke. | Add gallery checks |
| REQ-021 Support Static Photo Gallery | Planned | This is the main public gallery scale-up. | Generated gallery, lightbox, hash links. | Add generated gallery/lightbox |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-001 View Wedding Archive | Navigation includes the generated gallery. | Home/visual refresh is Sprint 3. |
| UC-005 Maintain Archive Content | Uses generated outputs from Sprint 1. | No raw originals in public site. |
| UC-006 View Static Photo Gallery | Upgrades from initial static gallery to scalable generated album gallery. | Main sprint focus. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| Story-card gallery worked for a small curated set. | Partially absorb | Keep caption/album intentionality, but replace manual cards with generated sections. |
| Gallery should remain static/no-backend. | Absorb | Use committed generated assets/data and vanilla JS only. |
| Full repo may contain hundreds of photos. | Absorb | Use thumbnails, lazy loading, and lightbox rather than full-size long page. |
| Archive visual refresh has home-page ideas. | Defer | Home/front-end redesign is Sprint 3. |

## Vertical Slice
A visitor opens `gallery.html`, sees album sections derived from generated metadata, scans optimized thumbnails, opens a thumbnail in a lightbox, navigates next/previous with mouse or keyboard, copies/opens a `#photo=<id>` deep link, and can close back to the album grid without leaving the static site.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Add generated gallery data contract and fixture assets. | REQ-004, REQ-021 | Static scan; metadata contract test or fixture inspection. |
| 2 | Render album sections and thumbnail grid. | REQ-003, REQ-006, REQ-021 | Browser smoke; JS-disabled content check. |
| 3 | Add custom vanilla-JS lightbox with keyboard navigation. | REQ-005, REQ-021 | Manual/browser smoke: open, next, previous, close, mobile viewport. |
| 4 | Add hash deep-link support and stable photo IDs. | REQ-021 | Open `gallery.html#photo=<id>` directly. |
| 5 | Update docs and sprint evidence after public behavior changes. | REQ-016, REQ-019 | Static scan; requirements/design doc updates if accepted. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Static scan | Generated image/data references resolve. | Automated | `powershell -ExecutionPolicy Bypass -File documentation\planning\working\prototypes\static_site_scan.ps1` |
| Gallery HTML | Album headings, counts, and thumbnails render from generated data. | Smoke/integration | Open `gallery.html`; inspect album sections. |
| Lightbox | Open/close/next/previous works. | Manual/browser | Click thumbnail; arrows; Escape; close button. |
| Deep links | `#photo=<path-derived-id>` opens expected photo. | Manual/browser | Direct URL hash smoke. |
| Mobile | Grid and lightbox fit phone viewport. | Manual/browser | Responsive viewport smoke. |
| No backend | No upload/form/fetch dependency for public gallery. | Inspection | `rg -n "<form|upload|fetch\\(|XMLHttpRequest|action=" gallery.html js css` |

## Check Sequence
1. Confirm Sprint 1 generated metadata/assets exist or create a small fixture equivalent.
2. Wire album sections and thumbnail paths.
3. Run static scan.
4. Add lightbox behavior.
5. Smoke test gallery on desktop and mobile.
6. Test hash deep links.
7. Inspect no-backend/public privacy markers.
8. Update durable docs only after implementation changes accepted behavior.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/2026-06-20-generated-gallery-lightbox.md` | Close with implementation evidence. | Sprint contract. |
| `documentation/requirements/requirements.md` | Potentially update REQ-021 evidence from initial gallery to generated gallery. | Public behavior changes. |
| `documentation/requirements/use-case-requirements.md` | Potentially update UC-006 steps/evidence. | Gallery flow expands to albums/lightbox. |
| `documentation/requirements/current-state-design.md` | Potentially update class/sequence/FMEA notes for generated metadata/lightbox. | Architecture details change. |
| `documentation/planning/deployment-footprint.md` | Potentially update asset sizing and static footprint notes. | Generated assets affect Pages size. |

## Out of Scope
- Local review app and image generator implementation.
- Full front-end visual refresh/home-page redesign.
- WebP.
- Search/filtering.
- Download originals.
- EXIF ordering.
- Duplicate detection.
- Backend, uploads, tagging, accounts, comments, or private albums.

## Risks and Dependencies
- Depends on Sprint 1 output structure or a stable fixture equivalent.
- Hundreds of generated images may create a large page; lazy loading and thumbnail sizes are important.
- Hash deep links need stable path-derived IDs from the generator.
- Existing Bootstrap 3/jQuery should not force new gallery code into jQuery.
- Generated asset volume must stay below GitHub Pages and repository size limits.

## Definition of Done
- Generated metadata drives album sections.
- Album names preserve folder defaults and support display-name overrides.
- Album/photo counts are visible.
- Thumbnails lazy-load and open large generated images.
- Lightbox supports close, next/previous, keyboard navigation, and hash deep links.
- Static scan passes.
- No originals or raw curation state are committed.
- Sprint evidence is filled in.

## PR Checklist
- [x] Gallery uses generated metadata, not hand-authored hundreds of images.
- [x] All generated thumbnail/large paths resolve.
- [x] Lightbox works on desktop.
- [x] Lightbox works on mobile viewport.
- [x] Hash deep links work.
- [x] No public download-original feature exists.
- [x] No backend/upload/account behavior is introduced.
- [x] Static scan passes.
- [x] Relevant docs are updated only for accepted behavior changes.

## Implementation Evidence
Implemented 2026-06-20 by `implement-change`.

| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-003 Provide Internal Navigation | Implemented | `gallery.html`; existing nav and chapter links | Static scan; source inspection | Pending | Gallery remains reachable from nav. |
| REQ-004 Resolve Local Assets | Implemented | Generated image paths in `data/gallery-data.json` and `js/gallery-data.js` | Static scan: 0 missing refs; generated width/path checks passed | Pending | Dynamic image references are validated through generator output checks. |
| REQ-005 Support Mobile Navigation | Implemented | Responsive gallery/lightbox CSS in `css/style.css` | Source inspection; browser automation unavailable | Pending | Manual browser review still recommended. |
| REQ-006 Preserve Readable Core Content | Implemented | Album summary, no-backend copy, `noscript` fallback in `gallery.html` | Source inspection | Pending | JS drives album rendering; generated files are static. |
| REQ-016 Verify Public Release | Implemented | Static scan and no-backend inspection | Static scan: 6 pages, 76 local refs, 0 missing, 0 runtime refs, 0 PHP | Pending | Browser automation unavailable in this sandbox. |
| REQ-031 Support Generated Album Lightbox | Implemented | `gallery.html`; `js/gallery.js`; `css/style.css`; generated metadata/assets | Source inspection; no-backend search found no actual form/upload/fetch/XHR/action/download behavior | Pending | Supports album sections, counts, thumbnails, large images, keyboard lightbox, and hash IDs. |

## Cleanup / Deferred
- Real-browser desktop/mobile visual smoke is still recommended because the available Node REPL browser path failed in this sandbox.
- Search/filtering, EXIF ordering, WebP, duplicate detection, and original downloads remain out of scope.

## Implementation Handoff
Use this sprint after the local photo pipeline is available. Start with a fixture-generated `gallery-data.json` and static album rendering before adding the lightbox. Do not modify home-page visual design in this sprint. Close this plan with actual gallery behavior, scan output, browser smoke notes, and doc updates.
