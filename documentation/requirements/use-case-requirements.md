# Use Case Requirements Analysis

## Source Inputs
- `documentation/requirements/current-state-design.md`
- Repository files: `index.html`, `about.html`, `contact.html`, `hotels.html`, `syracuse.html`, `css/style.css`, `js/contact_me.js`, `bin/contact_me.php`
- Prototype scan: `documentation/planning/working/prototypes/static_site_scan.ps1`
- User goal: cheap AWS hosting with GoDaddy URL forwarding

## Use Case Index
| Use Case ID | Use Case Name | Priority | Status | Source |
|---|---|---|---|---|
| UC-001 | View Wedding Information | High | Expanded | Current-state use case diagram |
| UC-002 | Browse Travel and Local Information | High | Expanded | Current-state use case diagram |
| UC-003 | Provide Contact Information | High | Expanded | Current-state use case diagram and code |
| UC-004 | Maintain Website Content | Medium | Indexed only | GitHub/development workflow |
| UC-005 | Deploy Static Website | High | Expanded | User AWS/GoDaddy goal |

## UC-001: View Wedding Information

### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-001 |
| Use Case Name | View Wedding Information |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens the website URL. |
| Goal | Visitor can read key wedding/event information and navigate from the home page. |
| Priority | High |
| Preconditions | Website files are hosted and reachable. |
| Postconditions | Visitor has viewed wedding content or navigated to another page. |
| Evidence | Observed |

### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Browser/static host | AWS host | Visitor requests the website URL. | `GET /` or `GET /index.html` | UC-001-CR-001 | The system shall be able to serve a home page as the default public website entry point. | Proposed/Observed |
| 2 | Visitor | Home page | Browser | System renders the couple names, wedding date, event locations, and call-to-action link. | HTML/CSS/images | UC-001-CR-002 | The system shall be able to present wedding summary information on the home page. | Observed |
| 3 | Visitor | Navigation | Browser | Visitor selects a navigation item. | Internal link click | UC-001-CR-003 | The system shall be able to provide navigation links to the home, about, contact, hotels, and local entertainment pages. | Observed |
| 4 | Browser | Asset layer | CDN/local assets | Browser loads styling, scripts, fonts, and images. | CSS/JS/image requests | UC-001-CR-004 | The system shall be able to load required local assets using deploy-safe paths. | Observed |

### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-001-A1 | Visitor uses mobile viewport | Visitor opens navigation menu. | Bootstrap menu should expose navigation links. | UC-001-CR-005 | The system shall be able to expose primary navigation on mobile viewport widths. | Observed/Inferred |
| UC-001-A2 | External CDN is slow or unavailable | Browser cannot load remote font or library. | Core static content should remain readable. | UC-001-CR-006 | The system shall keep primary textual wedding content readable when nonessential external font resources fail to load. | Inferred |

### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-001-E1 | Local image path is case-mismatched | Image does not render on case-sensitive hosting. | Correct file reference or filename. | UC-001-CR-007 | The system shall use case-correct local asset references for static hosting. | Prototype |
| UC-001-E2 | HTTP script is blocked on HTTPS page | Interactive scripts may not run. | Use HTTPS resource URLs. | UC-001-CR-008 | The system shall request required third-party scripts over HTTPS when the website is served over HTTPS. | Observed/Inferred |

### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-001-CR-001 | The system shall be able to serve a home page as the default public website entry point. | Step 1 | Demonstration |
| UC-001-CR-002 | The system shall be able to present wedding summary information on the home page. | Step 2 | Inspection |
| UC-001-CR-003 | The system shall be able to provide navigation links to the home, about, contact, hotels, and local entertainment pages. | Step 3 | Test |
| UC-001-CR-004 | The system shall be able to load required local assets using deploy-safe paths. | Step 4 | Test |
| UC-001-CR-005 | The system shall be able to expose primary navigation on mobile viewport widths. | Alternate A1 | Demonstration |
| UC-001-CR-006 | The system shall keep primary textual wedding content readable when nonessential external font resources fail to load. | Alternate A2 | Demonstration |
| UC-001-CR-007 | The system shall use case-correct local asset references for static hosting. | Exception E1 | Test |
| UC-001-CR-008 | The system shall request required third-party scripts over HTTPS when the website is served over HTTPS. | Exception E2 | Inspection/Test |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-001 | Browser | Static host | Page request | Visitor opens URL | Inbound |
| IF-002 | Browser | CDN | Bootstrap, jQuery, fonts | Page load | Outbound |
| IF-003 | Browser | Static host | Local image/CSS/JS requests | Page load | Inbound |

