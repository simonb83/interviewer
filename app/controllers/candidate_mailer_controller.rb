class CandidateMailerController < ApplicationController

  def get_candidate
    @candidate = Candidate.last
  end

  #Preview invitation

  def preview_invite()
    get_candidate
    render :file => 'candidate_mailer/invitation.html.erb'
  end

  def preview_accepted()
    get_candidate
    render :file => 'candidate_mailer/accepted.html.erb'
  end

  def preview_completed()
    get_candidate
    render :file => 'candidate_mailer/completed.html.erb'
  end

  def preview_passed_deadline()
    get_candidate
    render :file => 'candidate_mailer/deadline_passed.html.erb'
  end

  def preview_rejected()
    get_candidate
    render :file => 'candidate_mailer/rejected.html.erb'
  end

  def preview_reminder()
    get_candidate
    render :file => 'candidate_mailer/reminder.html.erb'
  end

  def preview_reopened()
    get_candidate
    render :file => 'candidate_mailer/reopened.html.erb'
  end

end