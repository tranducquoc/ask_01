class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  has_many :actions, as: :actionable

end
