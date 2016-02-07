class Message < ActiveRecord::Base

  #Message belongs to Recruiter
  belongs_to :recruiter
  has_many :message_recipients, dependent: :destroy

  attr_accessible :recruiter_id, :interview_id, :sender_name

  def message_candidate
    Candidate.where("uid = ?", self.interview_id).first
  end

  def sent_to_recruiter(recruiter)
    recipients = self.message_recipients.collect{ |m| m.recruiter_id }
    true if recipients.include?(recruiter.id)
  end

end
