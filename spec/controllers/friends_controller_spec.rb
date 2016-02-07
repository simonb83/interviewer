require 'spec_helper'

describe FriendsController do

  describe "GET recommend_friends" do
    it "redirects to finalize interview page if already recommended friends" do
      candidate = create(:candidate, recommended_friends: true, privacy_consent: true)
      candidate.update_attributes(completed_text_interview: true, completed_verbal_interview: true)
      get :recommend_friends, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end

    it "redirects to get interview stage if candidate has not completed interview" do
      candidate = create(:candidate, privacy_consent: true)
      get :recommend_friends, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end

    it "denies access if candidate has not started interview" do
      candidate = create(:candidate)
      get :recommend_friends, candidate_id: candidate.id
      response.should redirect_to("/403")
    end

    it "otherwise renders recommend_friends template" do
      candidate = create(:candidate, privacy_consent: true)
      candidate.update_attributes(completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
      get :recommend_friends, candidate_id: candidate.id
      response.should render_template('recommend_friends')
    end
  end

end