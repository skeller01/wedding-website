# Use Case Requirements Analysis

## Ordered Refresh - 2026-06-20

This refresh follows the updated context and use case model in `documentation/requirements/current-state-design.md`. It treats the site as a static GitHub Pages wedding information site with no active RSVP, address, message, email form, PHP endpoint, or database behavior.

### Source Inputs
- `documentation/requirements/current-state-design.md` ordered systems refresh.
- Root pages: `index.html`, `about.html`, `contact.html`, `hotels.html`, `syracuse.html`.
- Static assets and scripts: `css/style.css`, `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, `images/*`.
- Static scan: 5 HTML pages, 65 resolved local references, 0 missing references, 0 server-side runtime references, 0 PHP files.
- Planning docs: `documentation/planning/deployment-footprint.md`, `documentation/planning/prd.md`, sprint and working notes.

### Use Case Index
| Use Case ID | Use Case Name | Priority | Status | Source |
|---|---|---|---|---|
| UC-001 | View Wedding Information | High | Refreshed | Static pages and context model |
| UC-002 | Browse Travel and Local Information | High | Refreshed | Hotels/Syracuse pages and external links |
| UC-003 | Read Information Page | Medium | Refreshed | `contact.html` current no-collection content |
| UC-004 | Publish Static Website | High | Refreshed | GitHub Pages/static publication workflow |
| UC-005 | Maintain Website Content | Medium | Refreshed | Refactor/deployment/requirements follow-up |

### UC-001: View Wedding Information

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-001 |
| Use Case Name | View Wedding Information |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens the hosted site or forwarded public URL. |
| Goal | Visitor can read the home/story/event information and navigate to supporting pages. |
| Priority | High |
| Preconditions | Static site is hosted and reachable. |
| Postconditions | Visitor has viewed wedding information or selected another page. |
| Evidence | Observed |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Static host | Browser | Visitor requests `/` or `index.html`. | HTTPS page request | UC-001-CR-001 | The system shall be able to serve a home page as the default public website entry point. | Observed |
| 2 | Visitor | Home page | Browser | System renders names, wedding weekend framing, dates, locations, and CTA. | HTML/CSS/images | UC-001-CR-002 | The system shall be able to present wedding summary information on the home page. | Observed |
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
| UC-001-CR-002 | The system shall be able to present wedding summary information on the home page. | Step 2 | Inspection |
| UC-001-CR-003 | The system shall be able to provide navigation links to the public content pages. | Step 3 | Demonstration |
| UC-001-CR-004 | The system shall be able to load required local assets using deploy-safe paths. | Step 4 | Test |
| UC-001-CR-005 | The system shall be able to expose primary navigation on mobile viewport widths. | Alternate A1 | Demonstration |
| UC-001-CR-006 | The system shall keep primary textual wedding content readable when nonessential external resources fail to load. | Alternate A2 | Demonstration |
| UC-001-CR-007 | The system shall use case-correct local asset references for static hosting. | Exception E1 | Test |

### UC-002: Browse Travel and Local Information

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-002 |
| Use Case Name | Browse Travel and Local Information |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor selects Travel, Hotels, or Local Entertainment. |
| Goal | Visitor can read lodging/Syracuse guidance and optionally open useful external resources. |
| Priority | High |
| Preconditions | Static pages and local assets are available. |
| Postconditions | Visitor has viewed internal travel/local content or intentionally left via an external link. |
| Evidence | Observed with external freshness risk |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Navigation | Browser | Visitor opens the Travel dropdown. | Bootstrap dropdown | UC-002-CR-001 | The system shall be able to expose hotel and local entertainment links from navigation. | Observed |
| 2 | Visitor | Hotels page | Browser | System renders hotel names, descriptions, distances, and cost guidance. | `hotels.html` | UC-002-CR-002 | The system shall be able to present lodging information for visitors. | Observed |
| 3 | Visitor | Syracuse page | Browser | System renders local activity thumbnails and guidance. | `syracuse.html` | UC-002-CR-003 | The system shall be able to present local entertainment information for visitors. | Observed |
| 4 | Visitor | External link | Third-party site | Visitor opens a venue, hotel, or activity link. | Outbound URL | UC-002-CR-004 | The system shall be able to provide outbound links to relevant venue, hotel, and local activity resources. | Observed |

#### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-A1 | External site is stale or unavailable | Visitor still reads internal content. | Core travel/event context remains usable. | UC-002-CR-005 | The system shall keep core travel and event information available without requiring third-party links to load. | Inferred |
| UC-002-A2 | Specific business is closed/rebranded | Maintainer replaces it with official or durable destination information. | Page remains useful. | UC-002-CR-006 | The system shall allow stale business-specific links to be replaced with current official or destination-hub resources. | Proposed |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-E1 | Known stale external link remains before public promotion | Visitor may reach misleading or dead page. | Audit, replace, or remove the link. | UC-002-CR-007 | The system shall not knowingly present stale, closed, or rebranded external lodging/activity destinations as current recommendations before public-domain promotion. | Proposed |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-002-CR-001 | The system shall be able to expose hotel and local entertainment links from navigation. | Step 1 | Demonstration |
| UC-002-CR-002 | The system shall be able to present lodging information for visitors. | Step 2 | Inspection |
| UC-002-CR-003 | The system shall be able to present local entertainment information for visitors. | Step 3 | Inspection |
| UC-002-CR-004 | The system shall be able to provide outbound links to relevant venue, hotel, and local activity resources. | Step 4 | Inspection |
| UC-002-CR-005 | The system shall keep core travel and event information available without requiring third-party links to load. | Alternate A1 | Demonstration |
| UC-002-CR-006 | The system shall allow stale business-specific links to be replaced with current official or destination-hub resources. | Alternate A2 | Inspection |
| UC-002-CR-007 | The system shall not knowingly present stale, closed, or rebranded external lodging/activity destinations as current recommendations before public-domain promotion. | Exception E1 | Inspection |

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
| Goal | Verified static content is served over HTTPS and public-domain forwarding can be verified. |
| Priority | High |
| Preconditions | GitHub repository and GitHub Pages configuration exist. |
| Postconditions | Hosted URL works; forwarding is verified or explicitly pending. |
| Evidence | Observed / partially verified |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Maintainer | Repository | GitHub | Maintainer keeps deployable files in source control. | Git commit | UC-004-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Observed |
| 2 | Maintainer | Repository | GitHub Pages | Maintainer publishes production branch. | GitHub Pages source | UC-004-CR-002 | The system shall be deployable to GitHub Pages from the GitHub repository. | Observed |
| 3 | GitHub Pages | Static host | Browser | Host serves HTTPS site. | HTTPS request | UC-004-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Observed |
| 4 | Maintainer | Verification | Browser/static scan | Maintainer checks pages, assets, navigation, and info behavior. | Acceptance check | UC-004-CR-004 | The deployment process shall provide a post-deployment verification path for pages, assets, navigation, and information-page behavior. | Observed |
| 5 | Maintainer | Domain forwarding | GoDaddy/GitHub Pages | Maintainer verifies forwarded domain behavior. | Forwarded request | UC-004-CR-005 | The system shall support access through a GoDaddy-forwarded public URL. | Partial |

#### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-004-E1 | Static scan fails | Publication should pause. | Fix references/runtime issue. | UC-004-CR-006 | The deployment process shall identify missing local asset or server-runtime references before public release. | Tested |
| UC-004-E2 | Forwarded domain differs by device/network | Forwarding remains pending. | Verify cache, DNS, propagation, and target. | UC-004-CR-007 | The deployment process shall verify the GoDaddy-forwarded URL after configuration. | Partial |

#### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-004-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Step 1 | Inspection |
| UC-004-CR-002 | The system shall be deployable to GitHub Pages from the GitHub repository. | Step 2 | Demonstration |
| UC-004-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Step 3 | Demonstration |
| UC-004-CR-004 | The deployment process shall provide a post-deployment verification path for pages, assets, navigation, and information-page behavior. | Step 4 | Test/Demonstration |
| UC-004-CR-005 | The system shall support access through a GoDaddy-forwarded public URL. | Step 5 | Demonstration |
| UC-004-CR-006 | The deployment process shall identify missing local asset or server-runtime references before public release. | Exception E1 | Test |
| UC-004-CR-007 | The deployment process shall verify the GoDaddy-forwarded URL after configuration. | Exception E2 | Demonstration |

### UC-005: Maintain Website Content

#### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-005 |
| Use Case Name | Maintain Website Content |
| Primary Actor | Site Maintainer |
| Trigger | Content, links, assets, or docs need correction. |
| Goal | Site files and docs remain aligned with current static/no-collection product intent. |
| Priority | Medium |
| Preconditions | Maintainer has repository access. |
| Postconditions | Updated source passes static/reference checks and docs reflect the change. |
| Evidence | Inferred from repo/docs |

#### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Maintainer | Repository | Git | Maintainer identifies a stale link, obsolete asset, or content mismatch. | Source review | UC-005-CR-001 | The system shall support inspection of visitor-facing content and external links during maintenance. | Inferred |
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
| UC-005-CR-001 | The system shall support inspection of visitor-facing content and external links during maintenance. | Step 1 | Inspection |
| UC-005-CR-002 | The system shall allow static content and asset updates without requiring a build or backend deployment. | Step 2 | Demonstration |
| UC-005-CR-003 | The maintenance process shall verify static references and affected visitor flows after content changes. | Step 3 | Test |
| UC-005-CR-004 | The maintenance process shall update durable planning or requirements docs when behavior, deployment, or scope changes. | Step 4 | Inspection |
| UC-005-CR-005 | The repository shall remove or explicitly archive unused legacy interaction assets when the related public behavior has been intentionally removed. | Exception E1 | Inspection |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-001 | Browser | GitHub Pages | Page request | Visitor opens URL | Inbound | Observed |
| IF-002 | Browser | GitHub Pages | CSS/JS/image request | Page load | Inbound | Observed |
| IF-003 | Browser | External CDNs | Bootstrap/jQuery/fonts request | Page load | Outbound | Observed |
| IF-004 | Browser | Venue/hotel/activity sites | External navigation | Link click | Outbound | Observed |
| IF-005 | GoDaddy forwarding | GitHub Pages URL | Forwarded request | Visitor opens public domain | External | Partial |
| IF-006 | Maintainer/Git | GitHub repository | Static source changes | Maintenance/publication | Inbound | Observed |

### States Discovered
| State | Trigger / Cause | Meaning | Related Use Case |
|---|---|---|---|
| Page Loaded | HTML/assets returned | Visitor can read content. | UC-001 |
| Travel Page Loaded | Hotels/Syracuse page returned | Visitor can inspect travel/local content. | UC-002 |
| Info Page Loaded | `contact.html` returned | Visitor sees no-collection message. | UC-003 |
| Public Hosted | GitHub Pages serves expected site | Hosted URL works. | UC-004 |
| Forwarding Pending | Domain works inconsistently | GoDaddy verification remains incomplete. | UC-004 |
| Maintenance Ready | Repo/docs available | Maintainer can update content. | UC-005 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-001 | Static references | Run static scan and expect 0 missing local refs and 0 runtime refs. | Automated script |
| TEST-002 | Five-page smoke | Open all root pages and verify expected headings/content. | Demonstration |
| TEST-003 | Mobile navigation | Verify collapsed nav/dropdown on small viewport or phone. | Demonstration |
| TEST-004 | No collection behavior | Verify Info page has no form and no-collection copy. | Inspection |
| TEST-005 | External link freshness | Audit outbound hotel/activity/venue links. | Inspection/web-assisted check |
| TEST-006 | Public hosted URL | Open GitHub Pages URL and verify expected site. | Demonstration |
| TEST-007 | GoDaddy forwarding | Open final public domain from multiple contexts. | Demonstration |
| TEST-008 | Legacy asset cleanup | Search for unused countdown/validation references before removal. | Inspection |

## Historical Archive

Older conflicting sections were moved to [historical-doc-conflicts-2026-06-20.md](../planning/archive/historical-doc-conflicts-2026-06-20.md). Treat this file as the current source of truth for Use Case Requirements Analysis; use the archive only for historical context.
