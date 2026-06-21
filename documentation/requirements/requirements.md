# Requirements

## Ordered Refresh - 2026-06-20

This requirements refresh maps the ordered systems analysis to the canonical current requirement set. It treats older form/PHP/AWS-only claims as historical or conditional unless they are still supported by current code and user direction.

### Source Inputs
- `documentation/requirements/current-state-design.md` ordered systems refresh.
- `documentation/requirements/use-case-requirements.md` ordered behavioral refresh.
- Current repository files and static scan result after removing the temporary Info/contact page: 5 HTML pages, 52 resolved local references, 0 missing references, 0 server-side runtime references, 0 PHP files.
- `documentation/planning/deployment-footprint.md` and `documentation/planning/prd.md`.
- Sprint implementation evidence: `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`, `2026-06-20-generated-gallery-lightbox.md`, `2026-06-20-archive-visual-refresh.md`, `2026-06-20-variant-c-publishable-site-hardening.md`, and `2026-06-20-remove-contact-page-links.md`.

### Requirement Table
| Req ID | Abstract Name | Requirement | Type | Priority | Source | Verification Method | Evidence |
|---|---|---|---|---|---|---|---|
| REQ-001 | Serve Home Entry | The system shall be able to serve a home page as the default public website entry point. | Functional | High | UC-001-CR-001 | Demonstration | `index.html`; GitHub Pages plan |
| REQ-002 | Present Wedding Archive Summary | The system shall be able to present wedding archive summary and story information on public static pages. | Functional | High | UC-001-CR-002 | Inspection | `index.html`, `about.html` |
| REQ-003 | Provide Internal Navigation | The system shall be able to provide navigation links to the public content pages. | Functional | High | UC-001-CR-003, UC-002-CR-001 | Demonstration | Shared nav markup |
| REQ-004 | Resolve Local Assets | The system shall be able to load required local assets using deploy-safe, case-correct paths. | Functional | High | UC-001-CR-004, UC-001-CR-007, UC-004-CR-006 | Test | Static scan passes |
| REQ-005 | Support Mobile Navigation | The system shall be able to expose primary navigation on mobile viewport widths. | Functional | Medium | UC-001-CR-005 | Demonstration | Bootstrap responsive nav |
| REQ-006 | Preserve Readable Core Content | The system shall keep primary textual wedding, travel, and event information readable when nonessential external resources fail to load. | Reliability | Medium | UC-001-CR-006, UC-002-CR-005 | Demonstration | Static internal copy |
| REQ-007 | Present Historical Lodging Context | The system shall be able to present lodging information as historical wedding-weekend context. | Functional/Content | Medium | UC-002-CR-002 | Inspection | `hotels.html` |
| REQ-008 | Present Historical Local Context | The system shall be able to present local entertainment information as historical wedding-weekend context. | Functional/Content | Medium | UC-002-CR-003 | Inspection | `syracuse.html` |
| REQ-009 | Provide Non-Misleading External References | The system shall be able to provide outbound links or plain-text historical references to relevant venue, hotel, and local activity resources when those references are not misleading. | Functional/Interface | Medium | UC-002-CR-004, UC-002-CR-006, UC-002-CR-007 | Inspection | External links exist; archive-polish audit pending |
| REQ-010 | Defer Information Page | The system shall not expose a public information/contact page unless a future sprint deliberately reactivates that page. | Functional/Content | Low | UC-003 removal decision | Inspection | `contact.html` removed |
| REQ-011 | Preserve No Collection Posture | The system shall avoid visitor message, RSVP, address, upload, comment, account, or contact-submission paths in public pages. | Functional/Privacy | High | UC-003 removal decision | Inspection | Source search |
| REQ-012 | Avoid Static PHP Dependency | The system shall not depend on a PHP runtime when deployed as a static website. | Architecture/Deployment | High | UC-003-CR-004 | Analysis/Test | Static scan reports 0 PHP/runtime refs |
| REQ-013 | Avoid Placeholder Contact Destinations | The system shall avoid displaying placeholder contact destinations in visitor-facing states. | Content/Functional | High | UC-003-CR-005 | Inspection | Source search |
| REQ-014 | Deploy From GitHub Pages | The system shall be deployable to GitHub Pages from the GitHub repository. | Deployment | High | UC-004-CR-001, UC-004-CR-002 | Demonstration | Deployment footprint |
| REQ-015 | Provide HTTPS Hosted URL | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Deployment/Interface | High | UC-004-CR-003 | Demonstration | Deployment footprint |
| REQ-016 | Verify Public Release | The deployment process shall provide a verification path for pages, assets, navigation, hosted URL behavior, and domain forwarding. | Verification | High | UC-004-CR-004, UC-004-CR-006, UC-004-CR-007, UC-005-CR-003 | Test/Demonstration | Static scan and planned smoke checks |
| REQ-017 | Support GoDaddy Forwarding | The system shall support access through a GoDaddy-forwarded public URL. | Deployment/Interface | High | UC-004-CR-005, UC-004-CR-007 | Demonstration | Working per user update |
| REQ-018 | Support Static Maintenance | The system shall allow static content and asset updates without requiring a build or backend deployment. | Maintainability | Medium | UC-005-CR-002 | Demonstration | Plain HTML/CSS/JS repo |
| REQ-019 | Update Docs On Behavior Change | The maintenance process shall update durable planning or requirements docs when behavior, deployment, or scope changes. | Maintainability | Medium | UC-005-CR-004 | Inspection | Documentation workspace |
| REQ-020 | Remove Or Archive Dead Legacy Assets | The repository shall remove or explicitly archive unused legacy interaction assets when the related public behavior has been intentionally removed. | Maintainability | Medium | UC-005-CR-005 | Inspection | Public pages no longer load countdown scripts; unused validation/countdown files remain |
| REQ-021 | Support Static Photo Gallery | The system shall be able to present a static wedding photo gallery without backend calls, uploads, or visitor accounts. | Functional | Medium | UC-006-CR-001, UC-006-CR-002, UC-006-CR-003, UC-006-CR-004 | Test/Demonstration | `gallery.html`; static scan passes |
| REQ-022 | Provide Local Photo Review | The system shall be able to provide a local browser workflow for reviewing ignored wedding source photos. | Functional/Maintainability | High | UC-008-CR-001, UC-008-CR-002, UC-008-CR-005 | Demonstration | `tools/photo-pipeline.ps1 serve`; localhost review smoke |
| REQ-023 | Maintain Private Curation State | The system shall be able to record per-photo review states, album display names, album cover choices, and focal points in private curation state. | Functional/Data | High | UC-008-CR-003, UC-008-CR-004 | Test | `.photo-curation/curation.json` ignored; pipeline test |
| REQ-024 | Exclude Private Photo Inputs | The system shall exclude original source photos and private raw curation state from public committed site artifacts. | Privacy/Storage | High | UC-008-CR-007 | Inspection/Test | `.gitignore`; `git status --ignored` |
| REQ-025 | Allow Captionless Inclusion | The system shall not require per-photo captions before a photo can be included in generated public gallery output. | Functional/Content | Medium | UC-008-CR-006 | Inspection | Real curated generation publishes captionless photos |
| REQ-026 | Generate Optimized Photo Assets | The system shall be able to generate optimized JPEG derivatives for thumbnail and large image uses for published photos, and hero image derivatives for explicitly hero-marked photos. | Functional/Performance | High | UC-009-CR-001, UC-009-CR-002 | Test | Generated 480/1800 width-constrained outputs for published photos; 2400px hero outputs only for hero photos |
| REQ-027 | Generate Public Gallery Metadata | The system shall be able to generate public-safe gallery metadata for album, count, focal point, hero, caption, and lightbox rendering. | Functional/Data | High | UC-009-CR-003 | Inspection/Test | `data/gallery-data.json`; `js/gallery-data.js` |
| REQ-028 | Report Gallery Generation Results | The system shall be able to report generation counts and warnings after static gallery asset generation. | Verification/Maintainability | Medium | UC-009-CR-004 | Inspection | `images/gallery/generated/generation-report.json` |
| REQ-029 | Provide Stable Photo IDs | The system shall create stable path-derived photo IDs with collision handling for generated gallery metadata. | Functional/Data | Medium | UC-009-CR-005, UC-010-CR-004 | Test/Demonstration | Pipeline test; generated hash deep-link IDs |
| REQ-030 | Avoid Stale Generated Outputs | The system shall avoid leaving stale generated gallery outputs after regeneration. | Maintainability | Medium | UC-009-CR-006 | Test/Inspection | Generator replaces `images/gallery/generated/` each run |
| REQ-031 | Support Generated Album Lightbox | The system shall be able to present generated album sections, non-excluded thumbnails, album counts, and static lightbox navigation without backend photo-management behavior. | Functional | High | UC-010-CR-001, UC-010-CR-002, UC-010-CR-003, UC-010-CR-005, UC-010-CR-006 | Demonstration/Inspection | `gallery.html`; `js/gallery.js`; no-backend inspection |
| REQ-032 | Support Session-Stable Archive Hero | The system shall be able to present a photo-first archive landing with an explicit session-stable hero, fallback hero behavior, independent hero text, focal-point-aware presentation, and chapter links. | Functional/UX | Medium | UC-011-CR-001, UC-011-CR-002, UC-011-CR-003, UC-011-CR-004, UC-011-CR-005, UC-011-CR-006 | Demonstration/Inspection | `index.html`; `js/archive-home.js`; static scan |

