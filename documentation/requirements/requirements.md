# Requirements

## Source Inputs
- `documentation/requirements/current-state-design.md`, especially the current authoritative context, use case, and FFBD snapshots.
- `documentation/requirements/use-case-requirements.md`, especially the current refresh summary and refreshed UC-002, UC-003, and UC-004 behavioral matrices.
- `documentation/planning/deployment-footprint.md` and `documentation/planning/working/refactor-plan.md`.
- Repository files: `index.html`, `about.html`, `contact.html`, `hotels.html`, `syracuse.html`, `css/style.css`, `js/*`, and `images/*`.
- Static scan evidence from `documentation/planning/working/prototypes/static_site_scan.py`: 5 HTML pages, 65 resolved local references, 0 missing or case-mismatched references, 0 server-side runtime references, and 0 PHP files.
- Current deployment evidence, verified June 19, 2026: GitHub Pages serves the site from `main` at `https://skeller01.github.io/wedding-website/`; the site is public and HTTPS-enforced, and the live page returns HTTP 200.
- User direction: the site is mostly static public wedding information, no RSVP/address/email collection is needed, cheapest possible hosting is preferred, GoDaddy forwarding works from the user's phone but not yet from the user's home browser, and several hotel/activity links are stale or suspect.

## Current Requirement Baseline
GitHub Pages is now the production static host. The public website is an informational static site, not a contact form or RSVP collection tool. The obsolete PHP contact endpoint and Ajax contact script have been removed from the deployable public path.

The remaining requirement work is concentrated in:
- Complete GoDaddy forwarding verification across the user's home browser/network.
- External destination refresh for hotels, Syracuse activities, and stale linked resources.
- Desktop/home-browser smoke testing; mobile responsiveness has been observed on the user's phone.
- Cleanup or explicit archival of unused legacy interaction assets.

