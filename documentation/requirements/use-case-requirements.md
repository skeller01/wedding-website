# Use Case Requirements Analysis

## Ordered Refresh - 2026-06-20

This refresh follows the updated context and use case model in `documentation/requirements/current-state-design.md`. It treats the site as a static GitHub Pages wedding archive / memory site with no active RSVP, address, message, email form, PHP endpoint, upload flow, or database behavior.

### Source Inputs
- `documentation/requirements/current-state-design.md` ordered systems refresh.
- Root pages: `index.html`, `about.html`, `gallery.html`, `hotels.html`, `syracuse.html`.
- Static assets and scripts: `css/style.css`, Bootstrap/jQuery CDN behavior for navigation/tooltips, unused legacy validation/countdown files, `images/*`.
- Static scan after removing the temporary Info/contact page: 5 HTML pages, 52 resolved local references, 0 missing references, 0 server-side runtime references, 0 PHP files.
- Planning docs: `documentation/planning/deployment-footprint.md`, `documentation/planning/prd.md`, sprint and working notes.
- Planned sprint research: `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md`, `2026-06-20-generated-gallery-lightbox.md`, and `2026-06-20-archive-visual-refresh.md`.

### Use Case Index
| Use Case ID | Use Case Name | Priority | Status | Source |
|---|---|---|---|---|
| UC-001 | View Wedding Archive | High | Refreshed | Static pages and context model |
| UC-002 | Browse Historical Travel and Local Context | High | Refreshed | Hotels/Syracuse pages and external links |
| UC-003 | Read Information Page | Low | Deferred | `contact.html` removed for now; no public Info route |
| UC-004 | Publish Static Website | High | Refreshed | GitHub Pages/static publication workflow |
| UC-005 | Maintain Archive Content | Medium | Refreshed | Refactor/deployment/requirements follow-up |
| UC-006 | View Static Photo Gallery | Medium | Implemented | Initial simple static gallery |
| UC-008 | Curate Source Photos Locally | High | Implemented | Local photo curation tool; real source photos pending |
| UC-009 | Generate Static Gallery Assets | High | Implemented | Generated placeholder public assets/data from existing images |
| UC-010 | Browse Generated Album Gallery | High | Implemented | Generated gallery/lightbox sprint |
| UC-011 | View Session-Stable Archive Hero | Medium | Implemented | Archive visual refresh sprint |

### UC-001: View Wedding Archive

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-001 |
| Use Case Name | View Wedding Archive |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens the hosted site or forwarded public URL. |
| Goal | Visitor can read the home/story/event memory content and navigate to supporting pages. |
| Priority | High |
| Preconditions | Static site is hosted and reachable. |
| Postconditions | Visitor has viewed wedding archive content or selected another page. |
| Evidence | Observed |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Static host | Browser | Visitor requests `/` or `index.html`. | HTTPS page request | UC-001-CR-001 | The system shall be able to serve a home page as the default public website entry point. | Observed |
| 2 | Visitor | Home page | Browser | System renders names, wedding weekend framing, dates, locations, and CTA. | HTML/CSS/images | UC-001-CR-002 | The system shall be able to present wedding archive summary information on the home page. | Observed |
| 3 | Visitor | Site navigation | Browser | Visitor selects Home, Story, Gallery, Hotels, or Local Entertainment. | Internal link/menu click | UC-001-CR-003 | The system shall be able to provide navigation links to the public content pages. | Observed |
| 4 | Browser | Asset layer | GitHub Pages/CDNs | Browser loads CSS, JavaScript, fonts, and images. | Asset requests | UC-001-CR-004 | The system shall be able to load required local assets using deploy-safe paths. | Observed/Tested |

#### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-001-A1 | Visitor uses a mobile viewport | Visitor opens collapsed navigation. | Menu exposes primary navigation links. | UC-001-CR-005 | The system shall be able to expose primary navigation on mobile viewport widths. | Observed/Inferred |
| UC-001-A2 | CDN font/library is unavailable | Browser renders without that resource. | Core text remains available. | UC-001-CR-006 | The system shall keep primary textual wedding content readable when nonessential external resources fail to load. | Inferred |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-001-E1 | A local asset path is missing or case-mismatched | Static scan fails or hosted asset breaks. | Correct path before publication. | UC-001-CR-007 | The system shall use case-correct local asset references for static hosting. | Tested |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-001-CR-001 | The system shall be able to serve a home page as the default public website entry point. | Step 1 | Demonstration |
| UC-001-CR-002 | The system shall be able to present wedding archive summary information on the home page. | Step 2 | Inspection |
| UC-001-CR-003 | The system shall be able to provide navigation links to the public content pages. | Step 3 | Demonstration |
| UC-001-CR-004 | The system shall be able to load required local assets using deploy-safe paths. | Step 4 | Test |
| UC-001-CR-005 | The system shall be able to expose primary navigation on mobile viewport widths. | Alternate A1 | Demonstration |
| UC-001-CR-006 | The system shall keep primary textual wedding content readable when nonessential external resources fail to load. | Alternate A2 | Demonstration |
| UC-001-CR-007 | The system shall use case-correct local asset references for static hosting. | Exception E1 | Test |

### UC-002: Browse Historical Travel and Local Context

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-002 |
| Use Case Name | Browse Historical Travel and Local Context |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor selects Travel, Hotels, or Local Entertainment. |
| Goal | Visitor can read lodging/Syracuse historical context and optionally open useful current or archival external resources. |
| Priority | High |
| Preconditions | Static pages and local assets are available. |
| Postconditions | Visitor has viewed internal historical travel/local content or intentionally left via an external link. |
| Evidence | Observed with external freshness risk |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Navigation | Browser | Visitor opens the Travel dropdown. | Bootstrap dropdown | UC-002-CR-001 | The system shall be able to expose hotel and local entertainment links from navigation. | Observed |
| 2 | Visitor | Hotels page | Browser | System renders hotel names, descriptions, distances, and historical cost/location context. | `hotels.html` | UC-002-CR-002 | The system shall be able to present lodging information as historical wedding-weekend context. | Observed |
| 3 | Visitor | Syracuse page | Browser | System renders local activity thumbnails and historical guidance. | `syracuse.html` | UC-002-CR-003 | The system shall be able to present local entertainment information as historical wedding-weekend context. | Observed |
| 4 | Visitor | External link | Third-party site | Visitor opens a venue, hotel, or activity link when it is current enough not to mislead. | Outbound URL | UC-002-CR-004 | The system shall be able to provide outbound links or plain-text historical references to relevant venue, hotel, and local activity resources. | Observed |

#### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-A1 | External site is stale or unavailable | Visitor still reads internal content. | Core historical travel/event context remains usable. | UC-002-CR-005 | The system shall keep core travel and event context available without requiring third-party links to load. | Inferred |
| UC-002-A2 | Specific business is closed/rebranded | Maintainer replaces, removes, or converts it to plain historical text. | Page remains useful and non-misleading. | UC-002-CR-006 | The system shall allow stale business-specific links to be replaced with current official resources, removed, or converted to plain historical references. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-E1 | Known stale external link remains before broad archive sharing | Visitor may reach misleading or dead page. | Audit, replace, remove, or convert the link. | UC-002-CR-007 | The system shall not knowingly present stale, closed, or rebranded external lodging/activity destinations as current recommendations when the page is intended as an archive. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-002-CR-001 | The system shall be able to expose hotel and local entertainment links from navigation. | Step 1 | Demonstration |
| UC-002-CR-002 | The system shall be able to present lodging information as historical wedding-weekend context. | Step 2 | Inspection |
| UC-002-CR-003 | The system shall be able to present local entertainment information as historical wedding-weekend context. | Step 3 | Inspection |
| UC-002-CR-004 | The system shall be able to provide outbound links or plain-text historical references to relevant venue, hotel, and local activity resources. | Step 4 | Inspection |
| UC-002-CR-005 | The system shall keep core travel and event context available without requiring third-party links to load. | Alternate A1 | Demonstration |
| UC-002-CR-006 | The system shall allow stale business-specific links to be replaced with current official resources, removed, or converted to plain historical references. | Alternate A2 | Inspection |
| UC-002-CR-007 | The system shall not knowingly present stale, closed, or rebranded external lodging/activity destinations as current recommendations when the page is intended as an archive. | Exception E1 | Inspection |

