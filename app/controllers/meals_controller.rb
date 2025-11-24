class MealsController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @meals = Meal.where(user: current_user, date: @current_month..@current_month.end_of_month).order(date: :desc)
  end

  def new
    @meal = Meal.new(date: Date.current)
  end

  def create
    @meal = Meal.new(meal_params)
    @meal.user = current_user

    if @meal.save
      redirect_to root_path, notice: '投稿が完了しました🍽️'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  @meal = Meal.find(params[:id])
end

  private

  def meal_params
    params.require(:meal).permit(:title, :description, :date, :meal_type, :icon_type, images: [])
  end
end
