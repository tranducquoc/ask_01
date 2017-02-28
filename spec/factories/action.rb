FactoryGirl.define do
  factory :action, class: Action do
    before(:create, :build, :attributes_for) do |action|
      action.user {FactoryGirl.create(:user)}
      action.actionable {FactoryGirl.create(:question)}
    end

    actionable_id {rand(1..30)}
    actionable_type {Action.target_acts[:question]}
    type_act {Action.type_acts[:question]}
    user_id {rand(1..30)}
  end
end
