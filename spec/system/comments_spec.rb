require "rails_helper"

RSpec.describe "Comments", type: :system do
  let!(:family) { FactoryBot.create(:family) }
  let!(:user)   { FactoryBot.create(:user, family: family) }
  let!(:meal)   { FactoryBot.create(:meal, user: user, family: family) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  it "星とコメントを投稿できる" do
    visit meal_path(meal)

    # 👉 rating(hidden_field) を直接セット
    find("#hidden-rating-field", visible: false).set(4)

    fill_in "コメントを入力（任意）", with: "美味しかったです！"
    click_button "送信する"

    expect(page).to have_content("美味しかったです！")
    expect(page).to have_selector(".star.filled", count: 4)
  end

  it "自分のコメントは削除できる" do
    # 先にコメントを作る
    FactoryBot.create(:comment, user: user, meal: meal, rating: 4, content: "削除テスト")

    visit meal_path(meal)

    expect(page).to have_content("削除テスト")

    # 🗑 削除
    click_button "🗑️"

    # 🎯 削除されたことを確認
    expect(page).not_to have_content("削除テスト")
  end

  it "他人のコメントは削除できない" do
    other_user = FactoryBot.create(:user, family: family)
    FactoryBot.create(:comment, user: other_user, meal: meal, rating: 5, content: "他の人のコメント")

    visit meal_path(meal)

    expect(page).to have_content("他の人のコメント")
    expect(page).not_to have_button("🗑️")
  end
end
