require 'test_helper'

class CandidatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # def setup
  #   @campaign = campaigns(:one)
  # end

# test "add more candidates method redirects back to campaign page" do
#   # @campaign.expects(:process_candidates)
#   post :add_more_candidates, campaign_id: "1", :Campaign => {"candidate_list"=>"string 1, string 2\r\nstring 3\r\nstring 4"}
#   @recruiter = @campaign.recruiter
#   assert_redirected_to recruiter_campaign_path(@recruiter, @campaign)
# end

# test "add more candidates method displays correct message" do
#   post :add_more_candidates, campaign_id: "1", :Campaign => {"candidate_list"=>"string 1, string 2\r\nstring 3\r\nstring 3"}
#   assert_equal "3 of 4 candidates added. Candidate emails must be unique!", flash[:notice]
# end

# def create_candidate
#   @candidate = @campaign.candidates.create(email: "string-1")
# end

# test "add phone rejects phone numbers less than 10 digits" do
#   create_candidate
#   post :add_phone, candidate_id: @candidate.id, :candidate => {"phone_number"=>"11111111"}
#   assert_equal "Phone number must be 10 digits in length, including LADA.", flash[:alert]
#   assert_template :start_voice_interview
# end

# test "add phone rejects numbers which start with 1" do
#   create_candidate
#   post :add_phone, candidate_id: @candidate.id, :candidate => {"phone_number"=>"1222222222"}
#   assert_equal "Phone number cannot start with 1.", flash[:alert]
#   assert_template :start_voice_interview
# end

# test "add phone rejects non-numeric characters" do
#   create_candidate
#   post :add_phone, candidate_id: @candidate.id, :candidate => {"phone_number"=>"222.222222"}
#   assert_equal "Phone number cannot contain non-numeric characters.", flash[:alert]
#   assert_template :start_voice_interview
# end

# test "redirects to set up path with phone number if valid" do
#   create_candidate
#   post :add_phone, candidate_id: @candidate.id, :candidate => {"phone_number"=>"5523456789"}
#   assert_redirected_to candidate_set_up_path(@candidate, number: "+525523456789")
# end

# test "candidate cannot move on if has not completed verbal interview" do
#   create_candidate
#   get :complete_voice_interview, candidate_id: @candidate.id
#   assert_equal "Please ensure you have completed the verbal portion of your interview and hung up the phone before clicking on the next button.", flash[:alert]
#   assert_template :interview_in_progress
# end

# test "candidate can move on if has completed verbal interview" do
#   create_candidate
#   @candidate.update_attribute(:completed_verbal_interview, true)
#   get :complete_voice_interview, candidate_id: @candidate.id
#   assert_redirected_to candidate_next_stage_path(@candidate)
# end

# test "accepting candidate generates accepted mail" do
#   create_candidate
#   @candidate.update_attributes(completed_verbal_interview: true, completed_text_interview: true)
#   put :accept, campaign_id: @campaign.id, candidate_id: @candidate.id
#   assert_equal [@candidate.email], ActionMailer::Base.deliveries.last.to
#   assert_equal "Your virtual interview for #{@candidate.position_name} at #{@candidate.company_name}.", ActionMailer::Base.deliveries.last.subject
# end

# test "rejecting candidate generates rejected mail" do
#   create_candidate
#   @candidate.update_attributes(completed_verbal_interview: true, completed_text_interview: true)
#   put :reject, campaign_id: @campaign.id, candidate_id: @candidate.id
#   assert_equal [@candidate.email], ActionMailer::Base.deliveries.last.to
#   assert_equal "Your virtual interview for #{@candidate.position_name} at #{@candidate.company_name}.", ActionMailer::Base.deliveries.last.subject
# end

end
