class Topic < ApplicationRecord
  has_many :question_topics
  has_many :questions, through: :question_topics

  has_many :actions, as: :actionable

  validates :name, presence: true, length: {maximum: Settings.topic.name_max}
  validates :description, presence: true, length: {maximum: Settings.topic.description_max}
  validates :icon, presence: true

  mount_uploader :icon, IconTopicUploader

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  scope :topics_login_user, -> user_id do
    joins(:actions).where(actions: {actionable_type: Action.target_acts[:topic],
      type_act: Action.type_acts[:follow], user_id: user_id})
  end

  def self.is_follow current_user_id, topic_id
    query = Action.by_user(current_user_id).target(:topic).with_id(topic_id).is_follow
    query.length != 0
  end

  def self.find_muti id
    topic = Topic.find_by slug: id
    unless topic
      topic = Topic.find_by id: id
      if topic
        return topic
      else
        return false
      end
    else
      return topic
    end
  end
end
