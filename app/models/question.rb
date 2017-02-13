class Question < ApplicationRecord
  has_many :question_topics
  has_many :topics, through: :question_topics
  accepts_nested_attributes_for :topics

  has_many :version_questions, foreign_key: "question_target"

  has_many :actions, as: :actionable
  has_many :follows, as: :followable

  has_many :answers, foreign_key: "reply_to"

  validates :title, presence: true
  validates :content, presence: true, length: {maximum: Settings.question[:content_max]}
  validates :slug, uniqueness: true

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  belongs_to :user

  has_many :comments, as: :commentable

end
