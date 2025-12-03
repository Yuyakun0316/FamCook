document.addEventListener("turbo:load", () => {
  const track = document.querySelector(".meal-slider-track");
  if (!track) return; // ← スライダーが無いページでは終了

  const slides = document.querySelectorAll(".meal-slide");
  const prevBtn = document.querySelector(".meal-slider-nav.prev");
  const nextBtn = document.querySelector(".meal-slider-nav.next");

  let currentIndex = 0;
  const totalSlides = slides.length;

  const updateSlider = () => {
    track.style.transform = `translateX(-${currentIndex * 100}%)`;
  };

  // ============================================
  // 🔒 ボタンが無い（画像1枚）ならイベントを付けない
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
  // ✨ スワイプ（タッチ操作）
  // → 画像1枚でも問題なし
  // ============================================
  let startX = 0;
  let moveX = 0;
  let isDragging = false;

  track.addEventListener("touchstart", (e) => {
    if (totalSlides <= 1) return; // ← スワイプも1枚なら無効化
    startX = e.touches[0].clientX;
    isDragging = true;
  });

  track.addEventListener("touchmove", (e) => {
    if (!isDragging || totalSlides <= 1) return;
    moveX = e.touches[0].clientX - startX;
  });

  track.addEventListener("touchend", () => {
    if (totalSlides <= 1) return;

    isDragging = false;

    if (Math.abs(moveX) > 50) {
      currentIndex = moveX < 0
        ? (currentIndex + 1) % totalSlides
        : (currentIndex - 1 + totalSlides) % totalSlides;

      updateSlider();
    }

    moveX = 0;
  });

  // ============================================
  // ✨ PC ドラッグ対応
  // ============================================
  track.addEventListener("mousedown", (e) => {
    if (totalSlides <= 1) return;
    startX = e.clientX;
    isDragging = true;
  });

  track.addEventListener("mousemove", (e) => {
    if (!isDragging || totalSlides <= 1) return;
    moveX = e.clientX - startX;
  });

  track.addEventListener("mouseup", () => {
    if (!isDragging || totalSlides <= 1) return;

    isDragging = false;

    if (Math.abs(moveX) > 50) {
      currentIndex = moveX < 0
        ? (currentIndex + 1) % totalSlides
        : (currentIndex - 1 + totalSlides) % totalSlides;

      updateSlider();
    }

    moveX = 0;
  });
});
