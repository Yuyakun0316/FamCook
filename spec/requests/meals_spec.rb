require 'rails_helper'

RSpec.describe 'Meals', type: :request do
  let(:family) { FactoryBot.create(:family) }
  let(:user)   { FactoryBot.create(:user, family: family) }
  let(:meal)   { FactoryBot.create(:meal, user: user, family: family) }

  describe '認証チェック' do
    it '未ログインだとリダイレクトされる' do
      get meals_path, headers: basic_auth_header
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe '家族制限チェック' do
    let(:other_family) { FactoryBot.create(:family) }
    let(:other_user)   { FactoryBot.create(:user, family: other_family) }
    let(:other_meal)   { FactoryBot.create(:meal, user: other_user, family: other_family) }

    it '他の家族の meal を show できない' do
      sign_in user
      get meal_path(other_meal), headers: basic_auth_header
      expect(response).to redirect_to(meals_path)
      expect(flash[:alert]).to eq 'アクセス権限がありません。'
    end
  end

  describe '編集権限チェック' do
    let(:other_user) { FactoryBot.create(:user, family: family) }

    it '編集は投稿者だけ可能' do
      sign_in other_user
      get edit_meal_path(meal), headers: basic_auth_header
      expect(response).to redirect_to(meals_path)
      expect(flash[:alert]).to eq '編集権限がありません。'
    end
  end

  describe 'POST /meals' do
    before { sign_in user }

    it '正しく保存される' do
      expect do
        post meals_path, params: {
          meal: FactoryBot.attributes_for(:meal).except(:images)
        }, headers: basic_auth_header
      end.to change(Meal, :count).by(1)
    end

    it '保存に失敗すると new に戻る' do
      post meals_path, params: { meal: { title: '', date: Date.today } }, headers: basic_auth_header
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /meals/:id' do
    before { sign_in user }

    it '画像を送らずに更新できる' do
      patch meal_path(meal), params: {
        meal: { title: '新しいカレー名' }
      }, headers: basic_auth_header

      expect(response).to redirect_to(meal_path(meal))
      expect(meal.reload.title).to eq '新しいカレー名'
    end

    it '画像付きで更新できる' do
      file = fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpeg')

      patch meal_path(meal), params: {
        meal: {
          title: '画像更新カレー',
          images: [file]
        }
      }, headers: basic_auth_header

      expect(response).to redirect_to(meal_path(meal))
      expect(meal.reload.images).to be_attached
    end
  end

  describe 'GET /meals/filter' do
    before { sign_in user }

    let!(:meal_5) { FactoryBot.create(:meal, user: user, family: family, title: '★5') }
    let!(:meal_4) { FactoryBot.create(:meal, user: user, family: family, title: '★4') }
    let!(:meal_3) { FactoryBot.create(:meal, user: user, family: family, title: '★3') }
    let!(:meal_low) { FactoryBot.create(:meal, user: user, family: family, title: '★1') }
    let!(:meal_none) { FactoryBot.create(:meal, user: user, family: family, title: '評価なし') }

    before do
      FactoryBot.create(:comment, meal: meal_5, rating: 5)
      FactoryBot.create(:comment, meal: meal_4, rating: 4)
      FactoryBot.create(:comment, meal: meal_3, rating: 3)
      FactoryBot.create(:comment, meal: meal_low, rating: 1)
    end

    def request_filter(val)
      get filter_meals_path, params: { rating: val }, headers: basic_auth_header
    end

    it 'rating がない場合は空になる' do
      request_filter('')
      expect(response.body).not_to include('★5', '★4', '★3', '★1', '評価なし')
    end

    it 'rating=5 → ★5 だけ返る' do
      request_filter(5)
      expect(response.body).to include('★5')
      expect(response.body).not_to include('★4', '★3', '★1', '評価なし')
    end

    it 'rating=4 → ★4 だけ返る' do
      request_filter(4)
      expect(response.body).to include('★4')
      expect(response.body).not_to include('★5', '★3', '★1', '評価なし')
    end

    it 'rating=3 → ★3 だけ返る' do
      request_filter(3)
      expect(response.body).to include('★3')
      expect(response.body).not_to include('★5', '★4', '★1', '評価なし')
    end

    it 'rating=0 → ★1 だけ返る' do
      request_filter(0)
      expect(response.body).to include('★1')
      expect(response.body).not_to include('★5', '★4', '★3', '評価なし')
    end

    it 'rating=-1 → 評価なし だけ返る' do
      request_filter(-1)
      expect(response.body).to include('評価なし')
      expect(response.body).not_to include('★5', '★4', '★3', '★1')
    end
  end
end
