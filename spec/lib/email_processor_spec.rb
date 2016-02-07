# coding: utf-8

require 'spec_helper'

describe EmailProcessor do
  # include 'email_processor.rb'

  it "saves a copy of all candidate applications" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, :with_attachment, subject: "string ##{uid} string", from: "john@example.com", body: "some body")
    mail = double("email")
    AdminMailer.stub(:save_candidates).and_return(mail)
    mail.should_receive(:deliver).once
    EmailProcessor.process(email)
  end

  it "does not create a candidate if receiving apps option is not enabled" do
    campaign = create(:campaign, receive_applications: false)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string")
    Campaign.any_instance.stub(:candidates).and_return(Candidate)
    Candidate.should_not_receive(:create)
    EmailProcessor.process(email)
  end

  it "creates candidate with for relevant campaign" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string")
    EmailProcessor.process(email)
    Candidate.last.campaign.should == campaign
  end

  it "can handle a blank email" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", text: "")
    EmailProcessor.process(email)
    Candidate.last.campaign.should == campaign
  end

  it "creates candidate with email in from" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", from: "john@example.com")
    EmailProcessor.process(email)
    Candidate.last.email.should == "john@example.com"
    ActionMailer::Base.deliveries[-1].to.should == ["john@example.com"]
  end

  it "sends en email to the recruiter with the candidate details" do
    campaign = create(:campaign, receive_applications: true, forward_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", from: "john@example.com", body: "some body")
    EmailProcessor.process(email)
    ActionMailer::Base.deliveries.last.to.should == [campaign.recruiter.email]
    ActionMailer::Base.deliveries.last.from.should == ["john@example.com"]
    ActionMailer::Base.deliveries.last.subject.should match(/string ##{uid} string/)
    ActionMailer::Base.deliveries.last.body.should match(/some body/)
  end

  it "sends and email to the recruiter with the attachments" do
    campaign = create(:campaign, receive_applications: true, forward_applications: true)
    uid = campaign.uid
    email = build(:email, :with_attachment, subject: "string ##{uid} string", from: "john@example.com", body: "some body")
    EmailProcessor.process(email)
    mail = ActionMailer::Base.deliveries.last
    mail.attachments.should have(1).attachment
    attachment = mail.attachments[0]
    attachment.filename.should == 'test.pdf'
    attachment.content_type.should match(/application\/pdf/)
  end

  it "sends an informative email to the candidate if receiving apps is not permitted" do
    campaign = create(:campaign, receive_applications: false)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", from: "steve@example.com")
    EmailProcessor.process(email)
    mail = ActionMailer::Base.deliveries.last
    mail.to.should == ["steve@example.com"]
    mail.subject.should == "RE: string ##{uid} string"
    mail.body.should match(/Lo sentimos pero por el momento/)
  end

  it "sends and informative email to the candidate if they are already a candidate" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", from: "john@bigs.com")
    email2 = build(:email, subject: "string ##{uid} string", from: "john@bigs.com")
    EmailProcessor.process(email)
    EmailProcessor.process(email2)
    campaign.candidates.count.should == 1
    mail = ActionMailer::Base.deliveries.last
    mail.to.should == ["john@bigs.com"]
    mail.subject.should == "RE: string ##{uid} string"
    mail.body.should match(/Parece que ya has aplicado para esta vacante/)
  end

  it "does not send an email to the recruiter if forward application option is false" do
    campaign = create(:campaign, receive_applications: true)
    uid = campaign.uid
    email = build(:email, subject: "string ##{uid} string", from: "john@example.com", body: "some body")
    AdminMailer.should_not_receive(:new_candidate)
    EmailProcessor.process(email)
  end

  it "creates issue if no ID found in subject" do
    campaign = create(:campaign)
    email = build(:email, subject: "string", from: "john@example.com")
    EmailProcessor.process(email)
    Issue.last.category.should == "system"
    Issue.last.content.should include('john@example.com')
  end

  it "creates an issue if the campaign is not found from the ID" do
    campaign = create(:campaign)
    email = build(:email, subject: "string #12334", from: "john@example.com")
    EmailProcessor.process(email)
    Issue.last.category.should == "system"
    Issue.last.content.should include("john@example.com")
    Issue.last.content.should include("string #12334")
  end

end