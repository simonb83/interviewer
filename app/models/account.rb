class Account < ActiveRecord::Base

  include AdminTools

  validates_uniqueness_of :internal_id
  validates :period, :inclusion => { :in => %w(payg monthly annual),
    :message => "%{value} is not a valid period" }

  attr_accessible :candidate_price, :included_candidates, :internal_id, :max_users, :monthly_price, :name, :period, :voice_questions

  has_many :organization_accounts
end
