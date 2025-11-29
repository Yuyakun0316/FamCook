class HomesController < ApplicationController
  def index
    # 📌 月切り替え対応（例: ?month=2025-11-01）
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.current

    # 📅 表示する日付範囲
    start_date = @current_month.beginning_of_month
    end_date = @current_month.end_of_month
    @calendar_dates = (start_date..end_date).to_a

    # 🍚 指定月の献立データ（← family単位に変更！）
    @meals_by_date = Meal.where(
      family_id: current_user.family_id,
      date: start_date..end_date
    ).group_by(&:date)
  end
end
