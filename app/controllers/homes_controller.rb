class HomesController < ApplicationController
  def index
    # 📌 月切り替え対応（例: ?month=2025-11-01）
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.current

    # 📅 表示する日付範囲
    start_date = @current_month.beginning_of_month
    end_date = @current_month.end_of_month
    @calendar_dates = (start_date..end_date).to_a

    # 🍚 指定月の献立データ
    @meals_by_date = Meal.where(user: current_user, date: start_date..end_date).group_by(&:date)
  end
end