### Candidate Requirement Mapping
| Candidate ID | Source Use Case / Step | Final Req ID | Mapping Status | Notes |
|---|---|---|---|---|
| UC-001-CR-001 | Home page request | REQ-001 | Mapped | Default entry point. |
| UC-001-CR-002 | Home/story content | REQ-002 | Mapped | Wedding archive information. |
| UC-001-CR-003 | Internal navigation | REQ-003 | Merged | Navigation shared across use cases. |
| UC-001-CR-004 | Asset loading | REQ-004 | Merged | Local asset integrity. |
| UC-001-CR-005 | Mobile nav | REQ-005 | Mapped | Responsive navigation. |
| UC-001-CR-006 | CDN degradation | REQ-006 | Mapped | Core copy remains internal. |
| UC-001-CR-007 | Case-correct assets | REQ-004 | Merged | Static scan covers this. |
| UC-002-CR-001 | Travel nav | REQ-003 | Merged | Navigation to travel pages. |
| UC-002-CR-002 | Lodging content | REQ-007 | Mapped | Hotels page as historical context. |
| UC-002-CR-003 | Local entertainment content | REQ-008 | Mapped | Syracuse page as historical context. |
| UC-002-CR-004 | External resources | REQ-009 | Mapped | Outbound links or plain-text historical references. |
| UC-002-CR-005 | External site unavailable | REQ-006 | Merged | Internal content remains useful. |
| UC-002-CR-006 | Replace stale links | REQ-009 | Merged | Non-misleading archive references. |
| UC-002-CR-007 | Known stale destination | REQ-009 | Mapped | Archive sharing guardrail. |
| UC-003-CR-001 | Info page | REQ-010 | Superseded / Deferred | `contact.html` removed for now by sprint decision. |
| UC-003-CR-002 | No collection copy | REQ-011 | Reframed | No collection is now verified by absence of public submission paths. |
| UC-003-CR-003 | Info page nav | REQ-003 | Superseded / Deferred | Info navigation removed for now. |
| UC-003-CR-004 | No PHP runtime | REQ-012 | Mapped | Static architecture. |
| UC-003-CR-005 | No placeholder contact | REQ-013 | Mapped | Visitor-facing cleanup. |
| UC-004-CR-001 | Deployable source | REQ-014 | Merged | GitHub repository source. |
| UC-004-CR-002 | GitHub Pages deployment | REQ-014 | Mapped | Current production host. |
| UC-004-CR-003 | HTTPS hosted URL | REQ-015 | Mapped | Public hosting. |
| UC-004-CR-004 | Post-deployment checks | REQ-016 | Mapped | Release verification. |
| UC-004-CR-005 | GoDaddy access | REQ-017 | Mapped | Forwarded domain. |
| UC-004-CR-006 | Static scan before release | REQ-004, REQ-016 | Merged | Scan is both requirement and verification. |
| UC-004-CR-007 | Forwarding verification | REQ-016, REQ-017 | Merged | Public-domain verification. |
| UC-005-CR-001 | Inspect content/links | REQ-009, REQ-018 | Merged | Maintenance support. |
| UC-005-CR-002 | Static edits | REQ-018 | Mapped | No build/backend needed. |
| UC-005-CR-003 | Maintenance verification | REQ-016 | Mapped | Affected-flow checks. |
| UC-005-CR-004 | Docs update | REQ-019 | Mapped | Keep docs current. |
| UC-005-CR-005 | Legacy assets | REQ-020 | Mapped | Cleanup work. |
| UC-006-CR-001 | Gallery page or section | REQ-021 | Mapped | Implemented static gallery. |
| UC-006-CR-002 | Static gallery images | REQ-021 | Mapped | No backend/uploads/accounts. |
| UC-006-CR-003 | Gallery navigation | REQ-003, REQ-021 | Merged | Shared navigation. |
| UC-006-CR-004 | Gallery asset sizing/paths | REQ-004, REQ-021 | Merged | Static image verification. |
| UC-008-CR-001 | Local browser review | REQ-022 | Mapped | Implemented private review workflow. |
| UC-008-CR-002 | Folder-preserving review | REQ-022 | Merged | Review grouping supports album preservation. |
| UC-008-CR-003 | Review states | REQ-023 | Mapped | Implemented states: unreviewed/include/highlight/hero/exclude. |
| UC-008-CR-004 | Album and focal metadata | REQ-023 | Merged | Private curation state. |
| UC-008-CR-005 | Filters/folder actions | REQ-022 | Merged | Review workflow usability. |
| UC-008-CR-006 | Captionless photos | REQ-025 | Mapped | Captions are optional. |
| UC-008-CR-007 | Originals/private state not public | REQ-024 | Mapped | Public/private boundary. |
| UC-009-CR-001 | Generate public outputs | REQ-026, REQ-027 | Merged | Output generation includes assets and metadata. |
| UC-009-CR-002 | Optimized JPEG derivatives | REQ-026 | Mapped | Thumbnail/large derivative generation for published photos; hero derivative generation for explicit hero photos. |
| UC-009-CR-003 | Public metadata | REQ-027 | Mapped | Public-safe gallery data. |
| UC-009-CR-004 | Generation report | REQ-028 | Mapped | Counts and warnings. |
| UC-009-CR-005 | Stable collision-safe IDs | REQ-029 | Mapped | Deep-link support depends on stable IDs. |
| UC-009-CR-006 | No stale outputs | REQ-030 | Mapped | Regeneration cleanup rule. |
| UC-010-CR-001 | Generated album sections | REQ-031 | Mapped | Album rendering. |
| UC-010-CR-002 | Non-excluded thumbnails/counts | REQ-031 | Merged | Album/gallery rendering. |
| UC-010-CR-003 | Lightbox navigation | REQ-031 | Mapped | Visitor gallery behavior. |
| UC-010-CR-004 | Photo hash links | REQ-029 | Mapped | Stable photo IDs enable deep links. |
| UC-010-CR-005 | Browseable without lightbox JS | REQ-031 | Merged | Graceful degradation. |
| UC-010-CR-006 | No public originals/uploads/accounts | REQ-021, REQ-024, REQ-031 | Merged | Keeps no-backend/no-private-original boundary. |
| UC-011-CR-001 | Photo-first landing | REQ-032 | Mapped | Visual refresh. |
| UC-011-CR-002 | Session-stable hero | REQ-032 | Merged | Hero behavior. |
| UC-011-CR-003 | Hero text independent of captions | REQ-032 | Merged | Caption independence. |
| UC-011-CR-004 | Chapter links | REQ-003, REQ-032 | Merged | Archive navigation. |
| UC-011-CR-005 | Fallback hero | REQ-032 | Merged | Missing metadata fallback. |
| UC-011-CR-006 | Focal point/readability | REQ-032 | Merged | Readable photo presentation. |

