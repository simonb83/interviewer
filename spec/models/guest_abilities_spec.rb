require 'spec_helper'
require "cancan/matchers"

describe "Guest" do

  before(:each) { @ability = Ability.new(nil) }
  subject { @ability }

  it "should be able to manage calls" do
    should be_able_to(:manage, Call.new)
  end

  it "should not be able to manage campaigns" do
    should_not be_able_to(:manage, create(:campaign))
  end

  it "should not be able to manage campaign questions" do
    should_not be_able_to(:manage, CampaignQuestion.new)
  end

  it "should be able to create friends" do
    should be_able_to(:create, Friend.new)
  end

  it "should be able to recommend friends" do
    should be_able_to(:recommend_friends, Friend.new)
  end

  it "should be able to add_friends" do
    should be_able_to(:add_friends, Friend.new)
  end

  it "should be able to create issues with category candidate" do
    should be_able_to(:create, Issue.new(category: "candidate"))
  end

  it "should be able to create issues with category other" do
    should be_able_to(:create, Issue.new(category: "other"))
  end

  it "should be able to read issues with category candidate" do
    should be_able_to(:read, Issue.new(category: "candidate"))
  end

  it "should be able to read issues with category other" do
    should be_able_to(:read, Issue.new(category: "other"))
  end

  it "should not be able to manage messages" do
    should_not be_able_to(:manage, Message.new)
  end

  it "should not be able to manage message recipients" do
    should_not be_able_to(:manage, MessageRecipient.new)
  end

  it "should not be able to manage organizations" do
    should_not be_able_to(:manage, Organization.new)
  end

   it "should not be able to manage questions" do
    should_not be_able_to(:manage, Question.new)
  end

  it "should not be able to manage recruiters" do
    should_not be_able_to(:manage, Recruiter.new)
  end

  it "should be able to create answers to questions" do
    should be_able_to(:create, QuestionAnswer.new)
  end

  it "should be able to create answers" do
    should be_able_to(:create, Answer.new)
  end

  it "should be able to add answers" do
    should be_able_to(:add_answers, Answer.new)
  end

  it "should be able to view externally shared candidates" do
    candidate = create(:candidate)
    should be_able_to(:shared_external, candidate)
  end

  it "should not be able to view guides" do
    File.stub(:open)
    guide = FactoryGirl.create(:guide, name: "My New Name")
    should_not be_able_to(:read, guide)
  end

end