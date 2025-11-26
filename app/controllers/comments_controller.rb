class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @meal = Meal.find(params[:meal_id])
    @comment = @meal.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to meal_path(@meal), notice: "評価とコメントを投稿しました！"
    else
      render "meals/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:rating, :content)
  end
end