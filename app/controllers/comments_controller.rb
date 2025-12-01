class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meal
  before_action :set_comment, only: :destroy
  before_action :authorize_comment!, only: :destroy

  def create
    @comment = @meal.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        @comments = @meal.comments.includes(:user).order(created_at: :desc)
        format.html { redirect_to meal_path(@meal), notice: '評価とコメントを投稿しました！' }

        format.json do
          render json: {
            success: true,
            comment: @comment,
            average_rating: @meal.average_rating,
            comment_html: render_to_string(
              partial: 'comments/comment',
              locals: { comment: @comment },
              formats: [:html]
            ),
            average_rating_html: render_to_string(
              partial: 'meals/average_rating',
              locals: { average_rating: @meal.average_rating },
              formats: [:html]
            )
          }, status: :created
        end
      else
        format.html do
          @comments = @meal.comments.includes(:user).order(created_at: :desc)
          @average_rating = @meal.average_rating
          render 'meals/show', status: :unprocessable_entity
        end

        format.json do
          render json: {
            success: false,
            errors: @comment.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to meal_path(@meal), notice: 'コメントを削除しました。'
  end

  private

  def set_meal
    @meal = Meal.find(params[:meal_id])
  end

  def set_comment
    @comment = @meal.comments.find(params[:id])
  end

  def authorize_comment!
    return if @comment.user == current_user

    redirect_to meal_path(@meal), alert: '自分のコメント以外は削除できません。'
  end

  def comment_params
    params.require(:comment).permit(:rating, :content)
  end
end
