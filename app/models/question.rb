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

  def self.new_feed_login(user_id, page)
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
    per_page = Settings.home.per_page;
    @questions = Question.includes([:topics, :user, :actions]).paginate_by_sql(sql,
      page: page, per_page: per_page)
    return @questions
  end

end