### UC-003: Read Information Page

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-003 |
| Use Case Name | Read Information Page |
| Primary Actor | Visitor / Guest |
| Trigger | Deferred; no public trigger exists while `contact.html` is removed. |
| Goal | Preserve the no-collection product decision without exposing a low-value standalone Info page. |
| Priority | Low |
| Preconditions | Static site is reachable. |
| Postconditions | Visitor does not encounter an Info/contact page or a misleading submission path. |
| Evidence | Removed by sprint decision |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Navigation | Browser | Visitor sees no Info/contact navigation item. | Internal navigation | UC-003-CR-001 | The system shall not expose a public information/contact page unless reactivated by a future sprint. | Observed/Tested |
| 2 | Visitor | Public pages | Browser | System provides no RSVP, address, message, upload, account, comment, or contact-submission path. | Static pages/source | UC-003-CR-002 | The system shall preserve the no-collection posture by omitting visitor submission paths. | Observed/Tested |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-003-E1 | PHP/form behavior is reintroduced accidentally | Static scan/source search should flag runtime dependency. | Remove it or treat it as a new approved feature. | UC-003-CR-004 | The system shall not depend on a PHP runtime when deployed as a static website. | Observed/Tested |
| UC-003-E2 | Placeholder contact destination appears | Release inspection should fail. | Remove placeholder destination. | UC-003-CR-005 | The system shall avoid displaying placeholder contact destinations in visitor-facing states. | Observed/Tested |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-003-CR-001 | The system shall not expose a public information/contact page unless reactivated by a future sprint. | Step 1 | Inspection |
| UC-003-CR-002 | The system shall preserve the no-collection posture by omitting visitor submission paths. | Step 2 | Inspection |
| UC-003-CR-003 | The system shall preserve coherent internal navigation after removing the information page. | Step 1 | Demonstration |
| UC-003-CR-004 | The system shall not depend on a PHP runtime when deployed as a static website. | Exception E1 | Analysis/Test |
| UC-003-CR-005 | The system shall avoid displaying placeholder contact destinations in visitor-facing states. | Exception E2 | Inspection |

### UC-004: Publish Static Website

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-004 |
| Use Case Name | Publish Static Website |
| Primary Actor | Site Maintainer |
| Trigger | Maintainer wants current content publicly reachable. |
| Goal | Verified static archive content is served over HTTPS and public-domain forwarding remains working. |
| Priority | High |
| Preconditions | GitHub repository and GitHub Pages configuration exist. |
| Postconditions | Hosted URL works; forwarding is verified as working. |
| Evidence | Observed; GoDaddy redirect reported working by user on 2026-06-20 |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Maintainer | Repository | GitHub | Maintainer keeps deployable files in source control. | Git commit | UC-004-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Observed |
| 2 | Maintainer | Repository | GitHub Pages | Maintainer publishes production branch. | GitHub Pages source | UC-004-CR-002 | The system shall be deployable to GitHub Pages from the GitHub repository. | Observed |
| 3 | GitHub Pages | Static host | Browser | Host serves HTTPS site. | HTTPS request | UC-004-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Observed |
| 4 | Maintainer | Verification | Browser/static scan | Maintainer checks pages, assets, navigation, and removed-info behavior. | Acceptance check | UC-004-CR-004 | The deployment process shall provide a post-deployment verification path for pages, assets, navigation, and removed-route behavior. | Observed |
| 5 | Maintainer | Domain forwarding | GoDaddy/GitHub Pages | Maintainer records working forwarded domain behavior. | Forwarded request | UC-004-CR-005 | The system shall support access through a GoDaddy-forwarded public URL. | Observed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-004-E1 | Static scan fails | Publication should pause. | Fix references/runtime issue. | UC-004-CR-006 | The deployment process shall identify missing local asset or server-runtime references before public release. | Tested |
| UC-004-E2 | Forwarded domain regresses after future changes | Forwarding becomes a release issue. | Re-check target and public URL after publication changes. | UC-004-CR-007 | The deployment process shall verify the GoDaddy-forwarded URL after configuration or target changes. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-004-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Step 1 | Inspection |
| UC-004-CR-002 | The system shall be deployable to GitHub Pages from the GitHub repository. | Step 2 | Demonstration |
| UC-004-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Step 3 | Demonstration |
| UC-004-CR-004 | The deployment process shall provide a post-deployment verification path for pages, assets, navigation, and information-page behavior. | Step 4 | Test/Demonstration |
| UC-004-CR-005 | The system shall support access through a GoDaddy-forwarded public URL. | Step 5 | Demonstration |
| UC-004-CR-006 | The deployment process shall identify missing local asset or server-runtime references before public release. | Exception E1 | Test |
| UC-004-CR-007 | The deployment process shall verify the GoDaddy-forwarded URL after configuration or target changes. | Exception E2 | Demonstration |

