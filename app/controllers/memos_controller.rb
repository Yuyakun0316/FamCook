class MemosController < ApplicationController
  before_action :authenticate_user!

  def index
    @memos = current_user.memos.order(created_at: :desc)
    @memo = Memo.new
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