## Requirement Table
| Req ID | Abstract Name | Requirement | Type | Priority | Source | Status | Verification Method | Evidence |
|---|---|---|---|---|---|---|---|---|
| REQ-001 | Serve Home Entry | The system shall serve `index.html` as the default public website entry point. | Functional | High | UC-001-CR-001 | Implemented | Demonstration | GitHub Pages URL loads the home page. |
| REQ-002 | Present Wedding Summary | The system shall present wedding summary and story information on public static pages. | Functional | High | UC-001-CR-002 | Implemented | Inspection | Home/about content exists. |
| REQ-003 | Provide Internal Navigation | The system shall provide navigation links among the home, story, info, hotels, and Syracuse pages. | Functional | High | UC-001-CR-003, UC-002-CR-001, UC-003-CR-012 | Implemented | Demonstration | Shared navigation exists across pages. |
| REQ-004 | Resolve Local Assets | The system shall use deploy-safe, case-correct local asset references for all hosted static pages. | Functional | High | UC-001-CR-004, UC-001-CR-007, UC-002-CR-006, UC-004-CR-007 | Implemented | Test | Static scan reports 0 missing references. |
| REQ-005 | Support Mobile Navigation | The system shall expose primary navigation on mobile viewport widths. | Functional | Medium | UC-001-CR-005 | Verified by User | Demonstration | User reports the GoDaddy-forwarded site looks responsive on phone. |
| REQ-006 | Use HTTPS Script Resources | The system shall request required third-party scripts over HTTPS when the website is served over HTTPS. | Interface/Security | High | UC-001-CR-008 | Implemented | Inspection/Test | No required HTTP script source remains in public pages. |
| REQ-007 | Present Lodging Information | The system shall present lodging information for visitors. | Functional/Content | Medium | UC-002-CR-002 | Partial | Inspection | Hotels page renders; some names/links need freshness review. |
| REQ-008 | Present Local Entertainment Information | The system shall present Syracuse/local activity information for visitors. | Functional/Content | Medium | UC-002-CR-003 | Partial | Inspection | Syracuse page renders; some activity links need freshness review. |
| REQ-009 | Provide External Resource Links | The system shall provide outbound links to relevant venue, lodging, and local activity resources when those links are useful and current enough for public use. | Functional/Interface | Medium | UC-002-CR-004 | Partial | Inspection | Outbound links exist and open externally; stale links remain. |
| REQ-010 | Preserve Core Info Without External Sites | The system shall keep core wedding, travel, and event information available without requiring third-party sites to load. | Reliability | Medium | UC-001-CR-006, UC-002-CR-005 | Implemented | Demonstration | Core copy is internal static content. |
| REQ-011 | Present Information Page | The system shall present a static information page from the primary navigation. | Functional | Medium | UC-003-CR-001 | Implemented | Demonstration | `contact.html` is now the Info page. |
| REQ-012 | Avoid Static PHP Dependency | The system shall not require PHP execution to provide the public website when deployed as a static website. | Deployment/Architecture | High | UC-003-CR-004, UC-004-CR-007 | Implemented | Analysis/Test | Static scan reports 0 server-side runtime references and 0 PHP files. |
| REQ-013 | State No-Collection Policy | The system shall clearly state when no visitor message, RSVP, or address collection path is available. | Functional/Privacy | High | UC-003-CR-011 | Implemented | Inspection | Info page states the site is not collecting addresses, RSVPs, or messages. |
| REQ-014 | Avoid Placeholder Contact Destinations | The system shall avoid displaying placeholder contact destinations in visitor-facing pages or error states. | Content/Functional | High | UC-003-CR-009 | Implemented | Inspection | No visitor-facing `me@example` remains in public files. |
| REQ-015 | Validate Enabled Contact Form | When a form contact path is intentionally reintroduced, the system shall reject incomplete or invalid input before submission. | Conditional Functional | Low | Historical UC-003-CR-003, UC-003-CR-008 | Retired / Conditional | Demonstration | Not applicable unless a future form feature is approved. |
| REQ-016 | Route Enabled Form Submissions | When a form contact path is intentionally reintroduced, the system shall route submissions to a deliberately configured recipient or service. | Conditional Functional | Low | Historical UC-003-CR-010 | Retired / Conditional | Test | Not applicable unless a future backend/form feature is approved. |
| REQ-017 | Deploy From GitHub | The system shall be deployable to a low-cost static hosting service from the GitHub repository. | Deployment | High | UC-004-CR-001, UC-004-CR-002 | Implemented | Demonstration | GitHub Pages publishes from the repository. |
| REQ-018 | Provide HTTPS Hosted URL | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Deployment/Interface | High | UC-004-CR-003 | Implemented | Demonstration | `https://skeller01.github.io/wedding-website/` is live. |
| REQ-019 | Support GoDaddy Forwarding | The system shall support access through a GoDaddy-forwarded public URL. | Deployment/Interface | High | UC-004-CR-004, UC-004-CR-008 | Partially Verified | Demonstration | User reports the GoDaddy link works on phone but not yet from the home browser. |
| REQ-020 | Verify Before Public Release | The deployment process shall verify static pages, assets, navigation, information-page behavior, hosted URL behavior, and GoDaddy forwarding before public-domain promotion. | Verification | High | UC-004-CR-005, UC-004-CR-007, UC-004-CR-008, UC-004-CR-009 | Partial | Test/Demonstration | Static scan, Pages URL, phone GoDaddy check, and mobile responsiveness pass; home-browser GoDaddy and external-link checks remain. |
| REQ-021 | Support Development Branch Workflow | The deployment process shall allow work to occur on `development` before changes are merged or pushed to the production branch. | Deployment/Workflow | Medium | UC-004-CR-001, UC-004-CR-002 | Implemented | Inspection | `development` exists and has been used for PR-style work. |
| REQ-022 | Refresh External Destinations | The system shall not knowingly present stale, closed, or rebranded external lodging/activity destinations as current recommendations before public-domain promotion. | Content/Reliability | High | UC-002-CR-007, UC-002-CR-008, UC-002-CR-009 | Planned | Inspection/Demonstration | User identified Jefferson Clinton and kayak links as suspect. |
| REQ-023 | Remove Dead Legacy Assets | The repository shall remove or explicitly archive unused legacy interaction assets when the related public behavior has been intentionally removed. | Maintainability | Medium | UC-005 maintenance, refactor plan | Planned | Inspection | Countdown/validation-era assets remain after form removal. |

