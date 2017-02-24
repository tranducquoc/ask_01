require "spec_helper"

describe "questions/show.html.erb" do

  let(:question) {FactoryGirl.create :question}
  before do
    assign(:question, question)
    render
  end
  it "displays title question correctly" do
    rendered.should have_selector("h2.title")
  end
end
