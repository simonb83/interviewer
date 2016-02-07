class MessagesController < ApplicationController

  load_and_authorize_resource except: :get_recruiter

#Get the current recruiter before dealing with messages
before_filter :get_recruiter

def get_recruiter
  @recruiter = Recruiter.find(params[:recruiter_id])
end

def send_message
  @candidate = Candidate.find(params[:candidate_id])
  freeform = params[:message][:freeform].strip
  array = params[:message][:array]

  if freeform == "" && array.size == 1
    flash[:notice] = t(:no_recipients_error)
    render 'candidates/share'
  else
    @message = Message.create(recruiter_id: @recruiter.id, interview_id: @candidate.uid, sender_name: @recruiter.name)

    if freeform != ""
      @message.message_recipients.create(email: freeform)
      RecruiterNotifier.shared_external(@recruiter, freeform, @candidate).deliver
    end
    array.each do |ele|
      id = ele.to_i
      if id > 0
        @recipient = Recruiter.find(ele)
        @message.message_recipients.create(recruiter_id: ele)
        RecruiterNotifier.shared_internal(@recruiter, @recipient).deliver
      end
    end
    redirect_to campaign_candidate_path(@candidate.campaign, @candidate), notice: "
    El candidato fue compartido exitosamente con #{help.pluralize(@message.message_recipients.count, 'destinario')}."
  end #If, else, end
end #Definition

def destroy
  @message = Message.find(params[:id])
  @message.destroy

  redirect_to @recruiter
end

end
