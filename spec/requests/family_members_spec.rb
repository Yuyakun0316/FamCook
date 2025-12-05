require 'rails_helper'

RSpec.describe "FamilyMembers", type: :request do
  let(:family) { FactoryBot.create(:family) }

  let(:owner) do
    user = FactoryBot.create(:user, family: family)
    family.update(owner: user)
    user
  end

  let(:member) { FactoryBot.create(:user, family: family) }

  describe "DELETE /family_members/:id" do
    context "管理者の場合" do
      before { sign_in owner }

      it "別のメンバーを削除できる" do
        member
        expect {
          delete family_member_path(member), headers: basic_auth_header
        }.to change(User, :count).by(-1)
      end

      it "自分自身は削除できない" do
        expect {
          delete family_member_path(owner), headers: basic_auth_header
        }.not_to change(User, :count)

        expect(flash[:alert]).to eq "自分自身は削除できません。"
      end
    end

    context "管理者ではないメンバーの場合" do
      before { sign_in member }

      it "削除できずエラーになる" do
        owner
        expect {
          delete family_member_path(owner), headers: basic_auth_header
        }.not_to change(User, :count)

        expect(flash[:alert]).to eq "管理者のみ操作できます。"
      end
    end
  end
end
