class AdminNotifierController < ApplicationController

  def preview_new_issue()
    @issue = Issue.find(1)
    render :file => 'admin_mailer/new_issue.html.erb'
  end

  def preview_issue_confirm()
    @issue = Issue.find(1)
    render :file => 'admin_mailer/issue_confirm.html.erb'
  end

  def preview_issue_closed()
    @issue = Issue.find(1)
    render :file => 'admin_mailer/issue_closed.html.erb'
  end

  def preview_candidate_already_exists()
    render :file => 'admin_mailer/candidate_already_exists'
  end

end