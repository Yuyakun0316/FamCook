["turbo:load", "turbo:render"].forEach((eventName) => {
  document.addEventListener(eventName, () => {
    const sliders = document.querySelectorAll(".meal-slider");
    if (!sliders.length) return;

    sliders.forEach((slider) => {
      const track  = slider.querySelector(".meal-slider-track");
      const slides = slider.querySelectorAll(".meal-slide");
      const prev   = slider.querySelector(".meal-slider-nav.prev");
      const next   = slider.querySelector(".meal-slider-nav.next");

      if (!track || slides.length <= 1) return; // 1枚だけならスライド無し

      let index = 0;

      const update = () => {
        track.style.transform = `translateX(-${index * 100}%)`;
      };

      prev?.addEventListener("click", () => {
        index = (index - 1 + slides.length) % slides.length;
        update();
      });

      next?.addEventListener("click", () => {
        index = (index + 1) % slides.length;
        update();
      });

      // 初期表示
      update();
    });
  });
});
