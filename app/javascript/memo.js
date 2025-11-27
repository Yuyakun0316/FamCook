document.addEventListener("turbo:load", () => {
  const memoForm = document.getElementById("memo-form");
  const categoryField = document.getElementById("memo-category");
  const buttons = document.querySelectorAll(".memo-btn");

  if (!memoForm) return;

  buttons.forEach((btn) => {
    btn.addEventListener("click", () => {
      memoForm.classList.remove("hidden");
      categoryField.value = btn.dataset.category;

      buttons.forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
    });
  });
});
