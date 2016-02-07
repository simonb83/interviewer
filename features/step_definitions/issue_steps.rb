When /^I go to the technical support page$/ do
  visit technical_support_path
end

Then /^I should be on the issue page$/ do
  @issue = Issue.last
  current_path.should == issue_path(@issue)
end

Then /^the issue email should be the candidate email$/ do
  @issue.email.should == @candidate.email
end

Then /^the issue email should be the recruiter email$/ do
  @issue.email.should == @recruiter.email
end

Then /^the issue email should be "(.*?)"$/ do |arg1|
  @issue.email.should == arg1
end

Then /^the issue name should be "(.*?)"$/ do |arg1|
  @issue.name.should == arg1
end

Then /^the issue interview id should be the candidate uid$/ do
  @issue.interview_id.should == @candidate.uid
end

Then /^the issue interview id should be "(.*?)"$/ do |arg1|
  @issue.interview_id.should == arg1
end

Then /^the issue category should be "(.*?)"$/ do |arg1|
  @issue.category.should == arg1
end

Then /^the issue content should be "(.*?)"$/ do |arg1|
  @issue.content.should == arg1
end

Then /^the issue should be active$/ do
  @issue.active.should be_true
end