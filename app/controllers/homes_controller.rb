class HomesController < ApplicationController
  def index
    # 📌 月切り替え対応（例: ?month=2025-11-01）
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.current

    # 📅 カレンダーの開始・終了日
    start_date = @current_month.beginning_of_month
    end_date = @current_month.end_of_month

    # 🔍 月初の曜日（0 = 日曜, 6 = 土曜）
    start_wday = start_date.wday

    # 🧩 空白セル（nil）を追加して曜日調整
    @calendar_dates = Array.new(start_wday, nil) + (start_date..end_date).to_a

    # 🍚 指定月の献立データ（ family 単位で共有 ）
    @meals_by_date = Meal.where(
      family_id: current_user.family_id,
      date: start_date..end_date
    ).group_by(&:date)
  end
end
