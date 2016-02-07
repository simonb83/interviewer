# encoding: utf-8
require 'spec_helper'

describe CampaignsController do

  before(:each) do
     sign_in create(:recruiter, new_user: false)
  end

  describe "GET new" do
    it "defaults company name to recruiter's organization name" do
      get :new
      assigns(:campaign).company_name.should == "company"
    end
  end

  describe "POST create" do
    it "redirects to choose text questions if no gateway questions" do
      post :create, "campaign" => {"deadline" => Date.today(), "position_name" => "some name"}
      @campaign = assigns(:campaign)
      response.should redirect_to(campaign_choose_text_questions_path(@campaign))
    end

    it "redirects to choose gateway questions if gateway questions" do
      post :create, "campaign" => {"deadline" => Date.today(), "position_name" => "some name", "gateway" => true}
      @campaign = assigns(:campaign)
      response.should redirect_to(campaign_choose_filter_options_path(@campaign))
    end
  end

  describe "PUT add_filter_options" do
    it "adds filters when they are selected, but not when they are blank" do
      campaign = create(:campaign)
      put :add_filter_options, campaign_id: campaign.id, "campaign"=>{"min_age"=>"20", "max_age"=>"32", "gender"=>"Masculino", "max_salary"=>"", "civil_status"=>""}
      @campaign = Campaign.find(campaign.id)
      @campaign.min_age.should == "20"
      @campaign.max_age.should == "32"
      @campaign.gender.should == "Masculino"
      @campaign.max_salary.should be_nil
      @campaign.civil_status.should be_nil
    end

    it "creates filter questions and campaign_questions with content and required option for freeform questions" do
      create(:category, name: "Gateway")
      campaign = create(:campaign)
      put :add_filter_options, campaign_id: campaign.id, "campaign"=>{"min_age"=>"", "max_age"=>"", "gender"=>"", "max_salary"=>"", "civil_status"=>""}, "questions"=>{"q_1"=>{"content"=>"Something", "req"=>"true"}, "q_2"=>{"content"=>"Something Else", "req"=>"false"}}
      @campaign = Campaign.find(campaign.id)
      @campaign.questions.filter.count.should == 2
      @campaign.questions.filter.first.content.should == "Something"
      @campaign.questions.filter.last.content.should == "Something Else"
      @campaign.questions.filter.first.required_option(@campaign).should be_true
      @campaign.questions.filter.last.required_option(@campaign).should be_false
    end

    it "redirects to add text questions path" do
      campaign = create(:campaign)
      put :add_filter_options, campaign_id: campaign.id
      response.should redirect_to(campaign_choose_text_questions_path(campaign))
    end

  end

  describe "PUT update_filter_options" do
    it "updates filters" do
      campaign = create(:campaign, min_age: "20", gender: "Masculino")
      put :update_filter_options, campaign_id: campaign.id, "campaign"=>{"min_age"=>"18", "max_age"=>"", "gender"=>"Femenino", "max_salary"=>"", "civil_status"=>""}, origin: root_path
      @campaign = Campaign.find(campaign.id)
      @campaign.min_age.should == "18"
      @campaign.gender.should == "Femenino"
    end

    it "updates existing filter options" do
      category = create(:category, name: "Gateway")
      campaign = create(:campaign)
      question = create(:question, kind: "filter", content: "Some Content", category_id: category.id)
      CampaignQuestion.create(question_id: question.id, campaign_id: campaign.id, option: true)
      put :update_filter_options, "existing"=>{"#{question.id}"=>{"content"=>"Some Other Content", "req"=>"false"}}, campaign_id: campaign.id, origin: root_path
      @campaign = Campaign.find(campaign.id)
      @campaign.questions.filter.first.content.should == "Some Other Content"
      @campaign.questions.filter.first.required_option(@campaign).should be_false
    end

    it "creates filter questions and campaign_questions with content and required option for freeform questions" do
      create(:category, name: "Gateway")
      campaign = create(:campaign)
      put :update_filter_options, campaign_id: campaign.id, "campaign"=>{"min_age"=>"", "max_age"=>"", "gender"=>"", "max_salary"=>"", "civil_status"=>""}, "questions"=>{"q_1"=>{"content"=>"Something", "req"=>"true"}, "q_2"=>{"content"=>"Something Else", "req"=>"false"}}, origin: root_path
      @campaign = Campaign.find(campaign.id)
      @campaign.questions.filter.count.should == 2
      @campaign.questions.filter.first.content.should == "Something"
      @campaign.questions.filter.last.content.should == "Something Else"
      @campaign.questions.filter.first.required_option(@campaign).should be_true
      @campaign.questions.filter.last.required_option(@campaign).should be_false
    end

    it "redirects to question confirmation path" do
      campaign = create(:campaign)
      put :update_filter_options, campaign_id: campaign.id, origin: campaign_question_confirmation_path(campaign)
      response.should redirect_to(campaign_question_confirmation_path(campaign))
    end
  end

  describe "PUT update_deadline" do
    it "changes status of closed campaigns" do
      campaign = create(:campaign, active: false)
      put :update_deadline, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id, :campaign => {"deadline(3i)"=>"30", "deadline(2i)"=>"12", "deadline(1i)"=>"2013"}
      @campaign = Campaign.find(campaign.id)
      @campaign.active.should be_true
    end

    it "generates email to pending candidates" do
      campaign = create(:campaign)
      candidate = campaign.candidates.create(email: "string_1@factory.com")
      put :update_deadline, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id, :campaign => {"deadline(3i)"=>"30", "deadline(2i)"=>"12", "deadline(1i)"=>"2013"}
      ActionMailer::Base.deliveries.last.to.should == [candidate.email]
      ActionMailer::Base.deliveries.last.subject.should == "Tu entrevista virtual está abierta de nuevo, o la fecha límite se ha modificado."
    end
  end

  describe "PUT update recommend friends" do
    it "changes from true to false if currently true" do
      campaign = create(:campaign)
      put :update_recommend_friends, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      @campaign = Campaign.find(campaign.id)
      @campaign.recommend_friends.should_not be_true
    end

    it "changes from false to true if currently false" do
      campaign = create(:campaign, recommend_friends: false)
      put :update_recommend_friends, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      @campaign = Campaign.find(campaign.id)
      @campaign.recommend_friends.should be_true
    end

    it "redirects back to campaign page" do
      campaign = create(:campaign)
      put :update_recommend_friends, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      response.should redirect_to(recruiter_campaign_path(campaign.recruiter, campaign))
    end

  end

  describe "PUT update candidate references" do

    it "changes from true to false if currently true" do
      campaign = create(:campaign)
      put :update_candidate_references, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      @campaign = Campaign.find(campaign.id)
      @campaign.candidate_references.should_not be_true
    end

    it "changes from false to true if currently false" do
      campaign = create(:campaign, candidate_references: false)
      put :update_candidate_references, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      @campaign = Campaign.find(campaign.id)
      @campaign.candidate_references.should be_true
    end

    it "redirects back to campaign page" do
      campaign = create(:campaign)
      put :update_candidate_references, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      response.should redirect_to(recruiter_campaign_path(campaign.recruiter, campaign))
    end

  end

  describe "PUT update receive applications" do

    it "calls switch_receive_apps method" do
      campaign = create(:campaign)
      Campaign.any_instance.should_receive(:switch_receive_apps)
      put :update_receive_applications, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
    end

    it "redirects back to campaign page" do
      campaign = create(:campaign)
      put :update_receive_applications, recruiter_id: campaign.recruiter.id, campaign_id: campaign.id
      response.should redirect_to(recruiter_campaign_path(campaign.recruiter, campaign))
    end

  end
end