# Wedding Photo Pipeline

Local originals should go in `images/wedding_source/`, which is ignored by Git. Private curation state is written to `.photo-curation/curation.json`, also ignored.

Commands:

```powershell
.\tools\photo-pipeline.ps1 init
.\tools\photo-pipeline.ps1 serve
.\tools\photo-pipeline.ps1 generate
```

Until the real wedding photo folder is available, placeholder generated assets can be rebuilt from the existing checked-in images:

```powershell
.\tools\photo-pipeline.ps1 generate -UseExistingAsPlaceholders
```

Generated public outputs are committed:

- `images/gallery/generated/`
- `data/gallery-data.json`
- `js/gallery-data.js`

The generator creates thumbnail and large derivatives for every published photo. It creates 2400px hero derivatives only for photos marked `hero`; non-hero metadata reuses the large image path for hero fallback compatibility.

The public site reads generated metadata only; it does not expose originals, uploads, accounts, comments, or backend photo management.
