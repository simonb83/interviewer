class Reference < ActiveRecord::Base

  validates_presence_of :name, :email, :relationship

  belongs_to :candidate

  attr_accessible :name, :email, :relationship
end
