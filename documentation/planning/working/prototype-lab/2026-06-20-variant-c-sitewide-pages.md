# Prototype Lab

## Prototype Record: Variant C Sitewide Page Shell

### Decision
Absorb the page-shape direction into the publishable-site hardening sprint as working evidence: use Variant C as the sitewide visual contract for existing pages, with a landing-page pattern for Home and an interior journal-page pattern for Story, Gallery, Info, Hotels, and Syracuse.

Do not copy the throwaway prototype directly into production.

### Question Tested
Can Variant C from `archive_visual_refresh_variants.html` scale across all existing public pages while respecting the active requirements in `documentation/requirements/requirements.md`?

### Possible Outcomes Considered
- If Variant C worked only for Home, keep it as the landing page and use a different interior-page pattern.
- If Variant C made travel/info pages unclear, defer sitewide application and prototype a separate historical-context layout.
- If Variant C worked across the current page set, use it as the implementation direction for the publishable-site hardening sprint.
- If the gallery required new dynamic behavior, defer gallery polish to a separate sprint.

### Method
UI prototype.

A single throwaway static HTML artifact was created with sections representing the current public routes:

- Home / `index.html`
- Story / `about.html`
- Gallery / `gallery.html`
- Info / `contact.html`
- Hotels / `hotels.html`
- Syracuse / `syracuse.html`
- Requirements readout

### Runnable Artifact
`documentation/planning/working/prototypes/variant_c_sitewide_pages.html`

### Result
Variant C works across the current page set if it is treated as two related page patterns:

- **Landing journal:** Home keeps the full Variant C split hero and three chapter links.
- **Interior journal pages:** Existing pages use a compatible journal intro, route/requirement note, readable content band, and cards/lists that avoid the old Bootstrap/event-logistics look.

The prototype shows that the design can support the active requirements without adding new pages, a backend, a build system, upload behavior, forms, accounts, or external runtime dependencies.

Verification performed:

- Local image references in the runnable prototype resolve.
- The prototype includes sections for Home, Story, Gallery, Info, Hotels, Syracuse, and Requirements.
- Source search found no script, form, PHP, or external HTTP dependencies. Terms such as RSVP, upload, and accounts appear only in no-collection policy copy.
- Browser automation was attempted but unavailable in this environment due `codex/sandbox-state-meta: missing field sandboxPolicy`; real visual review remains required before production implementation.

### Interpretation
The production implementation should not try to make every page a full landing page. The better pattern is a shared visual language:

- Home is the emotional entry.
- Story is a readable chapter.
- Gallery is a generated static album page with journal-style cards.
- Info is a no-collection policy/context page.
- Hotels and Syracuse are historical-context chapters.

The gallery can be visually aligned in the first hardening sprint as long as production keeps the existing generated metadata/lightbox seam. A deep lightbox rewrite is not required for the prototype finding.

The safest hero interpretation for publication is a known-good fixed Variant C image until real photo curation proves that the session-stable rotating hero set looks good.

### What Gets Absorbed
- Use Variant C as the sitewide design contract for existing pages.
- Use two patterns: landing journal and interior journal pages.
- Reframe old event logistics as historical archive context instead of active planning content.
- Keep Info as a no-collection page.
- Keep Gallery static and generated; only align presentation unless a later sprint selects deeper gallery work.
- Treat mobile/manual browser review as required acceptance evidence.

### Promotion / Retention Decision
Keep as working evidence and absorb the design direction into `documentation/planning/sprints/2026-06-20-variant-c-publishable-site-hardening.md` during implementation.

### What Gets Deleted
Nothing now. The runnable artifact is a throwaway prototype and can be deleted after the hardening sprint is implemented and accepted.

### Downstream Document Impacts
- Sprint plan: no required change; the existing publishable-site hardening sprint already points at this direction.
- Requirements: no immediate mutation. After implementation, evidence may strengthen REQ-002, REQ-003, REQ-005, REQ-006, REQ-021, REQ-031, and REQ-032.
- Current-state design: update only after production implementation changes the durable page shell.
- Deployment footprint: no change unless release checks or hosting assumptions change.

### Open Questions
- Should production fix the home hero to `images/sonia_steve.jpg` until real photos are curated?
- Should the repeated Sangeet/Ceremony logistics content be removed from most pages or converted into one quieter archive context band?
- Should Gallery polish be included in the hardening sprint or split if lightbox changes expand?
- Who will perform the manual desktop/mobile visual review if browser automation remains unavailable?
