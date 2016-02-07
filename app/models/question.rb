class Question < ActiveRecord::Base

#Questions are related to campaigns through CampaignQuestions, and belong to categories
has_many :campaign_questions
has_many :campaigns, through: :campaign_questions
has_many :question_answers
has_many :answers, through: :question_answers
belongs_to :category

attr_accessible :kind, :category, :content, :category_id

scope :text, where("kind = ?", "text")
scope :verbal, where("kind = ?", "verbal")
scope :filter, where("kind = ?", "filter")

def text?
  if self.kind == "text"
    true
  else
    false
  end
end

def verbal?
  if self.kind == "verbal"
    true
  else
    false
  end
end

def candidate_answer(id)
  self.answers.find_by_candidate_id(id)
end

def required_option(campaign)
  CampaignQuestion.where(campaign_id: campaign.id, question_id: self.id).first.option
end

end
