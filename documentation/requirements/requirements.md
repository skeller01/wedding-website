# Requirements

## Source Inputs
- `documentation/requirements/current-state-design.md`
- `documentation/requirements/use-case-requirements.md`
- Repository files: root HTML pages, `css/style.css`, `js/contact_me.js`, `bin/contact_me.php`
- Prototype scan: `documentation/planning/working/prototypes/static_site_scan.ps1`
- User goal: cheap AWS static hosting with GoDaddy forwarding

## Requirement Table
| Req ID | Abstract Name | Requirement | Type | Priority | Source | Verification Method | Evidence |
|---|---|---|---|---|---|---|---|
| REQ-001 | Serve Home Entry | The system shall be able to serve `index.html` as the default public website entry point. | Functional | High | UC-001-CR-001 | Demonstration | Observed/Proposed |
| REQ-002 | Present Wedding Summary | The system shall be able to present wedding summary information on the home page. | Functional | High | UC-001-CR-002 | Inspection | Observed |
| REQ-003 | Provide Internal Navigation | The system shall be able to provide navigation links to the home, about, contact, hotels, and local entertainment pages. | Functional | High | UC-001-CR-003, UC-002-CR-001 | Demonstration | Observed |
| REQ-004 | Resolve Local Assets | The system shall use deploy-safe, case-correct local asset references for all hosted static pages. | Functional | High | UC-001-CR-004, UC-001-CR-007, UC-002-CR-006 | Test | Prototype |
| REQ-005 | Support Mobile Navigation | The system shall be able to expose primary navigation on mobile viewport widths. | Functional | Medium | UC-001-CR-005 | Demonstration | Observed/Inferred |
| REQ-006 | Use HTTPS Script Resources | The system shall request required third-party scripts over HTTPS when the website is served over HTTPS. | Interface/Security | High | UC-001-CR-008 | Inspection/Test | Observed/Inferred |
| REQ-007 | Present Lodging Information | The system shall be able to present suggested lodging information for visitors. | Functional | Medium | UC-002-CR-002 | Inspection | Observed |
| REQ-008 | Present Local Entertainment Information | The system shall be able to present local entertainment information for visitors. | Functional | Medium | UC-002-CR-003 | Inspection | Observed |
| REQ-009 | Provide External Resource Links | The system shall be able to provide outbound links to relevant venue, hotel, and local activity resources. | Functional/Interface | Medium | UC-002-CR-004 | Inspection | Observed |
| REQ-010 | Preserve Core Info Without External Sites | The system shall keep core travel and event information available without requiring third-party links to load. | Reliability | Medium | UC-002-CR-005 | Demonstration | Inferred |
| REQ-011 | Present Contact Channel | The system shall be able to present a contact page with a visitor-usable contact channel. | Functional | High | UC-003-CR-001, UC-003-CR-006 | Demonstration | Observed |
| REQ-012 | Avoid Static PHP Dependency | The system shall not require PHP execution to provide the public website when deployed as a static website. | Deployment/Architecture | High | UC-003-CR-004, UC-003-CR-007 | Analysis/Test | Inferred |
| REQ-013 | Provide Contact Fallback | The system shall provide a clear visitor-visible contact fallback when form submission is unavailable. | Functional | High | UC-003-CR-005, UC-003-CR-007 | Demonstration | Observed/Inferred |
| REQ-014 | Avoid Placeholder Contact Destinations | The system shall avoid displaying placeholder contact destinations in visitor-facing contact states. | Content/Functional | High | UC-003-CR-009 | Inspection | Observed |
| REQ-015 | Validate Enabled Contact Form | When a form contact path is enabled, the system shall reject incomplete or invalid contact form input before submission. | Functional | Medium | UC-003-CR-003, UC-003-CR-008 | Demonstration | Observed |
| REQ-016 | Route Enabled Form Submissions | When a form contact path is enabled, the system shall route submissions to a configured recipient. | Functional | Medium | UC-003-CR-010 | Test | Observed |
| REQ-017 | Deploy From GitHub | The system shall be deployable to a low-cost static hosting service from the GitHub repository. | Deployment | High | UC-005-CR-001, UC-005-CR-002 | Demonstration | Proposed |
| REQ-018 | Provide HTTPS Hosted URL | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Deployment/Interface | High | UC-005-CR-003 | Demonstration | Proposed |
| REQ-019 | Support GoDaddy Forwarding | The system shall support access through a GoDaddy-forwarded public URL. | Deployment/Interface | High | UC-005-CR-004 | Demonstration | Proposed |
| REQ-020 | Verify Before Public Release | The deployment process shall verify pages, assets, navigation, contact behavior, and the GoDaddy-forwarded URL before public release. | Verification | High | UC-005-CR-005, UC-005-CR-007, UC-005-CR-008 | Test/Demonstration | Proposed |
| REQ-021 | Support Pre-Release Branch | The deployment process shall allow a non-main branch to be used for pre-release verification. | Deployment | Medium | UC-005-CR-006 | Demonstration | User workflow |

