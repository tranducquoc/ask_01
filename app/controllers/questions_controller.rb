class QuestionsController < ApplicationController
  layout "main"
  before_filter :authenticate_user!, except: :show

  def new
    @question = Question.new
    @topics = Topic.all
  end

  def create
    @question = Question.create question_params
    @question.user_id = current_user.id
    @question.topic_ids = params[:question][:topics]
      .reject { |c| c.empty? }.map(&:to_i)
    @question.save
    @question.create_activity key: Settings.activity.question.create, owner: current_user
    redirect_to question_path(@question.slug)
  end

  def show
    @question = Question.includes({answers: [:user, {comments:
      [:actions, :user]}] }, :user, {comments: [:actions, :user]})
      .find_muti params[:id]

    unless @question
      flash[:notice] = t "flash.question.not_found"
      redirect_to root_path
    end

    gon.comments_path = comments_path
    gon.answers_path = answers_path
    gon.current_user = current_user
    gon.new_user_session_path = new_user_session_path
  end

  def edit
    @question = Question.includes(:topics).find_by slug: params[:id]
    @topics = Topic.all

    unless @question
      flash[:notice] = t "flash.question.not_found"
      redirect_to root_path
    end
  end

  def update
    if params.has_key?(:act)
      respond_to do |format|
        format.html
        format.json {
          if params[:act].to_i == Settings.vote[:down]
            result = down_vote
          else
            result = up_vote
          end
          render json: result
        }
      end
    else
      @question = Question.find_muti params[:id]
      @question.update question_params
      @question.create_activity key: Settings.activity.question.update, owner: current_user
      @question.topic_ids = params[:question][:topics]
        .reject {|c| c.empty?}.map(&:to_i)
      @topics = Topic.all
      redirect_to question_path
    end
  end

  private

  def up_vote
    @question = Question.find_by id: params[:id]
    if @question.nil? || User.is_upvote_question(current_user.id, params[:id])
      result = {status: Settings.status.not_ok}
    else
      @question.create_activity key: Settings.activity.question.up_vote, owner: current_user
      if User.is_downvote_question current_user.id, params[:id]
        @question.up_vote = @question.up_vote + 2
      else
        @question.up_vote = @question.up_vote + 1
      end
      p = Action.create action_upvote_params
      p.save
      p.destroy_question_down current_user.id, params[:id]
      if @question.save
        result = {status: Settings.status.ok, data: @question}
      else
        result = {status: Settings.status.not_ok, data: @question, errors: @question.errors}
      end
    end
    return result
  end

  def down_vote
    @question = Question.find_by id: params[:id]
    if @question.nil? || User.is_downvote_question(current_user.id, params[:id])
      result = {status: Settings.status.not_ok}
    else
      @question.create_activity key: Settings.activity.question.down_vote, owner: current_user
      if User.is_upvote_question current_user.id, params[:id]
        @question.down_vote = @question.down_vote + 2
      else
        @question.down_vote = @question.down_vote + 1
      end
      p = Action.create action_downvote_params
      p.save
      p.destroy_question_up current_user.id, params[:id]
      if @question.save
        result = {status: Settings.status.ok, data: @question}
      else
        result = {status: Settings.status.not_ok, data: @question, errors: @question.errors}
      end
    end

    return result
  end

  def question_params
    params.require(:question).permit :title, :content, :topics
  end

  def action_upvote_params
    {actionable_id: params[:id], actionable_type: Action.target_acts[:question],
      user_id: current_user.id, type_act: :up_vote}
  end

  def action_downvote_params
    {actionable_id: params[:id], actionable_type: Action.target_acts[:question],
      user_id: current_user.id, type_act: :down_vote}
  end

end
