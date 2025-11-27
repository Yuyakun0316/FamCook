document.addEventListener("turbo:load", () => {
  const buttons = document.querySelectorAll(".memo-btn");
  const memoForm = document.getElementById("memo-form");
  const memoCategory = document.getElementById("memo-category");

  // 📌 要素が存在しないページでは処理しない（安全対策）
  if (!memoForm || !memoCategory) return;

  const textarea = memoForm.querySelector("textarea");

  // 🔹 URL パラメータからカテゴリ取得
  const currentCategory = new URLSearchParams(window.location.search).get("category");

  // 🔹 ページ読み込み時に該当ボタンを active にする
  if (currentCategory) {
    buttons.forEach((btn) => {
      if (btn.dataset.category === currentCategory) {
        btn.classList.add("active");
        memoForm.classList.remove("hidden");
        memoCategory.value = currentCategory;
      }
    });
  }

  // 🔹 クリックイベント
  buttons.forEach((button) => {
    button.addEventListener("click", () => {
      buttons.forEach((btn) => btn.classList.remove("active"));
      button.classList.add("active");
      memoCategory.value = button.dataset.category;
      textarea.value = ""; // ← ここも memoForm がある時だけ
      memoForm.classList.remove("hidden");
    });
  });
});
