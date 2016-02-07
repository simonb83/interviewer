class EmailProcessor

  def self.process(email)

    #Save a copy of the email
    AdminMailer.save_candidates(email).deliver

    #Parse the subject line to find the Interview ID
    subject = email.subject
    uid = subject[/#([^\s]*)/,1]

    #If there is a valid ID, try and find the interview
    if uid
      candidate_email = email.from
      @campaign = Campaign.find_by_uid(uid)

      #If the interview exists and is set to receive apps, then add the candidate
      if @campaign && @campaign.receive_applications
        begin
          @campaign.candidates.create!(email: candidate_email)

          #Forward the application to the recruiter, if the option is set
          AdminMailer.candidate_forward(@campaign,email).deliver if @campaign.forward_applications

        #If the record is invalid (i.e. the candidate already exists) then send message to candidate
        rescue ActiveRecord::RecordInvalid
          AdminMailer.candidate_already_exists(email).deliver
        end

      #Else if the interview exists but is not set to receive apps then send error message to candidate
      elsif @campaign
        AdminMailer.receive_application_error(email).deliver

      #Otherwise if interview does not exist, create an issue for manual review
      else
        string = email.from + '\n' + email.subject + '\n' + email.body
        Issue.create(category: "system", content: string, email: "system")
      end

    #If there is not a valid ID, then create an issue for review by the admin
    else
      string = email.from + '\n' + email.subject + '\n' + email.body
      Issue.create(category: "system", content: string, email: "system")
    end
  end

end
