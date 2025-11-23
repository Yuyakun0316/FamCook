class HomesController < ApplicationController
  def index
    start_date = Date.current.beginning_of_month
    end_date = Date.current.end_of_month
    @calendar_dates = (start_date..end_date).to_a

    @meals_by_date = Meal.where(user: current_user, date: start_date..end_date).group_by(&:date)
  end
end
