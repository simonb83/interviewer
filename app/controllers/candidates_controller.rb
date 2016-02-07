# encoding: utf-8
class CandidatesController < ApplicationController

  load_and_authorize_resource except: [:get_campaign, :get_candidate, :candidate_start_interview, :interview_step_2, :start_text_interview, :start_voice_interview, :add_phone, :complete_voice_interview, :next_stage, :interview_confirmation, :interview_in_progress, :provide_references, :filter_questions]

  before_filter :get_campaign, only: [:show, :destroy, :enter_candidates, :enter_more_candidates, :add_candidates, :add_more_candidates, :accept, :reject]

  before_filter :get_candidate, except:[:show, :destroy, :enter_candidates, :enter_more_candidates, :add_candidates, :add_more_candidates, :candidate_start_interview]

  def get_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def get_candidate
    @candidate = Candidate.find(params[:candidate_id])
  end

  def show
    @recruiter = @campaign.recruiter
    @candidate = Candidate.find(params[:id])
    @history = @candidate.history
  end

  def destroy
    @recruiter = @campaign.recruiter
    @candidate = Candidate.find(params[:id])
    @candidate.destroy
    redirect_to recruiter_campaign_path(@recruiter,@campaign), notice: t(:candidate_deleted)
  end

  def add_candidates
    list = params[:Campaign][:candidate_list]
    m, n, non_unique, candidates_exceeded = @campaign.process_candidates(list)
    if candidates_exceeded && non_unique.size == 0
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista. Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos."
    elsif candidates_exceeded && non_unique.size > 0
      @dups = "["+non_unique.join(", ")+"]"
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista.#{' Los siguientes candidatos no son únicos: '+@dups if n < m}. Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos."
    else
      @dups = "["+non_unique.join(", ")+"]"
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista.#{' Los siguientes candidatos no son únicos: '+@dups if n < m}"
    end
  end

  def add_more_candidates
    list = params[:Campaign][:candidate_list]
    m, n, non_unique, candidates_exceeded = @campaign.process_candidates(list)
    if candidates_exceeded && non_unique.size == 0
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista. <br/><br />Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.".html_safe
    elsif candidates_exceeded && non_unique.size > 0
      @dups = "["+non_unique.join(", ")+"]"
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista.#{' Los siguientes candidatos no son únicos: '+@dups if n < m}. <br/><br />Se ha pasado el número máximo de Candidatos permitidos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.".html_safe
    else
      @dups = "["+non_unique.join(", ")+"]"
      redirect_to recruiter_campaign_path(@campaign.recruiter, @campaign), notice: "#{n} de #{m} candidatos fueron invitados a participar en esta entrevista.#{' Los siguientes candidatos no son únicos: '+@dups if n < m}"
    end
  end

  def accept
      if @candidate.rejected
        redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: "El candidato con email #{@candidate.email} ya se encuentra rechazado."
      else
        @candidate.update_attribute(:accepted, true)
        CandidateMailer.accepted(@candidate).deliver
          redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: "El candidato con email #{@candidate.email} fue aceptado exitosamente."
      end
  end

  def reject
      if @candidate.accepted
        redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: "El candidato con email #{@candidate.email} ya se encuentra aceptado."
      else
        @candidate.update_attribute(:rejected, true)
        CandidateMailer.rejected(@candidate).deliver
          redirect_to recruiter_campaign_path(@campaign.recruiter,@campaign), notice: "El candidato con email #{@candidate.email} fue rechazado exitosamente."
      end
  end

  def update_email
    @candidate.email = params[:candidate][:email]
    respond_to do |format|
      if @candidate.save
        format.html{
        redirect_to campaign_candidate_path(@candidate.campaign,@candidate), notice: t(:updated_email)}
      else
        format.html{ render action: "email_edit" }
        format.json{ render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def share
    redirect_to campaign_candidate_path(@candidate.campaign,@candidate), notice: t(:not_completed_interview) unless @candidate.completed_interview
  end

  def candidate_start_interview
    @candidate = Candidate.find_by_uid(params[:interview_id])
    @profile = @candidate.build_profile
    render @candidate.interview_status
  end

  def interview_step_2
    # @candidate.attributes = params[:candidate]
    # session[:return_to] ||= request.url
    # if params[:candidate][:name] == "" || params[:candidate][:surname] == ""
    #   flash[:error] = t(:enter_full_name)
    #   render :candidate_start_interview
    @profile = @candidate.build_profile(params[:candidate][:profile_attributes])
    if !@profile.valid? || params[:candidate][:privacy_consent] == "0"

      @profile.errors.each {|error, error_message| @candidate.errors.add error, error_message}
      
      @candidate.errors.add(:privacy_consent, t(:privacy_error)) if params[:candidate][:privacy_consent] == "0"
      
      respond_to do |format|
        format.html{ render action: "candidate_start_interview" }
        format.json{ render json: @candidate.errors, status: :unprocessable_entity }
      end

    else
      
      @candidate.update_attributes(params[:candidate])
      
      if @candidate.campaign.questions.text.count == 0
        @candidate.update_attribute(:completed_text_interview, true)
      end
      
      redirect_to candidate_next_stage_path(@candidate)

    end

    # if params[:candidate][:privacy_consent] == "0"
    #   @candidate.errors.add(:privacy_consent, t(:privacy_error))
    #   respond_to do |format|
    #     format.html{ render action: "candidate_start_interview" }
    #     format.json{ render json: @candidate.errors, status: :unprocessable_entity }
    #   end
    #   # flash[:error] = t(:privacy_error)
    #   # render :candidate_start_interview
    # else
    #   @candidate.update_attributes(params[:candidate])
    #   @profile = @candidate.build_profile(params[:candidate][:profile_attributes])
    #   if @profile.save
    #     if @candidate.campaign.questions.text.count == 0
    #       @candidate.update_attribute(:completed_text_interview, true)
    #     end
    #     redirect_to candidate_next_stage_path(@candidate)
    #   else
    #     respond_to do |format|
    #       format.html{ render action: "candidate_start_interview" }
    #       format.json{ render json: @profile.errors, status: :unprocessable_entity }
    #     end
    #   end
    # end
  end

  def start_text_interview
    raise CanCan::AccessDenied.new() unless @candidate.started?
    redirect_to candidate_next_stage_path(@candidate) if @candidate.completed_text_interview
  end

  def start_voice_interview
    raise CanCan::AccessDenied.new() unless @candidate.started?
    redirect_to candidate_next_stage_path(@candidate) if @candidate.completed_verbal_interview || !@candidate.completed_text_interview
    @campaign = @candidate.campaign
  end

  def filter_questions
    raise CanCan::AccessDenied.new() unless @candidate.started?
    @candidate.update_attributes(completed_filter_interview: true) if @candidate.campaign.questions.filter .count == 0
    redirect_to candidate_next_stage_path(@candidate) if @candidate.completed_filter_interview
  end

  def add_phone
    respond_to do |format|
      number = params[:candidate][:phone_number]
      if @candidate.completed_verbal_interview
        redirect_to candidate_next_stage_path(@candidate)
      elsif @candidate.valid_cel? && number == ""
        @campaign = @candidate.campaign
        phone = '+521' + @candidate.cel
        format.html { redirect_to candidate_set_up_path(@candidate, number: phone) }
        format.json { head :no_content }
      else
        @campaign = @candidate.campaign
        if number.size != 10
          format.html {
            flash[:alert] = t(:ten_digit_error)
            render action: "start_voice_interview"}
          format.json { render json: @candidate.errors, status: :unprocessable_entity }
        elsif number.match(/^1/)
          format.html {
            flash[:alert] = t(:start_with_1_error)
            render action: "start_voice_interview"}
          format.json { render json: @candidate.errors, status: :unprocessable_entity }
        elsif number.match(/\D/)
          format.html {
            flash[:alert] = t(:non_numeric_error)
            render action: "start_voice_interview"}
          format.json { render json: @candidate.errors, status: :unprocessable_entity }
        else
          phone = '+52' + number
          @candidate.update_attributes(params[:candidate])
          format.html { redirect_to candidate_set_up_path(@candidate, number: phone) }
          format.json { head :no_content }
        end
      end
    end
  end

  def complete_voice_interview
    @campaign = @candidate.campaign

    if @candidate.completed_verbal_interview
      redirect_to candidate_next_stage_path(@candidate)
    else
      flash[:alert] = t(:complete_voice_interview_error)
      render action: "interview_in_progress"
    end
  end

  def shared_external
    @campaign = @candidate.campaign
  end

  #At each stage of interview, redirect candidate to the next stage
   def next_stage
    case @candidate.interview_stage
        when 1
          redirect_to candidate_filter_questions_path(@candidate)
        when 2
          redirect_to candidate_start_text_interview_path(@candidate)
        when 3
          redirect_to candidate_start_voice_interview_path(@candidate)
        when 4
          redirect_to candidate_provide_references_path(@candidate)
        when 5
          redirect_to candidate_recommend_friends_path(@candidate)
        when 6
          redirect_to candidate_interview_confirmation_path(@candidate)
    end
  end

  #Share candidate
  def share
  @candidate = Candidate.find(params[:candidate_id])
  redirect_to campaign_candidate_path(@candidate.campaign, @candidate), notice: t(:share_error) unless @candidate.completed_interview
  end

  def provide_references
    raise CanCan::AccessDenied.new() unless @candidate.started?
    # @candidate = Candidate.find(params[:candidate_id])
    redirect_to candidate_next_stage_path(@candidate) if @candidate.references.count == 2 || !@candidate.completed_interview
  end

end
