  const initMealRating = () => {
    const stars = document.querySelectorAll("#star-rating .star");
    const hiddenRatingField = document.getElementById("hidden-rating-field");
    const form = document.querySelector("form[action*='comments']");

    if (!hiddenRatingField || stars.length === 0 || !form) return;
    if (form.dataset.bound === "true") return;
    form.dataset.bound = "true";

    let selectedRating = Number(hiddenRatingField.value) || 0;

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

      star.addEventListener("mouseover", () => updateStars(Number(star.dataset.value)));
      star.addEventListener("mouseleave", () => updateStars(selectedRating));
    });

    form.addEventListener("submit", (event) => {
      if (selectedRating === 0) {
        alert("⭐ 評価を選択してください！");
        return;
      }
      event.preventDefault();

      const formData = new FormData(form);
      const csrfToken = document.querySelector("meta[name='csrf-token']").content;

      fetch(form.action, {
        method: "POST",
        headers: { "X-CSRF-Token": csrfToken, "Accept": "application/json" },
        body: formData
      })
        .then(response => response.json())
        .then(data => {
          if (!data.success) {
            alert("投稿に失敗しました:\n" + data.errors.join(", "));
            return;
          }

          // 入力リセット
          form.reset();
          selectedRating = 0;
          hiddenRatingField.value = 0;
          updateStars(0);

          // コメント反映
          const commentList = document.querySelector(".meal-comment-list");
          if (commentList && data.comment_html) {
            const firstComment = commentList.querySelector(".comment-card");
            if (firstComment) {
              firstComment.insertAdjacentHTML("beforebegin", data.comment_html);
            } else {
              commentList.insertAdjacentHTML("beforeend", data.comment_html);
            }
          }

          // ⭐ 平均評価リアルタイム更新
          const avgArea = document.querySelector("#average-rating-area");
          if (avgArea && data.average_rating_html) {
            avgArea.innerHTML = data.average_rating_html;
          }

          // 「まだコメントありません」削除
          const noCommentMsg = document.querySelector(".no-comments");
          if (noCommentMsg) noCommentMsg.remove();
        })
        .catch(error => console.error("通信エラー:", error));
    });
  };

  // 🚀 ページ読み込み時（リロード回避）
  ["turbo:load", "turbo:render", "DOMContentLoaded"].forEach((eventName) => {
    document.addEventListener(eventName, initMealRating);
  });