## Candidate Requirement Mapping
| Candidate ID | Source Use Case / Step | Final Req ID | Mapping Status | Notes |
|---|---|---|---|---|
| UC-001-CR-001 | View home page | REQ-001 | Mapped | Default static entry. |
| UC-001-CR-002 | Read home/story content | REQ-002 | Mapped | Wedding summary and story content. |
| UC-001-CR-003 | Navigate pages | REQ-003 | Mapped | Shared public navigation. |
| UC-001-CR-004 | Load static assets | REQ-004 | Merged | General local asset integrity. |
| UC-001-CR-005 | Use mobile viewport | REQ-005 | Mapped | User observed responsive behavior on phone. |
| UC-001-CR-006 | External CDN degraded | REQ-010 | Merged | Core text remains internal. |
| UC-001-CR-007 | Case-sensitive asset failure | REQ-004 | Merged | Static scan covers this. |
| UC-001-CR-008 | HTTP script on HTTPS page | REQ-006 | Mapped | HTTPS resource safety. |
| UC-002-CR-001 | Travel navigation | REQ-003 | Merged | Navigation to travel pages. |
| UC-002-CR-002 | Lodging content | REQ-007 | Mapped | Hotels page. |
| UC-002-CR-003 | Local activity content | REQ-008 | Mapped | Syracuse page. |
| UC-002-CR-004 | Open external resource | REQ-009 | Mapped | Outbound links. |
| UC-002-CR-005 | External site unavailable | REQ-010 | Mapped | Internal content still useful. |
| UC-002-CR-006 | Thumbnail path issue | REQ-004 | Merged | Asset scan. |
| UC-002-CR-007 | Maintainer refreshes stale links | REQ-022 | Mapped | New high-priority content requirement. |
| UC-002-CR-008 | Replace stale business link with durable hub | REQ-022 | Merged | Allows tourism/official alternatives. |
| UC-002-CR-009 | Known stale link remains | REQ-022 | Mapped | Blocks public-domain promotion confidence. |
| UC-003-CR-001 | Open Info page | REQ-011 | Mapped | Current `contact.html` behavior. |
| UC-003-CR-004 | Avoid PHP runtime | REQ-012 | Mapped | Static hosting constraint. |
| UC-003-CR-009 | Placeholder contact destination | REQ-014 | Mapped | Public placeholder avoidance. |
| UC-003-CR-011 | No collection statement | REQ-013 | Mapped | Current product decision. |
| UC-003-CR-012 | Internal navigation from Info page | REQ-003 | Merged | Shared navigation. |
| Historical UC-003-CR-003 / CR-008 | Form validation | REQ-015 | Conditional | Retained only as future-form guardrail. |
| Historical UC-003-CR-010 | Form routing | REQ-016 | Conditional | Retained only as future-backend guardrail. |
| UC-004-CR-001 | Maintain deployable files | REQ-017, REQ-021 | Merged | Repository and branch workflow. |
| UC-004-CR-002 | Deploy through GitHub Pages | REQ-017 | Mapped | Current production host. |
| UC-004-CR-003 | Serve HTTPS URL | REQ-018 | Mapped | Current public URL. |
| UC-004-CR-004 | Verify GoDaddy forwarding | REQ-019 | Mapped | Partially verified on phone; home browser still not working. |
| UC-004-CR-005 | Post-deployment checks | REQ-020 | Mapped | Release verification. |
| UC-004-CR-007 | Static scan before release | REQ-004, REQ-020 | Merged | Automated local check. |
| UC-004-CR-008 | GoDaddy wrong/pending | REQ-019, REQ-020 | Merged | External verification. |
| UC-004-CR-009 | Pages propagation retry | REQ-020 | Mapped | Hosted URL verification. |
| UC-005 maintenance | Content and asset cleanup | REQ-022, REQ-023 | Mapped | Current next-sprint work. |

