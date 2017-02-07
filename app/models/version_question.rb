class VersionQuestion < ApplicationRecord
  belongs_to :questions, foreign_key: "question_target"

end
