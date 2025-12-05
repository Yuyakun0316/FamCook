require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    driven_by(:rack_test)
  end

  it "ログインしてトップに遷移できる" do
    visit new_user_session_path

    find(".auth-input[type='email']").set(user.email)
    find(".auth-input[type='password']").set(user.password)
    click_button "ログイン"

    expect(page).to have_current_path(root_path)

    expect(page).to have_content(user.name)
  end

  it "未ログイン状態では meals, memos にアクセスできない" do
    visit meals_path
    expect(page).to have_current_path(new_user_session_path)

    visit memos_path
    expect(page).to have_current_path(new_user_session_path)
  end
end
