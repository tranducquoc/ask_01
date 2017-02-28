class TopicsController < ApplicationController
  layout "main"

  def index
  end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.includes({questions: [:topics, :user,
      answers: [:user, {comments: [:actions, :user]}]]}).find_muti params[:id]
    if @topic
      @questions = @topic.questions.page(params[:page])
        .per Settings.topic.per_page
      if user_signed_in?
        @isFollow = Topic.is_follow(current_user.id, @topic.id)
      end
      @countQuestion = @topic.questions.count
      @numberPeopleFollow = Action.numberFollow(@topic.id).distinct.count(:user_id)
      @numberAnswerInTopic = Answer.numberAnwserInTopic(@topic.id).distinct.count
    else
      redirect_to root_path;
    end
  end

end
