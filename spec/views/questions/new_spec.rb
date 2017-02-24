require "spec_helper"

describe "questions/new.html.erb" do

  let(:question) {Question.new}
  before do
    assign(:question, question)
    assign(:topics, Topic.all)
    render
  end
  it "displays form create question" do
    rendered.should have_selector("form",
      id: "new_question") do |form|
      form.should have_selector("input",
        type: "submit")
      end
  end
end
