require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
   include Devise::TestHelpers

  # test "update deadline changes status of closed campaign" do
  #   put :update_deadline, recruiter_id: 1, campaign_id: 2, :campaign => {"deadline(3i)"=>"2", "deadline(2i)"=>"12", "deadline(1i)"=>"2012"}
  #   @campaign = Campaign.find(2)
  #   assert_equal true, @campaign.active
  # end

  # test "update deadline generates email to pending candidates" do
  #   @campaign = Campaign.create(recruiter_id: 1, position_name: "position", deadline: Date.tomorrow)
  #   @candidate = @campaign.candidates.create(email: "string")
  #   put :update_deadline, recruiter_id: 1, campaign_id: @campaign.id, :campaign => {"deadline(3i)"=>"2", "deadline(2i)"=>"12", "deadline(1i)"=>"2012"}
  #   assert_equal [@candidate.email], ActionMailer::Base.deliveries.last.to
  #   assert_equal "Your virtual interview has been reopened or the deadline extended.", ActionMailer::Base.deliveries.last.subject
  # end

end
