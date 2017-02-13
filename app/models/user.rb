class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :actions
  has_many :questions
  has_many :answers
  has_many :comments

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
  before_save :init_role

  mount_uploader :avatar, AvatarUploader
  enum role: [:admin, :user, :moderator]

  validates :name, presence: true, length: {maximum: Settings.user[:name_max]}
  validates :story, length: {maximum: Settings.user[:story_max]}
  validates :email, presence: true, length: {maximum: Settings.user[:email_max]}
  validates :role, presence: true
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    message: I18n.t("flash.user.email")

  class << self
    def is_upvote_answer(current_user_id, answer_id)
      query = Action.is_upvote_answer current_user_id, answer_id
      return query.length != 0
    end

    def is_downvote_answer(current_user_id, answer_id)
      query = Action.is_downvote_answer current_user_id, answer_id;
      return query.length != 0
    end

    def is_upvote_question(current_user_id, question_id)
      query = Action.is_upvote_question current_user_id, question_id;
      return query.length != 0
    end

    def is_downvote_question(current_user_id, question_id)
      query = Action.is_downvote_question current_user_id, question_id;
      return query.length != 0
    end
  end

  private

  def init_role
    self.role ||= :user
  end

end
