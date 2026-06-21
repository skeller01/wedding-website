# Sprint Plan: Local Photo Curation Pipeline

## Source Inputs
- User grilling decisions from 2026-06-20:
  - Original wedding photos should be ignored with `.gitignore`.
  - Originals can live at `images/wedding_source/`.
  - The review tool should be a local browser app.
  - Curation state should use JSON.
  - Raw curation state beside originals should be private/ignored.
  - Generated public metadata/assets should be committed.
  - Review workflow should support `unreviewed`, `include`, `highlight`, `hero`, and `exclude`.
  - Public gallery default should publish all non-excluded photos.
  - Folder structure should be preserved as album sections, with display-name overrides.
  - Local tool should support keyboard shortcuts and basic folder-level actions.
  - Hidden-by-default excluded photos should remain filterable.
  - Duplicate detection can wait.
  - Hero images must be explicit, with focal-point metadata.
  - Album cover selection should be supported, with fallback to first included photo.
  - Generator should create JPEG outputs: `thumb` 480px wide, `large` 1800px wide, `hero` 2400px wide.
  - Generator should produce a manifest/report.
  - Generated outputs can be fully replaced each run.
- `documentation/planning/prd.md`
- `documentation/planning/deployment-footprint.md`
- `documentation/requirements/requirements.md`
- `documentation/requirements/use-case-requirements.md`
- `documentation/requirements/current-state-design.md`
- `documentation/planning/working/prototype-lab/2026-06-20-static-gallery-front-end.md`
- `documentation/planning/working/prototype-lab/2026-06-20-archive-visual-refresh.md`

## Sprint Goal
Create a private local photo review and generation pipeline that can scan ignored originals, help the owner mark photos, and generate static web-ready gallery assets plus public-safe metadata.

## Branch / PR Intent
- Suggested branch: `feature/local-photo-curation-pipeline`
- Draft PR title: `Add local wedding photo curation pipeline`
- Draft PR summary: Add an ignored source-photo convention, a local Python/Pillow review app and generator, curation JSON handling, generated asset output structure, and a generation report without changing the public gallery behavior yet.

## Scope Decision
This sprint is first because the photo repository is not available yet and the public gallery should not be redesigned around unknown assets. A local-only pipeline lets the project absorb hundreds of photos safely while preserving the static GitHub Pages architecture.

## Selected Requirements
| Requirement | Planned Sprint Status | Why Included | Planned Evidence | Planned Commit |
|---|---|---|---|---|
| REQ-004 Resolve Local Assets | Planned | Generated assets must use deploy-safe, case-correct output paths. | Generator report and static/reference checks on generated fixture output. | Add deterministic generation outputs |
| REQ-016 Verify Public Release | Planned | The generator report becomes a release confidence input. | Manifest/report with counts and warnings. | Add generation report |
| REQ-018 Support Static Maintenance | Planned | The tool keeps photo maintenance local and static-site friendly. | Local app command and JSON workflow documented. | Add local review app |
| REQ-021 Support Static Photo Gallery | Planned | Generated assets and metadata are the input to the future public gallery sprint. | `gallery-data.json`, thumbs/large/hero outputs from fixture images. | Add curation schema and generator |

## Use Cases / Flows Touched
| Use Case / Flow | Sprint Impact | Notes |
|---|---|---|
| UC-005 Maintain Archive Content | Adds a local maintenance workflow for source photos and generated assets. | Public site behavior should not change in this sprint. |
| UC-006 View Static Photo Gallery | Prepares generated data/assets for the future gallery. | The public gallery integration is Sprint 2. |

## Prototype Findings To Absorb
| Finding | Decision | Sprint Impact |
|---|---|---|
| Static gallery should remain no-backend/no-upload. | Absorb | Tool runs locally; public output remains static. |
| Full original repository may contain hundreds of photos. | Absorb | Generate thumbnails and large images for selected public photos, plus hero images only for explicit hero photos. |
| Folder structure should be preserved. | Absorb | Album data is derived from folders with display-name overrides. |
| Hero selection should be explicit. | Absorb | Only `hero` photos enter generated hero set. |
| Visual refresh should not be production-absorbed from prototype. | Defer | No public redesign in this sprint. |

## Vertical Slice
A maintainer can place photos in ignored `images/wedding_source/`, run a local Python review app, mark photos and album settings, generate web-sized JPEG assets and `gallery-data.json`, and inspect a report showing source, published, excluded, hero, warning, and output counts.

## Commit Plan
| Commit | Purpose | Requirements | Tests / Checks |
|---|---|---|---|
| 1 | Define ignored source and generated asset conventions. | REQ-018, REQ-021 | `git status --ignored`; source folder ignored, generated folder tracked intentionally. |
| 2 | Add curation JSON schema and fixture-based generator. | REQ-004, REQ-021 | Unit tests for path-derived IDs, album mapping, and output dimensions. |
| 3 | Add local browser review app for grid triage. | REQ-018, REQ-021 | Local app smoke test; keyboard/button state updates write JSON. |
| 4 | Add generation report and warnings. | REQ-016, REQ-021 | Report fixture test includes counts and warnings. |
| 5 | Document local workflow and handoff to public gallery sprint. | REQ-018 | README/sprint closure inspection. |

## Test Plan
| Seam | Behavior | Test Type | Planned Test |
|---|---|---|---|
| Curation schema | Photo and album metadata round-trips through JSON. | Unit | Test load/save defaults, state changes, folder display names, focal points. |
| Generator | Source images create deterministic `thumb`, `large`, and `hero` JPEGs. | Unit/integration | Fixture image generation with width assertions: 480/1800/2400 maximums. |
| ID generation | File-path-derived IDs are stable and collision-safe. | Unit | Test duplicate names from different folders. |
| Review app | Grid, filters, folder actions, and keyboard shortcuts update JSON. | Smoke/manual | Local browser smoke using fixture photos. |
| Report | Counts and warnings are visible after generation. | Unit/smoke | Report includes albums/source/published/excluded/hero/warnings. |

