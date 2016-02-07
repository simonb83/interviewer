class CampaignsController < ApplicationController

  load_and_authorize_resource

  #Get the current recruiter before dealing with campaigns
  before_filter :get_recruiter

  def get_recruiter
    if params[:recruiter_id]
      @recruiter = Recruiter.find(params[:recruiter_id])
    else
      @recruiter = current_recruiter
    end
  end

  def new
    @campaign = @recruiter.campaigns.new(deadline: Date.today()+5.days, recommend_friends: false, candidate_references: false, company_name: @recruiter.organization.name, gateway: false)
  end

  def show
    @campaign = @recruiter.campaigns.find(params[:id])
  end

  def create
    @campaign = @recruiter.campaigns.new(params[:campaign])

    respond_to do |format|
     if @campaign.save
      format.html {
        if @campaign.gateway
          redirect_to campaign_choose_filter_options_path(@campaign), notice: t(:campaign_created)
        else
          redirect_to campaign_choose_text_questions_path(@campaign), notice: t(:campaign_created)
        end
      }
      format.json {}
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
     end
    end
  end

  def choose_filter_options
    @campaign = Campaign.find(params[:campaign_id])
  end

  def add_filter_options
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.update_attributes(params[:campaign])
    freeform = params[:questions]
    if freeform
      @category = Category.find_by_name("Gateway")
      freeform.each do |ques|
        @q = Question.create(kind: "filter", category_id: @category.id, content: ques[1][:content])
        if ques[1][:req] == 'true'
          option = true
        else
          option = false
        end
        CampaignQuestion.create(question_id: @q.id, campaign_id: @campaign.id, option: option)
      end
    end
    redirect_to campaign_choose_text_questions_path(@campaign), notice: "Las preguntas de filtro fueron agregadas exitosamente a tu entrevista."
  end

  def edit_filter_options
    session[:return_to_principal] = params[:request_path]
    @campaign = Campaign.find(params[:campaign_id])
    @questions = @campaign.questions.filter
  end

  def update_filter_options
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.update_attributes(params[:campaign])
    existing = params[:existing]
    freeform = params[:questions]
    if existing
      existing.each do |q|
        @question = Question.find(q[0])
        @question.update_attributes(content: q[1][:content])
        if q[1][:req] == 'true'
          option = true
        else
          option = false
        end
        CampaignQuestion.where("campaign_id = ? AND question_id = ?", @campaign.id, @question.id).first.update_attributes(option: option)
      end
    end
    if freeform
      @category = Category.find_by_name("Gateway")
      freeform.each do |ques|
        @q = Question.create(kind: "filter", category_id: @category.id, content: ques[1][:content])
        if ques[1][:req] == 'true'
          option = true
        else
          option = false
        end
        CampaignQuestion.create(question_id: @q.id, campaign_id: @campaign.id, option: option)
      end
    end
    redirect_to params[:origin]
  end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    redirect_to @recruiter, notice: t(:campaign_removed)
  end

  def confirmation
    @campaign = @recruiter.campaigns.find(params[:campaign_id])
  end

  def choose_deadline
    @campaign = Campaign.find(params[:campaign_id])
  end

  def update_deadline
    @campaign = Campaign.find(params[:campaign_id])
    if params[:commit] == "Cancelar"
      redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign)
    else
        respond_to do |format|
        if @campaign.update_attributes!(params[:campaign])
          @campaign.update_attribute(:active, true)
          @campaign.send_deadline_update
          format.html { redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: t(:deadline_modified) }
        else
            format.html { render action: "choose_deadline" }
            format.json { render json: @campaign.errors, status: :unprocessable_entity }
        end
        end
    end
  end

  def close
    @campaign = Campaign.find(params[:campaign_id])
    if @campaign.active
      @campaign.update_attributes!( { deadline: Date.today(), active: false } )
      @campaign.send_campaign_closed
      redirect_to recruiter_campaign_path(@recruiter,@campaign), notice: t(:campaign_closed)
    else
      redirect_to recruiter_campaign_path(@recruiter,@campaign), notice: t(:campaign_already_closed)
    end
  end

   def enter_candidates
    @campaign = Campaign.find(params[:campaign_id])
    if @campaign.active
      render 'enter_candidates'
    else
      redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: t(:enter_candidates_error)
    end
  end

  def enter_more_candidates
    @campaign = Campaign.find(params[:campaign_id])
    if @campaign.active
      render 'enter_more_candidates'
    else
      redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: t(:enter_candidates_error)
    end
  end

  def update_recommend_friends
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.switch_recommend_friends
    redirect_to recruiter_campaign_path(@recruiter, @campaign)
  end

  def update_candidate_references
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.switch_candidate_references
    redirect_to recruiter_campaign_path(@recruiter, @campaign)
  end

  def update_receive_applications
    @campaign = Campaign.find(params[:campaign_id])
    @campaign.switch_receive_apps
    redirect_to recruiter_campaign_path(@recruiter,@campaign)
  end

end
