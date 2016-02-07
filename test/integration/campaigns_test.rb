require 'test_helper'

class CampaignsTest < ActionDispatch::IntegrationTest
  fixtures :all

  # def setup
  #  @recruiter = recruiters(:user1)
  #  @campaign = campaigns(:one)
  # end

  # test "validates campaign creation fields and redirects to text questions page" do
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: @recruiter.email
  #   fill_in "password-input", with: "abcdefgh"
  #   click_on "Sign in"
  #   visit new_recruiter_campaign_path(@recruiter)
  #   fill_in "position-name-field", with: "Sales Analyst"
  #   choose 'recommend-yes'
  #   click_on "Next"
  #   @campaign = Campaign.last
  #   assert_equal campaign_choose_text_questions_path(@campaign), current_path
  # end

  # test "validates can add candidates to active campaign" do
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Add Candidates"
  #   assert_equal campaign_enter_more_candidates_path(@campaign) , current_path
  # end

  # test "validates cannot add candidates to closed campaign" do
  #   @campaign.update_attribute(:active, false)
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Add Candidates"
  #   assert_equal recruiter_campaign_path(@recruiter,@campaign) , current_path
  #   assert has_content?("Sorry, your campaign is closed")
  # end

  # test "validates can change deadline on active campaign" do
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Change Deadline"
  #   assert_equal  campaign_choose_deadline_path(@campaign), current_path
  #   select "1", from: "campaign_deadline_3i"
  #   select "December", from: "campaign_deadline_2i"
  #   click_on "Save"
  #   new_campaign = Campaign.find(@campaign.id)
  #   assert_equal 1, new_campaign.deadline.day
  #   assert_equal 12, new_campaign.deadline.month
  #   assert_equal recruiter_campaign_path(@recruiter,@campaign), current_path, "Path not equal"
  #   assert has_content?("Deadline successfully modified."), "Message not present"
  # end

  # test "validates can close campaign" do
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: @recruiter.email
  #   fill_in "password-input", with: "abcdefgh"
  #   click_on "Sign in"
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Close Campaign"
  #   assert_equal recruiter_campaign_path(@recruiter,@campaign), current_path
  #   @campaign = Campaign.find(campaigns(:one).id)
  #   assert_equal false, @campaign.active
  #   assert has_content?("Campaign was successfully closed.")
  # end

  # test "validates can delete campaign" do
  #   visit new_recruiter_session_path
  #   fill_in "email-input", with: @recruiter.email
  #   fill_in "password-input", with: "abcdefgh"
  #   click_on "Sign in"
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Delete Campaign"
  #   assert_equal recruiter_path(@recruiter), current_path
  #   assert_raise(ActiveRecord::RecordNotFound) {Campaign.find(campaigns(:one).id)}
  #   assert has_content?("Campaign successfully removed"), "Mesage not correct"
  # end

  # test "validates can accept candidate" do
  #   @candidate = @campaign.candidates.create(email: "string",completed_text_interview: true, completed_verbal_interview: true)
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Accept"
  #   @candidate = Candidate.last
  #   assert_equal true, @candidate.accepted
  # end

  # test "validates can reject candidate" do
  #    @candidate = @campaign.candidates.create(email: "string",completed_text_interview: true, completed_verbal_interview: true)
  #   visit recruiter_campaign_path(@recruiter,@campaign)
  #   click_on "Reject"
  #   @candidate = Candidate.last
  #   assert_equal true, @candidate.rejected
  # end

  # test "validates can delete candidate" do
  #   @candidate = @campaign.candidates.create(email: "string-unique")
  #   id = @candidate.id
  #   visit campaign_candidate_path(@campaign, @candidate)
  #   click_on "Delete Candidate"
  #   assert_equal recruiter_campaign_path(@recruiter,@campaign), current_path
  #   assert_raise(ActiveRecord::RecordNotFound) {Candidate.find(id)}
  # end

  # test "validates can update email" do
  #   @candidate = @campaign.candidates.create(email: "string-1")
  #   id = @candidate.id
  #   visit campaign_candidate_path(@campaign, @candidate)
  #   click_on "Edit Email"
  #   fill_in "Email", with: "string-2"
  #   click_on "Save"
  #   assert_equal campaign_candidate_path(@campaign, @candidate), current_path
  #   assert has_content?("Candidate email successfully updated")
  #   assert_equal "string-2", Candidate.find(id).email
  # end

end