## Check Sequence
1. Confirm working tree is clean or only contains this sprint's files.
2. Add `.gitignore` entries for `images/wedding_source/` and raw curation state.
3. Add a small fixture set from existing repo images or test fixtures.
4. Implement generator with Pillow.
5. Implement curation JSON load/save and local review app.
6. Run focused tests for schema/generator/report.
7. Run local app smoke test.
8. Run static scan to ensure public site is unchanged.
9. Check `git status --ignored` to verify originals stay ignored and generated public assets are trackable.

## Documentation Impact
| Artifact | Expected Action | Reason |
|---|---|---|
| `documentation/planning/sprints/2026-06-20-local-photo-curation-pipeline.md` | Close with implementation evidence. | Sprint contract. |
| Tool README or `documentation/planning/working/photo-pipeline-notes.md` | Add workflow commands and source/generated folder rules. | Maintainer usability. |
| `documentation/requirements/requirements.md` | Update only after implementation if behavior/status changes are promoted. | Requirements policy: no planning mutation. |
| Prototype-lab records | Preserve. | Evidence for decisions. |

## Out of Scope
- Public gallery/lightbox integration.
- Home hero rotation on the public site.
- WebP generation.
- Face detection, blur scoring, duplicate detection, or AI ranking.
- Cloud uploads or remote photo storage.
- Committing full-resolution originals.

## Risks and Dependencies
- Real photo repository may have unusual formats, nested folders, huge files, or duplicate filenames.
- Pillow must be added as a local tooling dependency without implying a public-site build step.
- A local browser review app needs a clear command and should not expose files outside intended folders.
- Generated outputs may approach GitHub Pages size limits if compression defaults are too generous.

## Definition of Done
- `images/wedding_source/` and private curation state are ignored.
- Local review app can load fixture/source folders and update JSON.
- Generator creates `thumb`, `large`, and `hero` JPEG outputs.
- Generated metadata includes albums, path-derived IDs, states, folder display names, album covers, focal points, and output paths.
- Report shows counts and warnings.
- Tests/checks pass.
- Public website behavior is unchanged except for any intentionally committed generated fixtures, if approved.

## PR Checklist
- [x] Originals and raw curation state are ignored.
- [x] No full-resolution originals are committed.
- [x] Generated public outputs are deterministic.
- [x] Keyboard shortcuts and visible controls both work in the local review app.
- [x] Folder-level defaults and display-name overrides work.
- [x] Hero/focal point metadata is supported.
- [x] Generation report is produced.
- [x] Static scan still passes.
- [x] Sprint implementation evidence is filled in.

## Implementation Evidence
Implemented 2026-06-20 by `implement-change`. The local tooling was implemented in PowerShell/.NET rather than Python/Pillow because this environment has no Python, Node, Pillow, or ImageMagick runtime available. The behavior and public/private boundaries follow the sprint contract.

| Requirement | Final Status | Implementation Evidence | Test Evidence | Commit / PR | Notes |
|---|---|---|---|---|---|
| REQ-022 Provide Local Photo Review | Implemented | `tools/photo-pipeline.ps1 serve`; local review HTML/API | Localhost smoke: `/` and `/api/photos` returned 200; temp source image appeared in API | Pending | Uses `TcpListener` to avoid unsupported `HttpListener`. |
| REQ-023 Maintain Private Curation State | Implemented | `.photo-curation/curation.json`; review API writes JSON | `tools/photo-pipeline.tests.ps1`; local review API smoke | Pending | Private state is ignored. |
| REQ-024 Exclude Private Photo Inputs | Implemented | `.gitignore` ignores `images/wedding_source/` and `.photo-curation/` | `git status --ignored` showed `.photo-curation/` ignored | Pending | No originals committed. |
| REQ-026 Generate Optimized Photo Assets | Implemented | `tools/photo-pipeline.ps1 generate`; `images/gallery/generated/` | Pipeline test plus generated width check: 24 thumbs/large/hero, 0 violations | Pending | Placeholder outputs generated from existing images until real photos arrive. |
| REQ-027 Generate Public Gallery Metadata | Implemented | `data/gallery-data.json`; `js/gallery-data.js` | Static scan and metadata inspection | Pending | Includes albums, public image paths, focal points, and hero list. |
| REQ-028 Report Gallery Generation Results | Implemented | `images/gallery/generated/generation-report.json` | Report shows 24 published placeholder photos, 1 album, warnings for ID collisions | Pending | Report is committed public evidence. |
| REQ-029 Provide Stable Photo IDs | Implemented | Path-derived ID generation in `tools/photo-pipeline.ps1` | Pipeline test covers duplicate names from different folders | Pending | Placeholder `champ` duplicate IDs were collision-safe. |
| REQ-030 Avoid Stale Generated Outputs | Implemented | Generator removes/replaces `images/gallery/generated/` per run | Regeneration completed successfully | Pending | Intended full replacement behavior. |

## Cleanup / Deferred
- Real wedding source photos are not available yet; current generated assets are placeholders from existing checked-in images.
- If Python/Pillow becomes available and preferred later, the PowerShell tool can be ported without changing the public metadata contract.

## Implementation Handoff
Use this sprint file for `implement-change`. Start with the `.gitignore` and fixture-driven generator tests before building the local browser app. Do not modify the public gallery page or home design in this sprint. Close this plan with actual commands, test evidence, cleanup notes, and `Commit / PR` values.
