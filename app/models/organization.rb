class Organization < ActiveRecord::Base

  include AdminTools

  #set up has many relationship for recruiters
  has_many :recruiters
  has_many :candidates
  has_one :organization_account
  has_one :account, through: :organization_account

  #set up accessible attributes
  attr_accessor :account_id
  attr_accessible :name, :account_id, :active

  after_create :create_account

  private
  def create_account
    OrganizationAccount.create(organization_id: self.id, account_id: self.account_id)
  end

end
