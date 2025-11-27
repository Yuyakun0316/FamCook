class MemosController < ApplicationController
  before_action :authenticate_user!

  def index
    @memo = Memo.new

    if params[:category].present?
      # ☑ カテゴリが指定されている場合 → 該当メモのみ表示
      @memos = current_user.memos.where(category: params[:category]).order(created_at: :desc)
    else
      # 📌 カテゴリ指定がなければ全件表示
      @memos = current_user.memos.order(created_at: :desc)
    end
  end

  def create
    @memo = current_user.memos.build(memo_params)
    if @memo.save
      redirect_to memos_path, notice: "メモを保存しました✨"
    else
      @memos = current_user.memos
      render :index, status: :unprocessable_entity
    end
  end

  private

  def memo_params
    params.require(:memo).permit(:category, :content)
  end
end
