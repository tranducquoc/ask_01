class CommentsController < ApplicationController
  layout "main"
  before_filter :authenticate_user!

  def index

  end

  def create
    @comment = Comment.includes(:user).create comment_question_params;
    @comment.user_id = current_user.id;
    if @comment.save
      @comment.create_activity key: Settings.activity.comment.create, owner: current_user
      comment = @comment.to_json(include: [:user])
      result = {status: Settings.status.ok, data: comment}
      render json: result
    else
      comment = @comment.to_json(include: [:user])
      result = {status: Settings.status.not_ok, data: comment,
        errors: @comment.errors}
      render json: result
    end
  end

  def update
    @comment = Comment.find_by id: params[:id]
    if @comment
      @comment.content = params[:content]
      if @comment.save
        result = {status: Settings.status.ok, data: @comment}
        @comment.create_activity key: Settings.activity.comment.update, owner: current_user
      else
        result = {status: Settings.status.not_ok, data: @comment,
          errors: @comment.errors}
      end
    end
    render json: result
  end

  def destroy
    isDestroyed = Comment.destroyed? params[:id]
    if isDestroyed
      result = {status: Settings.status.ok}
    else
      result = {status: Settings.status.not_ok}
    end
    render json: result
  end

  private

  def comment_question_params
    params.permit :content, :commentable_type, :commentable_id
  end
end
