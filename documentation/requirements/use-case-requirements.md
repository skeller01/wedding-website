# Use Case Requirements Analysis

## Ordered Refresh - 2026-06-20

This refresh follows the updated context and use case model in `documentation/requirements/current-state-design.md`. It treats the site as a static GitHub Pages wedding archive / memory site with no active RSVP, address, message, email form, PHP endpoint, upload flow, or database behavior.

### Source Inputs
- `documentation/requirements/current-state-design.md` ordered systems refresh.
- Root pages: `index.html`, `about.html`, `contact.html`, `hotels.html`, `syracuse.html`.
- Static assets and scripts: `css/style.css`, `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, `images/*`.
- Static scan: 5 HTML pages, 65 resolved local references, 0 missing references, 0 server-side runtime references, 0 PHP files.
- Planning docs: `documentation/planning/deployment-footprint.md`, `documentation/planning/prd.md`, sprint and working notes.

### Use Case Index
| Use Case ID | Use Case Name | Priority | Status | Source |
|---|---|---|---|---|
| UC-001 | View Wedding Archive | High | Refreshed | Static pages and context model |
| UC-002 | Browse Historical Travel and Local Context | High | Refreshed | Hotels/Syracuse pages and external links |
| UC-003 | Read Information Page | Medium | Refreshed | `contact.html` current no-collection content |
| UC-004 | Publish Static Website | High | Refreshed | GitHub Pages/static publication workflow |
| UC-005 | Maintain Archive Content | Medium | Refreshed | Refactor/deployment/requirements follow-up |
| UC-006 | View Static Photo Gallery | Medium | Future | Future simple static gallery |

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
| 3 | Visitor | Site navigation | Browser | Visitor selects Home, About, Info, Hotels, or Local Entertainment. | Internal link/menu click | UC-001-CR-003 | The system shall be able to provide navigation links to the public content pages. | Observed |
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
| Trigger | Visitor opens `contact.html` via the `Info` navigation item. |
| Goal | Visitor understands the site is informational and does not collect addresses, RSVPs, or messages. |
| Priority | Medium |
| Preconditions | Static site is reachable. |
| Postconditions | Visitor does not encounter a misleading or broken submission path. |
| Evidence | Observed |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Info page | Browser | Visitor opens the page. | Page request | UC-003-CR-001 | The system shall be able to present a static information page from primary navigation. | Observed |
| 2 | Visitor | Info page | Browser | System states that addresses, RSVPs, and messages are not collected through the website. | Static copy | UC-003-CR-002 | The system shall clearly state when no visitor message, RSVP, or address collection path is available. | Observed |
| 3 | Visitor | Navigation | Browser | Visitor can continue to other site pages. | Internal links/nav | UC-003-CR-003 | The system shall preserve internal navigation from the information page. | Observed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-003-E1 | PHP/form behavior is reintroduced accidentally | Static scan/source search should flag runtime dependency. | Remove it or treat it as a new approved feature. | UC-003-CR-004 | The system shall not depend on a PHP runtime when deployed as a static website. | Observed/Tested |
| UC-003-E2 | Placeholder contact destination appears | Release inspection should fail. | Remove placeholder destination. | UC-003-CR-005 | The system shall avoid displaying placeholder contact destinations in visitor-facing states. | Observed/Tested |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-003-CR-001 | The system shall be able to present a static information page from primary navigation. | Step 1 | Demonstration |
| UC-003-CR-002 | The system shall clearly state when no visitor message, RSVP, or address collection path is available. | Step 2 | Inspection |
| UC-003-CR-003 | The system shall preserve internal navigation from the information page. | Step 3 | Demonstration |
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
| 4 | Maintainer | Verification | Browser/static scan | Maintainer checks pages, assets, navigation, and info behavior. | Acceptance check | UC-004-CR-004 | The deployment process shall provide a post-deployment verification path for pages, assets, navigation, and information-page behavior. | Observed |
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
| Trigger | Visitor opens a future gallery page or gallery section. |
| Goal | Visitor can browse selected wedding photos without accounts, uploads, or backend services. |
| Priority | Medium |
| Preconditions | Gallery page and selected static photo assets exist. |
| Postconditions | Visitor has viewed selected photos and can navigate back to other archive pages. |
| Evidence | Proposed from user update |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Gallery page | Browser | Visitor opens the gallery. | Page request | UC-006-CR-001 | The system shall be able to present a static wedding photo gallery page or section. | Proposed |
| 2 | Visitor | Gallery assets | Browser | System renders selected wedding photos from static assets. | Image requests | UC-006-CR-002 | The system shall be able to render selected gallery photos without backend calls, uploads, or visitor accounts. | Proposed |
| 3 | Visitor | Navigation | Browser | Visitor returns to home/story/info pages. | Internal links/nav | UC-006-CR-003 | The system shall preserve internal navigation from the static gallery. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-006-E1 | Gallery image path is missing or file is too large | Static scan or browser smoke fails/degrades. | Correct path and resize/optimize image before publication. | UC-006-CR-004 | The system shall use deploy-safe gallery image references and image sizes suitable for static hosting. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-006-CR-001 | The system shall be able to present a static wedding photo gallery page or section. | Step 1 | Demonstration |
| UC-006-CR-002 | The system shall be able to render selected gallery photos without backend calls, uploads, or visitor accounts. | Step 2 | Test/Demonstration |
| UC-006-CR-003 | The system shall preserve internal navigation from the static gallery. | Step 3 | Demonstration |
| UC-006-CR-004 | The system shall use deploy-safe gallery image references and image sizes suitable for static hosting. | Exception E1 | Test |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-001 | Browser | GitHub Pages | Page request | Visitor opens URL | Inbound | Observed |
| IF-002 | Browser | GitHub Pages | CSS/JS/image request | Page load | Inbound | Observed |
| IF-003 | Browser | External CDNs | Bootstrap/jQuery/fonts request | Page load | Outbound | Observed |
| IF-004 | Browser | Venue/hotel/activity sites | External navigation | Link click | Outbound | Observed |
| IF-005 | GoDaddy forwarding | GitHub Pages URL | Forwarded request | Visitor opens public domain | External | Observed |
| IF-006 | Maintainer/Git | GitHub repository | Static source changes | Maintenance/publication | Inbound | Observed |
| IF-007 | Browser | GitHub Pages | Gallery image requests | Future gallery page load | Inbound | Proposed |

### States Discovered
| State | Trigger / Cause | Meaning | Related Use Case |
|---|---|---|---|
| Page Loaded | HTML/assets returned | Visitor can read content. | UC-001 |
| Travel Page Loaded | Hotels/Syracuse page returned | Visitor can inspect historical travel/local context. | UC-002 |
| Info Page Loaded | `contact.html` returned | Visitor sees no-collection message. | UC-003 |
| Public Hosted | GitHub Pages serves expected site | Hosted URL works. | UC-004 |
| Forwarding Working | Domain redirects to hosted site. | GoDaddy forwarding is functioning. | UC-004 |
| Maintenance Ready | Repo/docs available | Maintainer can update content. | UC-005 |
| Gallery Viewed | Static gallery page/assets returned | Visitor can browse selected wedding photos. | UC-006 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-001 | Static references | Run static scan and expect 0 missing local refs and 0 runtime refs. | Automated script |
| TEST-002 | Five-page smoke | Open all root pages and verify expected headings/content. | Demonstration |
| TEST-003 | Mobile navigation | Verify collapsed nav/dropdown on small viewport or phone. | Demonstration |
| TEST-004 | No collection behavior | Verify Info page has no form and no-collection copy. | Inspection |
| TEST-005 | External link freshness | Audit outbound hotel/activity/venue links. | Inspection/web-assisted check |
| TEST-006 | Public hosted URL | Open GitHub Pages URL and verify expected site. | Demonstration |
| TEST-007 | GoDaddy forwarding | Open final public domain after publication changes. | Demonstration |
| TEST-008 | Legacy asset cleanup | Search for unused countdown/validation references before removal. | Inspection |
| TEST-009 | Future static gallery | Open gallery page and verify selected photos load without backend requests. | Demonstration |

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](../planning/archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Use Case Requirements Analysis; use the archive only for historical context.
