require "rails_helper"

describe QuestionsController do
  let(:valid_attributes) {FactoryGirl.attributes_for :question}
  let(:user) {FactoryGirl.create :user}
  let(:topic) {FactoryGirl.create :topic}

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
  end

  describe "POST create" do
    context "create post successfully and redirects to the show question detail" do
      subject {question}
      before {post :create, {question: valid_attributes.merge({topics: [topic.id]})}}

      it {expect(response).to redirect_to question_path(Question.last.slug)}
      it {expect(response).to have_http_status(302)}
    end
  end

  describe "GET new" do
    it "response success 200" do
      get :new
      assert_response :success
    end

    it "render correct template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET show" do
    it "response success" do
      get :show, {id: Topic.first.id}
      assert_response :success
    end

    it "question not found and must set flash message" do
      get :show, {id: -1}
      expect(flash.key?(:notice)).to be true
    end

    it "render correct template" do
      get :show, {id: Topic.first.id}
      expect(response).to render_template("show")
    end
  end

end
