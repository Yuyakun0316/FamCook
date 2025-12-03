# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "meal_image_preview", to: "meal_image_preview.js"
pin "meal_rating", to: "meal_rating.js"
pin "memo",        to: "memo.js"
pin "memos_pin",   to: "memos_pin.js"
pin "memo_delete", to: "memo_delete.js"
pin "meal_slider", to: "meal_slider.js"