require 'rails_helper'

RSpec.describe "Memos", type: :request do
  let(:family) { FactoryBot.create(:family) }
  let(:user)   { FactoryBot.create(:user, family: family) }
  let(:memo)   { FactoryBot.create(:memo, user: user, family: family) }

  describe "POST /memos" do
    before { sign_in user }

    it "content があれば投稿できる" do
      expect {
        post memos_path, params: { memo: { content: "買い物リスト" } }, headers: basic_auth_header
      }.to change(Memo, :count).by(1)
    end

    it "content が空だと投稿できない" do
      post memos_path, params: { memo: { content: "" } }, headers: basic_auth_header
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "不正に他の family_id を送っても自分の家族に保存される" do
      other_family = FactoryBot.create(:family)
      expect {
        post memos_path, params: {
          memo: { content: "悪意あるメモ", family_id: other_family.id }
        }, headers: basic_auth_header
      }.to change(Memo, :count).by(1)
      expect(Memo.last.family_id).to eq user.family_id
    end
  end

  describe "PATCH /memos/:id/toggle_pin" do
    before { sign_in user }

    it "自分のメモならピンを切り替えできる" do
      expect {
        patch toggle_pin_memo_path(memo), headers: basic_auth_header
      }.to change { memo.reload.pinned }.from(false).to(true)
    end

    it "他人のメモは切り替えできない" do
      other_user = FactoryBot.create(:user, family: family)
      sign_in other_user
      expect {
        patch toggle_pin_memo_path(memo), headers: basic_auth_header
      }.not_to change { memo.reload.pinned }
    end
  end

  describe "DELETE /memos/:id" do
    before { sign_in user }

    it "自分のメモなら削除できる" do
      memo
      expect {
        delete memo_path(memo), headers: basic_auth_header
      }.to change(Memo, :count).by(-1)
    end

    it "他人のメモは削除できない" do
      other_user = FactoryBot.create(:user, family: family)
      sign_in other_user
      memo
      expect {
        delete memo_path(memo), headers: basic_auth_header
      }.not_to change(Memo, :count)
    end
  end
end
