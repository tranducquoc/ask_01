require "rails_helper"

describe Answer, type: :model do
  context "associations" do
    let(:answer) {FactoryGirl.create :answer}
    subject {answer}
    it {should belong_to :user}
    it {should have_many :actions}
    it {should have_many :comments}
    it {should belong_to :question}
  end
end
