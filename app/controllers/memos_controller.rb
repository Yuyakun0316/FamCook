class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [:destroy, :toggle_pin]
  before_action :authorize_memo!, only: [:destroy, :toggle_pin]

  def index
    @memo = Memo.new

    # 🔥 家族共有版（固定メモ優先）
    @memos = Memo.where(family_id: current_user.family_id)
                 .order(pinned: :desc, created_at: :desc)

    # 📌 カテゴリ指定があれば絞り込み
    return unless params[:category].present?

    @memos = @memos.where(category: params[:category])
  end

  def create
    @memo = current_user.memos.build(memo_params)
    @memo.family_id = current_user.family_id
    @memo.category = 'note' if @memo.category.blank?

    if @memo.save
      redirect_to memos_path, notice: 'メモを保存しました✨'
    else
      @memos = Memo.where(family_id: current_user.family_id).order(pinned: :desc, created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @memo.destroy
    respond_to do |format|
      format.json { render json: { success: true, id: @memo.id } }
      format.html { redirect_to memos_path(category: params[:category]), notice: 'メモを削除しました' }
    end
  end

  def toggle_pin
    @memo.update(pinned: !@memo.pinned)
    respond_to do |format|
      format.json { render json: { success: true, pinned: @memo.pinned } }
      format.html { redirect_to memos_path(category: params[:category]), notice: 'ピンを更新しました📌' }
    end
  end

  private

  def set_memo
    @memo = Memo.find(params[:id])
  end

  def authorize_memo!
    unless @memo.family_id == current_user.family_id && @memo.user_id == current_user.id
      redirect_to memos_path, alert: '権限がありません。'
    end
  end

  def memo_params
    params.require(:memo).permit(:category, :content)
  end
end
