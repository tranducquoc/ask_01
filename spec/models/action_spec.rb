require "rails_helper"

describe Action, type: :model do
  context "associations" do
    let(:action) {FactoryGirl.create :action}
    subject {action}
    it {should belong_to :actionable}
    it {should belong_to :user}
  end

  context "define enum" do
    it {should define_enum_for :type_act}
  end
end
