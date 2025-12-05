require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    let(:family) { FactoryBot.create(:family) }

    it "名前・メール・パスワードがあれば有効" do
      user = FactoryBot.build(:user, family: family)
      expect(user).to be_valid
    end

    it "名前がないと無効" do
      user = FactoryBot.build(:user, name: nil, family: family)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "名前が20文字以内であること" do
      user = FactoryBot.build(:user, name: "あ" * 21, family: family)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end

    it "familyがなくても有効（optional true）" do
      user = FactoryBot.build(:user, family: nil)
      expect(user).to be_valid
    end
  end

  describe 'インスタンスメソッドのテスト' do
    context "#family_owner?" do
      it "family の owner_id と user.id が一致すれば true を返す" do
        family = FactoryBot.create(:family)
        user = FactoryBot.create(:user, family: family)
        family.update(owner_id: user.id)
        user.reload
        expect(user.family_owner?).to eq true
      end

      it "一致しなければ false を返す" do
        family = FactoryBot.create(:family)
        user = FactoryBot.create(:user)
        family.update(owner_id: user.id + 1)
        expect(user.family_owner?).to eq false
      end
    end

    context "#owned_family" do
      it "自分が owner_id の family を返す" do
        family = FactoryBot.create(:family)
        user = FactoryBot.create(:user, family: family)
        family.update(owner_id: user.id)
        user.reload
        expect(user.owned_family).to eq family
      end

      it "owner でない場合は nil を返す" do
        user = FactoryBot.create(:user)
        expect(user.owned_family).to be_nil
      end
    end
  end
end
