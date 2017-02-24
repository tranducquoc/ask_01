FactoryGirl.define do
  factory :answer, class: Answer do
    before(:create, :build) do |answer|
      answer.question {FactoryGirl.create(:question)}
      answer.user {FactoryGirl.create(:user)}
    end
    reply_to {rand(1..30)}
    content {Faker::Lorem.sentence}
    user_id {rand(1..30)}
  end
end
