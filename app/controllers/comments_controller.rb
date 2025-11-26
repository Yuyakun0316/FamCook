class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal
  before_action :set_comment, only: :destroy
  before_action :authorize_comment!, only: :destroy

  def create
    @comment = @meal.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to meal_path(@meal), notice: "評価とコメントを投稿しました！"
    else
      @comments = @meal.comments.includes(:user)
      @average_rating = @meal.average_rating
      render "meals/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to meal_path(@meal), notice: "コメントを削除しました。"
  end

  private

  def set_meal
    @meal = Meal.find(params[:meal_id])
  end

  def set_comment
    @comment = @meal.comments.find(params[:id])
  end

  def authorize_comment!
    unless @comment.user == current_user
      redirect_to meal_path(@meal), alert: "自分のコメント以外は削除できません。"
    end
  end

  def comment_params
    params.require(:comment).permit(:rating, :content)
  end
end