### Requirement Status
| Req ID | Lifecycle Status | Status Rationale | Superseded By | Notes |
|---|---|---|---|---|
| REQ-001 | Active | Core public entry. |  |  |
| REQ-002 | Active | Core public content. |  |  |
| REQ-003 | Active | Needed for all visitor flows. |  |  |
| REQ-004 | Implemented | Static scan currently passes. |  | Keep as release gate. |
| REQ-005 | Active | Bootstrap mobile nav remains part of public UX. |  | Needs smoke checks after JS cleanup. |
| REQ-006 | Active | Core content should not depend on third-party sites/CDNs. |  |  |
| REQ-007 | Active / Partial | Page exists; historical-context polish pending. |  |  |
| REQ-008 | Active / Partial | Page exists; historical-context polish pending. |  |  |
| REQ-009 | Active / Partial | External references exist; archive-polish audit pending. |  |  |
| REQ-010 | Deferred | Public Info/contact page removed for now. | Future Weekend/Details/Info page decision | `contact.html` removed and public links removed. |
| REQ-011 | Implemented | No visitor submission or collection path exists in active public pages. |  | Verified by source search rather than a standalone Info page. |
| REQ-012 | Implemented | No PHP/runtime refs in scan. |  |  |
| REQ-013 | Implemented | No known placeholder contact destination in active public files. |  |  |
| REQ-014 | Active | GitHub Pages is current host. |  |  |
| REQ-015 | Active | HTTPS hosted URL is required. |  |  |
| REQ-016 | Active / Partial | Scan passes; external-link and forwarding checks remain. |  |  |
| REQ-017 | Implemented | GoDaddy redirect is working per user update. |  | Record exact domain/target. |
| REQ-018 | Active | Static maintenance model. |  |  |
| REQ-019 | Active | Needed because docs previously drifted. |  |  |
| REQ-020 | Active / Partial | Public pages no longer load obsolete countdown scripts and countdown CSS/commented markup was removed; unused legacy files still need deletion or explicit archive. |  | Remaining files: `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, `css/jquery.countdown.js`, ReactiveRaven vendor files |
| REQ-021 | Implemented | `gallery.html` presents selected static photos, is linked from navigation, and passes static scan with no backend/upload/account behavior. |  | Planned generated-gallery work is covered by REQ-022 through REQ-032. |
| REQ-022 | Implemented | Local review app serves over localhost and exposes a photo grid/API for source folders. |  | Implemented in PowerShell/.NET because Python/Pillow is unavailable in this environment. |
| REQ-023 | Implemented | Private curation JSON stores review state, titles/captions, and focal points. |  | Album cover/display metadata supported by schema/generator. |
| REQ-024 | Implemented | Original source folder and private curation state are ignored. |  | `.photo-curation/` exists locally and is ignored. |
| REQ-025 | Implemented | Real curated generation publishes captionless photos. |  | Captions can be added later during review. |
| REQ-026 | Implemented | Generator creates thumb and large JPEG derivatives for published photos, and 2400px hero derivatives only for hero-marked photos. |  | Pipeline tests passed; generated real gallery is about 107 MB. |
| REQ-027 | Implemented | Generated JSON and JS metadata drive public gallery and hero behavior. |  | Real curated metadata generated from the local source photo set. |
| REQ-028 | Implemented | Generation report is produced with counts and warnings. |  | Real generation report: 185 published, 601 excluded, 12 hero photos. |
| REQ-029 | Implemented | Path-derived IDs and collision handling are implemented. |  | Duplicate `champ` names were disambiguated. |
| REQ-030 | Implemented | Generated output directory is replaced each generation. |  | Prevents stale generated files. |
| REQ-031 | Implemented | Gallery renders generated album sections and static lightbox behavior. |  | Browser automation unavailable; static and source checks passed. |
| REQ-032 | Implemented | Home page uses generated hero metadata with session-stable selection and fallback. |  | Browser automation unavailable; static/source checks passed. |

### Requirement Constants
| Constant | Meaning | Current Value | Source / How To Determine |
|---|---|---|---|
| PUBLIC_HOSTING_MODE | Current deployment shape. | Static GitHub Pages | Deployment footprint |
| PRODUCTION_BRANCH | Branch served by production host. | `main` | Deployment docs |
| WORK_BRANCH | Branch for changes before publication. | `development` | Existing workflow docs |
| PUBLIC_HOSTING_URL | Hosted public URL. | `https://skeller01.github.io/wedding-website/` | Deployment docs |
| PUBLIC_FORWARDING_PROVIDER | Domain forwarding provider. | GoDaddy | User direction/docs |
| PUBLIC_FORWARDING_DOMAIN | Final user-facing domain. | TBD | Must be recorded from working redirect setup |
| CONTACT_COLLECTION_ENABLED | Whether site collects visitor messages, RSVPs, or addresses. | `false` | Current product decision and source scan |
| PRODUCT_FRAMING | Current product identity. | Shareable wedding archive / memory site | User update |
| STATIC_GALLERY_ENABLED | Whether a static photo gallery exists. | `true`; initial `gallery.html` implemented | User update plus prototype absorption |
| SOURCE_PHOTO_PUBLICATION_ALLOWED | Whether original source photos may be committed as public site artifacts. | `false` | User decision to `.gitignore` originals |
| PHOTO_REVIEW_STATES | Supported local review states. | `unreviewed`, `include`, `highlight`, `hero`, `exclude` | Grilling decisions |
| GENERATED_THUMB_WIDTH | Target max width for generated thumbnails. | `480px` | Sprint research |
| GENERATED_LARGE_WIDTH | Target max width for generated large images. | `1800px` | Sprint research |
| GENERATED_HERO_WIDTH | Target max width for generated hero images. | `2400px`, generated only for photos marked `hero` | Sprint research and 2026-06-21 curation optimization |
| HERO_SELECTION_MODE | Current archive hero behavior. | Session-stable random selection from explicit hero photos with fallback | Grilling decisions and implementation evidence |
| STATIC_SCAN_TARGET | Minimum scan result before release. | 0 missing local refs, 0 server-runtime refs, 0 PHP files | Prototype/static scan |