## Candidate Requirement Mapping
| Candidate ID | Source Use Case / Step | Final Req ID | Mapping Status | Notes |
|---|---|---|---|---|
| UC-001-CR-001 | UC-001 Step 1 | REQ-001 | Mapped | Default entry behavior. |
| UC-001-CR-002 | UC-001 Step 2 | REQ-002 | Mapped | Home content. |
| UC-001-CR-003 | UC-001 Step 3 | REQ-003 | Mapped | Internal navigation. |
| UC-001-CR-004 | UC-001 Step 4 | REQ-004 | Merged | General local asset integrity. |
| UC-001-CR-005 | UC-001 Alternate A1 | REQ-005 | Mapped | Mobile navigation. |
| UC-001-CR-006 | UC-001 Alternate A2 | REQ-010 | Merged | Core content availability. |
| UC-001-CR-007 | UC-001 Exception E1 | REQ-004 | Merged | Case-correct asset references. |
| UC-001-CR-008 | UC-001 Exception E2 | REQ-006 | Mapped | HTTPS scripts. |
| UC-002-CR-001 | UC-002 Step 1 | REQ-003 | Merged | Navigation links. |
| UC-002-CR-002 | UC-002 Step 2 | REQ-007 | Mapped | Lodging content. |
| UC-002-CR-003 | UC-002 Step 3 | REQ-008 | Mapped | Local content. |
| UC-002-CR-004 | UC-002 Step 4 | REQ-009 | Mapped | External links. |
| UC-002-CR-005 | UC-002 Alternate A1 | REQ-010 | Mapped | Core info independent of external websites. |
| UC-002-CR-006 | UC-002 Exception E1 | REQ-004 | Merged | Local image case correctness. |
| UC-003-CR-001 | UC-003 Step 1 | REQ-011 | Mapped | Contact page. |
| UC-003-CR-002 | UC-003 Step 2 | REQ-015 | Merged | Only applies if form remains enabled. |
| UC-003-CR-003 | UC-003 Step 3 | REQ-015 | Mapped | Form validation. |
| UC-003-CR-004 | UC-003 Step 4 | REQ-012 | Mapped | Static hosting cannot rely on PHP. |
| UC-003-CR-005 | UC-003 Step 5 | REQ-013 | Mapped | Contact fallback. |
| UC-003-CR-006 | UC-003 Alternate A1 | REQ-011 | Merged | Direct email option. |
| UC-003-CR-007 | UC-003 Alternate A2 | REQ-012, REQ-013 | Merged | Static contact preservation. |
| UC-003-CR-008 | UC-003 Exception E1 | REQ-015 | Mapped | Required/invalid fields. |
| UC-003-CR-009 | UC-003 Exception E2 | REQ-014 | Mapped | Placeholder email issue. |
| UC-003-CR-010 | UC-003 Exception E3 | REQ-016 | Mapped | Configured recipient. |
| UC-005-CR-001 | UC-005 Step 1 | REQ-017 | Merged | GitHub source. |
| UC-005-CR-002 | UC-005 Step 2 | REQ-017 | Mapped | Legacy candidate from AWS-first analysis; final requirement is now provider-neutral static hosting from GitHub. |
| UC-005-CR-003 | UC-005 Step 3 | REQ-018 | Mapped | HTTPS hosted URL. |
| UC-005-CR-004 | UC-005 Step 4 | REQ-019 | Mapped | GoDaddy forwarding. |
| UC-005-CR-005 | UC-005 Step 5 | REQ-020 | Mapped | Verification path. |
| UC-005-CR-006 | UC-005 Alternate A1 | REQ-021 | Mapped | Development branch preview. |
| UC-005-CR-007 | UC-005 Exception E1 | REQ-020 | Merged | Static scan before release. |
| UC-005-CR-008 | UC-005 Exception E2 | REQ-020 | Merged | Forwarding verification. |

