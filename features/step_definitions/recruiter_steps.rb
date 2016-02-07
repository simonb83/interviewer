Given /^that I am logged in as a recruiter$/ do
  password = "ae56tghjks"
  @recruiter = FactoryGirl.create(:recruiter, password: password, new_user: false)
  visit new_recruiter_session_path
  fill_in "email-input", with: @recruiter.email
  fill_in "password-input", with: password
  click_on "Enviar"
end

Given /^that my account has (\d+) Candidates included$/ do |arg1|
  @recruiter.organization.account.update_attributes!(included_candidates: arg1)
end

Given /^that a recruiter account has been created with a generic password$/ do
  @recruiter = FactoryGirl.create(:recruiter, email: "myemail@email.com", password: "mypassword")
end

Given /^that the recruiter has already logged in once$/ do
  @recruiter.update_attribute(:new_user, false)
end

Given /^there is a second recruiter$/ do
  @organization = @recruiter.organization
  @recruiter2 = FactoryGirl.create(:recruiter, organization_id: @organization.id, name: "Simon Bedford")
end

Given /^I have at least one campaign$/ do
  @campaign = @recruiter.campaigns.create(position_name: "unique name", deadline: Date.tomorrow())
end

Given /^that I create a campaign$/ do
  @campaign = @recruiter.campaigns.create(position_name: "unique name", deadline: Date.tomorrow())
end

Given(/^that I add (\d+) candidate to my campaign$/) do |arg1|
  arg1.to_i.times do |i|
    Candidate.create(email: "email#{i}@email.com", campaign_id: @campaign.id)
  end
end

Given(/^that I have contracted (\d+) additional candidates$/) do |arg1|
  @recruiter.organization.organization_account.update_attributes(additional_candidates: arg1.to_i)
end

Given(/^that the first candidate has commenced his interview$/) do
  @candidate = @campaign.candidates.first
  @candidate.update_attributes(privacy_consent: true)
end

Given /^I have at least one message$/ do
  @candidate = FactoryGirl.create(:candidate, completed_text_interview: true, completed_verbal_interview: true, campaign_id: @campaign.id)
  @message = FactoryGirl.create(:message, recruiter_id: @recruiter.id, interview_id: @candidate.uid)
  @message.message_recipients.create(email: @recruiter.email, message_id: @message.id, recruiter_id: @recruiter.id)
end

Given(/^my account has been suspended$/) do
  @recruiter.organization.update_attributes(active: false)
end

When /^I visit the recruiter page$/ do
  visit recruiter_path(@recruiter)
end

When /^I go to the recruiter technical support page$/ do
  visit recruiter_technical_support_path(@recruiter)
end

When(/^I visit my campaign page$/) do
  visit campaign_path(@recruiter,@campaign)
end

When(/^I click on candidate (\d+)$/) do |arg1|
  click_on "email#{arg1}@email.com"
end

Then /^I should be back on the recruiter page$/ do
  current_path.should == recruiter_path(@recruiter)
end

Then /^I should see the position name$/ do
  page.should have_content(@campaign.position_name)
end

Then /^I should see the message interview id$/ do
  page.should have_content(@candidate.uid)
end

Then /^the message should not exist$/ do
  @recruiter.messages.count.should == 0
end

Then /^I should be on the change password page$/ do
  current_path.should == recruiter_change_password_path(@recruiter)
end

Then(/^I should have (\d+) campaign$/) do |arg1|
  @recruiter.campaigns.count.should == arg1.to_i
end

Then(/^I should be on the edit recruiter page$/) do
  current_path.should == edit_recruiter_path(@recruiter)
end