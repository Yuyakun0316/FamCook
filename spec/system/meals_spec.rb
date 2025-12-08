require 'rails_helper'

RSpec.describe 'Meals', type: :system do
  let!(:family) { FactoryBot.create(:family) }
  let!(:user)   { FactoryBot.create(:user, family: family) }

  before do
    driven_by(:rack_test)
    sign_in user
  end

  it '献立を新規投稿できる' do
    visit new_meal_path

    # タイトル入力
    fill_in 'meal_title', with: 'カレーライス'
    fill_in 'meal_date', with: Date.current

    # select value を指定して選択
    find("select[name='meal[meal_type]']").find("option[value='lunch']").select_option
    find("select[name='meal[icon_type]']").find("option[value='curry']").select_option

    # 投稿ボタン
    click_button '✨ 献立を投稿する'

    # 一覧からカレーアイコンをクリック（value=curry）
    begin
      find("a[href*='icon_type=curry']", match: :first).click
    rescue StandardError
      nil
    end
    # ↑ 画面によっては不要。失敗しても rescue でスキップ。

    # 詳細ページへ遷移
    first("a[href*='/meals/']").click

    # 検証
    expect(page).to have_content('カレーライス')
    expect(page).to have_content('📅')
  end

  it '必須項目がないと投稿できない' do
    visit new_meal_path

    fill_in 'meal_title', with: ''
    click_button '✨ 献立を投稿する'

    expect(page).to have_css('.error-messages')
  end

  it '投稿した献立を詳細ページで確認できる' do
    meal = FactoryBot.create(:meal, user: user, family: family, title: 'ハンバーグ')

    visit meal_path(meal)

    expect(page).to have_content('ハンバーグ')
    expect(page).to have_content('📅')
  end

  it '投稿者本人の献立のみ削除リンクが表示される' do
    meal = FactoryBot.create(:meal, user: user, family: family, title: 'ステーキ')

    visit meal_path(meal)
    expect(page).to have_link('削除')

    other_user = FactoryBot.create(:user, family: family)
    sign_in other_user

    visit meal_path(meal)
    expect(page).not_to have_link('削除')
  end
end
