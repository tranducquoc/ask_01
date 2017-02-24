class NewestQuestionTopicMailerJob < ApplicationJob
  queue_as :default

  def perform *args
    @users = User.all
    @users.each do |user|
      actions = Action.by_user(user.id)
        .target(Action.target_acts[:topic])
        .is_follow
      results = Array.new
      actions.each do |action|
        results << action.actionable
      end
      next unless results.length
      UserMailer.sumQuestionLastDay(user.email, results).deliver_later
    end
  end
end
