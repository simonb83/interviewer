require 'spec_helper'

describe Recruiter do

  describe "candidates" do

    it "returns an array" do
      recruiter = create(:recruiter)
      recruiter.candidates.class.should == Array.new.class
    end

    it "returns an empty array if recruiter has not added any campaigns" do
      recruiter = create(:recruiter)
      recruiter.candidates.size.should == 0
    end

    it "returns an array of all candidates created by the recruiter" do
      account = create(:account, included_candidates: 5)
      organization = create(:organization, account_id: account.id)
      recruiter = create(:recruiter, organization: organization)
      campaign1 = create(:campaign, recruiter_id: recruiter.id)
      c1 = create(:candidate, campaign_id: campaign1.id)
      c2 = create(:candidate, campaign_id: campaign1.id)
      campaign2 = create(:campaign, recruiter_id: recruiter.id)
      c3 = create(:candidate, campaign_id: campaign2.id)
      c4 = create(:candidate, campaign_id: campaign2.id)
      recruiter.candidates.should == [c1,c2,c3,c4]
    end

  end

  describe "active?" do

    it "returns true if organization is active" do
      organization = create(:organization)
      recruiter = create(:recruiter, organization: organization)
      recruiter.active?.should be_true
    end

    it "returns false if organization is not active" do
      organization = create(:organization, active: false)
      recruiter = create(:recruiter, organization: organization)
      recruiter.active?.should == false
    end

  end

  describe "callbacks" do

    it "increments number of users for recruiter organization after creating a recruiter" do
      organization = create(:organization)
      expect{create(:recruiter, organization: organization)}.to change{organization.organization_account.current_users}.by(1)
    end

    it "decreases number of users for recruiter organization after destroying a recruiter" do
      organization = create(:organization)
      recruiter = create(:recruiter, organization: organization)
      expect{recruiter.destroy}.to change{organization.organization_account.current_users}.by(-1)
    end

  end

  describe "validations" do
    it "does not permit more than max number of users for a given account" do
      account = create(:account, max_users: 2)
      organization = create(:organization, account_id: account.id)
      2.times{create(:recruiter, organization: organization)}
      recruiter = build(:recruiter, organization: organization)
      recruiter.should_not be_valid
      recruiter.errors[:base].should include('max users already taken (2)')
    end
  end

  describe "used_candidates" do
    it "returns number of candidates currently used by organization" do
      organization = create(:organization)
      organization.organization_account.update_attributes(current_candidates: 4)
      recruiter = create(:recruiter, organization: organization)
      recruiter.used_candidates.should == 4
    end
  end

  describe "remaining_candidates" do
    it "returns number of remaining candidates for organization" do
      account = create(:account, included_candidates: 10)
      organization = create(:organization, account_id: account.id)
      organization.organization_account.update_attributes(current_candidates: 4, additional_candidates: 5)
      recruiter = create(:recruiter, organization: organization)
      recruiter.remaining_candidates.should == 11
    end
  end

  describe "max_voice_questions" do
    it "returns max voice questions for organization account" do
      account = create(:account, voice_questions: 4)
      organization = create(:organization, account_id: account.id)
      recruiter = create(:recruiter, organization: organization)
      recruiter.max_voice_questions.should == 4
    end
  end

end
