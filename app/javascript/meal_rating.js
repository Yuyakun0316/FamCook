["turbo:load", "turbo:render"].forEach((eventName) => {
  document.addEventListener(eventName, () => {
    const stars = document.querySelectorAll("#star-rating .star");
    const hiddenRatingField = document.getElementById("hidden-rating-field");
    const form = document.querySelector("form[action*='comments']");

    // ⭐ 星評価UIが存在しないページでは処理しない
    if (!hiddenRatingField || stars.length === 0 || !form) return;

    let selectedRating = Number(hiddenRatingField.value) || 0;

    const updateStars = (rating) => {
      stars.forEach((star, index) => {
        star.classList.toggle("active", index < rating);
      });
    };

    // ページ読み込み時も反映
    updateStars(selectedRating);

    // ⭐ 星クリック
    stars.forEach((star) => {
      star.addEventListener("click", () => {
        selectedRating = Number(star.dataset.value);
        hiddenRatingField.value = selectedRating;
        updateStars(selectedRating);
      });

      star.addEventListener("mouseover", () => {
        updateStars(Number(star.dataset.value));
      });

      star.addEventListener("mouseleave", () => {
        updateStars(selectedRating);
      });
    });

    // 🚀 Ajax送信
    form.addEventListener("submit", (event) => {
      if (selectedRating === 0) {
        alert("⭐ 評価を選択してください！");
        return;
      }

      event.preventDefault();

      const formData = new FormData(form);
      const url = form.action;
      const csrfToken = document.querySelector("meta[name='csrf-token']").content;

      fetch(url, {
        method: "POST",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: formData
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            console.log("コメントを投稿しました");

            // 🔁 リセット
            form.reset();
            selectedRating = 0;
            hiddenRatingField.value = 0;
            updateStars(0);

            // 🆕 最新コメントをトップに追加
            const commentList = document.querySelector(".meal-comment-list");
            if (commentList && data.comment_html) {
              const header = commentList.querySelector("h3");
              if (header) {
                header.insertAdjacentHTML("afterend", data.comment_html);
              } else {
                commentList.insertAdjacentHTML("afterbegin", data.comment_html);
              }
            }
          } else {
            alert("投稿に失敗しました:\n" + data.errors.join(", "));
          }
        })
        .catch(error => console.error("通信エラー:", error));
    });
  });
});
