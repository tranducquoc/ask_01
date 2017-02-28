class Question < ApplicationRecord

  include PublicActivity::Model

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

  scope :with_ac_user, ->{joins(actions: :user)}

  scope :with_ac, ->{joins(:actions)}

  scope :ac_protect, ->id{where(actions: {actionable_id: id, type_act: Action.type_acts[:protect]})}

  scope :lastday, ->{where updated_at: 1.day.ago..Time.now}

  scope :lastest, ->{order created_at: :desc}

  def self.new_feed_login user_id
    sql = "select q.*, IF(EXISTS(
      select * from actions a where a.user_id = #{user_id}
        and a.type_act = #{Action.type_acts[:follow]} and a.actionable_type =
        'Topic' and a.actionable_id in (
          select qt.topic_id from question_topics qt where qt.question_id = q.id
        )
      ),1,0) AS is_follow, (select count(an.id) from answers an
      where an.reply_to = q.id) as number_answer
      from questions q order by q.updated_at desc, is_follow desc,
      number_answer desc, q.up_vote desc";
    @questions = Question.includes([:topics, :user, :actions])
      .find_by_sql(sql)
  end

  def isProtected
    havePro = Question.with_ac.ac_protect self.id
    havePro.length != 0
  end

  def dataProtected
    havePro = Question.with_ac_user.ac_protect(self.id).first
    if havePro
      havePro.actions.first
    else
      nil
    end
  end

  class << self
    include Common

    def find_muti id
      question = Question.find_by slug: id
      unless question
        question = Question.find_by id: id
        if question
          return Question.wrap_content(question)
        else
          return false
        end
      else
        return Question.wrap_content(question)
      end
    end

    def wrap_content question
      verque = Verque.find_newest question.id
      if verque
        question.title = verque.title
        question.content = verque.content
      end
      question
    end

    def graph_question_created
      Question.group_by_day(:created_at).count
    end

    def graph_question_upvote
      Action.target(Action.target_acts[:question])
        .is_upvote.group_by_day(:created_at).count
    end

    def graph_percentage_type
      Action.group(:type_act).count
    end
  end

  def graph_up_vote
    Action.with_id(self.id)
      .target(Action.target_acts[:question])
      .is_upvote.group_by_day(:created_at).count
  end

  def graph_show_answer
    Answer.where(reply_to: self.id)
      .group_by_day(:created_at).count
  end
end
