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

  private

  def init_role
    self.role ||= :user
  end

end
