require 'rails_helper'

RSpec.describe Family, type: :model do
  describe 'バリデーション' do
    it "code があれば有効" do
      family = FactoryBot.build(:family)
      expect(family).to be_valid
    end

    it "code がなければ無効" do
      family = FactoryBot.build(:family, code: nil)
      expect(family).to be_invalid
      expect(family.errors[:code]).to include("を入力してください")
    end

    it "code が重複していれば無効" do
      FactoryBot.create(:family, code: "abcd1234")
      family = FactoryBot.build(:family, code: "abcd1234")
      expect(family).to be_invalid
      expect(family.errors[:code]).to include("はすでに存在します")
    end
  end

  describe 'owner の関連付け' do
    it "owner がいなくても有効（optional true）" do
      family = FactoryBot.build(:family, owner: nil)
      expect(family).to be_valid
    end

    it "owner を設定できる" do
      user = FactoryBot.create(:user)
      family = FactoryBot.build(:family, owner: user)
      expect(family).to be_valid
      expect(family.owner).to eq user
    end
  end
end
