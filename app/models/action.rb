class Action < ApplicationRecord
  belongs_to :actionable, polymorphic: true

  belongs_to :user

  enum type_act: [ :down_vote, :up_vote, :share_fa, :share_tw, :follow, :protect], _suffix: true

  enum target_act: {answer: "Answer", question: "Question", topic: "Topic", comment: "Comment", user: "User"}

  scope :by_user, ->user_id{where user_id: user_id}

  scope :target, ->type{where actionable_type: type}

  scope :with_id, ->id{where actionable_id: id}

  scope :is_upvote, ->{where type_act: Action.type_acts[:up_vote]}

  scope :is_downvote, ->{where type_act: Action.type_acts[:down_vote]}

  scope :is_follow, ->{where type_act: Action.type_acts[:follow]}

  scope :is_protect, ->{where type_act: Action.type_acts[:protect]}

  scope :numberFollow, -> topic_id do
    where(actionable_id: topic_id, actionable_type: Action.target_acts[:topic],
      type_act: Action.type_acts[:follow])
  end

  scope :follow_user, -> current_user_id, user_id do
    where user_id: current_user_id, actionable_id: user_id,
      actionable_type: Action.target_acts[:user], type_act: :follow
  end

  scope :is_upvote_answer, -> (current_user_id, answer_id) do
    where "user_id = ? and actionable_type = ? and actionable_id = ?
    and type_act = ?", current_user_id, Action.target_acts[:answer], answer_id,
    Action.type_acts[:up_vote] ;
  end

  scope :is_downvote_answer, -> (current_user_id, answer_id) do
    where "user_id = ? and actionable_type = ? and actionable_id = ?
    and type_act = ?", current_user_id, Action.target_acts[:answer], answer_id,
    Action.type_acts[:down_vote] ;
  end

  scope :is_upvote_question, -> (current_user_id, question_id) do
    where "user_id = ? and actionable_type = ? and actionable_id = ?
    and type_act = ?", current_user_id, Action.target_acts[:question], question_id,
    Action.type_acts[:up_vote] ;
  end

  scope :is_downvote_question, -> (current_user_id, question_id) do
    where "user_id = ? and actionable_type = ? and actionable_id = ?
    and type_act = ?", current_user_id, Action.target_acts[:question], question_id,
    Action.type_acts[:down_vote] ;
  end

  def destroy_question_down current_user_id, question_id
    Action.where(user_id: current_user_id,
      type_act: :down_vote,
      actionable_type: Action.target_acts[:question],
      actionable_id: question_id).destroy_all
  end

  def destroy_question_up current_user_id, question_id
    Action.where(user_id: current_user_id,
      type_act: :up_vote,
      actionable_type: Action.target_acts[:question],
      actionable_id: question_id).destroy_all
  end

  def self.destroy_question_protect question_id
    Action.target(Action.target_acts[:question]).with_id(question_id)
      .is_protect.destroy_all
  end

end
