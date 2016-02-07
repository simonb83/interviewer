class OrganizationAccount < ActiveRecord::Base

  include AdminTools

  belongs_to :organization
  belongs_to :account

  attr_accessible :account_id, :anniversary_day, :anniversary_month, :anniversary_year, :current_candidates, :current_users, :organization_id, :additional_candidates

  after_create :set_anniversary

  validates_uniqueness_of :organization_id

  def set_anniversary
    date_created = self.created_at
    self.update_attributes(anniversary_day: date_created.day, anniversary_month: date_created.month, anniversary_year: date_created.year)
  end

  def add_user
    self.update_attributes(current_users: self.current_users+1)
  end

  def remove_user
    self.update_attributes(current_users: self.current_users-1)
  end

  def add_candidate
    self.update_attributes(current_candidates: self.current_candidates+1)
  end

  def remove_candidate
    self.update_attributes(current_candidates: self.current_candidates-1)
  end

end