### UC-005: Maintain Archive Content

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-005 |
| Use Case Name | Maintain Archive Content |
| Primary Actor | Site Maintainer |
| Trigger | Content, links, gallery assets, or docs need correction. |
| Goal | Site files and docs remain aligned with current static wedding-archive/no-collection product intent. |
| Priority | Medium |
| Preconditions | Maintainer has repository access. |
| Postconditions | Updated source passes static/reference checks and docs reflect the change. |
| Evidence | Inferred from repo/docs |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Maintainer | Repository | Git | Maintainer identifies a stale link, obsolete asset, gallery need, or content mismatch. | Source review | UC-005-CR-001 | The system shall support inspection of visitor-facing archive content and external links during maintenance. | Inferred |
| 2 | Maintainer | Static files | Browser | Maintainer edits affected HTML/CSS/JS/assets. | File change | UC-005-CR-002 | The system shall allow static content and asset updates without requiring a build or backend deployment. | Observed |
| 3 | Maintainer | Verification | Static scan/browser | Maintainer verifies local references and visible behavior. | Static scan/smoke test | UC-005-CR-003 | The maintenance process shall verify static references and affected visitor flows after content changes. | Proposed |
| 4 | Maintainer | Documentation | Docs | Maintainer updates durable docs if product behavior or requirements changed. | Doc edit | UC-005-CR-004 | The maintenance process shall update durable planning or requirements docs when behavior, deployment, or scope changes. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-005-E1 | Dead legacy assets remain after behavior removal | Future maintenance may misinterpret inactive scripts. | Remove or explicitly archive unused files. | UC-005-CR-005 | The repository shall remove or explicitly archive unused legacy interaction assets when the related public behavior has been intentionally removed. | Inferred |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-005-CR-001 | The system shall support inspection of visitor-facing archive content and external links during maintenance. | Step 1 | Inspection |
| UC-005-CR-002 | The system shall allow static content and asset updates without requiring a build or backend deployment. | Step 2 | Demonstration |
| UC-005-CR-003 | The maintenance process shall verify static references and affected visitor flows after content changes. | Step 3 | Test |
| UC-005-CR-004 | The maintenance process shall update durable planning or requirements docs when behavior, deployment, or scope changes. | Step 4 | Inspection |
| UC-005-CR-005 | The repository shall remove or explicitly archive unused legacy interaction assets when the related public behavior has been intentionally removed. | Exception E1 | Inspection |

### UC-006: View Static Photo Gallery

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-006 |
| Use Case Name | View Static Photo Gallery |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens `gallery.html`. |
| Goal | Visitor can browse selected wedding photos without accounts, uploads, or backend services. |
| Priority | Medium |
| Preconditions | Gallery page and selected static photo assets exist. |
| Postconditions | Visitor has viewed selected photos and can navigate back to other archive pages. |
| Evidence | Observed in `gallery.html`; static scan passes |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Gallery page | Browser | Visitor opens the gallery. | Page request | UC-006-CR-001 | The system shall be able to present a static wedding photo gallery page or section. | Observed |
| 2 | Visitor | Gallery assets | Browser | System renders selected wedding photos from static assets. | Image requests | UC-006-CR-002 | The system shall be able to render selected gallery photos without backend calls, uploads, or visitor accounts. | Observed/Tested |
| 3 | Visitor | Navigation | Browser | Visitor returns to home/story/info pages. | Internal links/nav | UC-006-CR-003 | The system shall preserve internal navigation from the static gallery. | Observed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-006-E1 | Gallery image path is missing or file is too large | Static scan or browser smoke fails/degrades. | Correct path and resize/optimize image before publication. | UC-006-CR-004 | The system shall use deploy-safe gallery image references and image sizes suitable for static hosting. | Tested by static scan |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-006-CR-001 | The system shall be able to present a static wedding photo gallery page or section. | Step 1 | Demonstration |
| UC-006-CR-002 | The system shall be able to render selected gallery photos without backend calls, uploads, or visitor accounts. | Step 2 | Test/Demonstration |
| UC-006-CR-003 | The system shall preserve internal navigation from the static gallery. | Step 3 | Demonstration |
| UC-006-CR-004 | The system shall use deploy-safe gallery image references and image sizes suitable for static hosting. | Exception E1 | Test |

