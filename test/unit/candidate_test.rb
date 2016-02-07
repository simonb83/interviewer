require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  fixtures :all

  # def create_campaign
  #   @campaign = Campaign.create(recruiter_id: 1, active: true, position_name: "Position New", deadline: Date.today(), recommend_friends: true)
  # end

  # test "candidates who are not rejected or accepted are pending" do
  #   id = Campaign.last.id
  #   candidate = Candidate.create(email: "string", campaign_id: id)
  #   assert_equal true, candidate.pending?
  # end

  # test "generates interview id on create for new candidates" do
  #   create_campaign
  #   @candidate = @campaign.candidates.create(email: "string")
  #   @candidate = Candidate.last
  #   assert_equal true, @candidate.uid?
  # end

  # test "uid is not change on save for already created candidates" do
  #   create_campaign
  #   @candidate = @campaign.candidates.create(email: "string")
  #   uid = @candidate.uid
  #   @candidate.update_attribute(:email, "string-new")
  #   assert_equal uid, @candidate.uid
  # end

  # test "save updates interview status when text and verbal parts are completed" do
  #   create_campaign
  #   @candidate = @campaign.candidates.create(email: "string", completed_text_interview: true, completed_verbal_interview: true)
  #   assert_equal true, @candidate.completed_interview
  # end

  # test "save calls CandidateMailer when text and verbal parts are completed" do
  #   create_campaign
  #   CandidateMailer.stubs(:completed).returns(Candidate.new)
  #   Candidate.any_instance.stubs(:deliver).once
  #   @candidate = @campaign.candidates.create(email: "string", completed_text_interview: true)
  #   @candidate.update_attribute(:completed_verbal_interview, true)
  # end

  # test "save does not update interview status if text or verbal part is not completed" do
  #   create_campaign
  #   @candidate1 = @campaign.candidates.create(email: "string1", completed_text_interview: true)
  #   @candidate2 = @campaign.candidates.create(email: "string2", completed_verbal_interview: true)
  #   assert_equal false, @candidate1.completed_interview, "Candidate 1 error"
  #   assert_equal false, @candidate2.completed_interview, "Candidate 1 error"
  # end

  # test "correctly identifies if candidate has recommended friends for campaign" do
  #   create_campaign
  #   @c1 = @campaign.candidates.create(email: "string1")
  #   @c2 = @campaign.candidates.create(email: "string2", recommended_friends: "string")
  #   assert_equal [false,true], [@c1.recommended_friends?,@c2.recommended_friends?]
  # end

# test "must identify all candidates as having recommended friends for campaign where it is not allowed" do
#   create_campaign
#   @campaign.update_attribute(:recommend_friends, false)
#   @candidate = @campaign.candidates.create(email: "string2")
#   assert_equal true, @candidate.recommended_friends?
# end

# test "correctly identifies candidate interview stage" do
#   create_campaign
#   @c1 = @campaign.candidates.create(email: "string1", completed_text_interview: true, completed_verbal_interview: true, recommended_friends: "string")
#   @c2 = @campaign.candidates.create(email: "string2", completed_text_interview: true, completed_verbal_interview: true)
#   @c3 = @campaign.candidates.create(email: "string3", completed_text_interview: true)
#   @c4 = @campaign.candidates.create(email: "string4")
#   assert_equal 4, @c1.interview_stage
#   assert_equal 3, @c2.interview_stage
#   assert_equal 2, @c3.interview_stage
#   assert_equal 1, @c4.interview_stage
# end

# def create_campaign_for_mailer
# create_campaign
# @campaign.candidates.create(email: "s1")
# @campaign.candidates.create(email: "s2")
# end

# test "deadline passed emails invoques CandidateMailer.deadline_passed" do
# create_campaign_for_mailer
# CandidateMailer.stubs(:deadline_passed).returns(Candidate)
# Candidate.expects(:deliver).twice
# Candidate.deadline_passed_mails(@campaign)
# end

# test "reopened emails invoques CandidateMailer.reopened" do
# create_campaign_for_mailer
# CandidateMailer.stubs(:reopened).returns(Candidate)
# Candidate.expects(:deliver).twice
# Candidate.reopened_mails(@campaign)
# end

# test "send pending emails invoques CandidateMailer.reminder" do
# create_campaign_for_mailer
# CandidateMailer.stubs(:reminder).returns(Candidate)
# Candidate.expects(:deliver).twice
# Candidate.send_pending_emails(@campaign)
# end

# test "completing interview generates completed email" do
#   create_campaign
#   @candidate = @campaign.candidates.create(email: "string")
#   @candidate.update_attributes(completed_verbal_interview: true, completed_text_interview: true)
#   assert_equal [@candidate.email], ActionMailer::Base.deliveries.last.to
#   assert_equal "Completion of virtual interview.", ActionMailer::Base.deliveries.last.subject
# end


end
