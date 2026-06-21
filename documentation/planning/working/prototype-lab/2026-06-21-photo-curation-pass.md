# Prototype Lab

## Prototype Record: Can Codex Curate The Real Wedding Photo Set For GitHub Pages?

### Decision
Publish a curated 185-photo public gallery from the 786 local originals: 136 include photos, 37 highlights, and 12 hero photos. Exclude the remaining 601 photos from generated public output.

### Question Tested
Can a fast 1-3 pass visual curation process produce a public wedding-gallery set that feels complete without exceeding a practical GitHub Pages/repository footprint?

### Possible Outcomes Considered
- Publish fewer than 100 photos if the source set was highly repetitive or weak.
- Publish roughly 120-200 photos if the photographer highlight export had enough variety.
- Pause for owner review if the set contained many ambiguous/private moments.
- Reduce generated derivatives if the selected set was good but generated output was too large.

### Method
Visual curation prototype plus scoped production pipeline optimization. Contact sheets were generated from the 786 originals, then reviewed in sequence. The selection favored the photographer `HIGHLIGHTS` export, preserved story coverage across preparation, details, procession, theater ceremony, family, speeches, couple portraits, and reception/dance, and avoided adjacent-frame repetition.

### Runnable Artifact
[photo_curation_contact_sheets.ps1](../prototypes/photo_curation_contact_sheets.ps1) and [apply_photo_curation_selection.ps1](../prototypes/apply_photo_curation_selection.ps1)

### Result
The curation state now selects 185 public photos from 786 source photos. Generation report: 185 published, 601 excluded, 12 heroes, 1 album.

Initial generation produced about 266 MB because the pipeline generated 2400px hero copies for every public photo. A scoped pipeline change now generates hero derivatives only for actual hero photos, reducing generated gallery output to about 107.23 MB: 7.48 MB thumbnails, 89.35 MB large images, and 10.39 MB hero images.

### Interpretation
The 185-photo set is GitHub-suitable and visitor-suitable. It is large enough to feel like a real album, but constrained enough to avoid publishing the entire proof set. The optimized derivative strategy keeps the repository footprint reasonable without changing public gallery behavior.

### What Gets Absorbed
- Curation decision: only explicitly selected photos are public; unselected photos are excluded.
- Pipeline behavior: generate full hero derivatives only for photos marked `hero`.
- Test expectation: non-hero photo metadata may reuse the large image path for hero fallback metadata.

### Promotion / Retention Decision
Absorb the generated gallery and pipeline optimization into production. Keep contact sheets and curation scripts as temporary working evidence until the owner accepts the selection, then they can be deleted or archived.

### What Gets Deleted
Nothing deleted automatically from prototype evidence. Future cleanup can remove `documentation/planning/working/prototypes/photo-curation/` and the two prototype scripts after owner review.

### Downstream Document Impacts
Deployment footprint can be lightly refreshed later with the final generated gallery size if this selection is accepted. Requirements do not need a scope change because this remains within the existing static generated gallery workflow.

### Open Questions
- Should any sensitive/private photos be manually removed after owner review?
- Should captions or album sections be added, or is a single chronological wedding archive album enough for launch?