### States Discovered
| State | Trigger / Cause | Meaning | Related Step |
|---|---|---|---|
| Page Loaded | Static assets returned | Visitor can read content. | Step 2 |
| Degraded Render | CDN or asset failure | Text may remain readable but styling/interaction may degrade. | Alternate A2 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-001 | Local assets resolve | Run static scan and expect zero missing local references. | Automated script |
| TEST-002 | Home page renders | Open hosted URL and inspect home page content. | Demonstration |
| TEST-003 | Mobile nav renders | Resize browser and verify menu links. | Demonstration |

### Assumptions
- The root website entry should serve `index.html`.
- External fonts are aesthetic rather than required for content comprehension.

### Gaps and Questions
- Confirm whether home page date and event information should remain historical.

### Follow-On Artifacts
- Deployment verification checklist.
- Visual refresh plan if desired.

## UC-002: Browse Travel and Local Information

### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-002 |
| Use Case Name | Browse Travel and Local Information |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor selects Hotels or Local Entertainment. |
| Goal | Visitor can find lodging, venue, and Syracuse activity information. |
| Priority | High |
| Preconditions | Internal pages and image assets are deployed. |
| Postconditions | Visitor has viewed travel/local information or opened an external resource. |
| Evidence | Observed |

### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Navigation | Browser | Visitor opens the hotel dropdown. | Bootstrap dropdown | UC-002-CR-001 | The system shall be able to expose hotel and local entertainment page links from the shared navigation. | Observed |
| 2 | Visitor | Hotels page | Browser | System renders suggested hotel information and local distances. | `hotels.html` | UC-002-CR-002 | The system shall be able to present suggested lodging information for visitors. | Observed |
| 3 | Visitor | Syracuse page | Browser | System renders local activity thumbnails and links. | `syracuse.html` | UC-002-CR-003 | The system shall be able to present local entertainment information for visitors. | Observed |
| 4 | Visitor | External link | Third-party site | Visitor opens a venue, hotel, or activity link. | Outbound URL | UC-002-CR-004 | The system shall be able to provide outbound links to relevant venue, hotel, and local activity resources. | Observed |

### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-A1 | External link is unavailable | Visitor clicks stale third-party URL. | Browser displays third-party failure outside system control. | UC-002-CR-005 | The system shall keep core travel and event information available without requiring third-party links to load. | Inferred |

### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-002-E1 | Local thumbnail path is case-mismatched | Thumbnail image fails to render. | Correct asset case. | UC-002-CR-006 | The system shall use case-correct image references for travel and local information pages. | Prototype |

### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-002-CR-001 | The system shall be able to expose hotel and local entertainment page links from the shared navigation. | Step 1 | Demonstration |
| UC-002-CR-002 | The system shall be able to present suggested lodging information for visitors. | Step 2 | Inspection |
| UC-002-CR-003 | The system shall be able to present local entertainment information for visitors. | Step 3 | Inspection |
| UC-002-CR-004 | The system shall be able to provide outbound links to relevant venue, hotel, and local activity resources. | Step 4 | Inspection |
| UC-002-CR-005 | The system shall keep core travel and event information available without requiring third-party links to load. | Alternate A1 | Demonstration |
| UC-002-CR-006 | The system shall use case-correct image references for travel and local information pages. | Exception E1 | Test |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-004 | Browser | Third-party websites | Outbound link navigation | Visitor clicks link | Outbound | Observed |

