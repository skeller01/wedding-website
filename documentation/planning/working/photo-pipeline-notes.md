# Photo Pipeline Notes

The implementation uses a local PowerShell/.NET tool because this environment does not have Python, Node, Pillow, or ImageMagick available. The behavior still follows the accepted sprint contract:

- originals are ignored under `images/wedding_source/`
- raw curation state is ignored under `.photo-curation/`
- review states are `unreviewed`, `include`, `highlight`, `hero`, and `exclude`
- generated public outputs are committed under `images/gallery/generated/`, `data/gallery-data.json`, and `js/gallery-data.js`
- generated JPEG widths target 480px thumbnails, 1800px large images, and 2400px hero images
- the public site remains static and no-backend

The command `.\tools\photo-pipeline.ps1 generate -UseExistingAsPlaceholders` rebuilds placeholder public gallery assets from currently checked-in images until the real wedding source photo folder is available.
