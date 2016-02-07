require 'test_helper'

class CampaignQuestionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # test "text questions are properly added to campaign" do
  #   post :create_text_questions, campaign_id: 1, Integer: {"0"=>"1", "1"=>"2", "2"=>""}
  #   @campaign = Campaign.find(1)
  #   assert_equal 2, @campaign.questions.text.count
  # end

  # test "verbal questions are properly added to campaign" do
  #   post :create_verbal_questions, campaign_id: 1, Integer: {"0"=>"1", "1"=>"3", "2"=>"4"}
  #   @campaign = Campaign.find(1)
  #   assert_equal 2, @campaign.questions.verbal.count
  # end

end
