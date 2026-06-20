(function () {
  "use strict";

  var data = window.WEDDING_GALLERY_DATA || { albums: [], photos: [] };
  var albumsRoot = document.getElementById("gallery-albums");
  var summary = document.getElementById("gallery-summary");
  var lightbox = document.getElementById("gallery-lightbox");
  var lightboxImage = document.getElementById("lightbox-image");
  var lightboxTitle = document.getElementById("lightbox-title");
  var lightboxCount = document.getElementById("lightbox-count");
  var currentIndex = -1;
  var photos = (data.photos || []).filter(function (photo) {
    return photo.state !== "exclude";
  });

  function appendText(element, value) {
    element.appendChild(document.createTextNode(value || ""));
  }

  function setFocalPoint(image, photo) {
    var point = photo.focalPoint || { x: 50, y: 50 };
    image.style.objectPosition = Number(point.x || 50) + "% " + Number(point.y || 50) + "%";
  }

  function renderGallery() {
    if (!albumsRoot) return;
    albumsRoot.innerHTML = "";
    if (!photos.length) {
      summary.textContent = "No public gallery photos have been generated yet.";
      return;
    }

    summary.textContent = photos.length + " photos across " + (data.albums || []).length + " album" + ((data.albums || []).length === 1 ? "" : "s") + ".";

    (data.albums || []).forEach(function (album) {
      var albumPhotos = photos.filter(function (photo) {
        return photo.albumId === album.id;
      });
      if (!albumPhotos.length) return;

      var section = document.createElement("section");
      section.className = "album-section";
      section.id = "album-" + album.id;

      var header = document.createElement("div");
      header.className = "album-header";
      var title = document.createElement("h3");
      appendText(title, album.name || album.id);
      var count = document.createElement("p");
      appendText(count, albumPhotos.length + " photos");
      header.appendChild(title);
      header.appendChild(count);

      var grid = document.createElement("div");
      grid.className = "generated-gallery-grid";

      albumPhotos.forEach(function (photo) {
        var index = photos.indexOf(photo);
        var button = document.createElement("button");
        button.className = "generated-gallery-card";
        button.type = "button";
        button.setAttribute("data-photo-id", photo.id);
        button.setAttribute("aria-label", "Open " + (photo.title || "photo"));

        var image = document.createElement("img");
        image.loading = "lazy";
        image.src = photo.thumb;
        image.alt = photo.alt || photo.title || "Wedding photo";
        setFocalPoint(image, photo);

        var caption = document.createElement("span");
        caption.className = "generated-gallery-caption";
        appendText(caption, photo.title || "Wedding photo");

        button.appendChild(image);
        button.appendChild(caption);
        button.addEventListener("click", function () {
          openPhoto(index, true);
        });
        grid.appendChild(button);
      });

      section.appendChild(header);
      section.appendChild(grid);
      albumsRoot.appendChild(section);
    });
  }

  function openPhoto(index, updateHash) {
    if (!photos.length || !lightbox) return;
    currentIndex = (index + photos.length) % photos.length;
    var photo = photos[currentIndex];
    lightboxImage.src = photo.large || photo.hero || photo.thumb;
    lightboxImage.alt = photo.alt || photo.title || "Wedding photo";
    setFocalPoint(lightboxImage, photo);
    lightboxTitle.textContent = photo.caption || photo.title || "Wedding photo";
    lightboxCount.textContent = (currentIndex + 1) + " of " + photos.length;
    lightbox.classList.add("is-open");
    lightbox.setAttribute("aria-hidden", "false");
    document.body.classList.add("lightbox-open");
    if (updateHash) {
      history.replaceState(null, "", "#photo=" + encodeURIComponent(photo.id));
    }
  }

  function closePhoto() {
    if (!lightbox) return;
    lightbox.classList.remove("is-open");
    lightbox.setAttribute("aria-hidden", "true");
    document.body.classList.remove("lightbox-open");
    lightboxImage.removeAttribute("src");
    if (location.hash.indexOf("#photo=") === 0) {
      history.replaceState(null, "", location.pathname + location.search);
    }
  }

  function openFromHash() {
    if (location.hash.indexOf("#photo=") !== 0) return;
    var id = decodeURIComponent(location.hash.replace("#photo=", ""));
    var index = photos.findIndex(function (photo) { return photo.id === id; });
    if (index >= 0) {
      openPhoto(index, false);
    }
  }

  document.addEventListener("click", function (event) {
    if (event.target.matches("[data-gallery-close]")) closePhoto();
    if (event.target.matches("[data-gallery-prev]")) openPhoto(currentIndex - 1, true);
    if (event.target.matches("[data-gallery-next]")) openPhoto(currentIndex + 1, true);
    if (event.target === lightbox) closePhoto();
  });

  document.addEventListener("keydown", function (event) {
    if (!lightbox || !lightbox.classList.contains("is-open")) return;
    if (event.key === "Escape") closePhoto();
    if (event.key === "ArrowLeft") openPhoto(currentIndex - 1, true);
    if (event.key === "ArrowRight") openPhoto(currentIndex + 1, true);
  });

  window.addEventListener("hashchange", openFromHash);
  renderGallery();
  openFromHash();
})();
