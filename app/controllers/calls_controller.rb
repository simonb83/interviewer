# encoding: utf-8
class CallsController < ApplicationController

  load_and_authorize_resource

  protect_from_forgery except: ["begin", "close_greeting", "move_on", "call_callback"]

  before_filter :get_candidate

  def get_candidate
    @candidate = Candidate.find(params[:candidate_id])
  end

  #These are the credentials for Twilio account
  ACCOUNT_SID = 'SID'
  AUTH_TOKEN = 'TOKEN'

  # base URL of the application
  BASE_URL = 'https://interview.ampleo.mx/'

  # Outgoing Caller ID you have previously validated with Twilio
  FROM = 'Number'

  #Make an outgoing call to the candidate at the number they have provided
  def set_up

    #Don't make an outbound call if Candidate has already completed verbal interview
    if @candidate.completed_verbal_interview
      redirect_to candidate_complete_voice_interview_path(@candidate)
    else
      @twilio_account = Twilio::REST::Client.new(ACCOUNT_SID, AUTH_TOKEN).account
      data = {
        from:   FROM,
        to:   params[:number],
        url:  candidate_begin_url(@candidate, protocol: 'https'),
        method: 'get',
        statusCallback: candidate_call_callback_url(@candidate, protocol: 'https'),
        timeout: 10
      }
      begin
        #First, hangup any active calls for this candidate
        if @candidate.calls.find_last_by_status("in-progress")
          @candidate.calls.where("status = 'in-progress'").each do |call|
            @call = @twilio_account.calls.get(call.sid)
            @call.hangup
          end
        end
        @twilio_account.calls.create data
      rescue Twilio::REST::RequestError => bang
        @campaign = @candidate.campaign
        flash[:alert] = bang.message
        render 'candidates/start_voice_interview'
        return
      end
      render 'candidates/interview_in_progress'
    end
  end


  def call_error
    redirect_to candidate_start_voice_interview_path(@candidate), notice: "Por favor revisa tu número telefónico e intenta otra vez."
  end

  #If the phone is answered without error, welcome the candidate to the interview and then give them the option to repeat the instructions or proceed to the interview itself
  def begin
    Call.create(sid: params[:CallSid], status: params[:CallStatus], candidate_id: @candidate.id)
    @post_to = candidate_close_greeting_url(@candidate, protocol: 'https')
    response = Twilio::TwiML::Response.new do |r|
      r.Play BASE_URL+ActionController::Base.helpers.asset_path("instructions.mp3", version: 3)
      r.Gather action: @post_to, numDigits: 1 do |g|
        g.Play BASE_URL+ActionController::Base.helpers.asset_path("menu1.mp3", version: 3)
      end
    end.text
    render xml: response
  end

  #Get the input from the user via their keypad, and start the interview if they pressed 2 on their keypad
  def close_greeting
    if params['Digits'] == '2'
      redirect_to action: 'begin'
    elsif params['Digits'] == '1'
      ids = @candidate.verbal_question_ids
      redirect_to candidate_begin_questions_url(@candidate, list: ids, protocol: 'https')
    else
      @post_to = candidate_close_greeting_url(@candidate, protocol: 'https')
      response = Twilio::TwiML::Response.new do |r|
        r.Gather action: @post_to, numDigits: 1 do |g|
          g.Play BASE_URL+ActionController::Base.helpers.asset_path("menu1.mp3", version: 3)
        end
      end.text
      render xml: response
    end
  end

  def begin_questions
    #Retrieve the list of interview ids from the parameter
    list = params[:list]
    if params[:number]
      @number = params[:number].to_i
    else
      @number = 1
    end
    # list = ["11", "13", "15"]
    #Find the first question where a recording does not exist
    q_id = list.first
    if Answer.where(question_id: q_id, candidate_id: @candidate.id).first
      list.shift
      if list.size == 0
        redirect_to candidate_finalize_call_path(@candidate)
      else
        @number += 1
        redirect_to candidate_begin_questions_url(@candidate, list: list, number: @number, protocol: 'https')
      end
    else
      #Path for application to access after each question
      @post_to = candidate_move_on_url(@candidate, list: list, q_id: q_id, number: @number, protocol: 'https')
      response = Twilio::TwiML::Response.new do |r|
      r.Say("Pregunta #{@number}", language: 'es')
      #Play the question corresponding to the first id to the candidate
      r.Play BASE_URL+ActionController::Base.helpers.asset_path("q_#{q_id}.mp3", version: 2)
      # @question = Question.find(q_id)
      # r.Say(@question.content, language: 'es')
      #Play the intra-question instructions and get response from the keypad
      r.Play BASE_URL+ActionController::Base.helpers.asset_path("menu2.mp3", version: 3)
        r.Pause length: 15
        r.Record action: @post_to, finishOnKey: '1', maxLength: '540'
      end.text
      render xml: response
    end
  end

  def move_on
    #Retrieve the list of interview ids from the parameter
    list = params[:list]
    number = params[:number].to_i
    #Save answer
    begin
      @answer = @candidate.answers.create!(content: params[:RecordingUrl], question_id: params[:q_id].to_i)
      @answer.question_answers.create(question_id: params[:q_id].to_i)
    rescue ActiveRecord::RecordNotUnique
      nil
    rescue ActiveRecord::RecordNotSaved
      nil
    rescue ActiveRecord::RecordInvalid
      nil
    end
    #Remove the previous question from the list of question ids
    list.shift
    number += 1
    #Check if there are any questions left to be completed
    if list.size == 0
    #If no more questions, move on to finalizing interview
      redirect_to candidate_finalize_call_path(@candidate)
    else
      #Otherwise, go back to begin_questions action with the new reduced list
      redirect_to candidate_begin_questions_path(@candidate, list: list, number: number)
    end
  end

  #Once all questions have been answered, save interview details to candidate and update status of completed_verbal_interview, hangup the call and redirect the candidate back to the final stages of the interview
  def finalize_call
    callSid = params[:CallSid]
    called_number = params[:To]
    @candidate.update_attributes( call_sid: callSid, called_number: called_number, completed_verbal_interview: true )
    response = Twilio::TwiML::Response.new do |r|
      r.Play BASE_URL+ActionController::Base.helpers.asset_path("closing.mp3", version: 2)
      # r.Say("Muchas gracias. Ya terminó tu entrevista. Ya puedes dar clic en el botón de próximo en tu navegador.", language: 'es')
      r.Hangup
    end.text
    render xml: response
  end

  def call_callback
    Call.find_last_by_sid(params[:CallSid]).update_attribute(:status, params[:CallStatus]) if Call.find_last_by_sid(params[:CallSid])
    render nothing: true
  end

end
