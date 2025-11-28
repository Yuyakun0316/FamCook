document.addEventListener("turbo:load", () => {
  const deleteButtons = document.querySelectorAll(".memo-delete-btn");

  if (deleteButtons.length === 0) return; // 削除ボタンがないページでは終了

  deleteButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      event.preventDefault();

      if (!confirm("本当に削除しますか？")) return;

      const memoId = button.dataset.memoId;
      const category = button.dataset.category;
      const csrfToken = document.querySelector("meta[name='csrf-token']").content;

      fetch(`/memos/${memoId}?category=${category}`, {
        method: "DELETE",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        }
      })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            // 🧹 その場で要素を消す
            const memoItem = button.closest(".memo-item");
            if (memoItem) memoItem.remove();
          } else {
            alert("削除に失敗しました");
          }
        })
        .catch(error => console.error("通信エラー:", error));
    });
  });
});
