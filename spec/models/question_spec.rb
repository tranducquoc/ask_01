require "rails_helper"

describe Question, type: :model do
  context "associations" do
    let(:question) {FactoryGirl.create :question}
    subject {question}
    it {should belong_to :user}
    it {expect have_many :question_topics}
    it {expect have_many :version_questions}
  end

  context "validation presence" do
    let!(:question) {FactoryGirl.build :question}
    subject {question}
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:content)}
    it {should validate_uniqueness_of(:slug)}

  end

  context "valid question save unvalid" do
    let(:invalid_question) {FactoryGirl.build :invalid_question}
    subject {invalid_question}

    it "is not valid, without a title" do
      expect(invalid_question).to_not be_valid
    end

    it "is not valid, without a content" do
      invalid_question.content = ""
      expect(invalid_question).to_not be_valid
    end

    it "is not valid when have over 255 character" do
      invalid_question.content = Random.rand(257)
      expect(invalid_question).to_not be_valid
    end

  end

  context "valid object save valid" do
    let(:question) {FactoryGirl.build :question}
    subject {question}
    it {expect(question).to be_valid}
  end
end
