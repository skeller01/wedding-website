# Prototype Lab

## Prototype Record: Archive Visual Refresh Direction

### Decision
Keep this as working evidence and use it to inform a future sprint plan. Do not absorb directly into production.

### Question Tested
Which small visual direction would most improve the wedding archive feel without adding a build step, backend, dynamic gallery behavior, or production implementation during prototype work?

### Possible Outcomes Considered
- If the existing Bootstrap look was sufficient, recommend only minor copy/photo curation.
- If a gallery-only improvement carried the site, recommend gallery refinement first.
- If the home page felt like the highest-leverage issue, recommend a home-page archive landing sprint.

### Method
UI prototype variants.

### Runnable Artifact
`documentation/planning/working/prototypes/archive_visual_refresh_variants.html`

### Result
Three structurally different visual directions were prototyped:

- Variant A: full-bleed archive hero with a compact memory strip.
- Variant B: museum-wall layout with a sticky explanation rail and curated image records.
- Variant C: photo-first journal layout with chapter links.

The strongest direction is a combination of Variant A and Variant C: a more emotional archive landing page with chapter-style navigation into story, gallery, info, and travel context. Variant B is better suited to gallery refinement than the home page.

### Interpretation
The current site can look significantly better without new architecture. The main issue is not missing functionality; it is that the home page still reads like an event-info site. A visual pass should make the site feel like a preserved memory archive.

### What Gets Absorbed
Nothing yet. Candidate ideas for a later sprint:

- Replace the current home hero treatment with a calmer image-backed archive landing.
- Add a compact memory strip or chapter navigation below the hero.
- Reduce Bootstrap button noise in the nav and page CTAs.
- Reuse a consistent caption pattern across gallery and story content.

### Promotion / Retention Decision
Keep as working evidence. Promote only after a sprint is planned and approved.

### What Gets Deleted
Nothing now. The throwaway prototype can be deleted after the visual direction is accepted or superseded.

### Downstream Document Impacts
Recommended future updates only:

- Sprint plan: create a small `archive-visual-refresh` sprint.
- PRD/requirements: no changes unless the sprint is accepted.
- Tests: static scan, five-page smoke, mobile navigation smoke, and visual checks for home/gallery.

### Open Questions
- Should the first visual sprint target home only, or home plus gallery?
- Which photo should be the permanent home-page anchor image?
- How polished should the old travel/hotel pages become versus remaining historical context?
