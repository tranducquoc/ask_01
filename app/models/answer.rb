class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy, foreign_key: "reply_to"

  has_many :actions, as: :actionable
  has_many :comments, as: :commentable
  belongs_to :user
end
