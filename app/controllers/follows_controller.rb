class FollowsController < ApplicationController
  before_filter :authenticate_user!

  def create
    if params[:type] == Settings.user.follow
      result = follow
    else
      result = unfollow
    end
    render json: result
  end

  private

  def follow
    followObj = Action.create follow_params
    @user = User.find_by id: params[:user_id]
    if @user
      @user.create_activity key: Settings.activity.user.follow, owner: current_user
    end
    unless followObj
      result = {status: Settings.status.not_ok}
    else
      result = {status: Settings.status.ok}
    end
    return result
  end

  def unfollow
    followObj = Action.follow_user(current_user.id, params[:user_id]).destroy_all;
    @user = User.find_by id: params[:user_id]
    if @user
      @user.create_activity key: Settings.activity.user.unfollow, owner: current_user
    end
    if followObj.nil? || followObj.length == 0
      result = {status: Settings.status.not_ok}
    else
      result = {status: Settings.status.ok}
    end
    return result
  end

  def follow_params
    {user_id: current_user.id, actionable_id: params[:user_id],
      actionable_type: Action.target_acts[:user], type_act: :follow}
  end
end
