(function () {
  "use strict";

  var hero = document.getElementById("archive-hero");
  if (!hero) return;
  var heroImage = document.getElementById("archive-hero-image");
  var heroMode = hero.getAttribute("data-hero-mode") || "random";

  var data = window.WEDDING_GALLERY_DATA || {};
  var heroPhotos = (data.heroPhotos || []).filter(function (photo) {
    return photo && photo.hero;
  });
  var fallback = hero.getAttribute("data-fallback-hero") || "images/white_flowers.jpg";
  var storageKey = "weddingArchiveHeroId";

  function chooseHero() {
    if (heroMode === "fixed" || !heroPhotos.length) {
      return null;
    }
    var saved = getStoredHeroId();
    var match = heroPhotos.find(function (photo) {
      return photo.id === saved;
    });
    if (match) return match;

    var next = heroPhotos[Math.floor(Math.random() * heroPhotos.length)];
    setStoredHeroId(next.id);
    return next;
  }

  function getStoredHeroId() {
    try {
      return window.sessionStorage ? sessionStorage.getItem(storageKey) : "";
    } catch (error) {
      return "";
    }
  }

  function setStoredHeroId(id) {
    try {
      if (window.sessionStorage) {
        sessionStorage.setItem(storageKey, id);
      }
    } catch (error) {
      return;
    }
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
