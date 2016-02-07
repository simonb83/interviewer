# encoding: utf-8
require 'spec_helper'

describe Campaign do

  describe ".status"  do
    it "active campaigns have status active" do
      campaign = create(:campaign)
      campaign.status.should == "activo"
    end
    it "non-active campaigns have status closed" do
      campaign = create(:campaign, active: false)
      campaign.status.should == "cerrado"
    end
  end

  describe "create uid" do
    it "generates id on create for new campaigns" do
      campaign = create(:campaign)
      campaign.uid?.should be_true
    end

    it "does not include blank spaces" do
      campaign = create(:campaign, position_name:"a b")
      campaign.uid.should_not include(" ")
    end
  end

  describe "validations" do
    it "validates presence of required name field" do
      campaign = build(:campaign, position_name: "")
      campaign.should_not be_valid
    end
    it "validates date is not in past" do
      campaign = build(:campaign, deadline: Date.yesterday)
      campaign.should_not be_valid
    end
  end

  describe ".combined_display" do
    it "displays combines UID and Position Name" do
      campaign = build(:campaign, position_name: "Position")
      campaign.stub(:uid).and_return("ABCDE")
      campaign.save
      campaign.combined_display.should == "ABCDE - Position"
    end
  end

  describe "self.close_deadline_past_campaigns" do
    it "closes campaign" do
      campaign = create(:campaign, position_name: "position-1")
      Candidate.stub(:deadline_passed_mails)
      Campaign.any_instance.stub(:deadline).and_return(Date.yesterday)
      Campaign.close_deadline_past_campaigns
      campaign = Campaign.find_by_position_name("position-1")
      campaign.active.should be_false
    end
    it "sends deadline past emails" do
      campaign = create(:campaign)
      Candidate.should_receive(:deadline_passed_mails).once
      Campaign.any_instance.stub(:deadline).and_return(Date.yesterday)
      Campaign.close_deadline_past_campaigns
    end
  end

  describe ".select_soon_to_close_campaigns" do
    it "calls email method for soon to close campaigns" do
      campaign = create(:campaign)
      Candidate.should_receive(:send_pending_emails).once
      Campaign.any_instance.stub(:two_days_to_go).and_return(:true)
      Campaign.select_soon_to_close_campaigns
    end
  end

  describe ".two_days_to_go" do
    it "selects campaigns correctly" do
      campaign = create(:campaign, deadline: Date.today+2.days)
      campaign.two_days_to_go.should be_true
    end

    it "does not select campaigns with more or less than two days to go" do
      campaign1 = create(:campaign, deadline: Date.today + 1.day)
      campaign2 = create(:campaign, deadline: Date.today + 3.days)
      campaign1.two_days_to_go.should be_nil
      campaign2.two_days_to_go.should be_nil
    end
  end

  describe "switch recommend friends status" do
    it "inverts from true to false" do
      campaign = create(:campaign)
      campaign.switch_recommend_friends
      c = Campaign.find(campaign.id)
      c.recommend_friends.should_not be_true
    end

    it "inverts from false to true" do
      campaign = create(:campaign, recommend_friends: false)
      campaign.switch_recommend_friends
      c = Campaign.find(campaign.id)
      c.recommend_friends.should be_true
    end
  end

  describe "switch candidate references status" do
    it "inverts from true to false" do
      campaign = create(:campaign)
      campaign.switch_candidate_references
      c = Campaign.find(campaign.id)
      c.candidate_references.should_not be_true
    end

    it "inverts from false to true" do
      campaign = create(:campaign, candidate_references: false)
      campaign.switch_candidate_references
      c = Campaign.find(campaign.id)
      c.candidate_references.should be_true
    end
  end

  describe "switch receive_apps" do
    it "inverts from true to false" do
      campaign = create(:campaign, receive_applications: true)
      campaign.switch_receive_apps
      c = Campaign.find(campaign.id)
      c.receive_applications.should_not be_true
    end

    it "inverts from false to true" do
      campaign = create(:campaign)
      campaign.switch_receive_apps
      c = Campaign.find(campaign.id)
      c.receive_applications.should be_true
    end
  end

  describe "send email methods" do
    describe "send_deadline_update" do
      it "send campaign deadline update emails" do
          campaign = create(:campaign)
          Candidate.should_receive(:reopened_mails)
          campaign.send_deadline_update
      end

      it "send campaign closed calls deadline passed emails" do
          campaign = create(:campaign)
          Candidate.should_receive(:deadline_passed_mails)
          campaign.send_campaign_closed
      end
    end
  end

  describe "process_candidates" do
    it "correctly processes candidates with email addresses" do
      campaign = create(:campaign)
      list = "cand1, cand2"
      mailer = mock
      mailer.stub(:deliver)
      CandidateMailer.stub(:invitation).and_return(mailer)
      x, y = campaign.process_candidates(list)
      campaign.candidates.count.should == 2
      campaign.sent_invitations.should == 2
      x.should == 2
      y.should == 2
    end

    it "does not allow duplicate emails" do
      campaign = create(:campaign)
      campaign.recruiter.organization.account.update_attributes(included_candidates: 4)
      list = "string1, string2, string3, string3"
      mailer = mock
      mailer.stub(:deliver)
      CandidateMailer.stub(:invitation).and_return(mailer)
      x, y, z, n = campaign.process_candidates(list)
      campaign.candidates.count.should == 3
      campaign.sent_invitations.should == 3
      x.should == 4
      y.should == 3
      z.should == ["string3"]
      n.should be_nil
    end

    it "does not allow existing candidates" do
      campaign = create(:campaign)
      campaign.candidates.create(email: "cand1")
      list = "cand1"
      x, y = campaign.process_candidates(list)
      campaign.sent_invitations.should == 0
      x.should == 1
      y.should == 0
    end

    it "generates a welcome email when a candidate is added" do
      campaign = create(:campaign)
      list = "cand1"
      campaign.process_candidates(list)
      ActionMailer::Base.deliveries.last.to.should == ["cand1"]
      ActionMailer::Base.deliveries.last.subject.should == "Invitación para una entrevista virtual para el puesto de #{campaign.position_name} en #{campaign.recruiter.organization.name}."
    end

    it "breaks when max number of candidates has been exceeded and returns true as last parameter" do
      campaign = create(:campaign)
      list = "cand1, cand2, cand3, cand 4"
      x,y,z,n = campaign.process_candidates(list)
      x.should == 4
      y.should == 2
      z.should == []
      n.should be_true
    end
  end

end