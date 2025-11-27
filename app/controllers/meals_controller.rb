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
    @comments = @meal.comments.order(created_at: :desc)
    @average_rating = @meal.average_rating
  end

  def edit
    @meal = Meal.find(params[:id])
  end

  def update
    @meal = Meal.find(params[:id])

    # 画像未選択の場合、params から除外
    if meal_params[:images].blank?
      if @meal.update(meal_params.except(:images))
        redirect_to @meal, notice: '献立を更新しました✨'
      else
        render :edit, status: :unprocessable_entity
      end
    elsif @meal.update(meal_params)
      redirect_to @meal, notice: '献立を更新しました✨'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def filter
    rating = params[:rating].to_i

    # left_joins で評価なしも含める & avg_rating を使いやすくする
    base_scope = Meal.left_joins(:comments)
                    .select('meals.*, COALESCE(AVG(comments.rating), 0) AS avg_rating')
                    .group('meals.id')

    case rating
    when 5
      @meals = base_scope.having('ROUND(AVG(comments.rating), 1) = 5')
    when 4
      @meals = base_scope.having('AVG(comments.rating) >= 4 AND AVG(comments.rating) < 5')
    when 3
      @meals = base_scope.having('AVG(comments.rating) >= 3 AND AVG(comments.rating) < 4')
    when 0
      @meals = base_scope.having('AVG(comments.rating) < 3')
    when -1
      @meals = base_scope.having('COUNT(comments.id) = 0')  # ⭐評価なしの料理だけ
    else
      @meals = base_scope # 全件表示
    end
  end

  def destroy
    @meal = current_user.meals.find(params[:id])
    @meal.destroy
    redirect_to meals_path, notice: '献立を削除しました 🗑'
  end

  private

  def meal_params
    params.require(:meal).permit(:title, :description, :date, :meal_type, :icon_type, images: [])
  end
end
