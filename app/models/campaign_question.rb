class CampaignQuestion < ActiveRecord::Base

  #Join model for Campaigns & Questions
  belongs_to :campaign
  belongs_to :question
  validates :question_id, :uniqueness => { scope: :campaign_id }

  attr_accessible :campaign_id, :question_id, :option

end
