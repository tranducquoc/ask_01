class TopicsController < ApplicationController
  layout "main"

  def index
  end

  def new
    @topic = Topic.new
  end

  def show
    @topic = Topic.includes({questions: [:topics, :user,
      answers: [:user, {comments: [:actions, :user]}]]}).find_by id: params[:id]
    if @topic
      @questions = @topic.questions.paginate(page: params[:page],
        per_page: Settings.topic.per_page)
      if user_signed_in?
        @isFollow = Topic.is_follow(current_user.id, params[:id])
      end
      @countQuestion = @topic.questions.count
      @numberPeopleFollow = Topic.numberFollow @topic.id
      @numberAnswerInTopic = Topic.numberAnwserInTopic @topic.id
    else
      redirect_to root_path;
    end
  end

end
