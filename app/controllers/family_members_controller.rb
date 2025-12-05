class FamilyMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :ensure_family_owner!, only: :destroy

  def index
    @members = @family.users.order(:created_at)
  end

  def destroy
    member = @family.users.find(params[:id])

    # 👤 自分自身は削除できない（これを先にチェック）
    if member == current_user
      redirect_to family_members_path, alert: '自分自身は削除できません。'
      return
    end

    # 👑 家族管理者は削除できない
    if member == @family.owner
      redirect_to family_members_path, alert: '家族管理者は削除できません。'
      return
    end

    # 🔥 完全削除（投稿、メモ、コメント、画像すべて消える）
    member.destroy
    redirect_to family_members_path, notice: "#{member.name} さんを家族から削除しました。"
  end

  private

  def set_family
    @family = current_user.family
    return if @family

    redirect_to settings_path, alert: '家族に所属していません。'
  end

  def ensure_family_owner!
    return if current_user.family_owner?

    redirect_to family_members_path, alert: '管理者のみ操作できます。'
  end
end
