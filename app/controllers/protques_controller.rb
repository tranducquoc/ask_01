class ProtquesController < ApplicationController
  layout "main"
  before_action :verify_admin_mod_owner, only: [:create, :destroy]

  def create
    action = Action.create protque_params
    if action
      flash[:success] = t "flash.question.protect_question_success"
    else
      flash[:danger] = t "flash.question.cant_protected"
    end
    redirect_to :back
  end

  def destroy
    actions = Action.destroy_question_protect params[:question_id]
    if actions.length
      flash[:success] = t "flash.question.remove_protect_success"
    else
      flash[:danger] = t "flash.question.remove_protect_fail"
    end
    redirect_to :back
  end

  private

  def verify_admin_mod_owner
    question = Question.find_by id: params[:question_id]
    unless question && (current_user.admin? ||
      current_user.moderator? ||
      question.user_id = current_user.id)
      flash[:danger] = t "flash.question.verify_admin_mod_owner"
      redirect_to root_url
    end
  end

  def protque_params
    {actionable_type: Action.target_acts[:question], user_id: current_user.id,
      actionable_id: params[:question_id], type_act: Action.type_acts[:protect]}
  end
end
