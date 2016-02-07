Given /^that I have an active campaign$/ do
  @campaign = FactoryGirl.create(:campaign, recruiter: @recruiter)
end

Given /^that I have a closed campaign$/ do
  @campaign = FactoryGirl.create(:campaign, recruiter_id: @recruiter.id, active: false)
end

Given /^I have added (\d+) "(.*?)" questions to the campaign$/ do |arg1, arg2|
  n = arg1.to_i
  n.times do
    @q = FactoryGirl.create(:question, kind: arg2)
    CampaignQuestion.create(campaign_id: @campaign.id, question_id: @q.id)
  end
end

Given /^I have added a "(.*?)" question to the campaign with content "(.*?)"$/ do |arg1, arg2|
  @q = FactoryGirl.create(:question, kind: arg1, content: arg2)
  CampaignQuestion.create(campaign_id: @campaign.id, question_id: @q.id)
end

Given /^my campaign is closed$/ do
  @campaign.update_attribute(:active, false)
end

Given /^I am on the campaign page$/ do
  visit recruiter_campaign_path(@recruiter,@campaign)
end

Given /^I am on the questions confirmation path$/ do
  visit campaign_question_confirmation_path(@campaign)
end

When /^I am on the new campaign page$/ do
  visit new_recruiter_campaign_path(@recruiter)
end

Then(/^I should be on the campaign choose filter questions path$/) do
  @campaign = @recruiter.campaigns.last
  current_path.should == campaign_choose_filter_options_path(@campaign)
end

Then /^I should be on the campaign choose text questions path$/ do
  @campaign = @recruiter.campaigns.last
  current_path.should == campaign_choose_text_questions_path(@campaign)
end

Then /^I should be on the enter more candidates page$/ do
  current_path.should == campaign_enter_more_candidates_path(@campaign)
end

Then /^I should be back on the campaign page$/ do
  current_path.should == recruiter_campaign_path(@recruiter,@campaign)
end

Then /^I should be on the change deadline page$/ do
  current_path.should == campaign_choose_deadline_path(@campaign)
end

Then /^I should be on the edit questions page$/ do
  page.should have_content("Editar Preguntas")
end

Then /^I should be on the show questions page$/ do
  current_path.should == campaign_show_questions_path(@campaign)
end

Then /^I should be on the edit text questions page$/ do
  current_path.should == campaign_edit_text_questions_path(@campaign)
end

Then /^my campaign deadline should have day "(.*?)"$/ do |arg1|
  @campaign = @recruiter.campaigns.first
  @campaign.deadline.day.should == arg1.to_i
end

Then /^my campaign deadline should have month "(.*?)"$/ do |arg1|
  @campaign = @recruiter.campaigns.last
  @campaign.deadline.month.should == arg1.to_i
end

Then /^campaign should be closed$/ do
  @campaign = @recruiter.campaigns.last
  @campaign.active.should be_false
end

Then /^campaign should not exist$/ do
  @recruiter.campaigns.last.should be_nil
end

Then /^recommend friends should be "(.*?)"$/ do |arg1|
  @campaign = @recruiter.campaigns.last
  if arg1 == "true"
    test = true
  else
    test = false
  end
  @campaign.recommend_friends.should == test
end

Then /^candidate references should be "(.*?)"$/ do |arg1|
  @campaign = @recruiter.campaigns.last
  if arg1 == "true"
    test = true
  else
    test = false
  end
  @campaign.candidate_references.should == test
end

Then /^the campaign should have name "(.*?)"$/ do |arg1|
  Campaign.last.position_name.should == arg1
end

Then(/^the campaign should have company_name as "(.*?)"$/) do |arg1|
  Campaign.last.company_name.should == arg1
end

Then /^the campaign should have attribute "(.*?)" as "(.*?)"$/ do |arg1, arg2|
  if arg2 == 'true'
    Campaign.last.send(arg1.to_sym).should be_true
  else
    Campaign.last.send(arg1.to_sym).should_not be_true
  end
end