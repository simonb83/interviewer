#encoding: utf-8
class CampaignQuestionsController < ApplicationController

  load_and_authorize_resource except: [:get_campaign, :get_drop_down_options]

#Get the current campaign
  before_filter :get_campaign, except: 'get_drop_down_options'

  def get_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  #Enable recruiter to choose questions for campaign

  def  new
    @campaign_question = CampaignQuestion.new(campaign_id: @campaign.id)
  end

  def create
    @campaign_question = CampaignQuestion.new(params[:campaign_question])
    if @campaign_question.save
        redirect_to @recruiter, notice: t(:question_added)
    else
        render action: "new"
    end
  end

  def choose_verbal_questions
    @max_questions = @recruiter.max_voice_questions
  end

  def remove_question
    session[:return_to] = request.referer
    @campaign_question = CampaignQuestion.where("campaign_id = ? AND question_id = ?",@campaign.id, params[:question_id]).first
    @campaign_question.destroy
    @question = Question.find(params[:question_id])
    @question.destroy if @question.kind == 'filter'
    redirect_to session.delete(:return_to)
  end

  #Cycle through hash of question_ids and create corresponding campaign_questions for assigning questions to campaigns
  def create_text_questions
    if params[:commit] == t(:skip)
      redirect_to campaign_choose_verbal_questions_path(@campaign)
    else
      question_ids = params[:Integer]
      question_ids.each_value do |v|
      u = v.to_i
      CampaignQuestion.create(campaign_id: @campaign.id, question_id: u) if u > 0 && Question.find(u).text?
      end
      redirect_to campaign_choose_verbal_questions_path(@campaign), notice: t(:written_questions_added)
    end

  end

  def create_verbal_questions
    question_ids = params[:Integer]
    check_array = question_ids.values
    check_array.delete("")
    if check_array.size > 0
      # flash[:notice] = t(:step3_error)
      # render 'choose_verbal_questions'
      question_ids.each_value do |v|
        u = v.to_i
        CampaignQuestion.create(campaign_id: @campaign.id, question_id: u) if u > 0 && Question.find(u).verbal?
      end
    end
    redirect_to campaign_question_confirmation_path(@campaign), notice: t(:verbal_questions_added)
  end

  def question_confirmation
    @filter_questions = @campaign.filter_questions
  end

  #Update questions in view based on the category chosen by the user
  def get_drop_down_options
  val = params[:category_id]
  q_type = params[:question_type]
  @questions = Question.where('category_id = ? and kind = ?', val, q_type)
  response = Hash.new
  options = @questions.collect{|x| response[x.id] = x.content}
  render json: response.to_json
  end

  def edit_text_questions
    session[:return_to_principal] = params[:request_path]
    @questions = @campaign.questions.text
    render :edit_questions
  end

  def edit_verbal_questions
    session[:return_to_principal] = params[:request_path]
    @questions = @campaign.questions.verbal
    render :edit_questions
  end

  def add_question
    @question = Question.find(params[:question_id])
    if @question.kind == "text"
      @campaign_question = CampaignQuestion.new(campaign_id: @campaign.id, question_id: @question.id)
      respond_to do |format|
        if @campaign_question.save
          format.json { render :json => @question, status: 200 }
        else
          format.json { render :json => @campaign_question.errors, :status => 500 }
        end
      end
    elsif @question.kind == "verbal" && @campaign.questions.verbal.count < @recruiter.max_voice_questions
      @campaign_question = CampaignQuestion.new(campaign_id: @campaign.id, question_id: @question.id)
      respond_to do |format|
        if @campaign_question.save
          format.json { render :json => @question, status: 200 }
        else
          format.json { render :json => @campaign_question.errors, :status => 500 }
        end
      end
    else
      respond_to do |format|
        format.json { render :json => {max_questions_error: "Ya has alcanzado el límite de preguntas de voz permitidas para tu cuenta."}, :status => 500 }
      end
    end
  end

  def show_questions
    @created = true
    @recruiter = @campaign.recruiter if @admin
    @filter_questions = @campaign.filter_questions
    render :question_confirmation
  end

end