### UC-008: Curate Source Photos Locally

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-008 |
| Use Case Name | Curate Source Photos Locally |
| Primary Actor | Photo Curator |
| Trigger | Original wedding photos are available in an ignored local source folder. |
| Goal | Curator can review hundreds of local source photos and record inclusion, exclusion, hero, album, and focal-point decisions without publishing originals. |
| Priority | High |
| Preconditions | Source photos exist locally; originals are excluded from committed public site artifacts. |
| Postconditions | Private curation state is ready for static gallery asset generation. |
| Evidence | Implemented in `tools/photo-pipeline.ps1`; real source photos pending |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Photo Curator | Local review app | Local filesystem | Curator opens a local browser review app pointed at ignored source photos. | Local app session | UC-008-CR-001 | The system shall be able to provide a local browser review workflow for ignored source photos. | Proposed |
| 2 | Photo Curator | Review grid | Local filesystem | System presents photos in folder-preserving grid/contact-sheet views. | Photo metadata/read requests | UC-008-CR-002 | The system shall be able to present source photos grouped by their folder structure during local review. | Proposed |
| 3 | Photo Curator | Curation state | Local JSON | Curator marks photos as `unreviewed`, `include`, `highlight`, `hero`, or `exclude`. | State update | UC-008-CR-003 | The system shall be able to record per-photo review states of unreviewed, include, highlight, hero, and exclude. | Proposed |
| 4 | Photo Curator | Curation state | Local JSON | Curator records album display names, album cover choices, and focal points when desired. | State update | UC-008-CR-004 | The system shall be able to record album display names, album cover choices, and photo focal points during local review. | Proposed |
| 5 | Photo Curator | Review app | Local JSON | Curator filters included/excluded photos and applies folder-level actions when useful. | Review command | UC-008-CR-005 | The system shall be able to filter review states and apply folder-level review actions in the local photo review workflow. | Proposed |

#### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-008-A1 | Curator does not provide captions | Continue review without captions. | Public gallery generation can fall back to filenames, album names, or no caption. | UC-008-CR-006 | The system shall not require per-photo captions before a photo can be included in generated public gallery output. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-008-E1 | Source originals or raw curation state are accidentally staged for public commit | Release/review process flags the issue. | Keep originals and raw review data ignored or private. | UC-008-CR-007 | The system shall exclude original source photos and private raw curation state from public committed site artifacts. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-008-CR-001 | The system shall be able to provide a local browser review workflow for ignored source photos. | Step 1 | Demonstration |
| UC-008-CR-002 | The system shall be able to present source photos grouped by their folder structure during local review. | Step 2 | Demonstration |
| UC-008-CR-003 | The system shall be able to record per-photo review states of unreviewed, include, highlight, hero, and exclude. | Step 3 | Test |
| UC-008-CR-004 | The system shall be able to record album display names, album cover choices, and photo focal points during local review. | Step 4 | Test |
| UC-008-CR-005 | The system shall be able to filter review states and apply folder-level review actions in the local photo review workflow. | Step 5 | Demonstration |
| UC-008-CR-006 | The system shall not require per-photo captions before a photo can be included in generated public gallery output. | Alternate A1 | Inspection |
| UC-008-CR-007 | The system shall exclude original source photos and private raw curation state from public committed site artifacts. | Exception E1 | Inspection/Test |

