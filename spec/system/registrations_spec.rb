# spec/system/registrations_spec.rb
require 'rails_helper'

RSpec.describe "User Registration", type: :system do
  before do
    driven_by(:rack_test)
  end

  let!(:family) { FactoryBot.create(:family) }

  # --------------------------------
  # ① 招待コードなしで新規登録
  # --------------------------------
  it "招待コードなしで登録 → 新しい家族が作成され、オーナーになる" do
    visit new_user_registration_path

    fill_in "お名前", with: "太郎"
    fill_in "メールアドレス", with: "taro@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード確認", with: "password"
    fill_in "家族ID ※初めての方は空欄OK", with: ""

    click_button "登録する"

    user = User.last
    expect(user.family).to be_present
    expect(user.family.owner).to eq(user)
    expect(current_path).to eq(root_path)
  end

  # --------------------------------
  # ② 招待コードありで参加
  # --------------------------------
  it "招待コードを入力して登録 → 既存家族に参加" do
    visit new_user_registration_path

    fill_in "お名前", with: "次郎"
    fill_in "メールアドレス", with: "jiro@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード確認", with: "password"
    fill_in "家族ID ※初めての方は空欄OK", with: family.code

    click_button "登録する"

    user = User.last
    expect(user.family).to eq(family)
    expect(user.family.owner).not_to eq(user)
    expect(current_path).to eq(root_path)
  end

  # --------------------------------
  # ③ 間違った招待コード
  # --------------------------------
  it "間違った招待コード → 登録できずエラー表示" do
    visit new_user_registration_path

    fill_in "お名前", with: "三郎"
    fill_in "メールアドレス", with: "saburo@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード確認", with: "password"
    fill_in "家族ID ※初めての方は空欄OK", with: "WRONG123"

    click_button "登録する"

    expect(page).to have_content("家族IDが正しくありません").or have_content("正しく")
    expect(current_path).to eq(user_registration_path)
  end

  # --------------------------------
  # ④ 必須項目不足
  # --------------------------------
  it "名前が空 → 登録できない" do
    visit new_user_registration_path

    fill_in "お名前", with: ""
    fill_in "メールアドレス", with: "hanako@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード確認", with: "password"

    click_button "登録する"

    expect(page).to have_content("名前").or have_content("入力してください")
    expect(current_path).to eq(user_registration_path)
  end
end
