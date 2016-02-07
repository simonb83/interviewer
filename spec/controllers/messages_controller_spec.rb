# encoding: utf-8
require 'spec_helper'

describe MessagesController do

  before(:each) do
     sign_in create(:recruiter, new_user: false)
  end

  describe "POST send_message" do
    it "validates presence of recipients" do
      candidate = create(:candidate)
      post :send_message, recruiter_id: 1, candidate_id: candidate.id, message: {"freeform"=>"", "array"=>[""]}
      response.should render_template('candidates/share')
      flash[:notice].should == "No ingresaste ningún destinario."
    end

    it "generates shared internal email for other recruiters" do
      candidate = create(:candidate)
      r1 = candidate.campaign.recruiter
      org = r1.organization
      r2 = create(:recruiter, organization_id: org.id)
      id = r2.id.to_s
      post :send_message, recruiter_id: 1, candidate_id: candidate.id, message: {"freeform"=>"", "array"=>["","#{id}"]}
      ActionMailer::Base.deliveries.last.to.should == [r2.email]
    end

    it "generates shared external email for external users" do
      candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true)
      post :send_message, recruiter_id: 1, candidate_id: candidate.id, message: {"freeform"=>"string-2", "array"=>[""]}
      ActionMailer::Base.deliveries.last.to.should == ["string-2"]
      ActionMailer::Base.deliveries.last.subject.should == "Un colega quisiera compartir una entrevista contigo."
    end
  end

end