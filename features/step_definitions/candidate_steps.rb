# coding: utf-8
Given /^that I have a candidate$/ do
  @campaign = FactoryGirl.create(:campaign, recruiter_id: @recruiter.id)
  @candidate = FactoryGirl.create(:candidate, campaign_id: @campaign.id)
end

Given /^that I am a Candidate$/ do
  @recruiter = FactoryGirl.create(:recruiter)
  @campaign = FactoryGirl.create(:campaign, recruiter_id: @recruiter.id)
  @candidate = FactoryGirl.create(:candidate, campaign_id: @campaign.id)
end

Given /^that my campaign has (\d+) text question$/ do |arg1|
  @question = FactoryGirl.create(:question, kind: "text")
  CampaignQuestion.create(campaign_id: @campaign.id, question_id: @question.id)
end

Given(/^I have started the interview$/) do
  @candidate.update_attributes(privacy_consent: true)
end

Given(/^I have completed the text interview$/) do
  @candidate.update_attributes(completed_text_interview: true)
end

Given /^that the candidate has completed both interview parts$/ do
  @candidate.update_attributes(completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
end

Given /^I have completed my interview$/ do
  @candidate.update_attributes(completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
end

Given /^I am on the candidate page$/ do
  visit campaign_candidate_path(@campaign, @candidate)
end

Given(/^that the candidate has already been interviewed before$/) do
  @recruiter.organization.organization_account.update_attributes(additional_candidates: 2)
  @campaign2 = FactoryGirl.create(:campaign, recruiter_id: @recruiter.id, position_name: "Special Position")
  @candidate2 = FactoryGirl.create(:candidate, campaign_id: @campaign2.id, email: @candidate.email)
  @candidate2.update_attributes(completed_text_interview: true, completed_verbal_interview: true, privacy_consent: true)
  @candidate2.interview_completed_at = Date.new(2013,5,10)
  @candidate2.rejected = true
  @candidate2.save!
end

Given(/^I have cel "(.*?)"$/) do |arg1|
  @candidate.update_attributes(cel: arg1)
end

When /^I visit the start voice interview page$/ do
  visit candidate_start_voice_interview_path(@candidate)
end

When /^I go to the start interview link$/ do
  visit "/candidate_start_interview?interview_id=#{@candidate.uid}"
end

When /^I go to the recommend friends page$/ do
  visit candidate_recommend_friends_path(@candidate)
end

When /^I go to the provide references page$/ do
  visit candidate_provide_references_path(@candidate)
end

When /^I go to the candidate technical support page$/ do
   visit candidate_technical_support_path(@candidate)
end

When(/^I go to the start voice interview page$/) do
  visit candidate_start_voice_interview_path(@candidate)
end

When(/^I select a filter question answer$/) do
  @question_id = @candidate.campaign.questions.filter.first.id
  select 'Sí', from: "answers[#{@question_id}]"
end

Then /^the candidate should be accepted$/ do
  @candidate = @campaign.candidates.last
  @candidate.accepted.should == true
end

Then /^the candidate should be rejected$/ do
  @candidate = @campaign.candidates.last
  @candidate.rejected.should == true
end

Then /^the candidate should not exist$/ do
  @campaign.candidates.last.should be_nil
end

Then /^I should be on the candidate page$/ do
  current_path.should == campaign_candidate_path(@campaign, @candidate)
end

Then /^I should be on the recommend friends path$/ do
  current_path.should == candidate_recommend_friends_path(@candidate)
end

Then /^I should be on the interview confirmation path$/ do
  current_path.should == candidate_interview_confirmation_path(@candidate)
end

Then /^I should be on the Candidate FAQ path$/ do
  current_path.should == page_path("FAQ_candidate")
end

Then /^the candidate email should be "(.*?)"$/ do |arg1|
  @campaign.candidates.last.email.should == arg1
end

Then /^I should have "(.*?)" friends$/ do |arg1|
  @candidate.friends.count.should == arg1.to_i
end

Then /^I should have (\d+) references$/ do |arg1|
  @candidate.references.count.should == arg1.to_i
end

Then /^the message interview id should be the candidate uid$/ do
  @message = Message.last
  @message.interview_id.should == @candidate.uid
end

Then /^the message should have "(.*?)" recipients$/ do |arg1|
  @message = Message.last
  @message.message_recipients.count.should == arg1.to_i
end

Then(/^I should see the previous position name$/) do
  page.should have_content(@candidate2.position_name)
end

Then(/^I should see the interview date$/) do
  @d = @candidate2.interview_completed_at
  date = "#{@d.day}-#{@d.month}-#{@d.year}"
  page.should have_content(date)
end

Then(/^I should see the candidate decision$/) do
  page.should have_content(", Rechazado")
end

Then(/^I should be on the "(.*?)" interview page$/) do |arg1|
  if arg1 == "text"
    path = candidate_start_text_interview_path(@candidate)
  elsif arg1 == "voice"
    path = candidate_start_voice_interview_path(@candidate)
  end
  current_path.should == path
end

Then(/^I should be on the answer filter questions page$/) do
  current_path.should == candidate_filter_questions_path(@candidate)
end