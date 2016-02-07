# encoding: utf-8
class DateValidator < ActiveModel::Validator
  def validate(record)
    date = record.deadline
    if date < Date.today
      record.errors[:deadline] << "no puede haber pasado"
    end
  end
end


class Campaign < ActiveRecord::Base

  include AdminTools

  #campaigns belong to one recruiter and has many questions through CampaignQuestions
  #and has many candidates
  belongs_to :recruiter
  has_many :campaign_questions, dependent: :destroy
  has_many :questions, through: :campaign_questions
  has_many :candidates, dependent: :destroy

  attr_accessible :deadline, :recruiter_id, :recommend_friends, :candidate_references, :position_name, :active, :receive_applications, :forward_applications, :company_name, :gateway, :min_age, :max_age, :gender, :max_salary, :civil_status

  #Callback to add uid after create
  before_save :check_filter_attributes
  after_create :create_uid

  scope :active, where(active: true)
  scope :closed, where(active: false)

  validates :position_name, presence: true
  validates :deadline, presence: true
  validates_with DateValidator, fields: :deadline

  CORE_FILTER_ATTRIBUTES = [:min_age, :max_age, :gender, :max_salary, :civil_status]

  #Method to return Active when status active is true, Closed otherwise
  def status
    if self.active == true
      "activo"
    else
      "cerrado"
    end
  end

  def closed?
    true unless self.active
  end

  #Method to assign unique 6-digit id to campaigns
  def create_uid
    self.uid = (self.recruiter.organization.name[0,2] + self.position_name[0,2] + self.id.to_s).gsub(/\s/,"").upcase
    self.save
  end

#Method to combine uid and position name for display purposes
def combined_display
  "#{self.uid} - #{self.position_name}"
end

#Once a day, check campaigns and close active ones where deadline has passed
def self.close_deadline_past_campaigns
  self.active.each do |campaign|
    if campaign.deadline.past?
      campaign.update_attribute(:active, false)
      Candidate.deadline_passed_mails(campaign)
    end
  end
end

#Once a day, select all campaign with exactyle 2 days until deadline and send pending emails to candidates
def self.select_soon_to_close_campaigns
  self.active.each do |campaign|
    if campaign.two_days_to_go
      Candidate.send_pending_emails(campaign)
    end
  end
end

def switch_recommend_friends
  if self.recommend_friends == true
    self.update_attribute(:recommend_friends, false)
  else
    self.update_attribute(:recommend_friends, true)
  end
end

def switch_candidate_references
  if self.candidate_references == true
    self.update_attribute(:candidate_references, false)
  else
    self.update_attribute(:candidate_references, true)
  end
end

def switch_receive_apps
  if self.receive_applications == true
    self.update_attribute(:receive_applications, false)
  else
    self.update_attribute(:receive_applications, true)
  end
end

#If campaign has exactly two days until deadline, return true
def two_days_to_go
  today = Date.today()
  if self.deadline.mjd - today.mjd == 2
      true
  end
end

#Send emails to pending candidates when campaign status is updated
def send_deadline_update
  Candidate.reopened_mails(self)
end

#Send emails to pending candidates when campaign is closed
def send_campaign_closed
  Candidate.deadline_passed_mails(self)
end

def check_filter_attributes
  attributes = CORE_FILTER_ATTRIBUTES
  attributes.each do |attr|
    self.send(:attributes=, {attr => nil}) if self.read_attribute(attr) == ""
  end
end

def filter_questions
  questions = []
  questions << ["Edad del candidato", "#{self.min_age} - #{self.max_age}"] if self.min_age || self.max_age
  questions << ["Género del candidato", self.gender] if self.gender
  questions << ["Sueldo mínimo esperado por el candidato", "< $#{self.max_salary}"] if self.max_salary
  questions << ["Estado civil del candidato", self.civil_status] if self.civil_status
  self.questions.filter.each do |q|
    if q.required_option(self)
      option = "Sí"
    else
      option = "No"
    end
    questions << [q.content, option]
  end
  return questions
end

#Process hash of candidate email addresses and create corresponding candidates
def process_candidates(list)
    array = list.strip.gsub(/\r\n?/, ", ").split(/\s*,\s*/)
    non_unique = []
    i = 0
    array.each do |email|
      begin
      Candidate.create!(campaign_id: self.id, email: email )
      i += 1
      # CandidateMailer.invitation(@candidate).deliver
      self.increment(:sent_invitations)
      self.save
      rescue ActiveRecord::RecordInvalid => e
        if e.message.include?("Se ha pasado el número máximo de Candidatos")
          return array.size, i, non_unique, true
        else
          non_unique << email
          next
        end
      end
    end
    return array.size, i, non_unique
  end

end


