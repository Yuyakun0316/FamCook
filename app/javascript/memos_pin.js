document.addEventListener("turbo:load", () => {
  const pinButtons = document.querySelectorAll(".memo-pin-btn");

  if (pinButtons.length === 0) return; // ピンボタンがないページでは終了

  pinButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      event.preventDefault();

      const memoId = button.dataset.memoId;
      const category = button.dataset.category;
      const csrfToken = document.querySelector("meta[name='csrf-token']").content;

      fetch(`/memos/${memoId}/toggle_pin?category=${category}`, {
        method: "PATCH",
        headers: {
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          button.textContent = data.pinned ? "📍" : "📌";
          button.classList.toggle("pinned", data.pinned);
        } else {
          alert("ピン更新に失敗しました");
        }
      })
      .catch(error => console.error("通信エラー:", error));
    });
  });
});
