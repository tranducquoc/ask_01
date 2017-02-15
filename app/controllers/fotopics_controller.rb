class FotopicsController < ApplicationController
  before_filter :authenticate_user!

  def create
    if params[:type].to_i == Settings.topic.follow
      result = follow
    else
      result = unfollow
    end
    respond_to do |format|
      format.html {
        redirect_to :back
      }
      format.json {
        render json: result
      }
    end
  end

  private

  def follow
    followObj = Action.create follow_params
    if followObj.nil?
      result = {status: Settings.status.not_ok}
    else
      result = {status: Settings.status.ok}
    end
    return result
  end

  def unfollow
    followObj = Action.where(follow_params).destroy_all;
    if followObj.nil? || followObj.length == 0
      result = {status: Settings.status.not_ok}
    else
      result = {status: Settings.status.ok}
    end
    return result
  end

  def follow_params
    {user_id: current_user.id, actionable_id: params[:topic_id],
      actionable_type: Action.target_acts[:topic], type_act: :follow}
  end
end