### Quality Check
| Req ID | Correct | Clear / Precise | Unambiguous | Objective | Verifiable | Consistent | Issue / Fix |
|---|---|---|---|---|---|---|---|
| REQ-001-REQ-006 | Yes | Yes | Yes | Yes | Yes | Yes | Group checked; no issue. |
| REQ-007-REQ-009 | Yes | Yes | Yes | Yes | Yes | Yes | External references still need archive-polish audit evidence. |
| REQ-010-REQ-013 | Yes | Yes | Yes | Yes | Yes | Yes | Info page is deferred; no-collection scope remains consistent through absence of submission paths. |
| REQ-014-REQ-017 | Yes | Yes | Yes | Yes | Yes | Yes | Exact GoDaddy domain/target should be recorded. |
| REQ-018-REQ-021 | Yes | Yes | Yes | Yes | Yes | Yes | REQ-020 remains partial cleanup; REQ-021 is implemented as an initial static gallery. |
| REQ-022-REQ-032 | Yes | Yes | Yes | Yes | Yes | Yes | Implemented and traceable to sprint research; visual behavior still deserves real-browser review after a browser runner is available. |

### Traceability
| Req ID | Source Use Case / Step | Related Candidate ID(s) | Related Interface | Related State | Related Test |
|---|---|---|---|---|---|
| REQ-001 | UC-001 Step 1 | UC-001-CR-001 | IF-001 | Page Loaded | TEST-002 |
| REQ-002 | UC-001 Step 2 | UC-001-CR-002 | IF-001 | Page Loaded | TEST-002 |
| REQ-003 | UC-001/002/003 navigation | UC-001-CR-003, UC-002-CR-001, UC-003-CR-003 | IF-001 | Page Loaded | TEST-003 |
| REQ-004 | UC-001 assets, UC-004 scan | UC-001-CR-004, UC-001-CR-007, UC-004-CR-006 | IF-002 | Page Loaded | TEST-001 |
| REQ-005 | UC-001 mobile | UC-001-CR-005 | IF-003 | Page Loaded | TEST-003 |
| REQ-006 | UC-001/002 degraded resources | UC-001-CR-006, UC-002-CR-005 | IF-003, IF-004 | Travel Page Loaded | TEST-002 |
| REQ-007 | UC-002 Step 2 | UC-002-CR-002 | IF-001 | Travel Page Loaded | TEST-002 |
| REQ-008 | UC-002 Step 3 | UC-002-CR-003 | IF-001 | Travel Page Loaded | TEST-002 |
| REQ-009 | UC-002 Step 4/A2/E1 | UC-002-CR-004, CR-006, CR-007 | IF-004 | External Navigation Started | TEST-005 |
| REQ-010 | UC-003 removal decision | UC-003-CR-001 | IF-001 | Public Page Removed | TEST-004 |
| REQ-011 | UC-003 removal decision | UC-003-CR-002 | IF-001 | No Collection Path Present | TEST-004 |
| REQ-012 | UC-003 E1 | UC-003-CR-004 | retired server interface | No Runtime Present | TEST-001 |
| REQ-013 | UC-003 E2 | UC-003-CR-005 | IF-001 | No Contact Destination Present | TEST-004 |
| REQ-014 | UC-004 Steps 1-2 | UC-004-CR-001, CR-002 | IF-006 | Public Hosted | TEST-006 |
| REQ-015 | UC-004 Step 3 | UC-004-CR-003 | IF-001 | Public Hosted | TEST-006 |
| REQ-016 | UC-004/005 verification | UC-004-CR-004, CR-006, CR-007, UC-005-CR-003 | IF-001-IF-006 | Public Hosted/Forwarding Working | TEST-001-TEST-007 |
| REQ-017 | UC-004 Step 5/E2 | UC-004-CR-005, CR-007 | IF-005 | Forwarding Working | TEST-007 |
| REQ-018 | UC-005 Step 2 | UC-005-CR-002 | IF-006 | Maintenance Ready | TEST-008 |
| REQ-019 | UC-005 Step 4 | UC-005-CR-004 | docs | Maintenance Ready | Inspection |
| REQ-020 | UC-005 E1 | UC-005-CR-005 | source files | Maintenance Ready | TEST-008 |
| REQ-021 | UC-006 | UC-006-CR-001, CR-002, CR-003, CR-004 | IF-007 | Gallery Viewed | TEST-009 |
| REQ-022 | UC-008 Steps 1-2/5 | UC-008-CR-001, CR-002, CR-005 | IF-008 | Photo Review State Saved | TEST-010 |
| REQ-023 | UC-008 Steps 3-4 | UC-008-CR-003, CR-004 | IF-008 | Photo Review State Saved | TEST-010 |
| REQ-024 | UC-008 E1 / UC-010 E2 | UC-008-CR-007, UC-010-CR-006 | IF-008/IF-009 | Photo Review State Saved | TEST-010 |
| REQ-025 | UC-008 A1 | UC-008-CR-006 | IF-009 | Gallery Assets Generated | TEST-011 |
| REQ-026 | UC-009 Steps 1-2 | UC-009-CR-001, CR-002 | IF-009 | Gallery Assets Generated | TEST-011 |
| REQ-027 | UC-009 Step 3 | UC-009-CR-003 | IF-009/IF-010 | Gallery Assets Generated | TEST-011 |
| REQ-028 | UC-009 Step 4 | UC-009-CR-004 | IF-009 | Gallery Assets Generated | TEST-011 |
| REQ-029 | UC-009 E1 / UC-010 Step 4 | UC-009-CR-005, UC-010-CR-004 | IF-010 | Lightbox Open | TEST-012 |
| REQ-030 | UC-009 E2 | UC-009-CR-006 | IF-009 | Gallery Assets Generated | TEST-011 |
| REQ-031 | UC-010 | UC-010-CR-001, CR-002, CR-003, CR-005, CR-006 | IF-010 | Lightbox Open | TEST-012 |
| REQ-032 | UC-011 | UC-011-CR-001, CR-002, CR-003, CR-004, CR-005, CR-006 | IF-010 | Hero Selected | TEST-013 |

### Assumptions
- GitHub Pages remains the production host unless the user deliberately chooses AWS later.
- GoDaddy forwarding is working and targets the hosted site.
- Visitor-submitted data collection remains disabled.
- Stale external links should be fixed, removed, or converted to historical plain text before broad archive sharing.
- Gallery remains static; photo scaling uses local/private generation plus committed public web assets, not a backend.
- Hero rotation uses only explicitly hero-marked photos and should remain stable within a browser session.

### Gaps and Questions
- Exact GoDaddy domain and target URL.
- Which external links should be replaced, removed, or converted to historical plain text.
- Whether to delete or archive remaining unused countdown/validation assets now.
- Whether a future warm Weekend/Details page should be added as a new scoped sprint.
- Owner review of the auto-curated 185-photo selection, optional captions, and optional album-section refinements remain curation tasks.

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](../planning/archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Requirements; use the archive only for historical context.
