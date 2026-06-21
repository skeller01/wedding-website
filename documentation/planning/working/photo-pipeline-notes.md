# Photo Pipeline Notes

The implementation uses a local PowerShell/.NET tool because this environment does not have Python, Node, Pillow, or ImageMagick available. The behavior still follows the accepted sprint contract:

- originals are ignored under `images/wedding_source/`
- raw curation state is ignored under `.photo-curation/`
- review states are `unreviewed`, `include`, `highlight`, `hero`, and `exclude`
- generated public outputs are committed under `images/gallery/generated/`, `data/gallery-data.json`, and `js/gallery-data.js`
- generated JPEG widths target 480px thumbnails and 1800px large images for every published photo, plus 2400px hero images only for photos marked `hero`
- the public site remains static and no-backend

After the 2026-06-21 curation pass, the real source set generated 185 public photos from 786 originals: 136 include, 37 highlight, 12 hero, and 601 excluded. Generated public output is approximately 107 MB because non-hero photos reuse the large image path for hero metadata instead of creating unused 2400px derivatives.

The command `.\tools\photo-pipeline.ps1 generate -UseExistingAsPlaceholders` rebuilds placeholder public gallery assets from currently checked-in images until the real wedding source photo folder is available.
