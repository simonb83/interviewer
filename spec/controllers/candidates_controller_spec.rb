# encoding: utf-8
require 'spec_helper'

describe CandidatesController do

  before(:each) do
    @recruiter = create(:recruiter, new_user: false)
     sign_in @recruiter
  end

  describe "POST add_more_candidates" do
    it "redirects back to campaign page" do
      campaign = create(:campaign)
      post :add_more_candidates, campaign_id: campaign.id, :Campaign => {"candidate_list"=>"string1, string2"}
      response.should redirect_to(recruiter_campaign_path(campaign.recruiter, campaign))
    end

    it "displays correct message when emails are not unique but max candidates has not been exceeded" do
      @recruiter.organization.account.update_attributes(included_candidates: 4)
      campaign = create(:campaign, recruiter: @recruiter)
      post :add_more_candidates, campaign_id: campaign.id, :Campaign => {"candidate_list"=>"string1, string2, string3, string3"}
      flash[:notice].should ==  "3 de 4 candidatos fueron invitados a participar en esta entrevista. Los siguientes candidatos no son únicos: [string3]"
    end

    it "displays the correct message when emails are unique but max candidates has been exceeded" do
      campaign = create(:campaign)
      post :add_more_candidates, campaign_id: campaign.id, :Campaign => {"candidate_list"=>"string1, string2, string3"}
      flash[:notice].should include("Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.")
    end

    it "displays the correct message when emails are not unique and max candidates has been exceeded" do
      @recruiter.organization.account.update_attributes(included_candidates: 3)
      campaign = create(:campaign, recruiter: @recruiter)
      post :add_more_candidates, campaign_id: campaign.id, :Campaign => {"candidate_list"=>"string1, string1, string2, string3, string4"}
      flash[:notice].should include("3 de 5 candidatos fueron invitados a participar en esta entrevista. Los siguientes candidatos no son únicos: [string1]")
      flash[:notice].should include("Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.")
    end

  end

  describe "GET start_text_interview" do
    it "denies access if candidate has not started interview" do
      candidate = create(:candidate)
      get :start_text_interview, candidate_id: candidate.id
      response.should redirect_to("/403")
    end

    it "renders start_text_interview template if candidate has started interview" do
      candidate = create(:candidate, privacy_consent: true)
      get :start_text_interview, candidate_id: candidate.id
      response.code.should == "200"
      response.should render_template('start_text_interview')
    end

    it "gets next interview stage if has already completed text interview" do
      candidate = create(:candidate, privacy_consent: true, completed_text_interview: true)
      get :start_text_interview, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end
  end

  describe "GET start_voice_interview" do
    it "denies access if candidate has not started interview" do
      candidate = create(:candidate)
      get :start_voice_interview, candidate_id: candidate.id
      response.should redirect_to("/403")
    end

    it "gets interview next stage if candidate has not completed text interview" do
      candidate = create(:candidate, privacy_consent: true)
      get :start_voice_interview, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end

    it "renders start_voice_interview template if candidate has started interview and has completed text interview" do
      candidate = create(:candidate, privacy_consent: true, completed_text_interview: true)
      get :start_voice_interview, candidate_id: candidate.id
      response.code.should == "200"
      response.should render_template('start_voice_interview')
    end

    it "gets next interview stage if has already completed voice interview" do
      candidate = create(:candidate, privacy_consent: true, completed_verbal_interview: true)
      get :start_voice_interview, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end
  end

  describe "GET provide_references" do
    it "denies access if candidate has not started interview" do
      candidate = create(:candidate)
      get :provide_references, candidate_id: candidate.id
      response.should redirect_to("/403")
    end

    it "gets next interview stage if candidate has not completed interview" do
      candidate = create(:candidate, privacy_consent: true)
      get :provide_references, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end

    it "renders start_text_interview template if candidate has started & completed interview" do
      candidate = create(:candidate, privacy_consent: true)
      candidate.update_attributes(completed_text_interview: true, completed_verbal_interview: true, completed_filter_interview: true)
      get :provide_references, candidate_id: candidate.id
      response.code.should == "200"
      response.should render_template('provide_references')
    end

    it "gets next interview stage if has already provided references" do
      candidate = create(:candidate, privacy_consent: true)
      2.times {create(:reference, candidate_id: candidate.id, relationship: "string")}
      get :provide_references, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end
  end

  describe "POST add_phone" do
    it "redirects to set up path with permitted celphone if exists and phone number is not provided" do
      candidate = create(:candidate, cel: "5554543232")
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>""}
      response.should redirect_to(candidate_set_up_path(candidate, number: "+5215554543232"))
    end
    it "redirects to set up path with provided landline if celphone exists but other number is provided and is valid" do
      candidate = create(:candidate, cel: "5554543232")
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>"5523456789"}
      response.should redirect_to(candidate_set_up_path(candidate, number: "+525523456789"))
    end
    it "rejects phone numbers less than 10 digits" do
      candidate = create(:candidate)
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>"11111111"}
      flash[:alert].should == "El número telefónico debe ser de 10 dígitos, incluyendo la LADA."
      response.should render_template(:start_voice_interview)
    end
    it "rejects numbers which start with 1" do
      candidate = create(:candidate)
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>"1222222222"}
      flash[:alert].should == "El número telefónico no puede comenzar con '1'."
      response.should render_template(:start_voice_interview)
    end
    it "rejects non-numeric characters" do
      candidate = create(:candidate)
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>"222.222222"}
      flash[:alert].should == "El número telefónico no puede contener caracteres no numéricos."
      response.should render_template(:start_voice_interview)
    end
    it "redirects to set up path if valid" do
      candidate = create(:candidate)
      post :add_phone, candidate_id: candidate.id, :candidate => {"phone_number"=>"5523456789"}
      response.should redirect_to(candidate_set_up_path(candidate, number: "+525523456789"))
    end
  end

  describe "GET complete_voice_interview" do
    it "stops candidate moving on if has not completed verbal interview" do
      candidate = create(:candidate)
      get :complete_voice_interview, candidate_id: candidate.id
      flash[:alert].should == "Por favor asegurarte de terminar la parte verbal de tu entrevista y colgar el teléfono antes de dar clic en ‘Próximo’."
      response.should render_template(:interview_in_progress)
    end
    it "lets candidate move on if has completed verbal interview" do
      candidate = create(:candidate, completed_verbal_interview: true)
      get :complete_voice_interview, candidate_id: candidate.id
      response.should redirect_to(candidate_next_stage_path(candidate))
    end
  end

  describe "PUT accept" do
    it "generates accepted mail" do
      candidate = create(:candidate, completed_verbal_interview: true, completed_text_interview: true)
      put :accept, campaign_id: candidate.campaign.id, candidate_id: candidate.id
      ActionMailer::Base.deliveries.last.to.should == [candidate.email]
      ActionMailer::Base.deliveries.last.subject.should == "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}."
    end

    it "allows you to accept even when has not completed interview" do
      candidate = create(:candidate)
      put :accept, campaign_id: candidate.campaign.id, candidate_id: candidate.id
      Candidate.find(candidate.id).accepted.should be_true
    end
  end

  describe "PUT reject" do
    it "generates rejected email" do
      candidate = create(:candidate, completed_verbal_interview: true, completed_text_interview: true)
      put :reject, campaign_id: candidate.campaign.id, candidate_id: candidate.id
      ActionMailer::Base.deliveries.last.to.should == [candidate.email]
      ActionMailer::Base.deliveries.last.subject.should == "Tu entrevista virtual para el puesto de #{candidate.position_name} en #{candidate.company_name}."
    end

    it "allows you to accept even when has not completed interview" do
      candidate = create(:candidate)
      put :reject, campaign_id: candidate.campaign.id, candidate_id: candidate.id
      Candidate.find(candidate.id).rejected.should be_true
    end
  end

   describe "GET share" do
    it "prevents sharing when interview is not completed" do
      candidate = create(:candidate)
      get :share, recruiter_id: 1, candidate_id: candidate.id
      response.should redirect_to(campaign_candidate_path(candidate.campaign, candidate))
      flash[:notice].should == "No puedes compartir el candidato porque todavía no ha terminado su entrevista."
    end
  end

  describe "PUT interview_step_2" do
    it "updates candidate status if there are no text questions" do
      campaign = create(:campaign)
      candidate = create(:candidate, campaign: campaign)
      put :interview_step_2, candidate_id: candidate.id, "candidate"=>{"name"=>"Simon", "surname"=>"Bedford", "privacy_consent"=>"1", "profile_attributes"=>{desired_salary: "x", dob: Date.new, estado_civil: "x", gender: "x", name: "x", surname_paternal: "x"}}
      candidate = Candidate.last
      candidate.completed_text_interview.should be_true
    end

    it "creates candidate profile" do
      campaign = create(:campaign)
      candidate = create(:candidate, campaign: campaign)
      expect {put :interview_step_2, candidate_id: candidate.id, "candidate"=>{"name"=>nil, "surname"=>"Bedford", "privacy_consent"=>"1", "profile_attributes"=>{desired_salary: "x", dob: Date.new, estado_civil: "x", gender: "Masculino", name: "x", surname_paternal: "x"}}}.to change(Profile, :count).by(1)
      @candidate = Candidate.find(candidate.id)
      @candidate.profile.gender.should == "Masculino"
    end
  end

  describe "GET next_stage" do
    it "routes to confirmation path when 6" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(6)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_interview_confirmation_path(candidate))
    end

    it "routes to recommend friends when 5" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(5)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_recommend_friends_path(candidate))
    end

    it "routes to provide references when 4" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(4)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_provide_references_path(candidate))
    end

    it "routes to verbal interview when 3" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(3)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_start_voice_interview_path(candidate))
    end

    it "routes to text interview when 2" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(2)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_start_text_interview_path(candidate))
    end

    it "routes to filter interview when 1" do
      candidate = create(:candidate)
      Candidate.any_instance.stub(:interview_stage).and_return(1)
      get :next_stage, candidate_id: candidate.id
      response.should redirect_to(candidate_filter_questions_path(candidate))
    end
  end

end