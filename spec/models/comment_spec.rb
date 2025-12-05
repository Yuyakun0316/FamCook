require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーション" do
    it "必要項目が揃っていれば有効" do
      comment = FactoryBot.build(:comment)
      expect(comment).to be_valid
    end

    it "rating が必須" do
      comment = FactoryBot.build(:comment, rating: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:rating]).to include("を入力してください")
    end

    it "rating は 1 以上でないと無効" do
      comment = FactoryBot.build(:comment, rating: 0)
      expect(comment).to be_invalid
      expect(comment.errors[:rating]).to include("は1〜5の範囲で入力してください")
    end

    it "rating は 5 以下でないと無効" do
      comment = FactoryBot.build(:comment, rating: 6)
      expect(comment).to be_invalid
      expect(comment.errors[:rating]).to include("は1〜5の範囲で入力してください")
    end

    it "content が300文字以内なら有効" do
      comment = FactoryBot.build(:comment, content: "あ" * 300)
      expect(comment).to be_valid
    end

    it "content が301文字以上だと無効" do
      comment = FactoryBot.build(:comment, content: "あ" * 301)
      expect(comment).to be_invalid
    end
  end

  describe "関連のバリデーション" do
    it "user が必須" do
      comment = FactoryBot.build(:comment, user: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:user]).to include("を入力してください")
    end

    it "meal が必須" do
      comment = FactoryBot.build(:comment, meal: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:meal]).to include("を入力してください")
    end
  end
end
