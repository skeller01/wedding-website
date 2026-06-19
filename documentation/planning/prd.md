# Product Requirements Document

## Decision Update
Current recommendation: publish first with GitHub Pages, not AWS Amplify.

Reason: the user clarified that the site is mostly static wedding information, future photos may be added later, RSVP/email/forms are no longer needed, and cheapest possible hosting is the priority. A hosting comparison prototype in `documentation/planning/working/prototype-lab.md` selected GitHub Pages + cleaned HTTPS CDNs as the best first release path. AWS Amplify is now a fallback if GitHub Pages is blocked.

## Source Inputs
- Current user direction: make the wedding website available publicly through cheap AWS hosting and GoDaddy forwarding, with openness to future patches that improve fit and appearance.
- Repository files: root HTML pages, CSS, JavaScript, image assets, PHP contact script.
- Requirements artifacts: `documentation/requirements/current-state-design.md`, `documentation/requirements/use-case-requirements.md`, `documentation/requirements/requirements.md`.
- Deployment artifact: `documentation/planning/deployment-footprint.md`.
- Prototype artifact: `documentation/planning/working/prototype-lab.md` and static scan scripts.

## Document Mode
Existing repository analysis with a recommended MVP release slice for public static hosting.

## Conflict Notes
No material source conflicts were found. The main architecture mismatch is observed rather than contradictory: the repository contains a PHP contact endpoint, while the user's target deployment is cheap static AWS hosting.

## Decision Resolution Notes
- Recommended hosting default: GitHub Pages from the existing GitHub repository, because it is the cheapest path for a static public site when repository visibility/account support allows it.
- Recommended first release branch: deploy `development` first as a preview, then decide whether `main` becomes the public production branch.
- Recommended contact default: remove or simplify obsolete form behavior because RSVP, email collection, and backend form handling are no longer needed.
- No grilling question is blocking the PRD because the recommended defaults are reversible and match the stated low-cost/minimal-change goal.

## Problem Statement
The owner has an existing wedding website in a local/GitHub repository and wants people to be able to view it through a public URL without paying for or operating a traditional web server.

## Product Goal
Publish the existing site cheaply and reliably enough that visitors can open a GoDaddy-forwarded URL, view the wedding content, navigate the pages, and use a clear contact path.

## Users and Stakeholders
| Actor / Stakeholder | Need | Evidence |
|---|---|---|
| Visitor / Guest | View wedding, hotel, local activity, and contact information. | Site content and use cases. |
| Site Maintainer | Make small safe changes, deploy from GitHub, and avoid direct commits to `main`. | User branch workflow. |
| Domain Owner | Forward GoDaddy URL to public hosted site. | User goal. |
| AWS Account Owner | Keep cost and operational complexity low. | User goal. |

## Solution Summary
Use the existing static site as the product foundation, clean up static-hosting blockers, publish with GitHub Pages, and optionally point GoDaddy forwarding or a GitHub Pages custom domain at the published URL.

## Scope

### In Scope
- Document current website behavior and architecture.
- Preserve the existing static pages and visual direction unless a patch improves deployability or polish.
- Fix static deployment blockers before public release.
- Host the site on AWS using a very low-cost static hosting approach.
- Verify the hosted URL and GoDaddy-forwarded URL.

### Out of Scope
- Full backend application hosting.
- Database-backed RSVP/address collection.
- Authentication or admin editing UI.
- Route 53 DNS migration unless the user later prefers it.
- Major redesign before the first hosted release.

## Recommended MVP / Release Slice
MVP: a static, publicly hosted version of the current site.

Included:
- Home, About, Contact, Hotels, and Local Entertainment pages.
- Correct local asset paths.
- HTTPS-safe external script references.
- Static-compatible contact path.
- Amplify-hosted URL.
- GoDaddy forwarding verification.

Deferred:
- Real serverless contact form.
- Full visual redesign.
- Static site generator/template refactor.
- Ongoing monitoring/analytics.

## User Stories
1. As a visitor, I want to open the website URL so that I can view the wedding information.
2. As a visitor, I want to navigate to hotel and local entertainment pages so that I can plan travel.
3. As a visitor, I want a working contact option so that I can reach the couple or provide information.
4. As the site maintainer, I want to deploy from GitHub so that updates do not require manual file uploads.
5. As the domain owner, I want GoDaddy forwarding to reach the hosted site so that visitors can use the public URL I control.

## Functional Expectations
- The site opens at `index.html`.
- Navigation exposes all five public pages.
- Images, CSS, and JavaScript load on case-sensitive static hosting.
- Contact page does not promise a form submission path that cannot work on static hosting.
- Public hosted URL and GoDaddy-forwarded URL show the expected site.

## Baseline Approach
Baseline implementation direction:
- Keep the website static for the first release.
- Use GitHub Pages for GitHub-connected HTTPS static hosting.
- Deploy `development` first.
- Fix the known scan issues before public forwarding.
- Use a direct email/static fallback for contact unless a backend form becomes a separate feature.

