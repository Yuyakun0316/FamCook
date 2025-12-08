require 'rails_helper'

RSpec.describe "Memos", type: :system do
  let!(:family) { FactoryBot.create(:family) }
  let!(:user)   { FactoryBot.create(:user, family: family) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  it "カテゴリ付きでメモを投稿できる" do
    visit memos_path(category: "shopping")

    fill_in "ここにメモを書いてください", with: "玉ねぎを買う"
    click_button "保存する"

    expect(page).to have_content("玉ねぎを買う")
    expect(page).to have_content("🛒 買い物")
  end

  it "内容が空だと投稿できない" do
    visit memos_path(category: "note")

    fill_in "ここにメモを書いてください", with: ""
    click_button "保存する"

    # 画面が遷移していない（失敗）
    expect(page).to have_current_path(memos_path)

    # まだフォームが見えている（送信できていない）
    expect(page).to have_button("保存する")
  end

  it "自分のメモはピン切り替えできる" do
    memo = FactoryBot.create(:memo, user: user, family: family, content: "牛乳買う", pinned: false)

    # ピン切替実行（システムテストで JS 触らずに HTTP リクエスト）
    page.driver.submit :patch, toggle_pin_memo_path(memo), {}
    memo.reload

    expect(memo.pinned).to eq(true)
  end

  it "自分のメモは削除できる" do
    memo = FactoryBot.create(:memo, user: user, family: family, content: "砂糖を買う")

    page.driver.submit :delete, memo_path(memo), {}

    expect(Memo.exists?(memo.id)).to eq(false)
  end

  it "他人のメモは削除ボタンが表示されない" do
    other_user = FactoryBot.create(:user, family: family)
    FactoryBot.create(:memo, user: other_user, family: family, content: "他人のメモ")

    visit memos_path

    expect(page).not_to have_selector(".memo-delete-btn")
  end
end
