document.addEventListener("turbo:load", () => {
  const stars = document.querySelectorAll("#star-rating .star");
  const hiddenRatingField = document.getElementById("hidden-rating-field");
  const form = document.querySelector("form[action*='comments']"); // コメント投稿フォーム

  // ⭐ 星評価UIがないページでは処理しない
  if (!hiddenRatingField || stars.length === 0 || !form) return;

  let selectedRating = Number(hiddenRatingField.value) || 0;

  const updateStars = (rating) => {
    stars.forEach((star, index) => {
      star.classList.toggle("active", index < rating);
    });
  };

  updateStars(selectedRating);

  // ⭐ 星クリック時
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

  // 🚀 Ajax送信（フォーム送信イベントを上書き）
  form.addEventListener("submit", (event) => {
    // ⭐ ＜必須項目チェック＞星が未選択なら送信しない
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

          // 🔁 フォーム内容リセット
          form.reset();
          selectedRating = 0;
          hiddenRatingField.value = 0;
          updateStars(0);

          // 🆕 【ポイント】最新コメントを一番上に追加！
          const commentList = document.querySelector(".meal-comment-list");
          if (commentList && data.comment_html) {
            const header = commentList.querySelector("h3"); // タイトルの直下に挿入
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
