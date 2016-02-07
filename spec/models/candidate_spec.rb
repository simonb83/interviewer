# encoding: utf-8
require 'spec_helper'

describe Candidate do

describe "validations" do
  it "validates uniqueness of email" do
    campaign = create(:campaign)
    create(:candidate, email: "string", campaign: campaign)
    build(:candidate, email: "string", campaign: campaign).should_not be_valid
  end
end

describe ".pending?" do
  it "marks candidates who are not rejected or accepted as pending" do
    candidate = create(:candidate)
    candidate.pending?.should be_true
  end
end

describe "create_uid" do
  it "generates interview id on create for new candidates" do
    candidate = create(:candidate)
    candidate.uid?.should be_true
  end

  it "is not changed on save for already created candidates" do
    candidate = create(:candidate)
    uid = candidate.uid
    candidate.update_attribute(:email, "string-new")
    candidate.uid.should == uid
  end
end

describe "save" do

  it "updates interview status when text and verbal and filter parts are completed" do
    candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
    candidate.completed_interview.should be_true
  end

  it "calls CandidateMailer when text and verbal parts are completed" do
    mailer = mock
    mailer.should_receive(:deliver)
    CandidateMailer.should_receive(:completed).and_return(mailer)
    candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
  end

  it "does not call CandidateMailer if interview status is already fully completed" do
    candidate2 = create(:candidate, completed_text_interview: true, completed_verbal_interview:true, completed_interview: true)
    CandidateMailer.should_not_receive(:completed)
    candidate2.update_attributes(accepted: true)
  end

  it "does not update interview status if text or verbal part is not completed" do
    candidate1 = create(:candidate, completed_text_interview: true)
    candidate2 = create(:candidate, completed_verbal_interview: true)
    candidate3 = create(:candidate, completed_text_interview: true, completed_verbal_interview: true)
    candidate1.completed_interview.should be_false
    candidate2.completed_interview.should be_false
    candidate3.completed_interview.should be_false
  end
end

describe "recommended_friends?" do
  it "correctly identifies if candidate has recommended friends for campaign" do
    candidate1 = create(:candidate)
    candidate2 = create(:candidate, recommended_friends: "string")
    candidate1.recommended_friends?.should be_false
    candidate2.recommended_friends?.should be_true
  end

  it "must identify all candidates as having recommended friends for campaign where it is not allowed" do
    campaign = create(:campaign, recommend_friends: false)
    campaign.candidates.create(email: "string").recommended_friends?.should be_true
  end
end

describe "provided_references?" do
  it "is true if providing references is not allowed" do
    campaign = create(:campaign, candidate_references: false)
    campaign.candidates.create(email: "string").provided_references?.should be_true
  end

  it "is true if providing references is allowed and candidate has provided references" do
    campaign = create(:campaign, candidate_references: true)
    candidate = campaign.candidates.create(email: "string")
    candidate.references.create(name: "ref 1", email: "ref_1", relationship: "uncle")
    candidate.references.create(name: "ref 2", email: "ref_2", relationship: "aunt")
    candidate.provided_references?.should be_true
  end

  it "is false if providing references is allowed and candidate has not provided references" do
    campaign = create(:campaign, candidate_references: true)
    candidate = campaign.candidates.create(email: "string")
    candidate.provided_references?.should_not be_true
  end
end

