require 'spec_helper'

describe Answer do

  describe ".mp3_recent" do
    it "creates mp3 links correctly" do
      @answer = Answer.new
      @answer.stub(:content).and_return("http://link")
      @answer.mp3_url.should == "https://link.mp3"
    end
  end

  describe "validates uniqueness" do
    it "ensures each candidate can only provide one answer per question" do
      Answer.create(content: "string", candidate_id: "1", question_id: "1")
      @answer = Answer.new(content: "string", candidate_id: "1", question_id: "1")
      @answer.valid?.should be_false
    end
  end

end