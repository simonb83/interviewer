class RecruiterNotifierController < ApplicationController

  def preview_shared_internal()
    @sender = Recruiter.find(1)
    @recipient = Recruiter.find(2)
    render :file => 'recruiter_notifier/shared_internal.html.erb'
  end

  def preview_shared_external()
    @sender = Recruiter.find(1)
    @candidate = Candidate.find(1)
    recipient = "simon.bedford@gmail.com"
    render :file => 'recruiter_notifier/shared_external.html.erb'
  end

end