describe "interview stage" do
  it "is 6 if candidate has completed interview and provided references and recommended friends" do
    candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true, recommended_friends: "string")
    candidate.references.create(name: "ref 1", email: "ref_1", relationship: "uncle")
    candidate.interview_stage.should == 6
  end

  it "is 5 if has completed interview and provided references" do
    candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
    candidate.references.create(name: "ref 1", email: "ref_1", relationship: "uncle")
    candidate.interview_stage.should == 5
  end

  it "is 4 if has completed all partes of interview" do
    candidate = create(:candidate, completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
    candidate.interview_stage.should == 4
  end

  it "is 3 if has completed text interview & filter interview" do
    candidate = create(:candidate, completed_text_interview: true, completed_filter_interview: true)
    candidate.interview_stage.should == 3
  end

  it "is 2 if has completed only filter interview" do
    candidate = create(:candidate, completed_filter_interview: true)
    candidate.interview_stage.should == 2
  end

  it "is 1 if has not completed anything" do
    candidate = create(:candidate)
    candidate.interview_stage.should == 1
  end
end

describe "self.deadline_passed_mails" do
  it "invoques CandidateMailer.deadline_passed" do
    campaign = create(:campaign)
    campaign.candidates.create(email: "string@factory.com")
    mailer = mock
    mailer.should_receive(:deliver)
    CandidateMailer.should_receive(:deadline_passed).and_return(mailer)
    Candidate.deadline_passed_mails(campaign)
  end
end

describe "self.reopened_mails" do
  it "invoques CandidateMailer.reopened" do
    campaign = create(:campaign)
    campaign.candidates.create(email: "string@factory.com")
    mailer = mock
    mailer.should_receive(:deliver)
    CandidateMailer.should_receive(:reopened).and_return(mailer)
    Candidate.reopened_mails(campaign)
  end
end

describe "self.pending_mails" do
  it "invoques CandidateMailer.reminder" do
    campaign = create(:campaign)
    campaign.candidates.create(email: "string@factory.com")
    mailer = mock
    mailer.should_receive(:deliver)
    CandidateMailer.should_receive(:reminder).and_return(mailer)
    Candidate.send_pending_emails(campaign)
  end
end

describe "completing interview" do
  it "generates completed email" do
    candidate = create(:candidate)
    candidate.update_attributes(completed_text_interview: true, completed_verbal_interview:true, completed_filter_interview: true)
    ActionMailer::Base.deliveries.last.to.should == [candidate.email]
    ActionMailer::Base.deliveries.last.subject.should == "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}."
  end
end

describe "displaying name correctly" do
  it "correctly joins candidate first name and surname" do
    candidate = create(:candidate, name: "first", surname: "last")
    candidate.to_s.should == "first last"
  end
end

describe "callbacks" do
  it "increases number of candidates for account when candidate is added" do
    recruiter = create(:recruiter)
    campaign = create(:campaign, recruiter: recruiter)
    expect{create(:candidate, campaign: campaign)}.to change{recruiter.organization.organization_account.current_candidates}.by(1)
  end

  it "does not decrease the number of candidates for account when candidate is destroyed and has commenced the interview" do
    recruiter = create(:recruiter)
    campaign = create(:campaign, recruiter: recruiter)
    candidate = create(:candidate, campaign: campaign, privacy_consent: true)
    expect{candidate.destroy}.to change{recruiter.organization.organization_account.current_candidates}.by(0)
  end

  it "decreases the number of candidates for account when candidate is destroyed and has not commenced the interview" do
    recruiter = create(:recruiter)
    campaign = create(:campaign, recruiter: recruiter)
    candidate = create(:candidate, campaign: campaign)
    candidate.privacy_consent.should be_nil
    expect{candidate.destroy}.to change{recruiter.organization.organization_account.current_candidates}.by(-1)
  end
end

describe "validations" do
  it "validates max number of candidates for an account which has no additional candidates" do
    account = create(:account, included_candidates: 2)
    organization = create(:organization, account_id: account.id)
    recruiter = create(:recruiter, organization: organization)
    campaign = create(:campaign, recruiter: recruiter)
    2.times{create(:candidate, campaign: campaign)}
    candidate = build(:candidate, campaign: campaign)
    candidate.should_not be_valid
    candidate.errors[:base].should include("Se ha pasado el número máximo de Candidatos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.")
  end

  it "validates max number of candidates for an account which has additional candidates" do
    account = create(:account, included_candidates: 2)
    organization = create(:organization, account_id: account.id)
    organization.organization_account.update_attributes(additional_candidates: 1)
    recruiter = create(:recruiter, organization: organization)
    campaign = create(:campaign, recruiter: recruiter)
    2.times{create(:candidate, campaign: campaign)}
    candidate = build(:candidate, campaign: campaign)
    candidate.should be_valid
  end

  it "validates max number of candidates for an account which has additional candidates II" do
    account = create(:account, included_candidates: 2)
    organization = create(:organization, account_id: account.id)
    organization.organization_account.update_attributes(additional_candidates: 1)
    recruiter = create(:recruiter, organization: organization)
    campaign = create(:campaign, recruiter: recruiter)
    3.times{create(:candidate, campaign: campaign)}
    candidate = build(:candidate, campaign: campaign)
    candidate.should_not be_valid
  end
end

describe "history" do
  it "finds candidate history with a given organization" do
    account = create(:account, included_candidates: 2)
    organization = create(:organization, account_id: account.id)
    recruiter = create(:recruiter, organization: organization)
    campaign1 = create(:campaign, recruiter: recruiter)
    campaign2 = create(:campaign, recruiter: recruiter)
    cand1 = create(:candidate, campaign: campaign1)
    cand2 = create(:candidate, campaign: campaign2, email: cand1.email)
    cand2.history.class.should == Array
    cand2.history.should == [cand1]
  end

  it "does not include candidates from other organizations" do
    cand1 = create(:candidate, email: "myemail")
    cand2 = create(:candidate, email: "myemail")
    cand1.history.size.should == 0
  end
end

describe "before create" do
  it "sets organization id for candidate" do
    candidate = create(:candidate)
    candidate.organization_id.should == candidate.campaign.recruiter.organization.id
  end
end

describe "interview_history_detail" do
  it "displays prior position name" do
    campaign = create(:campaign, position_name: "Special Name", company_name: "Another Company")
    cand = create(:candidate, campaign: campaign)
    cand.interview_completed_at = Date.new(2013,5,10)
    cand.rejected = true
    cand.interview_history_detail.should match(/Another Company/)
    cand.interview_history_detail.should match(/Special Name/)
    cand.interview_history_detail.should match(/10-5-2013/)
    cand.interview_history_detail.should match(/Rechazado/)
  end
end

describe "valid_cel?" do
  it "returns true if cel exists and is 10 digits long" do
    candidate = create(:candidate, cel: "1111111111")
    candidate.valid_cel?.should be_true
  end

  it "returns false if cel does not exist" do
    candidate = create(:candidate)
    candidate.valid_cel?.should_not be_true
  end

  it "returns false if cel is not of right length" do
    candidate = create(:candidate, cel: "11111111")
    candidate.valid_cel?.should_not be_true
  end
end

describe "started?" do
  it "is true when candidate has checked & saved privacy consent" do
    candidate = create(:candidate, privacy_consent: true)
    candidate.started?.should be_true
  end

  it "is false if privacy consent is nil or false" do
    candidate = create(:candidate)
    candidate.started?.should_not be_true
  end
end

describe "candidate_name" do
  it "uses profile details when available" do
    candidate = create(:candidate)
    candidate.create_profile(name: "Steven", surname_paternal: "Jobs", surname_maternal: "X", gender: "M", estado_civil: "X", dob: Date.today, desired_salary: "5,000")
    candidate.candidate_name.should == "Steven Jobs X"
  end

  it "uses candidate name otherwise" do
    candidate = create(:candidate, name: "Steven", surname: "Jobs")
    candidate.candidate_name.should == "Steven Jobs"
  end

  it "displays nothing if name and profile do not exist" do
    candidate = create(:candidate, name: nil, surname: nil)
    candidate.candidate_name.should == ""
  end
end

end