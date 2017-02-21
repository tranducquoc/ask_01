class VotesController < ApplicationController

  def index
  end

  def update
    if params[:id].to_i == Settings.vote.down
      if params.has_key? :comment_id
        result = remove_vote_comment
      else
        result = down_vote
      end
    else
      if params.has_key? :comment_id
        result = up_vote_comment
      else
        result = up_vote
      end
    end
    render json: result
  end

  private

  def update_vote_answer_up answer
    if User.is_downvote_answer current_user.id, params[:answer_id]
      answer.up_vote = answer.up_vote + 2
    else
      answer.up_vote = answer.up_vote + 1
    end
    p = Action.create action_upvote_params
    p.save
    Action.by_user(current_user.id).target(Action.target_acts[:answer])
      .with_id(params[:answer_id]).is_downvote.destroy_all
    return answer.save
  end

  def up_vote
    @answer = Answer.find_by id: params[:answer_id]
    if @answer.nil? || User.is_upvote_answer(current_user.id, params[:answer_id])
      result = {status: Settings.status.not_ok}
    else
      @answer.create_activity key: Settings.activity.answer.up_vote, owner: current_user
      if update_vote_answer_up @answer
        result = {status: Settings.status.ok, data: @answer}
      else
        result = {status: Settings.status.not_ok, data: @answer,
          errors: @answer.errors}
      end
    end
    return result
  end

  def update_vote_answer_down answer
    if User.is_upvote_answer current_user.id, params[:answer_id]
      answer.down_vote = answer.down_vote + 2
    else
      answer.down_vote = answer.down_vote + 1
    end
    p = Action.create action_downvote_params
    p.save
    Action.by_user(current_user.id).target(Action.target_acts[:answer])
      .with_id(params[:answer_id]).is_upvote.destroy_all
    return answer.save
  end

  def down_vote
    @answer = Answer.find_by id: params[:answer_id]
    if @answer.nil? || User.is_downvote_answer(current_user.id, params[:answer_id])
      result = {status: Settings.status.not_ok}
    else
      @answer.create_activity key: Settings.activity.answer.down_vote, owner: current_user
      if update_vote_answer_down @answer
        result = {status: Settings.status.ok, data: @answer}
      else
        result = {status: Settings.status.not_ok, data: @answer,
          errors: @answer.errors}
      end
    end
    return result
  end

  def update_vote_comment_up comment
    comment.up_vote = comment.up_vote + 1
    p = Action.create action_upvote_comment_params
    p.save
    return comment.save
  end

  def up_vote_comment
    @comment = Comment.find_by id: params[:comment_id]
    if @comment.present?
      @comment.create_activity key: Settings.activity.comment.up_vote, owner: current_user
      if update_vote_comment_up @comment
        result = {status: Settings.status.ok, data: @comment}
      else
        result = {status: Settings.status.not_ok, data: @comment,
          errors: @comment.errors}
      end
    else
      result = {status: Settings.status.not_ok}
    end
    return result
  end

  def update_vote_comment_down comment
    comment.up_vote = comment.up_vote - 1
    Action.by_user(current_user.id).target(:comment)
      .with_id(params[:comment_id]).is_upvote.destroy_all
    return comment.save
  end

  def remove_vote_comment
    @comment = Comment.find_by id: params[:comment_id]
    if @comment.present?
      @comment.create_activity key: Settings.activity.comment.down_vote, owner: current_user
      if update_vote_comment_down @comment
        result = {status: Settings.status.ok, data: @comment}
      else
        result = {status: Settings.status.not_ok, data: @comment,
          errors: @comment.errors}
      end
    else
      result = {status: Settings.status.not_ok}
    end
    return result
  end

  def action_upvote_comment_params
    {actionable_id: params[:comment_id],
      actionable_type: Action.target_acts[:comment],
      user_id: current_user.id, type_act: :up_vote}
  end

  def action_upvote_params
    {actionable_id: params[:answer_id],
      actionable_type: Action.target_acts[:answer],
      user_id: current_user.id, type_act: :up_vote}
  end

  def action_downvote_params
    {actionable_id: params[:answer_id],
      actionable_type: Action.target_acts[:answer],
      user_id: current_user.id, type_act: :down_vote}
  end
end
