document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll("#star-rating .star");
  const hiddenRatingField = document.getElementById("hidden-rating-field");

  // ⭐ 新規投稿時は空なので必ず 0 からスタート
  let selectedRating = hiddenRatingField.value ? Number(hiddenRatingField.value) : 0;

  const updateStars = (rating) => {
    stars.forEach((star, index) => {
      star.classList.toggle("active", index < rating);
    });
  };

  updateStars(selectedRating);

  stars.forEach((star) => {
    star.addEventListener("click", () => {
      selectedRating = Number(star.dataset.value);
      hiddenRatingField.value = selectedRating;
      updateStars(selectedRating);
    });

    // ホバー時
    star.addEventListener("mouseover", () => {
      updateStars(Number(star.dataset.value));
    });

    // ホバー外れたら元に戻す
    star.addEventListener("mouseleave", () => {
      updateStars(selectedRating);
    });
  });
});
