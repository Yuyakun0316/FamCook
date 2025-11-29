["turbo:load", "turbo:render"].forEach((eventName) => {
  document.addEventListener(eventName, () => {
    const stars = document.querySelectorAll("#star-rating .star");
    const hiddenRatingField = document.getElementById("hidden-rating-field");
    const form = document.querySelector("form[action*='comments']");

    // ❗ 該当ページのみ処理
    if (!hiddenRatingField || stars.length === 0 || !form) return;

    // 🔥 ⭐ここでイベントの多重登録防止！
    if (form.dataset.bound === "true") return;
    form.dataset.bound = "true";

    let selectedRating = Number(hiddenRatingField.value) || 0;

    const updateStars = (rating) => {
      stars.forEach((star, index) => {
        star.classList.toggle("active", index < rating);
      });
    };

    // 初期状態反映
    updateStars(selectedRating);

    // ⭐ 星クリック・ホバー処理
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
      // ⭐ 未選択チェック
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

            // 🔁 入力リセット
            form.reset();
            selectedRating = 0;
            hiddenRatingField.value = 0;
            updateStars(0);

            // 🆕 最新コメントを最上部に挿入
            const commentList = document.querySelector(".meal-comment-list");
            if (commentList && data.comment_html) {
              const firstComment = commentList.querySelector(".comment-card");
              if (firstComment) {
                firstComment.insertAdjacentHTML("beforebegin", data.comment_html);
              } else {
                commentList.insertAdjacentHTML("beforeend", data.comment_html);
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
