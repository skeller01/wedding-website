# Prototype Lab

## Prototype Record: Static Gallery Front-End Slice

### Decision
Absorb the Story Cards gallery direction into the production static site as `gallery.html`.

### Question Tested
Can a small static front-end slice make the wedding archive more useful and satisfy an open requirement without adding backend, upload, account, or build-system scope?

### Possible Outcomes Considered
- If no existing images worked well, keep gallery as future scope.
- If a layout needed dynamic behavior, defer until a larger product decision.
- If a simple static layout worked, promote the smallest useful version into the real site.

### Method
UI prototype variants.

### Runnable Artifact
`documentation/planning/working/prototypes/gallery_layout_variants.html`

### Result
Three static variants were created: Memory Wall, Featured Moment, and Story Cards. All 12 prototype image references resolved locally. Story Cards best matched the archive/memory-site direction because each image can carry a short contextual caption and the layout works with a small curated set.

### Interpretation
The gallery requirement did not need a new framework, backend, upload flow, or private album system. The repository already had enough static images to support a first gallery slice.

### What Gets Absorbed
- `gallery.html` as a production static page.
- Navigation link to Gallery on all public pages.
- Gallery CSS in `css/style.css`.
- Requirement status update for `REQ-021`.
- A cleanup step removing public countdown script loads and countdown CSS/commented markup.

### Promotion / Retention Decision
Absorb production code; keep prototype artifact as working evidence for now.

### What Gets Deleted
Nothing from the prototype in this pass. Remaining legacy countdown/validation files are still cleanup candidates.

### Downstream Document Impacts
- `documentation/requirements/requirements.md`: `REQ-021` is implemented; `REQ-020` is partial.
- `documentation/requirements/use-case-requirements.md`: UC-006 is implemented/observed.
- `documentation/requirements/current-state-design.md`: gallery is inside current static site behavior.
- `documentation/planning/deployment-footprint.md`: static scan count and gallery footprint updated.
- `documentation/planning/prd.md`: gallery moved from future planning to initial implemented slice.

### Open Questions
- Which additional photos and final captions should refine the gallery?
- Should remaining unused legacy files be deleted or moved to an explicit archive?
- Should the external hotel/activity links be converted to historical plain text or refreshed current links?
