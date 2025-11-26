document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll("#star-rating .star");
  const hiddenRatingField = document.getElementById("hidden-rating-field");
  let selectedRating = hiddenRatingField.value || 0;

  const updateStars = (rating) => {
    stars.forEach((star, index) => {
      star.classList.toggle("active", index < rating);
    });
  };

  updateStars(selectedRating);

  stars.forEach((star) => {
    star.addEventListener("click", () => {
      selectedRating = star.getAttribute("data-value");
      hiddenRatingField.value = selectedRating;
      updateStars(selectedRating);
    });

    // ホバーで一時的な視覚反応
    star.addEventListener("mouseover", () => {
      updateStars(star.getAttribute("data-value"));
    });

    star.addEventListener("mouseleave", () => {
      updateStars(selectedRating);
    });
  });
});
