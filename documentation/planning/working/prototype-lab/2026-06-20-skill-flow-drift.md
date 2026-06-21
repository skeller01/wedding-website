# Prototype Lab

## Prototype Record: Skill Flow Drift Investigation

### Decision
Keep this as working evidence and use it to plan a small process/documentation cleanup sprint. The current skill flow is mostly sound, but it lacks a single mandatory roll-up step that synchronizes sprint index status, accepted implementation deviations, historical labels, and cleanup-candidate lifecycle after implementation.

### Question Tested
Did the way our user-created skills hand work from prototype to sprint to implementation to durable docs contribute to the current documentation/code-coherency issues?

### Possible Outcomes Considered
- If each skill had a clear owner for the stale fields, the drift would be mostly execution error.
- If the skills intentionally scoped those fields out, the drift would be a workflow seam problem.
- If the docs themselves disagreed on authority, the issue would require a documentation authority model before more implementation.

### Method
Logic/state prototype plus repository scan. I reviewed the relevant skill contracts and added a disposable PowerShell probe that scans sprint status drift, implementation-choice drift, historical mention hotspots, and remaining legacy cleanup candidates.

### Runnable Artifact
`documentation/planning/working/prototypes/skill_flow_drift_probe.ps1`

### Result
The probe and manual review support the workflow-seam explanation:

- Five sprint index rows are still marked `Planned` even though their sprint files contain implementation evidence: Local Photo Curation Pipeline, Generated Gallery and Lightbox, Archive Visual Refresh, Variant C Publishable Site Hardening, and Remove Contact Page Links.
- `prd.md` still mentions `Python/Pillow`, while current requirements and photo-pipeline notes mention the implemented `PowerShell/.NET` tool.
- Historical references to `contact.html` and six-page assumptions cluster in sprint/prototype/refactor history. Some are valid history, but the index/status layer does not make the current/superseded boundary obvious enough.
- Legacy cleanup candidates still exist in the repository: `js/app.js`, `js/jquery.countdown.js`, `js/jqBootstrapValidation.js`, and `css/jquery.countdown.js`.
- Sprint files can be closed by `implement-change`, but `sprint-planner` only creates the sprint index and does not own post-implementation roll-up status.
- `implement-change` updates durable docs selectively, but it does not have an explicit "implementation deviation must update PRD baseline" rule. That let the PowerShell/.NET photo-pipeline implementation coexist with an older PRD line preferring Python/Pillow.
- `prototype-lab` correctly preserves throwaway records as working evidence, but the broader documentation system does not yet require old route/page assumptions to be labeled superseded in the index layer.
- `refactor-planner` correctly identifies cleanup candidates, and `implement-change` avoids scope creep. Together, that leaves unused CSS/JS assets visible until a specific cleanup sprint selects them.

### Interpretation
The issues happened because the skills are individually careful and conservative. That is good for avoiding accidental overreach, but it creates small gaps between artifacts:

- Planning creates expected status.
- Implementation closes local evidence.
- Durable docs update when behavior changes.
- Historical prototype/sprint records remain untouched.
- Cleanup candidates are recorded, not automatically deleted.

No single skill currently performs a final "repository truth reconciliation" pass across all those layers.

### What Gets Absorbed
Recommended future workflow rules:

- Add a sprint-closure roll-up step after `implement-change`: update `documentation/planning/sprints/README.md` when a sprint file has implementation evidence.
- Add an implementation-deviation rule: when implementation uses a different stack or approach than the PRD baseline, update the PRD conflict/implementation decision line or record a durable deviation note.
- Add a historical-artifact label convention: prototype and sprint docs may keep old facts, but their index entries should say current, implemented, superseded, fallback, or historical.
- Add a cleanup-candidate lifecycle: when code cleanup is intentionally deferred, route it to `refactor-plan.md`, `requirements.md` status, or a sprint backlog row instead of leaving it as tribal memory.

### Promotion / Retention Decision
Absorbed into the 2026-06-20 documentation coherence pass. Keep this record as working evidence for why the sprint index, PRD implementation baseline, documentation guide, and refactor plan were updated.

### Absorption Update
The immediate repo-specific findings from this prototype have been addressed:

- Sprint index statuses now roll up implemented/superseded/historical/fallback state.
- PRD now treats PowerShell/.NET as the implemented photo-pipeline baseline.
- Current-state and requirements docs now describe the generated gallery and local photo pipeline as implemented current behavior.
- The documentation guide now includes a truth-reconciliation rule for future work.

Open process improvement remains optional: update the actual `.codex` skills so future sprint closure performs this roll-up automatically.

### What Gets Deleted
The probe script is disposable. It can be deleted after its findings are absorbed into a sprint or skill-improvement plan.

### Downstream Document Impacts
- `documentation/planning/sprints/README.md`: should be updated in a cleanup sprint to distinguish planned, implemented, fallback, historical, and superseded.
- `documentation/planning/prd.md`: should replace the stale Python/Pillow preference with the implemented PowerShell/.NET baseline or a note that Python/Pillow is only a future portability option.
- `documentation/README.md`: could add a short "truth reconciliation" rule explaining how durable docs, sprint records, and working evidence relate.
- `.codex` skills: consider small updates to `implement-change`, `sprint-planner`, and maybe `prototype-lab` so this drift is less likely next time.

### Open Questions
- Should we update the actual user-created skills in `.codex`, or keep this repo-specific as a sprint/process checklist?
- Should sprint index status be manually curated, or should we add a small maintained status-check script?
- Should old prototypes be explicitly marked superseded in the prototype index once their production sprint is implemented?