### States Discovered
| State | Trigger / Cause | Meaning | Related Step |
|---|---|---|---|
| Travel Page Loaded | Internal page request succeeds | Visitor can inspect hotel/local content. | Steps 2-3 |
| External Navigation Started | Outbound link clicked | Visitor leaves site context. | Step 4 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-004 | Travel/local pages render | Open `hotels.html` and `syracuse.html`. | Demonstration |
| TEST-005 | Local image refs resolve | Run static scan and expect no missing references. | Automated script |

### Assumptions
- Third-party external link freshness is lower priority than internal page correctness.

### Gaps and Questions
- Decide whether to update old hotel/activity links before public hosting.

### Follow-On Artifacts
- External-link review checklist.

## UC-003: Provide Contact Information

### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-003 |
| Use Case Name | Provide Contact Information |
| Primary Actor | Visitor / Guest |
| Trigger | Visitor opens `contact.html` and submits the form or clicks email link. |
| Goal | Visitor can provide address/contact information or reach the couple directly. |
| Priority | High |
| Preconditions | Contact page is hosted; contact channel is configured. |
| Postconditions | Visitor receives a clear success, failure, or alternate contact path. |
| Evidence | Observed with deployment gap |

### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Visitor | Contact page | Browser | Visitor opens `contact.html`. | Page request | UC-003-CR-001 | The system shall be able to present a contact page with a contact channel for visitors. | Observed |
| 2 | Visitor | Contact form | Browser | Visitor enters name, email, address, and note. | Form input | UC-003-CR-002 | The system shall be able to capture visitor name, email, address, and additional message fields when a form contact path is enabled. | Observed |
| 3 | Visitor | Validation script | Browser | Visitor submits the form and fields are validated. | Submit event | UC-003-CR-003 | The system shall be able to validate required contact fields before attempting form submission. | Observed |
| 4 | System | Contact script | Mail endpoint | System attempts Ajax submission. | `POST ./bin/contact_me.php` | UC-003-CR-004 | The system shall not depend on a PHP runtime when deployed as a static website. | Inferred from static hosting goal |
| 5 | System | Contact page | Visitor | System provides success/failure feedback or an alternate direct email path. | UI alert or mailto | UC-003-CR-005 | The system shall provide a clear visitor-visible contact fallback when form submission is unavailable. | Observed/Inferred |

### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-003-A1 | Visitor chooses direct email | Visitor clicks `mailto:` address. | Browser opens configured mail client. | UC-003-CR-006 | The system shall provide a direct email contact option on the contact page. | Observed |
| UC-003-A2 | Minimal static deployment defers form backend | Visitor sees direct email or non-Ajax contact guidance. | No PHP endpoint is required. | UC-003-CR-007 | The system shall preserve contact capability during static deployment without requiring server-side form execution. | Proposed |

### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-003-E1 | Required field missing or email invalid | Validation prevents submission. | Visitor corrects field. | UC-003-CR-008 | The system shall reject incomplete or invalid contact form input before submission when the form is enabled. | Observed |
| UC-003-E2 | PHP endpoint unavailable | Error branch shows failure message. | Replace placeholder email and/or remove Ajax path. | UC-003-CR-009 | The system shall avoid displaying placeholder contact destinations in visitor-facing error states. | Observed |
| UC-003-E3 | PHP endpoint recipient not configured | Submission appears successful but message is not useful. | Configure backend or remove PHP. | UC-003-CR-010 | The system shall route enabled form submissions to a configured recipient. | Observed |

### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-003-CR-001 | The system shall be able to present a contact page with a contact channel for visitors. | Step 1 | Inspection |
| UC-003-CR-002 | The system shall be able to capture visitor name, email, address, and additional message fields when a form contact path is enabled. | Step 2 | Demonstration |
| UC-003-CR-003 | The system shall be able to validate required contact fields before attempting form submission. | Step 3 | Demonstration |
| UC-003-CR-004 | The system shall not depend on a PHP runtime when deployed as a static website. | Step 4 | Analysis |
| UC-003-CR-005 | The system shall provide a clear visitor-visible contact fallback when form submission is unavailable. | Step 5 | Demonstration |
| UC-003-CR-006 | The system shall provide a direct email contact option on the contact page. | Alternate A1 | Inspection |
| UC-003-CR-007 | The system shall preserve contact capability during static deployment without requiring server-side form execution. | Alternate A2 | Demonstration |
| UC-003-CR-008 | The system shall reject incomplete or invalid contact form input before submission when the form is enabled. | Exception E1 | Demonstration |
| UC-003-CR-009 | The system shall avoid displaying placeholder contact destinations in visitor-facing error states. | Exception E2 | Inspection |
| UC-003-CR-010 | The system shall route enabled form submissions to a configured recipient. | Exception E3 | Test |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-005 | Browser/contact form | `js/contact_me.js` | Form values | Submit | Internal client-side |
| IF-006 | `js/contact_me.js` | `bin/contact_me.php` | POST contact payload | Valid submit | Client to server |
| IF-007 | Contact page | Mail client | `mailto:` address | Email link click | Browser to mail client |

### States Discovered
| State | Trigger / Cause | Meaning | Related Step |
|---|---|---|---|
| Editing Contact Form | Contact page loaded | Visitor can enter data. | Step 2 |
| Validation Failed | Missing/invalid field | Visitor must correct input. | Exception E1 |
| Submission Attempted | Ajax POST sent | System depends on endpoint availability. | Step 4 |
| Static Fallback Needed | PHP unavailable | Direct email or alternate form needed. | Alternate A2 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-006 | Static contact fallback | On hosted static URL, verify contact page gives usable contact path without PHP. | Demonstration |
| TEST-007 | No placeholder email | Search visitor-facing assets for `me@example.com`. | Inspection |
| TEST-008 | PHP independence | Static scan flags no required PHP runtime path for public deployment. | Automated script |

### Assumptions
- Static hosting is the immediate target.
- A direct email contact path is acceptable for the first hosted release unless user decides otherwise.

### Gaps and Questions
- Decide whether to remove the form, convert it to `mailto:`, or build a serverless backend later.

### Follow-On Artifacts
- Contact cleanup implementation plan.
- Serverless form PRD only if a real form is required.

## UC-005: Deploy Static Website

### Use Case Summary
| Field | Value |
|---|---|
| Use Case ID | UC-005 |
| Use Case Name | Deploy Static Website |
| Primary Actor | Site Maintainer |
| Trigger | Maintainer wants the GitHub repository hosted cheaply on AWS. |
| Goal | Public visitors can reach the website through an AWS-hosted URL and GoDaddy forwarding. |
| Priority | High |
| Preconditions | GitHub repository exists; AWS account and GoDaddy account are available. |
| Postconditions | Public hosted URL serves the website; GoDaddy forwards to it. |
| Evidence | Proposed from user goal |

### Main Success Scenario
| Step | Actor / Operator | System | External Entity | Behavior | Interface / Message | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|---|---|
| 1 | Maintainer | GitHub repository | GitHub | Maintainer keeps deployable website files in repository. | Git branch | UC-005-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Observed/Proposed |
| 2 | Maintainer | Static hosting | GitHub Pages/static host | Maintainer connects or configures the repository publication source. | GitHub integration | UC-005-CR-002 | The system shall be deployable to a low-cost static hosting service from the GitHub repository. | Proposed |
| 3 | AWS host | Website | Browser | AWS serves public HTTPS URL. | HTTPS request | UC-005-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Proposed |
| 4 | Maintainer | GoDaddy | GoDaddy forwarding | Maintainer forwards custom URL to AWS URL. | Domain forwarding | UC-005-CR-004 | The system shall support access through a GoDaddy-forwarded public URL. | Proposed |
| 5 | Maintainer | Website | Browser | Maintainer verifies pages, assets, navigation, and contact path. | Acceptance check | UC-005-CR-005 | The system shall provide a post-deployment verification path for pages, assets, navigation, and contact behavior. | Proposed |

