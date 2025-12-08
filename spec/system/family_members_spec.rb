require 'rails_helper'

RSpec.describe "FamilyMembers", type: :system do
  let!(:family) { FactoryBot.create(:family) }
  let!(:owner)  { FactoryBot.create(:user, family: family, name: "管理者さん") }
  let!(:member) { FactoryBot.create(:user, family: family, name: "一般ユーザーさん") }

  before do
    family.update!(owner: owner)  # 🔥 これが超重要！
    driven_by(:rack_test)
  end

  describe "管理者の場合" do
    before do
      sign_in owner
      visit family_members_path
    end

    it "メンバー一覧が見られる" do
      expect(page).to have_content("管理者さん")
      expect(page).to have_content("一般ユーザーさん")
    end

    it "別のメンバーを削除できる" do
      within(find("div.family-member-card", text: "一般ユーザーさん")) do
        click_button "削除"
      end
      expect(page).not_to have_content("一般ユーザーさん")
    end

    it "自分自身は削除ボタンが表示されない" do
      within(find("div.family-member-card", text: "管理者さん")) do
        expect(page).not_to have_button("削除")
      end
    end
  end

  describe "管理者ではない場合" do
    before do
      sign_in member
      visit family_members_path
    end

    it "削除ボタンが表示されない" do
      expect(page).not_to have_button("削除")
    end
  end
end
