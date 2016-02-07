#encoding: utf-8
require 'spec_helper'

describe CampaignQuestionsController do
  fixtures :questions

  before(:each) do
    @recruiter = create(:recruiter, new_user: false)
     sign_in @recruiter
  end

  describe "POST create_text_questions" do
    it "adds text questions to campaign" do
      campaign = create(:campaign)
      post :create_text_questions, campaign_id: campaign.id, Integer: {"0"=>"1", "1"=>"2", "2"=>""}
      campaign.questions.text.count.should == 2
    end

    it "skips to next step if recruiter does not wish to include text questions" do
      campaign = create(:campaign)
      post :create_text_questions, campaign_id: campaign.id, Integer: {"0"=>"1"}, commit: 'Omitir'
      response.should redirect_to(campaign_choose_verbal_questions_path(campaign))
      flash[:notice].should be_nil
    end
  end

  describe "POST create_verbal_questions" do
    it "does not check to ensure at least one question is being added" do
      campaign = create(:campaign)
      post :create_verbal_questions, campaign_id: campaign.id, Integer: {"0"=>"", "1"=>"", "2"=>""}
      response.should redirect_to(campaign_question_confirmation_path(campaign))
      flash[:notice].should == "Las preguntas de voz fueron agregadas exitosamente a tu entrevista."
    end

    it "adds verbal questions to campaign" do
      campaign = create(:campaign)
      post :create_verbal_questions, campaign_id: campaign.id, Integer: {"0"=>"1", "1"=>"3", "2"=>"4"}
      campaign.questions.verbal.count.should == 2
    end
  end

  describe "GET edit_text_questions" do
    it "displays all text questions linked to current campaign" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "text")
      q2 = create(:question, kind: "text")
      CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      CampaignQuestion.create(campaign_id: campaign.id, question_id: q2.id)
      get :edit_text_questions, campaign_id: campaign.id
      response.should render_template(:edit_questions)
      assigns(:questions).should == [q1,q2]
    end
  end

  describe "GET edit_verbal_questions" do
    it "displays all text questions linked to current campaign" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "verbal")
      q2 = create(:question, kind: "verbal")
      CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      CampaignQuestion.create(campaign_id: campaign.id, question_id: q2.id)
      get :edit_verbal_questions, campaign_id: campaign.id
      response.should render_template(:edit_questions)
      assigns(:questions).should == [q1,q2]
    end
  end

  describe "DELETE remove_question" do
    it "removes associated question from campaign" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "text")
      cq = CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      request.env["HTTP_REFERER"] = campaign_edit_text_questions_path(campaign)
      delete :remove_question, campaign_id: campaign.id, question_id: q1.id
      campaign.questions.text.count.should == 0
    end

    it "redirects back to edit text questions path" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "verbal")
      cq = CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      request.env["HTTP_REFERER"] = campaign_edit_text_questions_path(campaign)
      delete :remove_question, campaign_id: campaign.id, question_id: q1.id
      response.should redirect_to(campaign_edit_text_questions_path(campaign))
    end

    it "deletes question if kind is filter" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "filter")
      cq = CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      request.env["HTTP_REFERER"] = campaign_edit_text_questions_path(campaign)
      expect {delete :remove_question, campaign_id: campaign.id, question_id: q1.id}.to change(Question, :count).by(-1)
    end

    it "does not delete question if kind is other than filter" do
      campaign = create(:campaign)
      q1 = create(:question, kind: "verbal")
      cq = CampaignQuestion.create(campaign_id: campaign.id, question_id: q1.id)
      request.env["HTTP_REFERER"] = campaign_edit_text_questions_path(campaign)
      expect {delete :remove_question, campaign_id: campaign.id, question_id: q1.id}.to change(Question, :count).by(0)
    end
  end

  describe "POST add_question" do
    it "adds question to campaign" do
      campaign = create(:campaign)
      q = create(:question)
      post :add_question, campaign_id: campaign.id, question_id: q.id, format: "js"
      CampaignQuestion.where("campaign_id = ? AND question_id = ?",campaign.id, q.id).count.should_not == 0
    end

    it "responds with success if the question is added" do
      campaign = create(:campaign)
      q = create(:question)
      post :add_question, campaign_id: campaign.id, question_id: q.id, format: "json"
      response.should be_success
    end

    it "responds with failure if the question is not added" do
      campaign = create(:campaign)
      q = create(:question)
      CampaignQuestion.create(campaign_id: campaign.id, question_id: q.id)
      post :add_question, campaign_id: campaign.id, question_id: q.id, format: "json"
      response.should_not be_success
    end

    it "ensures maximum number of voice questions is not surpassed and returns relevant error message" do
      campaign = create(:campaign, recruiter: @recruiter)
      @recruiter.organization.account.update_attributes(voice_questions: 1)
      q1 = create(:question, kind: "verbal")
      CampaignQuestion.create!(campaign_id: campaign.id, question_id: q1.id)
      q2 = create(:question, kind: "verbal")
      post :add_question, campaign_id: campaign.id, recruiter_id: @recruiter.id, question_id: q2.id, format: "json"
      response.should_not be_success
      expected = {max_questions_error: "Ya has alcanzado el límite de preguntas de voz permitidas para tu cuenta."}.to_json
      response.body.should == expected
    end

    it "adds as many text questions as desired" do
      campaign = create(:campaign, recruiter: @recruiter)
      @recruiter.organization.account.update_attributes(voice_questions: 1)
      q1 = create(:question, kind: "verbal")
      CampaignQuestion.create!(campaign_id: campaign.id, question_id: q1.id)
      q2 = create(:question, kind: "text")
      post :add_question, campaign_id: campaign.id, recruiter_id: @recruiter.id, question_id: q2.id, format: "json"
      response.should be_success
    end
  end

  describe "GET question_confirmation" do

    it "renders question confirmatiokn template" do
      campaign = create(:campaign)
      get :question_confirmation, campaign_id: campaign.id
      response.should render_template('question_confirmation')
    end

    it "does not set created variable as true" do
      campaign = create(:campaign)
      get :question_confirmation, campaign_id: campaign.id
      assigns(:created).should_not be_true
    end

  end

  describe "GET show_questions" do

    it "renders question confirmation template" do
      campaign = create(:campaign)
      get :show_questions, campaign_id: campaign.id
      response.should render_template('question_confirmation')
    end

    it "sets created variable as true" do
      campaign = create(:campaign)
      get :show_questions, campaign_id: campaign.id
      assigns(:created).should be_true
    end
  end

  describe "GET choose_verbal_questions" do
    it "renders max_questions variable with max number of voice questions" do
      campaign = create(:campaign, recruiter: @recruiter)
      @recruiter.organization.account.update_attributes(voice_questions: 7)
      get :choose_verbal_questions, recruiter_id: @recruiter.id, campaign_id: campaign.id
      assigns(:max_questions).should == 7
    end
  end

end