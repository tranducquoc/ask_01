require "rails_helper"

describe VotesController do

  let(:user) {FactoryGirl.create :user}
  let(:answer) {FactoryGirl.create :answer}
  let(:action) {FactoryGirl.create :action}
  let(:action_attr) {FactoryGirl.attributes_for :action}
  let(:vote_params) {double(:vote_params)}

  before :each do |test|
    unless test.metadata[:skip_before]
      @user = FactoryGirl.create :user
      sign_in @user
    end
  end

  describe "PUT update" do
    context "vote up for answer" do
      before {post :update, {_method: :put,
        answer_id: answer.id,
        id: Settings.vote.up
      }}

      it {is_expected.to respond_with_content_type :json}

      it {expect(response).to have_http_status(:success)}

      it "up vote when don't login", skip_before: true do
        is_expected.to redirect_to new_user_session_path
      end

      it "response json if success" do
        expect(response).to match_response_schema("vote")
      end
    end

    context "mock instance" do

      it "should find by answer" do
        expect(Answer).to receive(:find_by).with({id: "#{answer.id}"})
        post :update, {_method: :put,
            answer_id: answer.id,
            id: Settings.vote.up
          }
      end

      it "shound created by action" do
        expect(Action).to receive(:create)
        post :update, {_method: :put,
            answer_id: answer.id,
            id: Settings.vote.up
          }.merge(action_attr)
      end
    end
  end
end