### Alternate Flows
| Flow ID | Condition | Steps | System Response | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-005-A1 | Development branch is used for preview | Maintainer deploys `development` before `main`. | Hosted preview supports review before production. | UC-005-CR-006 | The deployment process shall allow a non-main branch to be used for pre-release verification. | User workflow |

### Exception Flows
| Flow ID | Failure / Exception | System Response | Recovery / Mitigation | Candidate Requirement ID | Candidate Requirement | Evidence |
|---|---|---|---|---|---|---|
| UC-005-E1 | Static scan fails | Deployment should be delayed or corrected. | Fix missing assets/PHP dependency before public forwarding. | UC-005-CR-007 | The deployment process shall identify missing local asset references before public release. | Prototype |
| UC-005-E2 | GoDaddy forwarding points to wrong URL | Public URL fails or shows wrong content. | Correct target and retest. | UC-005-CR-008 | The deployment process shall verify the GoDaddy-forwarded URL after configuration. | Proposed |

### Derived Requirements
| Candidate Requirement ID | Candidate Requirement | Source Step | Verification Method |
|---|---|---|---|
| UC-005-CR-001 | The system shall maintain deployable static website files in the GitHub repository. | Step 1 | Inspection |
| UC-005-CR-002 | The system shall be deployable to a low-cost static hosting service from the GitHub repository. | Step 2 | Demonstration |
| UC-005-CR-003 | The system shall be publicly reachable through an HTTPS hosting URL after deployment. | Step 3 | Demonstration |
| UC-005-CR-004 | The system shall support access through a GoDaddy-forwarded public URL. | Step 4 | Demonstration |
| UC-005-CR-005 | The system shall provide a post-deployment verification path for pages, assets, navigation, and contact behavior. | Step 5 | Test |
| UC-005-CR-006 | The deployment process shall allow a non-main branch to be used for pre-release verification. | Alternate A1 | Demonstration |
| UC-005-CR-007 | The deployment process shall identify missing local asset references before public release. | Exception E1 | Test |
| UC-005-CR-008 | The deployment process shall verify the GoDaddy-forwarded URL after configuration. | Exception E2 | Demonstration |

### Interfaces Discovered
| Interface ID | Source | Target | Message / Data | Trigger | Direction | Evidence |
|---|---|---|---|---|---|---|
| IF-008 | GitHub | AWS static host | Repository branch content | Deploy | GitHub to AWS |
| IF-009 | Browser | AWS static host | HTTPS requests | Visitor opens hosted URL | Browser to AWS |
| IF-010 | GoDaddy | AWS hosted URL | Forwarded request | Visitor opens custom domain | GoDaddy to AWS |

### States Discovered
| State | Trigger / Cause | Meaning | Related Step |
|---|---|---|---|
| Preview Deployed | Development branch connected | Site can be reviewed before main release. | Alternate A1 |
| Public Hosted | AWS deploy succeeds | Site has hosted URL. | Step 3 |
| Forwarded | GoDaddy forwarding succeeds | Custom URL reaches hosted site. | Step 4 |

### Test Implications
| Test ID | Behavior or Requirement | Test Idea | Method |
|---|---|---|---|
| TEST-009 | AWS hosted URL | Open AWS URL and verify pages. | Demonstration |
| TEST-010 | GoDaddy forwarding | Open custom URL and confirm expected page. | Demonstration |
| TEST-011 | Pre-release scan | Run static scan before forwarding. | Automated script |

### Assumptions
- AWS Amplify Hosting is the recommended low-change AWS target.
- GoDaddy forwarding is acceptable instead of DNS delegation.

### Gaps and Questions
- Confirm exact production branch after preview: `main`, `development`, or both environments.

### Follow-On Artifacts
- Deployment footprint.
- Sprint plan for hosting cleanup and deployment.
