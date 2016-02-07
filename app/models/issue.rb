class Issue < ActiveRecord::Base

  validates_presence_of :email
  validates_inclusion_of :category, :in => %w( candidate recruiter other system)
  validates_presence_of :interview_id, :if => lambda {self.category == "candidate"}

  attr_accessible :category, :recruiter_id, :email, :name, :interview_id, :content, :section, :recruiter_type, :campaign_id

  after_create :send_emails

  def get_template
    if self.category == "candidate"
      "candidate_issue_show"
    elsif self.category == "recruiter"
      "recruiter_issue_show"
    else
      "issue_show"
    end
  end

  def switch_status
    if self.active
      self.update_attribute(:active, false)
      AdminMailer.issue_closed(self).deliver
    else
      self.update_attribute(:active, true)
    end
  end

  def send_emails
    AdminMailer.new_issue(self).deliver
    AdminMailer.issue_confirm(self).deliver unless self.category == "system"
  end

end
