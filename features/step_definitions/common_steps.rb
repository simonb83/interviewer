When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in arg1, with: arg2
end

When /^I choose "(.*?)"$/ do |arg1|
  choose arg1
end

When /^I click on "(.*?)"$/ do |arg1|
  click_on arg1
end

When /^I click on t\("(.*?)"\)$/ do |arg1|
  sym = arg1.to_sym
  click_on t(sym)
end

When /^I select "(.*?)" from "(.*?)"$/ do |arg1, arg2|
  select arg1, from: arg2
end

When /^I check "(.*?)"$/ do |arg1|
  check arg1
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content(arg1)
end

Then /^I should see a link for "(.*?)"$/ do |arg1|
  page.should have_link(arg1)
end

Then(/^the page should have input with id "(.*?)"$/) do |arg1|
  page.should have_field(arg1)
end

When /^I visit "(.*?)"$/ do |arg1|
  visit arg1
end

When /^I visit the home page$/ do
  visit root_path
end

Then /^the response status should be "(.*?)"$/ do |arg1|
  page.status_code.should == arg1.to_i
end