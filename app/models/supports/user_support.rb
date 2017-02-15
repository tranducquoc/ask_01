class Supports::UserSupport
  attr_reader :user

  def initialize user
    @user = user
  end

  def numberQuestion
    @user.questions.count
  end

  def numberAnswer
    @user.answers.count
  end

  def numberComment
    @user.comments.count
  end

  def numberUserFollow
    User.number_user_follow(@user.id)
  end
end