### UC-009: Generate Static Gallery Assets

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-009 |
| Use Case Name | Generate Static Gallery Assets |
| Primary Actor | Site Maintainer |
| Trigger | Curation state exists and public gallery assets need to be refreshed. |
| Goal | Maintainer can generate optimized public JPEG assets, public-safe metadata, and a report from local source photos. |
| Priority | High |
| Preconditions | Source photos and curation state exist locally. |
| Postconditions | Generated public assets and metadata are ready for static scan, review, and commit. |
| Evidence | Implemented by `tools/photo-pipeline.ps1 generate`; placeholder outputs generated from existing images |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Site Maintainer | Generator | Local filesystem | Maintainer runs the local generator against source photos and curation state. | Command invocation | UC-009-CR-001 | The system shall be able to generate public gallery outputs from local source photos and private curation state. | Proposed |
| 2 | Site Maintainer | Generator | Local filesystem | System creates optimized JPEG derivatives for thumbnail, large, and hero use. | Generated files | UC-009-CR-002 | The system shall be able to generate optimized JPEG derivatives for thumbnail, large, and hero image uses. | Proposed |
| 3 | Site Maintainer | Generator | Public metadata | System writes public gallery metadata containing albums, image paths, IDs, counts, focal points, hero eligibility, and captions when available. | `gallery-data.json` | UC-009-CR-003 | The system shall be able to generate public-safe gallery metadata for album and lightbox rendering. | Proposed |
| 4 | Site Maintainer | Generator | Report | System reports source, included, excluded, hero, warning, and output counts. | Generation report | UC-009-CR-004 | The system shall be able to report generation counts and warnings after static gallery asset generation. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-009-E1 | Duplicate or unsafe generated photo IDs would collide | Generator reports or resolves deterministic collision-safe IDs. | Fix input or accept deterministic disambiguation. | UC-009-CR-005 | The system shall create stable path-derived photo IDs with collision handling for generated gallery metadata. | Proposed |
| UC-009-E2 | Regeneration leaves stale public outputs | Generator replaces the generated output set or reports cleanup needs. | Re-run generator or remove stale outputs. | UC-009-CR-006 | The system shall avoid leaving stale generated gallery outputs after regeneration. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-009-CR-001 | The system shall be able to generate public gallery outputs from local source photos and private curation state. | Step 1 | Demonstration |
| UC-009-CR-002 | The system shall be able to generate optimized JPEG derivatives for thumbnail, large, and hero image uses. | Step 2 | Test |
| UC-009-CR-003 | The system shall be able to generate public-safe gallery metadata for album and lightbox rendering. | Step 3 | Inspection/Test |
| UC-009-CR-004 | The system shall be able to report generation counts and warnings after static gallery asset generation. | Step 4 | Inspection |
| UC-009-CR-005 | The system shall create stable path-derived photo IDs with collision handling for generated gallery metadata. | Exception E1 | Test |
| UC-009-CR-006 | The system shall avoid leaving stale generated gallery outputs after regeneration. | Exception E2 | Test/Inspection |

### UC-010: Browse Generated Album Gallery

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-010 |
| Use Case Name | Browse Generated Album Gallery |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens the generated gallery page. |
| Goal | Visitor can browse all non-excluded wedding photos by album and open optimized large photos in a static lightbox. |
| Priority | High |
| Preconditions | Generated public gallery metadata and optimized assets exist. |
| Postconditions | Visitor has browsed albums/photos without accounts, uploads, backend calls, or full-resolution downloads. |
| Evidence | Implemented in `gallery.html`, `js/gallery.js`, `data/gallery-data.json`, and generated assets |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Generated gallery page | Browser | Visitor opens `gallery.html`. | Page request | UC-010-CR-001 | The system shall be able to present generated album sections from public gallery metadata. | Proposed |
| 2 | Visitor | Gallery grid | Browser | System shows album names, photo counts, and optimized thumbnails for all non-excluded photos. | HTML/image requests | UC-010-CR-002 | The system shall be able to display all non-excluded generated gallery photos with album names, counts, and thumbnails. | Proposed |
| 3 | Visitor | Lightbox | Browser | Visitor opens a thumbnail, navigates next/previous, and closes the lightbox. | Click/keyboard events | UC-010-CR-003 | The system shall be able to provide static lightbox viewing with next, previous, close, and keyboard navigation. | Proposed |
| 4 | Visitor | Browser | Gallery page | Visitor opens or shares a photo hash link. | `#photo=<id>` | UC-010-CR-004 | The system shall be able to open stable photo deep links from generated gallery metadata. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-010-E1 | JavaScript lightbox behavior fails | Album thumbnails and static page content remain browseable. | Visitor can still inspect gallery page. | UC-010-CR-005 | The system shall keep generated gallery album content browseable when optional lightbox scripting is unavailable. | Proposed |
| UC-010-E2 | Visitor looks for original download or upload behavior | System provides no original download, upload, account, or backend path. | Visitor browses web-optimized static assets only. | UC-010-CR-006 | The system shall not expose original photo downloads, uploads, accounts, or backend photo-management behavior in the public gallery. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-010-CR-001 | The system shall be able to present generated album sections from public gallery metadata. | Step 1 | Demonstration |
| UC-010-CR-002 | The system shall be able to display all non-excluded generated gallery photos with album names, counts, and thumbnails. | Step 2 | Demonstration |
| UC-010-CR-003 | The system shall be able to provide static lightbox viewing with next, previous, close, and keyboard navigation. | Step 3 | Demonstration |
| UC-010-CR-004 | The system shall be able to open stable photo deep links from generated gallery metadata. | Step 4 | Demonstration |
| UC-010-CR-005 | The system shall keep generated gallery album content browseable when optional lightbox scripting is unavailable. | Exception E1 | Demonstration |
| UC-010-CR-006 | The system shall not expose original photo downloads, uploads, accounts, or backend photo-management behavior in the public gallery. | Exception E2 | Inspection |

