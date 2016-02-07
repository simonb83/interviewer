Given /^that I am a candidate$/ do
  @candidate = FactoryGirl.create(:candidate)
end

Given /^my campaign has two text questions$/ do
  @campaign = @candidate.campaign
  2.times {
    @question = FactoryGirl.create(:question, kind: "text")
    CampaignQuestion.create(campaign_id: @campaign.id, question_id: @question.id)
  }
end

Given /^my campaign has two verbal questions$/ do
  @campaign = @candidate.campaign
  2.times {
    @question = FactoryGirl.create(:question, kind: "verbal")
    CampaignQuestion.create(campaign_id: @campaign.id, question_id: @question.id)
  }
end

Given /^I am on the text questions page$/ do
  visit candidate_start_text_interview_path(@candidate)
end

When /^I fill in the first question with "(.*?)"$/ do |arg1|
  fill_in "answer_1", with: arg1
end

When /^I fill in the second question with "(.*?)"$/ do |arg1|
  fill_in "answer_2", with: arg1
end

Then /^I should be on the start voice interview page$/ do
  current_path.should == candidate_start_voice_interview_path(@candidate)
end

Then /^I should have two answers$/ do
  @candidate.answers.count.should == 2
end