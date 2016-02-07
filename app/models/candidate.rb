# encoding: utf-8
class Candidate < ActiveRecord::Base

  include AdminTools

  #Candidates belong to  campaigns
  belongs_to :campaign
  belongs_to :organization
  has_many :answers
  has_many  :friends
  has_many :calls
  has_many :references
  has_one :profile
  validates :email, :uniqueness => { scope: :campaign_id }
  validate :do_not_exceed_allowed_candidates

  attr_accessible :campaign_id, :email, :phone_number, :name, :surname, :privacy_consent, :completed_text_interview, :completed_verbal_interview, :organization_id, :cel, :accepted, :rejected, :profile_attributes, :completed_filter_interview

  accepts_nested_attributes_for :profile

  #Callback to add uid after create
  before_create :set_org_id
  after_create :create_uid, :send_invite, :increment_candidates
  after_destroy :decrement_candidates

  scope :completed_interview, where(completed_interview: true)
  scope :not_completed_interview, where(completed_interview: false)
  scope :pending, where(accepted: false, rejected: false)
  scope :accepted, where(accepted: true)
  scope :rejected, where(rejected: true)

  def save(*args)
    if self.completed_interview
    elsif self.completed_text_interview && self.completed_verbal_interview && self.completed_filter_interview
      self.completed_interview = true
      self.interview_completed_at = Time.now
      CandidateMailer.completed(self).deliver
    else
      self.completed_interview = false
    end
    super(*args)
  end

  def to_s
    "#{name} #{surname}"
  end

  def candidate_name
    if self.profile
      self.profile.to_s
    elsif self.name
      self.to_s
    else
      ""
    end  
  end

  def first_name
    if self.profile
      "#{self.profile.name}"
    elsif self.name
      "#{self.name}"
    else
      ""
    end
  end

  def pending?
    return true if self.accepted == false && self.rejected == false
  end

  def create_uid
    uid = (self.campaign.position_name[0,2] + self.email[0,2] + self.id.to_s).upcase
    self.update_attribute(:uid, uid)
  end

  def set_org_id
    self.organization_id = self.campaign.recruiter.organization.id
  end

  def send_invite
    CandidateMailer.invitation(self).deliver
  end

  def position_name
    self.campaign.position_name
  end

  def company_name
    if self.campaign.company_name
      self.campaign.company_name
    else
      self.organization.name
    end
  end

  def deadline
    self.campaign.deadline
  end

  def verbal_question_ids
    self.campaign.questions.verbal.collect{|q| q.id}
  end

  def recommended_friends?
    if self.recommended_friends.nil? && self.campaign.recommend_friends
      false
    else
      true
    end
  end

  def provided_references?
    if self.campaign.candidate_references && self.references.count == 0
      false
    else
      true
    end
  end

  def started?
    true if self.privacy_consent
  end

  def interview_status
    if self.completed_interview
      'candidate_completed_interview'
    elsif self.campaign.closed?
      'candidate_interview_closed'
    else
      'candidate_start_interview'
    end
  end


  def interview_stage
    if self.completed_interview && self.provided_references? && self.recommended_friends?
      6
    elsif self.completed_interview && self.provided_references?
      5
    elsif self.completed_interview
      4
    elsif self.completed_text_interview && self.completed_filter_interview
      3
    elsif self.completed_filter_interview
      2
    else
      1
    end
  end

  #Send mails to all pending candidates when campaign is closed
  def self.deadline_passed_mails(campaign)
    campaign.candidates.not_completed_interview.each do |candidate|
      CandidateMailer.deadline_passed(candidate).deliver
    end
  end

  #Send mails to all pending candidates when campaign is re-opened
  def self.reopened_mails(campaign)
    campaign.candidates.not_completed_interview.each do |candidate|
      CandidateMailer.reopened(candidate).deliver
    end
  end

   #Send mails to all pending candidates when two days to go til deadline
  def self.send_pending_emails(campaign)
    campaign.candidates.not_completed_interview.each do |candidate|
      CandidateMailer.reminder(candidate).deliver
    end
  end

  def history
    Candidate.where("email = ? and organization_id = ?", self.email, self.organization_id).reject{|c| c.id == self.id}
  end

  def interview_history_detail
    if self.interview_completed_at
      @d = self.interview_completed_at
      date_completed = "#{@d.day}-#{@d.month}-#{@d.year}"
    else
      date_completed = "Entrevista no completada"
    end

    if self.accepted
      status = "Aceptado"
    elsif self.rejected
      status = "Rechazado"
    else
      status = "Pendiente"
    end
    "#{self.company_name}, #{self.position_name}, #{date_completed}, #{status}"
  end

  def valid_cel?
    true if self.cel && self.cel.length == 10
  end

  private
  def increment_candidates
    self.campaign.recruiter.organization.organization_account.add_candidate
  end

  def decrement_candidates
    self.campaign.recruiter.organization.organization_account.remove_candidate unless self.privacy_consent
  end

  def do_not_exceed_allowed_candidates
    current_candidates = self.campaign.recruiter.organization.organization_account.current_candidates
    allowed_candidates = self.campaign.recruiter.organization.account.included_candidates + self.campaign.recruiter.organization.organization_account.additional_candidates
    if current_candidates == allowed_candidates
      errors.add(:base, "Se ha pasado el número máximo de Candidatos para tu cuenta. Ver aquí para saber como agregar mas Candidatos.")
    end
  end

end
