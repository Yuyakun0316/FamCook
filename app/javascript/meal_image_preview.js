document.addEventListener("turbo:load", function () {
  const slots = document.querySelectorAll(".image-slot");
  const fileInput = document.getElementById("meal-image-upload");
  let filesArray = []; // ← JSで選択された画像を保持

  if (!fileInput || slots.length === 0) return;

  // 各スロットをクリック → 画像選択
  slots.forEach((slot, index) => {
    slot.addEventListener("click", () => fileInput.click());
  });

  // 画像選択された時
  fileInput.addEventListener("change", (event) => {
    const file = event.target.files[0];
    if (!file || filesArray.length >= 3) return;

    filesArray.push(file); // ← 配列に保持

    const emptySlot = Array.from(slots).find((slot) => !slot.classList.contains("has-image"));
    if (!emptySlot) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      emptySlot.style.backgroundImage = `url('${e.target.result}')`;
      emptySlot.classList.add("has-image");
      emptySlot.textContent = "";

      // ❌ 画像削除ボタン
      const deleteBtn = document.createElement("span");
      deleteBtn.className = "delete-btn";
      deleteBtn.textContent = "×";
      emptySlot.appendChild(deleteBtn);

      // ❗削除処理
      deleteBtn.addEventListener("click", (ev) => {
        ev.stopPropagation();

        const index = Array.from(slots).indexOf(emptySlot);
        filesArray.splice(index, 1); // メモリ上から削除

        emptySlot.style.backgroundImage = "";
        emptySlot.classList.remove("has-image");
        emptySlot.textContent = "+";
        deleteBtn.remove();
      });
    };

    reader.readAsDataURL(file);
    fileInput.value = ""; // 再選択可能にする
  });

  // 🚀 投稿時に filesArray を input に挿入
  const form = document.querySelector("form");
  form.addEventListener("submit", () => {
    const dataTransfer = new DataTransfer();
    filesArray.forEach((file) => dataTransfer.items.add(file));
    fileInput.files = dataTransfer.files;
  });
});