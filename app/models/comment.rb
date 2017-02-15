class Comment < ApplicationRecord

  include PublicActivity::Model

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :actions, as: :actionable

  validates :content, presence: true, length: {maximum: Settings.comment.content_max,
    minimum: Settings.comment.content_min}
  validates :commentable_type, presence: true
  validates :commentable_id, presence: true
  validates :user_id, presence: true

  enum comment_type: {answer: "Answer", question: "Question"}

  def final_question
    if self.commentable_type == Comment.comment_types[:question]
      return Question.find self.commentable_id
    elsif self.commentable_type == Comment.comment_types[:answer]
      return Answer.find(self.commentable_id).question
    end
  end
end
