require 'spec_helper'

describe Issue do

describe "validations" do

it "validates presence of interview id for candidate category" do
  FactoryGirl.build(:issue, category: "candidate").should_not be_valid
end

it "does not require interview id for other categories" do
  FactoryGirl.build(:issue, category: "other").should be_valid
end

it "only allows categories of candidate, recruiter or other" do
  FactoryGirl.build(:issue, category: "string").should_not be_valid
end
end

describe "templates" do

it "gets candidate template if category is candidate" do
  issue = create(:issue, category: "candidate", interview_id: "string")
  issue.get_template.should == "candidate_issue_show"
end

it "gets recruiter template if category is recruiter" do
  issue = create(:issue, category: "recruiter")
  issue.get_template.should == "recruiter_issue_show"
end

it "gets issue template if category is other" do
  issue = create(:issue, category: "other")
  issue.get_template.should == "issue_show"
end
end

describe "switch status" do

  it "changes active from true to false if currently true" do
    issue = create(:issue, category: "other")
    issue.switch_status
    issue.active.should be_false
  end

  it "sends an email if currently true" do
    issue = create(:issue, category: "other")
    issue.switch_status
    ActionMailer::Base.deliveries.last.to.should == [issue.email]
    ActionMailer::Base.deliveries.last.subject.should == "Ticket ID: #{issue.id} ha sido cerrado"
  end

  it "changes from false to true if currently false" do
    issue = create(:issue, category: "other", active: "false")
    issue.switch_status
    issue.active.should be_true
  end

end

end