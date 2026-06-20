(function () {
  "use strict";

  var hero = document.getElementById("archive-hero");
  if (!hero) return;
  var heroImage = document.getElementById("archive-hero-image");

  var data = window.WEDDING_GALLERY_DATA || {};
  var heroPhotos = (data.heroPhotos || []).filter(function (photo) {
    return photo && photo.hero;
  });
  var fallback = hero.getAttribute("data-fallback-hero") || "images/white_flowers.jpg";
  var storageKey = "weddingArchiveHeroId";

  function chooseHero() {
    if (!heroPhotos.length) {
      return null;
    }
    var saved = window.sessionStorage ? sessionStorage.getItem(storageKey) : "";
    var match = heroPhotos.find(function (photo) {
      return photo.id === saved;
    });
    if (match) return match;

    var next = heroPhotos[Math.floor(Math.random() * heroPhotos.length)];
    if (window.sessionStorage) {
      sessionStorage.setItem(storageKey, next.id);
    }
    return next;
  }

  function applyHero(photo) {
    var src = photo ? photo.hero : fallback;
    var point = photo && photo.focalPoint ? photo.focalPoint : { x: 50, y: 50 };
    if (heroImage) {
      heroImage.src = src;
      heroImage.style.objectPosition = Number(point.x || 50) + "% " + Number(point.y || 50) + "%";
    }
  }

  applyHero(chooseHero());
})();
