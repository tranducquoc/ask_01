class HomeController < ApplicationController
  layout "main"

  def index
    @topics = Topic.all
    if params.has_key? :word_search
      @q = Question.ransack(title_or_content_cont: params[:word_search])
      @questions = @q.result.includes([:topics, :user, :actions])
        .page(params[:page]).per Settings.home.per_page
      render template: "home/search"
    else
      if user_signed_in?
        @questions = Kaminari.paginate_array(Question.new_feed_login(current_user.id))
          .page(params[:page]).per Settings.home.per_page
        @topicsFollow = Topic.topics_login_user current_user.id
      else
        @questions = Question.includes([:topics, :user, :actions])
          .page(params[:page]).per Settings.home.per_page
      end
    end
  end
end