## Non-Functional Expectations
| Area | Expectation | Evidence / Status |
|---|---|---|
| Cost | Tiny/prototype cost class. | Deployment footprint. |
| Security | Avoid mixed HTTP script loading on HTTPS pages. | FMEA and requirements. |
| Privacy | Do not collect address data through an unmaintained PHP endpoint. | Contact flow analysis. |
| Reliability | Core content remains readable even if third-party links fail. | Requirements. |
| Maintainability | Keep changes minimal for MVP; consider templates later. | Current duplicated markup. |
| Deployment | GitHub-to-AWS deploy with branch verification. | Deployment footprint. |

## Candidate Requirements
- Serve `index.html` as the default entry point.
- Provide internal navigation to all public pages.
- Resolve all local asset references with case-correct paths.
- Use HTTPS for required third-party scripts.
- Provide a visitor-usable contact channel without requiring PHP on static hosting.
- Deploy from GitHub to low-cost static hosting.
- Verify the AWS hosted URL and GoDaddy-forwarded URL before public release.

## Implementation Decisions
- Treat `bin/contact_me.php` as incompatible with the MVP deployment target.
- Keep the repository as plain static files for now; no build system is required.
- Preserve `development` as the working branch for pre-release changes.
- Use the static scan prototype or a future cleaned-up version as a release check.

## Test Seams
- Static reference scan: catches missing local files, case mismatches, and server runtime dependencies.
- Hosted browser smoke test: verifies pages, navigation, images, and contact behavior.
- GoDaddy forwarding check: verifies the public custom URL reaches the hosted site.

## Testing Decisions
- Run the static scan before deployment and after contact/asset cleanup.
- Manually inspect each public page after Amplify deploy.
- Verify mobile navigation at least once because Bootstrap menu behavior depends on JavaScript.
- Verify contact page wording and behavior on the hosted URL.

## Release and Rollout
1. Commit documentation and cleanup changes on `development`.
2. Deploy `development` through Amplify as a preview.
3. Verify scan, hosted pages, navigation, and contact behavior.
4. Merge or promote to `main` when ready, if `main` is chosen for production.
5. Configure GoDaddy forwarding to the final Amplify URL.
6. Verify the GoDaddy-forwarded URL.

Rollback:
- Revert the problematic commit and let Amplify redeploy, or repoint Amplify to the previous good branch/commit.
- Remove or update GoDaddy forwarding if the public URL should be paused.

## Risks and Tradeoffs
| Risk / Tradeoff | Impact | Mitigation |
|---|---|---|
| PHP contact form fails on static host | Visitors cannot submit form | Convert contact to static-compatible flow. |
| Mixed HTTP jQuery under HTTPS | Interactive behavior may fail | Use HTTPS script URL. |
| Case-sensitive image mismatch | Broken image after deploy | Fix path or filename. |
| External links are stale | Visitors may hit dead third-party pages | Review high-value links when polishing. |
| GoDaddy forwarding is simple but less integrated than DNS | Redirect behavior may be less seamless | Accept for MVP; migrate DNS later only if needed. |

## Success Metrics
| Metric | Target or Placeholder | Measurement Method | Source / Status |
|---|---|---|---|
| Static scan missing references | 0 | Run scan | Prototype-derived |
| Static scan server runtime blockers | 0 for MVP | Run scan | Prototype-derived |
| Public page smoke test | 5/5 pages load | Manual browser check | Proposed |
| Hosted HTTPS URL | Available | Open Amplify URL | Proposed |
| GoDaddy forwarding | Reaches hosted site | Open public URL | Proposed |
| Monthly hosting cost | HOSTING_COST_TARGET | AWS bill review | Requirement constant |

## Assumptions
- The first release should favor speed, low cost, and minimal changes over redesign.
- Visitors do not need login, RSVP database storage, or personalized content.
- The contact email visible in `contact.html` is close to the intended public contact, but should be confirmed.

## Gaps and Questions
- Confirm exact public contact email.
- Decide whether to keep the address form visually or simplify contact content.
- Decide whether to update historical wedding date/content before public release.
- Confirm whether final production deployment should track `main` or remain on `development`.

## Follow-On Artifacts
- Current state design: created.
- Use case diagram: created.
- Use case behavioral matrix: created.
- Requirements: created.
- Deployment footprint: created.
- Class diagram: created.
- Sequence diagram: created.
- FFBD: created.
- IDEF0: created.
- FMEA: created.
- Sprint plan: recommended next, after choosing the contact behavior.

## Cleanup / PR Hygiene
- Keep durable docs in `documentation/planning/` and `documentation/requirements/`.
- Treat `documentation/planning/working/prototypes/*` as disposable verification aids unless promoted into a real script location.
- Before PR/merge, decide whether to keep the prototype scanner, replace it with a polished script, or remove it after findings are implemented.
