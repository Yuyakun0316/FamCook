class MealsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal, only: [:show, :edit, :update, :destroy]
  before_action :check_family, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @meals = Meal.where(
      family_id: current_user.family_id,
      date: @current_month..@current_month.end_of_month
    ).order(date: :desc)
  end

  def new
    @meal = Meal.new(date: Date.current)
  end

  def create
    @meal = current_user.meals.build(meal_params)
    @meal.family_id = current_user.family_id

    if @meal.save
      redirect_to root_path, notice: '投稿が完了しました🍽️'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comments = @meal.comments.order(created_at: :desc)
    @average_rating = @meal.average_rating
  end

  def edit
  end

  def update
    if meal_params[:images].nil? || meal_params[:images].reject(&:blank?).empty?
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
    if params[:rating].blank?
      @meals = []
      @notice_message = '🔍 絞り込み条件を選択してください'
      return
    end

    rating = params[:rating].to_i

    base_scope = Meal.left_joins(:comments)
                     .where(family_id: current_user.family_id)
                     .select('meals.*, COALESCE(AVG(comments.rating), 0) AS avg_rating')
                     .group('meals.id')

    @meals = case rating
             when 5
               base_scope.having('ROUND(AVG(comments.rating), 1) = 5')
             when 4
               base_scope.having('AVG(comments.rating) >= 4 AND AVG(comments.rating) < 5')
             when 3
               base_scope.having('AVG(comments.rating) >= 3 AND AVG(comments.rating) < 4')
             when 0
               base_scope.having('AVG(comments.rating) < 3')
             when -1
               base_scope.having('COUNT(comments.id) = 0') # ⭐評価なしの料理だけ
             else
               base_scope # 全件表示
             end

    @meals = @meals.order('avg_rating DESC')
  end

  def destroy
    @meal.destroy
    redirect_to meals_path, notice: '献立を削除しました 🗑'
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  def check_family
    redirect_to meals_path, alert: 'アクセス権限がありません。' if @meal.family_id != current_user.family_id
  end

  def ensure_correct_user
    redirect_to meals_path, alert: '編集権限がありません。' unless @meal.user == current_user
  end

  def meal_params
    params.require(:meal).permit(:title, :description, :date, :meal_type, :icon_type, images: [])
  end
end
