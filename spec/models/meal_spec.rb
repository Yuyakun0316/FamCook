require 'rails_helper'

RSpec.describe Meal, type: :model do
  describe "バリデーション" do
    it "必要項目が揃っていれば有効" do
      meal = FactoryBot.build(:meal)
      expect(meal).to be_valid
    end

    it "title が必須" do
      meal = FactoryBot.build(:meal, title: nil)
      expect(meal).to be_invalid
    end

    it "title が50文字以内" do
      meal = FactoryBot.build(:meal, title: "あ" * 51)
      expect(meal).to be_invalid
    end

    it "description が500文字以内" do
      meal = FactoryBot.build(:meal, description: "あ" * 501)
      expect(meal).to be_invalid
    end

    it "date が必須" do
      meal = FactoryBot.build(:meal, date: nil)
      expect(meal).to be_invalid
    end

    it "meal_type が必須" do
      meal = FactoryBot.build(:meal, meal_type: nil)
      expect(meal).to be_invalid
    end

    it "icon_type が必須" do
      meal = FactoryBot.build(:meal, icon_type: nil)
      expect(meal).to be_invalid
    end
  end

  describe "関連バリデーション" do
    it "user が必須" do
      meal = FactoryBot.build(:meal, user: nil)
      expect(meal).to be_invalid
    end

    it "family が必須" do
      meal = FactoryBot.build(:meal, family: nil)
      expect(meal).to be_invalid
    end
  end

  describe "画像の検証" do
    it "画像が3枚までなら有効" do
      meal = FactoryBot.build(:meal)
      expect(meal).to be_valid
    end

    it "画像が4枚以上だと無効" do
      meal = FactoryBot.build(:meal)
      3.times do
        meal.images.attach(
          io: File.open(Rails.root.join("spec/fixtures/files/sample.jpg")),
          filename: "sample_extra.jpg",
          content_type: "image/jpeg"
        )
      end
      expect(meal).to be_invalid
    end
  end

  describe "#average_rating" do
    it "コメントがない場合は 0 を返す" do
      meal = FactoryBot.create(:meal)
      expect(meal.average_rating).to eq 0
    end

    it "コメントがある場合は平均評価を返す" do
      meal = FactoryBot.create(:meal)
      FactoryBot.create(:comment, meal: meal, rating: 3)
      FactoryBot.create(:comment, meal: meal, rating: 5)

      expect(meal.average_rating).to eq 4.0
    end
  end
end
