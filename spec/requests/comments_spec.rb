require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:family) { FactoryBot.create(:family) }
  let(:user)   { FactoryBot.create(:user, family: family) }
  let(:meal)   { FactoryBot.create(:meal, user: user, family: family) }

  let(:other_family) { FactoryBot.create(:family) }
  let(:other_user)   { FactoryBot.create(:user, family: other_family) }
  let(:other_meal)   { FactoryBot.create(:meal, user: other_user, family: other_family) }

  describe "POST /meals/:meal_id/comments" do
    context "正常系" do
      before { sign_in user }

      it "投稿できる" do
        expect {
          post meal_comments_path(meal), params: {
            comment: { rating: 4, content: "おいしかった！" }
          }, headers: basic_auth_header
        }.to change(Comment, :count).by(1)
      end
    end

    context "異常系" do
      before { sign_in user }

      it "rating がないと投稿できない" do
        expect {
          post meal_comments_path(meal), params: {
            comment: { rating: nil, content: "評価なし" }
          }, headers: basic_auth_header
        }.not_to change(Comment, :count)
      end

      it "他の家族の料理には投稿できない" do
        expect {
          post meal_comments_path(other_meal), params: {
            comment: { rating: 4, content: "侵入コメント" }
          }, headers: basic_auth_header
        }.not_to change(Comment, :count)

        expect(response).to redirect_to(meals_path)
        expect(flash[:alert]).to eq "アクセス権限がありません。"
      end
    end
  end

  describe "DELETE /comments/:id" do
    let!(:comment) { FactoryBot.create(:comment, user: user, meal: meal) }
    let!(:other_comment) { FactoryBot.create(:comment, user: other_user, meal: meal) }

    context "正常系" do
      before { sign_in user }

      it "自分のコメントは削除できる" do
        expect {
          delete meal_comment_path(meal, comment), headers: basic_auth_header
        }.to change(Comment, :count).by(-1)
      end
    end

    context "異常系" do
      before { sign_in user }

      it "他人のコメントは削除できない" do
        expect {
          delete meal_comment_path(meal, other_comment), headers: basic_auth_header
        }.not_to change(Comment, :count)

        expect(response).to redirect_to(meal_path(other_comment.meal))
        expect(flash[:alert]).to eq "自分のコメント以外は削除できません。"
      end
    end
  end
end
