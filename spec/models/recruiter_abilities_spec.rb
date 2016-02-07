require 'spec_helper'
require "cancan/matchers"

describe "Recruiter" do

  describe "recruiter management abilities" do
    it "should be able to manage own account" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:manage, recruiter)
    end

    it "should not be able to manage other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:manage, create(:recruiter))
    end
  end

  describe "campaign management abilities" do
    it "should be able to create campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:create, Campaign.new(recruiter_id: recruiter.id))
    end

    it "should be able to view own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:read, Campaign.new(recruiter_id: recruiter.id))
    end

    it "should not be able to view campaigns from other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:read, Campaign.new)
    end

    it "should be able to update own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:update, Campaign.new(recruiter_id: recruiter.id))
    end

    it "should not be able to update campaigns from other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:update, Campaign.new)
    end

    it "should be able to destroy own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:destroy, Campaign.new(recruiter_id: recruiter.id))
    end

    it "should not be able to destroy campaigns from other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:destroy, Campaign.new)
    end

    it "should be able to update deadline on own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:update_deadline, Campaign.new(recruiter_id: recruiter.id))
    end

     it "should not be able to update deadline on campaigns from other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:update_deadline, Campaign.new)
    end

    it "should be able to close own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:close, Campaign.new(recruiter_id: recruiter.id))
    end

     it "should not be able to close campaigns from other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:close, Campaign.new)
    end
  end

  describe "question management abilities" do
    it "should be able to add questions to own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should be_able_to(:create, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end

    it "should be able to add text questions to own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should be_able_to(:create_text_questions, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end

    it "should be able to add verbal questions to own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should be_able_to(:create_verbal_questions, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end

    it "should not be able to add questions to campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:create, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end

    it "should be able to add text questions to campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:create_text_questions, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end

    it "should be able to add verbal questions to campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign)
      question = create(:question, kind: "text")
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:create_verbal_questions, CampaignQuestion.new(campaign_id: campaign.id, question_id: question.id))
    end
  end

  describe "candidate management abilities" do
    it "should be able to manage candidates within own campaigns" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:manage, create(:candidate, campaign: campaign))
    end

    it "should not be able to manage candidates within campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:manage, create(:candidate))
    end

    it "should be able to view shared candidates within own organization" do
      org = create(:organization)
      recruiter_1 = create(:recruiter, organization: org, new_user: false)
      recruiter_2 = create(:recruiter, organization: org, new_user: false)
      campaign = create(:campaign, recruiter: recruiter_2)
      ability = Ability.new(recruiter_1)
      ability.should be_able_to(:shared_external, create(:candidate, campaign: campaign))
    end

    it "should not be able to view shared candidates within other organizations" do
      recruiter_1 = create(:recruiter, new_user: false)
      recruiter_2 = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter_2)
      ability = Ability.new(recruiter_1)
      ability.should_not be_able_to(:shared_external, create(:candidate, campaign: campaign))
    end

    it "should be able to add candidates to own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:add_candidates, create(:candidate, campaign: campaign))
    end

    it "should not be able to add candidates to campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:add_candidates, create(:candidate))
    end

    it "should be able to add more candidates to own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:add_more_candidates, create(:candidate, campaign: campaign))
    end

    it "should not be able to add more candidates to campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:add_more_candidates, create(:candidate))
    end

    it "should be able to accept candidates in own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:accept, create(:candidate, campaign: campaign))
    end

    it "should not be able to accept candidates in campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:accept, create(:candidate))
    end

    it "should be able to reject candidates in own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:reject, create(:candidate, campaign: campaign))
    end

    it "should not be able to reject candidates in campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:reject, create(:candidate))
    end

    it "should be able to update email for candidates in own campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:update_email, create(:candidate, campaign: campaign))
    end

    it "should not be able to update email for candidates in campaigns of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:update_email, create(:candidate))
    end

    it "should be able to share candidates from campaign" do
      recruiter = create(:recruiter, new_user: false)
      campaign = create(:campaign, recruiter: recruiter)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:share, create(:candidate, campaign: campaign))
    end

    it "should not be able to share candidates from of other recruiters" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:share, create(:candidate))
    end

  end

  describe "issues abilities" do

    it "lets recruiters create issues with category recruiter" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:create, Issue.new(recruiter_id: recruiter.id, category: "recruiter"))
    end

    it "does not let recruiters create issues with category candidate" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should_not be_able_to(:create, Issue.new(category: "candidate"))
    end

    it "lets recruiters view issues they have created" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:read, Issue.new(recruiter_id: recruiter.id, category: "recruiter"))
    end

    it "does not let recruiters view issues created by other recruiters" do
      recruiter_1 = create(:recruiter, new_user: false)
      recruiter_2 = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter_1)
      ability.should_not be_able_to(:read, Issue.new(recruiter_id: recruiter_2.id, category: "recruiter"))
    end
  end

  describe "messages abilities" do

    it "lets recruiters send messages" do
      recruiter = create(:recruiter, new_user: false)
      ability = Ability.new(recruiter)
      ability.should be_able_to(:send_message, Message.new)
    end

    it "lets recruiters delete messages sent to them" do
      recruiter_1 = create(:recruiter, new_user: false)
      recruiter_2 = create(:recruiter, new_user: false)
      message = Message.create(recruiter_id: recruiter_1.id)
      MessageRecipient.create(message_id: message.id, recruiter_id: recruiter_2.id)
      ability = Ability.new(recruiter_2)
      ability.should be_able_to(:destroy, message)
    end

    it "does not let recruiters delete messages not sent to them" do
      recruiter_1 = create(:recruiter, new_user: false)
      recruiter_2 = create(:recruiter, new_user: false)
      message = Message.create(recruiter_id: recruiter_1.id)
      MessageRecipient.create(message_id: message.id, recruiter_id: recruiter_2.id)
      ability = Ability.new(recruiter_1)
      ability.should_not be_able_to(:destroy, message)
    end
  end

  describe "abilities of new users" do
    def new_recruiter
      @recruiter = create(:recruiter)
      @ability = Ability.new(@recruiter)
    end

    it "cannot create campaigns" do
      new_recruiter
      @ability.should_not be_able_to(:create, Campaign.new)
    end

    it "cannot read campaigns" do
      new_recruiter
      @ability.should_not be_able_to(:read, Campaign.new)
    end

    it "cannot visit own home page" do
      new_recruiter
      @ability.should_not be_able_to(:show, @recruiter)
    end

    it "cannot create candidates" do
      new_recruiter
      @ability.should_not be_able_to(:create, Candidate.new)
    end

    it "can create help tickets" do
      new_recruiter
      @ability.should be_able_to(:create, Issue.new(category: "recruiter", recruiter_id: @recruiter.id))
    end

    it "can read help tickets" do
      new_recruiter
      @ability.should be_able_to(:read, Issue.create(category: "recruiter", recruiter_id: @recruiter.id))
    end

  end

  describe "guides abilities" do

    def new_recruiter
      @recruiter = create(:recruiter, new_user: false)
      @ability = Ability.new(@recruiter)
      Guide.any_instance.stub(:create_template).and_return(true)
      @guide = FactoryGirl.create(:guide, name: "My New Name")
    end

    it "can view guides" do
      new_recruiter
      @ability.should be_able_to(:read, @guide)
    end

    it "cannot destroy guides" do
      new_recruiter
      Guide.any_instance.stub(:remove_template).and_return(true)
      @ability.should_not be_able_to(:destroy, @guide)
    end

    it "cannot update guides" do
      new_recruiter
      Guide.any_instance.stub(:rename_template).and_return(true)
      @ability.should_not be_able_to(:update, @guide)
    end

  end

  describe  "abilities of suspended account" do

    def new_recruiter
      @organization = create(:organization, active: false)
      @recruiter = create(:recruiter, organization: @organization, new_user: false)
      @ability = Ability.new(@recruiter)
    end

    it "should be able to view recruiter home page" do
      new_recruiter
      @ability.should be_able_to(:show, @recruiter)
    end

    it "should be able to change and update password" do
      new_recruiter
      @ability.should be_able_to(:change_password, @recruiter)
      @ability.should be_able_to(:update_password, @recruiter)
    end

    it "should be able to edit and update own account" do
      new_recruiter
      @ability.should be_able_to(:edit, @recruiter)
      @ability.should be_able_to(:update, @recruiter)
    end

    it "should be able to open an issue" do
      new_recruiter
      @ability.should be_able_to(:create, Issue.new(category: "recruiter", recruiter_id: @recruiter.id))
      @ability.should be_able_to(:read, Issue.create(category: "recruiter", recruiter_id: @recruiter.id))
    end

    it "cannot create campaigns" do
      new_recruiter
      @ability.should_not be_able_to(:create, Campaign.new)
    end

    it "cannot read campaigns" do
      new_recruiter
      @ability.should_not be_able_to(:read, Campaign.new)
    end

    it "cannot create candidates" do
      new_recruiter
      @ability.should_not be_able_to(:create, Candidate.new)
    end

  end

end