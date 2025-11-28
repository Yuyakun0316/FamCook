class MemosController < ApplicationController
  before_action :authenticate_user!

  def index
    @memo = Memo.new

    @memos = if params[:category].present?
               # ☑ カテゴリ指定あり → 該当メモのみ表示（固定メモ優先）
               current_user.memos
                           .where(category: params[:category])
                           .order(pinned: :desc, created_at: :desc)
             else
               # 📌 カテゴリ指定なし → 全件表示（固定メモ優先）
               current_user.memos
                           .order(pinned: :desc, created_at: :desc)
             end
  end

  def create
    @memo = current_user.memos.build(memo_params)

    @memo.category = "note" if @memo.category.blank?

    if @memo.save
      redirect_to memos_path, notice: 'メモを保存しました✨'
    else
      @memos = current_user.memos
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @memo = current_user.memos.find(params[:id])
    @memo.destroy

    respond_to do |format|
      # 🎯 Ajax(fetch)での削除対応
      format.json { render json: { success: true, id: @memo.id } }

      # 🧷 通常の削除（formで送った時など用の保険）
      format.html { redirect_to memos_path(category: params[:category]), notice: 'メモを削除しました' }
    end
  end

  # ⭐️ ピン切り替えアクション
  def toggle_pin
    @memo = current_user.memos.find(params[:id])
    @memo.update(pinned: !@memo.pinned)

    respond_to do |format|
      # 🚀 非同期 (Fetch API / JSON)
      format.json { render json: { success: true, pinned: @memo.pinned } }

      # 🔁 もし通常のHTMLアクセスの場合（保険として）
      format.html { redirect_to memos_path(category: params[:category]), notice: 'ピンを更新しました📌' }
    end
  end

  private

  def memo_params
    params.require(:memo).permit(:category, :content)
  end
end
