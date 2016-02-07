require 'spec_helper'

describe CampaignQuestion do
  describe "validates uniqueness of questions" do
    it "ensures you cannot add same question to campaign more than once" do
      CampaignQuestion.create(campaign_id: 1, question_id: 1)
      @question = CampaignQuestion.create(campaign_id: 1, question_id: 1)
      @question.valid?.should be_false
    end
  end
end