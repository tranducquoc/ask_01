class VersionQuestion < ApplicationRecord
  belongs_to :answers, foreign_key: "answer_target"

end
