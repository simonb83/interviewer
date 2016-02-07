Given /^that I am logged in as an Admin$/ do
  password = "gh7tklmnp45"
  @admin = FactoryGirl.create(:admin, password: password)
  visit new_admin_session_path
  fill_in "email-input", with: @admin.email
  fill_in "password-input", with: password
  click_on "form-submit"
end

Given(/^there exists at least (\d+) account$/) do |arg1|
  FactoryGirl.create(:account)
end

Given /^that I have created an organization with name "(.*?)"$/ do |arg1|
  @organization = FactoryGirl.create(:organization, name: arg1, account_id: 1)
end

Given /^that I have created a New Recruiter with name "(.*?)"$/ do |arg1|
  @recruiter = FactoryGirl.create(:recruiter, name: arg1)
end

Given /^I am on the manage organization page$/ do
  visit organization_path(@organization)
end

Given /^I am on the manage recruiter page for "(.*?)"$/ do |arg1|
  visit recruiter_manage_path(Recruiter.find_by_name(arg1))
end

When /^I go to edit "(.*?)"$/ do |arg1|
  click_on "manage-recruiter-1"
end

When /^I click on delete for "(.*?)" question "(.*?)"$/ do |arg1, arg2|
  question = Question.where("content = ? AND kind = ?", arg2, arg1).first
  click_on "delete-#{arg1}-question-#{question.id}"
end

When /^I click on edit for "(.*?)" question "(.*?)"$/ do |arg1, arg2|
  question = Question.where("content = ? AND kind = ?", arg2, arg1).first
  click_on "edit-#{arg1}-question-#{question.id}"
end

When /^I click on edit category for "(.*?)"$/ do |arg1|
  category = Category.find_by_name(arg1)
  click_on "edit-category-#{category.id}"
end

Then /^I should be on the manage organization page$/ do
  @organization = Organization.last
  current_path.should == organization_path(@organization)
end

Then /^I should be back on my home page$/ do
  current_path.should == admin_path(@admin)
end

Then /^I should be on the manage recruiter page for "(.*?)"$/ do |arg1|
  current_path.should == recruiter_manage_path(Recruiter.find_by_name(arg1))
end

Then /^"(.*?)" should not exist$/ do |arg1|
  Organization.find_by_name(arg1).should be_nil
end

Then /^"(.*?)" should belong to "(.*?)"$/ do |arg1, arg2|
  Recruiter.find_by_name(arg1).organization.should == Organization.find_by_name(arg2)
end

Then /^recruiter "(.*?)" should not exist$/ do |arg1|
  Recruiter.find_by_name(arg1).should be_nil
end

Then /^I should be on the category page for "(.*?)"$/ do |arg1|
  current_path.should == category_path(Category.find_by_name(arg1))
end

Then /^"(.*?)" should have a "(.*?)" question called "(.*?)"$/ do |arg1, arg2, arg3|
  Question.where("content = ? AND kind = ?", arg3, arg2).should_not be_nil
  question = Question.where("content = ? AND kind = ?", arg3, arg2).first
  question.category.should == Category.find_by_name(arg1)
end

Then /^"(.*?)" should not have a "(.*?)" question called "(.*?)"$/ do |arg1, arg2, arg3|
  Question.where("content = ? AND kind = ?", arg3, arg2).should == []
end

Then /^"(.*?)" should exist$/ do |arg1|
  Category.find_by_name(arg1).should_not be_nil
end

Then(/^I should see correct anniversary date$/) do
  text = "Anniversary: #{Date.today().day.ordinalize} of each month"
  page.should have_content(text)
end