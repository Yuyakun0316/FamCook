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
        // 🎯 画像を背景ではなく「imgタグ」で表示＋しっかり中央寄せ
        emptySlot.innerHTML = `<img src="${e.target.result}" alt="meal image">`;
        emptySlot.classList.add("has-image");

        // 🗑️ 削除ボタン
        const deleteBtn = document.createElement("span");
        deleteBtn.className = "delete-btn";
        deleteBtn.textContent = "×";
        emptySlot.appendChild(deleteBtn);

        // 🔁 削除処理
        deleteBtn.addEventListener("click", (ev) => {
          ev.stopPropagation();

          // 何番目のスロットか確認し filesArray から削除
          const slotIndex = Array.from(slots).indexOf(emptySlot);
          filesArray.splice(slotIndex, 1);

          // スロットの初期化
          emptySlot.innerHTML = "+";
          emptySlot.classList.remove("has-image");
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
