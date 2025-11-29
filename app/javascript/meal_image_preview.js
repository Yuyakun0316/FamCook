["turbo:load", "turbo:render"].forEach((eventName) => {
  document.addEventListener(eventName, function () {
    const slots = document.querySelectorAll(".image-slot");
    const fileInput = document.getElementById("meal-image-upload");
    const form = document.querySelector("form");
    let filesArray = []; // ← 選択された画像の保持

    if (!fileInput || slots.length === 0 || !form) return;

    // ⚠️ 重複イベントを防ぐ（Turbo遷移時に重要！）
    if (fileInput.dataset.bound === "true") return;
    fileInput.dataset.bound = "true";

    // 📷 各スロットをクリック → ファイル選択
    slots.forEach((slot) => {
      slot.addEventListener("click", () => fileInput.click());
    });

    // 📦 画像選択時
    fileInput.addEventListener("change", (event) => {
      const file = event.target.files[0];
      if (!file || filesArray.length >= 3) return;

      filesArray.push(file); // JS上で保持

      const emptySlot = Array.from(slots).find((slot) => !slot.classList.contains("has-image"));
      if (!emptySlot) return;

      const reader = new FileReader();
      reader.onload = (e) => {
        emptySlot.style.backgroundImage = `url('${e.target.result}')`;
        emptySlot.classList.add("has-image");
        emptySlot.textContent = "";

        // ❌ 削除ボタン
        const deleteBtn = document.createElement("span");
        deleteBtn.className = "delete-btn";
        deleteBtn.textContent = "×";
        emptySlot.appendChild(deleteBtn);

        // 🗑️ 削除処理
        deleteBtn.addEventListener("click", (ev) => {
          ev.stopPropagation();

          // 当前スロットが何番目か確認して一致したファイルを削除
          const slotIndex = Array.from(slots).indexOf(emptySlot);
          filesArray.splice(slotIndex, 1);

          emptySlot.style.backgroundImage = "";
          emptySlot.classList.remove("has-image");
          emptySlot.textContent = "+";
          deleteBtn.remove();
        });
      };

      reader.readAsDataURL(file);
      fileInput.value = ""; // 再選択可能に
    });

    // 📤 フォーム送信時に DataTransfer 経由で filesArray を実際に送信
    form.addEventListener("submit", () => {
      const dataTransfer = new DataTransfer();
      filesArray.forEach((file) => dataTransfer.items.add(file));
      fileInput.files = dataTransfer.files;
    });
  });
});
