require 'rails_helper'

RSpec.describe Memo, type: :model do
  describe "バリデーション" do
    it "content があれば有効" do
      memo = FactoryBot.build(:memo)
      expect(memo).to be_valid
    end

    it "content がなければ無効" do
      memo = FactoryBot.build(:memo, content: nil)
      expect(memo).to be_invalid
      expect(memo.errors[:content]).to include("を入力してください")
    end
  end

  describe "関連のバリデーション" do
    it "user が必須" do
      memo = FactoryBot.build(:memo, user: nil)
      expect(memo).to be_invalid
      expect(memo.errors[:user]).to include("を入力してください")
    end

    it "family が必須" do
      memo = FactoryBot.build(:memo, family: nil)
      expect(memo).to be_invalid
      expect(memo.errors[:family]).to include("を入力してください")
    end
  end

  describe ".pinned_first" do
    it "pinned が true のものが先に並び、さらに新しい順で並ぶ" do
      family = FactoryBot.create(:family)
      user = FactoryBot.create(:user, family: family)

      memo1 = FactoryBot.create(:memo, user: user, family: family, pinned: false, created_at: 1.day.ago)
      memo2 = FactoryBot.create(:memo, user: user, family: family, pinned: true, created_at: 2.days.ago)
      memo3 = FactoryBot.create(:memo, user: user, family: family, pinned: true, created_at: Time.current)

      expect(Memo.pinned_first).to eq [memo3, memo2, memo1]
    end
  end
end
