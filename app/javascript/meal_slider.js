document.addEventListener("turbo:load", () => {
  const track = document.querySelector(".meal-slider-track");
  if (!track) return;

  const slides = document.querySelectorAll(".meal-slide");
  const prevBtn = document.querySelector(".meal-slider-nav.prev");
  const nextBtn = document.querySelector(".meal-slider-nav.next");

  let currentIndex = 0;
  const totalSlides = slides.length;

  const updateSlider = () => {
    track.style.transform = `translateX(-${currentIndex * 100}%)`;
  };

  prevBtn.addEventListener("click", () => {
    currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
    updateSlider();
  });

  nextBtn.addEventListener("click", () => {
    currentIndex = (currentIndex + 1) % totalSlides;
    updateSlider();
  });

  // ============================================
  // ✨ スワイプ（タッチ）対応
  // ============================================
  let startX = 0;
  let moveX = 0;
  let isDragging = false;

  // 指が触れた時
  track.addEventListener("touchstart", (e) => {
    startX = e.touches[0].clientX;
    isDragging = true;
  });

  // 触れたまま動かす時
  track.addEventListener("touchmove", (e) => {
    if (!isDragging) return;
    moveX = e.touches[0].clientX - startX;
  });

  // 指を離した時
  track.addEventListener("touchend", () => {
    isDragging = false;

    // スワイプ距離が50px以上なら判定
    if (Math.abs(moveX) > 50) {
      if (moveX < 0) {
        // 左スワイプ → 次へ
        currentIndex = (currentIndex + 1) % totalSlides;
      } else {
        // 右スワイプ → 前へ
        currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
      }
      updateSlider();
    }

    moveX = 0;
  });

  // ============================================
  // ✨ スワイプ（ドラッグ操作）対応（PC用）
  // ============================================
  track.addEventListener("mousedown", (e) => {
    startX = e.clientX;
    isDragging = true;
  });

  track.addEventListener("mousemove", (e) => {
    if (!isDragging) return;
    moveX = e.clientX - startX;
  });

  track.addEventListener("mouseup", () => {
    if (!isDragging) return;
    isDragging = false;

    if (Math.abs(moveX) > 50) {
      if (moveX < 0) {
        currentIndex = (currentIndex + 1) % totalSlides;
      } else {
        currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
      }
      updateSlider();
    }

    moveX = 0;
  });
});
