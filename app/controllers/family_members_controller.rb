class FamilyMembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :ensure_family_owner!, only: :destroy

  def index
    @members = @family.users.order(:created_at)
  end

  def destroy
    member = @family.users.find(params[:id])

    if member == @family.owner
      redirect_to family_members_path, alert: "家族管理者は削除できません。"
    elsif member == current_user
      redirect_to family_members_path, alert: "自分自身は削除できません。"
    else
      member.update!(family_id: nil)
      redirect_to family_members_path, notice: "#{member.name}さんを家族から外しました。"
    end
  end

  private

  def set_family
    @family = current_user.family
    redirect_to settings_path, alert: "家族に所属していません。" unless @family
  end

  def ensure_family_owner!
    redirect_to family_members_path, alert: "管理者のみ操作できます。" unless current_user.family_owner?
  end
end
