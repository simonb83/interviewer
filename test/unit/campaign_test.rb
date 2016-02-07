require 'test_helper'

class CampaignTest < ActiveSupport::TestCase

  # test "active campaigns have status active" do
  #   @campaign = campaigns(:one)
  #   assert_equal "active", @campaign.status
  # end

  # test "non-active campaigns have status closed" do
  #   @campaign = campaigns(:two)
  #   assert_equal "closed", @campaign.status
  # end

  # test "generates id on create for new campaigns" do
  #   @campaign = Campaign.create(recruiter_id: 1, active: true, position_name: "Position New", deadline: Date.today(), recommend_friends: true)
  #   @cam = Campaign.last
  #   assert_equal true, @cam.uid?
  # end

  # test "validates presence of required name field" do
  #   campaign = Campaign.new(deadline: Date.today())
  #   assert !campaign.valid?
  # end

  # test "validates date is not in past" do
  #   campaign = Campaign.new(position_name: "test position", deadline: Date.yesterday(), recommend_friends: true)
  #   assert !campaign.valid?
  # end

  # test "combined display combines UID and Position Name" do
  #   @campaign = Campaign.new
  #   @campaign.stubs(:uid).returns("ABCDE")
  #   @campaign.stubs(:position_name).returns("Position")
  #   assert_equal "ABCDE - Position", @campaign.combined_display
  # end

  # test "once deadline is reached, campaigns are closed and method is called to send emails" do
  #   Campaign.create(position_name: "string 1", deadline: Date.today, recruiter_id: 1)
  #   Candidate.expects(:deadline_passed_emails).at_least_once
  #   Campaign.any_instance.stubs(:deadline).returns(Date.yesterday)
  #   Campaign.close_deadline_past_campaigns
  #   @campaign = Campaign.find_by_position_name("string 1")
  #   assert_equal false, @campaign.active
  # end

  # test "calls email method for soon to close campaigns" do
  #   Candidate.expects(:send_pending_emails).at_least_once
  #   Campaign.any_instance.stubs(:two_days_to_go).returns(:true)
  #   Campaign.select_soon_to_close_campaigns
  # end

  # test "two days to go selects campaigns correctly" do
  #   @campaign = Campaign.create(position_name: "string 1", deadline: Date.today+2.days, recruiter_id: 1)
  #   assert_equal true, @campaign.two_days_to_go
  # end

  # test "two days to go does not select campaigns with more or less than two days to go" do
  #   @campaign1 = Campaign.create(position_name: "string 1", deadline: Date.today+1.day, recruiter_id: 1)
  #   @campaign2 = Campaign.create(position_name: "string 2", deadline: Date.today+3.days, recruiter_id: 1)
  #   assert_equal nil, @campaign1.two_days_to_go
  #   assert_equal nil, @campaign2.two_days_to_go
  # end

  # test "send campaign deadline update emails" do
  #   @campaign = Campaign.new(deadline: Date.today())
  #   Candidate.expects(:reopened_mails)
  #   @campaign.send_deadline_update
  # end

  # test "send campaign closed calls deadline passed emails" do
  #   @campaign = Campaign.new(deadline: Date.today())
  #   Candidate.expects(:deadline_passed_mails)
  #   @campaign.send_campaign_closed
  # end

  # test "candidates are correctly processed base on email addresses" do
  #   @campaign = Campaign.create(deadline: Date.today(), recruiter_id: 1, position_name: "name")
  #   list = "cand1, cand2"
  #   CandidateMailer.stubs(:invitation).returns(CandidateMailer).twice
  #   CandidateMailer.stubs(:deliver).twice
  #   x, y = @campaign.process_candidates(list)
  #   assert_equal 2, @campaign.candidates.count
  #   assert_equal 2, @campaign.sent_invitations
  #   assert_equal 2, x
  #   assert_equal 2, y
  # end

  # test "duplicate candidates are not allowed" do
  #   @campaign = Campaign.create(deadline: Date.today(), recruiter_id: 1, position_name: "name")
  #   list = "cand1, cand1"
  #   CandidateMailer.stubs(:invitation).returns(CandidateMailer).once
  #   CandidateMailer.stubs(:deliver).once
  #   x, y = @campaign.process_candidates(list)
  #   assert_equal 1, @campaign.candidates.count
  #   assert_equal 1, @campaign.sent_invitations
  #   assert_equal 2, x
  #   assert_equal 1, y
  # end

  # test "existing candidates are not allowed" do
  #   @campaign = Campaign.create(deadline: Date.today(), recruiter_id: 1, position_name: "name")
  #   @campaign.candidates.create(email: "cand1")
  #   list = "cand1"
  #   x, y = @campaign.process_candidates(list)
  #   assert_equal 0, @campaign.sent_invitations
  #   assert_equal 1, x
  #   assert_equal 0, y
  # end

  # test "adding a candidate generates a welcome email" do
  #   @campaign = Campaign.create(deadline: Date.today(), recruiter_id: 1, position_name: "name")
  #   list = "cand1"
  #   @campaign.process_candidates(list)
  #   assert_equal ["cand1"], ActionMailer::Base.deliveries.last.to
  #   assert_equal "Invitation to virtual interview for name at Scotiabank.", ActionMailer::Base.deliveries.last.subject
  # end

end