## Requirement Constants
| Constant | Meaning | Current Value | Source / How To Determine |
|---|---|---|---|
| HOSTING_COST_TARGET | Desired hosting cost class. | Free or effectively free for expected traffic. | User direction; GitHub Pages selection. |
| PRODUCTION_BRANCH | Branch used by the production static host. | `main` | GitHub Pages source. |
| WORK_BRANCH | Branch used for pre-production changes. | `development` | User workflow. |
| PUBLIC_HOSTING_URL | Current public hosted URL. | `https://skeller01.github.io/wedding-website/` | GitHub Pages. |
| PUBLIC_FORWARDING_PROVIDER | Domain forwarding provider. | GoDaddy | User direction. |
| PUBLIC_FORWARDING_DOMAIN | Final user-facing forwarded domain. | TBD / pending user verification. | GoDaddy setup. |
| CONTACT_COLLECTION_ENABLED | Whether the public site collects messages, RSVPs, or addresses. | `false` | Current product decision and Info page copy. |
| STATIC_SCAN_TARGET | Minimum static scan result before promotion. | 0 missing local references, 0 server-side runtime references, 0 PHP files. | Prototype scan evidence. |

## Quality Check
| Req ID | Correct | Clear / Precise | Unambiguous | Objective | Verifiable | Consistent | Issue / Fix |
|---|---|---|---|---|---|---|---|
| REQ-001 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-002 | Yes | Yes | Yes | Yes | Yes | Yes | Content freshness remains an owner choice. |
| REQ-003 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-004 | Yes | Yes | Yes | Yes | Yes | Yes | Implemented by current scan. |
| REQ-005 | Yes | Yes | Yes | Yes | Yes | Yes | Verified on phone by user; broader browser/device sweep remains optional. |
| REQ-006 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-007 | Yes | Yes | Yes | Yes | Yes | Yes | Link/name freshness work remains. |
| REQ-008 | Yes | Yes | Yes | Yes | Yes | Yes | Activity link freshness work remains. |
| REQ-009 | Yes | Yes | Yes | Yes | Yes | Yes | Partially satisfied until stale links are patched or removed. |
| REQ-010 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-011 | Yes | Yes | Yes | Yes | Yes | Yes | Decide later whether filename/nav should change from historical contact wording. |
| REQ-012 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-013 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-014 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-015 | Yes | Yes | Yes | Yes | Yes | Yes | Conditional only; not current scope. |
| REQ-016 | Yes | Yes | Yes | Yes | Yes | Yes | Conditional only; not current scope. |
| REQ-017 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-018 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-019 | Yes | Yes | Yes | Yes | Yes | Yes | Partial: works on phone, not yet in user's home browser. |
| REQ-020 | Yes | Yes | Yes | Yes | Yes | Yes | Partial until home-browser GoDaddy and external-link checks pass. |
| REQ-021 | Yes | Yes | Yes | Yes | Yes | Yes | No separate preview host is required by this requirement. |
| REQ-022 | Yes | Yes | Yes | Yes | Yes | Yes | New high-priority content reliability requirement. |
| REQ-023 | Yes | Yes | Yes | Yes | Yes | Yes | New maintainability requirement. |