## Requirement Constants
| Constant | Meaning | Current Value | Source / How To Determine |
|---|---|---|---|
| HOSTING_COST_TARGET | Desired monthly hosting cost class. | Tiny / effectively free or very low monthly cost | User goal; refine after AWS account setup. |
| PRE_RELEASE_BRANCH | Branch used for pre-release hosted verification. | `development` | User stated development branch exists. |
| PRODUCTION_BRANCH | Branch used for final public deployment. | `main` recommended, not confirmed | Decide before final Amplify setup. |
| PUBLIC_FORWARDING_PROVIDER | Domain forwarding provider. | GoDaddy | User goal. |
| CONTACT_DESTINATION | Visitor-facing contact destination. | `rani@steveandsonia.com` observed; confirm before publishing | `contact.html`; user confirmation needed. |

## Quality Check
| Req ID | Correct | Clear / Precise | Unambiguous | Objective | Verifiable | Consistent | Issue / Fix |
|---|---|---|---|---|---|---|---|
| REQ-001 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-002 | Yes | Yes | Yes | Yes | Yes | Yes | Content freshness is a product decision. |
| REQ-003 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-004 | Yes | Yes | Yes | Yes | Yes | Yes | Current repo fails due to `kayak.jpg` case mismatch. |
| REQ-005 | Yes | Yes | Yes | Yes | Yes | Yes | Requires visual/browser verification. |
| REQ-006 | Yes | Yes | Yes | Yes | Yes | Yes | Current repo has HTTP jQuery. |
| REQ-007 | Yes | Yes | Yes | Yes | Yes | Yes | Content freshness open. |
| REQ-008 | Yes | Yes | Yes | Yes | Yes | Yes | Content freshness open. |
| REQ-009 | Yes | Yes | Yes | Yes | Yes | Yes | Third-party links may be stale. |
| REQ-010 | Yes | Yes | Yes | Yes | Yes | Yes | None. |
| REQ-011 | Yes | Yes | Yes | Yes | Yes | Yes | Contact destination should be confirmed. |
| REQ-012 | Yes | Yes | Yes | Yes | Yes | Yes | Current repo includes PHP dependency. |
| REQ-013 | Yes | Yes | Yes | Yes | Yes | Yes | Needs implementation decision. |
| REQ-014 | Yes | Yes | Yes | Yes | Yes | Yes | Current repo has `me@example.com`. |
| REQ-015 | Yes | Yes | Yes | Yes | Yes | Yes | Conditional on keeping form. |
| REQ-016 | Yes | Yes | Yes | Yes | Yes | Yes | Conditional on keeping form. |
| REQ-017 | Yes | Yes | Yes | Yes | Yes | Yes | GitHub Pages is current preferred target; AWS remains fallback. |
| REQ-018 | Yes | Yes | Yes | Yes | Yes | Yes | Verify after deploy. |
| REQ-019 | Yes | Yes | Yes | Yes | Yes | Yes | Verify after GoDaddy config. |
| REQ-020 | Yes | Yes | Yes | Yes | Yes | Yes | Needs checklist/script retained or recreated. |
| REQ-021 | Yes | Yes | Yes | Yes | Yes | Yes | Confirm branch mapping. |

