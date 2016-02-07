# Model for Recruiter implementation

class Recruiter < ActiveRecord::Base

  include AdminTools
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :organization_id, :organization

  #Recruiter belongs to an organization and has many campaigns and messages
  belongs_to :organization
  has_many :campaigns, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :message_recipients, dependent: :destroy

  after_create :increment_users
  after_destroy :decrement_users

  validate :do_not_exceed_max_users

  def related_recruiters
    self.organization.recruiters.where("id != ?", self.id)
  end

  def received_messages
    self.message_recipients
  end

  def candidates
    self.campaigns.collect{ |c| c.candidates }.flatten
  end

  def active?
    if self.organization.active == true
      true
    elsif self.organization.active == false
      false
    end
  end

  def used_candidates
    self.organization.organization_account.current_candidates
  end

  def remaining_candidates
    self.organization.account.included_candidates+self.organization.organization_account.additional_candidates-self.used_candidates
  end

  def max_voice_questions
    self.organization.account.voice_questions
  end

  private
  def increment_users
    self.organization.organization_account.add_user
  end

  def decrement_users
    self.organization.organization_account.remove_user
  end

  def do_not_exceed_max_users
    current_users = self.organization.organization_account.current_users
    max_users = self.organization.account.max_users
    if current_users == max_users
      errors.add(:base, "max users already taken (#{max_users})")
    end
  end

end