## Traceability
| Req ID | Source Use Case / Step | Related Candidate ID(s) | Related Interface | Related State | Related Test |
|---|---|---|---|---|---|
| REQ-001 | UC-001 Step 1 | UC-001-CR-001 | IF-001 | Page Loaded | TEST-002, TEST-009 |
| REQ-002 | UC-001 Step 2 | UC-001-CR-002 | IF-001 | Page Loaded | TEST-002 |
| REQ-003 | UC-001 Step 3, UC-002 Step 1, UC-003 Step 3 | UC-001-CR-003, UC-002-CR-001, UC-003-CR-012 | IF-001 | Page Loaded | TEST-003 |
| REQ-004 | UC-001 Step 4, UC-001 E1, UC-002 E1, UC-004 E1 | UC-001-CR-004, UC-001-CR-007, UC-002-CR-006, UC-004-CR-007 | IF-003 | Degraded Render | TEST-001, TEST-005, TEST-011 |
| REQ-005 | UC-001 A1 | UC-001-CR-005 | IF-002 | Page Loaded | TEST-003 |
| REQ-006 | UC-001 E2 | UC-001-CR-008 | IF-002 | Degraded Render | TEST-002, TEST-003 |
| REQ-007 | UC-002 Step 2 | UC-002-CR-002 | IF-001 | Travel Page Loaded | TEST-004, TEST-012 |
| REQ-008 | UC-002 Step 3 | UC-002-CR-003 | IF-001 | Travel Page Loaded | TEST-004, TEST-012 |
| REQ-009 | UC-002 Step 4 | UC-002-CR-004 | IF-004 | External Navigation Started | TEST-012 |
| REQ-010 | UC-001 A2, UC-002 A2 | UC-001-CR-006, UC-002-CR-005 | IF-004 | Travel Page Loaded | TEST-004 |
| REQ-011 | UC-003 Step 1 | UC-003-CR-001 | IF-001 | Info Page Loaded | TEST-006 |
| REQ-012 | UC-003 E1, UC-004 E1 | UC-003-CR-004, UC-004-CR-007 | IF-006 retired | Static Fallback Needed | TEST-008, TEST-011 |
| REQ-013 | UC-003 Step 2 | UC-003-CR-011 | IF-001 | Info Page Loaded | TEST-006 |
| REQ-014 | UC-003 E2 | UC-003-CR-009 | IF-001 | Static Fallback Needed | TEST-007 |
| REQ-015 | Historical UC-003 form validation | UC-003-CR-003, UC-003-CR-008 | IF-005 retired | Validation Failed | Future form demo only |
| REQ-016 | Historical UC-003 form routing | UC-003-CR-010 | IF-006 retired | Submission Attempted | Future backend test only |
| REQ-017 | UC-004 Steps 1-2 | UC-004-CR-001, UC-004-CR-002 | IF-008 | Public Hosted | TEST-009 |
| REQ-018 | UC-004 Step 3 | UC-004-CR-003 | IF-009 | Public Hosted | TEST-009 |
| REQ-019 | UC-004 Step 5, E2 | UC-004-CR-004, UC-004-CR-008 | IF-010 | Forwarded | TEST-010 |
| REQ-020 | UC-004 Step 4, E1, E2, E3 | UC-004-CR-005, UC-004-CR-007, UC-004-CR-008, UC-004-CR-009 | IF-009, IF-010 | Public Hosted, Forwarded | TEST-011 |
| REQ-021 | Maintainer workflow | UC-004-CR-001, UC-004-CR-002 | IF-008 | Maintenance Ready | Git inspection |
| REQ-022 | UC-002 Step 5, A1, E2 | UC-002-CR-007, UC-002-CR-008, UC-002-CR-009 | IF-004 | External Navigation Started | TEST-012 |
| REQ-023 | Maintenance cleanup | UC-005 maintenance | IF-008 | Maintenance Ready | Inspection |

## Assumptions
- GitHub Pages remains the production hosting path unless it becomes blocked or the user deliberately chooses AWS later.
- AWS Amplify remains a fallback option, not the current target.
- GoDaddy forwarding will target the GitHub Pages URL unless the user decides to use full DNS/custom-domain configuration.
- No RSVP, email form, address collection, database, or backend runtime is in current scope.
- External hotel/activity destination accuracy matters before the GoDaddy-forwarded domain is advertised.

## Gaps and Questions
- What exact GoDaddy domain should be recorded for traceability?
- Which stale external links should be replaced with official venue/hotel/tourism links, and which should simply be removed?
- Should `contact.html` and the visible `Info` navigation label be renamed more directly now that there is no contact behavior?
- Should unused countdown and validation assets be removed in the next implementation sprint?
- Why does the GoDaddy-forwarded URL work on phone but not from the user's home browser: DNS cache, browser cache, local network resolver, or forwarding propagation?