## Traceability
| Req ID | Source Use Case / Step | Related Candidate ID(s) | Related Interface | Related State | Related Test |
|---|---|---|---|---|---|
| REQ-001 | UC-001 Step 1 | UC-001-CR-001 | IF-001 | Page Loaded | TEST-002 |
| REQ-002 | UC-001 Step 2 | UC-001-CR-002 | IF-001 | Page Loaded | TEST-002 |
| REQ-003 | UC-001 Step 3, UC-002 Step 1 | UC-001-CR-003, UC-002-CR-001 | IF-001 | Page Loaded | TEST-003 |
| REQ-004 | UC-001 Step 4, UC-001 E1, UC-002 E1 | UC-001-CR-004, UC-001-CR-007, UC-002-CR-006 | IF-003 | Degraded Render | TEST-001, TEST-005 |
| REQ-005 | UC-001 A1 | UC-001-CR-005 | IF-002 | Page Loaded | TEST-003 |
| REQ-006 | UC-001 E2 | UC-001-CR-008 | IF-002 | Degraded Render | TEST-002, TEST-003 |
| REQ-007 | UC-002 Step 2 | UC-002-CR-002 | IF-001 | Travel Page Loaded | TEST-004 |
| REQ-008 | UC-002 Step 3 | UC-002-CR-003 | IF-001 | Travel Page Loaded | TEST-004 |
| REQ-009 | UC-002 Step 4 | UC-002-CR-004 | IF-004 | External Navigation Started | Manual link check |
| REQ-010 | UC-002 A1 | UC-001-CR-006, UC-002-CR-005 | IF-004 | Travel Page Loaded | TEST-004 |
| REQ-011 | UC-003 Step 1, A1 | UC-003-CR-001, UC-003-CR-006 | IF-007 | Editing Contact Form | TEST-006 |
| REQ-012 | UC-003 Step 4, A2 | UC-003-CR-004, UC-003-CR-007 | IF-006 | Static Fallback Needed | TEST-008 |
| REQ-013 | UC-003 Step 5, A2 | UC-003-CR-005, UC-003-CR-007 | IF-007 | Static Fallback Needed | TEST-006 |
| REQ-014 | UC-003 E2 | UC-003-CR-009 | IF-007 | Static Fallback Needed | TEST-007 |
| REQ-015 | UC-003 Step 2, Step 3, E1 | UC-003-CR-002, UC-003-CR-003, UC-003-CR-008 | IF-005 | Validation Failed | Contact form demo |
| REQ-016 | UC-003 E3 | UC-003-CR-010 | IF-006 | Submission Attempted | Backend test if form retained |
| REQ-017 | UC-005 Step 1-2 | UC-005-CR-001, UC-005-CR-002 | IF-008 | Preview Deployed | TEST-009 |
| REQ-018 | UC-005 Step 3 | UC-005-CR-003 | IF-009 | Public Hosted | TEST-009 |
| REQ-019 | UC-005 Step 4 | UC-005-CR-004 | IF-010 | Forwarded | TEST-010 |
| REQ-020 | UC-005 Step 5, E1, E2 | UC-005-CR-005, UC-005-CR-007, UC-005-CR-008 | IF-009, IF-010 | Public Hosted, Forwarded | TEST-011 |
| REQ-021 | UC-005 A1 | UC-005-CR-006 | IF-008 | Preview Deployed | TEST-009 |

## Assumptions
- Static hosting is the near-term target; GitHub Pages is preferred, with AWS as fallback.
- `development` is the pre-release work branch.
- Contact form backend execution is not required for the first hosted static release if direct contact remains available.
- Requirements for actual wedding event planning are historical/current-content questions and not derived beyond what the repository currently shows.

## Gaps and Questions
- Confirm the correct public contact email before publishing.
- Decide whether to keep, remove, or replace the address/contact form.
- Confirm production publication source for GitHub Pages.
- Decide whether stale external links and 2017-era content should be refreshed before public release.
