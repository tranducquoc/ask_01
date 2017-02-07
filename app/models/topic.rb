class Topic < ApplicationRecord
  has_many :question_topics
  has_many :questions, through: :question_topics

  has_many :actions, as: :actionable

  validates :name, presence: true, length: {maximum: 255}
  validates :description, presence: true, length: {maximum: 255}
  validates :icon, presence: true

  mount_uploader :icon, IconTopicUploader

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]
end