### UC-011: View Session-Stable Archive Hero

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-011 |
| Use Case Name | View Session-Stable Archive Hero |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens the home page after hero-capable generated metadata exists. |
| Goal | Visitor sees a polished photo-first archive landing with a hero image that remains stable for the browser session. |
| Priority | Medium |
| Preconditions | At least one explicit hero photo exists or a static fallback hero is configured. |
| Postconditions | Visitor has a stable first impression and can continue to Story, Gallery, or Travel. |
| Evidence | Implemented in `index.html`, `css/style.css`, `js/archive-home.js`, and generated hero metadata |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Home page | Browser | Visitor opens the archive landing page. | Page request | UC-011-CR-001 | The system shall be able to present a photo-first archive landing page. | Proposed |
| 2 | Visitor | Hero selector | Browser session | System selects one hero image from explicitly hero-marked photos and keeps it stable for the session. | Session state | UC-011-CR-002 | The system shall be able to select a hero image from explicit hero photos and keep that selection stable for a browser session. | Proposed |
| 3 | Visitor | Home page | Browser | System renders hero text independently from per-photo captions. | HTML/CSS/image | UC-011-CR-003 | The system shall keep archive hero text independent from per-photo captions. | Proposed |
| 4 | Visitor | Home page | Browser | Visitor uses chapter links to continue to Story, Gallery, or Travel. | Internal links | UC-011-CR-004 | The system shall be able to provide archive chapter links to Story, Gallery, and Travel destinations. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-011-E1 | No generated hero metadata exists | Home page uses a configured static fallback hero. | Keep landing stable and readable. | UC-011-CR-005 | The system shall provide a fallback archive hero when generated hero metadata is unavailable. | Proposed |
| UC-011-E2 | Selected hero focal point would make text unreadable | System uses focal-point metadata and readable overlay rules. | Adjust metadata or fallback styling. | UC-011-CR-006 | The system shall support focal-point-aware hero presentation and readable overlay treatment for archive hero images. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-011-CR-001 | The system shall be able to present a photo-first archive landing page. | Step 1 | Demonstration |
| UC-011-CR-002 | The system shall be able to select a hero image from explicit hero photos and keep that selection stable for a browser session. | Step 2 | Demonstration |
| UC-011-CR-003 | The system shall keep archive hero text independent from per-photo captions. | Step 3 | Inspection |
| UC-011-CR-004 | The system shall be able to provide archive chapter links to Story, Gallery, and Travel destinations. | Step 4 | Demonstration |
| UC-011-CR-005 | The system shall provide a fallback archive hero when generated hero metadata is unavailable. | Exception E1 | Demonstration |
| UC-011-CR-006 | The system shall support focal-point-aware hero presentation and readable overlay treatment for archive hero images. | Exception E2 | Demonstration/Inspection |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-001 | Browser | GitHub Pages | Page request | Visitor opens URL | Inbound | Observed |
| IF-002 | Browser | GitHub Pages | CSS/JS/image request | Page load | Inbound | Observed |
| IF-003 | Browser | External CDNs | Bootstrap/jQuery/fonts request | Page load | Outbound | Observed |
| IF-004 | Browser | Venue/hotel/activity sites | External navigation | Link click | Outbound | Observed |
| IF-005 | GoDaddy forwarding | GitHub Pages URL | Forwarded request | Visitor opens public domain | External | Observed |
| IF-006 | Maintainer/Git | GitHub repository | Static source changes | Maintenance/publication | Inbound | Observed |
| IF-007 | Browser | GitHub Pages | Gallery image requests | Gallery page load | Inbound | Observed |
| IF-008 | Local review app | Local filesystem | Source photo reads and private curation JSON writes | Local review session | Local/private | Proposed |
| IF-009 | Generator | Public static assets | Optimized JPEG outputs and public gallery metadata | Generation command | Local/public output | Proposed |
| IF-010 | Browser | Generated gallery metadata/assets | Album data, thumbnail, large, and hero image requests | Gallery/home load | Inbound | Proposed |

