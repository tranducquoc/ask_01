class Action < ApplicationRecord
  belongs_to :actionable, polymorphic: true
  enum type_act: [ :down_vote, :up_vote, :share_fa, :share_tw, :follow ], _suffix: true
end
