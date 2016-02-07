# coding: utf-8

class AdminMailer < ActionMailer::Base
  default from: "contact@ampleo.mx"

  def new_issue(issue)
    @issue = issue
    mail to: "contact@ampleo.mx", subject: "New issue #{@issue.id}"
  end

  def issue_confirm(issue)
    @issue = issue
    mail to: issue.email, subject: "Ticket ID: #{issue.id}"
  end

  def issue_closed(issue)
    @issue = issue
    mail to: issue.email, subject: "Ticket ID: #{issue.id} ha sido cerrado"
  end

  def candidate_forward(campaign,email)
    @campaign = campaign
    email.attachments.each do |attachment|
      attachments[attachment.original_filename] = attachment.read
    end
    mail to: campaign.recruiter.email, from: email.from, body: email.body, subject: email.subject
  end

  def save_candidates(email)
    email.attachments.each do |attachment|
      attachments[attachment.original_filename] = attachment.read
    end
    mail to: "candidates@ampleo.mx", from: email.from, body: email.body, subject: email.subject
  end

  def receive_application_error(email)
    mail to: email.from, subject: "RE: #{email.subject}"
  end

  def candidate_already_exists(email)
    mail to: email.from, subject: "RE: #{email.subject}"
  end

end