### States Discovered
| State | Trigger / Cause | Meaning | Related Use Case |
|---|---|---|---|
| Page Loaded | HTML/assets returned | Visitor can read content. | UC-001 |
| Travel Page Loaded | Hotels/Syracuse page returned | Visitor can inspect historical travel/local context. | UC-002 |
| Public Page Removed | `contact.html` removed | Visitor cannot navigate to a low-value Info/contact page from the public site. | UC-003 |
| No Collection Path Present | Public pages omit submission paths | Visitor sees no form, RSVP, address, upload, account, or contact-submission workflow. | UC-003 |
| Public Hosted | GitHub Pages serves expected site | Hosted URL works. | UC-004 |
| Forwarding Working | Domain redirects to hosted site. | GoDaddy forwarding is functioning. | UC-004 |
| Maintenance Ready | Repo/docs available | Maintainer can update content. | UC-005 |
| Gallery Viewed | Static gallery page/assets returned | Visitor can browse selected wedding photos. | UC-006 |
| Photo Review State Saved | Local curation state written | Curator decisions can drive generation. | UC-008 |
| Gallery Assets Generated | Generator completed | Public gallery assets and metadata are ready for review. | UC-009 |
| Lightbox Open | Visitor opens generated photo | Visitor can browse large optimized photos. | UC-010 |
| Hero Selected | Home page selects hero | Visitor sees a stable session hero or fallback. | UC-011 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-001 | Static references | Run static scan and expect 0 missing local refs and 0 runtime refs. | Automated script |
| TEST-002 | Five-page smoke | Open all remaining root pages and verify expected headings/content. | Demonstration |
| TEST-003 | Mobile navigation | Verify collapsed nav/dropdown on small viewport or phone. | Demonstration |
| TEST-004 | Removed info/no collection behavior | Verify no `contact.html` public link and no form/contact/RSVP submission path. | Inspection |
| TEST-005 | External link freshness | Audit outbound hotel/activity/venue links. | Inspection/web-assisted check |
| TEST-006 | Public hosted URL | Open GitHub Pages URL and verify expected site. | Demonstration |
| TEST-007 | GoDaddy forwarding | Open final public domain after publication changes. | Demonstration |
| TEST-008 | Legacy asset cleanup | Search for unused countdown/validation references before removal. | Inspection |
| TEST-009 | Static gallery | Open gallery page and verify selected photos load without backend requests. | Demonstration/static scan |
| TEST-010 | Local photo review | Review fixture photos, update states, and confirm private curation JSON changes. | Local browser smoke/test |
| TEST-011 | Gallery generation | Generate thumbnail, large, hero outputs and public metadata from fixture photos. | Automated/integration |
| TEST-012 | Generated gallery/lightbox | Open generated gallery, verify album counts, thumbnails, keyboard lightbox, and hash deep links. | Browser smoke |
| TEST-013 | Archive hero | Verify session-stable hero selection, fallback behavior, focal point treatment, and chapter links. | Browser smoke |

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](../planning/archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Use Case Requirements Analysis; use the archive only for historical context.
