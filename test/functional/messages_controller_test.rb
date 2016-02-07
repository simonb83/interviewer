require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # test "must add recipients to send message" do
  #   @candidate = candidates(:one)
  #   post :send_message, recruiter_id: 1, candidate_id: @candidate.id, message: {"freeform"=>"", "array"=>[""]}
  #   assert_redirected_to campaign_candidate_path(@candidate.campaign, @candidate)
  #   assert_equal "You did not enter any recipients.", flash[:notice]
  # end

  # test "cannot share when interview not completed" do
  #   @candidate = candidates(:one)
  #   get :share, recruiter_id: 1, candidate_id: @candidate.id
  #   assert_redirected_to campaign_candidate_path(@candidate.campaign, @candidate)
  #   assert_equal "You cannot share until candidate has completed their interview.", flash[:notice]
  # end

  # test "sharing with another recruiter generates shared internal email" do
  #   @recruiter = recruiters(:user1)
  #   @campaign = campaigns(:one)
  #   @candidate = @campaign.candidates.create(email: "string", completed_text_interview: true, completed_verbal_interview: true)
  #   post :send_message, recruiter_id: 1, candidate_id: @candidate.id, message: {"freeform"=>"", "array"=>["","2"]}
  #   assert_equal ["simon@abare.in"], ActionMailer::Base.deliveries.last.to
  #   assert_equal "A colleague has shared a candidate interview with you.", ActionMailer::Base.deliveries.last.subject
  # end

  # test "sharing with external email generes shared external email" do
  #   @recruiter = recruiters(:user1)
  #   @campaign = campaigns(:one)
  #   @candidate = @campaign.candidates.create(email: "string", completed_text_interview: true, completed_verbal_interview: true)
  #   post :send_message, recruiter_id: 1, candidate_id: @candidate.id, message: {"freeform"=>"string-2", "array"=>[""]}
  #   assert_equal ["string-2"], ActionMailer::Base.deliveries.last.to
  #   assert_equal "A colleague would like to share a candidate interview with you.", ActionMailer::Base.deliveries.last.subject
  # end

end
