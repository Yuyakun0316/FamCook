document.addEventListener("turbo:load", () => {
  const track = document.querySelector(".meal-slider-track");
  if (!track) return;

  const slides = document.querySelectorAll(".meal-slide");
  const prevBtn = document.querySelector(".meal-slider-nav.prev");
  const nextBtn = document.querySelector(".meal-slider-nav.next");

  let currentIndex = 0;
  const totalSlides = slides.length;

  const updateSlider = () => {
    track.style.transition = "transform 0.3s ease";
    track.style.transform = `translateX(-${currentIndex * 100}%)`;
  };

  // ============================================
  // ボタンクリック
  // ============================================
  if (prevBtn && nextBtn && totalSlides > 1) {
    prevBtn.addEventListener("click", () => {
      currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
      updateSlider();
    });

    nextBtn.addEventListener("click", () => {
      currentIndex = (currentIndex + 1) % totalSlides;
      updateSlider();
    });
  }

  // ============================================
  // スワイプ処理（ループ対応・見た目も追従）
  // ============================================
  let startX = 0;
  let currentTranslate = 0;
  let previousTranslate = 0;
  let dragging = false;

  const setPosition = (translate) => {
    track.style.transition = "none";
    track.style.transform = `translateX(${translate}px)`;
  };

  track.addEventListener("touchstart", (e) => {
    if (totalSlides <= 1) return;
    startX = e.touches[0].clientX;
    previousTranslate = -currentIndex * track.clientWidth;
    dragging = true;
  });

  track.addEventListener("touchmove", (e) => {
    if (!dragging) return;
    const x = e.touches[0].clientX;
    currentTranslate = previousTranslate + (x - startX);
    setPosition(currentTranslate);
  });

  track.addEventListener("touchend", () => {
    if (!dragging) return;
    dragging = false;

    const moved = currentTranslate - previousTranslate;

    if (moved < -50) {
      currentIndex = (currentIndex + 1) % totalSlides;
    } else if (moved > 50) {
      currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
    }

    updateSlider();
  });
});
